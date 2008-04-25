Return-Path: <linux-kernel-owner+w=401wt.eu-S1765682AbYDYSIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765682AbYDYSIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762841AbYDYR5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55831 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764762AbYDYR47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:56:59 -0400
Message-Id: <20080425175656.742025100@szeredi.hu>
References: <20080425175520.735386844@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 25 Apr 2008 19:55:22 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 2/5] fuse: fix node ID type
Content-Disposition: inline; filename=fuse_64bit_nodeid.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Node ID is 64bit but it is passed as unsigned long to some functions.
This breakage wasn't noticed, because libfuse uses unsigned long too.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/fuse_i.h |    4 ++--
 fs/fuse/inode.c  |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2008-04-09 13:17:45.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2008-04-09 13:17:59.000000000 +0200
@@ -461,7 +461,7 @@ extern const struct file_operations fuse
 /**
  * Get a filled in inode
  */
-struct inode *fuse_iget(struct super_block *sb, unsigned long nodeid,
+struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 			int generation, struct fuse_attr *attr,
 			u64 attr_valid, u64 attr_version);
 
@@ -469,7 +469,7 @@ struct inode *fuse_iget(struct super_blo
  * Send FORGET command
  */
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
-		      unsigned long nodeid, u64 nlookup);
+		      u64 nodeid, u64 nlookup);
 
 /**
  * Initialize READ or READDIR request
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2008-04-09 13:17:45.000000000 +0200
+++ linux/fs/fuse/inode.c	2008-04-09 13:17:59.000000000 +0200
@@ -84,7 +84,7 @@ static void fuse_destroy_inode(struct in
 }
 
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
-		      unsigned long nodeid, u64 nlookup)
+		      u64 nodeid, u64 nlookup)
 {
 	struct fuse_forget_in *inarg = &req->misc.forget_in;
 	inarg->nlookup = nlookup;
@@ -207,7 +207,7 @@ static void fuse_init_inode(struct inode
 
 static int fuse_inode_eq(struct inode *inode, void *_nodeidp)
 {
-	unsigned long nodeid = *(unsigned long *) _nodeidp;
+	u64 nodeid = *(u64 *) _nodeidp;
 	if (get_node_id(inode) == nodeid)
 		return 1;
 	else
@@ -216,12 +216,12 @@ static int fuse_inode_eq(struct inode *i
 
 static int fuse_inode_set(struct inode *inode, void *_nodeidp)
 {
-	unsigned long nodeid = *(unsigned long *) _nodeidp;
+	u64 nodeid = *(u64 *) _nodeidp;
 	get_fuse_inode(inode)->nodeid = nodeid;
 	return 0;
 }
 
-struct inode *fuse_iget(struct super_block *sb, unsigned long nodeid,
+struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 			int generation, struct fuse_attr *attr,
 			u64 attr_valid, u64 attr_version)
 {

--
