Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbZEKOUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbZEKOUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZEKOUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:20:23 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43893 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751860AbZEKOUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:20:23 -0400
Date: Mon, 11 May 2009 16:20:20 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Christoph Hellwig <hch@lst.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       Jim Paris <jim@jtan.com>, linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [PATCH 04/15] ps3vram: Replace mutex by spinlock
 + list
In-Reply-To: <20090510190505.GA23535@lst.de>
Message-ID: <alpine.LRH.2.00.0905111615460.302@vixen.sonytel.be>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090510190505.GA23535@lst.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009, Christoph Hellwig wrote:
> On Fri, May 08, 2009 at 04:01:13PM +0200, Geert Uytterhoeven wrote:
> > Remove the mutex serializing access to the cache.
> > Instead, queue up new requests on a list if the driver is busy.
> 
> This should use the bio list helpers moved into bio.h in commit
> 8f3d8ba20e67991b531e9c0227dcd1f99271a32c

Ah, those didn't exist at the time of my previous submission ;-)

Like this?
Note that I had to introduce bio_list_peek(), as bio_list_pop() makes the list
empty, and I cannot do that until the request has been processed.

I'll split of the introduction of bio_list_peek() in a separate patch and will
merge the rest in my earlier patches, if this is what you want.

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index abda565..aac51a2 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -81,7 +81,7 @@ struct ps3vram_priv {
 	struct ps3vram_cache cache;
 
 	spinlock_t lock;	/* protecting list of bios */
-	struct bio *tail;
+	struct bio_list list;
 };
 
 
@@ -579,11 +579,8 @@ static struct bio *ps3vram_do_bio(struct ps3_system_bus_device *dev,
 
 out:
 	spin_lock_irq(&priv->lock);
-	next = bio->bi_next;
-	if (!next)
-		priv->tail = NULL;
-	else
-		bio->bi_next = NULL;
+	bio_list_pop(&priv->list);
+	next = bio_list_peek(&priv->list);
 	spin_unlock_irq(&priv->lock);
 
 	bio_endio(bio, error);
@@ -594,20 +591,18 @@ static int ps3vram_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct ps3_system_bus_device *dev = q->queuedata;
 	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
+	int busy;
 
 	dev_dbg(&dev->core, "%s\n", __func__);
 
 	spin_lock_irq(&priv->lock);
-	if (priv->tail) {
-		priv->tail->bi_next = bio;
-		priv->tail = bio;
-		spin_unlock_irq(&priv->lock);
-		return 0;
-	}
-
-	priv->tail = bio;
+	busy = !bio_list_empty(&priv->list);
+	bio_list_add(&priv->list, bio);
 	spin_unlock_irq(&priv->lock);
 
+	if (busy)
+		return 0;
+
 	do {
 		bio = ps3vram_do_bio(dev, bio);
 	} while (bio);
@@ -632,6 +627,7 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
 	}
 
 	spin_lock_init(&priv->lock);
+	bio_list_init(&priv->list);
 	dev_set_drvdata(&dev->core, priv);
 
 	/* Allocate XDR buffer (1MiB aligned) */
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7b214fd..618bb7d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -590,6 +590,11 @@ static inline void bio_list_merge_head(struct bio_list *bl,
 	bl->head = bl2->head;
 }
 
+static inline struct bio *bio_list_peek(struct bio_list *bl)
+{
+	return bl->head;
+}
+
 static inline struct bio *bio_list_pop(struct bio_list *bl)
 {
 	struct bio *bio = bl->head;

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
