Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0BGQem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 11:34:42 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51440 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab0BGQel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 11:34:41 -0500
Date: Sun, 7 Feb 2010 08:34:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100207163444.GA7434@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100201222511.GA12882@ZenIV.linux.org.uk> <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain> <20100201231847.GC12882@ZenIV.linux.org.uk> <20100202065341.GF6292@linux.vnet.ibm.com> <20100203024931.GA6307@linux.vnet.ibm.com> <alpine.LFD.2.00.1002040715570.3707@localhost.localdomain> <20100204160206.GG6676@linux.vnet.ibm.com> <alpine.LFD.2.00.1002040848330.3707@localhost.localdomain> <20100204173609.GE30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204173609.GE30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 05:36:09PM +0000, Al Viro wrote:
> On Thu, Feb 04, 2010 at 09:13:18AM -0800, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 4 Feb 2010, Paul E. McKenney wrote:
> > > 
> > > Ah, good point on the hash size.  And given that DNAME_INLINE_LEN_MIN
> > > is 40 characters on 32-bit systems and 32 characters on 64-bit systems,
> > > I agree that while a four-character increase might be nice, it cannot be
> > > said to be an emergency.
> > 
> > Well, what we _could_ do is to make the 'length' field be part of the name 
> > itself, and just keep the hash separate. The hash (and parenthood) is what 
> > we check most in the hot inner loop, and don't want to have any extra 
> > indirection (or cache misses) for. The name length we check only later, 
> > after we've done all other checks (and after we've gotten the spinlock, 
> > which is the big thing).
> > 
> > So qstr->len is _not_ performance critical in the same way that qstr->hash 
> > is.
> 
> We could also try to put the hash chain in that sucker, copy d_parent in
> there *and* put a pointer back to struct dentry in it.  Then the walk
> itself would go through those and we'd actually looked at the dentry
> only once - in the end of it.  Normally that thing would be just embedded
> into dentry, with ability to allocate separately.

Good point!!!

But wouldn't this also require that the permission bits
be in qstr as well, along with a flag indicating ACLs?

> That might deal with lockless lookups if we did it right, but delayed
> copying back into dentry and freeing of out-of-line copy (after d_move())
> would still cause all sorts of fun.
> 
> The thing is, we have places where ->d_name.name uses rely on "I hold
> i_mutex on parent, so this thing won't change or go away under me" and
> that's actually the majority of code using ->d_name.  All directory
> operations.
> 
> How about doing that delayed work just before dropping i_mutex on parent?
> There we definitely can sleep, etc., so if we have d_move mark dentry as
> "got out-of-line hash chain+name+hash+len+d_parent_copy, want to collapse
> it back into dentry" and do d_collapse_that_stuff(dentry) before the
> matching drop of i_mutex...

This sounds like a good way to solve the problem of successive renames
of the same file -- the second rename would be unable to acquire i_mutex
until after the d_collapse_that_stuff() completed, right?

> It would be one hell of a patch size, probably, but it seems that the rest
> of problems wouldn't be there...  All such out-of-line structs would be
> freed via RCU and never modified.  And inline ones would be modified only
> when
> 	a) everyone who looks at hash chains already sees out-of-line one
> 	b) i_mutex on parent is still held
> They'd get out-of-line one copied into them, replace it in hash chains
> and schedule freeing of out-of-line sucker.

And during the time that the dentry is switching from out-of-line to
inline, it can safely be referenced by both, so no need for fancy
hash-chain traversal tactics.

> The reason why I'm talking about copy of d_parent and not just taking the
> field over there: we avoid messing with dentry refcounting, etc. that way,
> assuming that this copy is never dereferenced (used only for comparisons
> during dcache lookups) and doesn't contribute to d_count.  Freeing dentries
> themselves would be also RCU-delayed, of course.
> 
> Comments?

Looks pretty good at first glance!

							Thanx, Paul
