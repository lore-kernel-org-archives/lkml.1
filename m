Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbXHGIlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbXHGIlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbXHGIkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:40:51 -0400
Received: from cm135.gamma145.maxonline.com.sg ([202.156.145.135]:59486 "EHLO
	kerndev.sin.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753724AbXHGIku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:40:50 -0400
Date: Tue, 7 Aug 2007 16:40:48 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [ALSA] seq: resource leak fix and various code cleanups
Message-ID: <20070807084048.GA5205@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes:
1) a resource leak (CID: 1817)
2) various code cleanups

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 sound/core/seq/oss/seq_oss_init.c   |   29 ++++++++++++++++++-----------
 sound/core/seq/oss/seq_oss_writeq.c |    6 ++++--
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index ca5a2ed..c9b95c3 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -176,7 +176,8 @@ snd_seq_oss_open(struct file *file, int level)
 	int i, rc;
 	struct seq_oss_devinfo *dp;
 
-	if ((dp = kzalloc(sizeof(*dp), GFP_KERNEL)) == NULL) {
+	dp = kzalloc(sizeof(*dp), GFP_KERNEL);
+	if (dp == NULL) {
 		snd_printk(KERN_ERR "can't malloc device info\n");
 		return -ENOMEM;
 	}
@@ -188,8 +189,8 @@ snd_seq_oss_open(struct file *file, int level)
 	}
 	if (i >= SNDRV_SEQ_OSS_MAX_CLIENTS) {
 		snd_printk(KERN_ERR "too many applications\n");
-		kfree(dp);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto _error;
 	}
 
 	dp->index = i;
@@ -211,14 +212,16 @@ snd_seq_oss_open(struct file *file, int level)
 
 	/* create port */
 	debug_printk(("create new port\n"));
-	if ((rc = create_port(dp)) < 0) {
+	rc = create_port(dp);
+	if (rc < 0) {
 		snd_printk(KERN_ERR "can't create port\n");
 		goto _error;
 	}
 
 	/* allocate queue */
 	debug_printk(("allocate queue\n"));
-	if ((rc = alloc_seq_queue(dp)) < 0)
+	rc = alloc_seq_queue(dp);
+	if (rc < 0)
 		goto _error;
 
 	/* set address */
@@ -235,7 +238,8 @@ snd_seq_oss_open(struct file *file, int level)
 	/* initialize read queue */
 	debug_printk(("initialize read queue\n"));
 	if (is_read_mode(dp->file_mode)) {
-		if ((dp->readq = snd_seq_oss_readq_new(dp, maxqlen)) == NULL) {
+		dp->readq = snd_seq_oss_readq_new(dp, maxqlen);
+		if (dp->readq == NULL) {
 			rc = -ENOMEM;
 			goto _error;
 		}
@@ -253,7 +257,8 @@ snd_seq_oss_open(struct file *file, int level)
 
 	/* initialize timer */
 	debug_printk(("initialize timer\n"));
-	if ((dp->timer = snd_seq_oss_timer_new(dp)) == NULL) {
+	dp->timer = snd_seq_oss_timer_new(dp);
+	if (dp->timer == NULL) {
 		snd_printk(KERN_ERR "can't alloc timer\n");
 		rc = -ENOMEM;
 		goto _error;
@@ -276,11 +281,13 @@ snd_seq_oss_open(struct file *file, int level)
 	return 0;
 
  _error:
-	snd_seq_oss_synth_cleanup(dp);
-	snd_seq_oss_midi_cleanup(dp);
-	i = dp->queue;
+	snd_seq_oss_writeq_delete(dp->writeq);
+	snd_seq_oss_readq_delete(dp->readq);
+	delete_seq_queue(dp->queue);
 	delete_port(dp);
-	delete_seq_queue(i);
+	snd_seq_oss_midi_cleanup(dp);
+	snd_seq_oss_synth_cleanup(dp);
+	kfree(dp);
 
 	return rc;
 }
diff --git a/sound/core/seq/oss/seq_oss_writeq.c b/sound/core/seq/oss/seq_oss_writeq.c
index 5c84956..2174248 100644
--- a/sound/core/seq/oss/seq_oss_writeq.c
+++ b/sound/core/seq/oss/seq_oss_writeq.c
@@ -63,8 +63,10 @@ snd_seq_oss_writeq_new(struct seq_oss_devinfo *dp, int maxlen)
 void
 snd_seq_oss_writeq_delete(struct seq_oss_writeq *q)
 {
-	snd_seq_oss_writeq_clear(q);	/* to be sure */
-	kfree(q);
+	if (q) {
+		snd_seq_oss_writeq_clear(q);	/* to be sure */
+		kfree(q);
+	}
 }
 
 

