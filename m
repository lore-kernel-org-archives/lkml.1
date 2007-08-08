Return-Path: <linux-kernel-owner+w=401wt.eu-S937591AbXHHRV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937591AbXHHRV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936939AbXHHRTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:38766 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935037AbXHHRTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:03 -0400
Message-Id: <20070808171644.161330964@suse.de>
References: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:28 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 06/10] Use vfs_permission instead of file_permission in do_path_lookup
Content-Disposition: inline; filename=do_path_lookup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from file_permission() to vfs_permission() in do_path_lookup()
by filling in the vfs_lookup in nd slightly earlier.

Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>

---
 fs/namei.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1133,25 +1133,23 @@ static int fastcall do_path_lookup(int d
 		nd->lookup.path.dentry = dget(fs->pwd);
 		read_unlock(&fs->lock);
 	} else {
-		struct dentry *dentry;
-
 		file = fget_light(dfd, &fput_needed);
 		retval = -EBADF;
 		if (!file)
 			goto out_fail;
 
-		dentry = file->f_path.dentry;
+		nd->lookup.path = file->f_path;
 
 		retval = -ENOTDIR;
-		if (!S_ISDIR(dentry->d_inode->i_mode))
+		if (!S_ISDIR(nd->lookup.path.dentry->d_inode->i_mode))
 			goto fput_fail;
 
-		retval = file_permission(file, MAY_EXEC);
+		retval = vfs_permission(&nd->lookup, MAY_EXEC);
 		if (retval)
 			goto fput_fail;
 
-		nd->lookup.path.mnt = mntget(file->f_path.mnt);
-		nd->lookup.path.dentry = dget(dentry);
+		mntget(nd->lookup.path.mnt);
+		dget(nd->lookup.path.dentry);
 
 		fput_light(file, fput_needed);
 	}

