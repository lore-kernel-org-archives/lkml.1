Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYJPRTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYJPRTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbYJPROT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:19 -0400
Received: from kroah.org ([198.145.64.141]:46946 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756123AbYJPROQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 11/46] device create: sound: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:12 -0700
Message-Id: <1224177047-11859-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/core/init.c     |    6 +++---
 sound/core/sound.c    |    5 ++---
 sound/oss/soundcard.c |   15 +++++++--------
 sound/sound_core.c    |    5 ++---
 4 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 8af467d..ef2352c 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -549,9 +549,9 @@ int snd_card_register(struct snd_card *card)
 		return -EINVAL;
 #ifndef CONFIG_SYSFS_DEPRECATED
 	if (!card->card_dev) {
-		card->card_dev = device_create_drvdata(sound_class, card->dev,
-						       MKDEV(0, 0), NULL,
-						       "card%i", card->number);
+		card->card_dev = device_create(sound_class, card->dev,
+					       MKDEV(0, 0), NULL,
+					       "card%i", card->number);
 		if (IS_ERR(card->card_dev))
 			card->card_dev = NULL;
 	}
diff --git a/sound/core/sound.c b/sound/core/sound.c
index c0685e2..44a69bb 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -274,9 +274,8 @@ int snd_register_device_for_dev(int type, struct snd_card *card, int dev,
 		return minor;
 	}
 	snd_minors[minor] = preg;
-	preg->dev = device_create_drvdata(sound_class, device,
-					  MKDEV(major, minor),
-					  private_data, "%s", name);
+	preg->dev = device_create(sound_class, device, MKDEV(major, minor),
+				  private_data, "%s", name);
 	if (IS_ERR(preg->dev)) {
 		snd_minors[minor] = NULL;
 		mutex_unlock(&sound_mutex);
diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index 7d89c08..61aaeda 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -560,19 +560,18 @@ static int __init oss_init(void)
 	sound_dmap_flag = (dmabuf > 0 ? 1 : 0);
 
 	for (i = 0; i < ARRAY_SIZE(dev_list); i++) {
-		device_create_drvdata(sound_class, NULL,
-				      MKDEV(SOUND_MAJOR, dev_list[i].minor),
-				      NULL, "%s", dev_list[i].name);
+		device_create(sound_class, NULL,
+			      MKDEV(SOUND_MAJOR, dev_list[i].minor), NULL,
+			      "%s", dev_list[i].name);
 
 		if (!dev_list[i].num)
 			continue;
 
 		for (j = 1; j < *dev_list[i].num; j++)
-			device_create_drvdata(sound_class, NULL,
-					      MKDEV(SOUND_MAJOR,
-						    dev_list[i].minor + (j*0x10)),
-					      NULL,
-					      "%s%d", dev_list[i].name, j);
+			device_create(sound_class, NULL,
+				      MKDEV(SOUND_MAJOR,
+					    dev_list[i].minor + (j*0x10)),
+				      NULL, "%s%d", dev_list[i].name, j);
 	}
 
 	if (sound_nblocks >= 1024)
diff --git a/sound/sound_core.c b/sound/sound_core.c
index 4ae07e2..faef87a 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -220,9 +220,8 @@ static int sound_insert_unit(struct sound_unit **list, const struct file_operati
 	else
 		sprintf(s->name, "sound/%s%d", name, r / SOUND_STEP);
 
-	device_create_drvdata(sound_class, dev,
-			      MKDEV(SOUND_MAJOR, s->unit_minor),
-			      NULL, s->name+6);
+	device_create(sound_class, dev, MKDEV(SOUND_MAJOR, s->unit_minor),
+		      NULL, s->name+6);
 	return r;
 
  fail:
-- 
1.6.0.2

