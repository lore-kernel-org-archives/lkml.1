Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbXFZX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbXFZX0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760413AbXFZXNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:13:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:53857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760148AbXFZXM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:12:59 -0400
Message-Id: <20070626231215.920900277@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:40 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 44/44] Fix file_permission()
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
