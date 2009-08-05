Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbZHEGky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbZHEGky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933485AbZHEGky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:40:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:52544 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933482AbZHEGkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:40:49 -0400
Message-ID: <4A79296A.4090600@suse.de>
Date: Wed, 05 Aug 2009 15:40:42 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: cguthrie@mandriva.org
Subject: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>
In-Reply-To: <4A79283E.7030202@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If any OSS support is enabled, regardless of built-in or module,
sound_core claims full OSS major number (that is, the old 0-255
region) to trap open attempts and request sound module automatically.
This feature is redundant as chrdev already has such mechanism and no
longer used by modern distros.  This preemptive claiming prevents
alternative OSS implementation.

This patch makes the preclaiming optional and adds a config option
SOUND_OSS_CORE_PRECLAIM and kernel parameter soundcore.preclaim_oss to
control whether preclaim is enabled or not.  This allows distros and
developers to try new things without rebuilding kernel.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Colin Guthrie <cguthrie@mandriva.org>
---
Hello, Takashi.

This patch is to allow using ossp without needing to recompile the
kernel.  The affected code is mostly deprecated.  chrdev already has
exactly about the same mechanism although it would use different
alises and AFAIK udev based modern distros just don't use it at all
(SUSE doesn't at least).  I thought about removing the code altogether
but this part of code is hopefully in slow death so the least amount
change should be the best.

Thanks.

 sound/Kconfig      |   20 +++++++++++++++
 sound/sound_core.c |   68 ++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 67 insertions(+), 21 deletions(-)

Index: work/sound/Kconfig
===================================================================
--- work.orig/sound/Kconfig
+++ work/sound/Kconfig
@@ -32,6 +32,26 @@ config SOUND_OSS_CORE
 	bool
 	default n

+config SOUND_OSS_CORE_PRECLAIM
+	bool "Preclaim OSS device numbers"
+	depends on SOUND_OSS_CORE
+	default y
+	help
+	  With this option enabled, the kernel will claim all OSS device
+	  numbers if any OSS support (native or emulation) is enabled
+	  whether the respective module is loaded or not and, if necessary,
+	  try to load the appropriate module when one of the device numbers
+	  is opened.  With this option disabled, kernel will only claim
+	  actually in-use device numbers and module loading is left to
+	  userland.
+
+	  Disabling it allows alternative out-of-kernel OSS implementation.
+
+	  The behavior can be overridden using kernel parameter
+	  soundcore.preclaim_oss.
+
+	  If unusre, say Y.
+
 source "sound/oss/dmasound/Kconfig"

 if !M68K
Index: work/sound/sound_core.c
===================================================================
--- work.orig/sound/sound_core.c
+++ work/sound/sound_core.c
@@ -127,6 +127,23 @@ extern int msnd_classic_init(void);
 extern int msnd_pinnacle_init(void);
 #endif

+#ifdef CONFIG_SOUND_OSS_CORE_PRECLAIM
+static int preclaim_oss = 1;
+#else
+static int preclaim_oss = 0;
+#endif
+
+module_param(preclaim_oss, int, 0444);
+
+static int soundcore_open(struct inode *, struct file *);
+
+static const struct file_operations soundcore_fops =
+{
+	/* We must have an owner or the module locking fails */
+	.owner	= THIS_MODULE,
+	.open	= soundcore_open,
+};
+
 /*
  *	Low level list operator. Scan the ordered list, find a hole and
  *	join into it. Called with the lock asserted
@@ -215,7 +232,8 @@ static DEFINE_SPINLOCK(sound_loader_lock
 static int sound_insert_unit(struct sound_unit **list, const struct file_operations *fops, int index, int low, int top, const char *name, umode_t mode, struct device *dev)
 {
 	struct sound_unit *s = kmalloc(sizeof(*s), GFP_KERNEL);
-	int r;
+	struct device *gdev;
+	int r, minor;

 	if (!s)
 		return -ENOMEM;
@@ -225,17 +243,34 @@ static int sound_insert_unit(struct soun
 	spin_unlock(&sound_loader_lock);
 	
 	if (r < 0)
-		goto fail;
+		goto fail_free;
 	else if (r < SOUND_STEP)
 		sprintf(s->name, "sound/%s", name);
 	else
 		sprintf(s->name, "sound/%s%d", name, r / SOUND_STEP);
+	minor = r;

-	device_create(sound_class, dev, MKDEV(SOUND_MAJOR, s->unit_minor),
-		      NULL, s->name+6);
-	return r;
+	if (!preclaim_oss) {
+		r = __register_chrdev(SOUND_MAJOR, s->unit_minor, 1, s->name,
+				      &soundcore_fops);
+		if (r < 0)
+			goto fail_remove;
+	}

- fail:
+	gdev = device_create(sound_class, dev,
+			     MKDEV(SOUND_MAJOR, s->unit_minor), NULL,
+			     s->name + 6);
+	if (IS_ERR(gdev)) {
+		r = PTR_ERR(gdev);
+		goto fail_destroy;
+	}
+	return minor;
+
+fail_destroy:
+	device_destroy(sound_class, MKDEV(SOUND_MAJOR, s->unit_minor));
+fail_remove:
+	__sound_remove_unit(list, s->unit_minor);
+fail_free:
 	kfree(s);
 	return r;
 }
@@ -254,6 +289,9 @@ static void sound_remove_unit(struct sou
 	p = __sound_remove_unit(list, unit);
 	spin_unlock(&sound_loader_lock);
 	if (p) {
+		if (!preclaim_oss)
+			__unregister_chrdev(SOUND_MAJOR, p->unit_minor, 1,
+					    p->name);
 		device_destroy(sound_class, MKDEV(SOUND_MAJOR, p->unit_minor));
 		kfree(p);
 	}
@@ -491,19 +529,6 @@ void unregister_sound_dsp(int unit)

 EXPORT_SYMBOL(unregister_sound_dsp);

-/*
- *	Now our file operations
- */
-
-static int soundcore_open(struct inode *, struct file *);
-
-static const struct file_operations soundcore_fops=
-{
-	/* We must have an owner or the module locking fails */
-	.owner	= THIS_MODULE,
-	.open	= soundcore_open,
-};
-
 static struct sound_unit *__look_for_unit(int chain, int unit)
 {
 	struct sound_unit *s;
@@ -539,7 +564,7 @@ static int soundcore_open(struct inode *
 	s = __look_for_unit(chain, unit);
 	if (s)
 		new_fops = fops_get(s->unit_fops);
-	if (!new_fops) {
+	if (preclaim_oss && !new_fops) {
 		spin_unlock(&sound_loader_lock);
 		/*
 		 *  Please, don't change this order or code.
@@ -593,7 +618,8 @@ static void cleanup_oss_soundcore(void)

 static int __init init_oss_soundcore(void)
 {
-	if (register_chrdev(SOUND_MAJOR, "sound", &soundcore_fops)==-1) {
+	if (preclaim_oss &&
+	    register_chrdev(SOUND_MAJOR, "sound", &soundcore_fops) == -1) {
 		printk(KERN_ERR "soundcore: sound device already in use.\n");
 		return -EBUSY;
 	}
