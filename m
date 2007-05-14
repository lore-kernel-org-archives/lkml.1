Return-Path: <linux-kernel-owner+w=401wt.eu-S1032089AbXENL40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032089AbXENL40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762624AbXENLe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:34:57 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27946 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762324AbXENLco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:44 -0400
Message-Id: <20070514110623.061824777@suse.de>
References: <20070514110607.549397248@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:50 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 43/45] Switch to vfs_permission() in do_path_lookup()
Content-Disposition: inline; filename=do_path_lookup-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from file_permission() to vfs_permission() in do_path_lookup():
this avoids calling permission() with a NULL nameidata here.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

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
