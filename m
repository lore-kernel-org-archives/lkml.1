Return-Path: <linux-kernel-owner+w=401wt.eu-S1764800AbXHFVFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764800AbXHFVFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759140AbXHFVFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:05:05 -0400
Received: from ns1.coraid.com ([65.14.39.133]:13036 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757846AbXHFVFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:05:04 -0400
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: ecashin@coraid.com, Greg K-H <greg@kroah.com>
Date: Mon, 6 Aug 2007 16:56:13 -0400
Subject: [PATCH] aoe: remove unecessary wrapper function
Message-Id: <E1II9ji-0005jG-00@kokone.coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We can just use skb_mac_header now, and we don't need
a wrapper function to perform the cast.  Instead of
requiring the reader to check aoe.h to look up what an
aoe_hdr function does, I'd rather do without it.
---
 drivers/block/aoe/aoe.h    |    9 ---------
 drivers/block/aoe/aoecmd.c |   14 +++++++-------
 drivers/block/aoe/aoenet.c |    2 +-
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index ba07f76..07f02f8 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -48,15 +48,6 @@ struct aoe_hdr {
 	__be32 tag;
 };
 
-#ifdef __KERNEL__
-#include <linux/skbuff.h>
-
-static inline struct aoe_hdr *aoe_hdr(const struct sk_buff *skb)
-{
-	return (struct aoe_hdr *)skb_mac_header(skb);
-}
-#endif
-
 struct aoe_atahdr {
 	unsigned char aflags;
 	unsigned char errfeat;
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 01fbdd3..8893a26 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -119,7 +119,7 @@ aoecmd_ata_rw(struct aoedev *d, struct frame *f)
 
 	/* initialize the headers & frame */
 	skb = f->skb;
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 	skb_put(skb, sizeof *h + sizeof *ah);
 	memset(h, 0, skb->len);
@@ -208,7 +208,7 @@ aoecmd_cfg_pkts(ushort aoemajor, unsigned char aoeminor, struct sk_buff **tail)
 		skb->dev = ifp;
 		if (sl_tail == NULL)
 			sl_tail = skb;
-		h = aoe_hdr(skb);
+		h = (struct aoe_hdr *) skb_mac_header(skb);
 		memset(h, 0, sizeof *h + sizeof *ch);
 
 		memset(h->dst, 0xff, sizeof h->dst);
@@ -303,7 +303,7 @@ rexmit(struct aoedev *d, struct frame *f)
 	aoechr_error(buf);
 
 	skb = f->skb;
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 	f->tag = n;
 	h->tag = cpu_to_be32(n);
@@ -532,7 +532,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	char ebuf[128];
 	u16 aoemajor;
 
-	hin = aoe_hdr(skb);
+	hin = (struct aoe_hdr *) skb_mac_header(skb);
 	aoemajor = be16_to_cpu(get_unaligned(&hin->major));
 	d = aoedev_by_aoeaddr(aoemajor, hin->minor);
 	if (d == NULL) {
@@ -564,7 +564,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	calc_rttavg(d, tsince(f->tag));
 
 	ahin = (struct aoe_atahdr *) (hin+1);
-	hout = aoe_hdr(f->skb);
+	hout = (struct aoe_hdr *) skb_mac_header(f->skb);
 	ahout = (struct aoe_atahdr *) (hout+1);
 	buf = f->buf;
 
@@ -698,7 +698,7 @@ aoecmd_ata_id(struct aoedev *d)
 
 	/* initialize the headers & frame */
 	skb = f->skb;
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 	skb_put(skb, sizeof *h + sizeof *ah);
 	memset(h, 0, skb->len);
@@ -729,7 +729,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	enum { MAXFRAMES = 16 };
 	u16 n;
 
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ch = (struct aoe_cfghdr *) (h+1);
 
 	/*
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index f9ddfda..d54bf3a 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -123,7 +123,7 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 		goto exit;
 	skb_push(skb, ETH_HLEN);	/* (1) */
 
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	n = be32_to_cpu(get_unaligned(&h->tag));
 	if ((h->verfl & AOEFL_RSP) == 0 || (n & 1<<31))
 		goto exit;
-- 
1.5.2.1

