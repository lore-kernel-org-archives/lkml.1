Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXIQLbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXIQLbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbXIQLaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:30:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbXIQL34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:29:56 -0400
Date: Mon, 17 Sep 2007 07:29:31 -0400
Message-Id: <200709171129.l8HBTVud024387@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 5/7] VFS: make notify_change pass ATTR_KILL_S*ID to setattr operations
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When an unprivileged process attempts to modify a file that has the
setuid or setgid bits set, the VFS will attempt to clear these bits. The
VFS will set the ATTR_KILL_SUID or ATTR_KILL_SGID bits in the ia_valid
mask, and then call notify_change to clear these bits and set the mode
accordingly.

With a networked filesystem (NFS and CIFS in particular but likely
others), the client machine or process may not have credentials that
allow for setting the mode. In some situations, this can lead to file
corruption, an operation failing outright because the setattr fails, or
to races that lead to a mode change being reverted.

In this situation, we'd like to just leave the handling of this to the
server and ignore these bits. The problem is that by the time the
setattr op is called, the VFS has already reinterpreted the ATTR_KILL_*
bits into a mode change. The setattr operation has no way to know its
intent.

The following patch fixes this by making notify_change no longer
clear the ATTR_KILL_SUID and ATTR_KILL_SGID bits in the ia_valid before
handing it off to the setattr inode op. setattr can then check for the
presence of these bits, and if they're set it can assume that the mode
change was only for the purposes of clearing these bits.

This means that we now have an implicit assumption that notify_change is
never called with ATTR_MODE and either ATTR_KILL_S*ID bit set. Nothing
currently enforces that, so this patch also adds a BUG() if that occurs.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/attr.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index ae58bd3..966b73e 100644
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
@@ -125,18 +124,25 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 		if (error)
 			return error;
 	}
+
+	/*
+	 * We now pass ATTR_KILL_S*ID to the lower level setattr function so
+	 * that the function has the ability to reinterpret a mode change
+	 * that's due to these bits. This adds an implicit restriction that
+	 * no function will ever call notify_change with both ATTR_MODE and
+	 * ATTR_KILL_S*ID set.
+	 */
+	if ((ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID)) &&
+	    (ia_valid & ATTR_MODE))
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
@@ -145,7 +151,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 			attr->ia_mode &= ~S_ISGID;
 		}
 	}
-	if (!attr->ia_valid)
+	if (!(attr->ia_valid & ~(ATTR_KILL_SUID | ATTR_KILL_SGID)))
 		return 0;
 
 	if (ia_valid & ATTR_SIZE)
-- 
1.5.2.1

