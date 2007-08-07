Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbXHGKxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbXHGKxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 06:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbXHGKww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 06:52:52 -0400
Received: from cm135.gamma145.maxonline.com.sg ([202.156.145.135]:51996 "EHLO
	kerndev.sin.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755102AbXHGKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 06:52:52 -0400
Date: Tue, 7 Aug 2007 18:52:49 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ALSA] seq: resource leak fix and various code cleanups
Message-ID: <20070807105249.GA4702@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20070807084048.GA5205@kernel.sg> <s5hk5s7brxd.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk5s7brxd.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi-san,

<quote sender="Takashi Iwai">
> At Tue, 7 Aug 2007 16:40:48 +0800,
> Eugene Teo wrote:
> > 
> > This patch fixes:
> > 1) a resource leak (CID: 1817)
> > 2) various code cleanups
[...]
> >  	if (i >= SNDRV_SEQ_OSS_MAX_CLIENTS) {
> >  		snd_printk(KERN_ERR "too many applications\n");
> > -		kfree(dp);
> > -		return -ENOMEM;
> > +		rc = -ENOMEM;
> > +		goto _error;
> 
> This seems wrong.  It goes before initializing dp->queue = -1, so it
> screws up delete_seq_queue().

You are right. The initialisations should come first.

> > @@ -276,11 +281,13 @@ snd_seq_oss_open(struct file *file, int level)
> >  	return 0;
> >  
> >   _error:
> > -	snd_seq_oss_synth_cleanup(dp);
> > -	snd_seq_oss_midi_cleanup(dp);
> > -	i = dp->queue;
> > +	snd_seq_oss_writeq_delete(dp->writeq);
> > +	snd_seq_oss_readq_delete(dp->readq);
> > +	delete_seq_queue(dp->queue);
> >  	delete_port(dp);
> > -	delete_seq_queue(i);
> > +	snd_seq_oss_midi_cleanup(dp);
> > +	snd_seq_oss_synth_cleanup(dp);
> > +	kfree(dp);
> 
> The order of these calls is important.  Did you test it and confirm
> that it has no side effects?

Only snd_seq_oss_synth_cleanup() and snd_seq_oss_midi_cleanup() should
be in order. The rest of the cleanup functions do not depend on one
another. Thanks for your advice.

Here's my second try:

This patch fixes:
1) a resource leak (CID: 1817)
2) various code cleanups

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 sound/core/seq/oss/seq_oss_init.c   |   40 +++++++++++++++++++++--------------
 sound/core/seq/oss/seq_oss_writeq.c |    6 +++-
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index ca5a2ed..f26b751 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -176,29 +176,31 @@ snd_seq_oss_open(struct file *file, int level)
 	int i, rc;
 	struct seq_oss_devinfo *dp;
 
-	if ((dp = kzalloc(sizeof(*dp), GFP_KERNEL)) == NULL) {
+	dp = kzalloc(sizeof(*dp), GFP_KERNEL);
+	if (!dp) {
 		snd_printk(KERN_ERR "can't malloc device info\n");
 		return -ENOMEM;
 	}
 	debug_printk(("oss_open: dp = %p\n", dp));
 
+	dp->cseq = system_client;
+	dp->port = -1;
+	dp->queue = -1;
+	dp->readq = NULL;
+	dp->writeq = NULL;
+
 	for (i = 0; i < SNDRV_SEQ_OSS_MAX_CLIENTS; i++) {
 		if (client_table[i] == NULL)
 			break;
 	}
+
+	dp->index = i;
 	if (i >= SNDRV_SEQ_OSS_MAX_CLIENTS) {
 		snd_printk(KERN_ERR "too many applications\n");
-		kfree(dp);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto _error;
 	}
 
-	dp->index = i;
-	dp->cseq = system_client;
-	dp->port = -1;
-	dp->queue = -1;
-	dp->readq = NULL;
-	dp->writeq = NULL;
-
 	/* look up synth and midi devices */
 	snd_seq_oss_synth_setup(dp);
 	snd_seq_oss_midi_setup(dp);
@@ -211,14 +213,16 @@ snd_seq_oss_open(struct file *file, int level)
 
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
@@ -235,7 +239,8 @@ snd_seq_oss_open(struct file *file, int level)
 	/* initialize read queue */
 	debug_printk(("initialize read queue\n"));
 	if (is_read_mode(dp->file_mode)) {
-		if ((dp->readq = snd_seq_oss_readq_new(dp, maxqlen)) == NULL) {
+		dp->readq = snd_seq_oss_readq_new(dp, maxqlen);
+		if (dp->readq == NULL) {
 			rc = -ENOMEM;
 			goto _error;
 		}
@@ -253,7 +258,8 @@ snd_seq_oss_open(struct file *file, int level)
 
 	/* initialize timer */
 	debug_printk(("initialize timer\n"));
-	if ((dp->timer = snd_seq_oss_timer_new(dp)) == NULL) {
+	dp->timer = snd_seq_oss_timer_new(dp);
+	if (dp->timer == NULL) {
 		snd_printk(KERN_ERR "can't alloc timer\n");
 		rc = -ENOMEM;
 		goto _error;
@@ -276,11 +282,13 @@ snd_seq_oss_open(struct file *file, int level)
 	return 0;
 
  _error:
+	snd_seq_oss_writeq_delete(dp->writeq);
+	snd_seq_oss_readq_delete(dp->readq);
 	snd_seq_oss_synth_cleanup(dp);
 	snd_seq_oss_midi_cleanup(dp);
-	i = dp->queue;
 	delete_port(dp);
-	delete_seq_queue(i);
+	delete_seq_queue(dp->queue);
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
 
 
