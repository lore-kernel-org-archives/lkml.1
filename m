Return-Path: <linux-kernel-owner+w=401wt.eu-S1763800AbYFFTVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763800AbYFFTVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 15:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbYFFTVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 15:21:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43502 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbYFFTVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 15:21:43 -0400
Date: Fri, 6 Jun 2008 20:21:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <greg@kroah.com>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: [PATCH] isight_firmware: Avoid crash on loading invalid firmware
Message-ID: <20080606192135.GA16727@srcf.ucam.org>
References: <dd18b0c30806041213x45b7efdfo42de9b214a7ce9df@mail.gmail.com> <20080606002601.a0f6c47c.akpm@linux-foundation.org> <dd18b0c30806060137j7edc751se364ff21cfc8911b@mail.gmail.com> <20080606121136.GA9087@srcf.ucam.org> <20080606110711.a9a6a4f6.akpm@linux-foundation.org> <dd18b0c30806061110qd3100b4p1ee9f8ef493a56c6@mail.gmail.com> <dd18b0c30806061138h69c87d6am898a4eb409d379e1@mail.gmail.com> <20080606185548.GB8576@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606185548.GB8576@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different tools generate slightly different formats of the isight 
firmware. Ensure that the firmware buffer is not overrun, while still 
ensuring that the correct amount of data is written if trailing data is 
prseent.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

diff --git a/drivers/usb/misc/isight_firmware.c b/drivers/usb/misc/isight_firmware.c
index 390e048..9f30aa1 100644
--- a/drivers/usb/misc/isight_firmware.c
+++ b/drivers/usb/misc/isight_firmware.c
@@ -39,9 +39,12 @@ static int isight_firmware_load(struct usb_interface *intf,
 	struct usb_device *dev = interface_to_usbdev(intf);
 	int llen, len, req, ret = 0;
 	const struct firmware *firmware;
-	unsigned char *buf;
+	unsigned char *buf = kmalloc(50, GFP_KERNEL);
 	unsigned char data[4];
-	char *ptr;
+	u8 *ptr;
+
+	if (!buf)
+		return -ENOMEM;
 
 	if (request_firmware(&firmware, "isight.fw", &dev->dev) != 0) {
 		printk(KERN_ERR "Unable to load isight firmware\n");
@@ -59,7 +62,7 @@ static int isight_firmware_load(struct usb_interface *intf,
 		goto out;
 	}
 
-	while (1) {
+	while (ptr+4 <= firmware->data+firmware->size) {
 		memcpy(data, ptr, 4);
 		len = (data[0] << 8 | data[1]);
 		req = (data[2] << 8 | data[3]);
@@ -71,10 +74,14 @@ static int isight_firmware_load(struct usb_interface *intf,
 			continue;
 
 		for (; len > 0; req += 50) {
-			llen = len > 50 ? 50 : len;
+			llen = min(len, 50);
 			len -= llen;
-
-			buf = kmalloc(llen, GFP_KERNEL);
+			if (ptr+llen > firmware->data+firmware->size) {
+				printk(KERN_ERR
+				       "Malformed isight firmware");
+				ret = -ENODEV;
+				goto out;
+			}
 			memcpy(buf, ptr, llen);
 
 			ptr += llen;
@@ -89,16 +96,18 @@ static int isight_firmware_load(struct usb_interface *intf,
 				goto out;
 			}
 
-			kfree(buf);
 		}
 	}
+
 	if (usb_control_msg
 	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, "\0", 1,
 	     300) != 1) {
 		printk(KERN_ERR "isight firmware loading completion failed\n");
 		ret = -ENODEV;
 	}
+
 out:
+	kfree(buf);
 	release_firmware(firmware);
 	return ret;
 }
-- 
Matthew Garrett | mjg59@srcf.ucam.org
