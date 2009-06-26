Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbZFZOAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbZFZOAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbZFZOAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:00:04 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:65349 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbZFZOAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:00:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type:content-id;
        b=OJ+Oyy2hMnRUbX1w2jpQ5bNGCfZz+4dZHmZYX3Pe0NKT20q+Y21lsMAeRetTS3x8Yo
         tRUHX4izapwSfcFWsTf+O/fLjgfmPRyXAUXOMeIixVbDrGK3v20Rd1O9e6ZsNRY9Hc9s
         eszEh5nXjyKRHT5l9U1NhX924FT56TwFXP4KQ=
Date: Fri, 26 Jun 2009 15:59:46 +0200 (CEST)
From: "rubenatch@gmail.com" <rubenatch@gmail.com>
X-X-Sender: root@localhost
To: jkosina@suse.cz
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] HID: Supporting rumble with Thrustmaster Dual Trigger
 3-in-1
Message-ID: <alpine.DEB.2.00.0906261551100.10045@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1881556729-1246024540=:10045"
Content-ID: <alpine.DEB.2.00.0906261555450.10045@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1881556729-1246024540=:10045
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.0906261555451.10045@localhost>

From: Rubén Aós Garralda <rubenatch@gmail.com>

This patch enables rumble in Thrustmaster Dual 3-in-1 trigger gamepads (in 
both PC and PS3 modes). It uses the same code as Thrustmaster FireStorm 
Dual Power 2/3, so it only modifies hid-core.c (to put the devices in the 
"forbidden list" and hid-tmff.c to add the new USB IDs.

---

diff -uprN linux-source-2.6.30/drivers/hid/hid-core.c linux-source-test/drivers/hid/hid-core.c
--- linux-source-2.6.30/drivers/hid/hid-core.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-source-test/drivers/hid/hid-core.c	2009-06-26 15:33:48.000000000 +0200
@@ -1309,6 +1309,8 @@ static const struct hid_device_id hid_bl
  	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED, USB_DEVICE_ID_TOPSEED_CYBERLINK) },
diff -uprN linux-source-2.6.30/drivers/hid/hid-tmff.c linux-source-test/drivers/hid/hid-tmff.c
--- linux-source-2.6.30/drivers/hid/hid-tmff.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-source-test/drivers/hid/hid-tmff.c	2009-06-26 15:35:27.000000000 +0200
@@ -236,7 +236,11 @@ err:
  static const struct hid_device_id tm_devices[] = {
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300),
  		.driver_data = (unsigned long)ff_rumble },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304),
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304),	/* FireStorm Dual Power 2 (and 3)
+		.driver_data = (unsigned long)ff_rumble },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323),	/* Dual Trigger 3-in-1 (PC Mode) */
+		.driver_data = (unsigned long)ff_rumble },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324),	/* Dual Trigger 3-in-1 (PS3 Mode) */
  		.driver_data = (unsigned long)ff_rumble },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651),	/* FGT Rumble Force Wheel */
  		.driver_data = (unsigned long)ff_rumble },
diff -uprN linux-source-2.6.30/drivers/hid/Kconfig linux-source-test/drivers/hid/Kconfig
--- linux-source-2.6.30/drivers/hid/Kconfig	2009-06-10 05:05:27.000000000 +0200
+++ linux-source-test/drivers/hid/Kconfig	2009-06-26 15:58:15.000000000 +0200
@@ -268,8 +268,9 @@ config THRUSTMASTER_FF
  	depends on USB_HID
  	select INPUT_FF_MEMLESS
  	help
-	  Say Y here if you have a THRUSTMASTER FireStore Dual Power 2 or
-	  a THRUSTMASTER Ferrari GT Rumble Force or Force Feedback Wheel.
+	  Say Y here if you have a THRUSTMASTER FireStore Dual Power 2 or 3,
+	  a THRUSTMASTER Dual Trigger 3-in-1 or a THRUSTMASTER Ferrari GT
+	  Rumble Force or Force Feedback Wheel.

  config ZEROPLUS_FF
  	tristate "Zeroplus based game controller support"
--8323328-1881556729-1246024540=:10045--
