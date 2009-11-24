Return-Path: <linux-kernel-owner+w=401wt.eu-S934296AbZKXVwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934296AbZKXVwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933979AbZKXVws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:52:48 -0500
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:41385 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933974AbZKXVws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:52:48 -0500
Date: Tue, 24 Nov 2009 14:52:53 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: [PATCH XFS] Fix error return for fallocate() on XFS
Message-ID: <20091124215253.GA10693@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed that through glibc fallocate would return 28 rather than -1
and errno = 28 for ENOSPC. The xfs routines uses XFS_ERROR format
positive return error codes while the syscalls use negative return codes.
Fixup the two cases in xfs_vn_fallocate syscall to convert to negative.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index cd42ef7..1f3b4b8 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -573,8 +573,8 @@ xfs_vn_fallocate(
 	bf.l_len = len;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	error = xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
-				      0, XFS_ATTR_NOLOCK);
+	error = -xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
+				       0, XFS_ATTR_NOLOCK);
 	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode))
 		new_size = offset + len;
@@ -585,7 +585,7 @@ xfs_vn_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
+		error = -xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
 	}
 
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-- 
1.5.4.2

