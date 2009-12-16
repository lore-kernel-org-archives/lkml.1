Return-Path: <linux-kernel-owner+w=401wt.eu-S1763331AbZLPX6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763331AbZLPX6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762708AbZLPX6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:58:43 -0500
Received: from www.tglx.de ([62.245.132.106]:38154 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbZLPX6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:58:42 -0500
Date: Thu, 17 Dec 2009 00:58:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Simon Horman <horms@verge.net.au>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] timers: Remove duplicate setting of new_base in
 __mod_timer()
In-Reply-To: <20091216222028.GA15841@verge.net.au>
Message-ID: <alpine.LFD.2.00.0912170053400.2755@localhost.localdomain>
References: <20091216222028.GA15841@verge.net.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cSimon,

On Thu, 17 Dec 2009, Simon Horman wrote:

> I am wondering if the first line of the following snippet of
> __mod_timer() can be removed as new_base always seems to be reset.

Good catch.
 
> Alternatively perhaps smp_processor_id() and  per_cpu() could
> be moved to inside the #if and the call to __get_cpu_var() moved to
> inside #else ?

Nah, __get_cpu_var does a smp_processor_id() anyway. Removing that
first new_base assignment is the right thing to do.

>         new_base = __get_cpu_var(tvec_bases);
> 
>         cpu = smp_processor_id();
>         
> #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
>         if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
>                 int preferred_cpu = get_nohz_load_balancer();
>                         
>                 if (preferred_cpu >= 0)
>                         cpu = preferred_cpu;
>         }
> #endif
>         new_base = per_cpu(tvec_bases, cpu);
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Index: linux-2.6/kernel/timer.c
> ===================================================================
> --- linux-2.6.orig/kernel/timer.c	2009-12-17 07:02:57.000000000 +0900
> +++ linux-2.6/kernel/timer.c	2009-12-17 07:03:17.000000000 +0900
> @@ -656,8 +656,6 @@ __mod_timer(struct timer_list *timer, un
>  
>  	debug_activate(timer, expires);
>  
> -	new_base = __get_cpu_var(tvec_bases);
> -
>  	cpu = smp_processor_id();
>  
>  #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)

Could you please resend the patch with a proper change log ?

Thanks,

	tglx
 
