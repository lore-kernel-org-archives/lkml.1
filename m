Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053Ab0A2UlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab0A2UlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270Ab0A2UlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:41:06 -0500
Received: from www.tglx.de ([62.245.132.106]:44761 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab0A2UjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:39:15 -0500
Message-Id: <20100129203613.591137914@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 29 Jan 2010 20:38:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 06/10] affs: Convert semaphores to mutexes
References: <20100129203549.526478432@linutronix.de>
Content-Disposition: inline; filename=affs-convert-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These semaphores are plain mutexes. Convert them to struct mutex.

Map affs_[un]lock_dir() to affs_[un]lock_ext() instead of the "#define
i_hash_lock i_ext_lock" magic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>

---
 fs/affs/affs.h  |   26 +++++++++-----------------
 fs/affs/super.c |    4 ++--
 2 files changed, 11 insertions(+), 19 deletions(-)

Index: linux-2.6-tip/fs/affs/affs.h
===================================================================
--- linux-2.6-tip.orig/fs/affs/affs.h
+++ linux-2.6-tip/fs/affs/affs.h
@@ -50,9 +50,8 @@ struct affs_ext_key {
  */
 struct affs_inode_info {
 	atomic_t i_opencnt;
-	struct semaphore i_link_lock;		/* Protects internal inode access. */
-	struct semaphore i_ext_lock;		/* Protects internal inode access. */
-#define i_hash_lock i_ext_lock
+	struct mutex i_link_lock;		/* Protects internal inode access. */
+	struct mutex i_ext_lock;		/* Protects internal inode access. */
 	u32	 i_blkcnt;			/* block count */
 	u32	 i_extcnt;			/* extended block count */
 	u32	*i_lc;				/* linear cache of extended blocks */
@@ -275,30 +274,23 @@ affs_adjust_bitmapchecksum(struct buffer
 static inline void
 affs_lock_link(struct inode *inode)
 {
-	down(&AFFS_I(inode)->i_link_lock);
+	mutex_lock(&AFFS_I(inode)->i_link_lock);
 }
 static inline void
 affs_unlock_link(struct inode *inode)
 {
-	up(&AFFS_I(inode)->i_link_lock);
-}
-static inline void
-affs_lock_dir(struct inode *inode)
-{
-	down(&AFFS_I(inode)->i_hash_lock);
-}
-static inline void
-affs_unlock_dir(struct inode *inode)
-{
-	up(&AFFS_I(inode)->i_hash_lock);
+	mutex_unlock(&AFFS_I(inode)->i_link_lock);
 }
 static inline void
 affs_lock_ext(struct inode *inode)
 {
-	down(&AFFS_I(inode)->i_ext_lock);
+	mutex_lock(&AFFS_I(inode)->i_ext_lock);
 }
 static inline void
 affs_unlock_ext(struct inode *inode)
 {
-	up(&AFFS_I(inode)->i_ext_lock);
+	mutex_unlock(&AFFS_I(inode)->i_ext_lock);
 }
+
+#define affs_lock_dir(i)	affs_lock_ext(i)
+#define affs_unlock_dir(i)	affs_unlock_ext(i)
Index: linux-2.6-tip/fs/affs/super.c
===================================================================
--- linux-2.6-tip.orig/fs/affs/super.c
+++ linux-2.6-tip/fs/affs/super.c
@@ -113,8 +113,8 @@ static void init_once(void *foo)
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
-	init_MUTEX(&ei->i_link_lock);
-	init_MUTEX(&ei->i_ext_lock);
+	mutex_init(&ei->i_link_lock);
+	mutex_init(&ei->i_ext_lock);
 	inode_init_once(&ei->vfs_inode);
 }
 


