Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbYCLRXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbYCLRXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYCLRW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:22:57 -0400
Received: from styx.suse.cz ([82.119.242.94]:50510 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750959AbYCLRW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:22:56 -0400
Date: Wed, 12 Mar 2008 18:22:55 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Do not allow setting of quota limits to too high values
Message-ID: <20080312172255.GB21395@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Perepechko <andrew.perepechko@sun.com>

We should check whether quota limits set via Q_SETQUOTA are not exceeding
limits which quota format is able to handle.

Signed-off-by: Andrew Perepechko <andrew.perepechko@sun.com>
Signed-off-by: Jan Kara <jack@suse.cz>

---
  Andrew, would you please queue it up for inclusion? Thanks.

 fs/dquot.c            |   22 +++++++++++++++++-----
 fs/quota_v1.c         |    3 +++
 fs/quota_v2.c         |    3 +++
 include/linux/quota.h |    2 ++
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 9c7feb6..f816d06 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1709,10 +1709,19 @@ int vfs_get_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *d
 }
 
 /* Generic routine for setting common part of quota structure */
-static void do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
+static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
 {
 	struct mem_dqblk *dm = &dquot->dq_dqb;
 	int check_blim = 0, check_ilim = 0;
+	struct mem_dqinfo *dqi = &sb_dqopt(dquot->dq_sb)->info[dquot->dq_type];
+
+	if ((di->dqb_valid & QIF_BLIMITS &&
+	     (di->dqb_bhardlimit > dqi->dqi_maxblimit ||
+	      di->dqb_bsoftlimit > dqi->dqi_maxblimit)) ||
+	    (di->dqb_valid & QIF_ILIMITS &&
+	     (di->dqb_ihardlimit > dqi->dqi_maxilimit ||
+	      di->dqb_isoftlimit > dqi->dqi_maxilimit)))
+		return -ERANGE;
 
 	spin_lock(&dq_data_lock);
 	if (di->dqb_valid & QIF_SPACE) {
@@ -1744,7 +1753,7 @@ static void do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
 			clear_bit(DQ_BLKS_B, &dquot->dq_flags);
 		}
 		else if (!(di->dqb_valid & QIF_BTIME))	/* Set grace only if user hasn't provided his own... */
-			dm->dqb_btime = get_seconds() + sb_dqopt(dquot->dq_sb)->info[dquot->dq_type].dqi_bgrace;
+			dm->dqb_btime = get_seconds() + dqi->dqi_bgrace;
 	}
 	if (check_ilim) {
 		if (!dm->dqb_isoftlimit || dm->dqb_curinodes < dm->dqb_isoftlimit) {
@@ -1752,7 +1761,7 @@ static void do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
 			clear_bit(DQ_INODES_B, &dquot->dq_flags);
 		}
 		else if (!(di->dqb_valid & QIF_ITIME))	/* Set grace only if user hasn't provided his own... */
-			dm->dqb_itime = get_seconds() + sb_dqopt(dquot->dq_sb)->info[dquot->dq_type].dqi_igrace;
+			dm->dqb_itime = get_seconds() + dqi->dqi_igrace;
 	}
 	if (dm->dqb_bhardlimit || dm->dqb_bsoftlimit || dm->dqb_ihardlimit || dm->dqb_isoftlimit)
 		clear_bit(DQ_FAKE_B, &dquot->dq_flags);
@@ -1760,21 +1769,24 @@ static void do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
 		set_bit(DQ_FAKE_B, &dquot->dq_flags);
 	spin_unlock(&dq_data_lock);
 	mark_dquot_dirty(dquot);
+
+	return 0;
 }
 
 int vfs_set_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *di)
 {
 	struct dquot *dquot;
+	int rc;
 
 	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
 	if (!(dquot = dqget(sb, id, type))) {
 		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 		return -ESRCH;
 	}
-	do_set_dqblk(dquot, di);
+	rc = do_set_dqblk(dquot, di);
 	dqput(dquot);
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
-	return 0;
+	return rc;
 }
 
 /* Generic routine for getting common part of quota file information */
diff --git a/fs/quota_v1.c b/fs/quota_v1.c
index f3841f2..a6cf926 100644
--- a/fs/quota_v1.c
+++ b/fs/quota_v1.c
@@ -139,6 +139,9 @@ static int v1_read_file_info(struct super_block *sb, int type)
 		goto out;
 	}
 	ret = 0;
+	/* limits are stored as unsigned 32-bit data */
+	dqopt->info[type].dqi_maxblimit = 0xffffffff;
+	dqopt->info[type].dqi_maxilimit = 0xffffffff;
 	dqopt->info[type].dqi_igrace = dqblk.dqb_itime ? dqblk.dqb_itime : MAX_IQ_TIME;
 	dqopt->info[type].dqi_bgrace = dqblk.dqb_btime ? dqblk.dqb_btime : MAX_DQ_TIME;
 out:
diff --git a/fs/quota_v2.c b/fs/quota_v2.c
index c519a58..23b647f 100644
--- a/fs/quota_v2.c
+++ b/fs/quota_v2.c
@@ -59,6 +59,9 @@ static int v2_read_file_info(struct super_block *sb, int type)
 			sb->s_id);
 		return -1;
 	}
+	/* limits are stored as unsigned 32-bit data */
+	info->dqi_maxblimit = 0xffffffff;
+	info->dqi_maxilimit = 0xffffffff;
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
 	info->dqi_igrace = le32_to_cpu(dinfo.dqi_igrace);
 	info->dqi_flags = le32_to_cpu(dinfo.dqi_flags);
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 6e0393a..c1cdbb7 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -202,6 +202,8 @@ struct mem_dqinfo {
 	unsigned long dqi_flags;
 	unsigned int dqi_bgrace;
 	unsigned int dqi_igrace;
+	qsize_t dqi_maxblimit;
+	qsize_t dqi_maxilimit;
 	union {
 		struct v1_mem_dqinfo v1_i;
 		struct v2_mem_dqinfo v2_i;
