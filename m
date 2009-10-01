Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZJAG3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZJAG3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZJAG3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:29:08 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:44200 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752104AbZJAG3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:29:06 -0400
Message-ID: <4AC44C15.1000007@snapgear.com>
Date: Thu, 01 Oct 2009 16:28:37 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@uclinux.org>
Subject: Re: [uClinux-dev] [PATCH] Add uboot commandline argument passing
 support to m68knommu (Try #2)
References: <20090918162736.GY23700@csclub.uwaterloo.ca>	<1253291944.7060.42.camel@desktop> <20090918174936.GJ23702@csclub.uwaterloo.ca>
In-Reply-To: <20090918174936.GJ23702@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lennart,

Lennart Sorensen wrote:
> On Fri, Sep 18, 2009 at 09:39:04AM -0700, Daniel Walker wrote:
>> You have a couple of various checkpatch errors in this patch. We use
>> scripts/checkpatch.pl to check for code style issues. Could you run that
>> on your patch and fix any errors it finds? A couple are whitespace
>> related and you can use scripts/cleanpatch or scripts/cleanfile to
>> remove whitespace (so I hear. I've never run those scripts personally)
> 
> Oh dear.  I guess the original patch was a bit messy then.  OK here we
> go again with a checkpatch approved patch.
> 
> ---
> 
> This patch adds m68knommu support for getting the kernel command line
> arguments from uboot, including the passing of an initrd image from uboot.
> 
> We use this on a 5270/5271 based board, and have used it on the 5271evb
> development board.  It is based on a patch found in the linux-2.6-denx
> git tree, although that tree seems to have had lots of other changes
> since which are not in the main Linus kernel.  I believe this will work
> on all coldfires, although other m68knommu might be missing the _init_sp
> stuff in head.S as far as I can tell.  I only have the coldfire to
> test on.
> 
> Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

Looks ok to me. I'll go ahead and apply it to the for-next
m68knommu git tree.

Regards
Greg


> diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
> index e2201b9..064f591 100644
> --- a/arch/m68knommu/Kconfig
> +++ b/arch/m68knommu/Kconfig
> @@ -533,6 +533,13 @@ config AVNET
>  	default y
>  	depends on (AVNET5282)
>  
> +config UBOOT
> +	bool "Support for U-Boot command line parameters"
> +	help
> +	  If you say Y here kernel will try to collect command
> +	  line parameters from the initial u-boot stack.
> +	default n
> +
>  config 4KSTACKS
>  	bool "Use 4Kb for kernel stacks instead of 8Kb"
>  	default y
> diff --git a/arch/m68knommu/kernel/setup.c b/arch/m68knommu/kernel/setup.c
> index 5c2bb3e..ba92b90 100644
> --- a/arch/m68knommu/kernel/setup.c
> +++ b/arch/m68knommu/kernel/setup.c
> @@ -29,6 +29,8 @@
>  #include <linux/bootmem.h>
>  #include <linux/seq_file.h>
>  #include <linux/init.h>
> +#include <linux/initrd.h>
> +#include <linux/root_dev.h>
>  
>  #include <asm/setup.h>
>  #include <asm/irq.h>
> @@ -52,7 +54,6 @@ void (*mach_reset)(void);
>  void (*mach_halt)(void);
>  void (*mach_power_off)(void);
>  
> -
>  #ifdef CONFIG_M68000
>  	#define CPU "MC68000"
>  #endif
> @@ -111,6 +112,69 @@ void (*mach_power_off)(void);
>  extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
>  extern int _ramstart, _ramend;
>  
> +#if defined(CONFIG_UBOOT)
> +/*
> + * parse_uboot_commandline
> + *
> + * Copies u-boot commandline arguments and store them in the proper linux
> + * variables.
> + *
> + * Assumes:
> + *	_init_sp global contains the address in the stack pointer when the
> + *	kernel starts (see head.S::_start)
> + *
> + *	U-Boot calling convention:
> + *	(*kernel) (kbd, initrd_start, initrd_end, cmd_start, cmd_end);
> + *
> + *	_init_sp can be parsed as such
> + *
> + *	_init_sp+00 = u-boot cmd after jsr into kernel (skip)
> + *	_init_sp+04 = &kernel board_info (residual data)
> + *	_init_sp+08 = &initrd_start
> + *	_init_sp+12 = &initrd_end
> + *	_init_sp+16 = &cmd_start
> + *	_init_sp+20 = &cmd_end
> + *
> + *	This also assumes that the memory locations pointed to are still
> + *	unmodified. U-boot places them near the end of external SDRAM.
> + *
> + * Argument(s):
> + *	commandp = the linux commandline arg container to fill.
> + *	size     = the sizeof commandp.
> + *
> + * Returns:
> + */
> +void parse_uboot_commandline(char *commandp, int size)
> +{
> +	extern unsigned long _init_sp;
> +	unsigned long *sp;
> +	unsigned long uboot_kbd;
> +	unsigned long uboot_initrd_start, uboot_initrd_end;
> +	unsigned long uboot_cmd_start, uboot_cmd_end;
> +
> +
> +	sp = (unsigned long *)_init_sp;
> +	uboot_kbd = sp[1];
> +	uboot_initrd_start = sp[2];
> +	uboot_initrd_end = sp[3];
> +	uboot_cmd_start = sp[4];
> +	uboot_cmd_end = sp[5];
> +
> +	if (uboot_cmd_start && uboot_cmd_end)
> +		strncpy(commandp, (const char *)uboot_cmd_start, size);
> +#if defined(CONFIG_BLK_DEV_INITRD)
> +	if (uboot_initrd_start && uboot_initrd_end &&
> +		(uboot_initrd_end > uboot_initrd_start)) {
> +		initrd_start = uboot_initrd_start;
> +		initrd_end = uboot_initrd_end;
> +		ROOT_DEV = Root_RAM0;
> +		printk(KERN_INFO "initrd at 0x%lx:0x%lx\n",
> +			initrd_start, initrd_end);
> +	}
> +#endif /* if defined(CONFIG_BLK_DEV_INITRD) */
> +}
> +#endif /* #if defined(CONFIG_UBOOT) */
> +
>  void __init setup_arch(char **cmdline_p)
>  {
>  	int bootmap_size;
> @@ -128,7 +192,24 @@ void __init setup_arch(char **cmdline_p)
>  #if defined(CONFIG_BOOTPARAM)
>  	strncpy(&command_line[0], CONFIG_BOOTPARAM_STRING, sizeof(command_line));
>  	command_line[sizeof(command_line) - 1] = 0;
> -#endif
> +#endif /* CONFIG_BOOTPARAM */
> +
> +#if defined(CONFIG_UBOOT)
> +	/* CONFIG_UBOOT and CONFIG_BOOTPARAM defined, concatenate cmdline */
> +	#if defined(CONFIG_BOOTPARAM)
> +		/* Add the whitespace separator */
> +		command_line[strlen(CONFIG_BOOTPARAM_STRING)] = ' ';
> +		/* Parse uboot command line into the rest of the buffer */
> +		parse_uboot_commandline(
> +			&command_line[(strlen(CONFIG_BOOTPARAM_STRING)+1)],
> +			(sizeof(command_line) -
> +			(strlen(CONFIG_BOOTPARAM_STRING)+1)));
> +	/* Only CONFIG_UBOOT defined, create cmdline */
> +	#else
> +		parse_uboot_commandline(&command_line[0], sizeof(command_line));
> +	#endif /* CONFIG_BOOTPARAM */
> +	command_line[sizeof(command_line) - 1] = 0;
> +#endif /* CONFIG_UBOOT */
>  
>  	printk(KERN_INFO "\x0F\r\n\nuClinux/" CPU "\n");
>  
> @@ -204,6 +285,13 @@ void __init setup_arch(char **cmdline_p)
>  	free_bootmem(memory_start, memory_end - memory_start);
>  	reserve_bootmem(memory_start, bootmap_size, BOOTMEM_DEFAULT);
>  
> +#if defined(CONFIG_UBOOT) && defined(CONFIG_BLK_DEV_INITRD)
> +	if ((initrd_start > 0) && (initrd_start < initrd_end) &&
> +			(initrd_end < memory_end))
> +		reserve_bootmem(initrd_start, initrd_end - initrd_start,
> +				 BOOTMEM_DEFAULT);
> +#endif /* if defined(CONFIG_BLK_DEV_INITRD) */
> +
>  	/*
>  	 * Get kmalloc into gear.
>  	 */
> diff --git a/arch/m68knommu/platform/coldfire/head.S b/arch/m68knommu/platform/coldfire/head.S
> index 2b0d73c..4b91aa2 100644
> --- a/arch/m68knommu/platform/coldfire/head.S
> +++ b/arch/m68knommu/platform/coldfire/head.S
> @@ -106,6 +106,9 @@
>  .global _ramvec
>  .global	_ramstart
>  .global	_ramend
> +#if defined(CONFIG_UBOOT)
> +.global	_init_sp
> +#endif
>  
>  /*****************************************************************************/
>  
> @@ -124,6 +127,10 @@ _ramstart:
>  .long	0
>  _ramend:
>  .long	0
> +#if defined(CONFIG_UBOOT)
> +_init_sp:
> +.long	0
> +#endif
>  
>  /*****************************************************************************/
>  
> @@ -137,6 +144,9 @@ __HEAD
>  _start:
>  	nop					/* filler */
>  	movew	#0x2700, %sr			/* no interrupts */
> +#if defined(CONFIG_UBOOT)
> +	movel	%sp,_init_sp			/* save initial stack pointer */
> +#endif
>  
>  	/*
>  	 *	Do any platform or board specific setup now. Most boards
> _______________________________________________
> uClinux-dev mailing list
> uClinux-dev@uclinux.org
> http://mailman.uclinux.org/mailman/listinfo/uclinux-dev
> This message was resent by uclinux-dev@uclinux.org
> To unsubscribe see:
> http://mailman.uclinux.org/mailman/options/uclinux-dev
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
