Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbXFZTFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbXFZTFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbXFZTFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:05:08 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25141 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757777AbXFZTFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:05:06 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2007 15:05:05 EDT
Message-Id: <19c0f3f4dad37b55efbf128ce35ced74dee3073d.1182883861.git.ecashin@coraid.com>
In-Reply-To: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:10 -0400
Subject: [PATCH 03/12] mac_addr: avoid 64-bit arch compiler warnings
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By returning unsigned long long, mac_addr does not generate compiler
warnings on 64-bit architectures.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |    3 +--
 drivers/block/aoe/aoecmd.c |   10 +++++-----
 drivers/block/aoe/aoenet.c |    4 ++--
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 069f04c..f085465 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -208,4 +208,4 @@ void aoenet_xmit(struct sk_buff *);
 int is_aoe_netif(struct net_device *ifp);
 int set_aoe_iflist(const char __user *str, size_t size);
 
-u64 mac_addr(char addr[6]);
+unsigned long long mac_addr(char addr[6]);
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index f6773ab..c9cf576 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -32,8 +32,7 @@ static ssize_t aoedisk_show_mac(struct gendisk * disk, char *page)
 
 	if (t == NULL)
 		return snprintf(page, PAGE_SIZE, "none\n");
-	return snprintf(page, PAGE_SIZE, "%012llx\n",
-			(unsigned long long)mac_addr(t->addr));
+	return snprintf(page, PAGE_SIZE, "%012llx\n", mac_addr(t->addr));
 }
 static ssize_t aoedisk_show_netif(struct gendisk * disk, char *page)
 {
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 8a3a973..62ba58c 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -305,7 +305,8 @@ resend(struct aoedev *d, struct aoetgt *t, struct frame *f)
 	snprintf(buf, sizeof buf,
 		"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x s=%012llx d=%012llx nout=%d\n",
 		"retransmit", d->aoemajor, d->aoeminor, f->tag, jiffies, n,
-		mac_addr(h->src), mac_addr(h->dst), t->nout);
+		mac_addr(h->src),
+		mac_addr(h->dst), t->nout);
 	aoechr_error(buf);
 
 	f->tag = n;
@@ -616,7 +617,7 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 
 	if (d->ssize != ssize)
 		printk(KERN_INFO "aoe: %012llx e%lu.%lu v%04x has %llu sectors\n",
-			(unsigned long long)mac_addr(t->addr),
+			mac_addr(t->addr),
 			d->aoemajor, d->aoeminor,
 			d->fw_ver, (long long)ssize);
 	d->ssize = ssize;
@@ -710,8 +711,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	t = gettgt(d, hin->src);
 	if (t == NULL) {
 		printk(KERN_INFO "aoe: can't find target e%ld.%d:%012llx\n",
-			d->aoemajor, d->aoeminor,
-			(unsigned long long) mac_addr(hin->src));
+			d->aoemajor, d->aoeminor, mac_addr(hin->src));
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
 	}
@@ -988,7 +988,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 			printk(KERN_INFO
 				"aoe: e%ld.%d: setting %d byte data frames on %s:%012llx\n",
 				d->aoemajor, d->aoeminor, n, ifp->nd->name,
-				(unsigned long long) mac_addr(t->addr));
+				mac_addr(t->addr));
 			ifp->maxbcnt = n;
 		}
 	}
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index f335099..d2c1a47 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -82,7 +82,7 @@ set_aoe_iflist(const char __user *user_str, size_t size)
 	return 0;
 }
 
-u64
+unsigned long long
 mac_addr(char addr[6])
 {
 	__be64 n = 0;
@@ -90,7 +90,7 @@ mac_addr(char addr[6])
 
 	memcpy(p + 2, addr, 6);	/* (sizeof addr != 6) */
 
-	return __be64_to_cpu(n);
+	return (unsigned long long) __be64_to_cpu(n);
 }
 
 void
-- 
1.5.2.1

