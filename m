Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYKZTzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYKZTzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYKZTzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:55:03 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42428 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYKZTzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:55:00 -0500
Date: Wed, 26 Nov 2008 19:54:57 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: [PATCH 1/2] relatime: Make atime updates more useful
Message-ID: <20081126195457.GA3541@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow atime to be updated once per day even with relatime enabled. This 
lets utilities like tmpreaper (which deletes files based on last access 
time) continue working.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Updated version of Ingo's patch from last year - this section is 
identical.

commit 2c145e187600ca961715fa82ae3ae7919d744bc9
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed Nov 26 17:44:07 2008 +0000

    Make relatime smarter
    
    Allow atime to be updated once per day even with relatime. This lets
    utilities like tmpreaper (which delete files based on last access time)
    continue working.

diff --git a/fs/inode.c b/fs/inode.c
index 0487ddb..348fa16 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1179,6 +1179,41 @@ sector_t bmap(struct inode * inode, sector_t block)
 }
 EXPORT_SYMBOL(bmap);
 
+/*
+ * Relative atime updates frequency (default: 1 day):
+ */
+int relatime_interval __read_mostly = 24*60*60;
+
+/*
+ * With relative atime, only update atime if the
+ * previous atime is earlier than either the ctime or
+ * mtime.
+ */
+static int relatime_need_update(struct inode *inode, struct timespec now)
+{
+	/*
+	 * Is mtime younger than atime? If yes, update atime:
+	 */
+	if (timespec_compare(&inode->i_mtime, &inode->i_atime) >= 0)
+		return 1;
+	/*
+	 * Is ctime younger than atime? If yes, update atime:
+	 */
+	if (timespec_compare(&inode->i_ctime, &inode->i_atime) >= 0)
+		return 1;
+
+	/*
+	 * Is the previous atime value older than the update interval?
+	 * If yes, update atime:
+	 */
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= relatime_interval)
+		return 1;
+	/*
+	 * Good, we can skip the atime update:
+	 */
+	return 0;
+}
+
 /**
  *	touch_atime	-	update the access time
  *	@mnt: mount the inode is accessed on
@@ -1206,17 +1241,12 @@ void touch_atime(struct vfsmount *mnt, struct dentry *dentry)
 		goto out;
 	if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
 		goto out;
-	if (mnt->mnt_flags & MNT_RELATIME) {
-		/*
-		 * With relative atime, only update atime if the previous
-		 * atime is earlier than either the ctime or mtime.
-		 */
-		if (timespec_compare(&inode->i_mtime, &inode->i_atime) < 0 &&
-		    timespec_compare(&inode->i_ctime, &inode->i_atime) < 0)
-			goto out;
-	}
 
 	now = current_fs_time(inode->i_sb);
+
+	if (mnt->mnt_flags & MNT_RELATIME)
+		if (!relatime_need_update(inode, now))
+			goto out;
 	if (timespec_equal(&inode->i_atime, &now))
 		goto out;
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
