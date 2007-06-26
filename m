Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXFZXZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXFZXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760399AbXFZXNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:13:07 -0400
Received: from ns1.suse.de ([195.135.220.2]:43108 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760354AbXFZXM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:12:56 -0400
Message-Id: <20070626231208.773317678@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:38 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 42/44] Switch to vfs_permission() in do_path_lookup()
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
@@ -1130,25 +1130,24 @@ static int fastcall do_path_lookup(int d
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
