Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbXJISJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbXJISJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbXJISHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:07:47 -0400
Received: from ns1.suse.de ([195.135.220.2]:35885 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbXJISHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:07:42 -0400
Message-Id: <20071009180512.041182650@X40.localnet>
References: <20071009180503.075306583@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Tue, 09 Oct 2007 20:05:04 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [patch 01/10] Dont touch fs_struct in drivers
Content-Disposition: inline; filename=vfs/dont-touch-current-fs.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The sound drivers and the pnpbios core test for current->root != NULL. This
test seems to be unnecessary since we always have rootfs mounted before
initializing the drivers.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 drivers/pnp/pnpbios/core.c     |    2 --
 sound/core/seq/seq_clientmgr.c |    4 ++--
 sound/core/seq/seq_device.c    |    3 ---
 sound/core/sound.c             |    4 ----
 sound/core/timer.c             |    2 --
 sound/ppc/daca.c               |    5 ++---
 sound/ppc/tumbler.c            |    5 ++---
 7 files changed, 6 insertions(+), 19 deletions(-)

Index: b/drivers/pnp/pnpbios/core.c
===================================================================
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -105,8 +105,6 @@ static int pnp_dock_event(int dock, stru
 	char *argv[3], **envp, *buf, *scratch;
 	int i = 0, value;
 
-	if (!current->fs->root)
-		return -EAGAIN;
 	if (!(envp = kcalloc(20, sizeof(char *), GFP_KERNEL)))
 		return -ENOMEM;
 	if (!(buf = kzalloc(256, GFP_KERNEL))) {
Index: b/sound/core/seq/seq_clientmgr.c
===================================================================
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -152,13 +152,13 @@ struct snd_seq_client *snd_seq_client_us
 	}
 	spin_unlock_irqrestore(&clients_lock, flags);
 #ifdef CONFIG_KMOD
-	if (!in_interrupt() && current->fs->root) {
+	if (!in_interrupt()) {
 		static char client_requested[SNDRV_SEQ_GLOBAL_CLIENTS];
 		static char card_requested[SNDRV_CARDS];
 		if (clientid < SNDRV_SEQ_GLOBAL_CLIENTS) {
 			int idx;
 			
-			if (! client_requested[clientid] && current->fs->root) {
+			if (!client_requested[clientid]) {
 				client_requested[clientid] = 1;
 				for (idx = 0; idx < 15; idx++) {
 					if (seq_client_load[idx] < 0)
Index: b/sound/core/seq/seq_device.c
===================================================================
--- a/sound/core/seq/seq_device.c
+++ b/sound/core/seq/seq_device.c
@@ -150,9 +150,6 @@ void snd_seq_device_load_drivers(void)
 	if (snd_seq_in_init)
 		return;
 
-	if (! current->fs->root)
-		return;
-
 	mutex_lock(&ops_mutex);
 	list_for_each_entry(ops, &opslist, list) {
 		if (! (ops->driver & DRIVER_LOADED) &&
Index: b/sound/core/sound.c
===================================================================
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -72,8 +72,6 @@ static DEFINE_MUTEX(sound_mutex);
  */
 void snd_request_card(int card)
 {
-	if (! current->fs->root)
-		return;
 	if (snd_card_locked(card))
 		return;
 	if (card < 0 || card >= cards_limit)
@@ -87,8 +85,6 @@ static void snd_request_other(int minor)
 {
 	char *str;
 
-	if (! current->fs->root)
-		return;
 	switch (minor) {
 	case SNDRV_MINOR_SEQUENCER:	str = "snd-seq";	break;
 	case SNDRV_MINOR_TIMER:		str = "snd-timer";	break;
Index: b/sound/core/timer.c
===================================================================
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -148,8 +148,6 @@ static struct snd_timer *snd_timer_find(
 
 static void snd_timer_request(struct snd_timer_id *tid)
 {
-	if (! current->fs->root)
-		return;
 	switch (tid->dev_class) {
 	case SNDRV_TIMER_CLASS_GLOBAL:
 		if (tid->device < timer_limit)
Index: b/sound/ppc/daca.c
===================================================================
--- a/sound/ppc/daca.c
+++ b/sound/ppc/daca.c
@@ -246,9 +246,8 @@ int __init snd_pmac_daca_init(struct snd
 	struct pmac_daca *mix;
 
 #ifdef CONFIG_KMOD
-	if (current->fs->root)
-		request_module("i2c-powermac");
-#endif /* CONFIG_KMOD */	
+	request_module("i2c-powermac");
+#endif /* CONFIG_KMOD */
 
 	mix = kzalloc(sizeof(*mix), GFP_KERNEL);
 	if (! mix)
Index: b/sound/ppc/tumbler.c
===================================================================
--- a/sound/ppc/tumbler.c
+++ b/sound/ppc/tumbler.c
@@ -1327,9 +1327,8 @@ int __init snd_pmac_tumbler_init(struct 
 	char *chipname;
 
 #ifdef CONFIG_KMOD
-	if (current->fs->root)
-		request_module("i2c-powermac");
-#endif /* CONFIG_KMOD */	
+	request_module("i2c-powermac");
+#endif /* CONFIG_KMOD */
 
 	mix = kzalloc(sizeof(*mix), GFP_KERNEL);
 	if (! mix)

-- 

