Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbYBGXYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbYBGXYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbYBGXYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:24:09 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56146 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756471AbYBGXYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:24:08 -0500
X-Sasl-enc: GWlN8ryqdttUxi0YA1hm/7arHRqnlj/QNm6n1DVr5mNX 1202426635
Date: Thu, 7 Feb 2008 21:23:09 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: disable triggers on brightness set
Message-ID: <20080207232309.GA2041@khazad-dum.debian.net>
References: <1202380503.9519.21.camel@dax.rpnet.com> <20080207213845.GA27862@khazad-dum.debian.net> <1202422388.9519.123.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1202422388.9519.123.camel@dax.rpnet.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable any active triggers when someone writes to the brightness attribute.
This fixes also a misbehaviour with hardware accelerated flashing.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Márton Németh <nm127@freemail.hu>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c    |    2 ++
 drivers/leds/led-triggers.c |   12 +++++++++---
 drivers/leds/leds.h         |    2 ++
 3 files changed, 13 insertions(+), 3 deletions(-)

The led class is not even close to checkpath-clean, so I have followed the
led class style instead of the kernel style.  You'll probably have to fix
the style of the entire stuff under drivers/leds/ eventually.

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 64c66b3..835f939 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -51,6 +51,8 @@ static ssize_t led_brightness_store(struct device *dev,
 
 	if (count == size) {
 		ret = count;
+
+		led_trigger_remove(led_cdev);
 		led_set_brightness(led_cdev, state);
 	}
 
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 13c9026..21dd969 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -45,9 +45,7 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 		trigger_name[len - 1] = '\0';
 
 	if (!strcmp(trigger_name, "none")) {
-		down_write(&led_cdev->trigger_lock);
-		led_trigger_set(led_cdev, NULL);
-		up_write(&led_cdev->trigger_lock);
+		led_trigger_remove(led_cdev);
 		return count;
 	}
 
@@ -139,6 +137,13 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 	led_cdev->trigger = trigger;
 }
 
+void led_trigger_remove(struct led_classdev *led_cdev)
+{
+	down_write(&led_cdev->trigger_lock);
+	led_trigger_set(led_cdev, NULL);
+	up_write(&led_cdev->trigger_lock);
+}
+
 void led_trigger_set_default(struct led_classdev *led_cdev)
 {
 	struct led_trigger *trig;
@@ -231,6 +236,7 @@ void led_trigger_unregister_simple(struct led_trigger *trigger)
 
 /* Used by LED Class */
 EXPORT_SYMBOL_GPL(led_trigger_set);
+EXPORT_SYMBOL_GPL(led_trigger_remove);
 EXPORT_SYMBOL_GPL(led_trigger_set_default);
 EXPORT_SYMBOL_GPL(led_trigger_show);
 EXPORT_SYMBOL_GPL(led_trigger_store);
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index 12b6fe9..b618256 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -34,9 +34,11 @@ extern struct list_head leds_list;
 void led_trigger_set_default(struct led_classdev *led_cdev);
 void led_trigger_set(struct led_classdev *led_cdev,
 			struct led_trigger *trigger);
+void led_trigger_remove(struct led_classdev *led_cdev);
 #else
 #define led_trigger_set_default(x) do {} while(0)
 #define led_trigger_set(x, y) do {} while(0)
+#define led_trigger_remove(x) do {} while(0)
 #endif
 
 ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
-- 
1.5.3.8

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
