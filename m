Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYH0J6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYH0J6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYH0J61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:58:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:44688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbYH0J6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:58:25 -0400
Message-ID: <48B524F2.1010105@kernel.org>
Date: Wed, 27 Aug 2008 11:57:06 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: [PATCH RESEND] sound: make OSS sound core optional
References: <48B50E17.4020106@kernel.org>	<s5hprnubz89.wl%tiwai@suse.de>	<48B52068.2090502@kernel.org> <s5hvdxmkcz7.wl%tiwai@suse.de>
In-Reply-To: <s5hvdxmkcz7.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 Aug 2008 09:58:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
>> SOUND_OSS_CORE should be turned on if ALSA OSS emul is turned on or
>> arch-um hostsound is turned on, both of which can be enabled regardless
>> of SOUND_PRIME, no?
> 
> Yes, sorry, I didn't cite clearly.  I meant only the last line.
> sound/oss/dmasound/Kconfig is included and evaluated outside the block
> "if SOUND_PRIME".  Thus, CONFIG_SOUND_OSS_CORE won't be enabled for
> drivers in sound/oss/dmasound.

Ah.. okay, dmasound also requires SOUND_OSS_CORE but not in
SOUND_PRIME.  I see.

> My suggestion is to move that line source sound/oss/dmasound/Kconfig
> into the "if SOUND_PRIME" block first, then apply your patch.

That would pull in sound_firmware.  Most likely no big deal but
still...  How about just adding select SOUND_OSS_CORE to DMASOUND for
now?

Thanks.

Subject: [PATCH] sound: make OSS sound core optional

sound/sound_core.c implements soundcore.ko and contains two parts -
sound_class which is shared by both ALSA and OSS and device
redirection support for OSS.  It's always compiled when any sound
support is enabled although it's necessary only when OSS (the actual
one or emulation) is enabled.  This is slightly wasteful and as device
redirection always registers character device region for major 14, it
prevents alternative implementation.

This patch introduces a new config SOUND_OSS_CORE which is selected
iff OSS support is actually necessary and build the OSS core part
conditionally.

If OSS is disabled, soundcore merely contains sound_class but leaving
it that way seems to be the simplest approach as otherwise sound_class
should be in ALSA core file if OSS is disabled but should be in
soundcore if OSS is enabled.  Also, there's also the user confusion
factor.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/um/Kconfig.char       |    4 ++
 sound/Kconfig              |    5 ++
 sound/core/Kconfig         |    1 
 sound/oss/dmasound/Kconfig |    1 
 sound/sound_core.c         |   79 ++++++++++++++++++++++++++++++++++-----------
 5 files changed, 71 insertions(+), 19 deletions(-)

Index: work/sound/Kconfig
===================================================================
--- work.orig/sound/Kconfig
+++ work/sound/Kconfig
@@ -28,6 +28,10 @@ menuconfig SOUND
 
 if SOUND
 
+config SOUND_OSS_CORE
+	bool
+	default n
+
 source "sound/oss/dmasound/Kconfig"
 
 if !M68K
@@ -80,6 +84,7 @@ endif # SND
 
 menuconfig SOUND_PRIME
 	tristate "Open Sound System (DEPRECATED)"
+	select SOUND_OSS_CORE
 	help
 	  Say 'Y' or 'M' to enable Open Sound System drivers.
 
Index: work/sound/core/Kconfig
===================================================================
--- work.orig/sound/core/Kconfig
+++ work/sound/core/Kconfig
@@ -38,6 +38,7 @@ config SND_SEQ_DUMMY
 	  will be called snd-seq-dummy.
 
 config SND_OSSEMUL
+	select SOUND_OSS_CORE
 	bool
 
 config SND_MIXER_OSS
Index: work/sound/sound_core.c
===================================================================
--- work.orig/sound/sound_core.c
+++ work/sound/sound_core.c
@@ -1,5 +1,61 @@
 /*
- *	Sound core handling. Breaks out sound functions to submodules
+ *	Sound core.  This file is composed of two parts.  sound_class
+ *	which is common to both OSS and ALSA and OSS sound core which
+ *	is used OSS or emulation of it.
+ */
+
+/*
+ * First, the common part.
+ */
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/err.h>
+
+#ifdef CONFIG_SOUND_OSS_CORE
+static int __init init_oss_soundcore(void);
+static void __exit cleanup_oss_soundcore(void);
+#else
+static inline int init_oss_soundcore(void)	{ return 0; }
+static inline void cleanup_oss_soundcore(void)	{ }
+#endif
+
+struct class *sound_class;
+EXPORT_SYMBOL(sound_class);
+
+MODULE_DESCRIPTION("Core sound module");
+MODULE_AUTHOR("Alan Cox");
+MODULE_LICENSE("GPL");
+
+static int __init init_soundcore(void)
+{
+	int rc;
+
+	rc = init_oss_soundcore();
+	if (rc)
+		return rc;
+
+	sound_class = class_create(THIS_MODULE, "sound");
+	if (IS_ERR(sound_class)) {
+		cleanup_oss_soundcore();
+		return PTR_ERR(sound_class);
+	}
+
+	return 0;
+}
+
+static void __exit cleanup_soundcore(void)
+{
+	cleanup_oss_soundcore();
+	class_destroy(sound_class);
+}
+
+module_init(init_soundcore);
+module_exit(cleanup_soundcore);
+
+
+#ifdef CONFIG_SOUND_OSS_CORE
+/*
+ *	OSS sound core handling. Breaks out sound functions to submodules
  *	
  *	Author:		Alan Cox <alan.cox@linux.org>
  *
@@ -34,21 +90,17 @@
  *	locking at some point in 2.3.x.
  */
 
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/sound.h>
 #include <linux/major.h>
 #include <linux/kmod.h>
-#include <linux/device.h>
 
 #define SOUND_STEP 16
 
-
 struct sound_unit
 {
 	int unit_minor;
@@ -64,9 +116,6 @@ extern int msnd_classic_init(void);
 extern int msnd_pinnacle_init(void);
 #endif
 
-struct class *sound_class;
-EXPORT_SYMBOL(sound_class);
-
 /*
  *	Low level list operator. Scan the ordered list, find a hole and
  *	join into it. Called with the lock asserted
@@ -523,31 +572,23 @@ int soundcore_open(struct inode *inode,
 	return -ENODEV;
 }
 
-MODULE_DESCRIPTION("Core sound module");
-MODULE_AUTHOR("Alan Cox");
-MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SOUND_MAJOR);
 
-static void __exit cleanup_soundcore(void)
+static void __exit cleanup_oss_soundcore(void)
 {
 	/* We have nothing to really do here - we know the lists must be
 	   empty */
 	unregister_chrdev(SOUND_MAJOR, "sound");
-	class_destroy(sound_class);
 }
 
-static int __init init_soundcore(void)
+static int __init init_oss_soundcore(void)
 {
 	if (register_chrdev(SOUND_MAJOR, "sound", &soundcore_fops)==-1) {
 		printk(KERN_ERR "soundcore: sound device already in use.\n");
 		return -EBUSY;
 	}
-	sound_class = class_create(THIS_MODULE, "sound");
-	if (IS_ERR(sound_class))
-		return PTR_ERR(sound_class);
 
 	return 0;
 }
 
-module_init(init_soundcore);
-module_exit(cleanup_soundcore);
+#endif /* CONFIG_SOUND_OSS_CORE */
Index: work/arch/um/Kconfig.char
===================================================================
--- work.orig/arch/um/Kconfig.char
+++ work/arch/um/Kconfig.char
@@ -203,6 +203,10 @@ config SOUND
 	tristate
 	default UML_SOUND
 
+config SOUND_OSS_CORE
+	bool
+	default UML_SOUND
+
 config HOSTAUDIO
 	tristate
 	default UML_SOUND
Index: work/sound/oss/dmasound/Kconfig
===================================================================
--- work.orig/sound/oss/dmasound/Kconfig
+++ work/sound/oss/dmasound/Kconfig
@@ -42,3 +42,4 @@ config DMASOUND_Q40
 
 config DMASOUND
 	tristate
+	select SOUND_OSS_CORE
