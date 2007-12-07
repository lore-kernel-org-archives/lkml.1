Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbXLGFxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbXLGFxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 00:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXLGFxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 00:53:16 -0500
Received: from www.tglx.de ([62.245.132.106]:54905 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbXLGFxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 00:53:15 -0500
Date: Fri, 7 Dec 2007 06:51:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
cc: Ingo Molnar <mingo@elte.hu>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
In-Reply-To: <20071207021952.6f0ac922@morte>
Message-ID: <alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain>
References: <20071207021952.6f0ac922@morte>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007, Stefano Brivio wrote:

> This patch fixes a regression introduced by:
> 
> commit bb29ab26863c022743143f27956cc0ca362f258c
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon Jul 9 18:51:59 2007 +0200
> 
> This caused the jiffies counter to leap back and forth on cpufreq changes
> on my x86 box. I'd say that we can't always assume that TSC does "small
> errors" only, when marked unstable. On cpufreq changes these errors can be
> huge.

Hmrpf. sched_clock() is used for the time stamp of the printks. We
need to find some better solution other than killing off the tsc
access completely.

Ingo ???

Thanks,

     tglx
 
> The original bug report can be found here:
> http://bugzilla.kernel.org/show_bug.cgi?id=9475
> 
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> 
> ---
> 
> diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
> index 9ebc0da..d29cd9c 100644
> --- a/arch/x86/kernel/tsc_32.c
> +++ b/arch/x86/kernel/tsc_32.c
> @@ -98,13 +98,8 @@ unsigned long long native_sched_clock(void)
>  
>  	/*
>  	 * Fall back to jiffies if there's no TSC available:
> -	 * ( But note that we still use it if the TSC is marked
> -	 *   unstable. We do this because unlike Time Of Day,
> -	 *   the scheduler clock tolerates small errors and it's
> -	 *   very important for it to be as fast as the platform
> -	 *   can achive it. )
>  	 */
> -	if (unlikely(!tsc_enabled && !tsc_unstable))
> +	if (unlikely(!tsc_enabled))
>  		/* No locking but a rare wrong value is not a big deal: */
>  		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
>  
> 
> -- 
> Ciao
> Stefano
> 
