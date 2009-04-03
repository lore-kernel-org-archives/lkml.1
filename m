Return-Path: <linux-kernel-owner+w=401wt.eu-S1762951AbZDCKfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762951AbZDCKfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761863AbZDCKf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:35:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:42759 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759663AbZDCKfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:35:25 -0400
Date: Fri, 3 Apr 2009 10:34:22 GMT
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
Subject: [tip:tracing/kmemtrace-v2] kmemtrace, fs: uninline simple_transaction_set()
Message-ID: <tip-76791ab2d5e00c1eef728a8df4347ba133760fb8@git.kernel.org>
Git-Commit-ID: 76791ab2d5e00c1eef728a8df4347ba133760fb8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:34:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76791ab2d5e00c1eef728a8df4347ba133760fb8
Gitweb:     http://git.kernel.org/tip/76791ab2d5e00c1eef728a8df4347ba133760fb8
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 25 Mar 2009 16:48:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 12:09:09 +0200

kmemtrace, fs: uninline simple_transaction_set()

Impact: cleanup

We want to remove percpu.h from rcupdate.h (for upcoming kmemtrace
changes), but this is not possible currently without breaking the
build because fs.h has an implicit include file depedency: it
uses PAGE_SIZE but does not include asm/page.h which defines it.

This problem gets masked in practice because most fs.h using sites
use rcupreempt.h (and other headers) which includes percpu.h which
brings in asm/page.h indirectly.

We cannot add asm/page.h to asm/fs.h because page.h is not an
exported header.

Move simple_transaction_set() to the other simple-transaction
file helpers in fs/libfs.c.

This removes the include file hell and also reduces
kernel size a bit.

Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: paulmck@linux.vnet.ibm.com
LKML-Reference: <1237898630.25315.83.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 fs/libfs.c         |   16 ++++++++++++++++
 include/linux/fs.h |   14 +-------------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 4910a36..cd22319 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -575,6 +575,21 @@ ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
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
@@ -820,6 +835,7 @@ EXPORT_SYMBOL(simple_sync_file);
 EXPORT_SYMBOL(simple_unlink);
 EXPORT_SYMBOL(simple_read_from_buffer);
 EXPORT_SYMBOL(memory_read_from_buffer);
+EXPORT_SYMBOL(simple_transaction_set);
 EXPORT_SYMBOL(simple_transaction_get);
 EXPORT_SYMBOL(simple_transaction_read);
 EXPORT_SYMBOL(simple_transaction_release);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fc4dc28..e4de2b5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2323,19 +2323,7 @@ ssize_t simple_transaction_read(struct file *file, char __user *buf,
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
