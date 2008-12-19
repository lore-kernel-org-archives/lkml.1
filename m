Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYLSUs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYLSUs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYLSUrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:47:31 -0500
Received: from kumera.dghda.com ([80.68.90.171]:35266 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbYLSUr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:47:29 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       ecryptfs-devel@lists.launchpad.net
Subject: [PATCH, v5] eCryptfs: check readlink result was not an error before using it
Date: Fri, 19 Dec 2008 20:47:10 +0000
Message-Id: <1229719638-6982-3-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229719638-6982-2-git-send-email-duaneg@dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
 <1229719638-6982-2-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The result from readlink is being used to index into the link name
buffer without checking whether it is a valid length. If readlink
returns an error this will fault or cause memory corruption.

Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: ecryptfs-devel@lists.launchpad.net
Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
---

Unchanged from original version.

 fs/ecryptfs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 89209f0..5e78fc1 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -673,10 +673,11 @@ static void *ecryptfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	ecryptfs_printk(KERN_DEBUG, "Calling readlink w/ "
 			"dentry->d_name.name = [%s]\n", dentry->d_name.name);
 	rc = dentry->d_inode->i_op->readlink(dentry, (char __user *)buf, len);
-	buf[rc] = '\0';
 	set_fs(old_fs);
 	if (rc < 0)
 		goto out_free;
+	else
+		buf[rc] = '\0';
 	rc = 0;
 	nd_set_link(nd, buf);
 	goto out;
-- 
1.6.0.4

