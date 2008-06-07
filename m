Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbYFGTCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbYFGTCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762286AbYFGTBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:01:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:60873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbYFGTBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=AsPKcQBloSbMmGCgY2Mvs9Xj0PYRbI6Z3PBVfvYI+Jp/8hFEaGmzRMO+IOcbKrefxF
         tQNJIJsbrkWdm8jj4zeirfPUH4nF771t9kg2YBIRdjuhjhNA8lYa4R8B03bF+IV+MQhH
         ROKY1rO1+zwscpKvY322nXbyqvgWVgMWvOKYE=
Date: Sat, 7 Jun 2008 21:00:59 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>
Cc: linux-cifs-client@lists.samba.org, stable@kernel.org
Subject: [PATCH] cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is
	enabled
Message-ID: <20080607190055.GA5726@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple "mount -t cifs //xxx /mnt" oopsed on strlen of options
http://kerneloops.org/guilty.php?guilty=cifs_get_sb&version=2.6.25-release&start=1671168&end=1703935&class=oops

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs-client@lists.samba.org
Cc: stable@kernel.org
---
 fs/cifs/cifsfs.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5df93fd..86b4d5f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -97,9 +97,6 @@ cifs_read_super(struct super_block *sb, void *data,
 {
 	struct inode *inode;
 	struct cifs_sb_info *cifs_sb;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	int len;
-#endif
 	int rc = 0;
 
 	/* BB should we make this contingent on mount parm? */
@@ -117,15 +114,17 @@ cifs_read_super(struct super_block *sb, void *data,
 	 * complex operation (mount), and in case of fail
 	 * just exit instead of doing mount and attempting
 	 * undo it if this copy fails?*/
-	len = strlen(data);
-	cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
-	if (cifs_sb->mountdata == NULL) {
-		kfree(sb->s_fs_info);
-		sb->s_fs_info = NULL;
-		return -ENOMEM;
+	if (data) {
+		int len = strlen(data);
+		cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
+		if (cifs_sb->mountdata == NULL) {
+			kfree(sb->s_fs_info);
+			sb->s_fs_info = NULL;
+			return -ENOMEM;
+		}
+		strncpy(cifs_sb->mountdata, data, len + 1);
+		cifs_sb->mountdata[len] = '\0';
 	}
-	strncpy(cifs_sb->mountdata, data, len + 1);
-	cifs_sb->mountdata[len] = '\0';
 #endif
 
 	rc = cifs_mount(sb, cifs_sb, data, devname);
-- 
1.5.4.5

