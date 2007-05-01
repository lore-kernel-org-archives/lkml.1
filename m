Return-Path: <linux-kernel-owner+w=401wt.eu-S1946596AbXEAF5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946596AbXEAF5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946598AbXEAF5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:57:42 -0400
Received: from gw.goop.org ([64.81.55.164]:50056 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946597AbXEAF5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:57:40 -0400
Message-ID: <4636D6E5.8090006@goop.org>
Date: Mon, 30 Apr 2007 22:57:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [8/30] x86_64: Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu
References: <20070501557.815359000@suse.de> <20070501035805.9FA9513CAF@wotan.suse.de>
In-Reply-To: <20070501035805.9FA9513CAF@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> This implements new vDSO for x86-64.  The concept is similar
> to the existing vDSOs on i386 and PPC.  x86-64 has had static
> vsyscalls before,  but these are not flexible enough anymore.
>
> A vDSO is a ELF shared library supplied by the kernel that is mapped into 
> user address space.  The vDSO mapping is randomized for each process
> for security reasons.
>
> Doing this was needed for clock_gettime, because clock_gettime
> always needs a syscall fallback and having one at a fixed
> address would have made buffer overflow exploits too easy to write.
>
> The vdso can be disabled with vdso=0
>
> It currently includes a new gettimeofday implemention and optimized
> clock_gettime(). The gettimeofday implementation is slightly faster
> than the one in the old vsyscall.  clock_gettime is significantly faster 
> than the syscall for CLOCK_MONOTONIC and CLOCK_REALTIME.
>
> The new calls are generally faster than the old vsyscall. 
>
> TBD: add new benchmarks
>
> Advantages over the old x86-64 vsyscalls:
> - Extensible
> - Randomized
> - Cleaner
> - Easier to virtualize (the old static address range previously causes
> overhead e.g. for Xen because it has to create special page tables for it) 
>
> Weak points: 
> - glibc support still to be written
>
> The VM interface is partly based on Ingo Molnar's i386 version.
>
> Signed-off-by: Andi Kleen <ak@suse.de>
>
> ---
>  Documentation/kernel-parameters.txt |    2 
>  arch/x86_64/Makefile                |    3 
>  arch/x86_64/ia32/ia32_binfmt.c      |    1 
>  arch/x86_64/kernel/time.c           |    1 
>  arch/x86_64/kernel/vmlinux.lds.S    |   12 +++
>  arch/x86_64/kernel/vsyscall.c       |   22 +----
>  arch/x86_64/mm/init.c               |   17 ++++
>  arch/x86_64/vdso/Makefile           |   49 ++++++++++++
>  arch/x86_64/vdso/vclock_gettime.c   |  120 +++++++++++++++++++++++++++++++
>  arch/x86_64/vdso/vdso-note.S        |   25 ++++++
>  arch/x86_64/vdso/vdso-start.S       |    2 
>  arch/x86_64/vdso/vdso.S             |    2 
>  arch/x86_64/vdso/vdso.lds.S         |   77 ++++++++++++++++++++
>  arch/x86_64/vdso/vextern.h          |   16 ++++
>  arch/x86_64/vdso/vgetcpu.c          |   50 +++++++++++++
>  arch/x86_64/vdso/vma.c              |  137 ++++++++++++++++++++++++++++++++++++
>  arch/x86_64/vdso/voffset.h          |    1 
>  arch/x86_64/vdso/vvar.c             |   12 +++
>  include/asm-x86_64/auxvec.h         |    2 
>  include/asm-x86_64/elf.h            |   13 +++
>  include/asm-x86_64/mmu.h            |    1 
>  include/asm-x86_64/pgtable.h        |    8 +-
>  include/asm-x86_64/vgtod.h          |   29 +++++++
>  include/asm-x86_64/vsyscall.h       |    3 
>  24 files changed, 583 insertions(+), 22 deletions(-)
>
> Index: linux/arch/x86_64/ia32/ia32_binfmt.c
> ===================================================================
> --- linux.orig/arch/x86_64/ia32/ia32_binfmt.c
> +++ linux/arch/x86_64/ia32/ia32_binfmt.c
> @@ -38,6 +38,7 @@
>  
>  int sysctl_vsyscall32 = 1;
>  
> +#undef ARCH_DLINFO
>  #define ARCH_DLINFO do {  \
>  	if (sysctl_vsyscall32) { \
>  	NEW_AUX_ENT(AT_SYSINFO, (u32)(u64)VSYSCALL32_VSYSCALL); \
> Index: linux/arch/x86_64/kernel/vmlinux.lds.S
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/vmlinux.lds.S
> +++ linux/arch/x86_64/kernel/vmlinux.lds.S
> @@ -94,6 +94,9 @@ SECTIONS
>    .vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data))
>  		{ *(.vsyscall_gtod_data) }
>    vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
> +  .vsyscall_clock : AT(VLOAD(.vsyscall_clock))
> +		{ *(.vsyscall_clock) }
> +  vsyscall_clock = VVIRT(.vsyscall_clock);
>  
>  
>    .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
> @@ -153,6 +156,8 @@ SECTIONS
>  
>    . = ALIGN(4096);		/* Init code and data */
>    __init_begin = .;
> +
> +
>    .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
>  	_sinittext = .;
>  	*(.init.text)
> @@ -190,6 +195,12 @@ SECTIONS
>    .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
>    .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
>  
> +/* vdso blob that is mapped into user space */
> +  vdso_start = . ;
> +  .vdso  : AT(ADDR(.vdso) - LOAD_OFFSET) { *(.vdso) }
> +  . = ALIGN(4096);
> +  vdso_end = .;
> +
>  #ifdef CONFIG_BLK_DEV_INITRD
>    . = ALIGN(4096);
>    __initramfs_start = .;
> @@ -202,6 +213,7 @@ SECTIONS
>    .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) { *(.data.percpu) }
>    __per_cpu_end = .;
>    . = ALIGN(4096);
> +
>    __init_end = .;
>  
>    . = ALIGN(4096);
> Index: linux/arch/x86_64/mm/init.c
> ===================================================================
> --- linux.orig/arch/x86_64/mm/init.c
> +++ linux/arch/x86_64/mm/init.c
> @@ -159,6 +159,14 @@ static __init void set_pte_phys(unsigned
>  	__flush_tlb_one(vaddr);
>  }
>  
> +void __init
> +set_kernel_map(void *vaddr,unsigned long len,unsigned long phys,pgprot_t prot)
> +{
> +	void *end = vaddr + ALIGN(len, PAGE_SIZE);
> +	for (; vaddr < end; vaddr += PAGE_SIZE, phys += PAGE_SIZE)
> +		set_pte_phys((unsigned long)vaddr, phys, prot);
> +}
> +
>  /* NOTE: this is meant to be run only at boot */
>  void __init 
>  __set_fixmap (enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
> @@ -756,3 +764,12 @@ int in_gate_area_no_task(unsigned long a
>  {
>  	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
>  }
> +
> +const char *arch_vma_name(struct vm_area_struct *vma)
> +{
> +	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
> +		return "[vdso]";
> +	if (vma == &gate_vma)
> +		return "[vsyscall]";
> +	return NULL;
> +}
> Index: linux/arch/x86_64/vdso/vdso-note.S
> ===================================================================
> --- /dev/null
> +++ linux/arch/x86_64/vdso/vdso-note.S
> @@ -0,0 +1,25 @@
> +/*
> + * This supplies .note.* sections to go into the PT_NOTE inside the vDSO text.
> + * Here we can supply some information useful to userland.
> + */
> +
> +#include <linux/uts.h>
> +#include <linux/version.h>
> +
> +#define ASM_ELF_NOTE_BEGIN(name, flags, vendor, type)			      \
>   

Use linux/elfnote.h?

    J
