Return-Path: <linux-kernel-owner+w=401wt.eu-S1751419AbXA3VL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbXA3VL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXA3VL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:11:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:2945 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXA3VLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=TS0lyhRpRNVTWVc5+myo/kleF35ot28FuW5SSbCuVj3yPpmC6pM1wWHvy4sG0A8cdfne1gFECDCU5D/zrNbLEKBH1sVOP7EiNjsfZT23xlK9kzyKyrdq4EiRCoKXdINWsSUZtBcXVVA3i/MPrUBRSPeKWGql9DBqPkgxJR8kFv8=
Date: Wed, 31 Jan 2007 00:11:43 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ifdef ->rchar, ->wchar, ->syscr, ->syscw from task_struct
Message-ID: <20070130211143.GB5533@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

They are fat: 4x8 bytes in task_struct.
They are uncoditionally updated in every fork, read, write and sendfile.
They are used only if you have some "extended acct fields feature".

And please, please, please, read(2) knows about bytes, not characters,
why it is called "rchar"?

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c        |    4 ++++
 fs/read_write.c       |   24 ++++++++++++------------
 include/linux/sched.h |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c         |    2 ++
 4 files changed, 58 insertions(+), 12 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1810,17 +1810,21 @@ #ifdef CONFIG_TASK_IO_ACCOUNTING
 static int proc_pid_io_accounting(struct task_struct *task, char *buffer)
 {
 	return sprintf(buffer,
+#ifdef CONFIG_TASK_XACCT
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
 			"syscw: %llu\n"
+#endif
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
 			"cancelled_write_bytes: %llu\n",
+#ifdef CONFIG_TASK_XACCT
 			(unsigned long long)task->rchar,
 			(unsigned long long)task->wchar,
 			(unsigned long long)task->syscr,
 			(unsigned long long)task->syscw,
+#endif
 			(unsigned long long)task->ioac.read_bytes,
 			(unsigned long long)task->ioac.write_bytes,
 			(unsigned long long)task->ioac.cancelled_write_bytes);
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -274,9 +274,9 @@ ssize_t vfs_read(struct file *file, char
 				ret = do_sync_read(file, buf, count, pos);
 			if (ret > 0) {
 				fsnotify_access(file->f_path.dentry);
-				current->rchar += ret;
+				add_rchar(current, ret);
 			}
-			current->syscr++;
+			inc_syscr(current);
 		}
 	}
 
@@ -332,9 +332,9 @@ ssize_t vfs_write(struct file *file, con
 				ret = do_sync_write(file, buf, count, pos);
 			if (ret > 0) {
 				fsnotify_modify(file->f_path.dentry);
-				current->wchar += ret;
+				add_wchar(current, ret);
 			}
-			current->syscw++;
+			inc_syscw(current);
 		}
 	}
 
@@ -675,8 +675,8 @@ sys_readv(unsigned long fd, const struct
 	}
 
 	if (ret > 0)
-		current->rchar += ret;
-	current->syscr++;
+		add_rchar(current, ret);
+	inc_syscr(current);
 	return ret;
 }
 
@@ -696,8 +696,8 @@ sys_writev(unsigned long fd, const struc
 	}
 
 	if (ret > 0)
-		current->wchar += ret;
-	current->syscw++;
+		add_wchar(current, ret);
+	inc_syscw(current);
 	return ret;
 }
 
@@ -779,12 +779,12 @@ static ssize_t do_sendfile(int out_fd, i
 	retval = in_file->f_op->sendfile(in_file, ppos, count, file_send_actor, out_file);
 
 	if (retval > 0) {
-		current->rchar += retval;
-		current->wchar += retval;
+		add_rchar(current, retval);
+		add_wchar(current, retval);
 	}
-	current->syscr++;
-	current->syscw++;
 
+	inc_syscr(current);
+	inc_syscw(current);
 	if (*ppos > max)
 		retval = -EOVERFLOW;
 
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1013,8 +1013,10 @@ #endif
  * to a stack based synchronous wait) if its doing sync IO.
  */
 	wait_queue_t *io_wait;
+#ifdef CONFIG_TASK_XACCT
 /* i/o counters(bytes read/written, #syscalls */
 	u64 rchar, wchar, syscr, syscw;
+#endif
 	struct task_io_accounting ioac;
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
@@ -1649,6 +1651,44 @@ extern int sched_create_sysfs_power_savi
 
 extern void normalize_rt_tasks(void);
 
+#ifdef CONFIG_TASK_XACCT
+static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
+{
+	tsk->rchar += amt;
+}
+
+static inline void add_wchar(struct task_struct *tsk, ssize_t amt)
+{
+	tsk->wchar += amt;
+}
+
+static inline void inc_syscr(struct task_struct *tsk)
+{
+	tsk->syscr++;
+}
+
+static inline void inc_syscw(struct task_struct *tsk)
+{
+	tsk->syscw++;
+}
+#else
+static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
+{
+}
+
+static inline void add_wchar(struct task_struct *tsk, ssize_t amt)
+{
+}
+
+static inline void inc_syscr(struct task_struct *tsk)
+{
+}
+
+static inline void inc_syscw(struct task_struct *tsk)
+{
+}
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1038,10 +1038,12 @@ #endif
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
  	p->sched_time = 0;
+#ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */
 	p->wchar = 0;		/* I/O counter: bytes written */
 	p->syscr = 0;		/* I/O counter: read syscalls */
 	p->syscw = 0;		/* I/O counter: write syscalls */
+#endif
 	task_io_accounting_init(p);
 	acct_clear_integrals(p);
 

