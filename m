Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYFXVD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYFXVD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYFXVDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:03:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754869AbYFXVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:03:17 -0400
Date: Tue, 24 Jun 2008 14:02:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH] leds: make sure led->trigger is valid before calling
 trigger->activate
Message-Id: <20080624140235.ef3f4d52.akpm@linux-foundation.org>
In-Reply-To: <20080619114847.GA13752@doriath.ww600.siemens.net>
References: <20080619114847.GA13752@doriath.ww600.siemens.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 15:48:47 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  drivers/leds/led-triggers.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index 0f242b3..f910eaf 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -111,16 +111,17 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
>  			flags);
>  		if (led_cdev->trigger->deactivate)
>  			led_cdev->trigger->deactivate(led_cdev);
> +		led_cdev->trigger = NULL;
>  		led_set_brightness(led_cdev, LED_OFF);
>  	}
>  	if (trigger) {
>  		write_lock_irqsave(&trigger->leddev_list_lock, flags);
>  		list_add_tail(&led_cdev->trig_list, &trigger->led_cdevs);
>  		write_unlock_irqrestore(&trigger->leddev_list_lock, flags);
> +		led_cdev->trigger = trigger;
>  		if (trigger->activate)
>  			trigger->activate(led_cdev);
>  	}
> -	led_cdev->trigger = trigger;
>  }
>  EXPORT_SYMBOL_GPL(led_trigger_set);
>  

The changelog tells us what the patch does, but it doesn't tell us
why it does it.

This matters.  For a start, there is no way in which I (at least)
am able to determine whether this change is needed in 2.6.26 nor
in 2.6.25.x.
