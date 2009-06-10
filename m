Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZFJJjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZFJJjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbZFJJiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40277 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756732AbZFJJiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:02 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/24] GFS2: Add commit= mount option
Date: Wed, 10 Jun 2009 09:30:47 +0100
Message-Id: <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has always been possible to adjust the gfs2 log commit
interval, but only from the sysfs interface. This adds a
mount option, commit=<nn>, which will be familar to ext3
users.

The sysfs interface continues to be available as well, although
this might be removed in the future.

Also this patch cleans up some duplicated structures in the GFS2
sysfs code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 399d1b9..65f438e 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -418,6 +418,7 @@ struct gfs2_args {
 	unsigned int ar_data:2;			/* ordered/writeback */
 	unsigned int ar_meta:1;			/* mount metafs */
 	unsigned int ar_discard:1;		/* discard requests */
+	int ar_commit;				/* Commit interval */
 };
 
 struct gfs2_tune {
diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index f7e8527..947af15 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -45,6 +45,7 @@ enum {
 	Opt_meta,
 	Opt_discard,
 	Opt_nodiscard,
+	Opt_commit,
 	Opt_err,
 };
 
@@ -73,6 +74,7 @@ static const match_table_t tokens = {
 	{Opt_meta, "meta"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
+	{Opt_commit, "commit=%d"},
 	{Opt_err, NULL}
 };
 
@@ -89,6 +91,7 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, struct gfs2_args *args, char *options)
 	char *o;
 	int token;
 	substring_t tmp[MAX_OPT_ARGS];
+	int rv;
 
 	/* Split the options into tokens with the "," character and
 	   process them */
@@ -173,6 +176,13 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, struct gfs2_args *args, char *options)
 		case Opt_nodiscard:
 			args->ar_discard = 0;
 			break;
+		case Opt_commit:
+			rv = match_int(&tmp[0], &args->ar_commit);
+			if (rv || args->ar_commit <= 0) {
+				fs_info(sdp, "commit mount option requires a positive numeric argument\n");
+				return rv ? rv : -EINVAL;
+			}
+			break;
 		case Opt_err:
 		default:
 			fs_info(sdp, "invalid mount option: %s\n", o);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 1ff9473..7981fbc 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -55,7 +55,6 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 	spin_lock_init(&gt->gt_spin);
 
 	gt->gt_incore_log_blocks = 1024;
-	gt->gt_log_flush_secs = 60;
 	gt->gt_recoverd_secs = 60;
 	gt->gt_logd_secs = 1;
 	gt->gt_quota_simul_sync = 64;
@@ -1165,6 +1164,7 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 
 	sdp->sd_args.ar_quota = GFS2_QUOTA_DEFAULT;
 	sdp->sd_args.ar_data = GFS2_DATA_DEFAULT;
+	sdp->sd_args.ar_commit = 60;
 
 	error = gfs2_mount_args(sdp, &sdp->sd_args, data);
 	if (error) {
@@ -1191,6 +1191,8 @@ static int fill_super(struct super_block *sb, void *data, int silent)
                                GFS2_BASIC_BLOCK_SHIFT;
 	sdp->sd_fsb2bb = 1 << sdp->sd_fsb2bb_shift;
 
+	sdp->sd_tune.gt_log_flush_secs = sdp->sd_args.ar_commit;
+
 	error = init_names(sdp, silent);
 	if (error)
 		goto fail;
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 4580195..0677a83 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -436,8 +436,12 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	struct gfs2_args args = sdp->sd_args; /* Default to current settings */
+	struct gfs2_tune *gt = &sdp->sd_tune;
 	int error;
 
+	spin_lock(&gt->gt_spin);
+	args.ar_commit = gt->gt_log_flush_secs;
+	spin_unlock(&gt->gt_spin);
 	error = gfs2_mount_args(sdp, &args, data);
 	if (error)
 		return error;
@@ -473,6 +477,10 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 		sb->s_flags |= MS_POSIXACL;
 	else
 		sb->s_flags &= ~MS_POSIXACL;
+	spin_lock(&gt->gt_spin);
+	gt->gt_log_flush_secs = args.ar_commit;
+	spin_unlock(&gt->gt_spin);
+
 	return 0;
 }
 
@@ -550,6 +558,7 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 {
 	struct gfs2_sbd *sdp = mnt->mnt_sb->s_fs_info;
 	struct gfs2_args *args = &sdp->sd_args;
+	int lfsecs;
 
 	if (is_ancestor(mnt->mnt_root, sdp->sd_master_dir))
 		seq_printf(s, ",meta");
@@ -610,7 +619,9 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	}
 	if (args->ar_discard)
 		seq_printf(s, ",discard");
-
+	lfsecs = sdp->sd_tune.gt_log_flush_secs;
+	if (lfsecs != 60)
+		seq_printf(s, ",commit=%d", lfsecs);
 	return 0;
 }
 
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 7655f50..d53b22e 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -26,6 +26,36 @@
 #include "util.h"
 #include "glops.h"
 
+struct gfs2_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct gfs2_sbd *, char *);
+	ssize_t (*store)(struct gfs2_sbd *, const char *, size_t);
+};
+
+static ssize_t gfs2_attr_show(struct kobject *kobj, struct attribute *attr,
+			      char *buf)
+{
+	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
+	struct gfs2_attr *a = container_of(attr, struct gfs2_attr, attr);
+	return a->show ? a->show(sdp, buf) : 0;
+}
+
+static ssize_t gfs2_attr_store(struct kobject *kobj, struct attribute *attr,
+			       const char *buf, size_t len)
+{
+	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
+	struct gfs2_attr *a = container_of(attr, struct gfs2_attr, attr);
+	return a->store ? a->store(sdp, buf, len) : len;
+}
+
+static struct sysfs_ops gfs2_attr_ops = {
+	.show  = gfs2_attr_show,
+	.store = gfs2_attr_store,
+};
+
+
+static struct kset *gfs2_kset;
+
 static ssize_t id_show(struct gfs2_sbd *sdp, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%u:%u\n",
@@ -212,11 +242,6 @@ static ssize_t demote_rq_store(struct gfs2_sbd *sdp, const char *buf, size_t len
 	return len;
 }
 
-struct gfs2_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct gfs2_sbd *, char *);
-	ssize_t (*store)(struct gfs2_sbd *, const char *, size_t);
-};
 
 #define GFS2_ATTR(name, mode, show, store) \
 static struct gfs2_attr gfs2_attr_##name = __ATTR(name, mode, show, store)
@@ -246,49 +271,21 @@ static struct attribute *gfs2_attrs[] = {
 	NULL,
 };
 
-static ssize_t gfs2_attr_show(struct kobject *kobj, struct attribute *attr,
-			      char *buf)
-{
-	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
-	struct gfs2_attr *a = container_of(attr, struct gfs2_attr, attr);
-	return a->show ? a->show(sdp, buf) : 0;
-}
-
-static ssize_t gfs2_attr_store(struct kobject *kobj, struct attribute *attr,
-			       const char *buf, size_t len)
-{
-	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
-	struct gfs2_attr *a = container_of(attr, struct gfs2_attr, attr);
-	return a->store ? a->store(sdp, buf, len) : len;
-}
-
-static struct sysfs_ops gfs2_attr_ops = {
-	.show  = gfs2_attr_show,
-	.store = gfs2_attr_store,
-};
-
 static struct kobj_type gfs2_ktype = {
 	.default_attrs = gfs2_attrs,
 	.sysfs_ops     = &gfs2_attr_ops,
 };
 
-static struct kset *gfs2_kset;
-
 /*
  * display struct lm_lockstruct fields
  */
 
-struct lockstruct_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct gfs2_sbd *, char *);
-};
-
 #define LOCKSTRUCT_ATTR(name, fmt)                                          \
 static ssize_t name##_show(struct gfs2_sbd *sdp, char *buf)                 \
 {                                                                           \
 	return snprintf(buf, PAGE_SIZE, fmt, sdp->sd_lockstruct.ls_##name); \
 }                                                                           \
-static struct lockstruct_attr lockstruct_attr_##name = __ATTR_RO(name)
+static struct gfs2_attr lockstruct_attr_##name = __ATTR_RO(name)
 
 LOCKSTRUCT_ATTR(jid,      "%u\n");
 LOCKSTRUCT_ATTR(first,    "%u\n");
@@ -401,14 +398,8 @@ static ssize_t recover_status_show(struct gfs2_sbd *sdp, char *buf)
 	return sprintf(buf, "%d\n", ls->ls_recover_jid_status);
 }
 
-struct gdlm_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct gfs2_sbd *sdp, char *);
-	ssize_t (*store)(struct gfs2_sbd *sdp, const char *, size_t);
-};
-
 #define GDLM_ATTR(_name,_mode,_show,_store) \
-static struct gdlm_attr gdlm_attr_##_name = __ATTR(_name,_mode,_show,_store)
+static struct gfs2_attr gdlm_attr_##_name = __ATTR(_name,_mode,_show,_store)
 
 GDLM_ATTR(proto_name,     0444, proto_name_show,     NULL);
 GDLM_ATTR(block,          0644, block_show,          block_store);
@@ -434,21 +425,12 @@ static struct attribute *lock_module_attrs[] = {
 	NULL,
 };
 
-/*
- * display struct gfs2_args fields
- */
-
-struct args_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct gfs2_sbd *, char *);
-};
-
 #define ARGS_ATTR(name, fmt)                                                \
 static ssize_t name##_show(struct gfs2_sbd *sdp, char *buf)                 \
 {                                                                           \
 	return snprintf(buf, PAGE_SIZE, fmt, sdp->sd_args.ar_##name);       \
 }                                                                           \
-static struct args_attr args_attr_##name = __ATTR_RO(name)
+static struct gfs2_attr args_attr_##name = __ATTR_RO(name)
 
 ARGS_ATTR(lockproto,       "%s\n");
 ARGS_ATTR(locktable,       "%s\n");
@@ -531,14 +513,8 @@ static ssize_t tune_set(struct gfs2_sbd *sdp, unsigned int *field,
 	return len;
 }
 
-struct tune_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct gfs2_sbd *, char *);
-	ssize_t (*store)(struct gfs2_sbd *, const char *, size_t);
-};
-
 #define TUNE_ATTR_3(name, show, store)                                        \
-static struct tune_attr tune_attr_##name = __ATTR(name, 0644, show, store)
+static struct gfs2_attr tune_attr_##name = __ATTR(name, 0644, show, store)
 
 #define TUNE_ATTR_2(name, store)                                              \
 static ssize_t name##_show(struct gfs2_sbd *sdp, char *buf)                   \
-- 
1.6.0.6

