Return-Path: <linux-kernel-owner+w=401wt.eu-S1765243AbXJZHPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765243AbXJZHPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762213AbXJZG7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:59:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:37046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760598AbXJZG71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:59:27 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:53 2007
Message-Id: <20071026064052.958161978@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:41:07 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 43/45] Switch to vfs_permission() in do_path_lookup()
Content-Disposition: inline; filename=do_path_lookup-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from file_permission() to vfs_permission() in do_path_lookup():
this avoids calling permission() with a NULL nameidata here.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1148,25 +1148,24 @@ static int fastcall do_path_lookup(int d
 		nd->dentry = dget(fs->pwd);
 		read_unlock(&fs->lock);
 	} else {
-		struct dentry *dentry;
-
 		file = fget_light(dfd, &fput_needed);
 		retval = -EBADF;
 		if (!file)
 			goto out_fail;
 
-		dentry = file->f_path.dentry;
+		nd->dentry = file->f_path.dentry;
+		nd->mnt = file->f_path.mnt;
 
 		retval = -ENOTDIR;
-		if (!S_ISDIR(dentry->d_inode->i_mode))
+		if (!S_ISDIR(nd->dentry->d_inode->i_mode))
 			goto fput_fail;
 
-		retval = file_permission(file, MAY_EXEC);
+		retval = vfs_permission(nd, MAY_EXEC);
 		if (retval)
 			goto fput_fail;
 
-		nd->mnt = mntget(file->f_path.mnt);
-		nd->dentry = dget(dentry);
+		mntget(nd->mnt);
+		dget(nd->dentry);
 
 		fput_light(file, fput_needed);
 	}

-- 

