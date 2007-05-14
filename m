Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbXENUPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbXENUPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbXENUO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:14:58 -0400
Received: from mx34.mail.ru ([194.67.23.200]:30317 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754392AbXENUO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:14:58 -0400
Date: Tue, 15 May 2007 00:12:56 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: kogiidena@eggplant.ddo.jp, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
Message-ID: <20070514201256.GB26554@zarina>
Reply-To: cbou@mail.ru
References: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp> <1178628889.6061.33.camel@localhost.localdomain> <2490.192.168.1.10.1178720780.squirrel@eggplant.ddo.jp> <1178723594.6291.21.camel@localhost.localdomain> <20070509160328.GA13640@zarina> <1179098182.5883.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1179098182.5883.31.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 12:16:22AM +0100, Richard Purdie wrote:
> On Wed, 2007-05-09 at 20:03 +0400, Anton Vorontsov wrote:
> > +	led_cdev->trigger = trigger;
> >  	if (trigger) {
> >  		write_lock_irqsave(&trigger->leddev_list_lock, flags);
> >  		list_add_tail(&led_cdev->trig_list, &trigger->led_cdevs);
> > @@ -134,7 +140,6 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
> >  		if (trigger->activate)
> >  			trigger->activate(led_cdev);
> >  	}
> > -	led_cdev->trigger = trigger;
> >  }
> >  
> >  void led_trigger_set_default(struct led_classdev *led_cdev)
> 
> Why was the above was changed?
> 
> I think we've discussed this before

Yup.

> and it would be better to add a
> trigger parameter to activate/deactivate if we really need it.

Well.. Passing trigger parameter to activate/deactivate function is not
only purpose of that patch...


From: Anton Vorontsov <cbou@mail.ru>
Date: Mon, 14 May 2007 23:49:09 +0400
Subject: [PATCH] Attach trigger to LED prior calling activate function.

This change needed for two purposes:

1. When somebody sets trigger, and that trigger would setup
   brightness in its activate() function, and led driver would check
   if that trigger supported (used by hwtimer trigger and drivers
   supporting hw blinking LEDs, not in mainline yet).

2. If trigger would access itself through led_cdev in its activate()
   function.

Pros of that patch:

1. Just sane to do;
2. Trivial;
3. Can't break anything;
4. No new code, just one line movement.

Cons of applying that patch:

1. No mainline kernel user, but offshores.

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/leds/led-triggers.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 7fde7d0..d3ab5d0 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -134,6 +134,7 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 			led_cdev->trigger->deactivate(led_cdev);
 		led_set_brightness(led_cdev, LED_OFF);
 	}
+	led_cdev->trigger = trigger;
 	if (trigger) {
 		write_lock_irqsave(&trigger->leddev_list_lock, flags);
 		list_add_tail(&led_cdev->trig_list, &trigger->led_cdevs);
@@ -141,7 +142,6 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 		if (trigger->activate)
 			trigger->activate(led_cdev);
 	}
-	led_cdev->trigger = trigger;
 }
 
 void led_trigger_set_default(struct led_classdev *led_cdev)
-- 
1.5.1.1-dirty

