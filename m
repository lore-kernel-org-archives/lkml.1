Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbXDIEXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbXDIEXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 00:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXDIES4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 00:18:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:34386 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbXDIESy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 00:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=VztWIQLoh8ajxn3pe7A48I9+isX6pAAZYM319dKL30kPHKedYFp9VNQP+SVr3XRyLZjHttg9sd0stgjK6S7LhcYKqh443Dujr53QdURr16phrp8pSRUHPixX4gpLmJtEMp0u2347s3k3rxEY+pYhqODTv4UwmKNWCdyHXxXiRnY=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 02/14] sysfs: fix error handling in binattr write()
In-Reply-To: <11760923261269-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Mon, 9 Apr 2007 13:18:47 +0900
Message-Id: <11760923271649-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling in fs/sysfs/bin.c:write() was wrong because size_t
count is used to receive return value from flush_write() which is
negative on failure.

This patch updates write() such that int variable is used instead.
read() is updated the same way for consistency.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index d3b9f5f..8273dd6 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -33,16 +33,13 @@ fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 }
 
 static ssize_t
-read(struct file * file, char __user * userbuf, size_t count, loff_t * off)
+read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 {
 	char *buffer = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
-	int ret;
-
-	if (count > PAGE_SIZE)
-		count = PAGE_SIZE;
+	int count = min_t(size_t, bytes, PAGE_SIZE);
 
 	if (size) {
 		if (offs > size)
@@ -51,10 +48,9 @@ read(struct file * file, char __user * userbuf, size_t count, loff_t * off)
 			count = size - offs;
 	}
 
-	ret = fill_read(dentry, buffer, offs, count);
-	if (ret < 0) 
-		return ret;
-	count = ret;
+	count = fill_read(dentry, buffer, offs, count);
+	if (count < 0)
+		return count;
 
 	if (copy_to_user(userbuf, buffer, count))
 		return -EFAULT;
@@ -78,16 +74,15 @@ flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
 	return attr->write(kobj, buffer, offset, count);
 }
 
-static ssize_t write(struct file * file, const char __user * userbuf,
-		     size_t count, loff_t * off)
+static ssize_t write(struct file *file, const char __user *userbuf,
+		     size_t bytes, loff_t *off)
 {
 	char *buffer = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
+	int count = min_t(size_t, bytes, PAGE_SIZE);
 
-	if (count > PAGE_SIZE)
-		count = PAGE_SIZE;
 	if (size) {
 		if (offs > size)
 			return 0;
-- 
1.5.0.3


