Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZCVMPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZCVMPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 08:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZCVMOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 08:14:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:52694 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZCVMOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 08:14:53 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH -mm] nilfs2: fix improper return values of nilfs_get_cpinfo ioctl
Date: Sun, 22 Mar 2009 21:11:03 +0900
Message-Id: <1237723863-9255-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 22 Mar 2009 21:14:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few tool developers gave me requests for fixing inconvenient return
value of nilfs_get_cpinfo() ioctl; if the requested mode is
NILFS_SNAPSHOT and the specified start entry is not a snapshot, the
ioctl unnaturally returns one as the number of acquired snapshot item.

In addition, the ioctl function returns an ENOENT error for
checkpoints within blocks deleted by garbage collection.

These behaviors require corrections for programs which enumerate
snapshots.  This resolves the inconvenience by changing the return
values to zero for the above cases.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/cpfile.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 2e3b066..e90b60d 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -434,7 +434,7 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 	__u64 curr = *cnop, next;
 	unsigned long curr_blkoff, next_blkoff;
 	void *kaddr;
-	int n, ret;
+	int n = 0, ret;
 
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
@@ -458,27 +458,33 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 
 	curr_blkoff = nilfs_cpfile_get_blkoff(cpfile, curr);
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, curr, 0, &bh);
-	if (ret < 0)
+	if (unlikely(ret < 0)) {
+		if (ret == -ENOENT)
+			ret = 0; /* No snapshots (started from a hole block) */
 		goto out;
+	}
 	kaddr = kmap_atomic(bh->b_page, KM_USER0);
-	for (n = 0; n < nci; n++) {
-		cp = nilfs_cpfile_block_get_checkpoint(
-			cpfile, curr, bh, kaddr);
-		nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp, &ci[n]);
-		next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
-		if (next == 0) {
-			curr = ~(__u64)0; /* Terminator */
-			n++;
+	while (n < nci) {
+		cp = nilfs_cpfile_block_get_checkpoint(cpfile, curr, bh, kaddr);
+		curr = ~(__u64)0; /* Terminator */
+		if (unlikely(nilfs_checkpoint_invalid(cp) ||
+			     !nilfs_checkpoint_snapshot(cp)))
 			break;
-		}
+		nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp, &ci[n++]);
+		next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
+		if (next == 0)
+			break; /* reach end of the snapshot list */
+
 		next_blkoff = nilfs_cpfile_get_blkoff(cpfile, next);
 		if (curr_blkoff != next_blkoff) {
 			kunmap_atomic(kaddr, KM_USER0);
 			brelse(bh);
 			ret = nilfs_cpfile_get_checkpoint_block(cpfile, next,
 								0, &bh);
-			if (ret < 0)
+			if (unlikely(ret < 0)) {
+				WARN_ON(ret == -ENOENT);
 				goto out;
+			}
 			kaddr = kmap_atomic(bh->b_page, KM_USER0);
 		}
 		curr = next;
-- 
1.5.6.5

