Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbXJXKUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbXJXKUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXJXKT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:19:56 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:34194 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXJXKTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:19:55 -0400
Message-ID: <471F1C48.1000803@tiscali.nl>
Date: Wed, 24 Oct 2007 12:19:52 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/?] Unlock when sn_oemdata can't be extended
References: <471E9322.1030408@tiscali.nl>
In-Reply-To: <471E9322.1030408@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

     Several unlocking issues
     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/net/9p/mux.c b/net/9p/mux.c
index f140147..c9f0805 100644
--- a/net/9p/mux.c
+++ b/net/9p/mux.c
@@ -222,8 +222,10 @@ static int p9_mux_poll_start(struct p9_conn *m)
 	}
 
 	if (i >= ARRAY_SIZE(p9_mux_poll_tasks)) {
-		if (vptlast == NULL)
+		if (vptlast == NULL) {
+			mutex_unlock(&p9_mux_task_lock);
 			return -ENOMEM;
+		}
 
 		P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
 		list_add(&m->mux_list, &vptlast->mux_list);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 817169e..b09c499 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -282,8 +282,10 @@ find_inlist_lock_noload(struct list_head *head, const char *name, int *error,
 		return NULL;
 
 	list_for_each_entry(e, head, list) {
-		if (strcmp(e->name, name) == 0)
+		if (strcmp(e->name, name) == 0) {
+			mutex_unlock(mutex);
 			return e;
+		}
 	}
 	*error = -ENOENT;
 	mutex_unlock(mutex);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9be1826..cf18097 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1079,7 +1079,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 						    CTA_TUPLE_MASTER,
 						    u3);
 			if (err < 0)
-				return err;
+				goto out_unlock;
 
 			master_h = __nf_conntrack_find(&master, NULL);
 			if (master_h == NULL) {
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 509defe..859fdc0 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -750,8 +750,10 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 
 	rose->neighbour = rose_get_neigh(&addr->srose_addr, &cause,
 					 &diagnostic);
-	if (!rose->neighbour)
-		return -ENETUNREACH;
+	if (!rose->neighbour) {
+		err = -ENETUNREACH;
+		goto out_release;
+	}
 
 	rose->lci = rose_new_lci(rose->neighbour);
 	if (!rose->lci) {
diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index 23018a7..5b0e9bd 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -1833,12 +1833,16 @@ au1550_open(struct inode *inode, struct file *file)
 	}
 
 	if (file->f_mode & FMODE_READ) {
-		if ((ret = prog_dmabuf_adc(s)))
+		if ((ret = prog_dmabuf_adc(s))) {
+			mutex_unlock(&s->open_mutex);
 			return ret;
+		}
 	}
 	if (file->f_mode & FMODE_WRITE) {
-		if ((ret = prog_dmabuf_dac(s)))
+		if ((ret = prog_dmabuf_dac(s))) {
+			mutex_unlock(&s->open_mutex);
 			return ret;
+		}
 	}
 
 	s->open_mode |= file->f_mode & (FMODE_READ | FMODE_WRITE);
diff --git a/sound/oss/dmasound/dmasound_atari.c b/sound/oss/dmasound/dmasound_atari.c
index 285239d..d23a089 100644
--- a/sound/oss/dmasound/dmasound_atari.c
+++ b/sound/oss/dmasound/dmasound_atari.c
@@ -1276,6 +1276,7 @@ static irqreturn_t AtaInterrupt(int irq, void *dummy)
 		 * (almost) like on the TT.
 		 */
 		write_sq_ignore_int = 0;
+		spin_unlock(&dmasound.lock);
 		return IRQ_HANDLED;
 	}
 
@@ -1284,6 +1285,7 @@ static irqreturn_t AtaInterrupt(int irq, void *dummy)
 		 * the sq variables, so better don't do anything here.
 		 */
 		WAKE_UP(write_sq.sync_queue);
+		spin_unlock(&dmasound.lock);
 		return IRQ_HANDLED;
 	}
 
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index 880b824..2f62ad6 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -608,6 +608,7 @@ static int snd_mixart_hw_params(struct snd_pcm_substream *subs,
 	/* set the format to the board */
 	err = mixart_set_format(stream, format);
 	if(err < 0) {
+		mutex_unlock(&mgr->setup_mutex);
 		return err;
 	}
 

