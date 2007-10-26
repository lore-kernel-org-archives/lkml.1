Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbXJZSwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbXJZSwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbXJZSw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:52:27 -0400
Received: from gw.goop.org ([64.81.55.164]:43857 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXJZSw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:52:26 -0400
Message-ID: <47223755.4030707@goop.org>
Date: Fri, 26 Oct 2007 11:52:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Fix boot protocol KEEP_SEGMENTS check.
References: <m1r6jh3hun.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6jh3hun.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> The kernel only ever supports 1 version of the boot protocol
> so there is no need to check the boot protocol revision to
> see if a feature is supported.
>
> Both x86 and x86_64 support the same boot protocol so we need
> to implement the KEEP_SEGMENTS on x86_64 as well.  It isn't
> just paravirt bootloaders that could use this functionality.
>   

Ack.  I was planning on sending this patch out today...

    J
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Vivek Goyal <vgoyal@in.ibm.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Zachary Amsden <zach@vmware.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/boot/compressed/head_32.S |   12 ++++--------
>  arch/x86/boot/compressed/head_64.S |    7 +++++++
>  arch/x86/kernel/asm-offsets_64.c   |   10 ++++++++++
>  3 files changed, 21 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
> index a0ae2e7..036e635 100644
> --- a/arch/x86/boot/compressed/head_32.S
> +++ b/arch/x86/boot/compressed/head_32.S
> @@ -33,24 +33,20 @@
>  	.globl startup_32
>  
>  startup_32:
> -	/* check to see if KEEP_SEGMENTS flag is meaningful */
> -	cmpw $0x207, BP_version(%esi)
> -	jb 1f
> -
> +	cld
>  	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
>  	 * us to not reload segments */
>  	testb $(1<<6), BP_loadflags(%esi)
> -	jnz 2f
> +	jnz 1f
>  
> -1:	cli
> +	cli
>  	movl $(__BOOT_DS),%eax
>  	movl %eax,%ds
>  	movl %eax,%es
>  	movl %eax,%fs
>  	movl %eax,%gs
>  	movl %eax,%ss
> -
> -2:	cld
> +1:
>  
>  /* Calculate the delta between where we were compiled to run
>   * at and where we were actually loaded at.  This can only be done
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 4946764..1ccb38a 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -29,6 +29,7 @@
>  #include <asm/pgtable.h>
>  #include <asm/page.h>
>  #include <asm/msr.h>
> +#include <asm/asm-offsets.h>
>  
>  .section ".text.head"
>  	.code32
> @@ -36,11 +37,17 @@
>  
>  startup_32:
>  	cld
> +	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
> +	 * us to not reload segments */
> +	testb $(1<<6), BP_loadflags(%esi)
> +	jnz 1f
> +
>  	cli
>  	movl	$(__KERNEL_DS), %eax
>  	movl	%eax, %ds
>  	movl	%eax, %es
>  	movl	%eax, %ss
> +1:
>  
>  /* Calculate the delta between where we were compiled to run
>   * at and where we were actually loaded at.  This can only be done
> diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
> index 7e50bda..d1b6ed9 100644
> --- a/arch/x86/kernel/asm-offsets_64.c
> +++ b/arch/x86/kernel/asm-offsets_64.c
> @@ -15,12 +15,16 @@
>  #include <asm/segment.h>
>  #include <asm/thread_info.h>
>  #include <asm/ia32.h>
> +#include <asm/bootparam.h>
>  
>  #define DEFINE(sym, val) \
>          asm volatile("\n->" #sym " %0 " #val : : "i" (val))
>  
>  #define BLANK() asm volatile("\n->" : : )
>  
> +#define OFFSET(sym, str, mem) \
> +	DEFINE(sym, offsetof(struct str, mem))
> +
>  #define __NO_STUBS 1
>  #undef __SYSCALL
>  #undef _ASM_X86_64_UNISTD_H_
> @@ -109,5 +113,11 @@ int main(void)
>  	DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
>  	BLANK();
>  	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
> +
> +	BLANK();
> +	OFFSET(BP_scratch, boot_params, scratch);
> +	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
> +	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
> +	OFFSET(BP_version, boot_params, hdr.version);
>  	return 0;
>  }
>   

