Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZEXTnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZEXTnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbZEXTm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:42:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39474 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960AbZEXTm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:42:57 -0400
Date: Sun, 24 May 2009 21:42:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: x86@kernel.org, Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Remove indirect variable usage at arch/x86/kernel/tsc.c
Message-ID: <20090524194255.GD1337@ucw.cz>
References: <20090519180302.603.3124.sendpatchset@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519180302.603.3124.sendpatchset@subratamodak.linux.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> CC      arch/x86/kernel/tsc.o
> arch/x86/kernel/tsc.c: In function 'time_cpufreq_notifier':
> arch/x86/kernel/tsc.c:634: warning: 'dummy' may be used uninitialized in this function
> 
> However, there seems to be no practical usage of variable 'dummy'
> in the following piece of code:
> 
> 630 static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
> 631                                 void *data)
> 632 {
> 633         struct cpufreq_freqs *freq = data;
> 634         unsigned long *lpj, dummy;
> 635 
> 636         if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
> 637                 return 0;
> 638 
> 639         lpj = &dummy;
> 640         if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> 641 #ifdef CONFIG_SMP
> 642                 lpj = &cpu_data(freq->cpu).loops_per_jiffy;
> 643 #else
> 644         lpj = &boot_cpu_data.loops_per_jiffy;
> 645 #endif
> 646 
> 
> 'lpj' probably will get to point to some address after this if() statement.
> 
> 647         if (!ref_freq) {
> 648                 ref_freq = freq->old;
> 649                 loops_per_jiffy_ref = *lpj;
> 
> And, if it does, then "loops_per_jiffy_ref" will have a proper value,
> else, even with "lpj = &dummy" will not gurantee "loops_per_jiffy_ref = *lpj"
> to have the expected value.

But that's a bug to be fixed, I'd say? ... actually I believe you are
introducing a bug here. Yes, old code would put random numbers in
loops_per_jiffy_ref for !CPUFREQ_CONST_LOOPS, but you are introducing
oops there.

Have you tested the code?

> @@ -631,12 +631,11 @@ static int time_cpufreq_notifier(struct 
>  				void *data)
>  {
>  	struct cpufreq_freqs *freq = data;
> -	unsigned long *lpj, dummy;
> +	unsigned long *lpj = NULL;
>  
>  	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
>  		return 0;
>  
> -	lpj = &dummy;
>  	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
>  #ifdef CONFIG_SMP
>  		lpj = &cpu_data(freq->cpu).loops_per_jiffy;
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
