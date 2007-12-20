Return-Path: <linux-kernel-owner+w=401wt.eu-S935224AbXLTO3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935224AbXLTO3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbXLTONO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:13:14 -0500
Received: from ns2.suse.de ([195.135.220.15]:56843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037AbXLTONL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:13:11 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:47 2007
Message-Id: <20071220140947.312934105@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:49 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 39/47] Fix file_permission()
Content-Disposition: inline; filename=file_permission-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
+	nd.path.dentry = file->f_path.dentry;
+	nd.path.mnt = file->f_path.mnt;
+	nd.flags = LOOKUP_ACCESS;
+
+	return permission(nd.path.dentry->d_inode, mask, &nd);
 }
 
 /*

-- 

