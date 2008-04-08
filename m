Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYDHLV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYDHLV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYDHLTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:25 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:41730 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYDHLTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:21 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 3/29] nfs: use proc_create to setup de->proc_fops
Date: Tue,  8 Apr 2008 15:19:10 +0400
Message-Id: <1207653576-12640-3-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing
PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Trond.Myklebust@netapp.com
---
 fs/nfs/client.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 67a193f..6d62652 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1314,6 +1314,7 @@ static const struct file_operations nfs_server_list_fops = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.owner		= THIS_MODULE,
 };
 
 static int nfs_volume_list_open(struct inode *inode, struct file *file);
@@ -1334,6 +1335,7 @@ static const struct file_operations nfs_volume_list_fops = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.owner		= THIS_MODULE,
 };
 
 /*
@@ -1500,20 +1502,16 @@ int __init nfs_fs_proc_init(void)
 	proc_fs_nfs->owner = THIS_MODULE;
 
 	/* a file of servers with which we're dealing */
-	p = create_proc_entry("servers", S_IFREG|S_IRUGO, proc_fs_nfs);
+	p = proc_create("servers", S_IFREG|S_IRUGO,
+			proc_fs_nfs, &nfs_server_list_fops);
 	if (!p)
 		goto error_1;
 
-	p->proc_fops = &nfs_server_list_fops;
-	p->owner = THIS_MODULE;
-
 	/* a file of volumes that we have mounted */
-	p = create_proc_entry("volumes", S_IFREG|S_IRUGO, proc_fs_nfs);
+	p = proc_create("volumes", S_IFREG|S_IRUGO,
+			proc_fs_nfs, &nfs_volume_list_fops);
 	if (!p)
 		goto error_2;
-
-	p->proc_fops = &nfs_volume_list_fops;
-	p->owner = THIS_MODULE;
 	return 0;
 
 error_2:
-- 
1.5.3.rc5

