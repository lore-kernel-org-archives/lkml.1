Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbYGFRQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbYGFRQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbYGFRQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:16:06 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:50375 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbYGFRQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:16:05 -0400
Date: Sun, 6 Jul 2008 14:15:56 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.de
Subject: [PATCH] Wait for all codecs to be ready if doing a cold reset
Message-ID: <20080706171548.GA9962@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If AC97_POWER_SAVE is enabled, intel8x0 does a cold reset when
initializing the codecs. While resuming, it does not wait for all codecs
to be active. Sound card does not work after a resume without it,
however. This patch fixes it.
---
 sound/pci/intel8x0.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 048d99e..7228a0a 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2335,16 +2335,6 @@ static int snd_intel8x0_ich_chip_init(struct intel8x0 *chip, int probing)
 				   igetdword(chip, ICHREG(GLOB_STA)));
 			return -EIO;
 		}
-
-		/* wait for other codecs ready status. */
-		end_time = jiffies + HZ / 4;
-		while (status != chip->codec_isr_bits &&
-		       time_after_eq(end_time, jiffies)) {
-			schedule_timeout_uninterruptible(1);
-			status |= igetdword(chip, ICHREG(GLOB_STA)) &
-				chip->codec_isr_bits;
-		}
-
 	} else {
 		/* resume phase */
 		int i;
@@ -2363,6 +2353,20 @@ static int snd_intel8x0_ich_chip_init(struct intel8x0 *chip, int probing)
 		} while (time_after_eq(end_time, jiffies));
 	}
 
+#ifndef CONFIG_SND_AC97_POWER_SAVE
+	if (probing)
+#endif
+	{
+		/* wait for other codecs ready status. */
+		end_time = jiffies + HZ / 4;
+		while (status != chip->codec_isr_bits &&
+		       time_after_eq(end_time, jiffies)) {
+			schedule_timeout_uninterruptible(1);
+			status |= igetdword(chip, ICHREG(GLOB_STA)) &
+				chip->codec_isr_bits;
+		}
+	}
+
 	if (chip->device_type == DEVICE_SIS) {
 		/* unmute the output on SIS7012 */
 		iputword(chip, 0x4c, igetword(chip, 0x4c) | 1);
-- 
1.5.6
