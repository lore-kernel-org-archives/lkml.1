Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZCUAJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZCUAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 20:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbZCUAJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 20:09:46 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:50532 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbZCUAJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 20:09:44 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] p54: fix SoftLED compile dependencies
Date: Sat, 21 Mar 2009 00:57:46 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.29-rc8-wl; KDE/4.2.1; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au> <49C293CC.6020009@oracle.com> <200903191955.00718.mb@bu3sch.de>
In-Reply-To: <200903191955.00718.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903210057.47067.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/wBhnreGcmWXYWuhsF+VvN9mKo99rKALzSIYKh
	SExvg7jCHTTmeBYX5AsgPHEUERJ2IqpAU4YCvwbY/kASeAfvNp
	UN/0o2/jw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compile problem when the MAC80211_LEDS
triggers are enabled but not LED class itself. 
(which is sort of pointless, but anyway...)

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
mb, thank you for the tips!

Randy Dunlap can you please give this patch a try?

John, do you know where the patch form 
Geert Uytterhoeven <geert@linux-m68k.org> went?
---
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index 0e344ac..ee1aaca 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -1,9 +1,10 @@
 config P54_COMMON
 	tristate "Softmac Prism54 support"
-	depends on MAC80211 && WLAN_80211 && FW_LOADER && EXPERIMENTAL
+	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select FW_LOADER
 	---help---
-	  This is common code for isl38xx based cards.
-	  This module does nothing by itself - the USB/PCI frontends
+	  This is common code for isl38xx/stlc45xx based modules.
+	  This module does nothing by itself - the USB/PCI/SPI frontends
 	  also need to be enabled in order to support any devices.
 
 	  These devices require softmac firmware which can be found at
@@ -17,31 +18,6 @@ config P54_USB
 	select CRC32
 	---help---
 	  This driver is for USB isl38xx based wireless cards.
-	  These are USB based adapters found in devices such as:
-
-	  3COM 3CRWE254G72
-	  SMC 2862W-G
-	  Accton 802.11g WN4501 USB
-	  Siemens Gigaset USB
-	  Netgear WG121
-	  Netgear WG111
-	  Medion 40900, Roper Europe
-	  Shuttle PN15, Airvast WM168g, IOGear GWU513
-	  Linksys WUSB54G
-	  Linksys WUSB54G Portable
-	  DLink DWL-G120 Spinnaker
-	  DLink DWL-G122
-	  Belkin F5D7050 ver 1000
-	  Cohiba Proto board
-	  SMC 2862W-G version 2
-	  U.S. Robotics U5 802.11g Adapter
-	  FUJITSU E-5400 USB D1700
-	  Sagem XG703A
-	  DLink DWL-G120 Cohiba
-	  Spinnaker Proto board
-	  Linksys WUSB54AG
-	  Inventel UR054G
-	  Spinnaker DUT
 
 	  These devices require softmac firmware which can be found at
 	  http://prism54.org/
@@ -71,3 +47,8 @@ config P54_SPI
 	  Nokia's N800/N810 Portable Internet Tablet.
 
 	  If you choose to build a module, it'll be called p54spi.
+
+config P54_LEDS
+	bool
+	depends on P54_COMMON && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = P54_COMMON)
+	default y
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 0a98983..0c1b057 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -21,9 +21,9 @@
 #include <linux/etherdevice.h>
 
 #include <net/mac80211.h>
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_P54_LEDS
 #include <linux/leds.h>
-#endif /* CONFIG_MAC80211_LEDS */
+#endif /* CONFIG_P54_LEDS */
 
 #include "p54.h"
 #include "p54common.h"
@@ -2420,7 +2420,7 @@ static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 	return 0;
 }
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_P54_LEDS
 static void p54_led_brightness_set(struct led_classdev *led_dev,
 				   enum led_brightness brightness)
 {
@@ -2508,7 +2508,7 @@ static void p54_unregister_leds(struct ieee80211_hw *dev)
 	if (priv->assoc_led.registered)
 		led_classdev_unregister(&priv->assoc_led.led_dev);
 }
-#endif /* CONFIG_MAC80211_LEDS */
+#endif /* CONFIG_P54_LEDS */
 
 static const struct ieee80211_ops p54_ops = {
 	.tx			= p54_tx,
@@ -2592,11 +2592,11 @@ int p54_register_common(struct ieee80211_hw *dev, struct device *pdev)
 		return err;
 	}
 
-	#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_P54_LEDS
 	err = p54_init_leds(dev);
 	if (err)
 		return err;
-	#endif /* CONFIG_MAC80211_LEDS */
+#endif /* CONFIG_P54_LEDS */
 
 	dev_info(pdev, "is registered as '%s'\n", wiphy_name(dev->wiphy));
 	return 0;
@@ -2610,9 +2610,9 @@ void p54_free_common(struct ieee80211_hw *dev)
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
 
-	#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_P54_LEDS
 	p54_unregister_leds(dev);
-	#endif /* CONFIG_MAC80211_LEDS */
+#endif /* CONFIG_P54_LEDS */
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
 
