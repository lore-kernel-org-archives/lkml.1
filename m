Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbYGIMwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbYGIMwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYGIMwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:52:36 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbYGIMwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:52:35 -0400
Message-Id: <20080709082903.748848000@sipsolutions.net>
References: <20080709082834.942992000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:28:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH -next 07/11] remove CONFIG_KMOD from sound
Content-Disposition: inline; filename=009-config-kmod-remove-sound.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of things in alsa depend on CONFIG_KMOD,
use CONFIG_MODULES instead where the dependency
is needed at all.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Takashi Iwai <tiwai@suse.de>
---
v2: remove #ifdef around EXPORT_SYMBOL pointed out by
    Adrian Bunk

 include/sound/seq_kernel.h     |    2 +-
 sound/core/seq/seq_clientmgr.c |    2 +-
 sound/core/seq/seq_device.c    |    6 ++----
 sound/core/sound.c             |    8 ++++----
 sound/core/timer.c             |    6 +++---
 sound/ppc/daca.c               |    2 --
 sound/ppc/tumbler.c            |    2 --
 7 files changed, 11 insertions(+), 17 deletions(-)

--- linux-next.orig/include/sound/seq_kernel.h	2008-07-08 23:47:40.000000000 +0200
+++ linux-next/include/sound/seq_kernel.h	2008-07-08 23:55:27.000000000 +0200
@@ -105,7 +105,7 @@ int snd_seq_event_port_attach(int client
 			      int cap, int type, int midi_channels, int midi_voices, char *portname);
 int snd_seq_event_port_detach(int client, int port);
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 void snd_seq_autoload_lock(void);
 void snd_seq_autoload_unlock(void);
 #else
--- linux-next.orig/sound/core/seq/seq_clientmgr.c	2008-07-08 23:47:42.000000000 +0200
+++ linux-next/sound/core/seq/seq_clientmgr.c	2008-07-08 23:55:27.000000000 +0200
@@ -148,7 +148,7 @@ struct snd_seq_client *snd_seq_client_us
 		return NULL;
 	}
 	spin_unlock_irqrestore(&clients_lock, flags);
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 	if (!in_interrupt()) {
 		static char client_requested[SNDRV_SEQ_GLOBAL_CLIENTS];
 		static char card_requested[SNDRV_CARDS];
--- linux-next.orig/sound/core/seq/seq_device.c	2008-07-08 23:47:42.000000000 +0200
+++ linux-next/sound/core/seq/seq_device.c	2008-07-08 23:55:27.000000000 +0200
@@ -124,7 +124,7 @@ static void snd_seq_device_info(struct s
  * load all registered drivers (called from seq_clientmgr.c)
  */
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 /* avoid auto-loading during module_init() */
 static int snd_seq_in_init;
 void snd_seq_autoload_lock(void)
@@ -140,7 +140,7 @@ void snd_seq_autoload_unlock(void)
 
 void snd_seq_device_load_drivers(void)
 {
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 	struct ops_list *ops;
 
 	/* Calling request_module during module_init()
@@ -566,7 +566,5 @@ EXPORT_SYMBOL(snd_seq_device_load_driver
 EXPORT_SYMBOL(snd_seq_device_new);
 EXPORT_SYMBOL(snd_seq_device_register_driver);
 EXPORT_SYMBOL(snd_seq_device_unregister_driver);
-#ifdef CONFIG_KMOD
 EXPORT_SYMBOL(snd_seq_autoload_lock);
 EXPORT_SYMBOL(snd_seq_autoload_unlock);
-#endif
--- linux-next.orig/sound/core/sound.c	2008-07-08 23:47:42.000000000 +0200
+++ linux-next/sound/core/sound.c	2008-07-08 23:55:27.000000000 +0200
@@ -61,14 +61,14 @@ EXPORT_SYMBOL(snd_ecards_limit);
 static struct snd_minor *snd_minors[SNDRV_OS_MINORS];
 static DEFINE_MUTEX(sound_mutex);
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 
 /**
  * snd_request_card - try to load the card module
  * @card: the card number
  *
  * Tries to load the module "snd-card-X" for the given card number
- * via KMOD.  Returns immediately if already loaded.
+ * via request_module.  Returns immediately if already loaded.
  */
 void snd_request_card(int card)
 {
@@ -93,7 +93,7 @@ static void snd_request_other(int minor)
 	request_module(str);
 }
 
-#endif				/* request_module support */
+#endif	/* modular kernel */
 
 /**
  * snd_lookup_minor_data - get user data of a registered device
@@ -133,7 +133,7 @@ static int __snd_open(struct inode *inod
 		return -ENODEV;
 	mptr = snd_minors[minor];
 	if (mptr == NULL) {
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 		int dev = SNDRV_MINOR_DEVICE(minor);
 		if (dev == SNDRV_MINOR_CONTROL) {
 			/* /dev/aloadC? */
--- linux-next.orig/sound/core/timer.c	2008-07-08 23:47:42.000000000 +0200
+++ linux-next/sound/core/timer.c	2008-07-08 23:55:27.000000000 +0200
@@ -146,7 +146,7 @@ static struct snd_timer *snd_timer_find(
 	return NULL;
 }
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 
 static void snd_timer_request(struct snd_timer_id *tid)
 {
@@ -259,8 +259,8 @@ int snd_timer_open(struct snd_timer_inst
 	/* open a master instance */
 	mutex_lock(&register_mutex);
 	timer = snd_timer_find(tid);
-#ifdef CONFIG_KMOD
-	if (timer == NULL) {
+#ifdef CONFIG_MODULES
+	if (!timer) {
 		mutex_unlock(&register_mutex);
 		snd_timer_request(tid);
 		mutex_lock(&register_mutex);
--- linux-next.orig/sound/ppc/daca.c	2008-07-08 23:47:43.000000000 +0200
+++ linux-next/sound/ppc/daca.c	2008-07-08 23:55:27.000000000 +0200
@@ -249,9 +249,7 @@ int __init snd_pmac_daca_init(struct snd
 	int i, err;
 	struct pmac_daca *mix;
 
-#ifdef CONFIG_KMOD
 	request_module("i2c-powermac");
-#endif /* CONFIG_KMOD */
 
 	mix = kzalloc(sizeof(*mix), GFP_KERNEL);
 	if (! mix)
--- linux-next.orig/sound/ppc/tumbler.c	2008-07-08 23:47:43.000000000 +0200
+++ linux-next/sound/ppc/tumbler.c	2008-07-08 23:55:27.000000000 +0200
@@ -1350,9 +1350,7 @@ int __init snd_pmac_tumbler_init(struct 
 	struct device_node *tas_node, *np;
 	char *chipname;
 
-#ifdef CONFIG_KMOD
 	request_module("i2c-powermac");
-#endif /* CONFIG_KMOD */
 
 	mix = kzalloc(sizeof(*mix), GFP_KERNEL);
 	if (! mix)

-- 
