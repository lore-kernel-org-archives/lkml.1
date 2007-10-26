Return-Path: <linux-kernel-owner+w=401wt.eu-S1765435AbXJZHQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765435AbXJZHQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762326AbXJZG7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:59:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:37055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762310AbXJZG7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:59:37 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:53 2007
Message-Id: <20071026064053.233728624@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:41:09 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 45/45] Fix file_permission()
Content-Disposition: inline; filename=file_permission-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot easily switch from file_permission() to vfs_permission()
everywhere, so fix file_permission() to not use a NULL nameidata
for the remaining users.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -313,7 +313,13 @@ int vfs_permission(struct nameidata *nd,
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

