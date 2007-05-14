Return-Path: <linux-kernel-owner+w=401wt.eu-S965826AbXENLcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965826AbXENLcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbXENLc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:32:28 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27929 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756689AbXENLc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:26 -0400
Message-Id: <20070514110623.729245216@suse.de>
References: <20070514110607.549397248@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:52 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 45/45] Fix file_permission()
Content-Disposition: inline; filename=file_permission-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot easily switch from file_permission() to vfs_permission()
everywhere, so fix file_permission() to not use a NULL nameidata
for the remaining users.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/namei.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -296,7 +296,13 @@ int vfs_permission(struct nameidata *nd,
  */
 int file_permission(struct file *file, int mask)
 {
-	return permission(file->f_path.dentry->d_inode, mask, NULL);
+	struct nameidata nd;
+	
+	nd.dentry = file->f_path.dentry;
+	nd.mnt = file->f_path.mnt;
+	nd.flags = LOOKUP_ACCESS;
+
+	return permission(nd.dentry->d_inode, mask, &nd);
 }
 
 /*

-- 
