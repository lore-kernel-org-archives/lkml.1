Return-Path: <linux-kernel-owner+w=401wt.eu-S1762152AbXGMXra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbXGMXra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbXGMXrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:47:23 -0400
Received: from smtp.qwerty.ru ([87.240.2.134]:33148 "EHLO smtp.qwerty.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbXGMXrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:47:23 -0400
Date: Sat, 14 Jul 2007 03:47:21 +0400
From: Kirill Kuvaldin <kuvkir@epsmu.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] isofs: mounting to regular file may succeed
Message-ID: <20070713234721.GG4536@zetta.epsmu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It turned out that mounting a corrupted ISO image to a regular file may
succeed, e.g. if an image was prepared as follows:

$ dd if=correct.iso of=bad.iso bs=4k count=8

We then can mount it to a regular file:

# mount -o loop -t iso9660 bad.iso /tmp/file

But mounting it to a directory fails with -ENOTDIR, simply because 
the root directory inode doesn't have S_IFDIR set and the condition
in graft_tree() is met:

	if (S_ISDIR(nd->dentry->d_inode->i_mode) !=
	      S_ISDIR(mnt->mnt_root->d_inode->i_mode))
		return -ENOTDIR

This is because the root directory inode was read from an incorrect
block. It's supposed to be read from sbi->s_firstdatazone, which is
an absolute value and gets messed up in the case of an incorrect image.

In order to somehow circumvent this we have to check that the root
directory inode is actually a directory after all.


Signed-off-by: Kirill Kuvaldin <kuvkir@epsmu.com>

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 5c3eecf..ce5062a 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -840,6 +840,15 @@ root_found:
 		goto out_no_root;
 	if (!inode->i_op)
 		goto out_bad_root;
+
+	/* Make sure the root inode is a directory */
+	if (!S_ISDIR(inode->i_mode)) {
+		printk(KERN_WARNING
+			"isofs_fill_super: root inode is not a directory. "
+			"Corrupted media?\n");
+		goto out_iput;
+	}
+
 	/* get the root dentry */
 	s->s_root = d_alloc_root(inode);
 	if (!(s->s_root))
