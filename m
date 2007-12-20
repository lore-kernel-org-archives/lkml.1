Return-Path: <linux-kernel-owner+w=401wt.eu-S933878AbXLTOdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878AbXLTOdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbXLTONG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:13:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:40986 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932969AbXLTOND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:13:03 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:47 2007
Message-Id: <20071220140947.033155999@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:47 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 37/47] Switch to vfs_permission() in do_path_lookup()
Content-Disposition: inline; filename=do_path_lookup-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from file_permission() to vfs_permission() in do_path_lookup():
this avoids calling permission() with a NULL nameidata here.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1150,24 +1150,21 @@ static int fastcall do_path_lookup(int d
 		path_get(&fs->pwd);
 		read_unlock(&fs->lock);
 	} else {
-		struct dentry *dentry;
-
 		file = fget_light(dfd, &fput_needed);
 		retval = -EBADF;
 		if (!file)
 			goto out_fail;
 
-		dentry = file->f_path.dentry;
+		nd->path = file->f_path;
 
 		retval = -ENOTDIR;
-		if (!S_ISDIR(dentry->d_inode->i_mode))
+		if (!S_ISDIR(nd->path.dentry->d_inode->i_mode))
 			goto fput_fail;
 
-		retval = file_permission(file, MAY_EXEC);
+		retval = vfs_permission(nd, MAY_EXEC);
 		if (retval)
 			goto fput_fail;
 
-		nd->path = file->f_path;
 		path_get(&file->f_path);
 
 		fput_light(file, fput_needed);

-- 

