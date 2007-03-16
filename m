Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbXCPDUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbXCPDUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 23:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXCPDUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 23:20:53 -0400
Received: from gw.goop.org ([64.81.55.164]:49170 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbXCPDUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 23:20:52 -0400
Message-ID: <45FA0D13.6080601@goop.org>
Date: Thu, 15 Mar 2007 20:20:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com>
In-Reply-To: <45FA054F.6020107@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Invoke black magic to relocate the VDSO even when COMPAT_VDSO is enabled
> by fixing up the ELF object.
>   

So does it actually work?  Can you boot the broken distros with this in
place?

> Signed-off-by: Zachary Amsden <zach@vmware.com>
>
> Index: linux-2.6.21/arch/i386/kernel/entry.S
> ===================================================================
> --- linux-2.6.21.orig/arch/i386/kernel/entry.S	2007-03-06 18:51:33.000000000 -0800
> +++ linux-2.6.21/arch/i386/kernel/entry.S	2007-03-15 18:14:11.000000000 -0800
> @@ -305,16 +305,12 @@ sysenter_past_esp:
>  	pushl $(__USER_CS)
>  	CFI_ADJUST_CFA_OFFSET 4
>  	/*CFI_REL_OFFSET cs, 0*/
> -#ifndef CONFIG_COMPAT_VDSO
>  	/*
>  	 * Push current_thread_info()->sysenter_return to the stack.
>  	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
>  	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
>  	 */
>  	pushl (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
> -#else
> -	pushl $SYSENTER_RETURN
> -#endif
>  	CFI_ADJUST_CFA_OFFSET 4
>  	CFI_REL_OFFSET eip, 0
>  
> Index: linux-2.6.21/arch/i386/kernel/sysenter.c
> ===================================================================
> --- linux-2.6.21.orig/arch/i386/kernel/sysenter.c	2007-03-06 18:51:34.000000000 -0800
> +++ linux-2.6.21/arch/i386/kernel/sysenter.c	2007-03-15 18:27:43.000000000 -0800
> @@ -72,6 +72,99 @@ extern const char vsyscall_int80_start, 
>  extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
>  static struct page *syscall_pages[1];
>  
> +#ifdef CONFIG_COMPAT_VDSO
> +static void fixup_vsyscall_elf(char *page)
> +{
> +	Elf32_Ehdr *hdr;
> +	Elf32_Shdr *sechdrs;
> +	Elf32_Phdr *phdr;
> +	char *secstrings;
> +	int i, j, n;
> +
> +	hdr = (Elf32_Ehdr *)page;
> +	
> +	printk("Remapping vsyscall page to %08x\n", (unsigned int)VDSO_HIGH_BASE);
> +
> +	/* Sanity checks against insmoding binaries or wrong arch,
> +           weird elf version */
> +	if (memcmp(hdr->e_ident, ELFMAG, 4) != 0 ||
> +		!elf_check_arch(hdr) ||
> +		hdr->e_type != ET_DYN)
> +		panic("Bogus ELF in vsyscall DSO\n");
> +
> +	hdr->e_entry += VDSO_HIGH_BASE;
> +	sechdrs = (void *)hdr + hdr->e_shoff;
> +	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
> +
> +	for (i = 1; i < hdr->e_shnum; i++) {
>   

Using sections is wrong; you should be going through the phdrs, and
looking for PT_DYNAMIC for relocation.

> +		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
> +			continue;
> +
> +		sechdrs[i].sh_addr += VDSO_HIGH_BASE;
> +		if (strcmp(secstrings+sechdrs[i].sh_name, ".dynsym") == 0) {
> +			Elf32_Sym  *sym =  (void *)hdr + sechdrs[i].sh_offset;
> +			n = sechdrs[i].sh_size / sizeof(*sym);
> +			for (j = 1; j < n;  j++) {
> +				int ndx = sym[j].st_shndx;
> +				if (ndx == SHN_UNDEF || ndx == SHN_ABS)
> +					continue;
> +				sym[j].st_value += VDSO_HIGH_BASE;
> +			}
>   

Does anyone expect the symbolic info to be correct?  It might be better
to just stomp it so nobody gets any ideas.

On the other hand, we don't want to break compatibility with anything...

> +		} else if (strcmp(secstrings+sechdrs[i].sh_name, ".dynamic") == 0) {
> +			Elf32_Dyn *dyn = (void *)hdr + sechdrs[i].sh_offset;
> +			int tag;
> +			while ((tag = (++dyn)->d_tag) != DT_NULL)
>   

Um, no.

> +		} else if (strcmp(secstrings+sechdrs[i].sh_name, ".useless") == 0) {
> +			/* This is demonic; see vsyscall.lds.S; it puts the
> +			 * .got in a section named .useless */
> +			uint32_t *got = (void *)hdr + sechdrs[i].sh_offset;
> +			*got += VDSO_HIGH_BASE;
> +		}
>   

This won't get relocated with one of the other relocations?  It's in the
text phdr.

> +	}
> +	phdr = (void *)hdr + hdr->e_phoff;
> +	for (i = 0; i < hdr->e_phnum; i++) {
> +		phdr[i].p_vaddr += VDSO_HIGH_BASE;
> +		phdr[i].p_paddr += VDSO_HIGH_BASE;
> +	}
> +
> +#if 0
> +/* 
> + * To verify the binary image in memory is identical, linked in the VDSO page
> + * from a COMPAT_VDSO compile without this patch; then diff the two.  For a
> + * non-relocated fixmap, the VDSO image is identical.
> + */
> +{
> +	extern const char vsyscall_orig_start, vsyscall_orig_end;
> +	int *l1 = (int *)page, *l2 = (int *)&vsyscall_orig_start;
> +	int foo = vsyscall_orig_end - vsyscall_orig_start / 4;
> +	for (i = 0; i < foo; i++) {
> +		if (l1[i] != l2[i]) {
> +			printk("vsyscall - delta [%03x] orig %08x new %08x\n",
> +				i, l2[i], l1[i]);
> +		}
> +	}
> +}
> +#endif
> +}
> +#else /* !CONFIG_COMPAT_VDSO */
> +static inline void fixup_vsyscall_elf(char *page) {}
> +#endif /* CONFIG_COMPAT_VDSO */
> +
>  int __init sysenter_setup(void)
>  {
>  	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
> @@ -86,20 +179,22 @@ int __init sysenter_setup(void)
>  		memcpy(syscall_page,
>  		       &vsyscall_int80_start,
>  		       &vsyscall_int80_end - &vsyscall_int80_start);
> +		fixup_vsyscall_elf((char *)syscall_page);
>  		return 0;
>  	}
>  
>  	memcpy(syscall_page,
>  	       &vsyscall_sysenter_start,
>  	       &vsyscall_sysenter_end - &vsyscall_sysenter_start);
> +	fixup_vsyscall_elf((char *)syscall_page);
>   

This could probably do with setting the addr and length in if statement,
and make the memcmp and fixup common.


    J
