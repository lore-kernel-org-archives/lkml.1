Return-Path: <linux-kernel-owner+w=401wt.eu-S932338Ab0AFQ5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0AFQ5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932249Ab0AFQ52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:57:28 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:37034 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab0AFQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:57:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: chris.mason@oracle.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] FS: btrfs, fix memory leaks
Date: Wed,  6 Jan 2010 17:57:22 +0100
Message-Id: <1262797042-24179-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found 2 memory leaks in relocate_block_group and
__btrfs_map_block. cluster and multi are not freed/assigned on all
paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/relocation.c |    4 +++-
 fs/btrfs/volumes.c    |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index cfcc93c..4565f5b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3274,8 +3274,10 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 		return -ENOMEM;
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		kfree(cluster);
 		return -ENOMEM;
+	}
 
 	rc->extents_found = 0;
 	rc->extents_skipped = 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7eda483..8555028 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2649,8 +2649,10 @@ again:
 	em = lookup_extent_mapping(em_tree, logical, *length);
 	read_unlock(&em_tree->lock);
 
-	if (!em && unplug_page)
+	if (!em && unplug_page) {
+		kfree(multi);
 		return 0;
+	}
 
 	if (!em) {
 		printk(KERN_CRIT "unable to find logical %llu len %llu\n",
-- 
1.6.5.7

