Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYGKLHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYGKLHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYGKLCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:02:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbYGKLB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:57 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/18] [GFS2] Remove support for unused and pointless flag
Date: Fri, 11 Jul 2008 11:11:18 +0100
Message-Id: <1215771119431-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157711171692-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
 <12157710983282-git-send-email-swhiteho@redhat.com>
 <12157711013356-git-send-email-swhiteho@redhat.com>
 <12157711023743-git-send-email-swhiteho@redhat.com>
 <12157711041157-git-send-email-swhiteho@redhat.com>
 <1215771106247-git-send-email-swhiteho@redhat.com>
 <12157711073280-git-send-email-swhiteho@redhat.com>
 <12157711093284-git-send-email-swhiteho@redhat.com>
 <12157711133727-git-send-email-swhiteho@redhat.com>
 <12157711153366-git-send-email-swhiteho@redhat.com>
 <12157711171692-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The ability to mark files for direct i/o access when opened
normally is both unused and pointless, so this patch removes
support for that feature.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 4ab3c3a..448697a 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -421,7 +421,6 @@ struct gfs2_tune {
 	unsigned int gt_quota_quantum; /* Secs between syncs to quota file */
 	unsigned int gt_atime_quantum; /* Min secs between atime updates */
 	unsigned int gt_new_files_jdata;
-	unsigned int gt_new_files_directio;
 	unsigned int gt_max_readahead; /* Max bytes to read-ahead from disk */
 	unsigned int gt_stall_secs; /* Detects trouble! */
 	unsigned int gt_complain_secs;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index caf4090..6da0ab3 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -789,13 +789,8 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 		if ((dip->i_di.di_flags & GFS2_DIF_INHERIT_JDATA) ||
 		    gfs2_tune_get(sdp, gt_new_files_jdata))
 			di->di_flags |= cpu_to_be32(GFS2_DIF_JDATA);
-		if ((dip->i_di.di_flags & GFS2_DIF_INHERIT_DIRECTIO) ||
-		    gfs2_tune_get(sdp, gt_new_files_directio))
-			di->di_flags |= cpu_to_be32(GFS2_DIF_DIRECTIO);
 	} else if (S_ISDIR(mode)) {
 		di->di_flags |= cpu_to_be32(dip->i_di.di_flags &
-					    GFS2_DIF_INHERIT_DIRECTIO);
-		di->di_flags |= cpu_to_be32(dip->i_di.di_flags &
 					    GFS2_DIF_INHERIT_JDATA);
 	}
 
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 1737af9..21b397d 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -134,7 +134,6 @@ static const u32 fsflags_to_gfs2[32] = {
 	[7] = GFS2_DIF_NOATIME,
 	[12] = GFS2_DIF_EXHASH,
 	[14] = GFS2_DIF_INHERIT_JDATA,
-	[20] = GFS2_DIF_INHERIT_DIRECTIO,
 };
 
 static const u32 gfs2_to_fsflags[32] = {
@@ -143,7 +142,6 @@ static const u32 gfs2_to_fsflags[32] = {
 	[gfs2fl_AppendOnly] = FS_APPEND_FL,
 	[gfs2fl_NoAtime] = FS_NOATIME_FL,
 	[gfs2fl_ExHash] = FS_INDEX_FL,
-	[gfs2fl_InheritDirectio] = FS_DIRECTIO_FL,
 	[gfs2fl_InheritJdata] = FS_JOURNAL_DATA_FL,
 };
 
@@ -161,12 +159,8 @@ static int gfs2_get_flags(struct file *filp, u32 __user *ptr)
 		return error;
 
 	fsflags = fsflags_cvt(gfs2_to_fsflags, ip->i_di.di_flags);
-	if (!S_ISDIR(inode->i_mode)) {
-		if (ip->i_di.di_flags & GFS2_DIF_JDATA)
-			fsflags |= FS_JOURNAL_DATA_FL;
-		if (ip->i_di.di_flags & GFS2_DIF_DIRECTIO)
-			fsflags |= FS_DIRECTIO_FL;
-	}
+	if (!S_ISDIR(inode->i_mode) && ip->i_di.di_flags & GFS2_DIF_JDATA)
+		fsflags |= FS_JOURNAL_DATA_FL;
 	if (put_user(fsflags, ptr))
 		error = -EFAULT;
 
@@ -195,13 +189,11 @@ void gfs2_set_inode_flags(struct inode *inode)
 
 /* Flags that can be set by user space */
 #define GFS2_FLAGS_USER_SET (GFS2_DIF_JDATA|			\
-			     GFS2_DIF_DIRECTIO|			\
 			     GFS2_DIF_IMMUTABLE|		\
 			     GFS2_DIF_APPENDONLY|		\
 			     GFS2_DIF_NOATIME|			\
 			     GFS2_DIF_SYNC|			\
 			     GFS2_DIF_SYSTEM|			\
-			     GFS2_DIF_INHERIT_DIRECTIO|		\
 			     GFS2_DIF_INHERIT_JDATA)
 
 /**
@@ -292,8 +284,6 @@ static int gfs2_set_flags(struct file *filp, u32 __user *ptr)
 	if (!S_ISDIR(inode->i_mode)) {
 		if (gfsflags & GFS2_DIF_INHERIT_JDATA)
 			gfsflags ^= (GFS2_DIF_JDATA | GFS2_DIF_INHERIT_JDATA);
-		if (gfsflags & GFS2_DIF_INHERIT_DIRECTIO)
-			gfsflags ^= (GFS2_DIF_DIRECTIO | GFS2_DIF_INHERIT_DIRECTIO);
 		return do_gfs2_set_flags(filp, gfsflags, ~0);
 	}
 	return do_gfs2_set_flags(filp, gfsflags, ~GFS2_DIF_JDATA);
@@ -494,11 +484,6 @@ static int gfs2_open(struct inode *inode, struct file *file)
 			goto fail_gunlock;
 		}
 
-		/* Listen to the Direct I/O flag */
-
-		if (ip->i_di.di_flags & GFS2_DIF_DIRECTIO)
-			file->f_flags |= O_DIRECT;
-
 		gfs2_glock_dq_uninit(&i_gh);
 	}
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 12fe38f..63a8a90 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -65,7 +65,6 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_quota_quantum = 60;
 	gt->gt_atime_quantum = 3600;
 	gt->gt_new_files_jdata = 0;
-	gt->gt_new_files_directio = 0;
 	gt->gt_max_readahead = 1 << 18;
 	gt->gt_stall_secs = 600;
 	gt->gt_complain_secs = 10;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 6f7e2e5..7484655 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -412,7 +412,6 @@ TUNE_ATTR(max_readahead, 0);
 TUNE_ATTR(complain_secs, 0);
 TUNE_ATTR(statfs_slow, 0);
 TUNE_ATTR(new_files_jdata, 0);
-TUNE_ATTR(new_files_directio, 0);
 TUNE_ATTR(quota_simul_sync, 1);
 TUNE_ATTR(quota_cache_secs, 1);
 TUNE_ATTR(stall_secs, 1);
@@ -441,7 +440,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_quotad_secs.attr,
 	&tune_attr_quota_scale.attr,
 	&tune_attr_new_files_jdata.attr,
-	&tune_attr_new_files_directio.attr,
 	NULL,
 };
 
-- 
1.5.1.2

