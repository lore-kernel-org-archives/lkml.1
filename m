Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab0BRTJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:09:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:59377 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0BRTJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:09:21 -0500
Message-ID: <4B7D9049.6040002@windriver.com>
Date: Thu, 18 Feb 2010 13:08:57 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, mort@sgi.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH 08/28] kdb: core for kgdb back end (2 of 2)
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com><1266014143-29444-9-git-send-email-jason.wessel@windriver.com><m1zl37xhmm.fsf@fess.ebiederm.org> <4B7D5704.6060504@windriver.com> <m1fx4ywlgr.fsf@fess.ebiederm.org> <4B7D7386.4040503@windriver.com>
In-Reply-To: <4B7D7386.4040503@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2010 19:08:52.0845 (UTC) FILETIME=[CF6F69D0:01CAB0CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> I'll post a new version of the patch with the hooks you asked about
> stripped out.  The commands will also get removed from the kdb command
> shell.


Thanks for your comments Eric.

The summary of the clean up is as follows because some of the kdb core
had to be touched in order to properly remove this.

 fs/proc/internal.h             |    4 +-
 fs/proc/meminfo.c              |   15 +--------
 fs/proc/mmu.c                  |    8 +----
 include/linux/swap.h           |    2 -
 kernel/debug/kdb/kdb_main.c    |   13 +++-----
 kernel/debug/kdb/kdb_private.h |   12 -------
 kernel/debug/kdb/kdb_support.c |   65 -----------------------------------------
 mm/swapfile.c                  |   10 +-----
 8 files changed, 15 insertions(+), 114 deletions(-)



Below is the new version of the basic kernel core kdb modifications.
If you have further comments, please let me know.  I would also be
happy to add an ack if you approve of the new patch.

Thanks,
Jason.

---

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] kdb: core for kgdb back end (2 of 2)

This patch contains the hooks and instrumentation into kernel which
live outside the kernel/debug directory, which the kdb core
will call to run commands like lsmod, dmesg, bt etc...

CC: mort@sgi.com
CC: linux-arch@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/arm/include/asm/kmap_types.h     |    1 
 arch/powerpc/include/asm/kmap_types.h |    1 
 include/asm-generic/kmap_types.h      |    3 +-
 init/main.c                           |    2 +
 kernel/kallsyms.c                     |   21 +++++++++++++++++
 kernel/module.c                       |    4 +++
 kernel/printk.c                       |   16 +++++++++++++
 kernel/sched.c                        |    7 ++++-
 kernel/signal.c                       |   40 ++++++++++++++++++++++++++++++++++
 9 files changed, 92 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/kmap_types.h
+++ b/arch/arm/include/asm/kmap_types.h
@@ -19,6 +19,7 @@ enum km_type {
 	KM_SOFTIRQ0,
 	KM_SOFTIRQ1,
 	KM_L2_CACHE,
+	KM_KDB,
 	KM_TYPE_NR
 };
 
--- a/arch/powerpc/include/asm/kmap_types.h
+++ b/arch/powerpc/include/asm/kmap_types.h
@@ -26,6 +26,7 @@ enum km_type {
 	KM_SOFTIRQ1,
 	KM_PPC_SYNC_PAGE,
 	KM_PPC_SYNC_ICACHE,
+	KM_KDB,
 	KM_TYPE_NR
 };
 
--- a/include/asm-generic/kmap_types.h
+++ b/include/asm-generic/kmap_types.h
@@ -28,7 +28,8 @@ KMAP_D(15)	KM_UML_USERCOPY,
 KMAP_D(16)	KM_IRQ_PTE,
 KMAP_D(17)	KM_NMI,
 KMAP_D(18)	KM_NMI_PTE,
-KMAP_D(19)	KM_TYPE_NR
+KMAP_D(19)	KM_KDB,
+KMAP_D(20)	KM_TYPE_NR
 };
 
 #undef KMAP_D
--- a/init/main.c
+++ b/init/main.c
@@ -63,6 +63,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/kdb.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
 #include <linux/kmemcheck.h>
@@ -659,6 +660,7 @@ asmlinkage void __init start_kernel(void
 	key_init();
 	radix_tree_init();
 	security_init();
+	kdb_init(KDB_INIT_FULL);
 	vfs_caches_init(totalram_pages);
 	signals_init();
 	/* rootfs populating might need page-writeback */
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/seq_file.h>
 #include <linux/fs.h>
+#include <linux/kdb.h>
 #include <linux/err.h>
 #include <linux/proc_fs.h>
 #include <linux/sched.h>	/* for cond_resched */
@@ -515,6 +516,26 @@ static int kallsyms_open(struct inode *i
 	return ret;
 }
 
+#ifdef	CONFIG_KGDB_KDB
+const char *kdb_walk_kallsyms(loff_t *pos)
+{
+	static struct kallsym_iter kdb_walk_kallsyms_iter;
+	if (*pos == 0) {
+		memset(&kdb_walk_kallsyms_iter, 0,
+		       sizeof(kdb_walk_kallsyms_iter));
+		reset_iter(&kdb_walk_kallsyms_iter, 0);
+	}
+	while (1) {
+		if (!update_iter(&kdb_walk_kallsyms_iter, *pos))
+			return NULL;
+		++*pos;
+		/* Some debugging symbols have no name.  Ignore them. */
+		if (kdb_walk_kallsyms_iter.name[0])
+			return kdb_walk_kallsyms_iter.name;
+	}
+}
+#endif	/* CONFIG_KGDB_KDB */
+
 static const struct file_operations kallsyms_operations = {
 	.open = kallsyms_open,
 	.read = seq_read,
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -79,6 +79,10 @@ EXPORT_TRACEPOINT_SYMBOL(module_get);
 DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
+#ifdef CONFIG_KGDB_KDB
+struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
+#endif /* CONFIG_KGDB_KDB */
+
 
 /* Block module loading/unloading? */
 int modules_disabled = 0;
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -420,6 +420,22 @@ SYSCALL_DEFINE3(syslog, int, type, char 
 	return do_syslog(type, buf, len);
 }
 
+#ifdef	CONFIG_KGDB_KDB
+/* kdb dmesg command needs access to the syslog buffer.  do_syslog()
+ * uses locks so it cannot be used during debugging.  Just tell kdb
+ * where the start and end of the physical and logical logs are.  This
+ * is equivalent to do_syslog(3).
+ */
+void kdb_syslog_data(char *syslog_data[4])
+{
+	syslog_data[0] = log_buf;
+	syslog_data[1] = log_buf + log_buf_len;
+	syslog_data[2] = log_buf + log_end -
+		(logged_chars < log_buf_len ? logged_chars : log_buf_len);
+	syslog_data[3] = log_buf + log_end;
+}
+#endif	/* CONFIG_KGDB_KDB */
+
 /*
  * Call the console drivers on a range of log_buf
  */
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9802,9 +9802,9 @@ void normalize_rt_tasks(void)
 
 #endif /* CONFIG_MAGIC_SYSRQ */
 
-#ifdef CONFIG_IA64
+#if defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB)
 /*
- * These functions are only useful for the IA64 MCA handling.
+ * These functions are only useful for the IA64 MCA handling, or kdb.
  *
  * They can only be called when the whole system has been
  * stopped - every CPU needs to be quiescent, and no scheduling
@@ -9824,6 +9824,9 @@ struct task_struct *curr_task(int cpu)
 	return cpu_curr(cpu);
 }
 
+#endif /* defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB) */
+
+#ifdef CONFIG_IA64
 /**
  * set_curr_task - set the current task for a given cpu.
  * @cpu: the processor in question.
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2718,3 +2718,43 @@ void __init signals_init(void)
 {
 	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
 }
+
+#ifdef CONFIG_KGDB_KDB
+#include <linux/kdb.h>
+/*
+ * kdb_send_sig_info - Allows kdb to send signals without exposing
+ * signal internals.  This function checks if the required locks are
+ * available before calling the main signal code, to avoid kdb
+ * deadlocks.
+ */
+void
+kdb_send_sig_info(struct task_struct *t, struct siginfo *info)
+{
+	static struct task_struct *kdb_prev_t;
+	int sig, new_t;
+	if (!spin_trylock(&t->sighand->siglock)) {
+		kdb_printf("Can't do kill command now.\n"
+			   "The sigmask lock is held somewhere else in "
+			   "kernel, try again later\n");
+		return;
+	}
+	spin_unlock(&t->sighand->siglock);
+	new_t = kdb_prev_t != t;
+	kdb_prev_t = t;
+	if (t->state != TASK_RUNNING && new_t) {
+		kdb_printf("Process is not RUNNING, sending a signal from "
+			   "kdb risks deadlock\n"
+			   "on the run queue locks. "
+			   "The signal has _not_ been sent.\n"
+			   "Reissue the kill command if you want to risk "
+			   "the deadlock.\n");
+		return;
+	}
+	sig = info->si_signo;
+	if (send_sig_info(sig, info, t))
+		kdb_printf("Fail to deliver Signal %d to process %d.\n",
+			   sig, t->pid);
+	else
+		kdb_printf("Signal %d is sent to process %d.\n", sig, t->pid);
+}
+#endif	/* CONFIG_KGDB_KDB */
