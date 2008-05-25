Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbYEYK1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbYEYK1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762303AbYEYKX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42026 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762298AbYEYKX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:57 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Patrick Boettcher <patrick.boettcher@desy.de>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Chris Pascoe <c.pascoe@itee.uq.edu.au>
Subject: [PATCHv2 22/28] cxusb: treat firmware data as const
Message-Id: <E1K0DOK-0007EC-6q@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:52 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...which means allocating our own copy when we want to modify it.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/media/dvb/dvb-usb/cxusb.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 720fcd1..94bb482 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -24,6 +24,7 @@
  * see Documentation/dvb/README.dvb-usb for more information
  */
 #include <media/tuner.h>
+#include <linux/vmalloc.h>
 
 #include "cxusb.h"
 
@@ -700,12 +701,26 @@ static int bluebird_patch_dvico_firmware_download(struct usb_device *udev,
 
 		if (fw->data[idoff] == (USB_VID_DVICO & 0xff) &&
 		    fw->data[idoff + 1] == USB_VID_DVICO >> 8) {
-			fw->data[idoff + 2] =
+			struct firmware new_fw;
+			u8 *new_fw_data = vmalloc(fw->size);
+			int ret;
+
+			if (!new_fw_data)
+				return -ENOMEM;
+
+			memcpy(new_fw_data, fw->data, fw->size);
+			new_fw.size = fw->size;
+			new_fw.data = fw->data;
+
+			new_fw_data[idoff + 2] =
 				le16_to_cpu(udev->descriptor.idProduct) + 1;
-			fw->data[idoff + 3] =
+			new_fw_data[idoff + 3] =
 				le16_to_cpu(udev->descriptor.idProduct) >> 8;
 
-			return usb_cypress_load_firmware(udev, fw, CYPRESS_FX2);
+			ret = usb_cypress_load_firmware(udev, &new_fw,
+							CYPRESS_FX2);
+			vfree(new_fw_data);
+			return ret;
 		}
 	}
 
-- 
1.5.4.5

