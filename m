Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYEPI1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYEPI1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYEPI1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:27:11 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:6489 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbYEPI1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:27:08 -0400
Date: Fri, 16 May 2008 17:27:05 +0900 (JST)
Message-Id: <20080516.172705.56564208.nemoto@toshiba-tops.co.jp>
To: linville@tuxdriver.com
Cc: dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zd1211rw: Use DMA-aware buffer for usb transfer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080515191647.GB17690@tuxdriver.com>
References: <20080516.001215.39152691.anemo@mba.ocn.ne.jp>
	<20080515191647.GB17690@tuxdriver.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 15:16:47 -0400, "John W. Linville" <linville@tuxdriver.com> wrote:
> This looks like a reasonable fix to me.  I would prefer to see a
> comment in the code indicating why you are reusing the "p" buffer
> instead of simply using "ret" directly.  Also, I think the style
> suggestion by Michael Buesch would make the code appear more idiomatic
> as well.

OK, revised.  Thank you for review.

------------------------------------------------------
Subject: [PATCH] zd1211rw: Use DMA-aware buffer for usb transfer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The zd1211rw driver uses unaligned stack buffer for USB control
message.  But it might cause stack corruption on non-coherent
platform, such as MIPS.  Use DMA-aware buffers for USB transfer.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 12e24f0..f9a9a5d 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -169,10 +169,11 @@ static int upload_code(struct usb_device *udev,
 	if (flags & REBOOT) {
 		u8 ret;
 
+		/* Use "DMA-aware" buffer. */
 		r = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			USB_REQ_FIRMWARE_CONFIRM,
 			USB_DIR_IN | USB_TYPE_VENDOR,
-			0, 0, &ret, sizeof(ret), 5000 /* ms */);
+			0, 0, p, sizeof(ret), 5000 /* ms */);
 		if (r != sizeof(ret)) {
 			dev_err(&udev->dev,
 				"control request firmeware confirmation failed."
@@ -181,6 +182,7 @@ static int upload_code(struct usb_device *udev,
 				r = -ENODEV;
 			goto error;
 		}
+		ret = p[0];
 		if (ret & 0x80) {
 			dev_err(&udev->dev,
 				"Internal error while downloading."
@@ -312,22 +314,31 @@ int zd_usb_read_fw(struct zd_usb *usb, zd_addr_t addr, u8 *data, u16 len)
 {
 	int r;
 	struct usb_device *udev = zd_usb_to_usbdev(usb);
+	u8 *buf;
 
+	/* Use "DMA-aware" buffer. */
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 	r = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 		USB_REQ_FIRMWARE_READ_DATA, USB_DIR_IN | 0x40, addr, 0,
-		data, len, 5000);
+		buf, len, 5000);
 	if (r < 0) {
 		dev_err(&udev->dev,
 			"read over firmware interface failed: %d\n", r);
-		return r;
+		goto exit;
 	} else if (r != len) {
 		dev_err(&udev->dev,
 			"incomplete read over firmware interface: %d/%d\n",
 			r, len);
-		return -EIO;
+		r = -EIO;
+		goto exit;
 	}
-
-	return 0;
+	r = 0;
+	memcpy(data, buf, len);
+exit:
+	kfree(buf);
+	return r;
 }
 
 #define urb_dev(urb) (&(urb)->dev->dev)
