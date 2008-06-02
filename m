Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYFBRMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYFBRMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYFBRLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:11:16 -0400
Received: from styx.suse.cz ([82.119.242.94]:55191 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753208AbYFBRLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:11:14 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: Split out quota_struct.h out of quota.h
Date: Mon,  2 Jun 2008 19:11:10 +0200
Message-Id: <12124266721420-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124266723968-git-send-email-jack@suse.cz>
References: y
 <12124266712214-git-send-email-jack@suse.cz>
 <12124266711334-git-send-email-jack@suse.cz>
 <12124266712838-git-send-email-jack@suse.cz>
 <12124266722979-git-send-email-jack@suse.cz>
 <12124266723968-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split some structure definitions from quota.h to quota_struct.h so that they
can be separately included in fs.h. This makes it possible to declare some
useful inline functions in quota.h because it can now include fs.h.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h       |    2 +-
 include/linux/quota.h    |  193 +---------------------------------------------
 include/linux/quotaops.h |    1 +
 include/linux/syscalls.h |    2 +-
 4 files changed, 5 insertions(+), 193 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f413085..c0f70f2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -364,7 +364,7 @@ struct iattr {
 /*
  * Includes for diskquotas.
  */
-#include <linux/quota.h>
+#include <linux/quota_struct.h>
 
 /** 
  * enum positive_aop_returns - aop return codes with specific semantics
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 6f1d97d..841c4ae 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -37,13 +37,11 @@
 
 #include <linux/errno.h>
 #include <linux/types.h>
+#include <linux/quota_struct.h>
 
 #define __DQUOT_VERSION__	"dquot_6.5.1"
 #define __DQUOT_NUM_VERSION__	6*10000+5*100+1
 
-typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
-typedef __u64 qsize_t;          /* Type in which we store sizes */
-
 /* Size of blocks in which are counted size limits */
 #define QUOTABLOCK_BITS 10
 #define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
@@ -53,10 +51,6 @@ typedef __u64 qsize_t;          /* Type in which we store sizes */
 #define kb2qb(x) ((x) >> (QUOTABLOCK_BITS-10))
 #define toqb(x) (((x) + QUOTABLOCK_SIZE - 1) >> QUOTABLOCK_BITS)
 
-#define MAXQUOTAS 2
-#define USRQUOTA  0		/* element used for user quotas */
-#define GRPQUOTA  1		/* element used for group quotas */
-
 /*
  * Definitions for the default names of the quotas files.
  */
@@ -86,49 +80,6 @@ typedef __u64 qsize_t;          /* Type in which we store sizes */
 #define Q_SETQUOTA 0x800008	/* set user quota structure */
 
 /*
- * Quota structure used for communication with userspace via quotactl
- * Following flags are used to specify which fields are valid
- */
-#define QIF_BLIMITS	1
-#define QIF_SPACE	2
-#define QIF_ILIMITS	4
-#define QIF_INODES	8
-#define QIF_BTIME	16
-#define QIF_ITIME	32
-#define QIF_LIMITS	(QIF_BLIMITS | QIF_ILIMITS)
-#define QIF_USAGE	(QIF_SPACE | QIF_INODES)
-#define QIF_TIMES	(QIF_BTIME | QIF_ITIME)
-#define QIF_ALL		(QIF_LIMITS | QIF_USAGE | QIF_TIMES)
-
-struct if_dqblk {
-	__u64 dqb_bhardlimit;
-	__u64 dqb_bsoftlimit;
-	__u64 dqb_curspace;
-	__u64 dqb_ihardlimit;
-	__u64 dqb_isoftlimit;
-	__u64 dqb_curinodes;
-	__u64 dqb_btime;
-	__u64 dqb_itime;
-	__u32 dqb_valid;
-};
-
-/*
- * Structure used for setting quota information about file via quotactl
- * Following flags are used to specify which fields are valid
- */
-#define IIF_BGRACE	1
-#define IIF_IGRACE	2
-#define IIF_FLAGS	4
-#define IIF_ALL		(IIF_BGRACE | IIF_IGRACE | IIF_FLAGS)
-
-struct if_dqinfo {
-	__u64 dqi_bgrace;
-	__u64 dqi_igrace;
-	__u32 dqi_flags;
-	__u32 dqi_valid;
-};
-
-/*
  * Definitions for quota netlink interface
  */
 #define QUOTA_NL_NOWARN 0
@@ -160,15 +111,7 @@ enum {
 
 
 #ifdef __KERNEL__
-#include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/rwsem.h>
 #include <linux/spinlock.h>
-#include <linux/wait.h>
-
-#include <linux/dqblk_xfs.h>
-#include <linux/dqblk_v1.h>
-#include <linux/dqblk_v2.h>
 
 #include <asm/atomic.h>
 
@@ -181,48 +124,7 @@ extern spinlock_t dq_data_lock;
 #define DQUOT_DEL_ALLOC max(V1_DEL_ALLOC, V2_DEL_ALLOC)
 #define DQUOT_DEL_REWRITE max(V1_DEL_REWRITE, V2_DEL_REWRITE)
 
-/*
- * Data for one user/group kept in memory
- */
-struct mem_dqblk {
-	__u32 dqb_bhardlimit;	/* absolute limit on disk blks alloc */
-	__u32 dqb_bsoftlimit;	/* preferred limit on disk blks */
-	qsize_t dqb_curspace;	/* current used space */
-	__u32 dqb_ihardlimit;	/* absolute limit on allocated inodes */
-	__u32 dqb_isoftlimit;	/* preferred inode limit */
-	__u32 dqb_curinodes;	/* current # allocated inodes */
-	time_t dqb_btime;	/* time limit for excessive disk use */
-	time_t dqb_itime;	/* time limit for excessive inode use */
-};
-
-/*
- * Data for one quotafile kept in memory
- */
-struct quota_format_type;
-
-struct mem_dqinfo {
-	struct quota_format_type *dqi_format;
-	int dqi_fmt_id;		/* Id of the dqi_format - used when turning
-				 * quotas on after remount RW */
-	struct list_head dqi_dirty_list;	/* List of dirty dquots */
-	unsigned long dqi_flags;
-	unsigned int dqi_bgrace;
-	unsigned int dqi_igrace;
-	qsize_t dqi_maxblimit;
-	qsize_t dqi_maxilimit;
-	union {
-		struct v1_mem_dqinfo v1_i;
-		struct v2_mem_dqinfo v2_i;
-	} u;
-};
-
-struct super_block;
-
-#define DQF_MASK 0xffff		/* Mask for format specific flags */
-#define DQF_INFO_DIRTY_B 16
-#define DQF_INFO_DIRTY (1 << DQF_INFO_DIRTY_B)	/* Is info dirty? */
-
-extern void mark_info_dirty(struct super_block *sb, int type);
+void mark_info_dirty(struct super_block *sb, int type);
 #define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
 
 #define sb_dqopt(sb) (&(sb)->s_dquot)
@@ -241,100 +143,9 @@ struct dqstats {
 
 extern struct dqstats dqstats;
 
-#define DQ_MOD_B	0	/* dquot modified since read */
-#define DQ_BLKS_B	1	/* uid/gid has been warned about blk limit */
-#define DQ_INODES_B	2	/* uid/gid has been warned about inode limit */
-#define DQ_FAKE_B	3	/* no limits only usage */
-#define DQ_READ_B	4	/* dquot was read into memory */
-#define DQ_ACTIVE_B	5	/* dquot is active (dquot_release not called) */
-
-struct dquot {
-	struct hlist_node dq_hash;	/* Hash list in memory */
-	struct list_head dq_inuse;	/* List of all quotas */
-	struct list_head dq_free;	/* Free list element */
-	struct list_head dq_dirty;	/* List of dirty dquots */
-	struct mutex dq_lock;		/* dquot IO lock */
-	atomic_t dq_count;		/* Use count */
-	wait_queue_head_t dq_wait_unused;	/* Wait queue for dquot to become unused */
-	struct super_block *dq_sb;	/* superblock this applies to */
-	unsigned int dq_id;		/* ID this applies to (uid, gid) */
-	loff_t dq_off;			/* Offset of dquot on disk */
-	unsigned long dq_flags;		/* See DQ_* */
-	short dq_type;			/* Type of quota */
-	struct mem_dqblk dq_dqb;	/* Diskquota usage */
-};
-
-#define NODQUOT (struct dquot *)NULL
-
 #define QUOTA_OK          0
 #define NO_QUOTA          1
 
-/* Operations which must be implemented by each quota format */
-struct quota_format_ops {
-	int (*check_quota_file)(struct super_block *sb, int type);	/* Detect whether file is in our format */
-	int (*read_file_info)(struct super_block *sb, int type);	/* Read main info about file - called on quotaon() */
-	int (*write_file_info)(struct super_block *sb, int type);	/* Write main info about file */
-	int (*free_file_info)(struct super_block *sb, int type);	/* Called on quotaoff() */
-	int (*read_dqblk)(struct dquot *dquot);		/* Read structure for one user */
-	int (*commit_dqblk)(struct dquot *dquot);	/* Write structure for one user */
-	int (*release_dqblk)(struct dquot *dquot);	/* Called when last reference to dquot is being dropped */
-};
-
-/* Operations working with dquots */
-struct dquot_operations {
-	int (*initialize) (struct inode *, int);
-	int (*drop) (struct inode *);
-	int (*alloc_space) (struct inode *, qsize_t, int);
-	int (*alloc_inode) (const struct inode *, unsigned long);
-	int (*free_space) (struct inode *, qsize_t);
-	int (*free_inode) (const struct inode *, unsigned long);
-	int (*transfer) (struct inode *, struct iattr *);
-	int (*write_dquot) (struct dquot *);		/* Ordinary dquot write */
-	int (*acquire_dquot) (struct dquot *);		/* Quota is going to be created on disk */
-	int (*release_dquot) (struct dquot *);		/* Quota is going to be deleted from disk */
-	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
-	int (*write_info) (struct super_block *, int);	/* Write of quota "superblock" */
-};
-
-/* Operations handling requests from userspace */
-struct quotactl_ops {
-	int (*quota_on)(struct super_block *, int, int, char *, int);
-	int (*quota_off)(struct super_block *, int, int);
-	int (*quota_sync)(struct super_block *, int);
-	int (*get_info)(struct super_block *, int, struct if_dqinfo *);
-	int (*set_info)(struct super_block *, int, struct if_dqinfo *);
-	int (*get_dqblk)(struct super_block *, int, qid_t, struct if_dqblk *);
-	int (*set_dqblk)(struct super_block *, int, qid_t, struct if_dqblk *);
-	int (*get_xstate)(struct super_block *, struct fs_quota_stat *);
-	int (*set_xstate)(struct super_block *, unsigned int, int);
-	int (*get_xquota)(struct super_block *, int, qid_t, struct fs_disk_quota *);
-	int (*set_xquota)(struct super_block *, int, qid_t, struct fs_disk_quota *);
-};
-
-struct quota_format_type {
-	int qf_fmt_id;	/* Quota format id */
-	struct quota_format_ops *qf_ops;	/* Operations of format */
-	struct module *qf_owner;		/* Module implementing quota format */
-	struct quota_format_type *qf_next;
-};
-
-#define DQUOT_USR_ENABLED	0x01		/* User diskquotas enabled */
-#define DQUOT_GRP_ENABLED	0x02		/* Group diskquotas enabled */
-#define DQUOT_USR_SUSPENDED	0x04		/* User diskquotas are off, but
-						 * we have necessary info in
-						 * memory to turn them on */
-#define DQUOT_GRP_SUSPENDED	0x08		/* The same for group quotas */
-
-struct quota_info {
-	unsigned int flags;			/* Flags for diskquotas on this device */
-	struct mutex dqio_mutex;		/* lock device while I/O in progress */
-	struct mutex dqonoff_mutex;		/* Serialize quotaon & quotaoff */
-	struct rw_semaphore dqptr_sem;		/* serialize ops using quota_info struct, pointers from inode to dquots */
-	struct inode *files[MAXQUOTAS];		/* inodes of quotafiles */
-	struct mem_dqinfo info[MAXQUOTAS];	/* Information for each quota type */
-	struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
-};
-
 #define sb_has_quota_enabled(sb, type) ((type)==USRQUOTA ? \
 	(sb_dqopt(sb)->flags & DQUOT_USR_ENABLED) : (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED))
 
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 0c8f9fe..8b7bdf5 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -13,6 +13,7 @@
 #include <linux/smp_lock.h>
 
 #include <linux/fs.h>
+#include <linux/quota.h>
 
 #if defined(CONFIG_QUOTA)
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0522f36..23b7ef0 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -62,7 +62,7 @@ struct getcpu_cache;
 #include <linux/sem.h>
 #include <asm/siginfo.h>
 #include <asm/signal.h>
-#include <linux/quota.h>
+#include <linux/quota_struct.h>
 #include <linux/key.h>
 
 asmlinkage long sys_time(time_t __user *tloc);
-- 
1.5.2.4

