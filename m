Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbYHKPW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbYHKPW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYHKPWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:22:18 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56051 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYHKPWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:22:17 -0400
Date: Mon, 11 Aug 2008 10:22:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
Message-ID: <20080811152201.GB25930@us.ibm.com>
References: <20080807224033.FFB3A2C1@kernel> <200808081146.54834.arnd@arndb.de> <1218221451.19082.36.camel@nimitz> <200808090013.41999.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808090013.41999.arnd@arndb.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arnd Bergmann (arnd@arndb.de):
> On Friday 08 August 2008, Dave Hansen wrote:
> > On Fri, 2008-08-08 at 11:46 +0200, Arnd Bergmann wrote:
> 
> > > > +struct cr_hdr_tail {
> > > > +	__u32 magic;
> > > > +	__u32 cksum[2];
> > > > +};
> > > 
> > > This structure has an odd multiple of 32-bit members, which means
> > > that if you put it into a larger structure that also contains
> > > 64-bit members, the larger structure may get different alignment
> > > on x86-32 and x86-64, which you might want to avoid.
> > > I can't tell if this is an actual problem here.
> > 
> > Can't we just declare all these things __packed__ and stop worrying
> > about aligning them all manually?
> 
> I personally dislike __packed__ because it makes it very easy to get
> suboptimal object code. If you either pad every structure to a multiple
> of 64 bits or avoid __u64 members, you don't have a problem. Also,
> I think avoiding implicit padding inside of data structures is very
> helpful for user interfaces, if necessary you can always add explicit
> padding.
> 
> > > get_fs()/set_fs() always feels a bit ouch, and this way you have
> > > to use __force to avoid the warnings about __user pointer casts
> > > in sparse.
> > > I wonder if you can use splice_read/splice_write to get around
> > > this problem.
> > 
> > I have to wonder if this is just a symptom of us trying to do this the
> > wrong way.  We're trying to talk the kernel into writing internal gunk
> > into a FD.  You're right, it is like a splice where one end of the pipe
> > is in the kernel.
> > 
> > Any thoughts on a better way to do this?  
> 
> Maybe you can invert the logic and let the new syscalls create a file
> descriptor, and then have user space read or splice the checkpoint
> data from it, and restore it by writing to the file descriptor.
> It's probably easy to do using anon_inode_getfd() and would solve this
> problem, but at the same time make checkpointing the current thread
> hard if not impossible.
> 
> > Yes, eventually.  I think one good point is that we should probably
> > remove this now so that we *have* to think about security implications
> > as we add each individual patch.  For instance, what kind of checking do
> > we do when we restore an mlock()'d VMA?
> 
> I think the question can be generalized further: How do you deal with
> saved tasks that have more priviledges than the task doing the restore?
> 
> There are probably more, but what I can think of right now includes:
> * anything you can set using ulimit
> * capabilities
> * threads running as another user/group
> * open files that have had their permissions changed after the open

At the checkpoint end, the ptrace checks seem apporpriate:  If you're
allowed to stop and manipulate the process, then you may as well be
allowed to checkpoint and see/tweak its memory that way.

At the restart end, every resource which was checkpointed will have to
be re-created, and permissions checked against the privilege of the
task which did the restart.  We may end up having to make use of the new
credentials for this.

This could become unpleasant: if an unprivileged task asked a privileged
helper to create something for the unprivileged task to use (i.e. a
raw socket), then the user needs to be privileged to re-created the
resource.  But it's necessary.

-serge
