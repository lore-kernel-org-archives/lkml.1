Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbXJVGzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbXJVGzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXJVGy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:54:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33079 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbXJVGy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:54:57 -0400
Date: Mon, 22 Oct 2007 12:24:51 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] Don't touch fs_struct in drivers
Message-ID: <20071022065451.GB6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065352.GA6489@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

The sound drivers and the pnpbios core test for current->root != NULL. This
test seems to be unnecessary since we always have rootfs mounted before
initializing the drivers.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
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
