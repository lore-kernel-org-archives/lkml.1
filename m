Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbYD3J1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbYD3J1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYD3J1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:27:43 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39285 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbYD3J1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:27:41 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       James Stafford <jstafford@ampltd.com>, Doug McLain <nostar@comcast.net>,
       Rodolfo Giometti <giometti@linux.it>
Date: Wed, 30 Apr 2008 11:27:18 +0200
Message-Id: <1209547638-22570-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <s5h8xamsuxd.wl%tiwai@suse.de>
References: <s5h8xamsuxd.wl%tiwai@suse.de>
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] [ALSA] ice1724 - support for more that one codec.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now it's possible to specify how many codes are present on the board by
using a new filed as follow:

	ice->ac97_codecs = 4;

For backward compatibility if "ice->ac97_codecs" is set to zero, the patch
redefines it as "1".

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 sound/pci/ice1712/ice1712.c |   37 +++++++++++++++++++++++++------------
 sound/pci/ice1712/ice1712.h |    1 +
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 6630a0a..f78c724 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -221,7 +221,7 @@ static void snd_ice1712_pro_ac97_write(struct snd_ac97 *ac97,
 	outb(reg, ICEMT(ice, AC97_INDEX));
 	outw(val, ICEMT(ice, AC97_DATA));
 	old_cmd &= ~(ICE1712_AC97_PBK_VSR | ICE1712_AC97_CAP_VSR);
-	outb(old_cmd | ICE1712_AC97_WRITE, ICEMT(ice, AC97_CMD));
+	outb(old_cmd | ac97->num | ICE1712_AC97_WRITE, ICEMT(ice, AC97_CMD));
 	for (tm = 0; tm < 0x10000; tm++)
 		if ((inb(ICEMT(ice, AC97_CMD)) & ICE1712_AC97_WRITE) == 0)
 			break;
@@ -244,7 +244,7 @@ static unsigned short snd_ice1712_pro_ac97_read(struct snd_ac97 *ac97,
 		break;
 	}
 	outb(reg, ICEMT(ice, AC97_INDEX));
-	outb(old_cmd | ICE1712_AC97_READ, ICEMT(ice, AC97_CMD));
+	outb(old_cmd | ac97->num | ICE1712_AC97_READ, ICEMT(ice, AC97_CMD));
 	for (tm = 0; tm < 0x10000; tm++)
 		if ((inb(ICEMT(ice, AC97_CMD)) & ICE1712_AC97_READ) == 0)
 			break;
@@ -1504,7 +1504,7 @@ static void snd_ice1712_mixer_free_ac97(struct snd_ac97 *ac97)
 
 static int __devinit snd_ice1712_ac97_mixer(struct snd_ice1712 * ice)
 {
-	int err, bus_num = 0;
+	int err, codec, bus_num = 0;
 	struct snd_ac97_template ac97;
 	struct snd_ac97_bus *pbus;
 	static struct snd_ac97_bus_ops con_ops = {
@@ -1532,15 +1532,28 @@ static int __devinit snd_ice1712_ac97_mixer(struct snd_ice1712 * ice)
 	}
 
 	if (! (ice->eeprom.data[ICE_EEP1_ACLINK] & ICE1712_CFG_PRO_I2S)) {
-		if ((err = snd_ac97_bus(ice->card, bus_num, &pro_ops, NULL, &pbus)) < 0)
-			return err;
-		memset(&ac97, 0, sizeof(ac97));
-		ac97.private_data = ice;
-		ac97.private_free = snd_ice1712_mixer_free_ac97;
-		if ((err = snd_ac97_mixer(pbus, &ac97, &ice->ac97)) < 0)
-			printk(KERN_WARNING "ice1712: cannot initialize pro ac97, skipped\n");
-		else
-			return 0;
+		/* Backward compatibility */
+		if (!ice->ac97_codecs)
+			ice->ac97_codecs = 1;
+
+		for (codec = 0; codec < ice->ac97_codecs; codec++) {
+			/* Sanity check */
+			if (codec >= 4) {
+				printk(KERN_WARNING "ice1712: too much pro ac97 codes (max = %d), skipped\n", codec);
+				break;
+			}
+
+			if ((err = snd_ac97_bus(ice->card, bus_num++, &pro_ops, NULL, &pbus)) < 0)
+				return err;
+			memset(&ac97, 0, sizeof(ac97));
+			ac97.num = codec;
+			ac97.private_data = ice;
+			ac97.private_free = snd_ice1712_mixer_free_ac97;
+			if ((err = snd_ac97_mixer(pbus, &ac97, &ice->ac97)) < 0)
+				printk(KERN_WARNING "ice1712: cannot initialize pro ac97 #%d, skipped\n", codec);
+		}
+
+		return 0;
 	}
 	/* I2S mixer only */
 	strcat(ice->card->mixername, "ICE1712 - multitrack");
diff --git a/sound/pci/ice1712/ice1712.h b/sound/pci/ice1712/ice1712.h
index 6ac486d..59047ad 100644
--- a/sound/pci/ice1712/ice1712.h
+++ b/sound/pci/ice1712/ice1712.h
@@ -335,6 +335,7 @@ struct snd_ice1712 {
 	unsigned int force_rdma1: 1;	/* VT1720/4 - RDMA1 as non-spdif */
 	unsigned int num_total_dacs;	/* total DACs */
 	unsigned int num_total_adcs;	/* total ADCs */
+	unsigned int ac97_codecs;	/* total pro AC97 codecs */
 	unsigned int cur_rate;		/* current rate */
 
 	struct mutex open_mutex;
-- 
1.5.3.6

