Return-Path: <linux-kernel-owner+w=401wt.eu-S964888AbZKYNh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888AbZKYNh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934630AbZKYNh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:37:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964790AbZKYNgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:36:21 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/30] GFS2: add barrier/nobarrier mount options
Date: Wed, 25 Nov 2009 14:30:56 +0000
Message-Id: <1259159462-28622-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259159462-28622-3-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-1-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-2-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Currently gfs2 issues barrier unconditionally.  There are various reasons
to disable them, be that just for testing or for stupid devices flushing
large battert backed caches.  Add a nobarrier option that matches xfs and
btrfs for this.  Also add a symmetric barrier option to turn it back on
at remount time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/incore.h     |    1 +
 fs/gfs2/ops_fstype.c |    2 ++
 fs/gfs2/super.c      |   14 ++++++++++++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index c239b0f..4792200 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -429,6 +429,7 @@ struct gfs2_args {
 	unsigned int ar_meta:1;			/* mount metafs */
 	unsigned int ar_discard:1;		/* discard requests */
 	unsigned int ar_errors:2;               /* errors=withdraw | panic */
+	unsigned int ar_nobarrier:1;            /* do not send barriers */
 	int ar_commit;				/* Commit interval */
 	int ar_statfs_quantum;			/* The fast statfs interval */
 	int ar_quota_quantum;			/* The quota interval */
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 9744ee9..edfee24 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1131,6 +1131,8 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	}
 	if (sdp->sd_args.ar_posix_acl)
 		sb->s_flags |= MS_POSIXACL;
+	if (sdp->sd_args.ar_nobarrier)
+		set_bit(SDF_NOBARRIERS, &sdp->sd_flags);
 
 	sb->s_magic = GFS2_MAGIC;
 	sb->s_op = &gfs2_super_ops;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b1dcfab..5e4b314 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -73,6 +73,8 @@ enum {
 	Opt_statfs_quantum,
 	Opt_statfs_percent,
 	Opt_quota_quantum,
+	Opt_barrier,
+	Opt_nobarrier,
 	Opt_error,
 };
 
@@ -107,6 +109,8 @@ static const match_table_t tokens = {
 	{Opt_statfs_quantum, "statfs_quantum=%d"},
 	{Opt_statfs_percent, "statfs_percent=%d"},
 	{Opt_quota_quantum, "quota_quantum=%d"},
+	{Opt_barrier, "barrier"},
+	{Opt_nobarrier, "nobarrier"},
 	{Opt_error, NULL}
 };
 
@@ -253,6 +257,12 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			}
 			args->ar_errors = GFS2_ERRORS_PANIC;
 			break;
+		case Opt_barrier:
+			args->ar_nobarrier = 0;
+			break;
+		case Opt_nobarrier:
+			args->ar_nobarrier = 1;
+			break;
 		case Opt_error:
 		default:
 			printk(KERN_WARNING "GFS2: invalid mount option: %s\n", o);
@@ -1143,6 +1153,10 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 		sb->s_flags |= MS_POSIXACL;
 	else
 		sb->s_flags &= ~MS_POSIXACL;
+	if (sdp->sd_args.ar_nobarrier)
+		set_bit(SDF_NOBARRIERS, &sdp->sd_flags);
+	else
+		clear_bit(SDF_NOBARRIERS, &sdp->sd_flags);
 	spin_lock(&gt->gt_spin);
 	gt->gt_log_flush_secs = args.ar_commit;
 	gt->gt_quota_quantum = args.ar_quota_quantum;
-- 
1.6.2.5

