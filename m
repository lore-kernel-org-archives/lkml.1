Return-Path: <linux-kernel-owner+w=401wt.eu-S1161600AbXD3AG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161600AbXD3AG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161602AbXD3AG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:06:57 -0400
Received: from neon.samage.net ([85.17.153.66]:53371 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161600AbXD3AG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:06:56 -0400
Message-ID: <1497.81.207.0.53.1177891613.squirrel@secure.samage.net>
In-Reply-To: <1177874733.5791.137.camel@localhost.localdomain>
References: <4655.81.207.0.53.1177863612.squirrel@secure.samage.net>
    <1177874733.5791.137.camel@localhost.localdomain>
Date: Mon, 30 Apr 2007 02:06:53 +0200 (CEST)
Subject: Re: [2.6.21] BUG: clocksource_watchdog isn't reset after resume
From: "Indan Zupancic" <indan@nul.nu>
To: tglx@linutronix.de
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: be1ed956250a6aced2eef8025a824392
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, April 29, 2007 21:25, Thomas Gleixner wrote:
> --- linux-2.6.orig/kernel/time/tick-common.c
> +++ linux-2.6/kernel/time/tick-common.c
> @@ -308,16 +308,20 @@ static void tick_suspend(void)
>  	spin_unlock_irqrestore(&tick_device_lock, flags);
>  }
>
> -static void tick_resume(void)
> +static void tick_resume(int broadcast)
>  {
>  	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
>  	unsigned long flags;
>
>  	spin_lock_irqsave(&tick_device_lock, flags);
> -	if (td->mode == TICKDEV_MODE_PERIODIC)
> -		tick_setup_periodic(td->evtdev, 0);
> -	else
> -		tick_resume_oneshot();
> +	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
> +
> +	if (!broadcast) {
> +		if (td->mode == TICKDEV_MODE_PERIODIC)
> +			tick_setup_periodic(td->evtdev, 0);
> +		else
> +			tick_resume_oneshot();
> +	}
>  	spin_unlock_irqrestore(&tick_device_lock, flags);
>  }
>
> @@ -327,6 +331,8 @@ static void tick_resume(void)
>  static int tick_notify(struct notifier_block *nb, unsigned long reason,
>  			       void *dev)
>  {
> +	int res;
> +
>  	switch (reason) {
>
>  	case CLOCK_EVT_NOTIFY_ADD:
> @@ -354,8 +360,8 @@ static int tick_notify(struct notifier_b
>  		break;
>
>  	case CLOCK_EVT_NOTIFY_RESUME:
> -		if (!tick_resume_broadcast())
> -			tick_resume();
> +		res = tick_resume_broadcast();
> +		tick_resume(res);
>  		break;

What about moving the tick_resume_broadcast() check into tick_resume() and
removing the parameter again? Something like the below:


--- tick-common.c	2007-04-30 01:45:19.000000000 +0200
+++ tick-common.c.iz	2007-04-30 01:45:14.000000000 +0200
@@ -308,7 +308,7 @@ static void tick_suspend(void)
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }

-static void tick_resume(int broadcast)
+static void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	unsigned long flags;
@@ -316,7 +316,7 @@ static void tick_resume(int broadcast)
 	spin_lock_irqsave(&tick_device_lock, flags);
 	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);

-	if (!broadcast) {
+	if (!tick_resume_broadcast()) {
 		if (td->mode == TICKDEV_MODE_PERIODIC)
 			tick_setup_periodic(td->evtdev, 0);
 		else
@@ -360,8 +360,7 @@ static int tick_notify(struct notifier_b
 		break;

 	case CLOCK_EVT_NOTIFY_RESUME:
-		res = tick_resume_broadcast();
-		tick_resume(res);
+		tick_resume();
 		break;

 	default:


