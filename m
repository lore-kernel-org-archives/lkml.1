Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYAYAui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYAYAui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYAYAtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:49:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbYAYAtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:49:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 5/5] b43: Avoid unregistering device objects during suspend
Date: Fri, 25 Jan 2008 01:37:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Michael Buesch <mb@bu3sch.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       bcm43xx-dev@lists.berlios.de,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Richard Purdie <rpurdie@rpsys.net>
References: <200801250127.21966.rjw@sisk.pl>
In-Reply-To: <200801250127.21966.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801250137.34275.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Modify the b43 driver to avoid deadlocking suspend and resume,
which happens as a result of attempting to unregister device objects
locked by the PM core during suspend/resume cycles.  Also, make it
use a suspend-safe method of unregistering device object in the
resume error path.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Michael Buesch <mb@bu3sch.de>
---
 drivers/net/wireless/b43/b43.h  |    1 +
 drivers/net/wireless/b43/leds.c |    5 ++++-
 drivers/net/wireless/b43/main.c |   25 ++++++++++++++++---------
 3 files changed, 21 insertions(+), 10 deletions(-)

Index: linux-2.6.24-rc8-mm1/drivers/net/wireless/b43/b43.h
===================================================================
--- linux-2.6.24-rc8-mm1.orig/drivers/net/wireless/b43/b43.h
+++ linux-2.6.24-rc8-mm1/drivers/net/wireless/b43/b43.h
@@ -706,6 +706,7 @@ struct b43_wldev {
 	bool short_preamble;	/* TRUE, if short preamble is enabled. */
 	bool short_slot;	/* TRUE, if short slot timing is enabled. */
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
+	bool suspend_in_progress;	/* TRUE, if we are in a suspend/resume cycle */
 
 	/* PHY/Radio device. */
 	struct b43_phy phy;
Index: linux-2.6.24-rc8-mm1/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.24-rc8-mm1.orig/drivers/net/wireless/b43/main.c
+++ linux-2.6.24-rc8-mm1/drivers/net/wireless/b43/main.c
@@ -2470,10 +2470,10 @@ static int b43_rng_read(struct hwrng *rn
 	return (sizeof(u16));
 }
 
-static void b43_rng_exit(struct b43_wl *wl)
+static void b43_rng_exit(struct b43_wl *wl, bool suspended)
 {
 	if (wl->rng_initialized)
-		hwrng_unregister(&wl->rng);
+		__hwrng_unregister(&wl->rng, suspended);
 }
 
 static int b43_rng_init(struct b43_wl *wl)
@@ -3298,8 +3298,10 @@ static void b43_wireless_core_exit(struc
 		return;
 	b43_set_status(dev, B43_STAT_UNINIT);
 
-	b43_leds_exit(dev);
-	b43_rng_exit(dev->wl);
+	if (!dev->suspend_in_progress) {
+		b43_leds_exit(dev);
+		b43_rng_exit(dev->wl, false);
+	}
 	b43_pio_free(dev);
 	b43_dma_free(dev);
 	b43_chip_exit(dev);
@@ -3420,11 +3422,13 @@ static int b43_wireless_core_init(struct
 	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
-	b43_rng_init(wl);
+	if (!dev->suspend_in_progress)
+		b43_rng_init(wl);
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
-	b43_leds_init(dev);
+	if (!dev->suspend_in_progress)
+		b43_leds_init(dev);
 out:
 	return err;
 
@@ -4024,6 +4028,7 @@ static int b43_suspend(struct ssb_device
 	b43dbg(wl, "Suspending...\n");
 
 	mutex_lock(&wl->mutex);
+	wldev->suspend_in_progress = true;
 	wldev->suspend_init_status = b43_status(wldev);
 	if (wldev->suspend_init_status >= B43_STAT_STARTED)
 		b43_wireless_core_stop(wldev);
@@ -4055,15 +4060,17 @@ static int b43_resume(struct ssb_device 
 	if (wldev->suspend_init_status >= B43_STAT_STARTED) {
 		err = b43_wireless_core_start(wldev);
 		if (err) {
+			b43_leds_exit(wldev);
+			b43_rng_exit(wldev->wl, true);
 			b43_wireless_core_exit(wldev);
 			b43err(wl, "Resume failed at core start\n");
 			goto out;
 		}
 	}
-	mutex_unlock(&wl->mutex);
-
 	b43dbg(wl, "Device resumed.\n");
-      out:
+ out:
+	wldev->suspend_in_progress = false;
+	mutex_unlock(&wl->mutex);
 	return err;
 }
 
Index: linux-2.6.24-rc8-mm1/drivers/net/wireless/b43/leds.c
===================================================================
--- linux-2.6.24-rc8-mm1.orig/drivers/net/wireless/b43/leds.c
+++ linux-2.6.24-rc8-mm1/drivers/net/wireless/b43/leds.c
@@ -116,7 +116,10 @@ static void b43_unregister_led(struct b4
 {
 	if (!led->dev)
 		return;
-	led_classdev_unregister(&led->led_dev);
+	if (led->dev->suspend_in_progress)
+		led_classdev_unregister_suspended(&led->led_dev);
+	else
+		led_classdev_unregister(&led->led_dev);
 	b43_led_turn_off(led->dev, led->index, led->activelow);
 	led->dev = NULL;
 }
