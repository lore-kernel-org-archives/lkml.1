Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbXEIQEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbXEIQEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbXEIQEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:04:33 -0400
Received: from mail.z-net.ru ([89.113.80.10]:3241 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbXEIQEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:04:31 -0400
Date: Wed, 9 May 2007 20:03:28 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: kogiidena@eggplant.ddo.jp, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
Message-ID: <20070509160328.GA13640@zarina>
Reply-To: cbou@mail.ru
References: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp> <1178628889.6061.33.camel@localhost.localdomain> <2490.192.168.1.10.1178720780.squirrel@eggplant.ddo.jp> <1178723594.6291.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1178723594.6291.21.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 04:13:14PM +0100, Richard Purdie wrote:
> On Wed, 2007-05-09 at 23:26 +0900, kogiidena wrote:
> > Hi Richard-san
> > 
> > The following three points were corrected.
> > 
> > 1.
> > > You can't do this since the trigger will appear for all LEDs and it only
> > > applies to a single LED. There has been previous discussion of LED
> > > specific triggers and we'll need that support before you can make
> > > something like this work. Nobody has sent me a patch for that yet and I
> > > haven't had time to write one...
> > The trigger name past "disk" was changed to the name "hard".
> > This is to mean the hardware of LANDISK controls LED.
> > The problem of "LED specific triggers" is solved.
> 
> No, its not solved.
> 
> Imagine I connect some device with its own LEDs and LED drivers. I'll
> use "corgi:amber" as an example.
> 
> I run:
> 
> 'cat /sys/class/leds/corgi:amber/triggers'
> 
> I see "hard" listed.
> 
> 'echo "hard" > /sys/class/leds/corgi:amber/triggers'
> 
> doesn't work though...
> 
> If its not going to work, it shouldn't be listed.
> 
> Regards,
> 
> Richard

Following patch sitting for a long time in our handhelds.org tree.

kogiidena, I'm almost sure you'll find it useful, just apply patch,
and implement .is_led_supported function for your trigger, which will
eliminate trigger showing in
/sys/class/leds/LED_WHICH_NOT_SUPPORTS_CUSTOM_TRIGGER/triggers


- - - - -

Custom triggers support, which are might not supported by all LEDs
    
Signed-off-by: Anton Vorontsov <cbou@mail.ru>

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 454fb09..0af0d61 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -53,6 +53,9 @@ ssize_t led_trigger_store(struct class_device *dev, const char *buf,
 	read_lock(&triggers_list_lock);
 	list_for_each_entry(trig, &trigger_list, next_trig) {
 		if (!strcmp(trigger_name, trig->name)) {
+			if (trig->is_led_supported &&
+			    !trig->is_led_supported(led_cdev)) break;
+
 			write_lock(&led_cdev->trigger_lock);
 			led_trigger_set(led_cdev, trig);
 			write_unlock(&led_cdev->trigger_lock);
@@ -85,6 +88,8 @@ ssize_t led_trigger_show(struct class_device *dev, char *buf)
 		if (led_cdev->trigger && !strcmp(led_cdev->trigger->name,
 							trig->name))
 			len += sprintf(buf+len, "[%s] ", trig->name);
+		else if (trig->is_led_supported &&
+			 !trig->is_led_supported(led_cdev)) continue;
 		else
 			len += sprintf(buf+len, "%s ", trig->name);
 	}
@@ -127,6 +132,7 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 			led_cdev->trigger->deactivate(led_cdev);
 		led_set_brightness(led_cdev, LED_OFF);
 	}
+	led_cdev->trigger = trigger;
 	if (trigger) {
 		write_lock_irqsave(&trigger->leddev_list_lock, flags);
 		list_add_tail(&led_cdev->trig_list, &trigger->led_cdevs);
@@ -134,7 +140,6 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 		if (trigger->activate)
 			trigger->activate(led_cdev);
 	}
-	led_cdev->trigger = trigger;
 }
 
 void led_trigger_set_default(struct led_classdev *led_cdev)
@@ -171,7 +176,9 @@ int led_trigger_register(struct led_trigger *trigger)
 	list_for_each_entry(led_cdev, &leds_list, node) {
 		write_lock(&led_cdev->trigger_lock);
 		if (!led_cdev->trigger && led_cdev->default_trigger &&
-			    !strcmp(led_cdev->default_trigger, trigger->name))
+			   !strcmp(led_cdev->default_trigger, trigger->name) &&
+			   (!trigger->is_led_supported ||
+			    trigger->is_led_supported(led_cdev)))
 			led_trigger_set(led_cdev, trigger);
 		write_unlock(&led_cdev->trigger_lock);
 	}
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 88afcef..71175f6 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -70,6 +70,7 @@ struct led_trigger {
 	const char	 *name;
 	void		(*activate)(struct led_classdev *led_cdev);
 	void		(*deactivate)(struct led_classdev *led_cdev);
+	int		(*is_led_supported)(struct led_classdev *led_cdev);
 
 	/* LEDs under control by this trigger (for simple triggers) */
 	rwlock_t	  leddev_list_lock;
