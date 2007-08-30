Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbXH3Pn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbXH3Pn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbXH3Pno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:43:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758344AbXH3PnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:43:16 -0400
Date: Thu, 30 Aug 2007 11:06:38 -0400
Message-Id: <200708301506.l7UF6c63002133@dantu.rdu.redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 1/3] VFS: make notify_change pass ATTR_KILL_S*ID to setattr operations
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make notify_change not clear the ATTR_KILL_S*ID bits in the ia_vaid that
gets passed to the setattr inode operation. This allows the filesystems
to reinterpret whether this mode change is simply intended to clear the
setuid/setgid bits.

This means that notify_change should never be called with both ATTR_MODE
and either of the ATTR_KILL_S*ID bits set, since the filesystem would
have no way to know what part of the mode change was intentional. If
it is called this way, consider it a BUG().

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/attr.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index ae58bd3..f98d10c 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -103,12 +103,11 @@ EXPORT_SYMBOL(inode_setattr);
 int notify_change(struct dentry * dentry, struct iattr * attr)
 {
 	struct inode *inode = dentry->d_inode;
-	mode_t mode;
+	mode_t mode = inode->i_mode;
 	int error;
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
-	mode = inode->i_mode;
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
@@ -125,18 +124,21 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 		if (error)
 			return error;
 	}
+
+	/*
+	 * It's not valid to pass an iattr with both ATTR_MODE and
+	 * ATTR_KILL_S*ID set.
+	 */
+	if (ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID) && ia_valid & ATTR_MODE)
+		BUG();
+
 	if (ia_valid & ATTR_KILL_SUID) {
-		attr->ia_valid &= ~ATTR_KILL_SUID;
 		if (mode & S_ISUID) {
-			if (!(ia_valid & ATTR_MODE)) {
-				ia_valid = attr->ia_valid |= ATTR_MODE;
-				attr->ia_mode = inode->i_mode;
-			}
-			attr->ia_mode &= ~S_ISUID;
+			ia_valid = attr->ia_valid |= ATTR_MODE;
+			attr->ia_mode = (inode->i_mode & ~S_ISUID);
 		}
 	}
 	if (ia_valid & ATTR_KILL_SGID) {
-		attr->ia_valid &= ~ ATTR_KILL_SGID;
 		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
 			if (!(ia_valid & ATTR_MODE)) {
 				ia_valid = attr->ia_valid |= ATTR_MODE;
@@ -145,7 +147,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 			attr->ia_mode &= ~S_ISGID;
 		}
 	}
-	if (!attr->ia_valid)
+	if (!(attr->ia_valid & ~(ATTR_KILL_SUID | ATTR_KILL_SGID)))
 		return 0;
 
 	if (ia_valid & ATTR_SIZE)
-- 
1.5.2.1

