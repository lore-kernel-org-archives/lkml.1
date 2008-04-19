Return-Path: <linux-kernel-owner+w=401wt.eu-S1762316AbYDSSnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762316AbYDSSnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbYDSSns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:43:48 -0400
Received: from smtp1.sms.unimo.it ([155.185.44.147]:39551 "HELO smtp.unimo.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756008AbYDSSnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:43:47 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2008 14:43:47 EDT
Subject: [PATCH] option.c: add support for the ET502HS HSDPA modem
From: Mauro Andreolini <mauro.andreolini@unimore.it>
Reply-To: mauro.andreolini@unimore.it
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-2nK2n0PUM6O/AaTFqSGZ"
Organization: University of Modena and Reggio Emilia
Date: Sat, 19 Apr 2008 20:36:42 +0200
Message-Id: <1208630202.5947.0.camel@brandy.ing.unimo.it.ing.unimo.it>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2nK2n0PUM6O/AaTFqSGZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi everyone,

the attached patch (against 2.6.25) allows to recognize and run the ONDA
ET502HS HSDPA modem (which seems to be widespread here in Italy) through
the option driver without any further udev configuration or external
software (usb_modeswitch). Here is what I did:

1. add an unusual device entry in unusual_devs.h to bypass the ZeroCD
mechanism;
2. add proper PCI vendor and product IDs in option.c.

It works reliably for me (no oopses, no hangs, download peaks of
300KB/s) on a Dell Precision M20 Laptop running Debian (lenny).
Two warnings:

1. It takes as much as 30s for the device to setup properly as a modem,
so watch the logs for /dev/ttyUSB* devices to appear before firing off
the connection scripts.
2. The actual modem device is /dev/ttyUSB1.

Please CC me in any answer as I am not subscribed to the list.

Mauro Andreolini
-- 
Ing. Mauro Andreolini - Ph.D., Research Associate
Dipartimento di Ingegneria dell'Informazione
Università di Modena e Reggio Emilia - Italia
e-mail: andreolini.mauro@unimore.it
www: http://weblab.ing.unimo.it/people/andreolini/
tel: +39 059 2056325, fax: +39 059 2056129


--=-2nK2n0PUM6O/AaTFqSGZ
Content-Disposition: attachment; filename=onda-et502hs-driver.patch
Content-Type: text/x-patch; name=onda-et502hs-driver.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -ruN linux-2.6.25-orig/drivers/usb/serial/option.c linux-2.6.25/drivers/usb/serial/option.c
--- linux-2.6.25-orig/drivers/usb/serial/option.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/usb/serial/option.c	2008-04-19 19:05:06.000000000 +0200
@@ -184,6 +184,9 @@
 #define AXESSTEL_VENDOR_ID			0x1726
 #define AXESSTEL_PRODUCT_MV110H			0x1000
 
+#define ONDA_VENDOR_ID				0x19d2
+#define ONDA_PRODUCT_ET502HS			0x0002
+
 #define BANDRICH_VENDOR_ID			0x1A8D
 #define BANDRICH_PRODUCT_C100_1			0x1002
 #define BANDRICH_PRODUCT_C100_2			0x1003
@@ -296,6 +299,7 @@
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(AXESSTEL_VENDOR_ID, AXESSTEL_PRODUCT_MV110H) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_ET502HS) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
diff -ruN linux-2.6.25-orig/drivers/usb/storage/unusual_devs.h linux-2.6.25/drivers/usb/storage/unusual_devs.h
--- linux-2.6.25-orig/drivers/usb/storage/unusual_devs.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/usb/storage/unusual_devs.h	2008-04-19 19:06:18.000000000 +0200
@@ -1520,6 +1520,16 @@
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_DEVICE),
 
+/* Reported by Mauro Andreolini <andreoli@weblab.ing.unimo.it>
+ * This entry is needed to bypass the ZeroCD mechanism
+ * and to properly load as a modem device.
+ */
+UNUSUAL_DEV(  0x19d2, 0x2000, 0x0000, 0x9999,
+		"Onda ET502HS",
+		"USB MMC Storage",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_IGNORE_DEVICE),
+
 /* Reported by Jaco Kroon <jaco@kroon.co.za>
  * The usb-storage module found on the Digitech GNX4 (and supposedly other
  * devices) misbehaves and causes a bunch of invalid I/O errors.

--=-2nK2n0PUM6O/AaTFqSGZ--

