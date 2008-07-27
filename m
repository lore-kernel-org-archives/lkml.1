Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbYG0Ws1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbYG0Ws1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 18:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbYG0WsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 18:48:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:36333 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbYG0WsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 18:48:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DEBcB5OvP3Op0D/Dn2Gd7MtUlwc+gvvwww+GR5lY4y3rKPajfkJpU+TrzCI2KtpHWR
         svlAYG0jCoQLuqaCEE4j+HoITd4qUzrjlLTfJeHlhBF/QWPbN5sdCY9UtdyhLuIOx3X9
         QvWH3/FaQc92DiKERr3v0e/eV14YhPqTBvrbg=
From: Andrea Righi <righi.andrea@gmail.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, matt@bluehost.com,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 1/1] task IO accounting: move all IO statistics in struct task_io_accounting
Date: Mon, 28 Jul 2008 00:48:12 +0200
Message-Id: <1217198892-10159-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the code of include/linux/task_io_accounting.h.

It is also more reasonable to have all the task i/o-related statistics in a
single struct (task_io_accounting).

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
---
 fs/proc/base.c                         |   10 +++---
 include/linux/sched.h                  |   12 ++++----
 include/linux/task_io_accounting.h     |   17 +----------
 include/linux/task_io_accounting_ops.h |   48 ++++++++++++++++----------------
 kernel/tsacct.c                        |   14 ++++----
 5 files changed, 44 insertions(+), 57 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3d94906..01ed610 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2403,7 +2403,7 @@ static int proc_base_fill_cache(struct file *filp, void *dirent,
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 {
-	struct proc_io_accounting acct = task->ioac;
+	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
 
 	if (whole && lock_task_sighand(task, &flags)) {
@@ -2423,10 +2423,10 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
 			"cancelled_write_bytes: %llu\n",
-			acct.chr.rchar, acct.chr.wchar,
-			acct.chr.syscr, acct.chr.syscw,
-			acct.blk.read_bytes, acct.blk.write_bytes,
-			acct.blk.cancelled_write_bytes);
+			acct.rchar, acct.wchar,
+			acct.syscr, acct.syscw,
+			acct.read_bytes, acct.write_bytes,
+			acct.cancelled_write_bytes);
 }
 
 static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 034c1ca..5270d44 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -505,7 +505,7 @@ struct signal_struct {
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
-	struct proc_io_accounting ioac;
+	struct task_io_accounting ioac;
 
 	/*
 	 * Cumulative ns of scheduled CPU time for dead threads in the
@@ -1253,7 +1253,7 @@ struct task_struct {
 
 	unsigned long ptrace_message;
 	siginfo_t *last_siginfo; /* For ptrace use.  */
-	struct proc_io_accounting ioac;
+	struct task_io_accounting ioac;
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
 	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
@@ -2183,22 +2183,22 @@ extern long sched_group_rt_period(struct task_group *tg);
 #ifdef CONFIG_TASK_XACCT
 static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
 {
-	tsk->ioac.chr.rchar += amt;
+	tsk->ioac.rchar += amt;
 }
 
 static inline void add_wchar(struct task_struct *tsk, ssize_t amt)
 {
-	tsk->ioac.chr.wchar += amt;
+	tsk->ioac.wchar += amt;
 }
 
 static inline void inc_syscr(struct task_struct *tsk)
 {
-	tsk->ioac.chr.syscr++;
+	tsk->ioac.syscr++;
 }
 
 static inline void inc_syscw(struct task_struct *tsk)
 {
-	tsk->ioac.chr.syscw++;
+	tsk->ioac.syscw++;
 }
 #else
 static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
diff --git a/include/linux/task_io_accounting.h b/include/linux/task_io_accounting.h
index 165390f..5e88afc 100644
--- a/include/linux/task_io_accounting.h
+++ b/include/linux/task_io_accounting.h
@@ -1,5 +1,5 @@
 /*
- * proc_io_accounting: a structure which is used for recording a single task's
+ * task_io_accounting: a structure which is used for recording a single task's
  * IO statistics.
  *
  * Don't include this header file directly - it is designed to be dragged in via
@@ -8,8 +8,8 @@
  * Blame akpm@osdl.org for all this.
  */
 
+struct task_io_accounting {
 #ifdef CONFIG_TASK_XACCT
-struct task_chr_io_accounting {
 	/* bytes read */
 	u64 rchar;
 	/*  bytes written */
@@ -18,14 +18,9 @@ struct task_chr_io_accounting {
 	u64 syscr;
 	/* # of write syscalls */
 	u64 syscw;
-};
-#else /* CONFIG_TASK_XACCT */
-struct task_chr_io_accounting {
-};
 #endif /* CONFIG_TASK_XACCT */
 
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-struct task_io_accounting {
 	/*
 	 * The number of bytes which this task has caused to be read from
 	 * storage.
@@ -46,13 +41,5 @@ struct task_io_accounting {
 	 * information loss in doing that.
 	 */
 	u64 cancelled_write_bytes;
-};
-#else /* CONFIG_TASK_IO_ACCOUNTING */
-struct task_io_accounting {
-};
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
-
-struct proc_io_accounting {
-	struct task_chr_io_accounting chr;
-	struct task_io_accounting blk;
 };
diff --git a/include/linux/task_io_accounting_ops.h b/include/linux/task_io_accounting_ops.h
index e6f958e..4d090f9 100644
--- a/include/linux/task_io_accounting_ops.h
+++ b/include/linux/task_io_accounting_ops.h
@@ -9,7 +9,7 @@
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 static inline void task_io_account_read(size_t bytes)
 {
-	current->ioac.blk.read_bytes += bytes;
+	current->ioac.read_bytes += bytes;
 }
 
 /*
@@ -18,12 +18,12 @@ static inline void task_io_account_read(size_t bytes)
  */
 static inline unsigned long task_io_get_inblock(const struct task_struct *p)
 {
-	return p->ioac.blk.read_bytes >> 9;
+	return p->ioac.read_bytes >> 9;
 }
 
 static inline void task_io_account_write(size_t bytes)
 {
-	current->ioac.blk.write_bytes += bytes;
+	current->ioac.write_bytes += bytes;
 }
 
 /*
@@ -32,25 +32,25 @@ static inline void task_io_account_write(size_t bytes)
  */
 static inline unsigned long task_io_get_oublock(const struct task_struct *p)
 {
-	return p->ioac.blk.write_bytes >> 9;
+	return p->ioac.write_bytes >> 9;
 }
 
 static inline void task_io_account_cancelled_write(size_t bytes)
 {
-	current->ioac.blk.cancelled_write_bytes += bytes;
+	current->ioac.cancelled_write_bytes += bytes;
 }
 
-static inline void task_io_accounting_init(struct proc_io_accounting *ioac)
+static inline void task_io_accounting_init(struct task_io_accounting *ioac)
 {
 	memset(ioac, 0, sizeof(*ioac));
 }
 
-static inline void task_blk_io_accounting_add(struct proc_io_accounting *dst,
-						struct proc_io_accounting *src)
+static inline void task_blk_io_accounting_add(struct task_io_accounting *dst,
+						struct task_io_accounting *src)
 {
-	dst->blk.read_bytes += src->blk.read_bytes;
-	dst->blk.write_bytes += src->blk.write_bytes;
-	dst->blk.cancelled_write_bytes += src->blk.cancelled_write_bytes;
+	dst->read_bytes += src->read_bytes;
+	dst->write_bytes += src->write_bytes;
+	dst->cancelled_write_bytes += src->cancelled_write_bytes;
 }
 
 #else
@@ -77,35 +77,35 @@ static inline void task_io_account_cancelled_write(size_t bytes)
 {
 }
 
-static inline void task_io_accounting_init(struct proc_io_accounting *ioac)
+static inline void task_io_accounting_init(struct task_io_accounting *ioac)
 {
 }
 
-static inline void task_blk_io_accounting_add(struct proc_io_accounting *dst,
-						struct proc_io_accounting *src)
+static inline void task_blk_io_accounting_add(struct task_io_accounting *dst,
+						struct task_io_accounting *src)
 {
 }
 
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
 
 #ifdef CONFIG_TASK_XACCT
-static inline void task_chr_io_accounting_add(struct proc_io_accounting *dst,
-						struct proc_io_accounting *src)
+static inline void task_chr_io_accounting_add(struct task_io_accounting *dst,
+						struct task_io_accounting *src)
 {
-	dst->chr.rchar += src->chr.rchar;
-	dst->chr.wchar += src->chr.wchar;
-	dst->chr.syscr += src->chr.syscr;
-	dst->chr.syscw += src->chr.syscw;
+	dst->rchar += src->rchar;
+	dst->wchar += src->wchar;
+	dst->syscr += src->syscr;
+	dst->syscw += src->syscw;
 }
 #else
-static inline void task_chr_io_accounting_add(struct proc_io_accounting *dst,
-						struct proc_io_accounting *src)
+static inline void task_chr_io_accounting_add(struct task_io_accounting *dst,
+						struct task_io_accounting *src)
 {
 }
 #endif /* CONFIG_TASK_XACCT */
 
-static inline void task_io_accounting_add(struct proc_io_accounting *dst,
-						struct proc_io_accounting *src)
+static inline void task_io_accounting_add(struct task_io_accounting *dst,
+						struct task_io_accounting *src)
 {
 	task_chr_io_accounting_add(dst, src);
 	task_blk_io_accounting_add(dst, src);
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index f9cd256..8ebcd85 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -94,14 +94,14 @@ void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
 		mmput(mm);
 	}
-	stats->read_char	= p->ioac.chr.rchar;
-	stats->write_char	= p->ioac.chr.wchar;
-	stats->read_syscalls	= p->ioac.chr.syscr;
-	stats->write_syscalls	= p->ioac.chr.syscw;
+	stats->read_char	= p->ioac.rchar;
+	stats->write_char	= p->ioac.wchar;
+	stats->read_syscalls	= p->ioac.syscr;
+	stats->write_syscalls	= p->ioac.syscw;
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	stats->read_bytes	= p->ioac.blk.read_bytes;
-	stats->write_bytes	= p->ioac.blk.write_bytes;
-	stats->cancelled_write_bytes = p->ioac.blk.cancelled_write_bytes;
+	stats->read_bytes	= p->ioac.read_bytes;
+	stats->write_bytes	= p->ioac.write_bytes;
+	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
 #else
 	stats->read_bytes	= 0;
 	stats->write_bytes	= 0;
-- 
1.5.4.3

