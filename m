Return-Path: <linux-kernel-owner+w=401wt.eu-S1762824AbZE3Sh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762824AbZE3Sh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 14:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762150AbZE3ShO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 14:37:14 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37764 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761914AbZE3ShN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 14:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EVtjaLnknbvlV+b0F6SoqC1D+YOVN6oHDkhScwRwGgQd34+EbKRs0Ynhk/OyxPUjko
         c7InlgHgcEpxcUfE1DZ8Dv0QqEJ99bSdVGhZ4DQsW9sVi2Se2lKkH/hs2cT+SLfytTT8
         uG21QSvBByHh/RJOcTEjM1/Lbt/GdF9kQ9+NQ=
Date: Sat, 30 May 2009 20:37:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 05/12] Use wrapper routines around debug registers in
	processor related functions
Message-ID: <20090530183709.GA8739@nowhere>
References: <20090530103857.715014561@prasadkr_t60p.in.ibm.com> <20090530105129.GF9512@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090530105129.GF9512@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 04:21:29PM +0530, K.Prasad wrote:
> This patch enables the use of wrapper routines to access the debug/breakpoint
> registers.
> 
> Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  arch/x86/kernel/smpboot.c |    3 +++
>  arch/x86/power/cpu_32.c   |   16 +++-------------
>  arch/x86/power/cpu_64.c   |   15 +++------------
>  3 files changed, 9 insertions(+), 25 deletions(-)
> 
> Index: linux-2.6-tip.hbkpt/arch/x86/kernel/smpboot.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/smpboot.c
> +++ linux-2.6-tip.hbkpt/arch/x86/kernel/smpboot.c
> @@ -63,6 +63,7 @@
>  #include <asm/apic.h>
>  #include <asm/setup.h>
>  #include <asm/uv/uv.h>
> +#include <asm/debugreg.h>
>  #include <linux/mc146818rtc.h>
>  
>  #include <asm/smpboot_hooks.h>
> @@ -326,6 +327,7 @@ notrace static void __cpuinit start_seco
>  	setup_secondary_clock();
>  
>  	wmb();
> +	load_debug_registers();
>  	cpu_idle();
>  }
>  
> @@ -1252,6 +1254,7 @@ void cpu_disable_common(void)
>  	remove_cpu_from_maps(cpu);
>  	unlock_vector_lock();
>  	fixup_irqs();
> +	hw_breakpoint_disable();
>  }
>  
>  int native_cpu_disable(void)
> Index: linux-2.6-tip.hbkpt/arch/x86/power/cpu_32.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/arch/x86/power/cpu_32.c
> +++ linux-2.6-tip.hbkpt/arch/x86/power/cpu_32.c
> @@ -13,6 +13,7 @@
>  #include <asm/mce.h>
>  #include <asm/xcr.h>
>  #include <asm/suspend.h>
> +#include <asm/debugreg.h>
>  
>  static struct saved_context saved_context;
>  
> @@ -48,6 +49,7 @@ static void __save_processor_state(struc
>  	ctxt->cr2 = read_cr2();
>  	ctxt->cr3 = read_cr3();
>  	ctxt->cr4 = read_cr4_safe();
> +	hw_breakpoint_disable();
>  }
>  
>  /* Needed by apm.c */
> @@ -80,19 +82,7 @@ static void fix_processor_context(void)
>  	load_TR_desc();				/* This does ltr */
>  	load_LDT(&current->active_mm->context);	/* This does lldt */
>  
> -	/*
> -	 * Now maybe reload the debug registers
> -	 */
> -	if (current->thread.debugreg7) {
> -		set_debugreg(current->thread.debugreg0, 0);
> -		set_debugreg(current->thread.debugreg1, 1);
> -		set_debugreg(current->thread.debugreg2, 2);
> -		set_debugreg(current->thread.debugreg3, 3);
> -		/* no 4 and 5 */
> -		set_debugreg(current->thread.debugreg6, 6);
> -		set_debugreg(current->thread.debugreg7, 7);
> -	}
> -
> +	load_debug_registers();


This part is breaking the things in the middle.

I think the conversion from thread.debugreg0/1/2/3 to an
array should be done completely early, when you add the headers.

The problem is that your patchset iterates through those two versions
of virtual debug registers, and those two version can't be carried
well while keeping the good granularity of your patchset.

You are dropping the old version of virtual debug registers from
cpu management in favour of the new version which uses the array through
wrappers, whereas the thread code still deals with the old version.

The result, which I haven't tried, is likely to break the things
if I don't apply further patches of this series.

Of course it will build, but the breakpoints won't work anymore
with cpu hotplug or suspend because the threads management still
uses the old version of registers.

I can't apply this patchset if it induces a know regression in
the middle otherwise bisection will become impossible.

I think you need to convert all sites from
thread->debugregX to thread->debugreg[X] early in
the first patch. It will also bring your patchset into
a better logic of progression changes.

Thanks,
Frederic.



>  }
>  
>  static void __restore_processor_state(struct saved_context *ctxt)
> Index: linux-2.6-tip.hbkpt/arch/x86/power/cpu_64.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/arch/x86/power/cpu_64.c
> +++ linux-2.6-tip.hbkpt/arch/x86/power/cpu_64.c
> @@ -16,6 +16,7 @@
>  #include <asm/mtrr.h>
>  #include <asm/xcr.h>
>  #include <asm/suspend.h>
> +#include <asm/debugreg.h>
>  
>  static void fix_processor_context(void);
>  
> @@ -71,6 +72,7 @@ static void __save_processor_state(struc
>  	ctxt->cr3 = read_cr3();
>  	ctxt->cr4 = read_cr4();
>  	ctxt->cr8 = read_cr8();
> +	hw_breakpoint_disable();
>  }
>  
>  void save_processor_state(void)
> @@ -159,16 +161,5 @@ static void fix_processor_context(void)
>  	load_TR_desc();				/* This does ltr */
>  	load_LDT(&current->active_mm->context);	/* This does lldt */
>  
> -	/*
> -	 * Now maybe reload the debug registers
> -	 */
> -	if (current->thread.debugreg7){
> -                loaddebug(&current->thread, 0);
> -                loaddebug(&current->thread, 1);
> -                loaddebug(&current->thread, 2);
> -                loaddebug(&current->thread, 3);
> -                /* no 4 and 5 */
> -                loaddebug(&current->thread, 6);
> -                loaddebug(&current->thread, 7);
> -	}
> +	load_debug_registers();
>  }
> 

