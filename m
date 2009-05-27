Return-Path: <linux-kernel-owner+w=401wt.eu-S1763422AbZE0NYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763422AbZE0NYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760642AbZE0NYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:24:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44087 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760287AbZE0NYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:24:13 -0400
Message-ID: <4A1D3EEC.3050106@redhat.com>
Date: Wed, 27 May 2009 09:23:56 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tero.kristo@nokia.com, ext-eero.nurkkala@nokia.com,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de
Subject: Re: [tip:timers/urgent] NOHZ: Properly feed cpufreq ondemand governor
References: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com> <tip-cf1240033cc81216a18eec0ca71466f7fe4eeda8@git.kernel.org>
In-Reply-To: <tip-cf1240033cc81216a18eec0ca71466f7fe4eeda8@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Eero Nurkkala wrote:
> Commit-ID:  cf1240033cc81216a18eec0ca71466f7fe4eeda8
> Gitweb:     http://git.kernel.org/tip/cf1240033cc81216a18eec0ca71466f7fe4eeda8
> Author:     Eero Nurkkala <ext-eero.nurkkala@nokia.com>
> AuthorDate: Mon, 25 May 2009 09:57:37 +0300
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 27 May 2009 14:51:47 +0200
> 
> NOHZ: Properly feed cpufreq ondemand governor
> 
> A call from irq_exit() may occasionally pause the timing
> info for cpufreq ondemand governor. This results in the
> cpufreq ondemand governor to fail to calculate the
> system load properly. Thus, relocate the checks for this
> particular case to keep the governor always functional.
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
>  kernel/time/tick-sched.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d3f1ef4..233b4e7 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -222,6 +222,15 @@ void tick_nohz_stop_sched_tick(int inidle)
>  
>  	cpu = smp_processor_id();
>  	ts = &per_cpu(tick_cpu_sched, cpu);
> +
> +	/*
> +	 * Call to tick_nohz_start_idle stops the last_update_time from being
> +	 * updated. Thus, it must not be called in the event we are called from
> +	 * irq_exit() with the prior state different than idle.
> +	 */
> +	if (!inidle && !ts->inidle)
> +		return;

Calling return without restoring the
local_irq_save(flags) right above the
line where you get the CPU number seems
like a bad idea.

-- 
All rights reversed.
