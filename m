Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbYEPRIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbYEPRIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbYEPRHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:07:31 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:35493 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759306AbYEPRH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:07:29 -0400
To: linux-kernel@vger.kernel.org
Subject: [RFC Patch 3/5] Blktrace - Remove the "block" directory operations from blktrace.c
Reply-To: prasad@linux.vnet.ibm.com
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
Organization: IBM
Cc: dwilder@us.ibm.com, axboe@kernel.dk, linux-btrace@vger.kernel.org,
       akpm@linux-foundation.org, prasad@linux.vnet.ibm.com
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
In-Reply-To: <20080516164644.GA22928@in.ibm.com>
References: <20080516164644.GA22928@in.ibm.com>
Content-Transfer-Encoding: 8BIT
Date: Fri, 16 May 2008 22:36:58 +0530
Message-ID: <op.ua9a5wic03j166@prasadkr_t60p.in.ibm.com>
User-Agent: Opera Mail/9.26 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the code associated with the creation/removal/access
operations associated with the "block" directory. Please note that the  
"block"
di
rectory had been renamed "block_old" in the previous patch for testing.  
This
change is however temporary, since all code relevant to directory  
operations
are removed through this patch.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
  block/blktrace.c             |   57  
-------------------------------------------
  include/linux/blktrace_api.h |    1
  2 files changed, 58 deletions(-)

Index: linux-blktrace-many/block/blktrace.c
===================================================================
--- linux-blktrace-many.orig/block/blktrace.c
+++ linux-blktrace-many/block/blktrace.c
@@ -180,59 +180,9 @@ void __blk_add_trace(struct blk_trace *b

  EXPORT_SYMBOL_GPL(__blk_add_trace);

-static struct dentry *blk_tree_root;
-static DEFINE_MUTEX(blk_tree_mutex);
-static unsigned int root_users;
-
-static inline void blk_remove_root(void)
-{
-	if (blk_tree_root) {
-		debugfs_remove(blk_tree_root);
-		blk_tree_root = NULL;
-	}
-}
-
-static void blk_remove_tree(struct dentry *dir)
-{
-	mutex_lock(&blk_tree_mutex);
-	debugfs_remove(dir);
-	if (--root_users == 0)
-		blk_remove_root();
-	mutex_unlock(&blk_tree_mutex);
-}
-
-static struct dentry *blk_create_tree(const char *blk_name)
-{
-	struct dentry *dir = NULL;
-	int created = 0;
-
-	mutex_lock(&blk_tree_mutex);
-
-	if (!blk_tree_root) {
-		blk_tree_root = debugfs_create_dir("block_old", NULL);
-		if (!blk_tree_root)
-			goto err;
-		created = 1;
-	}
-
-	dir = debugfs_create_dir(blk_name, blk_tree_root);
-	if (dir)
-		root_users++;
-	else {
-		/* Delete root only if we created it */
-		if (created)
-			blk_remove_root();
-	}
-
-err:
-	mutex_unlock(&blk_tree_mutex);
-	return dir;
-}
-
  static void blk_trace_cleanup(struct blk_trace *bt)
  {
  	relay_close(bt->rchan);
-	blk_remove_tree(bt->dir);
  	free_percpu(bt->sequence);
  	trace_cleanup(bt->tpk->ti);

@@ -339,11 +289,6 @@ int do_blk_trace_setup(struct request_qu
  		goto err;

  	ret = -ENOENT;
-	dir = blk_create_tree(buts->name);
-	if (!dir)
-		goto err;
-
-	bt->dir = dir;
  	bt->dev = dev;

  	ret = -EIO;
@@ -377,8 +322,6 @@ dir_err:
  parent_dir_err:
  	kfree(bt->tpk);
  err:
-	if (dir)
-		blk_remove_tree(dir);
  	if (bt) {
  		free_percpu(bt->sequence);
  		if (bt->rchan)
Index: linux-blktrace-many/include/linux/blktrace_api.h
===================================================================
--- linux-blktrace-many.orig/include/linux/blktrace_api.h
+++ linux-blktrace-many/include/linux/blktrace_api.h
@@ -125,7 +125,6 @@ struct blk_trace {
  	u64 end_lba;
  	u32 pid;
  	u32 dev;
-	struct dentry *dir;
  	struct trace_info *ti;
  	struct trace_printk_data *tpk;
  };
