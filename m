Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbYH0Pls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbYH0Pls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYH0Plk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:41:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52231 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbYH0Plk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:41:40 -0400
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <48B49C61.1040003@cs.columbia.edu>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu>
	 <1219437422.20559.146.camel@nimitz>  <48B0F449.2000006@cs.columbia.edu>
	 <1219768406.8680.17.camel@nimitz>  <48B49C61.1040003@cs.columbia.edu>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 08:41:36 -0700
Message-Id: <1219851696.8680.67.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 20:14 -0400, Oren Laadan wrote:
> >>>> +
> >>>> +	while (addr < end) {
> >>>> +		struct page *page;
> >>>> +
> >>>> +		/* simplified version of get_user_pages(): already have vma,
> >>>> +		* only need FOLL_TOUCH, and (for now) ignore fault stats */
> >>>> +
> >>>> +		cond_resched();
> >>>> +		while (!(page = follow_page(vma, addr, FOLL_TOUCH))) {
> >>>> +			ret = handle_mm_fault(vma->vm_mm, vma, addr, 0);
> >>>> +			if (ret & VM_FAULT_ERROR) {
> >>>> +				if (ret & VM_FAULT_OOM)
> >>>> +					ret = -ENOMEM;
> >>>> +				else if (ret & VM_FAULT_SIGBUS)
> >>>> +					ret = -EFAULT;
> >>>> +				else
> >>>> +					BUG();
> >>>> +				break;
> >>>> +			}
> >>>> +			cond_resched();
> >>>> +		}
> >>> At best this needs to get folded back into its own function.  This is
> >> This is almost identical to the original - see the preceding comment.
> > 
> > Exactly.  The code is copy-and-pasted.  If there's a bug in the
> > original, who will change this one?  Better to simply consolidate the
> > code into one copy.
> > 
> >>> pretty hard to read as-is.  Also, are there truly no in-kernel functions
> >>> that can be used for this?
> >> Can you suggest one ?
> > 
> > This is where the mentality has to shift.  Instead of thinking "there is
> > no exact in-kernel match for what I want here" we need to consider that
> > we can modify the in-kernel ones.  They can be modified to suit both
> > existing and the new needs that we have.
> 
> I agree.
> 
> However, my main goal now is not to make this patch perfect, but to provide
> a viable proof-of-concept that demonstrates how we want to do things. Unless
> you feel we are near ready to send these for inclusion soon (...), I intend
> to prioritize design and functionality.

So, you currently have buy-in on this basic approach from the OpenVZ
guys, and probably Ingo.  If you get too far along in the "design and
functionality" and a community member comes up with a really good
objection to some basic part of the "design and functionality" you're
going to have a lot of code to rewrite.

I'm trying to get minimized the quantity of "design and functionality"
down to the bare minimum set where we can get this merged.  So, yes, I
do think these should be sent for inclusion soon.

I believe that we're on course to create another large out-of-tree patch
set that does in-kernel checkpoint/restart.  We have no shortage of
those.  It's been done many times before.

This one will *HOPEFULLY* be different from all the rest when it gets
merged.  

> >>>> +	for (pgarr = ctx->pgarr; pgarr; pgarr = pgarr->next) {
> >>>> +		struct page **pages = pgarr->pages;
> >>>> +		int nr = pgarr->nused;
> >>>> +		void *ptr;
> >>>> +
> >>>> +		while (nr--) {
> >>>> +			ptr = kmap(*pages);
> >>>> +			ret = cr_kwrite(ctx, ptr, PAGE_SIZE);
> >>>> +			kunmap(*pages);
> >>> Why not use kmap_atomic() here?
> >> It is my understanding that the code must not sleep between kmap_atomic()
> >> and kunmap_atomic().
> > 
> > Yes, but you're going to absolutely kill performance on systems which
> > have expensive global TLB flushes.  Frequent kmaps()s should be avoided
> > at all costs.
> > 
> > The best way around this would be to change the interface to cr_kwrite()
> > so that it didn't have to use *mapped* kernel memory.  Maybe an
> > interface that takes 'struct page'.  Or, one where we kmap_atomic() the
> > buffer, kunmap_atomic(), copy to a temporary buffer, then cr_kwrite().
> > 
> >>>> +static int cr_write_vma(struct cr_ctx *ctx, struct vm_area_struct *vma)
> >>>> +{
> >>>> +	struct cr_hdr h;
> >>>> +	struct cr_hdr_vma *hh = ctx->hbuf;
> >>>> +	char *fname = NULL;
> >>>> +	int flen = 0, how, nr, ret;
> >>>> +
> >>>> +	h.type = CR_HDR_VMA;
> >>>> +	h.len = sizeof(*hh);
> >>>> +	h.ptag = 0;
> >>>> +
> >>>> +	hh->vm_start = vma->vm_start;
> >>>> +	hh->vm_end = vma->vm_end;
> >>>> +	hh->vm_page_prot = vma->vm_page_prot.pgprot;
> >>>> +	hh->vm_flags = vma->vm_flags;
> >>>> +	hh->vm_pgoff = vma->vm_pgoff;
> >>>> +
> >>>> +	if (vma->vm_flags & (VM_SHARED | VM_IO | VM_HUGETLB | VM_NONLINEAR)) {
> >>>> +		pr_warning("CR: unknown VMA %#lx\n", vma->vm_flags);
> >>>> +		return -ETXTBSY;
> >>>> +	}
> >>> Hmmm.  Interesting error code for VM_HUGETLB.  :)
> >> :)  well, the usual EINVAL didn't seem suitable. Any better suggestions ?
> > 
> > -ENOSUP might be clearest for now.  "Your system call tried to do
> > something unsupported."
> 
> Are you suggesting adding a new error code ?

Dang.  What's the thing we return from system calls that are
unsupported?  Did I just dream that up?

-- Dave

