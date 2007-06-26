Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbXFZTGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbXFZTGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759504AbXFZTFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:05:37 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25146 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757506AbXFZTFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:05:36 -0400
Message-Id: <bca4cec8ad679e8f8549cb78e012e54bfad1027e.1182883861.git.ecashin@coraid.com>
In-Reply-To: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:11 -0400
Subject: [PATCH 07/12] use a dynamic pool of sk_buffs to keep up with fast targets
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use a dynamic pool of sk_buffs to keep up with fast targets.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    5 ++
 drivers/block/aoe/aoecmd.c |  129 +++++++++++++++++++++++++++++---------------
 drivers/block/aoe/aoedev.c |   51 +++++++++++++++---
 3 files changed, 134 insertions(+), 51 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 7fa86dd..55c2f08 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -98,6 +98,7 @@ enum {
 	MIN_BUFS = 16,
 	NTARGETS = 8,
 	NAOEIFS = 8,
+	NSKBPOOLMAX = 128,
 
 	TIMERTICK = HZ / 10,
 	MINTIMER = HZ >> 2,
@@ -147,6 +148,7 @@ struct aoetgt {
 	u16 useme;
 	ulong lastwadj;		/* last window adjustment */
 int wpkts, rpkts;
+int dataref;
 };
 
 struct aoedev {
@@ -168,6 +170,9 @@ struct aoedev {
 	spinlock_t lock;
 	struct sk_buff *sendq_hd; /* packets needing to be sent, list head */
 	struct sk_buff *sendq_tl;
+	struct sk_buff *skbpool_hd;
+	struct sk_buff *skbpool_tl;
+	int nskbpool;
 	mempool_t *bufpool;	/* for deadlock-free Buf allocation */
 	struct list_head bufq;	/* queue of bios to work on */
 	struct buf *inprocess;	/* the one we're currently working on */
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 62ba58c..89df9de 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -105,43 +105,102 @@ ifrotate(struct aoetgt *t)
 	}
 }
 
+static void
+skb_pool_put(struct aoedev *d, struct sk_buff *skb)
+{
+	if (!d->skbpool_hd)
+		d->skbpool_hd = skb;
+	else
+		d->skbpool_tl->next = skb;
+	d->skbpool_tl = skb;
+}
+
+static struct sk_buff *
+skb_pool_get(struct aoedev *d)
+{
+	struct sk_buff *skb;
+
+	skb = d->skbpool_hd;
+	if (skb)
+	if (atomic_read(&skb_shinfo(skb)->dataref) == 1) {
+		d->skbpool_hd = skb->next;
+		skb->next = NULL;
+		return skb;
+	}
+	if (d->nskbpool < NSKBPOOLMAX)
+	if ((skb = new_skb(ETH_ZLEN))) {
+		d->nskbpool++;
+		return skb;
+	}
+	return NULL;
+}
+
+/* freeframe is where we do our load balancing so it's a little hairy. */
 static struct frame *
 freeframe(struct aoedev *d)
 {
-	struct frame *f, *e;
+	struct frame *f, *e, *rf;
 	struct aoetgt **t;
-	ulong n;
+	struct sk_buff *skb;
 
 	if (d->targets[0] == NULL) {	/* shouldn't happen, but I'm paranoid */
 		printk(KERN_ERR "aoe: NULL TARGETS!\n");
 		return NULL;
 	}
-	t = d->targets;
-	do {
+	t = d->tgt;
+	t++;
+	if (t >= &d->targets[NTARGETS] || !*t)
+		t = d->targets;
+	for (;;) {
+		if ((*t)->nout < (*t)->maxout)
 		if (t != d->htgt)
-		if ((*t)->ifp->nd)
-		if ((*t)->nout < (*t)->maxout) {
-			n = (*t)->nframes;
+		if ((*t)->ifp->nd) {
+			rf = NULL;
 			f = (*t)->frames;
-			e = f + n;
+			e = f + (*t)->nframes;
 			for (; f<e; f++) {
 				if (f->tag != FREETAG)
 					continue;
-				if (atomic_read(&skb_shinfo(f->skb)->dataref) != 1) {
-					n--;
+				skb = f->skb;
+				if (!skb)
+				if (!(f->skb = skb = new_skb(ETH_ZLEN)))
+					continue;
+				if (atomic_read(&skb_shinfo(skb)->dataref) != 1) {
+					if (!rf)
+						rf = f;
 					continue;
 				}
-				skb_shinfo(f->skb)->nr_frags = f->skb->data_len = 0;
-				skb_trim(f->skb, 0);
+gotone:				skb_shinfo(skb)->nr_frags = skb->data_len = 0;
+				skb_trim(skb, 0);
 				d->tgt = t;
 				ifrotate(*t);
 				return f;
 			}
-			if (n == 0)	/* slow polling network card */
+			/* Work can be done, but the network layer is
+			   holding our precious packets.  Try to grab
+			   one from the pool. */
+			f = rf;
+			if (f == NULL) {	/* more paranoia */
+				printk(KERN_ERR "aoe: freeframe: unexpected null rf.\n");
+				d->flags |= DEVFL_KICKME;
+				return NULL;
+			}
+			skb = skb_pool_get(d);
+			if (skb) {
+				skb_pool_put(d, f->skb);
+				f->skb = skb;
+				goto gotone;
+			}
+			(*t)->dataref++;
+			if ((*t)->nout == 0)
 				d->flags |= DEVFL_KICKME;
 		}
+		if (t == d->tgt)	/* we've looped and found nada */
+			break;
 		t++;
-	} while (t < &d->targets[NTARGETS] && *t);
+		if (t >= &d->targets[NTARGETS] || !*t)
+			t = d->targets;
+	}
 	return NULL;
 }
 
@@ -870,44 +929,26 @@ addtgt(struct aoedev *d, char *addr, ulong nframes)
 
 	tt = d->targets;
 	te = tt + NTARGETS;
-	for (; tt<te; tt++) {
-		if (*tt == NULL)
-			break;
-		else if (memcmp((*tt)->addr, addr, 6) > 0) {
-			memmove(tt+1, tt, (void *)te-(void *)(tt+1));
-			break;
-		}
-	}
+	for (; tt<te && *tt; tt++)
+		;
+
 	if (tt == te)
 		return NULL;
 
 	t = kcalloc(1, sizeof *t, GFP_ATOMIC);
+	if (!t)
+		return NULL;
 	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);
-	switch (!t || !f) {
-	case 0:
-		t->nframes = nframes;
-		t->frames = f;
-		e = f + nframes;
-		for (; f<e; f++) {
-			f->tag = FREETAG;
-			f->skb = new_skb(ETH_ZLEN);
-			if (!f->skb)
-				break;
-		}
-		if (f == e)
-			break;
-		while (f > t->frames) {
-			f--;
-			dev_kfree_skb(f->skb);
-		}
-	default:
-		if (f)
-			kfree(f);
-		if (t)
-			kfree(t);
+	if (!f) {
+		kfree(t);
 		return NULL;
 	}
 
+	t->nframes = nframes;
+	t->frames = f;
+	e = f + nframes;
+	for (; f<e; f++)
+		f->tag = FREETAG;
 	memcpy(t->addr, addr, sizeof t->addr);
 	t->ifp = t->ifs;
 	t->maxout = t->nframes;
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 8659796..cf4e58d 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -7,11 +7,13 @@
 #include <linux/hdreg.h>
 #include <linux/blkdev.h>
 #include <linux/netdevice.h>
+#include <linux/delay.h>
 #include "aoe.h"
 
 static void dummy_timer(ulong);
 static void aoedev_freedev(struct aoedev *);
-static void freetgt(struct aoetgt *t);
+static void freetgt(struct aoedev *d, struct aoetgt *t);
+static void skbpoolfree(struct aoedev *d);
 
 static struct aoedev *devlist;
 static spinlock_t devlist_lock;
@@ -125,9 +127,10 @@ aoedev_freedev(struct aoedev *d)
 	t = d->targets;
 	e = t + NTARGETS;
 	for (; t<e && *t; t++)
-		freetgt(*t);
+		freetgt(d, *t);
 	if (d->bufpool)
 		mempool_destroy(d->bufpool);
+	skbpoolfree(d);
 	kfree(d);
 }
 
@@ -176,6 +179,42 @@ aoedev_flush(const char __user *str, size_t cnt)
 	return 0;
 }
 
+/* I'm not really sure that this is a realistic problem, but if the
+network driver goes gonzo let's just leak memory after complaining. */
+static void
+skbfree(struct sk_buff *skb)
+{
+	enum { Sms= 100, Tms= 3*1000};
+	int i = Tms / Sms;
+
+	if (skb == NULL)
+		return;
+	while (atomic_read(&skb_shinfo(skb)->dataref) != 1 && i-- > 0)
+		msleep_interruptible(Sms);
+	if (i <= 0) {
+		printk(KERN_ERR
+			"aoe: %s holds ref: cannot free skb -- memory leaked.\n",
+			skb->dev ? skb->dev->name : "netif");
+		return;
+	}
+	skb_shinfo(skb)->nr_frags = skb->data_len = 0;
+	skb_trim(skb, 0);
+	dev_kfree_skb(skb);
+}
+
+static void
+skbpoolfree(struct aoedev *d)
+{
+	struct sk_buff *skb;
+
+	while ((skb = d->skbpool_hd)) {
+		d->skbpool_hd = skb->next;
+		skb->next = NULL;
+		skbfree(skb);
+	}
+	d->skbpool_tl = NULL;
+}
+
 /* find it or malloc it */
 struct aoedev *
 aoedev_by_sysminor_m(ulong sysminor)
@@ -214,16 +253,14 @@ aoedev_by_sysminor_m(ulong sysminor)
 }
 
 static void
-freetgt(struct aoetgt *t)
+freetgt(struct aoedev *d, struct aoetgt *t)
 {
 	struct frame *f, *e;
 
 	f = t->frames;
 	e = f + t->nframes;
-	for (; f<e; f++) {
-		skb_shinfo(f->skb)->nr_frags = 0;
-		dev_kfree_skb(f->skb);
-	}
+	for (; f<e; f++)
+		skbfree(f->skb);
 	kfree(t->frames);
 	kfree(t);
 }
-- 
1.5.2.1

