Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbYFVOTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbYFVOTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbYFVOTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:19:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39204 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbYFVOTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:19:30 -0400
To: mchehab@infradead.org
Subject: [PATCH] xc2028 unaligned access fixes
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAQPh-0001y2-I9@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jun 2008 15:19:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/common/tuners/tuner-xc2028.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 0cbde17..cd7905a 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <media/tuner.h>
 #include <linux/mutex.h>
+#include <asm/unaligned.h>
 #include "tuner-i2c.h"
 #include "tuner-xc2028.h"
 #include "tuner-xc2028-types.h"
@@ -292,10 +293,10 @@ static int load_all_firmwares(struct dvb_frontend *fe)
 	name[sizeof(name) - 1] = 0;
 	p += sizeof(name) - 1;
 
-	priv->firm_version = le16_to_cpu(*(__u16 *) p);
+	priv->firm_version = get_unaligned_le16(p);
 	p += 2;
 
-	n_array = le16_to_cpu(*(__u16 *) p);
+	n_array = get_unaligned_le16(p);
 	p += 2;
 
 	tuner_info("Loading %d firmware images from %s, type: %s, ver %d.%d\n",
@@ -324,26 +325,26 @@ static int load_all_firmwares(struct dvb_frontend *fe)
 		}
 
 		/* Checks if there's enough bytes to read */
-		if (p + sizeof(type) + sizeof(id) + sizeof(size) > endp) {
-			tuner_err("Firmware header is incomplete!\n");
-			goto corrupt;
-		}
+		if (endp - p < sizeof(type) + sizeof(id) + sizeof(size))
+			goto header;
 
-		type = le32_to_cpu(*(__u32 *) p);
+		type = get_unaligned_le32(p);
 		p += sizeof(type);
 
-		id = le64_to_cpu(*(v4l2_std_id *) p);
+		id = get_unaligned_le64(p);
 		p += sizeof(id);
 
 		if (type & HAS_IF) {
-			int_freq = le16_to_cpu(*(__u16 *) p);
+			int_freq = get_unaligned_le16(p);
 			p += sizeof(int_freq);
+			if (endp - p < sizeof(size))
+				goto header;
 		}
 
-		size = le32_to_cpu(*(__u32 *) p);
+		size = get_unaligned_le32(p);
 		p += sizeof(size);
 
-		if ((!size) || (size + p > endp)) {
+		if (!size || size > endp - p) {
 			tuner_err("Firmware type ");
 			dump_firm_type(type);
 			printk("(%x), id %llx is corrupted "
@@ -382,6 +383,8 @@ static int load_all_firmwares(struct dvb_frontend *fe)
 
 	goto done;
 
+header:
+	tuner_err("Firmware header is incomplete!\n");
 corrupt:
 	rc = -EINVAL;
 	tuner_err("Error: firmware file is corrupted!\n");
-- 
1.5.3.GIT


