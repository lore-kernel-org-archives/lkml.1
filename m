Return-Path: <linux-kernel-owner+w=401wt.eu-S965365AbXDKUbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965365AbXDKUbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965379AbXDKUbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:31:37 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965365AbXDKUbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:31:36 -0400
Date: Wed, 11 Apr 2007 13:31:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Message-Id: <20070411133122.badf1c4f.akpm@linux-foundation.org>
In-Reply-To: <20070411162904.232696302@mvista.com>
References: <20070411162904.232696302@mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 09:29:04 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> The locking of the xtime_lock around the cpu notifier is unessesary now. At one
> time the tsc was used after a frequency change for timekeeping, but the re-write
> of timekeeping no longer uses the TSC unless the frequency is constant. 
> 
> The variables that are changed in this section of code had also once been used
> for timekeeping, but not any longer ..
> 
> Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  arch/i386/kernel/tsc.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> Index: linux-2.6.20/arch/i386/kernel/tsc.c
> ===================================================================
> --- linux-2.6.20.orig/arch/i386/kernel/tsc.c
> +++ linux-2.6.20/arch/i386/kernel/tsc.c
> @@ -200,13 +200,10 @@ time_cpufreq_notifier(struct notifier_bl
>  {
>  	struct cpufreq_freqs *freq = data;
>  
> -	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
> -		write_seqlock_irq(&xtime_lock);
> -
>  	if (!ref_freq) {
>  		if (!freq->old){
>  			ref_freq = freq->new;
> -			goto end;
> +			return 0;
>  		}
>  		ref_freq = freq->old;
>  		loops_per_jiffy_ref = cpu_data[freq->cpu].loops_per_jiffy;
> @@ -237,9 +234,6 @@ time_cpufreq_notifier(struct notifier_bl
>  			}
>  		}
>  	}
> -end:
> -	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
> -		write_sequnlock_irq(&xtime_lock);
>  
>  	return 0;
>  }

hm.

I've been permadropping Andi's
ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current/patches/sched-clock-share
because it causes a lockup when initscripts start ondemand on my
single-CPU, CONFIG_SMP=n Vaio.

I don't know _why_ it locks up - I traced it down to the
write_seqlock_irq() which you have just removed.  But write_seqlock()
doesn't loop with CONFIG_SMP=n builds, so a hang there is quite mysterious.

Anyway, your patch might make that hang go away.  We'll see.
