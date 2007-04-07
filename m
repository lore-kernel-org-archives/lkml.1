Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXDGIXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXDGIXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965526AbXDGIXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:23:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:60677 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965521AbXDGIXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=MrMYyloTQO2svEYx97tKDYoqWoQ0bVyavFgQe/iG0Qikb25+rMSj+ZiPABAWQ9lEaL8a8DunTL4WnzNr1Eqg37N+hLgsavAJNKSdfAAFbqmBx5/h6ww+RlIXcbqAmUFF2lVaw6fgfUzOvnfFWKOkbhwXPC/umdqJUZ0t4+CeuCA=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 02/14] sysfs: fix error handling in binattr write()
In-Reply-To: <1175934226928-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 7 Apr 2007 17:23:46 +0900
Message-Id: <11759342261477-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       htejun@gmail.com
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


