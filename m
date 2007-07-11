Return-Path: <linux-kernel-owner+w=401wt.eu-S935647AbXGKXoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935647AbXGKXoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935061AbXGKXel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934881AbXGKXej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/61] sysfs: fix error handling in binattr write()
Date: Wed, 11 Jul 2007 16:31:44 -0700
Message-Id: <1184196856662-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968512510-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Error handling in fs/sysfs/bin.c:write() was wrong because size_t
count is used to receive return value from flush_write() which is
negative on failure.

This patch updates write() such that int variable is used instead.
read() is updated the same way for consistency.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index d3b9f5f..606267a 100644
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
@@ -51,15 +48,14 @@ read(struct file * file, char __user * userbuf, size_t count, loff_t * off)
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
 
-	pr_debug("offs = %lld, *off = %lld, count = %zd\n", offs, *off, count);
+	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
 
 	*off = offs + count;
 
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
1.5.2.2

