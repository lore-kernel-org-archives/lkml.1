Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYK0PBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYK0PBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYK0PBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:01:34 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43762 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYK0PBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:01:33 -0500
Date: Thu, 27 Nov 2008 15:01:26 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mingo@redhat.com, val.henson@gmail.com, matthew@wil.cx
Subject: [PATCH v2 1/2] relatime: Make relatime behaviour smarter
Message-ID: <20081127150126.GA20941@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492DD035.5020705@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make relatime smarter
    
Allow atime to be updated once per day even with relatime. This lets
utilities like tmpreaper (which delete files based on last access time)
continue working.

---

Subset of Ingo's original patch, rediffed against current git

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
