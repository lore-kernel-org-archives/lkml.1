Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYKXTgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYKXTgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYKXTfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:35:39 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:30694 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYKXTfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:35:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BS2JTJ0WAkTgvnKXVdkPGs19CGYirKKC/DIptWbKJT9xeFO3Q2FoeIOxKqvWOikzTY
         R4OodRybcRMSLRmmXc/7l7XKgNHZ4SOF3GNFsD6njmSKgM2d8ML196y+ziZaMtvxhQOw
         lt7VK72DLdLLwY/Os9nJ7Ir19zVe/BdGhoxQQ=
Subject: Re: [PATCH-mm] kernel: add common endian load/store API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1227553971.5511.15.camel@brick>
References: <1227553971.5511.15.camel@brick>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 11:35:33 -0800
Message-Id: <1227555333.5511.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] block: aoe switch to the new endian helpers

Add the necesary casts now that the unaligned helpers are typesafe
and switch to load_* where possible as it is more efficient.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, I thought it might be helpful to show what the new API will
look like as it gets used, this is an example conversion patch.

 drivers/block/aoe/aoecmd.c |   30 +++++++++++++++---------------
 drivers/block/aoe/aoenet.c |    4 ++--
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 71ff78c..199494a 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -642,16 +642,16 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 	u16 n;
 
 	/* word 83: command set supported */
-	n = get_unaligned_le16(&id[83 << 1]);
+	n = load_le16_noalign((__le16 *)&id[83 << 1]);
 
 	/* word 86: command set/feature enabled */
-	n |= get_unaligned_le16(&id[86 << 1]);
+	n |= load_le16_noalign((__le16 *)&id[86 << 1]);
 
 	if (n & (1<<10)) {	/* bit 10: LBA 48 */
 		d->flags |= DEVFL_EXT;
 
 		/* word 100: number lba48 sectors */
-		ssize = get_unaligned_le64(&id[100 << 1]);
+		ssize = load_le16_noalign((__le16 *)&id[100 << 1]);
 
 		/* set as in ide-disk.c:init_idedisk_capacity */
 		d->geo.cylinders = ssize;
@@ -662,12 +662,12 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 		d->flags &= ~DEVFL_EXT;
 
 		/* number lba28 sectors */
-		ssize = get_unaligned_le32(&id[60 << 1]);
+		ssize = load_le32_noalign((__le32 *)&id[60 << 1]);
 
 		/* NOTE: obsolete in ATA 6 */
-		d->geo.cylinders = get_unaligned_le16(&id[54 << 1]);
-		d->geo.heads = get_unaligned_le16(&id[55 << 1]);
-		d->geo.sectors = get_unaligned_le16(&id[56 << 1]);
+		d->geo.cylinders = load_le16_noalign((__le16 *)&id[54 << 1]);
+		d->geo.heads = load_le16_noalign((__le16 *)&id[55 << 1]);
+		d->geo.sectors = load_le16_noalign((__le16 *)&id[56 << 1]);
 	}
 
 	if (d->ssize != ssize)
@@ -760,7 +760,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	u16 aoemajor;
 
 	hin = (struct aoe_hdr *) skb_mac_header(skb);
-	aoemajor = get_unaligned_be16(&hin->major);
+	aoemajor = load_be16_noalign(&hin->major);
 	d = aoedev_by_aoeaddr(aoemajor, hin->minor);
 	if (d == NULL) {
 		snprintf(ebuf, sizeof ebuf, "aoecmd_ata_rsp: ata response "
@@ -772,7 +772,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	spin_lock_irqsave(&d->lock, flags);
 
-	n = get_unaligned_be32(&hin->tag);
+	n = load_be32_noalign(&hin->tag);
 	t = gettgt(d, hin->src);
 	if (t == NULL) {
 		printk(KERN_INFO "aoe: can't find target e%ld.%d:%012llx\n",
@@ -787,9 +787,9 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		snprintf(ebuf, sizeof ebuf,
 			"%15s e%d.%d    tag=%08x@%08lx\n",
 			"unexpected rsp",
-			get_unaligned_be16(&hin->major),
+			load_be16_noalign(&hin->major),
 			hin->minor,
-			get_unaligned_be32(&hin->tag),
+			load_be32_noalign(&hin->tag),
 			jiffies);
 		aoechr_error(ebuf);
 		return;
@@ -854,7 +854,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			printk(KERN_INFO
 				"aoe: unrecognized ata command %2.2Xh for %d.%d\n",
 				ahout->cmdstat,
-				get_unaligned_be16(&hin->major),
+				load_be16_noalign(&hin->major),
 				hin->minor);
 		}
 	}
@@ -982,7 +982,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	 * Enough people have their dip switches set backwards to
 	 * warrant a loud message for this special case.
 	 */
-	aoemajor = get_unaligned_be16(&h->major);
+	aoemajor = load_be16_noalign(&h->major);
 	if (aoemajor == 0xfff) {
 		printk(KERN_ERR "aoe: Warning: shelf address is all ones.  "
 			"Check shelf dip switches.\n");
@@ -996,7 +996,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 		return;
 	}
 
-	n = be16_to_cpu(ch->bufcnt);
+	n = load_be16(&ch->bufcnt);
 	if (n > aoe_maxout)	/* keep it reasonable */
 		n = aoe_maxout;
 
@@ -1049,7 +1049,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
 	}
-	d->fw_ver = be16_to_cpu(ch->fwver);
+	d->fw_ver = load_be16(&ch->fwver);
 
 	sl = aoecmd_ata_id(d);
 
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 9157d64..7a61d54 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -127,7 +127,7 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 	skb_push(skb, ETH_HLEN);	/* (1) */
 
 	h = (struct aoe_hdr *) skb_mac_header(skb);
-	n = get_unaligned_be32(&h->tag);
+	n = load_be32_noalign(&h->tag);
 	if ((h->verfl & AOEFL_RSP) == 0 || (n & 1<<31))
 		goto exit;
 
@@ -139,7 +139,7 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 			printk(KERN_ERR
 				"%s%d.%d@%s; ecode=%d '%s'\n",
 				"aoe: error packet from ",
-				get_unaligned_be16(&h->major),
+				load_be16_noalign(&h->major),
 				h->minor, skb->dev->name,
 				h->err, aoe_errlist[n]);
 		goto exit;
-- 
1.6.0.4.1013.gc6a01



