Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZGZIYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZGZIYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZGZIYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:24:20 -0400
Received: from www.tglx.de ([62.245.132.106]:34115 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbZGZIYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:24:12 -0400
Message-Id: <20090726081555.484354764@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [Patch RFC 17/37] hpfs: Convert sbi->hpfs_creation_de to mutex
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=hpfs-convert-sem-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sbi->hpfs_creation_de is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/hpfs/buffer.c  |    4 ++--
 fs/hpfs/hpfs_fn.h |    2 +-
 fs/hpfs/super.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/fs/hpfs/buffer.c
===================================================================
--- linux-2.6-tip.orig/fs/hpfs/buffer.c
+++ linux-2.6-tip/fs/hpfs/buffer.c
@@ -13,7 +13,7 @@ void hpfs_lock_creation(struct super_blo
 #ifdef DEBUG_LOCKS
 	printk("lock creation\n");
 #endif
-	down(&hpfs_sb(s)->hpfs_creation_de);
+	mutex_lock(&hpfs_sb(s)->hpfs_creation_de);
 }
 
 void hpfs_unlock_creation(struct super_block *s)
@@ -21,7 +21,7 @@ void hpfs_unlock_creation(struct super_b
 #ifdef DEBUG_LOCKS
 	printk("unlock creation\n");
 #endif
-	up(&hpfs_sb(s)->hpfs_creation_de);
+	mutex_unlock(&hpfs_sb(s)->hpfs_creation_de);
 }
 
 /* Map a sector into a buffer and return pointers to it and to the buffer. */
Index: linux-2.6-tip/fs/hpfs/hpfs_fn.h
===================================================================
--- linux-2.6-tip.orig/fs/hpfs/hpfs_fn.h
+++ linux-2.6-tip/fs/hpfs/hpfs_fn.h
@@ -87,7 +87,7 @@ struct hpfs_sb_info {
 	unsigned *sb_bmp_dir;		/* main bitmap directory */
 	unsigned sb_c_bitmap;		/* current bitmap */
 	unsigned sb_max_fwd_alloc;	/* max forwad allocation */
-	struct semaphore hpfs_creation_de; /* when creating dirents, nobody else
+	struct mutex hpfs_creation_de;	/* when creating dirents, nobody else
 					   can alloc blocks */
 	/*unsigned sb_mounting : 1;*/
 	int sb_timeshift;
Index: linux-2.6-tip/fs/hpfs/super.c
===================================================================
--- linux-2.6-tip.orig/fs/hpfs/super.c
+++ linux-2.6-tip/fs/hpfs/super.c
@@ -487,7 +487,7 @@ static int hpfs_fill_super(struct super_
 	sbi->sb_bmp_dir = NULL;
 	sbi->sb_cp_table = NULL;
 
-	init_MUTEX(&sbi->hpfs_creation_de);
+	mutex_init(&sbi->hpfs_creation_de);
 
 	uid = current_uid();
 	gid = current_gid();


