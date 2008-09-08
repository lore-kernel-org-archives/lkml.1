Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYIHQuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYIHQuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYIHQuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:50:03 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46389 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYIHQuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:50:00 -0400
Subject: Re: [RFC v3][PATCH 5/9] Memory managemnet (restore)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <48C345D2.1020603@cs.columbia.edu>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0809040404060.5982@takamine.ncl.cs.columbia.edu>
	 <1220551683.23386.32.camel@nimitz>  <48C345D2.1020603@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 09:49:56 -0700
Message-Id: <1220892596.23386.166.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-06 at 23:09 -0400, Oren Laadan wrote:
> >> +		ret = cr_kread(ctx, pgarr->addrs, nr * sizeof(unsigned long));
> >> +		if (ret < 0)
> >> +			return ret;
> >> +		pgarr->nleft -= nr;
> >> +		pgarr->nused += nr;
> >> +		npages -= nr;
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * cr_vma_read_pages_data - read in data of pages in page-array chain
> >> + * @ctx - restart context
> >> + * @npages - number of pages
> >> + */
> >> +static int cr_vma_read_pages_data(struct cr_ctx *ctx, int npages)
> >> +{
> >> +	struct cr_pgarr *pgarr;
> >> +	unsigned long *addrs;
> >> +	int nr, ret;
> >> +
> >> +	for (pgarr = ctx->pgarr; npages; pgarr = pgarr->next) {
> >> +		addrs = pgarr->addrs;
> >> +		nr = pgarr->nused;
> >> +		npages -= nr;
> >> +		while (nr--) {
> >> +			ret = cr_uread(ctx, (void *) *(addrs++), PAGE_SIZE);
> > 
> > The void cast is unnecessary, right?
> 
> It is: cr_uread() expects "void *", while "*addrs" is "unsigned long".

I'd suggest not storing virtual addresses in 'unsigned long'.  It's
passable when you're doing lots of arithmetic on the addresses, but that
isn't happening here.  That probably means cascading back and changing
the type of pgarr->addrs[]. 

> > 
> >> +			if (ret < 0)
> >> +				return ret;
> >> +		}
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> > 
> > I'm having some difficulty parsing this function.  Could we
> > s/data/contents/ in the function name?  It also looks like addrs is
> > being used like an array here.  Can we use it explicitly that way?  I'd
> > also like to see it called vaddr or something explicit about what kinds
> > of addresses they are.
> > 
> >> +/* change the protection of an address range to be writable/non-writable.
> >> + * this is useful when restoring the memory of a read-only vma */
> >> +static int cr_vma_writable(struct mm_struct *mm, unsigned long start,
> >> +			   unsigned long end, int writable)
> > 
> > "cr_vma_writable" is a question to me.  This needs to be
> > "cr_vma_make_writable" or something to indicate that it is modifying the
> > vma.
> > 
> >> +{
> >> +	struct vm_area_struct *vma, *prev;
> >> +	unsigned long flags = 0;
> >> +	int ret = -EINVAL;
> >> +
> >> +	cr_debug("vma %#lx-%#lx writable %d\n", start, end, writable);
> >> +
> >> +	down_write(&mm->mmap_sem);
> >> +	vma = find_vma_prev(mm, start, &prev);
> >> +	if (unlikely(!vma || vma->vm_start > end || vma->vm_end < start))
> >> +		goto out;
> > 
> > Kill the unlikely(), please.  It's unnecessary and tends to make things
> > slower when not used correctly.  Can you please check all the future
> > patches and make sure that you don't accidentally introduce these later?
> > 
> >> +	if (writable && !(vma->vm_flags & VM_WRITE))
> >> +		flags = vma->vm_flags | VM_WRITE;
> >> +	else if (!writable && (vma->vm_flags & VM_WRITE))
> >> +		flags = vma->vm_flags & ~VM_WRITE;
> >> +	cr_debug("flags %#lx\n", flags);
> >> +	if (flags)
> >> +		ret = mprotect_fixup(vma, &prev, vma->vm_start,
> >> +				     vma->vm_end, flags);
> > 
> > Is this to fixup the same things that setup_arg_pages() uses it for?  We
> > should probably consolidate those calls somehow.  
> 
> This is needed for a VMA that has modified pages but is read-only: e.g. a
> task modifies memory then calls mprotect() to make it read-only.
> Since during restart we will recreate this VMA as read-only, we need to
> temporarily make it read-write to be able to read the saved contents into
> it, and then restore the read-only protection.
> 
> setup_arg_pages() is unrelated, and the code doesn't seem to have much in
> common.

Have you looked at mprotect_fixup()?  It deals with two things:
1. altering the commit charge against RSS if the mapping is actually
   writable.
2. Merging the VMA with an adjacent one if possible

We don't want to do either of these two things.  Even if we do merge the
VMA, it will be a waste of time and energy since we'll just re-split it
when we mprotect() again.

> >> + out:
> >> +	up_write(&mm->mmap_sem);
> >> +	return ret;
> >> +}
> >> +
> >> +/**
> >> + * cr_vma_read_pages - read in pages for to restore a vma
> >> + * @ctx - restart context
> >> + * @cr_vma - vma descriptor from restart
> >> + */
> >> +static int cr_vma_read_pages(struct cr_ctx *ctx, struct cr_hdr_vma *cr_vma)
> >> +{
> >> +	struct mm_struct *mm = current->mm;
> >> +	int ret = 0;
> >> +
> >> +	if (!cr_vma->nr_pages)
> >> +		return 0;
> > 
> > Looking at this code, I can now tell that we need to be more explicit
> > about what nr_pages is.  Is it the nr_pages that the vma spans,
> > contains, maps....??  Why do we need to check it here?
> 
> nr_pages is the number of pages _saved_ for this VMA, that is, the number
> of pages to follow to read in. If it's zero, we don't read anything (the
> VMA is had no dirty pages). Otherwise, we need to read that many addresses
> followed by that many pages.

Right, but that doesn't come out of the code easily.  I'm asking you to
please change those variable names to make it easier to figure out what
those things are used for.  You, as the author, have a good grip but
others reading the code do not.

> >> +	/* restore original protection for this vma */
> >> +	if (!(cr_vma->vm_flags & VM_WRITE))
> >> +		ret = cr_vma_writable(mm, cr_vma->vm_start, cr_vma->vm_end, 0);
> >> +
> >> + out:
> >> +	return ret;
> >> +}
> > 
> > Ugh.  Is this a security hole?  What if the user was not allowed to
> > write to the file being mmap()'d by this VMA?  Is this a window where
> > someone could come in and (using ptrace or something similar) write to
> > the file?
> 
> Not a security hole: this is only for private memory, so it never
> modifies the underlying file. This is related to what I explained before
> about read-only VMAs that have modified pages.

OK, so a shared, read-only mmap() should never get into this code path.
What if an attacker modified the checkpoint file to pretend to have
pages for a read-only, but shared mmap().  Would this code be tricked?

> The process is restarting, inside a container that is restarting. All
> tasks inside should be calling sys_restart() (by design) and no other
> process from outside should be allowed to ptrace them at this point.

Are there plans to implement this, or is it already in here somehow?

> (In any case, if some other tasks ptraces this task, it can make it do
> anything anyhow).

No.  I'm suggesting that since this lets you effectively write to
something that is not writable, it may be a hole with which to bypass
permissions which were set up at an earlier time.  

> > We copy into the process address space all the time when not in its
> > context explicitly.  
> 
> Huh ?

I'm just saying that you don't need to be in a process's context in
order to copy contents into its virtual address space.  Check out
access_process_vm().

-- Dave

