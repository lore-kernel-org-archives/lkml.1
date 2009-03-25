Return-Path: <linux-kernel-owner+w=401wt.eu-S1761044AbZCYQw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044AbZCYQw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbZCYQw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:52:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:53721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260AbZCYQwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:52:24 -0400
Date: Wed, 25 Mar 2009 16:51:28 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro,
       viro@zeniv.linux.org.uk, tglx@linutronix.de, mingo@elte.hu,
       adobriyan@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro,
       viro@zeniv.linux.org.uk, tglx@linutronix.de, mingo@elte.hu,
       adobriyan@gmail.com
In-Reply-To: <1237898630.25315.83.camel@penberg-laptop>
References: <1237898630.25315.83.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace] fs.h: uninline simple_transaction_set()
Message-ID: <tip-44eea45ca9e25d6dd660d4806ef4c11209609e03@git.kernel.org>
Git-Commit-ID: 44eea45ca9e25d6dd660d4806ef4c11209609e03
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 16:51:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44eea45ca9e25d6dd660d4806ef4c11209609e03
Gitweb:     http://git.kernel.org/tip/44eea45ca9e25d6dd660d4806ef4c11209609e03
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 25 Mar 2009 16:48:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 17:48:14 +0100

fs.h: uninline simple_transaction_set()

Move simple_transaction_set() to the other simple-transaction
file helpers in fs/libfs.c.

This removes an implicit asm/page.h PAGE_SIZE dependency from
fs.h (asm/page.h is not an exported header so HEADERS_CHECK fils),
and also reduces kernel size a bit.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: paulmck@linux.vnet.ibm.com
LKML-Reference: <1237898630.25315.83.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 fs/libfs.c         |   15 +++++++++++++++
 include/linux/fs.h |   16 +---------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 49b4409..a1db380 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -574,6 +574,21 @@ ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
  * possibly a read which collects the result - which is stored in a
  * file-local buffer.
  */
+
+void simple_transaction_set(struct file *file, size_t n)
+{
+	struct simple_transaction_argresp *ar = file->private_data;
+
+	BUG_ON(n > SIMPLE_TRANSACTION_LIMIT);
+
+	/*
+	 * The barrier ensures that ar->size will really remain zero until
+	 * ar->data is ready for reading.
+	 */
+	smp_mb();
+	ar->size = n;
+}
+
 char *simple_transaction_get(struct file *file, const char __user *buf, size_t size)
 {
 	struct simple_transaction_argresp *ar;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 79be937..2ebe3ce 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -9,8 +9,6 @@
 #include <linux/limits.h>
 #include <linux/ioctl.h>
 
-#include <asm/page.h> /* for PAGE_SIZE */
-
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
  * the file limit at runtime and only root can increase the per-process
@@ -2173,19 +2171,7 @@ ssize_t simple_transaction_read(struct file *file, char __user *buf,
 				size_t size, loff_t *pos);
 int simple_transaction_release(struct inode *inode, struct file *file);
 
-static inline void simple_transaction_set(struct file *file, size_t n)
-{
-	struct simple_transaction_argresp *ar = file->private_data;
-
-	BUG_ON(n > SIMPLE_TRANSACTION_LIMIT);
-
-	/*
-	 * The barrier ensures that ar->size will really remain zero until
-	 * ar->data is ready for reading.
-	 */
-	smp_mb();
-	ar->size = n;
-}
+void simple_transaction_set(struct file *file, size_t n);
 
 /*
  * simple attribute files
