Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbZBITgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbZBITgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbZBITf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:35:58 -0500
Received: from kroah.org ([198.145.64.141]:34758 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757251AbZBITfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:35:41 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Andryuk <jandryuk@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/6] Staging: at76_usb: fix bugs introduced by "Staging: at76_usb: cleanup dma on stack issues"
Date: Mon,  9 Feb 2009 11:34:02 -0800
Message-Id: <1234208046-2295-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1.2
In-Reply-To: <20090209193201.GB2194@kroah.com>
References: <20090209193201.GB2194@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Andryuk <jandryuk@gmail.com>

Tracking down the firmware loading problem led to this commit.

$ git bisect bad
0d1d1424330cc1934f2b2742f0cfa2c31e6a250b is first bad commit
commit 0d1d1424330cc1934f2b2742f0cfa2c31e6a250b
Author: Oliver Neukum <oliver@neukum.org>
Date:   Thu Dec 18 13:16:40 2008 +0100

    Staging: at76_usb: cleanup dma on stack issues

    - no DMA on stack
    - cleanup unclear endianness issue

    Signed-off-by: Oliver Neukum <oneukum@suse.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 c4fee9ea0fef25926229d810d19dc2f89cca9401
8b165a35d16280d2413b2700a6080ef290ca1009 M	drivers

The "no DMA on stack" conversion was incomplete with respect to
updating the arguments passed to usb_control_msg.  The value 40 is
hardcoded as it was prior to conversion.

The driver can now load firmware, but is not fully functional.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/at76_usb/at76_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76_usb.c
index 9195ee9..06ae163 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -649,7 +649,7 @@ static int at76_get_op_mode(struct usb_device *udev)
 		return -ENOMEM;
 	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x33,
 			      USB_TYPE_VENDOR | USB_DIR_IN |
-			      USB_RECIP_INTERFACE, 0x01, 0, &op_mode, 1,
+			      USB_RECIP_INTERFACE, 0x01, 0, op_mode, 1,
 			      USB_CTRL_GET_TIMEOUT);
 	saved = *op_mode;
 	kfree(op_mode);
@@ -782,7 +782,7 @@ static inline int at76_get_cmd_status(struct usb_device *udev, u8 cmd)
 	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x22,
 			      USB_TYPE_VENDOR | USB_DIR_IN |
 			      USB_RECIP_INTERFACE, cmd, 0, stat_buf,
-			      sizeof(stat_buf), USB_CTRL_GET_TIMEOUT);
+			      40, USB_CTRL_GET_TIMEOUT);
 	if (ret >= 0)
 		ret = stat_buf[5];
 	kfree(stat_buf);
-- 
1.6.0.2

