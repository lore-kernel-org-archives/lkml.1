Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbXK1Kab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbXK1Kab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbXK1KaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:30:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756805AbXK1KaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:30:21 -0500
Date: Wed, 28 Nov 2007 02:29:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] msleep() with hrtimers
Message-Id: <20071128022949.be8d925f.akpm@linux-foundation.org>
In-Reply-To: <15327.1186166232@lwn.net>
References: <15327.1186166232@lwn.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 12:37:12 -0600 Jonathan Corbet <corbet@lwn.net> wrote:

> Here's the second (and probably final) posting of the msleep() with
> hrtimers patch.  The problem being addressed here is that the current
> msleep() will stop for a minimum of two jiffies, meaning that, on a
> HZ=100 system, msleep(1) delays for for about 20ms.  In a driver with
> one such delay for each of 150 or so register setting operations, the
> extra time adds up to a few seconds.
> 
> This patch addresses the situation by using hrtimers.  On tickless
> systems with working timers, msleep(1) now sleeps for 1ms, even with
> HZ=100.
> 
> Most comments last time were favorable.  The one dissenter was Roman,
> who worries about the overhead of using hrtimers for this operation; my
> understanding is that he would rather see a really_msleep() function for
> those who actually want millisecond resolution.  I'm not sure how to
> characterize what the cost could be, but it can only be buried by the
> fact that every call sleeps for some number of milliseconds.  On my
> system, the several hundred total msleep() calls can't cause any real
> overhead, and almost all happen at initialization time.
> 
> I still think it would be useful for msleep() to do what it says it does
> and not vastly oversleep with small arguments.  A quick grep turns up
> 450 msleep(1) calls in the current mainline.  Andrew, if you agree, can
> you drop this into -mm?  If not, I guess I'll let it go.
> 
> jon
> 
> ---
> 
> Use hrtimers so that msleep() sleeps for the requested time
> 
> Current msleep() snoozes for at least two jiffies, causing msleep(1) to
> sleep for at least 20ms on HZ=100 systems.  Using hrtimers allows
> msleep() to sleep for something much closer to the requested time.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> 
> --- 2.6.23-rc1/kernel/timer.c.orig	2007-08-02 13:45:20.000000000 -0600
> +++ 2.6.23-rc1/kernel/timer.c	2007-08-03 12:34:48.000000000 -0600
> @@ -1349,18 +1349,43 @@ void __init init_timers(void)
>  	open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
>  }
>  
> +
> +
> +
> +static void do_msleep(unsigned int msecs, struct hrtimer_sleeper *sleeper,
> +	int sigs)
> +{
> +	enum hrtimer_mode mode = HRTIMER_MODE_REL;
> +	int state = sigs ? TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE;
> +
> +	/*
> +	 * This is really just a reworked and simplified version
> +	 * of do_nanosleep().
> +	 */
> +	hrtimer_init(&sleeper->timer, CLOCK_MONOTONIC, mode);
> +	sleeper->timer.expires = ktime_set(0, msecs*NSEC_PER_MSEC);
> +	hrtimer_init_sleeper(sleeper, current);
> +
> +	do {
> +		set_current_state(state);
> +		hrtimer_start(&sleeper->timer, sleeper->timer.expires, mode);
> +		if (sleeper->task)
> +			schedule();
> +		hrtimer_cancel(&sleeper->timer);
> +		mode = HRTIMER_MODE_ABS;
> +	} while (sleeper->task && !(sigs && signal_pending(current)));
> +}
> +
>  /**
>   * msleep - sleep safely even with waitqueue interruptions
>   * @msecs: Time in milliseconds to sleep for
>   */
>  void msleep(unsigned int msecs)
>  {
> -	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
> +	struct hrtimer_sleeper sleeper;
>  
> -	while (timeout)
> -		timeout = schedule_timeout_uninterruptible(timeout);
> +	do_msleep(msecs, &sleeper, 0);
>  }
> -
>  EXPORT_SYMBOL(msleep);
>  
>  /**
> @@ -1369,11 +1394,15 @@ EXPORT_SYMBOL(msleep);
>   */
>  unsigned long msleep_interruptible(unsigned int msecs)
>  {
> -	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
> +	struct hrtimer_sleeper sleeper;
> +	ktime_t left;
>  
> -	while (timeout && !signal_pending(current))
> -		timeout = schedule_timeout_interruptible(timeout);
> -	return jiffies_to_msecs(timeout);
> -}
> +	do_msleep(msecs, &sleeper, 1);
>  
> +	if (!sleeper.task)
> +		return 0;
> +	left = ktime_sub(sleeper.timer.expires,
> +			 sleeper.timer.base->get_time());
> +	return max(((long) ktime_to_ns(left))/NSEC_PER_MSEC, 1L);
> +}
>  EXPORT_SYMBOL(msleep_interruptible);

This patch (which appears to have got stranded in Thomas's git-hrt tree)
breaks hotplugging of the wireless mouse on my Vaio.

Kinda strange - sometimes things come up and work but more often the
machine simply fails to notice that the mouse was plugged in at all.

It could be a bug in USB...

<gets a sinking feeling>

<looks down-thread>

ah shit, I already reported this bug on August 9 and I just spent an hour
and a half re-finding it.  Thanks, guys.

Anyway, here's a fix which doesn't fix it:


- Don't return from msleep() in state TASK_[UN]INTERRUPTIBLE

- Someone seems to have fallen asleep on the enter key.  Fix.

--- a/kernel/timer.c~git-hrt-fix
+++ a/kernel/timer.c
@@ -1347,7 +1347,6 @@ static struct notifier_block __cpuinitda
 	.notifier_call	= timer_cpu_notify,
 };
 
-
 void __init init_timers(void)
 {
 	int err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
@@ -1360,9 +1359,6 @@ void __init init_timers(void)
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
 }
 
-
-
-
 static void do_msleep(unsigned int msecs, struct hrtimer_sleeper *sleeper,
 	int sigs)
 {
@@ -1385,6 +1381,7 @@ static void do_msleep(unsigned int msecs
 		hrtimer_cancel(&sleeper->timer);
 		mode = HRTIMER_MODE_ABS;
 	} while (sleeper->task && !(sigs && signal_pending(current)));
+	set_current_state(TASK_RUNNING);
 }
 
 /**
_


I'll revert it.

