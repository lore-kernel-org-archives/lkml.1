Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbZEQLHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbZEQLHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 07:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbZEQLGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 07:06:43 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:57605 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbZEQLGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 07:06:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rFgkWHggVyrTEtnGwwC5hTA8k5Wd7V2IbpSTCzN98EqnEXstejbNujYecF3WpZhZU2
         YOzbmeo/Ex3GGJbWDm93BGcnEkmLVLbylKxkBVeA5zq5bPZeJaxOzRANYajJ+NYzMW00
         GMQKKxU+C2At08FDAGr+pbm6rb87zvkhwL0ts=
From: Richard Genoud <richard.genoud@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Judd Montgomery <judd@jpilot.org>, Jeff Frontz <jeff.frontz@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 3/3] rspiusb.c: duplicate code in pixis_io
Date: Sun, 17 May 2009 13:06:32 +0200
Message-Id: <5ec2d25bcf5e4f86e118c2df753a18bcd850077f.1242557192.git.richard.genoud@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <92fedd0af6bfccd6bb8d69f430148e4630eeeb28.1242557192.git.richard.genoud@gmail.com>
References: <128c57bf092e08fe6372f6e8c3d02fc88b62e094.1242557192.git.richard.genoud@gmail.com>
 <92fedd0af6bfccd6bb8d69f430148e4630eeeb28.1242557192.git.richard.genoud@gmail.com>
In-Reply-To: <128c57bf092e08fe6372f6e8c3d02fc88b62e094.1242557192.git.richard.genoud@gmail.com>
References: <128c57bf092e08fe6372f6e8c3d02fc88b62e094.1242557192.git.richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that pixis_io and pixis_io2 should do the same thing.


Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/staging/rspiusb/rspiusb.c |   59 +++++--------------------------------
 1 files changed, 8 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/rspiusb/rspiusb.c b/drivers/staging/rspiusb/rspiusb.c
index 685ab3f..090bf41 100644
--- a/drivers/staging/rspiusb/rspiusb.c
+++ b/drivers/staging/rspiusb/rspiusb.c
@@ -252,38 +252,6 @@ static int pixis_io(struct ioctl_struct *ctrl, struct device_extension *pdx,
 	return ctrl->numbytes;
 }
 
-static int pixis_io2(struct ioctl_struct *ctrl, struct device_extension *pdx,
-		struct ioctl_struct *arg)
-{
-	unsigned char *uBuf;
-	int numbytes;
-	int i;
-
-	uBuf = kmalloc(ctrl->numbytes, GFP_KERNEL);
-	if (!uBuf) {
-		dbg("Alloc for uBuf failed");
-		return 0;
-	}
-	numbytes = (int) ctrl->numbytes;
-	/* dbg( "numbytes to read = %d", numbytes ); */
-	if (copy_from_user(uBuf, ctrl->pData, numbytes))
-		dbg("copying ctrl->pData to dummyBuf failed");
-
-	i = usb_bulk_msg(pdx->udev, pdx->hEP[ctrl->endpoint],
-			uBuf, numbytes, &numbytes, HZ * 10);
-	if (i) {
-		dbg("Blocking ReadI/O Failed with status %d", i);
-		kfree(uBuf);
-		return -1;
-	}
-	ctrl->numbytes = numbytes;
-	memcpy(ctrl->pData, uBuf, numbytes);
-	if (copy_to_user(arg, ctrl, sizeof(struct ioctl_struct)))
-		dbg("copy_to_user failed in IORB");
-	kfree(uBuf);
-	return ctrl->numbytes;
-}
-
 static int pixel_data(struct ioctl_struct *ctrl, struct device_extension *pdx)
 {
 	int i;
@@ -398,27 +366,16 @@ static int piusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 					sizeof(struct ioctl_struct)))
 			dev_err(&pdx->udev->dev, "copy_from_user failed\n");
 
-		switch (ctrl.endpoint) {
-		case 0:	/* ST133 Pixel Data or PIXIS IO */
-			if (pdx->iama == PIXIS_PID) {
-				return pixis_io(&ctrl, pdx,
-						(struct ioctl_struct *)arg);
-			}
-			/* ST133 Pixel Data */
-			/* fall through */
-		case 2:	/* PIXIS Ping */
-			/* fall through */
-		case 3:	/* PIXIS Pong */
+		if (((0 == ctrl.endpoint) && (PIXIS_PID == pdx->iama)) ||
+				(1 == ctrl.endpoint) ||	/* ST133IO */
+				(4 == ctrl.endpoint))	/* PIXIS IO */
+			return pixis_io(&ctrl, pdx,
+					(struct ioctl_struct *)arg);
+		else if ((0 == ctrl.endpoint) || /* ST133 Pixel Data */
+				(2 == ctrl.endpoint) || /* PIXIS Ping */
+				(3 == ctrl.endpoint))	/* PIXIS Pong */
 			return pixel_data(&ctrl, pdx);
 
-		case 1:	/* ST133IO */
-			/* fall through */
-		case 4:	/* PIXIS IO */
-			return pixis_io2(&ctrl, pdx,
-					(struct ioctl_struct *)arg);
-		default:
-			break;
-		}
 		break;
 
 	case PIUSB_WHATCAMERA:
-- 
1.6.0.4

