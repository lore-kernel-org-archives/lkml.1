Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZKBKM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZKBKM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbZKBKM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:12:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:47312 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbZKBKHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:08 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, William Irwin <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Mel Gorman <mel@csn.ul.ie>,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 19/27] BKL: Remove BKL from hugetlbfs
Date: Mon,  2 Nov 2009 11:04:59 +0100
Message-Id: <1257156307-24175-20-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/hugetlbfs/inode.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 53be2b9..87a1258 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -32,7 +32,6 @@
 #include <linux/security.h>
 #include <linux/ima.h>
 #include <linux/magic.h>
-#include <linux/smp_lock.h> /* Only for lock_kernel() */
 
 #include <asm/uaccess.h>
 
@@ -825,7 +824,6 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct hugetlbfs_config config;
 	struct hugetlbfs_sb_info *sbinfo;
 
-	lock_kernel();
 	save_mount_options(sb, data);
 
 	config.nr_blocks = -1; /* No limit on size by default */
@@ -835,16 +833,12 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 	config.mode = 0755;
 	config.hstate = &default_hstate;
 	ret = hugetlbfs_parse_options(data, &config);
-	if (ret) {
-		unlock_kernel();
+	if (ret)
 		return ret;
-	}
 
 	sbinfo = kmalloc(sizeof(struct hugetlbfs_sb_info), GFP_KERNEL);
-	if (!sbinfo) {
-		unlock_kernel();
+	if (!sbinfo)
 		return -ENOMEM;
-	}
 	sb->s_fs_info = sbinfo;
 	sbinfo->hstate = config.hstate;
 	spin_lock_init(&sbinfo->stat_lock);
@@ -869,11 +863,9 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_free;
 	}
 	sb->s_root = root;
-	unlock_kernel();
 	return 0;
 out_free:
 	kfree(sbinfo);
-	unlock_kernel();
 	return -ENOMEM;
 }
 
-- 
1.6.4.2

