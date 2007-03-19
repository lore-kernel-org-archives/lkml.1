Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbXCSKjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbXCSKjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbXCSKjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:39:45 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:43311 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbXCSKjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:39:44 -0400
Content-Disposition: inline
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH, take2] getrusage() : Fill ru_inblock and ru_oublock fields if possible
Date: Mon, 19 Mar 2007 11:39:40 +0100
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200703191139.40281.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

Here is the new version of this patch. Could you please update mm with it ?

As noticed by Oleg, first version was wrong, reporting three times SELF
values, and no support for RUSAGE_CHILDREN.

RUSAGE_CHILDREN support imply we add cinblock and  coublock in signal_struct,
to be able to accumulate inblock/oublock of  terminated and waited-for
children.

Thank you

[PATCH, take2] getrusage() : Fill ru_inblock and ru_oublock fields if possible

If CONFIG_TASK_IO_ACCOUNTING is defined, we update io accounting counters for
each task.

This patch permits reporting of these values using the well known getrusage()
syscall, filling ru_inblock and ru_oublock instead of null values.

For RUSAGE_CHILDREN support, we must add two new fields in struct
signal_struct, named cinblock and coublock, where we sum the inblock/oublock
values of terminated and waited-for children.

As TASK_IO_ACCOUNTING currently counts bytes, we approximate blocks
count doing : nr_blocks = nr_bytes / 512

Example of use :
----------------------
After patch is applied, /usr/bin/time command can now give a good
approximation of IO that the process (and its children) had to do.

$ /usr/bin/time dd if=/dev/zero of=/tmp/testfile count=1000
1000+0 records in
1000+0 records out
512000 bytes (512 kB) copied, 0.0033976 seconds, 151 MB/s
0.00user 0.00system 0:00.00elapsed 100%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+1000outputs (0major+235minor)pagefaults 0swaps

# /usr/bin/time updatedb
1.63user 6.38system 4:21.42elapsed 3%CPU (0avgtext+0avgdata 0maxresident)k
878112inputs+22448outputs (2major+1148minor)pagefaults 0swaps

# ls -s --block-size=512 /var/lib/slocate/slocate.db
22472 /var/lib/slocate/slocate.db

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/sched.h                  |    1 
 include/linux/task_io_accounting_ops.h |   44 +++++++++++++++++++++++
 kernel/exit.c                          |    8 ++++
 kernel/fork.c                          |    1 
 kernel/sys.c                           |    7 +++
 5 files changed, 61 insertions(+)

--- linux-2.6.21-rc4/include/linux/sched.h
+++ linux-2.6.21-rc4-ed/include/linux/sched.h
@@ -457,6 +457,7 @@ struct signal_struct {
 	cputime_t utime, stime, cutime, cstime;
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
+	unsigned long cinblock, coublock;
 
 	/*
 	 * Cumulative ns of scheduled CPU time for dead threads in the
--- linux-2.6.21-rc4/include/linux/task_io_accounting_ops.h
+++ linux-2.6.21-rc4-ed/include/linux/task_io_accounting_ops.h
@@ -10,11 +10,29 @@ static inline void task_io_account_read(
 	current->ioac.read_bytes += bytes;
 }
 
+/*
+ * We approximate number of blocks, because we account bytes only.
+ * A 'block' is 512 bytes
+ */
+static inline unsigned long task_io_get_inblock(const struct task_struct *p)
+{
+	return p->ioac.read_bytes >> 9;
+}
+
 static inline void task_io_account_write(size_t bytes)
 {
 	current->ioac.write_bytes += bytes;
 }
 
+/*
+ * We approximate number of blocks, because we account bytes only.
+ * A 'block' is 512 bytes
+ */
+static inline unsigned long task_io_get_oublock(const struct task_struct *p)
+{
+	return p->ioac.write_bytes >> 9;
+}
+
 static inline void task_io_account_cancelled_write(size_t bytes)
 {
 	current->ioac.cancelled_write_bytes += bytes;
@@ -25,16 +43,38 @@ static inline void task_io_accounting_in
 	memset(&tsk->ioac, 0, sizeof(tsk->ioac));
 }
 
+/*
+ * task_io_account_transfert() is called from __exit_signal()
+ * to be able to provide correct ru_inblock/ru_oublock in struct rusage
+ * This is why we take into account read_bytes and write_bytes only.
+ */
+static inline void task_io_account_transfert(struct task_struct *to,
+	const struct task_struct *from)
+{
+	to->ioac.read_bytes += from->ioac.read_bytes;
+	to->ioac.write_bytes += from->ioac.write_bytes;
+}
+
 #else
 
 static inline void task_io_account_read(size_t bytes)
 {
 }
 
+static inline unsigned long task_io_get_inblock(const struct task_struct *p)
+{
+	return 0;
+}
+
 static inline void task_io_account_write(size_t bytes)
 {
 }
 
+static inline unsigned long task_io_get_oublock(const struct task_struct *p)
+{
+	return 0;
+}
+
 static inline void task_io_account_cancelled_write(size_t bytes)
 {
 }
@@ -43,5 +83,9 @@ static inline void task_io_accounting_in
 {
 }
 
+static inline void task_io_account_transfert(struct task_struct *to,
+	const struct task_struct *from)
+{
+}
 #endif		/* CONFIG_TASK_IO_ACCOUNTING */
 #endif		/* __TASK_IO_ACCOUNTING_OPS_INCLUDED */
--- linux-2.6.21-rc4/kernel/sys.c
+++ linux-2.6.21-rc4-ed/kernel/sys.c
@@ -29,6 +29,7 @@
 #include <linux/signal.h>
 #include <linux/cn_proc.h>
 #include <linux/getcpu.h>
+#include <linux/task_io_accounting_ops.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -2021,6 +2022,8 @@ static void k_getrusage(struct task_stru
 			r->ru_nivcsw = p->signal->cnivcsw;
 			r->ru_minflt = p->signal->cmin_flt;
 			r->ru_majflt = p->signal->cmaj_flt;
+			r->ru_inblock = p->signal->cinblock;
+			r->ru_oublock = p->signal->coublock;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
@@ -2032,6 +2035,8 @@ static void k_getrusage(struct task_stru
 			r->ru_nivcsw += p->signal->nivcsw;
 			r->ru_minflt += p->signal->min_flt;
 			r->ru_majflt += p->signal->maj_flt;
+			r->ru_inblock += task_io_get_inblock(p->signal);
+			r->ru_oublock += task_io_get_oublock(p->signal);
 			t = p;
 			do {
 				utime = cputime_add(utime, t->utime);
@@ -2040,6 +2045,8 @@ static void k_getrusage(struct task_stru
 				r->ru_nivcsw += t->nivcsw;
 				r->ru_minflt += t->min_flt;
 				r->ru_majflt += t->maj_flt;
+				r->ru_inblock += task_io_get_inblock(t);
+				r->ru_oublock += task_io_get_oublock(t);
 				t = next_thread(t);
 			} while (t != p);
 			break;
--- linux-2.6.21-rc4/kernel/fork.c
+++ linux-2.6.21-rc4-ed/kernel/fork.c
@@ -874,6 +874,7 @@ static inline int copy_signal(unsigned l
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
+	sig->cinblock = sig->coublock = 0;
 	sig->sched_time = 0;
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
--- linux-2.6.21-rc4/kernel/exit.c
+++ linux-2.6.21-rc4-ed/kernel/exit.c
@@ -42,6 +42,7 @@
 #include <linux/audit.h> /* for audit_free() */
 #include <linux/resource.h>
 #include <linux/blkdev.h>
+#include <linux/task_io_accounting_ops.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -113,6 +114,7 @@ static void __exit_signal(struct task_st
 		sig->nvcsw += tsk->nvcsw;
 		sig->nivcsw += tsk->nivcsw;
 		sig->sched_time += tsk->sched_time;
+		task_io_account_transfert(sig, tsk);
 		sig = NULL; /* Marker for below. */
 	}
 
@@ -1191,6 +1193,12 @@ static int wait_task_zombie(struct task_
 			p->nvcsw + sig->nvcsw + sig->cnvcsw;
 		psig->cnivcsw +=
 			p->nivcsw + sig->nivcsw + sig->cnivcsw;
+		psig->cinblock +=
+			task_io_get_inblock(p) +
+			task_io_get_inblock(sig) + sig->cinblock;
+		psig->coublock +=
+			task_io_get_oublock(p) +
+			task_io_get_oublock(sig) + sig->coublock;
 		spin_unlock_irq(&p->parent->sighand->siglock);
 	}
 
