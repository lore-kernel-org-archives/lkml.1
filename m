Return-Path: <linux-kernel-owner+w=401wt.eu-S1762804AbYB1A5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762804AbYB1A5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761450AbYB1A4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:23 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:41369 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761346AbYB1A4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tH/7mM2y8ShSQbu2NFfzKLm1PrOjdnh8tBgBV65t70JamOUvrAdByEHl2VJLQGqaTBAo0b7+kzxHhMqbCmDooYoAl9W7mkA7Nh4OkSEdnrSLT4cHbSZIaJ6tfbPjFZ8qxiFnoEUoM9xSGdaYTjHAynoSrOxwF+jFX5zbWS455Xc=
Subject: [PATCH 05/12] sound: maestro3.c fix shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:06 -0800
Message-Id: <1204160166.20280.53.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change id to elem_id as it is used to initialize each mixer element
sound/pci/maestro3.c:2071:25: warning: symbol 'id' shadows an earlier one
sound/pci/maestro3.c:67:13: originally declared here

index is used in each of these places to count over the dsp's memory,
change to the name dsp_index
sound/pci/maestro3.c:2572:9: warning: symbol 'index' shadows an earlier one
sound/pci/maestro3.c:66:12: originally declared here
sound/pci/maestro3.c:2604:9: warning: symbol 'index' shadows an earlier one
sound/pci/maestro3.c:66:12: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/maestro3.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 04fa0a6..d0114cd 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2068,7 +2068,7 @@ static int __devinit snd_m3_mixer(struct snd_m3 *chip)
 {
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
-	struct snd_ctl_elem_id id;
+	struct snd_ctl_elem_id elem_id;
 	int err;
 	static struct snd_ac97_bus_ops ops = {
 		.write = snd_m3_ac97_write,
@@ -2088,14 +2088,14 @@ static int __devinit snd_m3_mixer(struct snd_m3 *chip)
 	schedule_timeout_uninterruptible(msecs_to_jiffies(100));
 	snd_ac97_write(chip->ac97, AC97_PCM, 0);
 
-	memset(&id, 0, sizeof(id));
-	id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-	strcpy(id.name, "Master Playback Switch");
-	chip->master_switch = snd_ctl_find_id(chip->card, &id);
-	memset(&id, 0, sizeof(id));
-	id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-	strcpy(id.name, "Master Playback Volume");
-	chip->master_volume = snd_ctl_find_id(chip->card, &id);
+	memset(&elem_id, 0, sizeof(elem_id));
+	elem_id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	strcpy(elem_id.name, "Master Playback Switch");
+	chip->master_switch = snd_ctl_find_id(chip->card, &elem_id);
+	memset(&elem_id, 0, sizeof(elem_id));
+	elem_id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	strcpy(elem_id.name, "Master Playback Volume");
+	chip->master_volume = snd_ctl_find_id(chip->card, &elem_id);
 
 	return 0;
 }
@@ -2569,7 +2569,7 @@ static int m3_suspend(struct pci_dev *pci, pm_message_t state)
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct snd_m3 *chip = card->private_data;
-	int i, index;
+	int i, dsp_index;
 
 	if (chip->suspend_mem == NULL)
 		return 0;
@@ -2583,12 +2583,12 @@ static int m3_suspend(struct pci_dev *pci, pm_message_t state)
 	snd_m3_assp_halt(chip);
 
 	/* save dsp image */
-	index = 0;
+	dsp_index = 0;
 	for (i = REV_B_CODE_MEMORY_BEGIN; i <= REV_B_CODE_MEMORY_END; i++)
-		chip->suspend_mem[index++] = 
+		chip->suspend_mem[dsp_index++] = 
 			snd_m3_assp_read(chip, MEMTYPE_INTERNAL_CODE, i);
 	for (i = REV_B_DATA_MEMORY_BEGIN ; i <= REV_B_DATA_MEMORY_END; i++)
-		chip->suspend_mem[index++] = 
+		chip->suspend_mem[dsp_index++] = 
 			snd_m3_assp_read(chip, MEMTYPE_INTERNAL_DATA, i);
 
 	pci_disable_device(pci);
@@ -2601,7 +2601,7 @@ static int m3_resume(struct pci_dev *pci)
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct snd_m3 *chip = card->private_data;
-	int i, index;
+	int i, dsp_index;
 
 	if (chip->suspend_mem == NULL)
 		return 0;
@@ -2625,13 +2625,13 @@ static int m3_resume(struct pci_dev *pci)
 	snd_m3_ac97_reset(chip);
 
 	/* restore dsp image */
-	index = 0;
+	dsp_index = 0;
 	for (i = REV_B_CODE_MEMORY_BEGIN; i <= REV_B_CODE_MEMORY_END; i++)
 		snd_m3_assp_write(chip, MEMTYPE_INTERNAL_CODE, i, 
-				  chip->suspend_mem[index++]);
+				  chip->suspend_mem[dsp_index++]);
 	for (i = REV_B_DATA_MEMORY_BEGIN ; i <= REV_B_DATA_MEMORY_END; i++)
 		snd_m3_assp_write(chip, MEMTYPE_INTERNAL_DATA, i, 
-				  chip->suspend_mem[index++]);
+				  chip->suspend_mem[dsp_index++]);
 
 	/* tell the dma engine to restart itself */
 	snd_m3_assp_write(chip, MEMTYPE_INTERNAL_DATA, 
-- 
1.5.4.3.342.g99e8


