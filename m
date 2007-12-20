Return-Path: <linux-kernel-owner+w=401wt.eu-S1763533AbXLTWQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763533AbXLTWQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932076AbXLTWP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:15:56 -0500
Received: from baron.coraid.com ([65.14.39.133]:28902 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764745AbXLTWPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:15:55 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 03/13] mac_addr: avoid 64-bit arch compiler warnings
Date: Thu, 20 Dec 2007 17:15:51 -0500
Message-Id: <1198188961-25147-3-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
References: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
index 87df18b..aecaac3 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -198,4 +198,4 @@ void aoenet_xmit(struct sk_buff *);
 int is_aoe_netif(struct net_device *ifp);
 int set_aoe_iflist(const char __user *str, size_t size);
 
-u64 mac_addr(char addr[6]);
+unsigned long long mac_addr(char addr[6]);
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index c2649c9..deea536 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -37,8 +37,7 @@ static ssize_t aoedisk_show_mac(struct device *dev,
 
 	if (t == NULL)
 		return snprintf(page, PAGE_SIZE, "none\n");
-	return snprintf(page, PAGE_SIZE, "%012llx\n",
-			(unsigned long long)mac_addr(t->addr));
+	return snprintf(page, PAGE_SIZE, "%012llx\n", mac_addr(t->addr));
 }
 static ssize_t aoedisk_show_netif(struct device *dev,
 				  struct device_attribute *attr, char *page)
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 5e7daa1..1be5150 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -309,7 +309,8 @@ resend(struct aoedev *d, struct aoetgt *t, struct frame *f)
 		"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x "
 		"s=%012llx d=%012llx nout=%d\n",
 		"retransmit", d->aoemajor, d->aoeminor, f->tag, jiffies, n,
-		mac_addr(h->src), mac_addr(h->dst), t->nout);
+		mac_addr(h->src),
+		mac_addr(h->dst), t->nout);
 	aoechr_error(buf);
 
 	f->tag = n;
@@ -633,7 +634,7 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 
 	if (d->ssize != ssize)
 		printk(KERN_INFO "aoe: %012llx e%lu.%lu v%04x has %llu sectors\n",
-			(unsigned long long)mac_addr(t->addr),
+			mac_addr(t->addr),
 			d->aoemajor, d->aoeminor,
 			d->fw_ver, (long long)ssize);
 	d->ssize = ssize;
@@ -727,8 +728,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	t = gettgt(d, hin->src);
 	if (t == NULL) {
 		printk(KERN_INFO "aoe: can't find target e%ld.%d:%012llx\n",
-			d->aoemajor, d->aoeminor,
-			(unsigned long long) mac_addr(hin->src));
+			d->aoemajor, d->aoeminor, mac_addr(hin->src));
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
 	}
@@ -1003,7 +1003,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 				"aoe: e%ld.%d: setting %d%s%s:%012llx\n",
 				d->aoemajor, d->aoeminor, n,
 				" byte data frames on ", ifp->nd->name,
-				(unsigned long long) mac_addr(t->addr));
+				mac_addr(t->addr));
 			ifp->maxbcnt = n;
 		}
 	}
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 7a38a45..ada4a06 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -83,7 +83,7 @@ set_aoe_iflist(const char __user *user_str, size_t size)
 	return 0;
 }
 
-u64
+unsigned long long
 mac_addr(char addr[6])
 {
 	__be64 n = 0;
@@ -91,7 +91,7 @@ mac_addr(char addr[6])
 
 	memcpy(p + 2, addr, 6);	/* (sizeof addr != 6) */
 
-	return __be64_to_cpu(n);
+	return (unsigned long long) __be64_to_cpu(n);
 }
 
 void
-- 
1.5.3.4

