Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbXENT7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbXENT7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbXENT64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:58:56 -0400
Received: from mx2-2.mail.ru ([194.67.23.122]:6906 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755300AbXENT6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:58:55 -0400
Date: Mon, 14 May 2007 23:56:51 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: kogiidena@eggplant.ddo.jp, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
Message-ID: <20070514195651.GA26554@zarina>
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
> > Following patch sitting for a long time in our handhelds.org tree.
> > 
> > kogiidena, I'm almost sure you'll find it useful, just apply patch,
> > and implement .is_led_supported function for your trigger, which will
> > eliminate trigger showing in
> > /sys/class/leds/LED_WHICH_NOT_SUPPORTS_CUSTOM_TRIGGER/triggers
> 
> I like the approach and will apply something like this.

Splendid!

> Comments
> follow..
...
> Missing newline.
... 
> ditto.

Thanks, fixed.

> Thanks,
> 
> Richard


From: Anton Vorontsov <cbou@mail.ru>
Date: Mon, 14 May 2007 23:39:30 +0400
Subject: [PATCH] Custom triggers support, which are might not supported by all LEDs

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/leds/led-triggers.c |   11 ++++++++++-
 include/linux/leds.h        |    1 +
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 454fb09..7fde7d0 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -53,6 +53,10 @@ ssize_t led_trigger_store(struct class_device *dev, const char *buf,
 	read_lock(&triggers_list_lock);
 	list_for_each_entry(trig, &trigger_list, next_trig) {
 		if (!strcmp(trigger_name, trig->name)) {
+			if (trig->is_led_supported &&
+			    !trig->is_led_supported(led_cdev))
+				break;
+
 			write_lock(&led_cdev->trigger_lock);
 			led_trigger_set(led_cdev, trig);
 			write_unlock(&led_cdev->trigger_lock);
@@ -85,6 +89,9 @@ ssize_t led_trigger_show(struct class_device *dev, char *buf)
 		if (led_cdev->trigger && !strcmp(led_cdev->trigger->name,
 							trig->name))
 			len += sprintf(buf+len, "[%s] ", trig->name);
+		else if (trig->is_led_supported &&
+			 !trig->is_led_supported(led_cdev))
+			continue;
 		else
 			len += sprintf(buf+len, "%s ", trig->name);
 	}
@@ -171,7 +178,9 @@ int led_trigger_register(struct led_trigger *trigger)
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
-- 
1.5.1.1-dirty

