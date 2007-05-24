Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbXEXJT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbXEXJT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXEXJTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:19:19 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:64399 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbXEXJTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:19:18 -0400
Message-ID: <46555886.4040408@linux.vnet.ibm.com>
Date: Thu, 24 May 2007 14:49:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu> <20070524064235.GA2386@linux.vnet.ibm.com> <20070524080959.GA29151@elte.hu>
In-Reply-To: <20070524080959.GA29151@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> btw., i think some more consolidation could be done in this area. We've 
> now got the traditional /proc/PID/stat metrics, schedstats, taskstats 
> and delay accounting and with CFS we've got /proc/sched_debug and 
> /proc/PID/sched. There's a fair amount of overlap.
> 

Yes. true. schedstats and delay accounting share code and taskstats is
a transport mechansim. I'll try and look at /proc/PID/stat and /proc/PID/sched
and /proc/sched_debug.

> btw., CFS does this change to fs/proc/array.c:
> 
> @@ -410,6 +408,14 @@ static int do_task_stat(struct task_stru
>  	/* convert nsec -> ticks */
>  	start_time = nsec_to_clock_t(start_time);
> 
> +	/*
> +	 * Use CFS's precise accounting, if available:
> +	 */
> +	if (!has_rt_policy(task)) {
> +		utime = nsec_to_clock_t(task->sum_exec_runtime);
> +		stime = 0;
> +	}
> +
>  	res = sprintf(buffer,"%d (%s) %c %d %d %d %d %d %lu %lu \
>  %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
>  %lu %lu %lu %lu %lu %lu %lu %lu %d %d %lu %lu %llu\n",
> 
> if you have some spare capacity to improve this code, it could be 
> further enhanced by not setting 'stime' to zero, but using the existing 
> jiffies based utime/stime statistics as a _ratio_ to split up the 
> precise p->sum_exec_runtime. That way we dont have to add precise 
> accounting to syscall entry/exit points (that would be quite expensive), 
> but still the sum of utime+stime would be very precise. (and that's what 
> matters most anyway)
> 
> 	Ingo

I'll start looking into splitting sum_exec_time into utime and stime
based on the ratio already present in the task structure. 

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
