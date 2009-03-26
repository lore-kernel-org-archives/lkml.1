Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZCZRdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZCZRdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZCZRc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:32:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36332 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbZCZRcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:32:55 -0400
Date: Thu, 26 Mar 2009 17:32:14 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       mingo@elte.hu, tytso@mit.edu, jack@suse.cz, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
       jens.axboe@oracle.com, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, oleg@redhat.com, roland@redhat.com,
       willy@linux.intel.com, vaurora@redhat.com
Subject: [PATCH] Allow relatime to update atime once a day
Message-ID: <20090326173214.GA7198@srcf.ucam.org>
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326140312.GB14822@elte.hu> <20090326073013.2fa83178.akpm@linux-foundation.org> <200903261632.42439.elendil@planet.nl> <20090326084733.156c4910.akpm@linux-foundation.org> <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow atime to be updated once per day even with relatime. This lets
utilities like tmpreaper (which delete files based on last access time)
continue working, making relatime a plausible default for distributions.
    
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
