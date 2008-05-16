Return-Path: <linux-kernel-owner+w=401wt.eu-S1763261AbYEPPM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763261AbYEPPM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbYEPPMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:12:49 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:56121 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbYEPPMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:12:48 -0400
Date: Sat, 17 May 2008 00:13:56 +0900 (JST)
Message-Id: <20080517.001356.72708524.anemo@mba.ocn.ne.jp>
To: akirat@rd.scei.sony.co.jp
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-serial: pl2303: add support for RATOC REX-USB60F
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080516.171345.01918000.nemoto@toshiba-tops.co.jp>
References: <20080118185231.0B48.4D252088@rd.scei.sony.co.jp>
	<20080516.171345.01918000.nemoto@toshiba-tops.co.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 17:13:45 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> This device works fine with the ftdi_sio driver, with "vendor=0x584
> product=0xb020" module option.  (0x584 is RATOC_VENDOR_ID and 0xb020
> is RATOC_PRODUCT_ID_USB60F).
> 
> Is the pl2303 driver appropriate for this device?

For those who can read Japanese, here is a web page saying this device
uses FTDI FT232BL chip.

http://www.ratocsystems.com/info/news/2005/0524.html

Tsukamoto-san, does your REX-USB60F work with pl2303 driver?  If so,
we have to do some trick to support this strange device (different
driver for same USB ID), though I'm not sure that is possible.
Otherwise, this patch can be used to support the device correctly.

------------------------------------------------------
Subject: [PATCH] usb-serial: Use ftdi_sio driver for RATOC REX-USB60F
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This patch reverts 57833ea6b95a3995149f1f6d1a8d8862ab7a0ba2
("usb-serial: pl2303: add support for RATOC REX-USB60F") and add
support for the device to ftdi_sio driver.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    6 ++++++
 drivers/usb/serial/pl2303.c   |    1 -
 drivers/usb/serial/pl2303.h   |    1 -
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5b349ec..3cee6fe 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -374,6 +374,7 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_OOCDLINK_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index 504edf8..a72f2c8 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -592,6 +592,12 @@
 #define	FIC_NEO1973_DEBUG_PID	0x5118
 
 /*
+ * RATOC REX-USB60F
+ */
+#define RATOC_VENDOR_ID		0x0584
+#define RATOC_PRODUCT_ID_USB60F	0xb020
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index c605fb6..234c5ee 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -66,7 +66,6 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(ITEGNO_VENDOR_ID, ITEGNO_PRODUCT_ID_2080) },
 	{ USB_DEVICE(MA620_VENDOR_ID, MA620_PRODUCT_ID) },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID) },
-	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(TRIPP_VENDOR_ID, TRIPP_PRODUCT_ID) },
 	{ USB_DEVICE(RADIOSHACK_VENDOR_ID, RADIOSHACK_PRODUCT_ID) },
 	{ USB_DEVICE(DCU10_VENDOR_ID, DCU10_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 10cf872..3bdefe0 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -36,7 +36,6 @@
 
 #define RATOC_VENDOR_ID		0x0584
 #define RATOC_PRODUCT_ID	0xb000
-#define RATOC_PRODUCT_ID_USB60F	0xb020
 
 #define TRIPP_VENDOR_ID		0x2478
 #define TRIPP_PRODUCT_ID	0x2008
