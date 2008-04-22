Return-Path: <linux-kernel-owner+w=401wt.eu-S1763682AbYDVTMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763682AbYDVTMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYDVTMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:12:39 -0400
Received: from mx1.hqhost.net ([88.214.192.192]:38792 "EHLO mail.hqhost.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754211AbYDVTMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:12:38 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2008 15:12:38 EDT
Date: Tue, 22 Apr 2008 22:05:13 +0300
From: Sergey Kononenko <sergk@sergk.org.ua>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] BSD acct: disk I/O accounting
Message-ID: <20080422220513.1e5f2736@vingilot.sergknet>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch make acct use I/O statistics gathered when
TASK_IO_ACCOUNTING is enabled. getrusage() already uses that statistics,
but also will be helpful to get access to disk I/O statistics through
traditional BSD accounting interface, because many userspace scripts
that process such information not yet adapted to new taskstats API.
Patch against 2.6.25.

Signed-off-by: Sergey Kononenko <sergk@sergk.org.ua>
---

diff -uprN a/include/linux/task_io_accounting_ops.h b/include/linux/task_io_accounting_ops.h
--- a/include/linux/task_io_accounting_ops.h	2008-04-17 02:49:44.000000000 +0000
+++ b/include/linux/task_io_accounting_ops.h	2008-04-22 16:42:17.000000000 +0000
@@ -21,6 +21,11 @@ static inline unsigned long task_io_get_
 	return p->ioac.read_bytes >> 9;
 }
 
+static inline unsigned long task_io_get_inbytes(const struct task_struct *p)
+{
+	return p->ioac.read_bytes;
+}
+
 static inline void task_io_account_write(size_t bytes)
 {
 	current->ioac.write_bytes += bytes;
@@ -35,6 +40,11 @@ static inline unsigned long task_io_get_
 	return p->ioac.write_bytes >> 9;
 }
 
+static inline unsigned long task_io_get_oubytes(const struct task_struct *p)
+{
+	return p->ioac.write_bytes;
+}
+
 static inline void task_io_account_cancelled_write(size_t bytes)
 {
 	current->ioac.cancelled_write_bytes += bytes;
@@ -56,6 +66,11 @@ static inline unsigned long task_io_get_
 	return 0;
 }
 
+static inline unsigned long task_io_get_inbytes(const struct task_struct *p)
+{
+	return 0;
+}
+
 static inline void task_io_account_write(size_t bytes)
 {
 }
@@ -65,6 +80,11 @@ static inline unsigned long task_io_get_
 	return 0;
 }
 
+static inline unsigned long task_io_get_oubytes(const struct task_struct *p)
+{
+	return 0;
+}
+
 static inline void task_io_account_cancelled_write(size_t bytes)
 {
 }
diff -uprN a/kernel/acct.c b/kernel/acct.c
--- a/kernel/acct.c	2008-04-17 02:49:44.000000000 +0000
+++ b/kernel/acct.c	2008-04-22 16:42:17.000000000 +0000
@@ -55,6 +55,7 @@
 #include <linux/times.h>
 #include <linux/syscalls.h>
 #include <linux/mount.h>
+#include <linux/task_io_accounting_ops.h>
 #include <asm/uaccess.h>
 #include <asm/div64.h>
 #include <linux/blkdev.h> /* sector_div */
@@ -504,8 +505,8 @@ static void do_acct_process(struct pid_n
 	ac.ac_majflt = encode_comp_t(pacct->ac_majflt);
 	ac.ac_exitcode = pacct->ac_exitcode;
 	spin_unlock_irq(&current->sighand->siglock);
-	ac.ac_io = encode_comp_t(0 /* current->io_usage */);	/* %% */
-	ac.ac_rw = encode_comp_t(ac.ac_io / 1024);
+	ac.ac_io = encode_comp_t(task_io_get_inbytes(current) + task_io_get_oubytes(current));
+	ac.ac_rw = encode_comp_t(task_io_get_inblock(current) + task_io_get_oublock(current));
 	ac.ac_swaps = encode_comp_t(0);
 
 	/*
