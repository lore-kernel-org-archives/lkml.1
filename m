Return-Path: <linux-kernel-owner+w=401wt.eu-S934674AbXFFGCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674AbXFFGCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbXFFGCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:02:10 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:43444 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754655AbXFFGCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:02:08 -0400
Subject: Re: [PATCH 4/4] mm: variable length argument support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       Ollie Wild <aaw@google.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <20070605163925.bfc417ca.akpm@linux-foundation.org>
References: <20070605150523.786600000@chello.nl>
	 <20070605151203.790585000@chello.nl>
	 <20070605163925.bfc417ca.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 08:02:05 +0200
Message-Id: <1181109725.7348.149.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 16:39 -0700, Andrew Morton wrote:

> > @@ -1620,6 +1600,34 @@ int expand_stack(struct vm_area_struct *
> >  	return error;
> >  }
> >  
> > +#ifdef CONFIG_STACK_GROWSUP
> > +int expand_stack(struct vm_area_struct *vma, unsigned long address)
> > +{
> > +	return expand_upwards(vma, address);
> > +}
> > +
> > +struct vm_area_struct *
> > +find_extend_vma(struct mm_struct *mm, unsigned long addr)
> > +{
> > +	struct vm_area_struct *vma, *prev;
> > +
> > +	addr &= PAGE_MASK;
> > +	vma = find_vma_prev(mm, addr, &prev);
> > +	if (vma && (vma->vm_start <= addr))
> > +		return vma;
> > +	if (!prev || expand_stack(prev, addr))
> > +		return NULL;
> > +	if (prev->vm_flags & VM_LOCKED) {
> > +		make_pages_present(addr, prev->vm_end);
> > +	}
> 
> unneeded braces
> 
> We really should check and propagate the make_pages_present() return value
> when appropriate.  It can fail under -ENOMEM, ulimit exceeded, overcommit,
> etc.

Right, this is not new ugliness, but indeed a good opportunity to clean
up.

> > +	return prev;
> > +}
> > +#else
> > +int expand_stack(struct vm_area_struct *vma, unsigned long address)
> > +{
> > +	return expand_downwards(vma, address);
> > +}
> > +
> >  struct vm_area_struct *
> >  find_extend_vma(struct mm_struct * mm, unsigned long addr)
> >  {
> > Index: linux-2.6-2/mm/mprotect.c
> > ===================================================================
> > --- linux-2.6-2.orig/mm/mprotect.c	2007-06-05 16:23:16.000000000 +0200
> > +++ linux-2.6-2/mm/mprotect.c	2007-06-05 16:29:45.000000000 +0200
> > @@ -128,7 +128,7 @@ static void change_protection(struct vm_
> >  	flush_tlb_range(vma, start, end);
> >  }
> >  
> > -static int
> > +int
> >  mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
> >  	unsigned long start, unsigned long end, unsigned long newflags)
> >  {
> > Index: linux-2.6-2/arch/ia64/ia32/binfmt_elf32.c
> > ===================================================================
> > --- linux-2.6-2.orig/arch/ia64/ia32/binfmt_elf32.c	2007-06-05 16:23:16.000000000 +0200
> > +++ linux-2.6-2/arch/ia64/ia32/binfmt_elf32.c	2007-06-05 16:29:45.000000000 +0200
> > @@ -195,62 +195,23 @@ ia64_elf32_init (struct pt_regs *regs)
> >  	ia32_load_state(current);
> >  }
> >  
> > +#undef setup_arg_pages
> 
> What's this for?

That file reads:

#define setup_arg_pages(bprm,tos,exec)          ia32_setup_arg_pages(bprm,exec)

....

#include "../../../fs/binfmt_elf.c"

....

int
ia32_setup_arg_pages (struct linux_binprm *bprm, int executable_stack)
{
        int ret;

        ret = setup_arg_pages(bprm, IA32_STACK_TOP, executable_stack);
/---------------^
We really want to call the real setup_arg_pages() here, not ourselves please.

        if (!ret) {
                /*
                 * Can't do it in ia64_elf32_init(). Needs to be done before
                 * calls to elf32_map()
                 */
                current->thread.ppl = ia32_init_pp_list();
        }

        return ret;
}


