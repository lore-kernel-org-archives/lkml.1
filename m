Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZG1Xtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZG1Xtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZG1Xtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:51 -0400
Received: from kroah.org ([198.145.64.141]:35693 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbZG1Xtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:53 2009
Message-Id: <20090728234153.843240873@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Mack <daniel@caiaq.de>, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 17/71] USB: fix LANGID=0 regression
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=usb-fix-langid-0-regression.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Mack <daniel@caiaq.de>

commit 0cce2eda19923e5e5ccc8b042dec5af87b3ffad0 upstream.

commit b7af0bb ("USB: allow malformed LANGID descriptors") broke support
for devices without string descriptor support.

Reporting string descriptors is optional to USB devices, and a device
lets us know it can't deal with strings by responding to the LANGID
request with a STALL token.

The kernel handled that correctly before b7af0bb came in, but failed
hard if the LANGID was reported but broken. More than that, if a device
was not able to provide string descriptors, the LANGID was retrieved
over and over again at each string read request.

This patch changes the behaviour so that

 a) the LANGID is only queried once
 b) devices which can't handle string requests are not asked again
 c) devices with malformed LANGID values have a sane fallback to 0x0409

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/message.c |   63 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 18 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -758,6 +758,48 @@ static int usb_string_sub(struct usb_dev
 	return rc;
 }
 
+static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
+{
+	int err;
+
+	if (dev->have_langid)
+		return 0;
+
+	if (dev->string_langid < 0)
+		return -EPIPE;
+
+	err = usb_string_sub(dev, 0, 0, tbuf);
+
+	/* If the string was reported but is malformed, default to english
+	 * (0x0409) */
+	if (err == -ENODATA || (err > 0 && err < 4)) {
+		dev->string_langid = 0x0409;
+		dev->have_langid = 1;
+		dev_err(&dev->dev,
+			"string descriptor 0 malformed (err = %d), "
+			"defaulting to 0x%04x\n",
+				err, dev->string_langid);
+		return 0;
+	}
+
+	/* In case of all other errors, we assume the device is not able to
+	 * deal with strings at all. Set string_langid to -1 in order to
+	 * prevent any string to be retrieved from the device */
+	if (err < 0) {
+		dev_err(&dev->dev, "string descriptor 0 read error: %d\n",
+					err);
+		dev->string_langid = -1;
+		return -EPIPE;
+	}
+
+	/* always use the first langid listed */
+	dev->string_langid = tbuf[2] | (tbuf[3] << 8);
+	dev->have_langid = 1;
+	dev_dbg(&dev->dev, "default language 0x%04x\n",
+				dev->string_langid);
+	return 0;
+}
+
 /**
  * usb_string - returns ISO 8859-1 version of a string descriptor
  * @dev: the device whose string descriptor is being retrieved
@@ -797,24 +839,9 @@ int usb_string(struct usb_device *dev, i
 	if (!tbuf)
 		return -ENOMEM;
 
-	/* get langid for strings if it's not yet known */
-	if (!dev->have_langid) {
-		err = usb_string_sub(dev, 0, 0, tbuf);
-		if (err < 0) {
-			dev_err(&dev->dev,
-				"string descriptor 0 read error: %d\n",
-				err);
-		} else if (err < 4) {
-			dev_err(&dev->dev, "string descriptor 0 too short\n");
-		} else {
-			dev->string_langid = tbuf[2] | (tbuf[3] << 8);
-			/* always use the first langid listed */
-			dev_dbg(&dev->dev, "default language 0x%04x\n",
-				dev->string_langid);
-		}
-
-		dev->have_langid = 1;
-	}
+	err = usb_get_langid(dev, tbuf);
+	if (err < 0)
+		goto errout;
 
 	err = usb_string_sub(dev, dev->string_langid, index, tbuf);
 	if (err < 0)


