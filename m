Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbYHOMcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbYHOMcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYHOMcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:32:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:64809 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYHOMcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HrvUaGNQHvW/035JitTkTEJsCn2hBz+LW+Ad//rw4OfJ5QVp/faBoEk4Hx60ylsxAB
         /GHS1kqTeq979Kvbyft2OFe0MmhksPdKtMK2GwCe/b13yTnzcluhXUVjSJIg1RLoKPnR
         RpUovoMwOEXRqxSVpAUN8XykUQrMCYHgulV44=
Date: Fri, 15 Aug 2008 14:32:06 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix 2 section mismatch warnings -
	find_and_reserve_crashkernel
Message-ID: <20080815123201.GB5285@joi>
References: <1218576186-31442-3-git-send-email-marcin.slusarz@gmail.com> <20080813111051.GA18660@elte.hu> <20080813140555.GA18523@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813140555.GA18523@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 04:05:55PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > # 844342a: x86: fix section mismatch warning - spp_getpage()
> 
> i've reverted this one as it's wrong and can cause crashes. For example 
> native_set_fixmap() gets called on 32-bit kernels from the ELF loader, 
> via arch_setup_additional_pages().


$ git grep  arch_setup_additional_pages | cat
arch/powerpc/include/asm/elf.h:/* vDSO has arch_setup_additional_pages */
arch/powerpc/include/asm/elf.h:extern int arch_setup_additional_pages(struct linux_binprm *bprm,
arch/powerpc/kernel/vdso.c:int arch_setup_additional_pages(struct linux_binprm *bprm,
arch/sh/include/asm/elf.h:/* vDSO has arch_setup_additional_pages */
arch/sh/include/asm/elf.h:extern int arch_setup_additional_pages(struct linux_binprm *bprm,
arch/sh/kernel/vsyscall/vsyscall.c:int arch_setup_additional_pages(struct linux_binprm *bprm,
arch/x86/vdso/vdso32-setup.c:#define arch_setup_additional_pages        syscall32_setup_pages
arch/x86/vdso/vdso32-setup.c:int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
arch/x86/vdso/vma.c:int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
fs/binfmt_elf.c:        retval = arch_setup_additional_pages(bprm, executable_stack);
fs/compat_binfmt_elf.c:#ifdef   compat_arch_setup_additional_pages
fs/compat_binfmt_elf.c:#undef   arch_setup_additional_pages
fs/compat_binfmt_elf.c:#define  arch_setup_additional_pages compat_arch_setup_additional_pages
include/asm-x86/elf.h:extern int arch_setup_additional_pages(struct linux_binprm *bprm,
include/asm-x86/elf.h:#define compat_arch_setup_additional_pages        syscall32_setup_pages

$ git grep native_set_fixmap | cat
arch/x86/kernel/paravirt.c:     .set_fixmap = native_set_fixmap,
arch/x86/mm/pgtable.c:void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
arch/x86/mm/pgtable.c:void native_set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
arch/x86/mm/pgtable.c:  __native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
arch/x86/xen/enlighten.c:       __native_set_fixmap(idx, pte);
include/asm-x86/fixmap.h:void __native_set_fixmap(enum fixed_addresses idx, pte_t pte);
include/asm-x86/fixmap.h:void native_set_fixmap(enum fixed_addresses idx,
include/asm-x86/fixmap.h:       native_set_fixmap(idx, phys, flags);

I looked at both implementations of arch_setup_additional_pages and didn't see any call to native_set_fixmap
or function which calls directly native_set_fixmap... Can you tell me what's the callchain?

Marcin
