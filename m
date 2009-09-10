Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZIJK36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZIJK36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbZIJK35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:29:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbZIJK3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:55 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/15] GFS2: Add "-o errors=panic|withdraw" mount options
Date: Thu, 10 Sep 2009 12:28:01 +0100
Message-Id: <1252582087-10007-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-9-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-6-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-7-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-8-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-9-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch adds "-o errors=panic" and "-o errors=withdraw" to the
gfs2 mount options.  The "errors=withdraw" option is today's
current behaviour, meaning to withdraw from the file system if a
non-serious gfs2 error occurs.  The new "errors=panic" option
tells gfs2 to force a kernel panic if a non-serious gfs2 file
system error occurs.  This may be useful, for example, where
fabric-level fencing is used that has no way to reboot (such as
fence_scsi).

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/incore.h     |    7 +++++++
 fs/gfs2/ops_fstype.c |    1 +
 fs/gfs2/super.c      |   36 ++++++++++++++++++++++++++++++++++++
 fs/gfs2/util.c       |   41 +++++++++++++++++++++++++++--------------
 4 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 61801ad..1d11e6e 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -406,6 +406,12 @@ struct gfs2_statfs_change_host {
 #define GFS2_DATA_WRITEBACK	1
 #define GFS2_DATA_ORDERED	2
 
+#define GFS2_ERRORS_DEFAULT     GFS2_ERRORS_WITHDRAW
+#define GFS2_ERRORS_WITHDRAW    0
+#define GFS2_ERRORS_CONTINUE    1 /* place holder for future feature */
+#define GFS2_ERRORS_RO          2 /* place holder for future feature */
+#define GFS2_ERRORS_PANIC       3
+
 struct gfs2_args {
 	char ar_lockproto[GFS2_LOCKNAME_LEN];	/* Name of the Lock Protocol */
 	char ar_locktable[GFS2_LOCKNAME_LEN];	/* Name of the Lock Table */
@@ -422,6 +428,7 @@ struct gfs2_args {
 	unsigned int ar_data:2;			/* ordered/writeback */
 	unsigned int ar_meta:1;			/* mount metafs */
 	unsigned int ar_discard:1;		/* discard requests */
+	unsigned int ar_errors:2;               /* errors=withdraw | panic */
 	int ar_commit;				/* Commit interval */
 };
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 39021c0..165518a 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1168,6 +1168,7 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 	sdp->sd_args.ar_quota = GFS2_QUOTA_DEFAULT;
 	sdp->sd_args.ar_data = GFS2_DATA_DEFAULT;
 	sdp->sd_args.ar_commit = 60;
+	sdp->sd_args.ar_errors = GFS2_ERRORS_DEFAULT;
 
 	error = gfs2_mount_args(sdp, &sdp->sd_args, data);
 	if (error) {
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 85bd2bc..7a5c128 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -68,6 +68,8 @@ enum {
 	Opt_discard,
 	Opt_nodiscard,
 	Opt_commit,
+	Opt_err_withdraw,
+	Opt_err_panic,
 	Opt_error,
 };
 
@@ -97,6 +99,8 @@ static const match_table_t tokens = {
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
 	{Opt_commit, "commit=%d"},
+	{Opt_err_withdraw, "errors=withdraw"},
+	{Opt_err_panic, "errors=panic"},
 	{Opt_error, NULL}
 };
 
@@ -152,6 +156,11 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, struct gfs2_args *args, char *options)
 			args->ar_localcaching = 1;
 			break;
 		case Opt_debug:
+			if (args->ar_errors == GFS2_ERRORS_PANIC) {
+				fs_info(sdp, "-o debug and -o errors=panic "
+				       "are mutually exclusive.\n");
+				return -EINVAL;
+			}
 			args->ar_debug = 1;
 			break;
 		case Opt_nodebug:
@@ -205,6 +214,17 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, struct gfs2_args *args, char *options)
 				return rv ? rv : -EINVAL;
 			}
 			break;
+		case Opt_err_withdraw:
+			args->ar_errors = GFS2_ERRORS_WITHDRAW;
+			break;
+		case Opt_err_panic:
+			if (args->ar_debug) {
+				fs_info(sdp, "-o debug and -o errors=panic "
+					"are mutually exclusive.\n");
+				return -EINVAL;
+			}
+			args->ar_errors = GFS2_ERRORS_PANIC;
+			break;
 		case Opt_error:
 		default:
 			fs_info(sdp, "invalid mount option: %s\n", o);
@@ -1226,6 +1246,22 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	lfsecs = sdp->sd_tune.gt_log_flush_secs;
 	if (lfsecs != 60)
 		seq_printf(s, ",commit=%d", lfsecs);
+	if (args->ar_errors != GFS2_ERRORS_DEFAULT) {
+		const char *state;
+
+		switch (args->ar_errors) {
+		case GFS2_ERRORS_WITHDRAW:
+			state = "withdraw";
+			break;
+		case GFS2_ERRORS_PANIC:
+			state = "panic";
+			break;
+		default:
+			state = "unknown";
+			break;
+		}
+		seq_printf(s, ",errors=%s", state);
+	}
 	return 0;
 }
 
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 9d12b11..f6a7efa 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -38,24 +38,30 @@ int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
 	const struct lm_lockops *lm = ls->ls_ops;
 	va_list args;
 
-	if (test_and_set_bit(SDF_SHUTDOWN, &sdp->sd_flags))
+	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW &&
+	    test_and_set_bit(SDF_SHUTDOWN, &sdp->sd_flags))
 		return 0;
 
 	va_start(args, fmt);
 	vprintk(fmt, args);
 	va_end(args);
 
-	fs_err(sdp, "about to withdraw this file system\n");
-	BUG_ON(sdp->sd_args.ar_debug);
+	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW) {
+		fs_err(sdp, "about to withdraw this file system\n");
+		BUG_ON(sdp->sd_args.ar_debug);
 
-	kobject_uevent(&sdp->sd_kobj, KOBJ_OFFLINE);
+		kobject_uevent(&sdp->sd_kobj, KOBJ_OFFLINE);
 
-	if (lm->lm_unmount) {
-		fs_err(sdp, "telling LM to unmount\n");
-		lm->lm_unmount(sdp);
+		if (lm->lm_unmount) {
+			fs_err(sdp, "telling LM to unmount\n");
+			lm->lm_unmount(sdp);
+		}
+		fs_err(sdp, "withdrawn\n");
+		dump_stack();
 	}
-	fs_err(sdp, "withdrawn\n");
-	dump_stack();
+
+	if (sdp->sd_args.ar_errors == GFS2_ERRORS_PANIC)
+		panic("GFS2: fsid=%s: panic requested.\n", sdp->sd_fsname);
 
 	return -1;
 }
@@ -93,17 +99,24 @@ int gfs2_assert_warn_i(struct gfs2_sbd *sdp, char *assertion,
 			gfs2_tune_get(sdp, gt_complain_secs) * HZ))
 		return -2;
 
-	printk(KERN_WARNING
-	       "GFS2: fsid=%s: warning: assertion \"%s\" failed\n"
-	       "GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
-	       sdp->sd_fsname, assertion,
-	       sdp->sd_fsname, function, file, line);
+	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW)
+		printk(KERN_WARNING
+		       "GFS2: fsid=%s: warning: assertion \"%s\" failed\n"
+		       "GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
+		       sdp->sd_fsname, assertion,
+		       sdp->sd_fsname, function, file, line);
 
 	if (sdp->sd_args.ar_debug)
 		BUG();
 	else
 		dump_stack();
 
+	if (sdp->sd_args.ar_errors == GFS2_ERRORS_PANIC)
+		panic("GFS2: fsid=%s: warning: assertion \"%s\" failed\n"
+		      "GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
+		      sdp->sd_fsname, assertion,
+		      sdp->sd_fsname, function, file, line);
+
 	sdp->sd_last_warning = jiffies;
 
 	return -1;
-- 
1.6.2.5

