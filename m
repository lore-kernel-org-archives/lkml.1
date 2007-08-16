Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbXHPI35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbXHPI35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764812AbXHPI2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:28:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567AbXHPI2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:28:44 -0400
Message-Id: <20070816074627.494510000@chello.nl>
References: <20070816074525.065850000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 09:45:37 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 12/23] containers: bdi init hooks
Content-Disposition: inline; filename=bdi_init_container.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

split off from the large bdi_init patch because containers are not slated
for mainline any time soon.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/container.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/container.c
===================================================================
--- linux-2.6.orig/kernel/container.c
+++ linux-2.6/kernel/container.c
@@ -567,12 +567,13 @@ static int container_populate_dir(struct
 static struct inode_operations container_dir_inode_operations;
 static struct file_operations proc_containerstats_operations;
 
+static struct backing_dev_info container_backing_dev_info = {
+	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+};
+
 static struct inode *container_new_inode(mode_t mode, struct super_block *sb)
 {
 	struct inode *inode = new_inode(sb);
-	static struct backing_dev_info container_backing_dev_info = {
-		.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
-	};
 
 	if (inode) {
 		inode->i_mode = mode;
@@ -2261,6 +2262,10 @@ int __init container_init(void)
 	int i;
 	struct proc_dir_entry *entry;
 
+	err = bdi_init(&container_backing_dev_info);
+	if (err)
+		return err;
+
 	for (i = 0; i < CONTAINER_SUBSYS_COUNT; i++) {
 		struct container_subsys *ss = subsys[i];
 		if (!ss->early_init)
@@ -2276,6 +2281,9 @@ int __init container_init(void)
 		entry->proc_fops = &proc_containerstats_operations;
 
 out:
+	if (err)
+		bdi_destroy(&container_backing_dev_info);
+
 	return err;
 }
 

--

