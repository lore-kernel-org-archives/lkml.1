Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbXJKNE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbXJKNE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbXJKNET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:04:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:53222 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbXJKNES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:04:18 -0400
In-Reply-To: <20071011072208.075979098@au1.ibm.com>
References: <20071011071558.676463639@au1.ibm.com> <20071011072208.075979098@au1.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DFC6881D-E917-4EC5-B19C-8CE04E040B06@kernel.crashing.org>
Cc: PowerPC dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [patch 1/2] Replace NT_PRXFPREG with ELF_CORE_XFPREG_TYPE #define
Date: Thu, 11 Oct 2007 08:04:17 -0500
To: markn@au1.ibm.com
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 11, 2007, at 2:15 AM, markn@au1.ibm.com wrote:

> Replace NT_PRXFPREG with ELF_CORE_XFPREG_TYPE in the coredump code  
> which
> allows for more flexibility in the note type for the state of  
> 'extended
> floating point' implementations in coredumps. New note types can  
> now be
> added with an appropriate #define.
>
> #define ELF_CORE_XFPREG_TYPE to be NT_PRXFPREG in all current users so
> there's are no change in behaviour.

Can we make this ELF_CORE_VECREG_TYPE or something that is so coupled  
to the x86 specific name?

>
> Signed-off-by: Mark Nelson <markn@au1.ibm.com>
> ---
>  arch/ia64/ia32/elfcore32.h     |    1 +
>  arch/x86_64/ia32/ia32_binfmt.c |    1 +
>  fs/binfmt_elf.c                |    4 ++--
>  include/asm-i386/elf.h         |    1 +
>  4 files changed, 5 insertions(+), 2 deletions(-)
>
> Index: linux/arch/ia64/ia32/elfcore32.h
> ===================================================================
> --- linux.orig/arch/ia64/ia32/elfcore32.h
> +++ linux/arch/ia64/ia32/elfcore32.h
> @@ -117,6 +117,7 @@ elf_core_copy_task_fpregs(struct task_st
>  }
>
>  #define ELF_CORE_COPY_XFPREGS 1
> +#define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
>  static inline int
>  elf_core_copy_task_xfpregs(struct task_struct *tsk,  
> elf_fpxregset_t *xfpu)
>  {
> Index: linux/arch/x86_64/ia32/ia32_binfmt.c
> ===================================================================
> --- linux.orig/arch/x86_64/ia32/ia32_binfmt.c
> +++ linux/arch/x86_64/ia32/ia32_binfmt.c
> @@ -188,6 +188,7 @@ elf_core_copy_task_fpregs(struct task_st
>  }
>
>  #define ELF_CORE_COPY_XFPREGS 1
> +#define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
>  static inline int
>  elf_core_copy_task_xfpregs(struct task_struct *t, elf_fpxregset_t  
> *xfpu)
>  {
> Index: linux/fs/binfmt_elf.c
> ===================================================================
> --- linux.orig/fs/binfmt_elf.c
> +++ linux/fs/binfmt_elf.c
> @@ -1446,8 +1446,8 @@ static int elf_dump_thread_status(long s
>
>  #ifdef ELF_CORE_COPY_XFPREGS
>  	if (elf_core_copy_task_xfpregs(p, &t->xfpu)) {
> -		fill_note(&t->notes[2], "LINUX", NT_PRXFPREG, sizeof(t->xfpu),
> -			  &t->xfpu);
> +		fill_note(&t->notes[2], "LINUX", ELF_CORE_XFPREG_TYPE,
> +			  sizeof(t->xfpu), &t->xfpu);
>  		t->num_notes++;
>  		sz += notesize(&t->notes[2]);
>  	}

You've only fixed up one of 4 NT_PRXFPREG uses in the kernel.

Also, I'm not a fan of your proposed mechanism to "overload" the  
elf_fpxregset_t.  I'd rather see us introduce a new elf_vecregset_t  
and have it typedef'd to be elf_fpxregset_t on i386, x86_64, ia64

> Index: linux/include/asm-i386/elf.h
> ===================================================================
> --- linux.orig/include/asm-i386/elf.h
> +++ linux/include/asm-i386/elf.h
> @@ -129,6 +129,7 @@ extern int dump_task_extended_fpu (struc
>  #define ELF_CORE_COPY_TASK_REGS(tsk, elf_regs) dump_task_regs(tsk,  
> elf_regs)
>  #define ELF_CORE_COPY_FPREGS(tsk, elf_fpregs) dump_task_fpu(tsk,  
> elf_fpregs)
>  #define ELF_CORE_COPY_XFPREGS(tsk, elf_xfpregs)  
> dump_task_extended_fpu(tsk, elf_xfpregs)
> +#define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
>
>  #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
>  #define VDSO_CURRENT_BASE	((unsigned long)current->mm->context.vdso)
>
> -- 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

