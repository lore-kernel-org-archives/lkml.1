Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0BDKDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 05:03:02 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40082 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab0BDKC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 05:02:59 -0500
Date: Tue, 2 Feb 2010 18:49:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100203024931.GA6307@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100201222511.GA12882@ZenIV.linux.org.uk> <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain> <20100201231847.GC12882@ZenIV.linux.org.uk> <20100202065341.GF6292@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202065341.GF6292@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 10:53:41PM -0800, Paul E. McKenney wrote:
> On Mon, Feb 01, 2010 at 11:18:47PM +0000, Al Viro wrote:
> > On Mon, Feb 01, 2010 at 02:37:32PM -0800, Linus Torvalds wrote:
> > 
> > > > * don't use %pd under dentry->d_lock, use dentry->d_name.name instead; in
> > > > that case it *is* safe.  Incidentally, ->d_lock isn't held a lot.
> > > 
> > > I realize we can just call it a rule, and yes, d_lock is held much less 
> > > than something like console_lock etc that we've had ABBA issues with, but 
> > > still..
> > 
> > > Quite frankly, I'd _much_ rather see something like just always freeing 
> > > the dentry names (when they aren't inlined) using RCU. The VFS layer quite 
> > > possibly would want to do that anyway at some point (eg Nick's VFS 
> > > scalability patches), and then we could make it just a RCU read-lock or 
> > > whatever (interrupt disable, what-not) instead.
> > > 
> > > And I'm much happier with printk doing that kind of thing, and wouldn't 
> > > have issues with that kind of much weaker locking.
> > 
> > Ehh...  RCU will save you from stepping on freed memory, but it still will
> > leave the joy of half-updated string with length out of sync with it, etc.
> > We probably can get away with that, but we'll have to be a lot more careful
> > with the order of updating these suckers in d_move_locked et.al.
> > 
> > I don't know...  Note that if we end up adding something extra to struct
> > dentry, we might as well just add *another* spinlock, taken only under
> > ->d_lock and only in two places in dcache.c that change d_name.  That kind
> > of thing is trivial to enforce (just grep over the tree once in a while)
> > and if it shares the cacheline with d_lock, we shouldn't get any real overhead
> > in d_move()/d_materialise_unique().  I'm not particulary fond of that variant,
> > but it's at least guaranteed to be devoid of subtleties.
> > 
> > If RCU folks can come up with a sane suggestions that would be robust and
> > wouldn't bloat dentry - sure, I'm all for it.  If not...
> 
> Here is an approximation that might inspire someone to come up with a
> real solution.
> 
> One approach would be to store the name length with the name, so that
> struct qstr loses the "len" field, and so that its "name" field points
> to a struct that has a "len" field followed by an array of const
> unsigned char.  That way, the name and length are closely associated.
> When you pick up a struct qstr's "name" pointer, you are guaranteed to
> get a length that matches the name.
> 
> Unfortunately:
> 
> o	In theory, this leaves the length of the dentry unchanged, but
> 	alignment is a problem on 64-bit systems.  Also, the long names
> 	gain an extra four bytes.

And one fix for the alignment issue is to move the "hash" as well as the
"len" field to the struct containing the name.  The size of the dentry
remains unchanged, as these two fields smiply move from the d_name qstr
to the small-name d_iname array (which becomes a structure containing
a hash, length, and char array).  This approach guarantees that the
length, hash, and name are consistent.

One stupid question: why are the hash and length ints rather than shorts?
Doesn't the maximum filename length fit into a 16-bit short?  In fact,
doesn't the maximum length of a full pathname fit into a 16-bit short?

							Thanx, Paul

> o	If you get a pointer to the d_iname small-name field, rename
> 	might still change the name out from under you.  This could in
> 	theory be fixed by refusing to re-use the d_iname field until
> 	an RCU grace period had elapsed (using an external structure
> 	instead).  In practice, not sure if this is really a reasonable
> 	approach.
> 
> Thoughts?
> 
> 							Thanx, Paul
