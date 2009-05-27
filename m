Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbZE0MUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbZE0MUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbZE0MUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:20:36 -0400
Received: from smtp.nokia.com ([192.100.122.233]:31964 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZE0MUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:20:35 -0400
Subject: Re: [tip:timers/urgent] NOHZ: Properly feed cpufreq ondemand
 governor
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reply-To: ext-eero.nurkkala@nokia.com
To: "riel@redhat.com" <riel@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <tip-4e67ac87c460a3c876019fa05149591122ec5287@git.kernel.org>
References: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>
	 <tip-4e67ac87c460a3c876019fa05149591122ec5287@git.kernel.org>
Content-Type: text/plain
Organization: Nokia
Date: Wed, 27 May 2009 15:18:32 +0300
Message-Id: <1243426712.19944.165.camel@eenurkka-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2009 12:20:05.0041 (UTC) FILETIME=[776E4A10:01C9DEC5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 13:57 +0200, Nurkkala Eero.An (EXT-Offcode/Oulu)
wrote:
> Commit-ID:  4e67ac87c460a3c876019fa05149591122ec5287
> Gitweb:     http://git.kernel.org/tip/4e67ac87c460a3c876019fa05149591122ec5287
> Author:     Eero Nurkkala <ext-eero.nurkkala@nokia.com>
> AuthorDate: Mon, 25 May 2009 09:57:37 +0300
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 27 May 2009 13:55:00 +0200
> 
> NOHZ: Properly feed cpufreq ondemand governor
> 
> A call from irq_exit() may occasionally pause the timing
> info for cpufreq ondemand governor. This results in the
> cpufreq ondemand governor to fail to calculate the
> system load properly. Thus, relocate the checks for this
> particular case to keep the governor always functional.
> 
> [ tglx: moved the check to the top of the function ]
> 
> Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
> Reported-by: Tero Kristo <tero.kristo@nokia.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> LKML-Reference: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> 
> ---
>  kernel/time/tick-sched.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d3f1ef4..d3d6f3f 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -218,8 +218,15 @@ void tick_nohz_stop_sched_tick(int inidle)
>  	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
>  	int cpu;
>  
> -	local_irq_save(flags);
> +	/*
> +	 * Call to tick_nohz_start_idle stops the last_update_time from being
> +	 * updated. Thus, it must not be called in the event we are called from
> +	 * irq_exit() with the prior state different than idle.
> +	 */
> +	if (!inidle && !ts->inidle)
> +		return;
>  
> +	local_irq_save(flags);
>  	cpu = smp_processor_id();
>  	ts = &per_cpu(tick_cpu_sched, cpu);
>  	now = tick_nohz_start_idle(ts);
> @@ -239,9 +246,6 @@ void tick_nohz_stop_sched_tick(int inidle)
>  	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
>  		goto end;
>  
> -	if (!inidle && !ts->inidle)
> -		goto end;
> -
>  	ts->inidle = 1;
>  
>  	if (need_resched())

A quick note:
Now ts is uninitialized? So ts->inidle could cause troubles, no?


