Return-Path: <linux-kernel-owner+w=401wt.eu-S1761054AbYF2OFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761054AbYF2OFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 10:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbYF2OEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 10:04:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:22037 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758308AbYF2OEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 10:04:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=KfjCOM3MLY45cr7C3usTkNM7Wy/qvOrqbI82QwT/4S6w03ZmdLt2OrOu4f//fq3Wn3
         N4VOSGmjTmTmX7fC7Q1IAvah83DcSvIC/9VwlKmeGrIDcrUqLmt9nCZIwjJCzBNXt2Iv
         YjPaQd3V9aoSSEFaganxGxUqKTInUMViVougI=
Date: Sun, 29 Jun 2008 16:04:46 +0200
From: Tomas Smetana <t.smetana@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fs/proc: Per thread I/O accounting
Message-ID: <20080629160446.07eef194@saiph.smetana.name>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  here's an attempt to fix the bug #10702: The /proc/#/io doesn't aggregate
I/O statistics of all the process' threads -- just the main one. The patch
fixes this and also adds /proc/#/task/#/io file for per-thread accounting
which should make I/O accounting consistent with CPU stats.

Reference: http://bugzilla.kernel.org/show_bug.cgi?id=10702

Please cc: me in the answers.


Signed-off-by: Tomas Smetana <t.smetana@gmail.com>
---
 fs/proc/base.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3b45537..5437ae3 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2377,6 +2377,51 @@ static int proc_base_fill_cache(struct file *filp, void *dirent,
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 static int proc_pid_io_accounting(struct task_struct *task, char *buffer)
 {
+#ifdef CONFIG_TASK_XACCT
+	unsigned long long rchar = 0, wchar = 0;
+	unsigned long long syscr = 0, syscw = 0;
+#endif
+	unsigned long long read_bytes = 0, write_bytes = 0;
+	unsigned long long cancelled_write_bytes = 0;
+	struct task_struct *t = task;
+
+	do {
+#ifdef CONFIG_TASK_XACCT
+		rchar += (unsigned long long)t->rchar;
+		wchar += (unsigned long long)t->wchar;
+		syscr += (unsigned long long)t->syscr;
+		syscw += (unsigned long long)t->syscw;
+#endif
+		read_bytes += (unsigned long long)t->ioac.read_bytes;
+		write_bytes += (unsigned long long)t->ioac.write_bytes;
+		cancelled_write_bytes +=
+		    (unsigned long long)t->ioac.cancelled_write_bytes;
+		t = next_thread(t);
+	} while (t != task);
+
+	return sprintf(buffer,
+#ifdef CONFIG_TASK_XACCT
+			"rchar: %llu\n"
+			"wchar: %llu\n"
+			"syscr: %llu\n"
+			"syscw: %llu\n"
+#endif
+			"read_bytes: %llu\n"
+			"write_bytes: %llu\n"
+			"cancelled_write_bytes: %llu\n",
+#ifdef CONFIG_TASK_XACCT
+			rchar,
+			wchar,
+			syscr,
+			syscw,
+#endif
+			read_bytes,
+			write_bytes,
+			cancelled_write_bytes);
+}
+
+static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
+{
 	return sprintf(buffer,
 #ifdef CONFIG_TASK_XACCT
 			"rchar: %llu\n"
@@ -2796,6 +2841,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	INF("io",	S_IRUGO, tid_io_accounting)
+#endif
 };
 
 static int proc_tid_base_readdir(struct file * filp,
-- 
1.5.4.1

