Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbYACRUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbYACRUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYACRT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:19:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48415 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYACRT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:19:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Date: Thu, 3 Jan 2008 18:22:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pavel@suse.cz, linux-kernel@vger.kernel.org
References: <20080103442.621670000@suse.de> <20080103154229.9723F14DDD@wotan.suse.de>
In-Reply-To: <20080103154229.9723F14DDD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031822.02668.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of January 2008, Andi Kleen wrote:
> 
> This avoids the requirement to mark a lot of initialization functions not 
> __cpuinit just for resume from RAM.
> 
> More functions could be converted now, didn't do all.
> 
> Cc: rjw@sisk.pl
> Cc: pavel@suse.cz
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/Kconfig                |    5 +++++
>  arch/x86/kernel/cpu/mtrr/main.c |    2 +-
>  arch/x86/kernel/trampoline_64.S |    2 +-
>  include/linux/init.h            |    2 +-
>  4 files changed, 8 insertions(+), 3 deletions(-)
> 
> Index: linux/arch/x86/kernel/trampoline_64.S
> ===================================================================
> --- linux.orig/arch/x86/kernel/trampoline_64.S
> +++ linux/arch/x86/kernel/trampoline_64.S
> @@ -34,7 +34,7 @@
>  #include <asm/segment.h>
>  
>  /* We can free up trampoline after bootup if cpu hotplug is not supported. */
> -#ifndef CONFIG_HOTPLUG_CPU
> +#if !defined(CONFIG_HOTPLUG_CPU) && !defined(CONFIG_PM_CPUINIT)
>  .section .init.data, "aw", @progbits
>  #else
>  .section .rodata, "a", @progbits
> Index: linux/include/linux/init.h
> ===================================================================
> --- linux.orig/include/linux/init.h
> +++ linux/include/linux/init.h
> @@ -266,7 +266,7 @@ void __init parse_early_param(void);
>  #define __devexitdata __exitdata
>  #endif
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> +#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_PM_CPUINIT)
>  #define __cpuinit
>  #define __cpuinitdata
>  #define __cpuexit
> Index: linux/arch/x86/Kconfig
> ===================================================================
> --- linux.orig/arch/x86/Kconfig
> +++ linux/arch/x86/Kconfig
> @@ -130,6 +130,11 @@ config GENERIC_PENDING_IRQ
>  	depends on GENERIC_HARDIRQS && SMP
>  	default y
>  
> +config PM_CPUINIT
> +	bool
> +	depends on PM

Please make it PM_SLEEP (PM is more than suspend/hibernation).

> +	default y
> +
>  config X86_SMP
>  	bool
>  	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
> Index: linux/arch/x86/kernel/cpu/mtrr/main.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/cpu/mtrr/main.c
> +++ linux/arch/x86/kernel/cpu/mtrr/main.c
> @@ -712,7 +712,7 @@ void __init mtrr_bp_init(void)
>  	}
>  }
>  
> -void mtrr_ap_init(void)
> +void __cpuinit mtrr_ap_init(void)
>  {
>  	unsigned long flags;
