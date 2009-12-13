Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZLMX6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZLMX6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZLMX5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34175 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbZLMX5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:47 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, miklos@szeredi.hu,
       torvalds@linux-foundation.org
Subject: [PATCH 3/9] Constify struct file_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:31 +0100
Message-Id: <38cdd17089045641da3ed4ae52791ceef283dcea.1260662997.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662997.git.re.emese@gmail.com>
References: <cover.1260662997.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 fs/fuse/cuse.c   |   19 ++++++++++++-------
 fs/fuse/dev.c    |    8 ++++----
 fs/fuse/fuse_i.h |   10 ++++++++++
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index de792dc..2115e7f 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -528,7 +528,18 @@ static int cuse_channel_release(struct inode *inode, struct file *file)
 	return rc;
 }
 
-static struct file_operations cuse_channel_fops; /* initialized during init */
+static const struct file_operations cuse_channel_fops = { /* initialized during init */
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.read		= do_sync_read,
+	.aio_read	= fuse_dev_read,
+	.write		= do_sync_write,
+	.aio_write	= fuse_dev_write,
+	.poll		= fuse_dev_poll,
+	.open		= cuse_channel_open,
+	.release	= cuse_channel_release,
+	.fasync		= fuse_dev_fasync,
+};
 
 
 /**************************************************************************
@@ -575,12 +586,6 @@ static int __init cuse_init(void)
 	for (i = 0; i < CUSE_CONNTBL_LEN; i++)
 		INIT_LIST_HEAD(&cuse_conntbl[i]);
 
-	/* inherit and extend fuse_dev_operations */
-	cuse_channel_fops		= fuse_dev_operations;
-	cuse_channel_fops.owner		= THIS_MODULE;
-	cuse_channel_fops.open		= cuse_channel_open;
-	cuse_channel_fops.release	= cuse_channel_release;
-
 	cuse_class = class_create(THIS_MODULE, "cuse");
 	if (IS_ERR(cuse_class))
 		return PTR_ERR(cuse_class);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 51d9e33..03c8f95 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -745,7 +745,7 @@ __releases(&fc->lock)
  * request_end().  Otherwise add it to the processing list, and set
  * the 'sent' flag.
  */
-static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
+ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
 			      unsigned long nr_segs, loff_t pos)
 {
 	int err;
@@ -987,7 +987,7 @@ static int copy_out_args(struct fuse_copy_state *cs, struct fuse_out *out,
  * it from the list and copy the rest of the buffer to the request.
  * The request is finished by calling request_end()
  */
-static ssize_t fuse_dev_write(struct kiocb *iocb, const struct iovec *iov,
+ssize_t fuse_dev_write(struct kiocb *iocb, const struct iovec *iov,
 			       unsigned long nr_segs, loff_t pos)
 {
 	int err;
@@ -1084,7 +1084,7 @@ static ssize_t fuse_dev_write(struct kiocb *iocb, const struct iovec *iov,
 	return err;
 }
 
-static unsigned fuse_dev_poll(struct file *file, poll_table *wait)
+unsigned fuse_dev_poll(struct file *file, poll_table *wait)
 {
 	unsigned mask = POLLOUT | POLLWRNORM;
 	struct fuse_conn *fc = fuse_get_conn(file);
@@ -1210,7 +1210,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 }
 EXPORT_SYMBOL_GPL(fuse_dev_release);
 
-static int fuse_dev_fasync(int fd, struct file *file, int on)
+int fuse_dev_fasync(int fd, struct file *file, int on)
 {
 	struct fuse_conn *fc = fuse_get_conn(file);
 	if (!fc)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 01cc462..b11fe78 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -521,6 +521,16 @@ extern const struct file_operations fuse_dev_operations;
 
 extern const struct dentry_operations fuse_dentry_operations;
 
+extern ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
+			      unsigned long nr_segs, loff_t pos);
+
+extern ssize_t fuse_dev_write(struct kiocb *iocb, const struct iovec *iov,
+			       unsigned long nr_segs, loff_t pos);
+
+extern unsigned fuse_dev_poll(struct file *file, poll_table *wait);
+
+extern int fuse_dev_fasync(int fd, struct file *file, int on);
+
 /**
  * Inode to nodeid comparison.
  */
-- 
1.6.5.3

