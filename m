Return-Path: <linux-kernel-owner+w=401wt.eu-S971076AbXILRcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971076AbXILRcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967906AbXILRcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:32:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967468AbXILRcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:32:24 -0400
Date: Wed, 12 Sep 2007 13:32:21 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-cifs-client@lists.samba.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] CIFS: respect umask when using POSIX mkdir
Message-Id: <20070912133221.d63a8213.jlayton@redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When making a directory with POSIX mkdir calls, cifs_mkdir does not
respect the umask. This moves the AND'ing of the mode with the umask
to higher in the function so that the POSIX mkdir creates with the
correct mode.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 66436f5..260ab4e 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -908,6 +908,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 		return -ENOMEM;
 	}
 
+	mode &= ~current->fs->umask;
 	if ((pTcon->ses->capabilities & CAP_UNIX) &&
 		(CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(pTcon->fsUnixInfo.Capability))) {
@@ -999,7 +1000,6 @@ mkdir_get_info:
 		if ((direntry->d_inode) && (direntry->d_inode->i_nlink < 2))
 				direntry->d_inode->i_nlink = 2;
 		if (pTcon->unix_ext) {
-			mode &= ~current->fs->umask;
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 				CIFSSMBUnixSetPerms(xid, pTcon, full_path,
 						    mode,
-- 
1.5.2.1

