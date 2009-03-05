Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZCEQLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZCEQLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbZCEQLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:11:21 -0500
Received: from sh.osrg.net ([192.16.179.4]:40818 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbZCEQLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:11:18 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH -mm 3/5] nilfs2: mark minor flag for checkpoint created by internal operation
Date: Fri,  6 Mar 2009 01:07:47 +0900
Message-Id: <1236269269-512-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1236269269-512-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1236269269-512-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 Mar 2009 01:11:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nilfs creates checkpoints even for garbage collection or metadata
updates such as checkpoint mode change.  So, user often sees
checkpoints created only by such internal operations.

This is inconvenient in some situations.  For example, application
that monitors checkpoints and changes them to snapshots, will fall
into an infinite loop because it cannot distinguish internally created
checkpoints.

This patch solves this sort of problem by adding a flag to checkpoint
for identification.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/segment.c       |    9 +++++++++
 fs/nilfs2/segment.h       |    3 +++
 include/linux/nilfs2_fs.h |    3 +++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 981c34a..2879704 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -462,6 +462,9 @@ static void nilfs_segctor_begin_finfo(struct nilfs_sc_info *sci,
 	sci->sc_binfo_ptr = sci->sc_finfo_ptr;
 	nilfs_segctor_map_segsum_entry(
 		sci, &sci->sc_binfo_ptr, sizeof(struct nilfs_finfo));
+
+	if (inode->i_sb && !test_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags))
+		set_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 	/* skip finfo */
 }
 
@@ -887,6 +890,11 @@ static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 	raw_cp->cp_create = cpu_to_le64(sci->sc_seg_ctime);
 	raw_cp->cp_cno = cpu_to_le64(nilfs->ns_cno);
 
+	if (test_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags))
+		nilfs_checkpoint_clear_minor(raw_cp);
+	else
+		nilfs_checkpoint_set_minor(raw_cp);
+
 	nilfs_write_inode_common(sbi->s_ifile, &raw_cp->cp_ifile_inode, 1);
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
 	return 0;
@@ -2091,6 +2099,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno);
 
+		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
 		set_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags);
 	} else
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index fbd162d..bb7d417 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -185,6 +185,9 @@ enum {
 	NILFS_SC_SUPER_ROOT,	/* The latest segment has a super root */
 	NILFS_SC_PRIOR_FLUSH,	/* Requesting immediate flush without making a
 				   checkpoint */
+	NILFS_SC_HAVE_DELTA,	/* Next checkpoint will have update of files
+				   other than DAT, cpfile, sufile, or files
+				   moved by GC */
 };
 
 /* sc_state */
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index e9c84aa..cbce664 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -470,6 +470,7 @@ enum {
 	NILFS_CHECKPOINT_SNAPSHOT,
 	NILFS_CHECKPOINT_INVALID,
 	NILFS_CHECKPOINT_SKETCH,
+	NILFS_CHECKPOINT_MINOR,
 };
 
 #define NILFS_CHECKPOINT_FNS(flag, name)				\
@@ -494,6 +495,7 @@ nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)		\
 
 NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
 NILFS_CHECKPOINT_FNS(INVALID, invalid)
+NILFS_CHECKPOINT_FNS(MINOR, minor)
 
 /**
  * struct nilfs_cpinfo - checkpoint information
@@ -526,6 +528,7 @@ nilfs_cpinfo_##name(const struct nilfs_cpinfo *cpinfo)			\
 
 NILFS_CPINFO_FNS(SNAPSHOT, snapshot)
 NILFS_CPINFO_FNS(INVALID, invalid)
+NILFS_CPINFO_FNS(MINOR, minor)
 
 
 /**
-- 
1.5.6.5

