Return-Path: <linux-kernel-owner+w=401wt.eu-S938113AbXHIHRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938113AbXHIHRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXHIHRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:17:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60636 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbXHIHRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:17:43 -0400
Date: Thu, 9 Aug 2007 00:16:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] msleep() with hrtimers
Message-Id: <20070809001640.ec2f3bfb.akpm@linux-foundation.org>
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

This failed the Vaio test.  I guess it triggered a USB bug.

With this patch applied, when I hotplug my wireless mouse, the little LED
on the mouse comes on for a second or so then goes out and no pointy clicky
for me.

It says:

[  152.481522] usb 1-1: new low speed USB device using uhci_hcd and address 2


Without this patch applied, I get

[  195.935445] usb 2-1: new low speed USB device using uhci_hcd and address 2
[  196.116183] usb 2-1: configuration #1 chosen from 1 choice
[  196.198362] input: Microsoft Microsoft Wireless Optical Mouse 1.00 as /class/input/input7
[  196.223724] input: USB HID v1.11 Mouse [Microsoft Microsoft Wireless Optical Mouse 1.00] on usb-0000:00:1d.1-1
[  196.224570] usb 2-1: new device found, idVendor=045e, idProduct=00e1
[  196.224579] usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
[  196.224585] usb 2-1: Product: Microsoft Wireless Optical Mouse 1.00
[  196.224590] usb 2-1: Manufacturer: Microsoft

and lots of pointy clickiness.

I would assume that there is some msleep() in USB which is too short, and
the present wild rounding-up which msleep() does covered up the
incorrectly-chosen sleep duration.

I'm using HZ=250 (http://userweb.kernel.org/~akpm/config-sony.txt) and it
could well be that the mouse would fail just by going to HZ=1000, but I
didn't bother testing that.

Could one of the USB developers please suggest which msleep()(s) I should
start looking at?

Thanks.
