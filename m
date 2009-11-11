Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZKKIUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZKKIUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbZKKIUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:20:21 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:48917 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099AbZKKIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:20:20 -0500
Message-ID: <4AFA73C7.4070002@natemccallum.com>
Date: Wed, 11 Nov 2009 03:20:23 -0500
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Devices that ignore USB spec generate invalid modaliases
Content-Type: multipart/mixed;
 boundary="------------080806080303040206070005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080806080303040206070005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Please CC me as I'm not subscribed to LKML.

The current code to generate usb modaliases from usb_device_id assumes 
that the device's bcdDevice descriptor will actually be in BCD format. 
While this should be a sane assumption, some devices don't follow spec 
and just use plain old hex.  This causes drivers for these devices to 
generate invalid modalias lines which will never actually match for the 
hardware.

The following patch adds hex support for bcdDevice in file2alias.c. 
Drivers for devices which have bcdDevice conforming to BCD will have no 
change in modalias output.  Drivers for devices which don't conform 
(primarily usb-storage and ibmcam in my initial survey) should now 
generate valid modaliases.

EXAMPLE OUTPUT (ibmcam; space added to highlight change)
Old: usb:v0545p800D d030[10-9] dc*dsc*dp*ic*isc*ip*
New: usb:v0545p800D d030a      dc*dsc*dp*ic*isc*ip*

Patch attached. Questions/comments welcome.

Nathaniel McCallum

--------------080806080303040206070005
Content-Type: text/plain;
 name="file2alias_usb_bcd2hex.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="file2alias_usb_bcd2hex.patch"

--- linux-2.6.31.orig/scripts/mod/file2alias.c	2009-09-09 18:13:59.000000000 -0400
+++ linux-2.6.31/scripts/mod/file2alias.c	2009-11-11 02:51:02.446894908 -0500
@@ -118,9 +118,20 @@
 		sprintf(alias + strlen(alias), "%0*X",
 			bcdDevice_initial_digits, bcdDevice_initial);
 	if (range_lo == range_hi)
-		sprintf(alias + strlen(alias), "%u", range_lo);
-	else if (range_lo > 0 || range_hi < 9)
-		sprintf(alias + strlen(alias), "[%u-%u]", range_lo, range_hi);
+		sprintf(alias + strlen(alias), "%x", range_lo);
+	else if (range_lo > 0x0 || range_hi < 0xf) {
+		if (range_lo > 0x9 || range_hi < 0xa)
+			sprintf(alias + strlen(alias),
+				"[%x-%x]", range_lo, range_hi);
+		else {
+			sprintf(alias + strlen(alias), 
+				range_lo < 0x9 ? "[%x-9" : "[%x",
+				range_lo);
+			sprintf(alias + strlen(alias), 
+				range_hi > 0xa ? "a-%x]" : "%x]",
+				range_hi);
+		}
+	}
 	if (bcdDevice_initial_digits < (sizeof(id->bcdDevice_lo) * 2 - 1))
 		strcat(alias, "*");
 
@@ -173,8 +184,6 @@
 	for (ndigits = sizeof(id->bcdDevice_lo) * 2 - 1; devlo <= devhi; ndigits--) {
 		clo = devlo & 0xf;
 		chi = devhi & 0xf;
-		if (chi > 9)	/* it's bcd not hex */
-			chi = 9;
 		devlo >>= 4;
 		devhi >>= 4;
 
@@ -184,10 +193,10 @@
 		}
 
 		if (clo > 0)
-			do_usb_entry(id, devlo++, ndigits, clo, 9, mod);
+			do_usb_entry(id, devlo++, ndigits, clo, 0xf, mod);
 
-		if (chi < 9)
-			do_usb_entry(id, devhi--, ndigits, 0, chi, mod);
+		if (chi < 0xf)
+			do_usb_entry(id, devhi--, ndigits, 0x0, chi, mod);
 	}
 }
 

--------------080806080303040206070005--
