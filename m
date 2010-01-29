Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988Ab0A2UjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0A2UjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972Ab0A2UjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:39:05 -0500
Received: from www.tglx.de ([62.245.132.106]:44724 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab0A2UjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:39:04 -0500
Message-Id: <20100129203613.443786537@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 29 Jan 2010 20:38:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 02/10] hpfs: Convert sbi->hpfs_creation_de to mutex
References: <20100129203549.526478432@linutronix.de>
Content-Disposition: inline; filename=hpfs-convert-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sbi->hpfs_creation_de semaphore is used as mutex. Convert it to a
real mutex.

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
@@ -486,7 +486,7 @@ static int hpfs_fill_super(struct super_
 	sbi->sb_bmp_dir = NULL;
 	sbi->sb_cp_table = NULL;
 
-	init_MUTEX(&sbi->hpfs_creation_de);
+	mutex_init(&sbi->hpfs_creation_de);
 
 	uid = current_uid();
 	gid = current_gid();


