Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXHOJGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXHOJGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759347AbXHOJFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:05:55 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41688 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756674AbXHOJFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:05:54 -0400
Message-ID: <387168750.10594@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 15 Aug 2007 17:05:50 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] seqfile: merge duplite code to seq_open_private()
Message-ID: <20070815090549.GB19893@mail.ustc.edu.cn>
References: <20070815085637.GA19293@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815085637.GA19293@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are dozens of calls to seq_open() that need to set m->private.
Introduce seq_open_private() to remove code duplications.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
Andrew: more conversions will be made if this patch is ok.

 fs/nfs/client.c          |   24 ++----------------------
 fs/seq_file.c            |   10 ++++++++++
 include/linux/seq_file.h |    1 +
 3 files changed, 13 insertions(+), 22 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/include/linux/seq_file.h
+++ linux-2.6.23-rc2-mm2/include/linux/seq_file.h
@@ -33,6 +33,7 @@ struct seq_operations {
 };
 
 int seq_open(struct file *, const struct seq_operations *);
+int seq_open_private(struct file *, struct seq_operations *, void *);
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
 loff_t seq_lseek(struct file *, loff_t, int);
 int seq_release(struct inode *, struct file *);
--- linux-2.6.23-rc2-mm2.orig/fs/seq_file.c
+++ linux-2.6.23-rc2-mm2/fs/seq_file.c
@@ -53,6 +53,16 @@ int seq_open(struct file *file, const st
 }
 EXPORT_SYMBOL(seq_open);
 
+int seq_open_private(struct file *file, struct seq_operations *op, void *data)
+{
+	int ret = seq_open(file, op);
+
+	if (!ret)
+		((struct seq_file *)file->private_data)->private = data;
+
+	return ret;
+}
+EXPORT_SYMBOL(seq_open_private);
 /**
  *	seq_read -	->read() method for sequential files.
  *	@file: the file to read from
--- linux-2.6.23-rc2-mm2.orig/fs/nfs/client.c
+++ linux-2.6.23-rc2-mm2/fs/nfs/client.c
@@ -1188,17 +1188,7 @@ static const struct file_operations nfs_
  */
 static int nfs_server_list_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *m;
-	int ret;
-
-	ret = seq_open(file, &nfs_server_list_ops);
-	if (ret < 0)
-		return ret;
-
-	m = file->private_data;
-	m->private = PDE(inode)->data;
-
-	return 0;
+	return seq_open_private(file, &nfs_server_list_ops, PDE(inode)->data);
 }
 
 /*
@@ -1258,17 +1248,7 @@ static int nfs_server_list_show(struct s
  */
 static int nfs_volume_list_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *m;
-	int ret;
-
-	ret = seq_open(file, &nfs_volume_list_ops);
-	if (ret < 0)
-		return ret;
-
-	m = file->private_data;
-	m->private = PDE(inode)->data;
-
-	return 0;
+	return seq_open_private(file, &nfs_volume_list_ops, PDE(inode)->data);
 }
 
 /*

