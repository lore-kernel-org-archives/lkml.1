Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbZBJPp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbZBJPp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZBJPpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:45:17 -0500
Received: from sh.osrg.net ([192.16.179.4]:41121 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbZBJPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:45:15 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm] nilfs2: fix buggy behavior seen in enumerating checkpoints
Date: Wed, 11 Feb 2009 00:42:49 +0900
Message-Id: <1234280569-18102-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 11 Feb 2009 00:44:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will fix the weird behavior of lscp command in listing
continuously created checkpoints; the output of lscp is rewinded
regularly for the recent nilfs.  As a result of debugging, a defect
was found in nilfs_cpfile_do_get_cpinfo() function.

Though the function can be repeatedly called to enumerate checkpoints
and it can skip invalid checkpoint entries, the index value was not
carried between successive calls.

The bug has long been present, and came to surface after applying a
bugfix nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch, which
increased frequency of calling the function.  The similar bugfix was
already applied for ``snapshots'' by
nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch.

This fixes the problem by making the index argument bidirectional on
the function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/cpfile.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index a4c9550..eb9b2d8 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -382,13 +382,13 @@ static void nilfs_cpfile_checkpoint_to_cpinfo(struct inode *cpfile,
 	ci->ci_next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
 }
 
-static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 cno,
+static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 *cnop,
 					  struct nilfs_cpinfo *ci, size_t nci)
 {
 	struct nilfs_checkpoint *cp;
 	struct buffer_head *bh;
 	size_t cpsz = NILFS_MDT(cpfile)->mi_entry_size;
-	__u64 cur_cno = nilfs_mdt_cno(cpfile);
+	__u64 cur_cno = nilfs_mdt_cno(cpfile), cno = *cnop;
 	void *kaddr;
 	int n, ret;
 	int ncps, i;
@@ -416,6 +416,8 @@ static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 cno,
 	}
 
 	ret = n;
+	if (n > 0)
+		*cnop = ci[n - 1].ci_cno + 1;
 
  out:
 	up_read(&NILFS_MDT(cpfile)->mi_sem);
@@ -504,7 +506,7 @@ ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
 {
 	switch (mode) {
 	case NILFS_CHECKPOINT:
-		return nilfs_cpfile_do_get_cpinfo(cpfile, *cnop, ci, nci);
+		return nilfs_cpfile_do_get_cpinfo(cpfile, cnop, ci, nci);
 	case NILFS_SNAPSHOT:
 		return nilfs_cpfile_do_get_ssinfo(cpfile, cnop, ci, nci);
 	default:
@@ -520,13 +522,14 @@ ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
 int nilfs_cpfile_delete_checkpoint(struct inode *cpfile, __u64 cno)
 {
 	struct nilfs_cpinfo ci;
+	__u64 tcno = cno;
 	ssize_t nci;
 	int ret;
 
 	/* checkpoint number 0 is invalid */
 	if (cno == 0)
 		return -ENOENT;
-	nci = nilfs_cpfile_do_get_cpinfo(cpfile, cno, &ci, 1);
+	nci = nilfs_cpfile_do_get_cpinfo(cpfile, &tcno, &ci, 1);
 	if (nci < 0)
 		return nci;
 	else if (nci == 0 || ci.ci_cno != cno)
-- 
1.5.6.5

