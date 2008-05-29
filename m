Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbYE2DRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbYE2DRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYE2DRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:17:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398AbYE2DRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:17:38 -0400
Date: Wed, 28 May 2008 20:16:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] NTP: Let update_persistent_clock() sleep
Message-Id: <20080528201612.d2641dc3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.55.0805281856200.29522@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805281856200.29522@cliff.in.clinika.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 19:15:41 +0100 (BST) "Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  This is a change that makes the 11-minute RTC update be run in the
> process context.  This is so that update_persistent_clock() can sleep,
> which may be required for certain types of RTC hardware -- most notably
> I2C devices.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
> Hello,
> 
>  After the initial enthusiasm, I am not sure how my series of patches to
> let read_persistent_clock() and update_persistent_clock() use the class
> RTC subsystem is going to be handled.  As keeping the order of patches is 
> required to avoid breakage in various places, I will try to coordinate the 
> changes and submit them one by one as the dependencies get satisfied.  I 
> hope this is OK and will take less than half a year. ;)
> 
>  Given this one applies to generic code and is required by all the other
> changes, while not requiring anything and not meant to break anything, ;) 
> I think this is ready to go.  It may be worth testing that moving the 
> function into the process context does not cause any regressions for some 
> obscure configuration.
> 
>  I am not sure who actually claims maintenance of kernel/time/ntp.c, but
> it looks, Thomas, you seem to be our current time overseer -- could you
> please speak out on this change?  I'd like this change to get applied
> somewhere reasonable -- is it -mm?

Roman does most of the NTP work afaik.  I consider Thomas's git-hrt
tree to be the route via which NTP changes get into linux-next and
mainline.

> patch-2.6.26-rc1-20080505-sync-cmos-work-0
> diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/kernel/time/ntp.c linux-2.6.26-rc1-20080505/kernel/time/ntp.c
> --- linux-2.6.26-rc1-20080505.macro/kernel/time/ntp.c	2008-05-05 02:56:03.000000000 +0000
> +++ linux-2.6.26-rc1-20080505/kernel/time/ntp.c	2008-05-05 21:10:50.000000000 +0000
> @@ -3,6 +3,8 @@
>   *
>   * NTP state machine interfaces and logic.
>   *
> + * Copyright (c) 2008  Maciej W. Rozycki
> + *
>   * This code was mainly moved from kernel/timer.c and kernel/time.c
>   * Please see those files for relevant copyright info and historical
>   * changelogs.
> @@ -17,6 +19,7 @@
>  #include <linux/capability.h>
>  #include <linux/math64.h>
>  #include <linux/clocksource.h>
> +#include <linux/workqueue.h>
>  #include <asm/timex.h>
>  
>  /*
> @@ -218,11 +221,13 @@ void second_overflow(void)
>  /* Disable the cmos update - used by virtualization and embedded */
>  int no_sync_cmos_clock  __read_mostly;
>  
> -static void sync_cmos_clock(unsigned long dummy);
> +static void sync_cmos_clock(unsigned long data);
> +static void do_sync_cmos_clock(struct work_struct *work);
>  
>  static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
> +static DECLARE_WORK(sync_cmos_work, do_sync_cmos_clock);
>  
> -static void sync_cmos_clock(unsigned long dummy)
> +static void do_sync_cmos_clock(struct work_struct *work)
>  {
>  	struct timespec now, next;
>  	int fail = 1;
> @@ -261,6 +266,12 @@ static void sync_cmos_clock(unsigned lon
>  	mod_timer(&sync_cmos_timer, jiffies + timespec_to_jiffies(&next));
>  }
>  
> +static void sync_cmos_clock(unsigned long data)
> +{
> +	/* Some implementations of update_persistent_clock() may sleep.  */
> +	schedule_work(&sync_cmos_work);
> +}
> +
>  static void notify_cmos_timer(void)
>  {
>  	if (!no_sync_cmos_clock)

OK, that timer code in there now officially makes my brain hurt.

Is it as simple as it could be?

Would schedule_delayed_work() make my brain feel better?

