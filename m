Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbXGRF3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbXGRF3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbXGRF3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:29:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:22088 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbXGRF3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uVv8SiljtjSBp7MgvZFC5yUcMmpBgYvTvOZcYC4+vT1NNnqdK68w2UttSBdbUAKfyw4WZCVQSe43xtMtaA+8vY8BqU/yzfXwsuTuzTWitkLfvDkWHXiiCNYAi5/S7BeAhPqLPogRfMzy0J3Yjf2d3JV72r5/QZyMuRMGwNITzGE=
Date: Wed, 18 Jul 2007 14:29:06 +0900
From: Tejun Heo <htejun@gmail.com>
To: Greg KH <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: fix sysfs root inode nlink accounting
Message-ID: <20070718052906.GG23568@htj.dyndns.org>
References: <20070715124232.4e371bf9@hyperion.delvare> <20070717034844.GB11602@suse.de> <20070717131255.71b7e72e@hyperion.delvare> <20070717183652.GG9702@suse.de> <20070717230530.64d9a896@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717230530.64d9a896@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While making sysfs indoes hashed, sysfs root inode was left out.  Now
that nlink accounting depends on the inode being on the hash, sysfs
root inode nlink isn't adjusted properly.

Put sysfs root inode on the inode hash by allocating it using
sysfs_get_inode() like other sysfs inodes.  While at it, massage
comments a bit.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/mount.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: work/fs/sysfs/mount.c
===================================================================
--- work.orig/fs/sysfs/mount.c
+++ work/fs/sysfs/mount.c
@@ -43,19 +43,19 @@ static int sysfs_fill_super(struct super
 	sb->s_time_gran = 1;
 	sysfs_sb = sb;
 
-	inode = new_inode(sysfs_sb);
+	/* get root inode, initialize and unlock it */
+	inode = sysfs_get_inode(&sysfs_root);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
 		return -ENOMEM;
 	}
 
-	sysfs_init_inode(&sysfs_root, inode);
-
 	inode->i_op = &sysfs_dir_inode_operations;
 	inode->i_fop = &sysfs_dir_operations;
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
-	inc_nlink(inode);
+	inc_nlink(inode); /* directory, account for "." */
+	unlock_new_inode(inode);
 
+	/* instantiate and link root dentry */
 	root = d_alloc_root(inode);
 	if (!root) {
 		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
