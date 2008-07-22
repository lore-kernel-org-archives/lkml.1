Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbYGVFaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbYGVFaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYGVFXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:43083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbYGVFXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 25/79] device create: sound: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:49 -0700
Message-Id: <1216703983-21448-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/core/init.c     |    5 +++--
 sound/oss/soundcard.c |   14 ++++++++------
 sound/sound_core.c    |    5 +++--
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 5c254d4..df46bbc 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -548,8 +548,9 @@ int snd_card_register(struct snd_card *card)
 	snd_assert(card != NULL, return -EINVAL);
 #ifndef CONFIG_SYSFS_DEPRECATED
 	if (!card->card_dev) {
-		card->card_dev = device_create(sound_class, card->dev, 0,
-					       "card%i", card->number);
+		card->card_dev = device_create_drvdata(sound_class, card->dev,
+						       MKDEV(0, 0), NULL,
+						       "card%i", card->number);
 		if (IS_ERR(card->card_dev))
 			card->card_dev = NULL;
 	}
diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index a9c23b2..7d89c08 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -560,17 +560,19 @@ static int __init oss_init(void)
 	sound_dmap_flag = (dmabuf > 0 ? 1 : 0);
 
 	for (i = 0; i < ARRAY_SIZE(dev_list); i++) {
-		device_create(sound_class, NULL,
-			      MKDEV(SOUND_MAJOR, dev_list[i].minor),
-			      "%s", dev_list[i].name);
+		device_create_drvdata(sound_class, NULL,
+				      MKDEV(SOUND_MAJOR, dev_list[i].minor),
+				      NULL, "%s", dev_list[i].name);
 
 		if (!dev_list[i].num)
 			continue;
 
 		for (j = 1; j < *dev_list[i].num; j++)
-			device_create(sound_class, NULL,
-				      MKDEV(SOUND_MAJOR, dev_list[i].minor + (j*0x10)),
-				      "%s%d", dev_list[i].name, j);
+			device_create_drvdata(sound_class, NULL,
+					      MKDEV(SOUND_MAJOR,
+						    dev_list[i].minor + (j*0x10)),
+					      NULL,
+					      "%s%d", dev_list[i].name, j);
 	}
 
 	if (sound_nblocks >= 1024)
diff --git a/sound/sound_core.c b/sound/sound_core.c
index dcfc1d5..1b04259 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -171,8 +171,9 @@ static int sound_insert_unit(struct sound_unit **list, const struct file_operati
 	else
 		sprintf(s->name, "sound/%s%d", name, r / SOUND_STEP);
 
-	device_create(sound_class, dev, MKDEV(SOUND_MAJOR, s->unit_minor),
-		      s->name+6);
+	device_create_drvdata(sound_class, dev,
+			      MKDEV(SOUND_MAJOR, s->unit_minor),
+			      NULL, s->name+6);
 	return r;
 
  fail:
-- 
1.5.6.3

