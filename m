Return-Path: <linux-kernel-owner+w=401wt.eu-S932827AbXA2Wxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbXA2Wxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932829AbXA2Wxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:53:31 -0500
Received: from ns.suse.de ([195.135.220.2]:45276 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827AbXA2Wxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:53:30 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] [PATCH] ALSA: Fix sysfs breakage
Date: Mon, 29 Jan 2007 14:52:32 -0800
Message-Id: <11701111521338-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <20070129225055.GA4796@kroah.com>
References: <20070129225055.GA4796@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

The recent change for a new sysfs tree with card* object breaks the
/sys/class/sound tree if CONFIG_SYSFS_DEPRECATED is enabled.
The device in each entry doesn't point the correct device object:

  /sys/class/sound
  ...
  |-- pcmC0D0c
  |   |-- dev
  |   |-- device -> ../../../class/sound/card0
  |   |-- pcm_class
  |   |-- power
  |   |   `-- wakeup
  |   |-- subsystem -> ../../../class/sound
  |   `-- uevent

Also, this change breaks some drivers (like sound/arm/*) referring
card->dev directly to obtain the device object for memory handling.

This patch reverts the semantics of card->dev to the former version,
which points to a real device object.  The card* object is stored in a
new card->card_dev field, instead.  The device parent is chosen either
card->dev or card->card_dev according to CONFIG_SYSFS_DEPRECATED to
keep the tree compatibility.
Also, card* isn't created if CONFIG_SYSFS_DEPRECATED is enabled.  The
reason of card* object is a root of all beloing devices, and it makes
little sense if each sound device points to the real device object
directly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Monty Montgomery <xiphmont@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/sound/core.h   |   18 +++++++++++++++---
 sound/core/init.c      |   18 +++++++++++-------
 sound/core/sound.c     |    4 +---
 sound/core/sound_oss.c |    4 +---
 4 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index a994bea..521f036 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -132,8 +132,10 @@ struct snd_card {
 	int shutdown;			/* this card is going down */
 	int free_on_last_close;		/* free in context of file_release */
 	wait_queue_head_t shutdown_sleep;
-	struct device *parent;
-	struct device *dev;
+	struct device *dev;		/* device assigned to this card */
+#ifndef CONFIG_SYSFS_DEPRECATED
+	struct device *card_dev;	/* cardX object for sysfs */
+#endif
 
 #ifdef CONFIG_PM
 	unsigned int power_state;	/* power state */
@@ -191,6 +193,16 @@ struct snd_minor {
 	struct device *dev;		/* device for sysfs */
 };
 
+/* return a device pointer linked to each sound device as a parent */
+static inline struct device *snd_card_get_device_link(struct snd_card *card)
+{
+#ifdef CONFIG_SYSFS_DEPRECATED
+	return card ? card->dev : NULL;
+#else
+	return card ? card->card_dev : NULL;
+#endif
+}
+
 /* sound.c */
 
 extern int snd_major;
@@ -257,7 +269,7 @@ int snd_card_file_add(struct snd_card *card, struct file *file);
 int snd_card_file_remove(struct snd_card *card, struct file *file);
 
 #ifndef snd_card_set_dev
-#define snd_card_set_dev(card,devptr) ((card)->parent = (devptr))
+#define snd_card_set_dev(card,devptr) ((card)->dev = (devptr))
 #endif
 
 /* device.c */
diff --git a/sound/core/init.c b/sound/core/init.c
index 6152a75..a4cc6b1 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -361,8 +361,10 @@ static int snd_card_do_free(struct snd_card *card)
 		snd_printk(KERN_WARNING "unable to free card info\n");
 		/* Not fatal error */
 	}
-	if (card->dev)
-		device_unregister(card->dev);
+#ifndef CONFIG_SYSFS_DEPRECATED
+	if (card->card_dev)
+		device_unregister(card->card_dev);
+#endif
 	kfree(card);
 	return 0;
 }
@@ -497,12 +499,14 @@ int snd_card_register(struct snd_card *card)
 	int err;
 
 	snd_assert(card != NULL, return -EINVAL);
-	if (!card->dev) {
-		card->dev = device_create(sound_class, card->parent, 0,
-					  "card%i", card->number);
-		if (IS_ERR(card->dev))
-			card->dev = NULL;
+#ifndef CONFIG_SYSFS_DEPRECATED
+	if (!card->card_dev) {
+		card->card_dev = device_create(sound_class, card->dev, 0,
+					       "card%i", card->number);
+		if (IS_ERR(card->card_dev))
+			card->card_dev = NULL;
 	}
+#endif
 	if ((err = snd_device_register_all(card)) < 0)
 		return err;
 	mutex_lock(&snd_card_mutex);
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 2827420..82a61c6 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -238,7 +238,7 @@ int snd_register_device(int type, struct snd_card *card, int dev,
 {
 	int minor;
 	struct snd_minor *preg;
-	struct device *device = NULL;
+	struct device *device = snd_card_get_device_link(card);
 
 	snd_assert(name, return -EINVAL);
 	preg = kmalloc(sizeof *preg, GFP_KERNEL);
@@ -263,8 +263,6 @@ int snd_register_device(int type, struct snd_card *card, int dev,
 		return minor;
 	}
 	snd_minors[minor] = preg;
-	if (card)
-		device = card->dev;
 	preg->dev = device_create(sound_class, device, MKDEV(major, minor),
 				  "%s", name);
 	if (preg->dev)
diff --git a/sound/core/sound_oss.c b/sound/core/sound_oss.c
index b2fc40a..4566df4 100644
--- a/sound/core/sound_oss.c
+++ b/sound/core/sound_oss.c
@@ -106,7 +106,7 @@ int snd_register_oss_device(int type, struct snd_card *card, int dev,
 	int cidx = SNDRV_MINOR_OSS_CARD(minor);
 	int track2 = -1;
 	int register1 = -1, register2 = -1;
-	struct device *carddev = NULL;
+	struct device *carddev = snd_card_get_device_link(card);
 
 	if (card && card->number >= 8)
 		return 0; /* ignore silently */
@@ -134,8 +134,6 @@ int snd_register_oss_device(int type, struct snd_card *card, int dev,
 		track2 = SNDRV_MINOR_OSS(cidx, SNDRV_MINOR_OSS_DMMIDI1);
 		break;
 	}
-	if (card)
-		carddev = card->dev;
 	register1 = register_sound_special_device(f_ops, minor, carddev);
 	if (register1 != minor)
 		goto __end;
-- 
1.4.4.4

