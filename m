Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0BIMxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 07:53:19 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41198 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab0BIMxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 07:53:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=aDGJParlLsLACNUHNX722lB9fsErEChf+FAYRWunbY5OHFz1O9UAOgbK+GEJueRQpM
         xxnLZuUi8dJAw/qeHIyGB6Ady6WC4X8VnxbbpqsuOVdMgZ86kc1rOtOKq0s3pRLAhoQW
         mwtn65boBL5Bifdlz/pwU8cvlZPwXFYOG5RiI=
Message-ID: <4B715C55.5090102@gmail.com>
Date: Tue, 09 Feb 2010 14:00:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, sarah.a.sharp@linux.intel.com,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: don't read past config->interface[] if usb_control_msg()
 fails in usb_reset_configuration()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the loop `for (i = 0; i < config->desc.bNumInterfaces; i++)' if no
break occurred, i equals config->desc.bNumInterfaces. so if
usb_control_msg() failed then after goto reset_old_alts we read from
config->interface[config->desc.bNumInterfaces].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 9bc95fe..00b49bc 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1466,10 +1466,15 @@ int usb_reset_configuration(struct usb_device *dev)
 			retval = usb_hcd_alloc_bandwidth(dev, NULL,
 					intf->cur_altsetting, alt);
 		if (retval < 0)
-			break;
+			/* If not, reinstate the old alternate settings */
+			goto reset_old_alts;
 	}
-	/* If not, reinstate the old alternate settings */
+	retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			USB_REQ_SET_CONFIGURATION, 0,
+			config->desc.bConfigurationValue, 0,
+			NULL, 0, USB_CTRL_SET_TIMEOUT);
 	if (retval < 0) {
+		i--;
 reset_old_alts:
 		for (; i >= 0; i--) {
 			struct usb_interface *intf = config->interface[i];
@@ -1485,12 +1490,6 @@ reset_old_alts:
 		mutex_unlock(&hcd->bandwidth_mutex);
 		return retval;
 	}
-	retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-			USB_REQ_SET_CONFIGURATION, 0,
-			config->desc.bConfigurationValue, 0,
-			NULL, 0, USB_CTRL_SET_TIMEOUT);
-	if (retval < 0)
-		goto reset_old_alts;
 	mutex_unlock(&hcd->bandwidth_mutex);
 
 	/* re-init hc/hcd interface/endpoint state */
