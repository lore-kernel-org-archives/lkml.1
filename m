Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZBQILJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZBQILJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZBQIKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:10:43 -0500
Received: from sh.osrg.net ([192.16.179.4]:55113 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbZBQIKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:10:42 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm 2/6] nilfs2: use fixed sized types for ioctl structures
Date: Tue, 17 Feb 2009 16:42:02 +0900
Message-Id: <1234856526-1947-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 17 Feb 2009 17:10:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nilfs ioctl had structures not having fixed sized types such as:

  struct nilfs_argv {
         void *v_base;
         size_t v_nmembs;
         size_t v_size;
         int v_index;
         int v_flags;
  };

Further, some of them are wrongly aligned:

  e.g.

  struct nilfs_cpmode {
        __u64 cm_cno;
        int cm_mode;
  };

The size of wrongly aligned structures varies depending on
architectures, and it breaks the identity of ioctl commands, which
leads to arch dependent errors.

Previously, these are compensated by using compat_ioctl.

This fixes these problems and allows removal of compat ioctl.

Since this will change sizes of those structures, binary compatibility
for the past utilities will once break; new utilities have to be used
instead.  However, it would be helpful to avoid platform dependent
problems in the long term.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/ioctl.c         |   11 +++++------
 include/linux/nilfs2_fs.h |   23 ++++++++++++++---------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 85a291c..7fbd9fe 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -41,6 +41,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 						   void *, size_t, size_t))
 {
 	void *buf;
+	void __user *base = (void __user *)(unsigned long)argv->v_base;
 	size_t maxmembs, total, n;
 	ssize_t nr;
 	int ret, i;
@@ -64,9 +65,8 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 		n = (argv->v_nmembs - i < maxmembs) ?
 			argv->v_nmembs - i : maxmembs;
 		if ((dir & _IOC_WRITE) &&
-		    copy_from_user(buf,
-			    (void __user *)argv->v_base + argv->v_size * i,
-			    argv->v_size * n)) {
+		    copy_from_user(buf, base + argv->v_size * i,
+				   argv->v_size * n)) {
 			ret = -EFAULT;
 			break;
 		}
@@ -78,9 +78,8 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 			break;
 		}
 		if ((dir & _IOC_READ) &&
-		    copy_to_user(
-			    (void __user *)argv->v_base + argv->v_size * i,
-			    buf, argv->v_size * nr)) {
+		    copy_to_user(base + argv->v_size * i, buf,
+				 argv->v_size * nr)) {
 			ret = -EFAULT;
 			break;
 		}
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index b0a6b39..8fb64ce 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -499,6 +499,7 @@ NILFS_CHECKPOINT_FNS(SKETCH, sketch)
 /**
  * struct nilfs_cpinfo - checkpoint information
  * @ci_flags: flags
+ * @ci_pad: padding
  * @ci_cno: checkpoint number
  * @ci_create: creation timestamp
  * @ci_nblk_inc: number of blocks incremented by this checkpoint
@@ -508,6 +509,7 @@ NILFS_CHECKPOINT_FNS(SKETCH, sketch)
  */
 struct nilfs_cpinfo {
 	__u32 ci_flags;
+	__u32 ci_pad;
 	__u64 ci_cno;
 	__u64 ci_create;
 	__u64 ci_nblk_inc;
@@ -668,7 +670,8 @@ enum {
  */
 struct nilfs_cpmode {
 	__u64 cm_cno;
-	int cm_mode;
+	__u32 cm_mode;
+	__u32 cm_pad;
 };
 
 /**
@@ -676,15 +679,15 @@ struct nilfs_cpmode {
  * @v_base:
  * @v_nmembs:
  * @v_size:
- * @v_index:
  * @v_flags:
+ * @v_index:
  */
 struct nilfs_argv {
-	void *v_base;
-	size_t v_nmembs;	/* number of members */
-	size_t v_size;		/* size of members */
-	int v_index;
-	int v_flags;
+	__u64 v_base;
+	__u32 v_nmembs;	/* number of members */
+	__u16 v_size;	/* size of members */
+	__u16 v_flags;
+	__u64 v_index;
 };
 
 /**
@@ -721,8 +724,8 @@ struct nilfs_sustat {
 	__u64 ss_nsegs;
 	__u64 ss_ncleansegs;
 	__u64 ss_ndirtysegs;
-	time_t ss_ctime;
-	time_t ss_nongc_ctime;
+	__u64 ss_ctime;
+	__u64 ss_nongc_ctime;
 };
 
 /**
@@ -750,6 +753,7 @@ struct nilfs_vdesc {
 	__u64 vd_blocknr;
 	__u64 vd_offset;
 	__u32 vd_flags;
+	__u32 vd_pad;
 };
 
 /**
@@ -761,6 +765,7 @@ struct nilfs_bdesc {
 	__u64 bd_blocknr;
 	__u64 bd_offset;
 	__u32 bd_level;
+	__u32 bd_pad;
 };
 
 #define NILFS_IOCTL_IDENT		'n'
-- 
1.5.6.5

