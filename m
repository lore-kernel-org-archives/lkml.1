Return-Path: <linux-kernel-owner+w=401wt.eu-S1751665AbXCEUH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbXCEUH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXCEUH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:07:28 -0500
Received: from gw.goop.org ([64.81.55.164]:49085 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbXCEUH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:07:26 -0500
Message-ID: <45EC787B.2020807@goop.org>
Date: Mon, 05 Mar 2007 12:07:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: xen-devel@lists.xensource.com,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/10] linux 2.6.18: COMPAT_VDSO
References: <45EC098D.76E4.0078.0@novell.com>
In-Reply-To: <45EC098D.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> This adds support for CONFIG_COMPAT_VDSO. As this will certainly raise
> questions, I left in the code needed for an alternative approach (which
> requires mode C code, but less build script changes).
>   

Ingo just raised this as an issue for paravirt_ops as well.  I don't
quite follow what's going on there.   My understanding is that there are
some old versions of glibc (which were unreleased CVS snapshots shipped
by some vendors) which don't use the vdso's ELF header, but instead have
their own canned one which built into the library itself.

If that's the case (and I suspect I'm wrong about the detail here), then
how does this patch help?

And either way, we lose COMPAT_VDSO support for very old glibcs which
support the vdso at a really at a fixed address.  I don't know how many
real systems that would effect at this point though.

The C version looks more appealing to be, for a couple of reasons.  One,
its actually more comprehensible.  And two, it opens the possibility of
generating other customised vdsos.  One complaint about the Xen pv_ops
patches is that we unconditionally put the non-negative-offset-tls vdso
in place regardless of the actual hypervisor; if we can switch vdsos
depending on the hypervisor then that would be good.  Though that
wouldn't actually require anything more than fiddling with the ELF
notes, so it wouldn't actually require any relocs.

    J

[patch below for reference]

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
> Index: head-2007-02-27/arch/i386/Kconfig
> ===================================================================
> --- head-2007-02-27.orig/arch/i386/Kconfig	2007-03-05 10:00:18.000000000 +0100
> +++ head-2007-02-27/arch/i386/Kconfig	2007-02-27 16:27:37.000000000 +0100
> @@ -819,7 +819,6 @@ config HOTPLUG_CPU
>  
>  config COMPAT_VDSO
>  	bool "Compat VDSO support"
> -	depends on !X86_XEN
>  	default y
>  	help
>  	  Map the VDSO to the predictable old-style address too.
> Index: head-2007-02-27/arch/i386/kernel/Makefile
> ===================================================================
> --- head-2007-02-27.orig/arch/i386/kernel/Makefile	2007-03-05 10:00:18.000000000 +0100
> +++ head-2007-02-27/arch/i386/kernel/Makefile	2007-02-27 16:27:37.000000000 +0100
> @@ -74,6 +74,52 @@ $(obj)/vsyscall-%.so: $(src)/vsyscall.ld
>  		      $(obj)/vsyscall-%.o $(obj)/$(vsyscall_note) FORCE
>  	$(call if_changed,syscall)
>  
> +ifeq ($(CONFIG_XEN)$(CONFIG_COMPAT_VDSO),yy)
> +
> +# vsyscall.o also contains the vsyscall DSO relocation info as __initdata.
> +# We must build both alternative images before we can assemble it.
> +# Note: kbuild does not track this dependency due to usage of .include
> +$(obj)/vsyscall.o: $(obj)/vsyscall-int80.rel $(obj)/vsyscall-sysenter.rel
> +targets += $(foreach F,int80 sysenter,vsyscall-$F.so.alt vsyscall-$F.rel)
> +targets += vsyscall.lds.alt
> +
> +# The alternative DSO images are built using an alternate base address.
> +quiet_cmd_syscall_alt = REBASE  $@
> +      cmd_syscall_alt = sed 's,^\([[:space:]]*\.[[:space:]]*=[[:space:]]*\),\1-0x55AA0000 + ,' $< >$@
> +
> +quiet_cmd_syscall_rel = COMPARE $@
> +      cmd_syscall_rel = set -e; \
> +			cmp -l $(basename $<) $< \
> +			| { read off1 old1 new1; \
> +			    read off2 old2 new2; \
> +			    test $$(expr $$off1 + 1) = $$off2; \
> +			    echo " .long $$(expr $$off1 - 3)"; \
> +			    while read off1 old3 new3; do \
> +				read off2 old4 new4; \
> +				test $$(expr $$off1 + 1) = $$off2; \
> +				test $$old1 = $$old3 -a $$new1 = $$new3; \
> +				test $$old2 = $$old4 -a $$new2 = $$new4; \
> +				echo " .long $$(expr $$off1 - 3)"; \
> +			    done; \
> +			  } >$@
> +
> +SYSCFLAGS_vsyscall-sysenter.so.alt = $(vsyscall-flags)
> +SYSCFLAGS_vsyscall-int80.so.alt    = $(vsyscall-flags)
> +
> +$(obj)/vsyscall.lds.alt: $(obj)/vsyscall.lds FORCE
> +	$(call if_changed,syscall_alt)
> +
> +$(obj)/vsyscall-int80.so.alt $(obj)/vsyscall-sysenter.so.alt: \
> +$(obj)/vsyscall-%.so.alt: $(obj)/vsyscall.lds.alt \
> +		      $(obj)/vsyscall-%.o $(obj)/$(vsyscall_note) FORCE
> +	$(call if_changed,syscall)
> +
> +$(obj)/vsyscall-int80.rel $(obj)/vsyscall-sysenter.rel: \
> +$(obj)/vsyscall-%.rel: $(obj)/vsyscall-%.so.alt FORCE
> +	$(call if_changed,syscall_rel)
> +
> +endif
> +
>  # We also create a special relocatable object that should mirror the symbol
>  # table and layout of the linked DSO.  With ld -R we can then refer to
>  # these symbols in the kernel code rather than hand-coded addresses.
> Index: head-2007-02-27/arch/i386/kernel/sysenter.c
> ===================================================================
> --- head-2007-02-27.orig/arch/i386/kernel/sysenter.c	2007-03-05 10:00:18.000000000 +0100
> +++ head-2007-02-27/arch/i386/kernel/sysenter.c	2007-02-27 16:27:37.000000000 +0100
> @@ -25,6 +25,8 @@
>  
>  #ifdef CONFIG_XEN
>  #include <xen/interface/callback.h>
> +extern const unsigned long vdso_rel_int80_start[], vdso_rel_int80_end[];
> +extern const unsigned long vdso_rel_sysenter_start[], vdso_rel_sysenter_end[];
>  #endif
>  
>  /*
> @@ -66,6 +68,142 @@ void enable_sep_cpu(void)
>  #endif
>  }
>  
> +#if defined(CONFIG_XEN) && defined(CONFIG_COMPAT_VDSO)
> +static void __init relocate_vdso(Elf32_Ehdr *ehdr, unsigned long old_base, unsigned long new_base,
> +                                 const unsigned long *reloc_start, const unsigned long *reloc_end)
> +{
> +#if 1
> +	const unsigned long *reloc;
> +
> +	for (reloc = reloc_start; reloc < reloc_end; ++reloc) {
> +		unsigned long *ptr = (void *)((unsigned long)ehdr + *reloc);
> +
> +		*ptr += new_base - old_base;
> +	}
> +#else
> +	unsigned i, ndynsym = 0, szdynsym = 0;
> +	unsigned long dynsym = 0;
> +
> +	BUG_ON(ehdr->e_ident[EI_MAG0] != ELFMAG0);
> +	BUG_ON(ehdr->e_ident[EI_MAG1] != ELFMAG1);
> +	BUG_ON(ehdr->e_ident[EI_MAG2] != ELFMAG2);
> +	BUG_ON(ehdr->e_ident[EI_MAG3] != ELFMAG3);
> +	BUG_ON(ehdr->e_ident[EI_CLASS] != ELFCLASS32);
> +	BUG_ON(ehdr->e_ident[EI_DATA] != ELFDATA2LSB);
> +	BUG_ON(ehdr->e_ehsize < sizeof(*ehdr));
> +	ehdr->e_entry += new_base - old_base;
> +	BUG_ON(ehdr->e_phentsize < sizeof(Elf32_Phdr));
> +	for (i = 0; i < ehdr->e_phnum; ++i) {
> +		Elf32_Phdr *phdr = (void *)((unsigned long)ehdr + ehdr->e_phoff + i * ehdr->e_phentsize);
> +
> +		phdr->p_vaddr += new_base - old_base;
> +		switch(phdr->p_type) {
> +		case PT_LOAD:
> +		case PT_NOTE:
> +			break;
> +		case PT_DYNAMIC: {
> +				Elf32_Dyn *dyn = (void *)(phdr->p_vaddr - new_base + (unsigned long)ehdr);
> +				unsigned j;
> +
> +				for(j = 0; dyn[j].d_tag != DT_NULL; ++j) {
> +					switch(dyn[j].d_tag) {
> +					case DT_HASH:
> +					case DT_STRTAB:
> +					case DT_SYMTAB:
> +					case 0x6ffffff0: /* DT_VERSYM */
> +					case 0x6ffffffc: /* DT_VERDEF */
> +						break;
> +					case DT_SONAME:
> +					case DT_STRSZ:
> +					case 0x6ffffffd: /* DT_VERDEFNUM */
> +						continue;
> +					case DT_SYMENT:
> +						szdynsym = dyn[j].d_un.d_val;
> +						continue;
> +					default:
> +						if (dyn[j].d_tag >= 0x60000000 /* OLD_DT_LOOS */
> +						    || dyn[j].d_tag < 31 /* DT_ENCODING */
> +						    || !(dyn[j].d_tag & 1)) {
> +							printk(KERN_WARNING "vDSO dynamic info %u has unsupported tag
> %08X\n", j, dyn[j].d_tag);
> +							WARN_ON(1);
> +							continue;
> +						}
> +						break;
> +					}
> +					dyn[j].d_un.d_ptr += new_base - old_base;
> +					switch(dyn[j].d_tag) {
> +					case DT_HASH:
> +						ndynsym = ((Elf32_Word *)dyn[j].d_un.d_ptr)[1];
> +						break;
> +					case DT_SYMTAB:
> +						dynsym = dyn[j].d_un.d_ptr;
> +						break;
> +					}
> +				}
> +			}
> +			break;
> +		case PT_GNU_EH_FRAME:
> +			/* XXX */
> +			break;
> +		default:
> +			printk(KERN_WARNING "vDSO program header %u has unsupported type %08X\n", i, phdr->p_type);
> +			WARN_ON(1);
> +			break;
> +		}
> +	}
> +	BUG_ON(ehdr->e_shentsize < sizeof(Elf32_Shdr));
> +	BUG_ON(ehdr->e_shnum >= SHN_LORESERVE);
> +	for (i = 1; i < ehdr->e_shnum; ++i) {
> +		Elf32_Shdr *shdr = (void *)((unsigned long)ehdr + ehdr->e_shoff + i * ehdr->e_shentsize);
> +
> +		if (!(shdr->sh_flags & SHF_ALLOC))
> +			continue;
> +		shdr->sh_addr += new_base - old_base;
> +		switch(shdr->sh_type) {
> +		case SHT_DYNAMIC:
> +		case SHT_HASH:
> +		case SHT_NOBITS:
> +		case SHT_NOTE:
> +		case SHT_PROGBITS:
> +		case SHT_STRTAB:
> +		case 0x6ffffffd: /* SHT_GNU_verdef */
> +		case 0x6fffffff: /* SHT_GNU_versym */
> +			break;
> +		case SHT_DYNSYM:
> +			BUG_ON(shdr->sh_entsize < sizeof(Elf32_Sym));
> +			if (!szdynsym)
> +				szdynsym = shdr->sh_entsize;
> +			else
> +				WARN_ON(szdynsym != shdr->sh_entsize);
> +			if (!ndynsym)
> +				ndynsym = shdr->sh_size / szdynsym;
> +			else
> +				WARN_ON(ndynsym != shdr->sh_size / szdynsym);
> +			if (!dynsym)
> +				dynsym = shdr->sh_addr;
> +			else
> +				WARN_ON(dynsym != shdr->sh_addr);
> +			break;
> +		default:
> +			printk(KERN_WARNING "vDSO section %u has unsupported type %08X\n", i, shdr->sh_type);
> +			WARN_ON(shdr->sh_size);
> +			break;
> +		}
> +	}
> +	dynsym += (unsigned long)ehdr - new_base;
> +	for(i = 1; i < ndynsym; ++i) {
> +		Elf32_Sym *sym = (void *)(dynsym + i * szdynsym);
> +
> +		if (sym->st_shndx == SHN_ABS)
> +			continue;
> +		sym->st_value += new_base - old_base;
> +	}
> +#endif
> +}
> +#else
> +#define relocate_vdso(ehdr, old, new, start, end) ((void)0)
> +#endif
> +
>  /*
>   * These symbols are defined by vsyscall.o to mark the bounds
>   * of the ELF DSO images included therein.
> @@ -104,12 +245,16 @@ int __init sysenter_setup(void)
>  		memcpy(syscall_page,
>  		       &vsyscall_int80_start,
>  		       &vsyscall_int80_end - &vsyscall_int80_start);
> +		relocate_vdso(syscall_page, VDSO_PRELINK, __fix_to_virt(FIX_VDSO),
> +		              vdso_rel_int80_start, vdso_rel_int80_end);
>  		return 0;
>  	}
>  
>  	memcpy(syscall_page,
>  	       &vsyscall_sysenter_start,
>  	       &vsyscall_sysenter_end - &vsyscall_sysenter_start);
> +	relocate_vdso(syscall_page, VDSO_PRELINK, __fix_to_virt(FIX_VDSO),
> +	              vdso_rel_sysenter_start, vdso_rel_sysenter_end);
>  
>  	return 0;
>  }
> Index: head-2007-02-27/arch/i386/kernel/vsyscall.S
> ===================================================================
> --- head-2007-02-27.orig/arch/i386/kernel/vsyscall.S	2007-03-05 10:00:18.000000000 +0100
> +++ head-2007-02-27/arch/i386/kernel/vsyscall.S	2007-02-27 16:27:37.000000000 +0100
> @@ -12,4 +12,20 @@ vsyscall_sysenter_start:
>  	.incbin "arch/i386/kernel/vsyscall-sysenter.so"
>  vsyscall_sysenter_end:
>  
> +#if defined(CONFIG_XEN) && defined(CONFIG_COMPAT_VDSO)
> +
> +	.align 4
> +
> +	.globl vdso_rel_int80_start, vdso_rel_int80_end
> +vdso_rel_int80_start:
> +	.include "arch/i386/kernel/vsyscall-int80.rel"
> +vdso_rel_int80_end:
> +
> +	.globl vdso_rel_sysenter_start, vdso_rel_sysenter_end
> +vdso_rel_sysenter_start:
> +	.include "arch/i386/kernel/vsyscall-sysenter.rel"
> +vdso_rel_sysenter_end:
> +
> +#endif
> +
>  __FINIT
> Index: head-2007-02-27/include/asm-i386/elf.h
> ===================================================================
> --- head-2007-02-27.orig/include/asm-i386/elf.h	2007-03-05 10:00:18.000000000 +0100
> +++ head-2007-02-27/include/asm-i386/elf.h	2007-02-27 16:27:37.000000000 +0100
> @@ -137,7 +137,11 @@ extern int dump_task_extended_fpu (struc
>  
>  #ifdef CONFIG_COMPAT_VDSO
>  # define VDSO_COMPAT_BASE	VDSO_HIGH_BASE
> -# define VDSO_PRELINK		VDSO_HIGH_BASE
> +# ifndef CONFIG_XEN
> +#  define VDSO_PRELINK		VDSO_HIGH_BASE
> +# else
> +#  define VDSO_PRELINK		(0UL - FIX_VDSO * PAGE_SIZE)
> +# endif
>  #else
>  # define VDSO_COMPAT_BASE	VDSO_BASE
>  # define VDSO_PRELINK		0
>
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>   

