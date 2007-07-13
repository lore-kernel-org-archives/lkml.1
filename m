Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbXGMNDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbXGMNDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbXGMNDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:03:18 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48527 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbXGMNDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:03:17 -0400
Date: Fri, 13 Jul 2007 14:02:34 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dmitry Monakhov <dmonakhov@sw.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
In-Reply-To: <20070713011332.2550c5e1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707131341230.17487@blonde.wat.veritas.com>
References: <20070709184917.GA8720@dnb.sw.ru> <20070713011332.2550c5e1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AG5pY2twaWdnaW5AeWFob28uY29tLmF1AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAZG1vbmFraG92QHN3LnJ1AGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAaGNoQGluZnJhZGVhZC5vcmcA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Andrew Morton wrote:
> On Mon, 9 Jul 2007 22:49:17 +0400 Dmitry Monakhov <dmonakhov@sw.ru> wrote:
> 
> > Some device drivers can change vm_flags in their f_op->mmap
> > method. In order to be on the safe side we have to recheck
> > lock rlimit. Now we have to check lock rlimit from two places,
> > let's move this common code to helper functon.

I think you've made a mistake putting this one into your -mm tree:
I thought we'd replaced it all by the one-liner to mspec.c
[PATCH] mspec_mmap don't set VM_LOCKED

There is no justification for a driver to set VM_LOCKED these days
(even in 2.4 they were supposed to set VM_RESERVED instead).  So
all this to handle a driver setting VM_LOCKED is inappropriate.

mspec was the only driver doing it in tree, but ATI's fglrx is the
one Dmitry spotted (and it takes care to adjust the locked_vm count,
so that won't even wrap negative later - the worst that happens is
they prevent the process using their driver from locking as much
memory as it might wish to - or that's how it looked to me).

The only debate is what we might do in the way of extra checks after
coming back from a driver's ->mmap.  WARN_ON(vma->vm_flags & VM_LOCKED)?
And which other flags?  hch is keen to put a check in there, I'm less
interested, and haven't begun to think of all the things we might wish
to check if we're going to distrust the driver here, and wherever else.

But that would be the way to go, not Dmitry's check_lock_limit patch:
please remove it from -mm after all.

One more comment below...

> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  mm/mmap.c |   33 ++++++++++++++++++++++++++-------
> >  1 files changed, 26 insertions(+), 7 deletions(-)
> > 
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 906ed40..5c89f1d 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -885,6 +885,18 @@ void vm_stat_account(struct mm_struct *mm, unsigned long flags,
> >  }
> >  #endif /* CONFIG_PROC_FS */
> >  
> > +static int check_lock_limit(unsigned long delta, struct mm_struct* mm)
> > +{
> > +	unsigned long locked, lock_limit;
> > +	locked = delta >> PAGE_SHIFT;
> > +	locked += mm->locked_vm;
> > +	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
> > +	lock_limit >>= PAGE_SHIFT;
> > +	if (locked > lock_limit && !capable(CAP_IPC_LOCK))
> > +		return -EAGAIN;
> > +	return 0;
> > +}
> > +
> >  /*
> >   * The caller must hold down_write(current->mm->mmap_sem).
> >   */
> > @@ -954,13 +966,9 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
> >  	}
> >  	/* mlock MCL_FUTURE? */
> >  	if (vm_flags & VM_LOCKED) {
> > -		unsigned long locked, lock_limit;
> > -		locked = len >> PAGE_SHIFT;
> > -		locked += mm->locked_vm;
> > -		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
> > -		lock_limit >>= PAGE_SHIFT;
> > -		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
> > -			return -EAGAIN;
> > +		error = check_lock_limit(len, mm);
> > +		if (error)
> > +			return error;
> >  	}
> >  
> >  	inode = file ? file->f_path.dentry->d_inode : NULL;
> > @@ -1101,6 +1109,17 @@ munmap_back:
> >  		error = file->f_op->mmap(file, vma);
> >  		if (error)
> >  			goto unmap_and_free_vma;
> > +		
> > +		if (vma->vm_flags & VM_LOCKED
> > +				&& !(vm_flags & VM_LOCKED)) {
> > +		/*
> > +		 * VM_LOCKED was added in f_op->mmap() method,
> > +		 * so we have to recheck limit.
> > +		 */
> > +			error = check_lock_limit(len, mm);
> > +			if (error)
> > +				goto unmap_and_free_vma;
> > +		}
> 
> Worried.  As far as the filesytem is concerned, its mmap has succeeded.
> 
> But now we're taking the unmap_and_free_vma path _after_ ->mmap() has
> "succeeded".  So we will now tell userspace that the mmap syscall has
> failed, even though the fs thinks it succeeded, if you follow me.  And this
> is a new thing.  
> 
> Could it cause bad things to happen?  Well, if filesystems had a
> file_operations.munmap() then yeah, we should have called that in your new
> code.  But filesystems don't have a ->munmap() method.
> 
> Still.  Can we think of any way in which this change could lead to resource
> leaks or to any other such problems?

All very good thoughts, but we don't even need to think them!

Hugh
