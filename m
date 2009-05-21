Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbZEUAct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbZEUAct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZEUA3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:29:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46363 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbZEUA2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:19 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 20/20] sysfs: Normalize error handling in sysfs_fill_inode
Date: Wed, 20 May 2009 17:28:14 -0700
Message-Id: <1242865694-2100-20-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-19-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-7-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-8-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-9-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-10-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-11-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-12-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-13-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-14-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-15-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-16-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-17-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-18-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-19-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Use a single error exit path instead of doing whatever
is the required cleanup at each point we find the error.
Ultimately this should make the code more maintainable.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/mount.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 0cb1088..1dd023a 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -41,8 +41,9 @@ struct sysfs_dirent sysfs_root = {
 
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct inode *inode;
-	struct dentry *root;
+	struct inode *inode = NULL;
+	struct dentry *root = NULL;
+	int error;
 
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
@@ -51,24 +52,29 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 
 	/* get root inode, initialize and unlock it */
+	error = -ENOMEM;
 	mutex_lock(&sysfs_mutex);
 	inode = sysfs_get_inode(sb, &sysfs_root);
 	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
-		return -ENOMEM;
+		goto err_out;
 	}
 
 	/* instantiate and link root dentry */
+	error = -ENOMEM;
 	root = d_alloc_root(inode);
 	if (!root) {
 		pr_debug("%s: could not get root dentry!\n",__func__);
-		iput(inode);
-		return -ENOMEM;
+		goto err_out;
 	}
 	root->d_fsdata = &sysfs_root;
 	sb->s_root = root;
 	return 0;
+err_out:
+	dput(root);
+	iput(inode);
+	return error;
 }
 
 static int sysfs_get_sb(struct file_system_type *fs_type,
-- 
1.6.1.2.350.g88cc

