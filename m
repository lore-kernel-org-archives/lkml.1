Return-Path: <linux-kernel-owner+w=401wt.eu-S1762268AbXHDDHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762268AbXHDDHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 23:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXHDDHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 23:07:17 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:59060 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763430AbXHDDHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 23:07:11 -0400
Date: Sat, 4 Aug 2007 12:06:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linuxsh-dev@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SH: add machine-ops and Dreamcast specific fix-up
Message-ID: <20070804030624.GA20847@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linuxsh-dev@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org
References: <8b67d60708031226m747f142sd3ed4447fb896a94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60708031226m747f142sd3ed4447fb896a94@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 08:26:17PM +0100, Adrian McMenamin wrote:
> diff --git a/arch/sh/boards/dreamcast/Makefile
> b/arch/sh/boards/dreamcast/Makefile
> index e6fcd3d..7b97546 100644
> --- a/arch/sh/boards/dreamcast/Makefile
> +++ b/arch/sh/boards/dreamcast/Makefile
> @@ -2,5 +2,5 @@
>  # Makefile for the Sega Dreamcast specific parts of the kernel
>  #
> 
> -obj-y	 := setup.o irq.o rtc.o reboot.o
> +obj-y	 := setup.o irq.o rtc.o
> 

You've created this diff against a bogus kernel.

> diff --git a/arch/sh/kernel/Makefile b/arch/sh/kernel/Makefile
> index bdb30ba..7ab2359 100644
> --- a/arch/sh/kernel/Makefile
> +++ b/arch/sh/kernel/Makefile
> @@ -5,15 +5,11 @@
>  extra-y	:= head.o init_task.o vmlinux.lds
> 
>  obj-y	:= debugtraps.o io.o io_generic.o irq.o machvec.o process.o ptrace.o \
> -	   semaphore.o setup.o signal.o sys_sh.o syscalls.o \
> +	   reboot.o semaphore.o setup.o signal.o sys_sh.o syscalls.o \
>  	   time.o topology.o traps.o
> 
>  obj-y				+= cpu/ timers/
> 
> -ifneq ($(CONFIG_SH_DREAMCAST),y)
> -	obj-y			+= reboot.o
> -endif
> -
>  obj-$(CONFIG_VSYSCALL)		+= vsyscall/
> 
>  obj-$(CONFIG_SMP)		+= smp.o
> diff --git a/arch/sh/kernel/machine_kexec.c b/arch/sh/kernel/machine_kexec.c
> index 790ed69..201b370 100644
> --- a/arch/sh/kernel/machine_kexec.c
> +++ b/arch/sh/kernel/machine_kexec.c
> @@ -29,9 +29,6 @@ extern const unsigned char relocate_new_kernel[];
>  extern const unsigned int relocate_new_kernel_size;
>  extern void *gdb_vbr_vector;
> 
> -void machine_shutdown(void)
> -{
> -}
> 
>  void machine_crash_shutdown(struct pt_regs *regs)
>  {

You've missed machine_crash_shutdown().

> +static void mach_reboot_fixups(void)
> +{
> +	if (mach_is_dreamcast()) {
> +		writel(0x00007611, 0xA05F6890);
> +	}
> +}
> +
Whether it's only the dreamcast or not is irrelevant, why bother adding
abstraction if you intend to add pointless hacks that completely
side-steps it?

> diff --git a/include/asm-sh/emergency-restart.h
> b/include/asm-sh/emergency-restart.h
> index 108d8c4..d6bec92 100644
> --- a/include/asm-sh/emergency-restart.h
> +++ b/include/asm-sh/emergency-restart.h
> @@ -1,6 +1,6 @@
> -#ifndef _ASM_EMERGENCY_RESTART_H
> -#define _ASM_EMERGENCY_RESTART_H
> +#ifndef _ASM_SH_EMERGENCY_RESTART_H
> +#define _ASM_SH_EMERGENCY_RESTART_H
> 
> -#include <asm-generic/emergency-restart.h>
> +extern void machine_emergency_restart(void);
> 
> -#endif /* _ASM_EMERGENCY_RESTART_H */
> +#endif /* _ASM_SH_EMERGENCY_RESTART_H */
> 
Pointless. Separating out machine_emergency_restart() buys us nothing,
leave this alone and just kill it off from the machine_ops entirely.
You've also ignored my earlier mail where I suggested this and killing
off some of the other ops we had no use for (as well as consolidating
machine_crash_shutdown()). I do wish you would read these things and wait
until there's been a resolution one way or another.
