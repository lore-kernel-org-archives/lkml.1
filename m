Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbXIMJg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbXIMJg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbXIMJgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:36:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbXIMJgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:36:45 -0400
Date: Thu, 13 Sep 2007 02:35:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <marcelo@kvack.org>
Subject: Re: [PATCH] timekeeping: Prevent time going backwards on resume
Message-Id: <20070913023519.2fea026b.akpm@linux-foundation.org>
In-Reply-To: <1189550194.5235.99.camel@chaos>
References: <1189550194.5235.99.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 00:36:34 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> Timekeeping resume adjusts xtime by adding the slept time in seconds and
> resets the reference value of the clock source (clock->cycle_last).
> clock->cycle last is used to calculate the delta between the last xtime
> update and the readout of the clock source in __get_nsec_offset(). xtime
> plus the offset is the current time. The resume code ignores the delta
> which had already elapsed between the last xtime update and the actual
> time of suspend. If the suspend time is short, then we can see time
> going backwards on resume.
> 
> Suspend:
> offs_s = clock->read() - clock->cycle_last;
> now = xtime + offs_s;
> timekeeping_suspend_time = read_rtc();
> 
> Resume:
> sleep_time = read_rtc() - timekeeping_suspend_time;
> xtime.tv_sec += sleep_time;
> clock->cycle_last = clock->read();
> offs_r = clock->read() - clock->cycle_last;
> now = xtime + offs_r;
> 
> if sleep_time_seconds == 0 and offs_r < offs_s, then time goes
> backwards.
> 
> Fix this by storing the offset from the last xtime update and add it to
> xtime during resume, when we reset clock->cycle_last:
> 
> sleep_time = read_rtc() - timekeeping_suspend_time;
> xtime.tv_sec += sleep_time;
> xtime += offs_s;	/* Fixup xtime offset at suspend time */
> clock->cycle_last = clock->read();
> offs_r = clock->read() - clock->cycle_last;
> now = xtime + offs_r;
> 
> Thanks to Marcelo for tracking this down on the OLPC and providing the
> necessary details to analyze the root cause.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -280,6 +280,8 @@ void __init timekeeping_init(void)
>  static int timekeeping_suspended;
>  /* time in seconds when suspend began */
>  static unsigned long timekeeping_suspend_time;
> +/* xtime offset when we went into suspend */
> +static s64 timekeeping_suspend_offset;
>  
>  /**
>   * timekeeping_resume - Resumes the generic timekeeping subsystem.
> @@ -305,6 +307,8 @@ static int timekeeping_resume(struct sys_device *dev)
>  		wall_to_monotonic.tv_sec -= sleep_length;
>  		total_sleep_time += sleep_length;
>  	}
> +	/* Make sure that we have the correct xtime reference */
> +	timespec_add_ns(&xtime, timekeeping_suspend_offset);
>  	/* re-base the last cycle value */
>  	clock->cycle_last = clocksource_read(clock);
>  	clock->error = 0;
> @@ -326,6 +330,8 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
>  	unsigned long flags;
>  
>  	write_seqlock_irqsave(&xtime_lock, flags);
>  	timekeeping_suspended = 1;
> +	/* Get the current xtime offset */
> +	timekeeping_suspend_offset = __get_nsec_offset();
>  	timekeeping_suspend_time = read_persistent_clock();
>  	write_sequnlock_irqrestore(&xtime_lock, flags);
> 

kernel/time/timekeeping.c: In function 'timekeeping_suspend':
kernel/time/timekeeping.c:335: error: implicit declaration of function '__get_nsec_offset'

sparc32, and presumably anything with CONFIG_GENERIC_TIME=n


