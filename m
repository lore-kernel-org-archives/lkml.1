Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbZIXGyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbZIXGyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 02:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZIXGyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 02:54:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:24771 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbZIXGyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 02:54:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,444,1249282800"; 
   d="scan'208";a="451211214"
Subject: [RFC] page-writeback: move indoes from one superblock together
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       Chris Mason <chris.mason@oracle.com>
Content-Type: multipart/mixed; boundary="=-0Hp2fY4vZvzFvq5IqZad"
Date: Thu, 24 Sep 2009 14:54:20 +0800
Message-Id: <1253775260.10618.10.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0Hp2fY4vZvzFvq5IqZad
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

__mark_inode_dirty adds inode to wb dirty list in random order. If a disk has
several partitions, writeback might keep spindle moving between partitions.
To reduce the move, better write big chunk of one partition and then move to
another. Inodes from one fs usually are in one partion, so idealy move indoes
from one fs together should reduce spindle move. This patch tries to address
this. Before per-bdi writeback is added, the behavior is write indoes
from one fs first and then another, so the patch restores previous behavior.
The loop in the patch is a bit ugly, should we add a dirty list for each
superblock in bdi_writeback?

Test in a two partition disk with attached fio script shows about 3% ~ 6%
improvement.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8e1e5e1..fc87730 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -324,13 +324,29 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 			       struct list_head *dispatch_queue,
 				unsigned long *older_than_this)
 {
+	LIST_HEAD(tmp);
+	struct list_head *pos, *node;
+	struct super_block *sb;
+	struct inode *inode;
+
 	while (!list_empty(delaying_queue)) {
-		struct inode *inode = list_entry(delaying_queue->prev,
-						struct inode, i_list);
+		inode = list_entry(delaying_queue->prev, struct inode, i_list);
 		if (older_than_this &&
 		    inode_dirtied_after(inode, *older_than_this))
 			break;
-		list_move(&inode->i_list, dispatch_queue);
+		list_move(&inode->i_list, &tmp);
+	}
+
+	/* Move indoes from one superblock together */
+	while (!list_empty(&tmp)) {
+		inode = list_entry(tmp.prev, struct inode, i_list);
+		sb = inode->i_sb;
+		list_for_each_prev_safe(pos, node, &tmp) {
+			struct inode *inode = list_entry(pos,
+				struct inode, i_list);
+			if (inode->i_sb == sb)
+				list_move(&inode->i_list, dispatch_queue);
+		}
 	}
 }
 


--=-0Hp2fY4vZvzFvq5IqZad
Content-Disposition: attachment; filename="newfio"
Content-Type: text/plain; name="newfio"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[global]
runtime=120
ioscheduler=cfq
size=2G
ioengine=sync
rw=write
file_service_type=random:256
overwrite=1

[sdb1]
directory=/mnt/b1
nrfiles=10
numjobs=4

[sdb2]
directory=/mnt/b2
nrfiles=10
numjobs=4

--=-0Hp2fY4vZvzFvq5IqZad--

