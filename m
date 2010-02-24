Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0BXBqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:46:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:40537 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0BXBqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:46:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,528,1262592000"; 
   d="scan'208";a="775349604"
Message-Id: <20100224013921.629217000@intel.com>
References: <20100224013858.506388000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 23 Feb 2010 17:38:59 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@sun.com>, Eric Paris <eparis@redhat.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/3] ext4: Fixup rb_root initializations to use RB_ROOT
Content-Disposition: inline; filename=0001-ext4-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext4 uses rb_node = NULL; to zero rb_root at few places.
The problem with this is that 17d9ddc72fb8bba0d4f678 in the
linux-next tree adds a new field to that struct which needs to be NULLas well.
This patch uses RB_ROOT as the intializer so all of the relevant fields will
be NULL'd.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 fs/ext4/block_validity.c |    4 ++--
 fs/ext4/dir.c            |    2 +-
 fs/ext4/mballoc.c        |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index a60ab9a..983f0e1 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -205,14 +205,14 @@ void ext4_release_system_zone(struct super_block *sb)
 		entry = rb_entry(n, struct ext4_system_zone, node);
 		kmem_cache_free(ext4_system_zone_cachep, entry);
 		if (!parent)
-			EXT4_SB(sb)->system_blks.rb_node = NULL;
+			EXT4_SB(sb)->system_blks = RB_ROOT;
 		else if (parent->rb_left == n)
 			parent->rb_left = NULL;
 		else if (parent->rb_right == n)
 			parent->rb_right = NULL;
 		n = parent;
 	}
-	EXT4_SB(sb)->system_blks.rb_node = NULL;
+	EXT4_SB(sb)->system_blks = RB_ROOT;
 }
 
 /*
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 9dc9316..6bdb566 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -303,7 +303,7 @@ static void free_rb_tree_fname(struct rb_root *root)
 			kfree(old);
 		}
 		if (!parent)
-			root->rb_node = NULL;
+			*root = RB_ROOT;
 		else if (parent->rb_left == n)
 			parent->rb_left = NULL;
 		else if (parent->rb_right == n)
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d34afad..ba1d99d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2256,7 +2256,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
 	init_rwsem(&meta_group_info[i]->alloc_sem);
-	meta_group_info[i]->bb_free_root.rb_node = NULL;
+	meta_group_info[i]->bb_free_root = RB_ROOT;
 
 #ifdef DOUBLE_CHECK
 	{
-- 
1.6.0.6

-- 

