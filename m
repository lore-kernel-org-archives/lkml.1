Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYG0So6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYG0So6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 14:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYG0Sou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 14:44:50 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:39564 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYG0Sot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 14:44:49 -0400
X-Greylist: delayed 816 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jul 2008 14:44:49 EDT
Date: Sun, 27 Jul 2008 20:30:59 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Rod Whitby <rod@whitby.id.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] leds-fsg: Change order of initialization and
 deinitialization
Message-ID: <alpine.LNX.1.10.0807272016570.16340@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -1.0
X-Spam-Bar: -
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 27 Jul 2008 18:31:11 +0000
	Bayes: 0.0443 Tokens: new, 235; hammy, 3; neutral, 4; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0443]
X-Spam-Signature: f809272dd93ab93b4e57af0e166739c126c81f0e
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On initialization, we first do the ioremap and then register the led devices.
On deinitialization, we do it in reverse order. This prevents someone calling
into the brightness_set functions with an invalid latch_address.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Rod Whitby <rod@whitby.id.au>
---
 drivers/leds/leds-fsg.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

I do not own a FSG-3, but it's probably a single CPU device and the chance 
of hitting this race condition is unlikely, but we should do it right 
nontheless. Further looking at the code, we probably also need a lock to 
make changing latch_value fully atomic, but again it is unlikely to hit 
this.

diff --git a/drivers/leds/leds-fsg.c b/drivers/leds/leds-fsg.c
index a7421b8..a26fe36 100644
--- a/drivers/leds/leds-fsg.c
+++ b/drivers/leds/leds-fsg.c
@@ -161,6 +161,16 @@ static int fsg_led_probe(struct platform_device *pdev)
 {
 	int ret;
 
+	/* Map the LED chip select address space */
+	latch_address = (unsigned short *) ioremap(IXP4XX_EXP_BUS_BASE(2), 512);
+	if (!latch_address) {
+		ret = -ENOMEM;
+		goto failremap;
+	}
+
+	latch_value = 0xffff;
+	*latch_address = latch_value;
+
 	ret = led_classdev_register(&pdev->dev, &fsg_wlan_led);
 	if (ret < 0)
 		goto failwlan;
@@ -185,20 +195,8 @@ static int fsg_led_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto failring;
 
-	/* Map the LED chip select address space */
-	latch_address = (unsigned short *) ioremap(IXP4XX_EXP_BUS_BASE(2), 512);
-	if (!latch_address) {
-		ret = -ENOMEM;
-		goto failremap;
-	}
-
-	latch_value = 0xffff;
-	*latch_address = latch_value;
-
 	return ret;
 
- failremap:
-	led_classdev_unregister(&fsg_ring_led);
  failring:
 	led_classdev_unregister(&fsg_sync_led);
  failsync:
@@ -210,14 +208,14 @@ static int fsg_led_probe(struct platform_device *pdev)
  failwan:
 	led_classdev_unregister(&fsg_wlan_led);
  failwlan:
+	iounmap(latch_address);
+ failremap:
 
 	return ret;
 }
 
 static int fsg_led_remove(struct platform_device *pdev)
 {
-	iounmap(latch_address);
-
 	led_classdev_unregister(&fsg_wlan_led);
 	led_classdev_unregister(&fsg_wan_led);
 	led_classdev_unregister(&fsg_sata_led);
@@ -225,6 +223,8 @@ static int fsg_led_remove(struct platform_device *pdev)
 	led_classdev_unregister(&fsg_sync_led);
 	led_classdev_unregister(&fsg_ring_led);
 
+	iounmap(latch_address);
+
 	return 0;
 }
 
