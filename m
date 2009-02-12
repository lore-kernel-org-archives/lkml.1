Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZBLAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZBLAb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 19:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZBLAbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 19:31:18 -0500
Received: from ns1.coraid.com ([12.51.113.4]:65125 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750793AbZBLAbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:31:18 -0500
X-Greylist: delayed 970 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 19:31:18 EST
From: Ed Cashin <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, karaluh@karaluh.pl,
       Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 1/1] aoe: ignore vendor extension AoE responses
Date: Wed, 11 Feb 2009 19:16:44 -0500
Message-Id: <1234397804-9034-1-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Welland ME-747K-SI AoE target generates unsolicited AoE
responses that are marked as vendor extensions.  Instead of
ignoring these packets, the aoe driver was generating kernel
messages for each unrecognized response received.  This patch
corrects the behavior.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Reported-by: karaluh@karaluh.pl
Tested-by: karaluh@karaluh.pl
---

I will place this patch in the new aoe quilt tree for
linux-next when this patch has passed LKML review.

 drivers/block/aoe/aoe.h    |    1 +
 drivers/block/aoe/aoenet.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index c237527..5e41e6d 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -18,6 +18,7 @@
 enum {
 	AOECMD_ATA,
 	AOECMD_CFG,
+	AOECMD_VEND_MIN = 0xf0,
 
 	AOEFL_RSP = (1<<3),
 	AOEFL_ERR = (1<<2),
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 30de5b1..c6099ba 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -142,6 +142,8 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 		aoecmd_cfg_rsp(skb);
 		break;
 	default:
+		if (h->cmd >= AOECMD_VEND_MIN)
+			break;	/* don't complain about vendor commands */
 		printk(KERN_INFO "aoe: unknown cmd %d\n", h->cmd);
 	}
 exit:
-- 
1.5.6.5

