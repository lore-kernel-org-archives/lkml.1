Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbYDNWsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbYDNWsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbYDNWr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:47:57 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:58009 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbYDNWr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TOxqEgtV7+/CUefC6o4E52btmHlKpuE6yV+Gf/s91h0e/obwcZRJbiTai3XO1meKce+/sDWPyWSVhcVx4cwn+GQ5MbIwgfQvCHQN2aCGy61QDgxvFqtN4XgGUPtMXfSkgyr8ugWwAlnTPqM1Y0ww9qcr7HhbpHswZJzjxH8KEtM=
Subject: [PATCH-mm 01/15] drivers/block: Use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 15:47:56 -0700
Message-Id: <1208213276.11920.31.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/block/aoe/aoecmd.c |   24 ++++++++++++------------
 drivers/block/aoe/aoenet.c |    4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index d00293b..8fc429c 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -668,16 +668,16 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 	u16 n;
 
 	/* word 83: command set supported */
-	n = le16_to_cpu(get_unaligned((__le16 *) &id[83<<1]));
+	n = get_unaligned_le16(&id[83 << 1]);
 
 	/* word 86: command set/feature enabled */
-	n |= le16_to_cpu(get_unaligned((__le16 *) &id[86<<1]));
+	n |= get_unaligned_le16(&id[86 << 1]);
 
 	if (n & (1<<10)) {	/* bit 10: LBA 48 */
 		d->flags |= DEVFL_EXT;
 
 		/* word 100: number lba48 sectors */
-		ssize = le64_to_cpu(get_unaligned((__le64 *) &id[100<<1]));
+		ssize = get_unaligned_le64(&id[100 << 1]);
 
 		/* set as in ide-disk.c:init_idedisk_capacity */
 		d->geo.cylinders = ssize;
@@ -688,12 +688,12 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 		d->flags &= ~DEVFL_EXT;
 
 		/* number lba28 sectors */
-		ssize = le32_to_cpu(get_unaligned((__le32 *) &id[60<<1]));
+		ssize = get_unaligned_le32(&id[60 << 1]);
 
 		/* NOTE: obsolete in ATA 6 */
-		d->geo.cylinders = le16_to_cpu(get_unaligned((__le16 *) &id[54<<1]));
-		d->geo.heads = le16_to_cpu(get_unaligned((__le16 *) &id[55<<1]));
-		d->geo.sectors = le16_to_cpu(get_unaligned((__le16 *) &id[56<<1]));
+		d->geo.cylinders = get_unaligned_le16(&id[54 << 1]);
+		d->geo.heads = get_unaligned_le16(&id[55 << 1]);
+		d->geo.sectors = get_unaligned_le16(&id[56 << 1]);
 	}
 
 	if (d->ssize != ssize)
@@ -779,7 +779,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	u16 aoemajor;
 
 	hin = (struct aoe_hdr *) skb_mac_header(skb);
-	aoemajor = be16_to_cpu(get_unaligned(&hin->major));
+	aoemajor = get_unaligned_be16(&hin->major);
 	d = aoedev_by_aoeaddr(aoemajor, hin->minor);
 	if (d == NULL) {
 		snprintf(ebuf, sizeof ebuf, "aoecmd_ata_rsp: ata response "
@@ -791,7 +791,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	spin_lock_irqsave(&d->lock, flags);
 
-	n = be32_to_cpu(get_unaligned(&hin->tag));
+	n = get_unaligned_be32(&hin->tag);
 	t = gettgt(d, hin->src);
 	if (t == NULL) {
 		printk(KERN_INFO "aoe: can't find target e%ld.%d:%012llx\n",
@@ -806,9 +806,9 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		snprintf(ebuf, sizeof ebuf,
 			"%15s e%d.%d    tag=%08x@%08lx\n",
 			"unexpected rsp",
-			be16_to_cpu(get_unaligned(&hin->major)),
+			get_unaligned_be16(&hin->major),
 			hin->minor,
-			be32_to_cpu(get_unaligned(&hin->tag)),
+			get_unaligned_be32(&hin->tag),
 			jiffies);
 		aoechr_error(ebuf);
 		return;
@@ -873,7 +873,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			printk(KERN_INFO
 				"aoe: unrecognized ata command %2.2Xh for %d.%d\n",
 				ahout->cmdstat,
-				be16_to_cpu(get_unaligned(&hin->major)),
+				get_unaligned_be16(&hin->major),
 				hin->minor);
 		}
 	}
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 8460ef7..dece4fb 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -128,7 +128,7 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 	skb_push(skb, ETH_HLEN);	/* (1) */
 
 	h = (struct aoe_hdr *) skb_mac_header(skb);
-	n = be32_to_cpu(get_unaligned(&h->tag));
+	n = get_unaligned_be32(&h->tag);
 	if ((h->verfl & AOEFL_RSP) == 0 || (n & 1<<31))
 		goto exit;
 
@@ -140,7 +140,7 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 			printk(KERN_ERR
 				"%s%d.%d@%s; ecode=%d '%s'\n",
 				"aoe: error packet from ",
-				be16_to_cpu(get_unaligned(&h->major)),
+				get_unaligned_be16(&h->major),
 				h->minor, skb->dev->name,
 				h->err, aoe_errlist[n]);
 		goto exit;
-- 
1.5.5.144.g3e42


