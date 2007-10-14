Return-Path: <linux-kernel-owner+w=401wt.eu-S1763713AbXJNSh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763713AbXJNSh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761118AbXJNSfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:35:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47948 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761493AbXJNSfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:35:51 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] more low-hanging fruits - kernel, fs, lib signedness
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Ih8Ja-00043r-7O@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:35:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/jfs/jfs_dtree.c             |    2 +-
 fs/jfs/jfs_incore.h            |    2 +-
 fs/jfs/jfs_logmgr.h            |    2 +-
 fs/smbfs/smbiod.c              |    2 +-
 include/linux/reiserfs_fs_sb.h |    4 ++--
 kernel/posix-timers.c          |    6 +++---
 lib/idr.c                      |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index c14ba3c..df0b853 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -520,7 +520,7 @@ static void free_index(tid_t tid, struct inode *ip, u32 index, u32 next)
  *	Changes an entry in the directory index table
  */
 static void modify_index(tid_t tid, struct inode *ip, u32 index, s64 bn,
-			 int slot, struct metapage ** mp, u64 *lblock)
+			 int slot, struct metapage ** mp, s64 *lblock)
 {
 	struct dir_table_slot *dirtab_slot;
 
diff --git a/fs/jfs/jfs_incore.h b/fs/jfs/jfs_incore.h
index cb8f309..439901d 100644
--- a/fs/jfs/jfs_incore.h
+++ b/fs/jfs/jfs_incore.h
@@ -49,7 +49,7 @@ struct jfs_inode_info {
 	short	btorder;	/* access order	*/
 	short	btindex;	/* btpage entry index*/
 	struct inode *ipimap;	/* inode map			*/
-	long	cflag;		/* commit flags		*/
+	unsigned long cflag;	/* commit flags		*/
 	u16	bxflag;		/* xflag of pseudo buffer?	*/
 	unchar	agno;		/* ag number			*/
 	signed char active_ag;	/* ag currently allocating from	*/
diff --git a/fs/jfs/jfs_logmgr.h b/fs/jfs/jfs_logmgr.h
index 1f85ef0..9236bc4 100644
--- a/fs/jfs/jfs_logmgr.h
+++ b/fs/jfs/jfs_logmgr.h
@@ -376,7 +376,7 @@ struct jfs_log {
 	int size;		/* 4: log size in log page (in page) */
 	int l2bsize;		/* 4: log2 of bsize */
 
-	long flag;		/* 4: flag */
+	unsigned long flag;	/* 4: flag */
 
 	struct lbuf *lbuf_free;	/* 4: free lbufs */
 	wait_queue_head_t free_wait;	/* 4: */
diff --git a/fs/smbfs/smbiod.c b/fs/smbfs/smbiod.c
index 67176af..283c572 100644
--- a/fs/smbfs/smbiod.c
+++ b/fs/smbfs/smbiod.c
@@ -45,7 +45,7 @@ static LIST_HEAD(smb_servers);
 static DEFINE_SPINLOCK(servers_lock);
 
 #define SMBIOD_DATA_READY	(1<<0)
-static long smbiod_flags;
+static unsigned long smbiod_flags;
 
 static int smbiod(void *);
 static int smbiod_start(void);
diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
index 1e5488e..ff9e923 100644
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -120,7 +120,7 @@ struct reiserfs_journal_cnode {
 	struct buffer_head *bh;	/* real buffer head */
 	struct super_block *sb;	/* dev of real buffer head */
 	__u32 blocknr;		/* block number of real buffer head, == 0 when buffer on disk */
-	long state;
+	unsigned long state;
 	struct reiserfs_journal_list *jlist;	/* journal list this cnode lives in */
 	struct reiserfs_journal_cnode *next;	/* next in transaction list */
 	struct reiserfs_journal_cnode *prev;	/* prev in transaction list */
@@ -181,7 +181,7 @@ struct reiserfs_journal {
 	struct block_device *j_dev_bd;
 	int j_1st_reserved_block;	/* first block on s_dev of reserved area journal */
 
-	long j_state;
+	unsigned long j_state;
 	unsigned long j_trans_id;
 	unsigned long j_mount_id;
 	unsigned long j_start;	/* start of current waiting commit (index into j_ap_blocks) */
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 7a15afb..57efe04 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -712,7 +712,7 @@ sys_timer_getoverrun(timer_t timer_id)
 {
 	struct k_itimer *timr;
 	int overrun;
-	long flags;
+	unsigned long flags;
 
 	timr = lock_timer(timer_id, &flags);
 	if (!timr)
@@ -784,7 +784,7 @@ sys_timer_settime(timer_t timer_id, int flags,
 	struct k_itimer *timr;
 	struct itimerspec new_spec, old_spec;
 	int error = 0;
-	long flag;
+	unsigned long flag;
 	struct itimerspec *rtn = old_setting ? &old_spec : NULL;
 
 	if (!new_setting)
@@ -836,7 +836,7 @@ asmlinkage long
 sys_timer_delete(timer_t timer_id)
 {
 	struct k_itimer *timer;
-	long flags;
+	unsigned long flags;
 
 retry_delete:
 	timer = lock_timer(timer_id, &flags);
diff --git a/lib/idr.c b/lib/idr.c
index d0f1acd..09cbe2b 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -120,7 +120,7 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 	int n, m, sh;
 	struct idr_layer *p, *new;
 	int l, id, oid;
-	long bm;
+	unsigned long bm;
 
 	id = *starting_id;
  restart:
-- 
1.5.3.GIT


