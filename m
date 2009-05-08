Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbZEHBNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbZEHBNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZEHBN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:13:26 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43248 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751626AbZEHBNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:13:25 -0400
From: Felix Blyakher <felixb@sgi.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, a.beregalov@gmail.com,
       kernel-testers@vger.kernel.org, Felix Blyakher <felixb@sgi.com>
Subject: [PATCH] xfs: fix double unlock in xfs_swap_extents()
Date: Thu,  7 May 2009 20:13:22 -0500
Message-Id: <1241745202-7452-1-git-send-email-felixb@sgi.com>
X-Mailer: git-send-email 1.5.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regreesion from commit ef8f7fc, which rearranged the code in
xfs_swap_extents() leading to double unlock of xfs inode iolock.
That resulted in xfs_fsr deadlocking itself on platforms, which
don't handle double unlock of rw_semaphore nicely. It caused the
count go negative, which represents the write holder, without
really having one. ia64 is one of the platforms where deadlock
was easily reproduced and the fix was tested.

Signed-off-by: Felix Blyakher <felixb@sgi.com>
---
 fs/xfs/xfs_dfrag.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index e6d839b..7465f9e 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -347,13 +347,15 @@ xfs_swap_extents(
 
 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
 
-out_unlock:
-	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 out:
 	kmem_free(tempifp);
 	return error;
 
+out_unlock:
+	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	goto out;
+
 out_trans_cancel:
 	xfs_trans_cancel(tp, 0);
 	goto out_unlock;
-- 
1.5.4.rc3

