Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYIAJf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYIAJf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYIAJfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:35:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54182 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYIAJfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:35:17 -0400
Message-ID: <48BBB71E.7060400@cn.fujitsu.com>
Date: Mon, 01 Sep 2008 17:34:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: moinejf@free.fr, LKML <linux-kernel@vger.kernel.org>,
       video4linux-list@redhat.com
Subject: [PATCH] V4L/DVB: gspca: fix wrong retry counting
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 'while (retry--) {...}', retry will be -1 but not 0.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/media/video/gspca/conex.c   |    4 ++--
 drivers/media/video/gspca/spca561.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/gspca/conex.c b/drivers/media/video/gspca/conex.c
index cd3a3f5..b5e3e96 100644
--- a/drivers/media/video/gspca/conex.c
+++ b/drivers/media/video/gspca/conex.c
@@ -731,13 +731,13 @@ static void cx11646_jpeg(struct gspca_dev*gspca_dev)
 	reg_w_val(gspca_dev, 0x0000, 0x00);
 	/* wait for completion */
 	retry = 50;
-	while (retry--) {
+	do {
 		reg_r(gspca_dev, 0x0002, 1);
 							/* 0x07 until 0x00 */
 		if (gspca_dev->usb_buf[0] == 0x00)
 			break;
 		reg_w_val(gspca_dev, 0x0053, 0x00);
-	}
+	} while (--retry);
 	if (retry == 0)
 		PDEBUG(D_ERR, "Damned Errors sending jpeg Table");
 	/* send the qtable now */
diff --git a/drivers/media/video/gspca/spca561.c b/drivers/media/video/gspca/spca561.c
index 1073ac3..5ba3b75 100644
--- a/drivers/media/video/gspca/spca561.c
+++ b/drivers/media/video/gspca/spca561.c
@@ -231,11 +231,11 @@ static int i2c_read(struct gspca_dev *gspca_dev, __u16 reg, __u8 mode)
 	reg_w_val(gspca_dev->dev, 0x92, 0x8804);
 	reg_w_val(gspca_dev->dev, reg, 0x8801);
 	reg_w_val(gspca_dev->dev, (mode | 0x01), 0x8802);
-	while (retry--) {
+	do {
 		reg_r(gspca_dev, 0x8803, 1);
 		if (!gspca_dev->usb_buf)
 			break;
-	}
+	} while (--retry);
 	if (retry == 0)
 		return -1;
 	reg_r(gspca_dev, 0x8800, 1);
-- 
1.5.4.rc3

