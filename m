Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab0BJJa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:30:56 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:61048 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab0BJJ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:29:20 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, mfasheh@suse.com
Subject: [PATCH 09/11] ocfs2_dlmfs: Don't honor truncate.  The size of a dlmfs file is LVB_LEN
Date: Wed, 10 Feb 2010 01:27:52 -0800
Message-Id: <1265794074-19539-10-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
References: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B727C6C.0125:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want folks using dlmfs to be able to use the LVB in places other than
just write(2)/read(2).  By ignoring truncate requests, we allow 'echo
"contents" > /dlm/space/lockname' to work.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmfs/dlmfs.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index e21ce0e..13ac2bf 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -220,6 +220,23 @@ static int dlmfs_file_release(struct inode *inode,
 	return 0;
 }
 
+/*
+ * We do ->setattr() just to override size changes.  Our size is the size
+ * of the LVB and nothing else.
+ */
+static int dlmfs_file_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	int error;
+	struct inode *inode = dentry->d_inode;
+
+	attr->ia_valid &= ~ATTR_SIZE;
+	error = inode_change_ok(inode, attr);
+	if (!error)
+		error = inode_setattr(inode, attr);
+
+	return error;
+}
+
 static unsigned int dlmfs_file_poll(struct file *file, poll_table *wait)
 {
 	int event = 0;
@@ -634,6 +651,7 @@ static const struct super_operations dlmfs_ops = {
 
 static const struct inode_operations dlmfs_file_inode_operations = {
 	.getattr	= simple_getattr,
+	.setattr	= dlmfs_file_setattr,
 };
 
 static int dlmfs_get_sb(struct file_system_type *fs_type,
-- 
1.6.6.1

