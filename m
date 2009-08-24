Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbZHXG4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbZHXG4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZHXG4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:56:41 -0400
Received: from centrinvest.ru ([94.25.115.130]:41099 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbZHXG4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:56:41 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Mon, 24 Aug 2009 10:48:25 +0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: Re: [RFC patch 21/32] x86: Add timer_init to platform
Message-ID: <20090824064309.GA24326@centrinvest.ru>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arjan van de Veen <arjan@infradead.org>,
	Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Alok N Kataria <akataria@vmware.com>,
	Pan Jacob jun <jacob.jun.pan@intel.com>
References: <20090821205008.518392436@linutronix.de>
 <20090821205602.826717491@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821205602.826717491@linutronix.de>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 233, 08 21, 2009 at 09:31:20 -0000, Thomas Gleixner wrote:
> The timer init code is convoluted with several quirks and the paravirt
> timer chooser. Figuring out which code path is actually taken is not
> for the faint hearted.
> 
> Move the numaq TSC quirk to tsc_pre_init platform function and replace
> the paravirt time chooser and the remaining x86 quirk with a simple
> platform setup function.

> Index: linux-2.6/arch/x86/kernel/visws_quirks.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
> +++ linux-2.6/arch/x86/kernel/visws_quirks.c
> @@ -30,6 +30,7 @@
>  #include <asm/setup.h>
>  #include <asm/apic.h>
>  #include <asm/e820.h>
> +#include <asm/time.h>
>  #include <asm/io.h>
>  
>  #include <linux/kernel_stat.h>
> @@ -53,8 +54,10 @@ int is_visws_box(void)
>  	return visws_board_type >= 0;
>  }
>  
> -static int __init visws_time_init(void)
> +static void __init visws_time_init(void)
>  {
> +	hpet_time_init();

What's the purpose of this line ? It's highly unlikely that there is HPET hidden
somewhere inside VisWs :)


>  	printk(KERN_INFO "Starting Cobalt Timer system clock\n");
>  
>  	/* Set the countdown value */
> @@ -65,12 +68,6 @@ static int __init visws_time_init(void)
>  
>  	/* Enable (unmask) the timer interrupt */
>  	co_cpu_write(CO_CPU_CTRL, co_cpu_read(CO_CPU_CTRL) & ~CO_CTRL_TIMEMASK);
> -
> -	/*
> -	 * Zero return means the generic timer setup code will set up
> -	 * the standard vector:
> -	 */
> -	return 0;
>  }
>  
