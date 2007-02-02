Return-Path: <linux-kernel-owner+w=401wt.eu-S1945970AbXBBQ4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945970AbXBBQ4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945981AbXBBQ4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:56:05 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58323 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945970AbXBBQ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:56:04 -0500
Date: Fri, 2 Feb 2007 17:56:05 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: rminnich@lanl.gov, lucho@ionkov.net, v9fs-developer@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [2.6.20 patch] v9fs_vfs_mkdir(): fix a double free
Message-ID: <20070202165605.GI3754@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a double free of "dfid" introduced by
commit da977b2c7eb4d6312f063a7b486f2aad99809710 and spotted by the 
Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-rc6-mm3/fs/9p/vfs_inode.c.old	2007-02-02 17:11:10.000000000 +0100
+++ linux-2.6.20-rc6-mm3/fs/9p/vfs_inode.c	2007-02-02 17:39:12.000000000 +0100
@@ -583,21 +583,18 @@ static int v9fs_vfs_mkdir(struct inode *
 	v9fs_fid_clunk(v9ses, dfid);
 	inode = v9fs_inode_from_fid(v9ses, vfid->fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		inode = NULL;
-		goto clean_up_fids;
+		v9fs_fid_destroy(vfid);
+		goto error;
 	}
 
 	dentry->d_op = &v9fs_dentry_operations;
 	d_instantiate(dentry, inode);
 	return 0;
 
-clean_up_fids:
-	if (vfid)
-		v9fs_fid_destroy(vfid);
-
 clean_up_dfid:
 	v9fs_fid_clunk(v9ses, dfid);
 
 error:
 	return err;
