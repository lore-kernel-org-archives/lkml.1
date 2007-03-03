Return-Path: <linux-kernel-owner+w=401wt.eu-S1030298AbXCCOha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030298AbXCCOha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030305AbXCCOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:37:30 -0500
Received: from thing.hostingexpert.com ([67.15.235.34]:47381 "EHLO
	thing.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030298AbXCCOhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:37:10 -0500
Message-ID: <45E987DF.3060903@linuxtv.org>
Date: Sat, 03 Mar 2007 09:36:15 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: stable@kernel.org
CC: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.20.y PATCH 7/7] V4L: cx88-blackbird: allow usage of 376836 and
 262144 sized firmware images
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thing.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Krufky <mkrufky@linuxtv.org>
Date: Sat, 3 Mar 2007 10:10:43 -0200
Subject: [PATCH] V4L: cx88-blackbird: allow usage of 376836 and 262144 sized firmware images

This updates the cx88-blackbird driver to be able to use the new cx23416
firmware image released by Hauppauge Computer Works, while retaining
compatibility with the older firmware images.
cx2341x firmware can be downloaded at: http://dl.ivtvdriver.org/ivtv/firmware/

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
(cherry picked from commit af70dbd3346999570db73b3bc3d4f7b7c004f2ea)
---
 drivers/media/video/cx88/cx88-blackbird.c |   14 +++++++++-----
 drivers/media/video/cx88/cx88.h           |    1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index 0cf0360..1c04516 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -53,7 +53,8 @@ MODULE_PARM_DESC(debug,"enable debug messages [blackbird]");
 
 /* ------------------------------------------------------------------ */
 
-#define BLACKBIRD_FIRM_IMAGE_SIZE 256*1024
+#define OLD_BLACKBIRD_FIRM_IMAGE_SIZE 262144
+#define     BLACKBIRD_FIRM_IMAGE_SIZE 376836
 
 /* defines below are from ivtv-driver.h */
 
@@ -401,7 +402,7 @@ static int blackbird_find_mailbox(struct cx8802_dev *dev)
 	u32 value;
 	int i;
 
-	for (i = 0; i < BLACKBIRD_FIRM_IMAGE_SIZE; i++) {
+	for (i = 0; i < dev->fw_size; i++) {
 		memory_read(dev->core, i, &value);
 		if (value == signature[signaturecnt])
 			signaturecnt++;
@@ -449,12 +450,15 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 		return -1;
 	}
 
-	if (firmware->size != BLACKBIRD_FIRM_IMAGE_SIZE) {
-		dprintk(0, "ERROR: Firmware size mismatch (have %zd, expected %d)\n",
-			firmware->size, BLACKBIRD_FIRM_IMAGE_SIZE);
+	if ((firmware->size != BLACKBIRD_FIRM_IMAGE_SIZE) &&
+	    (firmware->size != OLD_BLACKBIRD_FIRM_IMAGE_SIZE)) {
+		dprintk(0, "ERROR: Firmware size mismatch (have %zd, expected %d or %d)\n",
+			firmware->size, BLACKBIRD_FIRM_IMAGE_SIZE,
+			OLD_BLACKBIRD_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
 		return -1;
 	}
+	dev->fw_size = firmware->size;
 
 	if (0 != memcmp(firmware->data, magic, 8)) {
 		dprintk(0, "ERROR: Firmware magic mismatch, wrong file?\n");
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index a9575ad..e775b4b 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -459,6 +459,7 @@ struct cx8802_dev {
 	u32                        mailbox;
 	int                        width;
 	int                        height;
+	int                        fw_size;
 
 	/* for dvb only */
 	struct videobuf_dvb        dvb;
