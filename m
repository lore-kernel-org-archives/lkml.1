Return-Path: <linux-kernel-owner+w=401wt.eu-S1750819AbXB1ELm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750819AbXB1ELm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 23:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXB1ELm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 23:11:42 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:8693 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbXB1ELl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 23:11:41 -0500
To: linux-kernel@vger.kernel.org
CC: Michael Halcrow <mhalcrow@us.ibm.com>
Subject: [PATCH] ecryptfs: lower root result must be adirectory
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Wed, 28 Feb 2007 07:06:21 +0300
Message-ID: <873b4rvsci.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

patch against lastest mm tree.

- Currently after path_lookup succeed we dot't have any guarantie what
  it is DIR. This must be explicitly demanded.
- path_lookup can't return negative dentry, So inode check is useless.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>


--=-=-=
Content-Disposition: inline; filename=diff-ms-ecryptfs-read_super-fix-b

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 812427e..fc4a3a2 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -484,18 +484,12 @@ static int ecryptfs_read_super(struct super_block *sb, const char *dev_name)
 	struct vfsmount *lower_mnt;
 
 	memset(&nd, 0, sizeof(struct nameidata));
-	rc = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
+	rc = path_lookup(dev_name, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &nd);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "path_lookup() failed\n");
 		goto out;
 	}
 	lower_root = nd.dentry;
-	if (!lower_root->d_inode) {
-		ecryptfs_printk(KERN_WARNING,
-				"No directory to interpose on\n");
-		rc = -ENOENT;
-		goto out_free;
-	}
 	lower_mnt = nd.mnt;
 	ecryptfs_set_superblock_lower(sb, lower_root->d_sb);
 	sb->s_maxbytes = lower_root->d_sb->s_maxbytes;

--=-=-=--

