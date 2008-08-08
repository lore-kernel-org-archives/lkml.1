Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYHHMnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYHHMnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYHHMnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:43:01 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:53905 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYHHMnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:43:01 -0400
Date: Fri, 8 Aug 2008 14:42:48 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: paul.clements@steeleye.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] nbd: Fix memory leak of nbd_dev array
Message-ID: <alpine.LNX.1.10.0808081434550.16201@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Fri, 08 Aug 2008 12:42:58 +0000
	Bayes: 0.0028 Tokens: new, 181; hammy, 5; neutral, 2; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0028]
X-Spam-Signature: 9f85697f942f34f4294a388ea32067a20ed278a9
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We leak the memory allocated for the nbd_dev array at multiple places. Fix them
by either adding a kfree() or by rearranging code to return before we allocate
the memory.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/block/nbd.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

Only compile-tested.

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index ad98dda..1778e4a 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -707,15 +707,15 @@ static int __init nbd_init(void)
 
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
-	nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
-	if (!nbd_dev)
-		return -ENOMEM;
-
 	if (max_part < 0) {
 		printk(KERN_CRIT "nbd: max_part must be >= 0\n");
 		return -EINVAL;
 	}
 
+	nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
+	if (!nbd_dev)
+		return -ENOMEM;
+
 	part_shift = 0;
 	if (max_part > 0)
 		part_shift = fls(max_part);
@@ -779,6 +779,7 @@ out:
 		blk_cleanup_queue(nbd_dev[i].disk->queue);
 		put_disk(nbd_dev[i].disk);
 	}
+	kfree(nbd_dev);
 	return err;
 }
 
@@ -795,6 +796,7 @@ static void __exit nbd_cleanup(void)
 		}
 	}
 	unregister_blkdev(NBD_MAJOR, "nbd");
+	kfree(nbd_dev);
 	printk(KERN_INFO "nbd: unregistered device at major %d\n", NBD_MAJOR);
 }
 
