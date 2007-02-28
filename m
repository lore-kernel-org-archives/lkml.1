Return-Path: <linux-kernel-owner+w=401wt.eu-S933047AbXB1POL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbXB1POL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 10:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933052AbXB1POL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 10:14:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933047AbXB1POJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 10:14:09 -0500
Message-ID: <45E59C26.7060808@redhat.com>
Date: Wed, 28 Feb 2007 10:13:42 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: John Reiser <jreiser@BitWagon.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: fully honor vdso_enabled [i386, sh; x86_64?]
References: <45DDFD98.4080300@BitWagon.com>
In-Reply-To: <45DDFD98.4080300@BitWagon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Andi and Ingo]

John Reiser wrote:
> Architectures such as i386, sh, x86_64 have a flag /proc/sys/vm/vdso_enabled
> to choose whether the kernel should setup a process to use vdso after execve().
> Informing the user code via AT_SYSINFO* is controlled by macro ARCH_DLINFO in
> fs/binfmt_elf.c and include/asm-$ARCH/elf.h, but the vdso page is established
> always via arch_setup_additonal_pages() called from load_elf_binary().
> If vdso_enabled is off, then current code wastes kernel time during execve()
> and fragments the address space unnecessarily.
> 
> This patch changes arch_setup_additonal_pages() to honor vdso_enabled.
> For i386 it also allows the option of a fixed addresss to avoid
> fragmenting the address space.  Compiles and runs on i386.
> x86_64 [IA32 support] and sh maintainers also please comment.
> 
> For some related history, including interaction with exec-shield, see:
> http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229304
> and also 207020 and 162797.
> 
> 
> Signed-off-by: John Reiser <jreiser@BitWagon.com>
> 
> diff --git a/arch/i386/kernel/sysenter.c b/arch/i386/kernel/sysenter.c
> index 13ca54a..f8c4d76 100644
> --- a/arch/i386/kernel/sysenter.c
> +++ b/arch/i386/kernel/sysenter.c
> @@ -22,6 +22,8 @@
>  #include <asm/msr.h>
>  #include <asm/pgtable.h>
>  #include <asm/unistd.h>
> +#include <asm/a.out.h>
> +#include <asm/mman.h>
> 
>  /*
>   * Should the kernel map a VDSO page into processes and pass its
> @@ -105,10 +107,25 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
>  {
>  	struct mm_struct *mm = current->mm;
>  	unsigned long addr;
> +	unsigned long flags;
>  	int ret;
> 
> +	switch (vdso_enabled) {
> +	case 0:  /* none */
> +		return 0;
> +	default:
> +	case 1:  /* vdso in random available page */
> +		addr = 0ul;
> +		flags = 0ul;
> +		break;
> +	case 2:  /* out of user's way */
> +		addr = STACK_TOP;
> +		flags = MAP_FIXED;
> +		break;
> +	}
> +
>  	down_write(&mm->mmap_sem);
> -	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
> +	addr = get_unmapped_area(NULL, addr, PAGE_SIZE, 0, flags);
>  	if (IS_ERR_VALUE(addr)) {
>  		ret = addr;
>  		goto up_fail;
> diff --git a/arch/sh/kernel/vsyscall/vsyscall.c b/arch/sh/kernel/vsyscall/vsyscall.c
> index 7b0f66f..2b789fb 100644
> --- a/arch/sh/kernel/vsyscall/vsyscall.c
> +++ b/arch/sh/kernel/vsyscall/vsyscall.c
> @@ -64,6 +64,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
>  	unsigned long addr;
>  	int ret;
> 
> +	if (!vdso_enabled)
> +		return 0;
> +
>  	down_write(&mm->mmap_sem);
>  	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
>  	if (IS_ERR_VALUE(addr)) {
> diff --git a/include/asm-i386/a.out.h b/include/asm-i386/a.out.h
> index ab17bb8..9894f73 100644
> --- a/include/asm-i386/a.out.h
> +++ b/include/asm-i386/a.out.h
> @@ -19,7 +19,7 @@ struct exec
> 
>  #ifdef __KERNEL__
> 
> -#define STACK_TOP	TASK_SIZE
> +#define STACK_TOP	(TASK_SIZE - PAGE_SIZE)  /* 1 page optional for vdso */
> 
>  #endif
> 

