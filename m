Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYL1P3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYL1P3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 10:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYL1P3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 10:29:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35402 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbYL1P3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 10:29:04 -0500
Date: Sun, 28 Dec 2008 15:29:01 +0000
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH, resend] relatime: Let relatime update atime at least once per day
Message-ID: <20081228152901.GB13565@srcf.ucam.org>
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

Ensure relatime updates atime at least once per day
    
Allow atime to be updated once per day even with relatime. This lets
utilities like tmpreaper (which delete files based on last access time)
continue working.
    
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Acked-by: Valerie Aurora Henson <vaurora@redhat.com>
Acked-by: Alan Cox <alan@redhat.com>
Acked-by: Ingo Molnar <mingo@elte.hu>

---

diff --git a/fs/inode.c b/fs/inode.c
index 0487ddb..057c92b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1179,6 +1179,40 @@ sector_t bmap(struct inode * inode, sector_t block)
 }
 EXPORT_SYMBOL(bmap);
 
+/*
+ * With relative atime, only update atime if the previous atime is
+ * earlier than either the ctime or mtime or if at least a day has
+ * passed since the last atime update.
+ */
+static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
+			     struct timespec now)
+{
+
+	if (!(mnt->mnt_flags & MNT_RELATIME))
+		return 1;
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
+	 * Is the previous atime value older than a day? If yes,
+	 * update atime:
+	 */
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
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
@@ -1206,17 +1240,12 @@ void touch_atime(struct vfsmount *mnt, struct dentry *dentry)
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
+	if (!relatime_need_update(mnt, inode, now))
+		goto out;
+
 	if (timespec_equal(&inode->i_atime, &now))
 		goto out;

-- 
Matthew Garrett | mjg59@srcf.ucam.org
