Return-Path: <linux-kernel-owner+w=401wt.eu-S2992544AbXCBPzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992544AbXCBPzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992548AbXCBPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:55:18 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49686 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992545AbXCBPzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:55:12 -0500
Subject: [PATCH 5/9] mtd: Allow dynamic major/minor number for mtd block
	devices
From: Richard Purdie <rpurdie@openedhand.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 15:54:49 +0000
Message-Id: <1172850889.11149.125.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow mtd block devices to have a dynamically allocated major/minor 
numbers if tr->major == 0.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 drivers/mtd/mtd_blkdevs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/drivers/mtd/mtd_blkdevs.c
===================================================================
--- linux.orig/drivers/mtd/mtd_blkdevs.c	2007-02-28 18:16:52.000000000 +0000
+++ linux/drivers/mtd/mtd_blkdevs.c	2007-03-02 14:46:29.000000000 +0000
@@ -380,13 +380,16 @@ int register_mtd_blktrans(struct mtd_blk
 	mutex_lock(&mtd_table_mutex);
 
 	ret = register_blkdev(tr->major, tr->name);
-	if (ret) {
+	if (ret < 0) {
 		printk(KERN_WARNING "Unable to register %s block device on major %d: %d\n",
 		       tr->name, tr->major, ret);
 		kfree(tr->blkcore_priv);
 		mutex_unlock(&mtd_table_mutex);
 		return ret;
 	}
+	if (!tr->major)
+		tr->major = ret;
+
 	spin_lock_init(&tr->blkcore_priv->queue_lock);
 	init_completion(&tr->blkcore_priv->thread_dead);
 	init_waitqueue_head(&tr->blkcore_priv->thread_wq);


