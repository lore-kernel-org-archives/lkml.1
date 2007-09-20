Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbXITHHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbXITHHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXITHF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:64799 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbXITHFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=urNv+o40vFCO46nA/aH6l1rCwiRPU/bNQK8K55TPVX+U4GOhWpAi4xyqUj0PnjnEF/OHWWHC3CRnZaYPlRNMt274tRRqoU6hitU2e3wbYUycIKRhzWEgFQt1W40kxwjWa/herM5C7uKmCljUOCcGqMnvRjk2hvYIcqSZwNaqJ4A=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 07/15] sysfs: kill unnecessary sysfs_get() in open paths
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:10 +0900
Message-Id: <11902719102893-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to get an extra reference to sysfs_dirent for an
open file.  Open file has a reference to the dentry which in turn has
a reference to sysfs_dirent.  This is fairly obvious as otherwise open
itself won't be able to access the sysfs_dirent.  Kill the extra
sysfs_get() and matching sysfs_put().

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c  |    4 +---
 fs/sysfs/file.c |    6 +-----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index a819a7e..e93fe5e 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -193,9 +193,8 @@ static int open(struct inode * inode, struct file * file)
 	mutex_init(&bb->mutex);
 	file->private_data = bb;
 
-	/* open succeeded, put active reference and pin attr_sd */
+	/* open succeeded, put active reference */
 	sysfs_put_active(attr_sd);
-	sysfs_get(attr_sd);
 	return 0;
 
  err_out:
@@ -211,7 +210,6 @@ static int release(struct inode * inode, struct file * file)
 
 	if (bb->mmapped)
 		sysfs_put_active_two(attr_sd);
-	sysfs_put(attr_sd);
 	kfree(bb->buffer);
 	kfree(bb);
 	return 0;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 61a8c19..73333dc 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -298,9 +298,8 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	buffer->ops = ops;
 	file->private_data = buffer;
 
-	/* open succeeded, put active references and pin attr_sd */
+	/* open succeeded, put active references */
 	sysfs_put_active_two(attr_sd);
-	sysfs_get(attr_sd);
 	return 0;
 
  err_out:
@@ -310,11 +309,8 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 
 static int sysfs_release(struct inode * inode, struct file * filp)
 {
-	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
 	struct sysfs_buffer *buffer = filp->private_data;
 
-	sysfs_put(attr_sd);
-
 	if (buffer) {
 		if (buffer->page)
 			free_page((unsigned long)buffer->page);
-- 
1.5.0.3


