Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbYGZHm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbYGZHm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 03:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYGZHmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 03:42:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:60147 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYGZHmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 03:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fvErov73fFbKsfTRTxf4/xrJ0QowSJ5ncl0QWtIQqUBFa20tPhB1W4rTK2ioyvlWlo
         bwyV9XYdK9SsmMjD6CxdnE9CCpTHdzHq7r7ULgQEcoDA6SMP4kVgz56/nCU7ZQM68kTb
         BJbFBCtySX6epOs41j3aDN6mw+X/ZSa16Rq7w=
Date: Sat, 26 Jul 2008 11:42:16 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] devpts: switch to IDA
Message-ID: <20080726074215.GA4956@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devpts code wants just numbers for tty indexes.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/devpts/inode.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -29,7 +29,7 @@
 #define DEVPTS_DEFAULT_MODE 0600
 
 extern int pty_limit;			/* Config limit on Unix98 ptys */
-static DEFINE_IDR(allocated_ptys);
+static DEFINE_IDA(allocated_ptys);
 static DEFINE_MUTEX(allocated_ptys_lock);
 
 static struct vfsmount *devpts_mnt;
@@ -180,24 +180,24 @@ static struct dentry *get_node(int num)
 int devpts_new_index(void)
 {
 	int index;
-	int idr_ret;
+	int ida_ret;
 
 retry:
-	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
+	if (!ida_pre_get(&allocated_ptys, GFP_KERNEL)) {
 		return -ENOMEM;
 	}
 
 	mutex_lock(&allocated_ptys_lock);
-	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
-	if (idr_ret < 0) {
+	ida_ret = ida_get_new(&allocated_ptys, &index);
+	if (ida_ret < 0) {
 		mutex_unlock(&allocated_ptys_lock);
-		if (idr_ret == -EAGAIN)
+		if (ida_ret == -EAGAIN)
 			goto retry;
 		return -EIO;
 	}
 
 	if (index >= pty_limit) {
-		idr_remove(&allocated_ptys, index);
+		ida_remove(&allocated_ptys, index);
 		mutex_unlock(&allocated_ptys_lock);
 		return -EIO;
 	}
@@ -208,7 +208,7 @@ retry:
 void devpts_kill_index(int idx)
 {
 	mutex_lock(&allocated_ptys_lock);
-	idr_remove(&allocated_ptys, idx);
+	ida_remove(&allocated_ptys, idx);
 	mutex_unlock(&allocated_ptys_lock);
 }
 

