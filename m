Return-Path: <linux-kernel-owner+w=401wt.eu-S1763134AbYETSLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763134AbYETSLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbYETSG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:56 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:3485 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765574AbYETSGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aY2qzkoFGyqPbzvnWfAs1MjkvJQgqci1E50lqlQEU5Eqi7vMzoQocJNuEV6IiZVnN+uS936NtXynhfqR7gTV+yL7+WyYhWuTrAvY5gcorqHPAGgtTejbkDOC1XHKAuZODCBp54ywLnn/1JB1NFDsEYOiXTUvfXDQYvzXbQEz3N4=
Subject: [PATCH 18/21] media: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:18 -0700
Message-Id: <1211306778.5915.181.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/dvb/frontends/or51132.c             |    2 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c            |    4 ++--
 drivers/video/aty/mach64_accel.c                  |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb/frontends/or51132.c
index c7b5785..b2af1de 100644
--- a/drivers/media/dvb/frontends/or51132.c
+++ b/drivers/media/dvb/frontends/or51132.c
@@ -126,7 +126,7 @@ static int or51132_readreg(struct or51132_state *state, u8 reg)
 		       reg, err);
 		return -EREMOTEIO;
 	}
-	return le16_to_cpup((u16*)buf);
+	return get_le16(buf);
 }
 
 static int or51132_load_firmware (struct dvb_frontend* fe, const struct firmware *fw)
diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index 732ce4d..ad3a099 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -552,7 +552,7 @@ static void ttusb_process_muxpack(struct ttusb *ttusb, const u8 * muxpack,
 	u16 csum = 0, cc;
 	int i;
 	for (i = 0; i < len; i += 2)
-		csum ^= le16_to_cpup((u16 *) (muxpack + i));
+		csum ^= get_le16(muxpack + i);
 	if (csum) {
 		printk("%s: muxpack with incorrect checksum, ignoring\n",
 		       __func__);
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index f20a01c..726db9b 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -3858,7 +3858,7 @@ static void __devinit osprey_eeprom(struct bttv *btv, const u8 ee[256])
 		ee += i;
 
 		/* found a valid descriptor */
-		type = be16_to_cpup((u16*)(ee+4));
+		type = get_be16(ee + 4);
 
 		switch(type) {
 		/* 848 based */
@@ -3918,7 +3918,7 @@ static void __devinit osprey_eeprom(struct bttv *btv, const u8 ee[256])
 			       btv->c.nr, type);
 			break;
 		}
-		serial = be32_to_cpup((u32*)(ee+6));
+		serial = get_be32(ee + 6);
 	}
 
 	printk(KERN_INFO "bttv%d: osprey eeprom: card=%d '%s' serial=%u\n",
diff --git a/drivers/video/aty/mach64_accel.c b/drivers/video/aty/mach64_accel.c
index a8f60c3..4e8b77c 100644
--- a/drivers/video/aty/mach64_accel.c
+++ b/drivers/video/aty/mach64_accel.c
@@ -412,7 +412,7 @@ void atyfb_imageblit(struct fb_info *info, const struct fb_image *image)
 		u32 *pbitmap, dwords = (src_bytes + 3) / 4;
 		for (pbitmap = (u32*)(image->data); dwords; dwords--, pbitmap++) {
 			wait_for_fifo(1, par);
-			aty_st_le32(HOST_DATA0, le32_to_cpup(pbitmap), par);
+			aty_st_le32(HOST_DATA0, get_le32(pbitmap), par);
 		}
 	}
 
-- 
1.5.5.1.570.g26b5e


