Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbXD1Npe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbXD1Npe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbXD1Nke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:45359 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbXD1Njv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:39:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=D54fdZ+fTTRXMfoAvSijHXr+Nyjn6CTHibuEqurVWmaKM9/sCNOAoufddv8uzUo3Y1yUZkDhaBkR2Ox9Azru5ZHDXkigSSjYhMFM0jmsV27t/kRn9+tQked/5jekOontw3tr+I8ZXGThlt+CvUV9dEzERfi7RlkD2RezAoti+Ks=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 07/21] sysfs: fix error handling in binattr write()
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:40 +0900
Message-Id: <11777675801406-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
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
index 8ea2a51..606267a 100644
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


