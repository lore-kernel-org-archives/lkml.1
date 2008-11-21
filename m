Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYKUWLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYKUWLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 17:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYKUWLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 17:11:36 -0500
Received: from flusers.ccur.com ([12.192.68.2]:42135 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752668AbYKUWLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 17:11:35 -0500
Date: Fri, 21 Nov 2008 17:11:13 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] create /proc/timer-wheel-list
Message-ID: <20081121221113.GA13566@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create /proc/timer_wheel_list.

This does for the timer wheel what /proc/timer_list
does for hrtimers -- provide a way of displaying what
timers are running on what cpus, and their attributes.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.28-rc6/kernel/timer.c
===================================================================
--- 2.6.28-rc6.orig/kernel/timer.c	2008-11-21 17:02:04.000000000 -0500
+++ 2.6.28-rc6/kernel/timer.c	2008-11-21 17:04:25.000000000 -0500
@@ -36,6 +36,8 @@
 #include <linux/syscalls.h>
 #include <linux/delay.h>
 #include <linux/tick.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/kallsyms.h>
 
 #include <asm/uaccess.h>
@@ -1568,6 +1570,113 @@
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
 }
 
+#ifdef CONFIG_PROC_FS
+
+static void seq_printf_symbol(struct seq_file *m, void *symaddr, int width)
+{
+	char symname[KSYM_NAME_LEN];
+	int stat, len = m->count;
+
+	if (lookup_symbol_name((unsigned long)symaddr, symname) < 0)
+		stat = seq_printf(m, "<%p>", symaddr);
+	else
+		stat = seq_printf(m, "%s", symname);
+	if (width && stat == 0) {
+		len += (width - m->count);
+		if (len > 0)
+			seq_printf(m, "%*s", len, " ");
+	}
+}
+
+static void print_single_timer(struct seq_file *m, struct timer_list *timer)
+{
+	unsigned long base_jiffies = tbase_get_base(timer->base)->timer_jiffies;
+
+	seq_printf(m, " %p - ", (void *)(timer->expires - base_jiffies));
+	seq_printf_symbol(m, timer->function, 24);
+	seq_printf(m, " (data ");
+	seq_printf_symbol(m, (void *)(timer->data), 24);
+	seq_printf(m, ")");
+#ifdef CONFIG_TIMER_STATS
+	seq_printf(m, " from ");
+	seq_printf_symbol(m, timer->start_site, 28);
+	seq_printf(m, " %*s/%d",
+		TASK_COMM_LEN, timer->start_comm,
+		timer->start_pid);
+#endif
+	seq_printf(m, "\n");
+}
+
+static void print_timer_list(struct seq_file *m, struct list_head *head)
+{
+	struct timer_list *timer;
+	struct list_head *item;
+
+	for (item = head->next; item != head; item = item->next) {
+		timer = list_entry(item, struct timer_list, entry);
+		print_single_timer(m, timer);
+	}
+}
+
+static void print_cpu_timers(struct seq_file *m, int cpu)
+{
+	int i;
+	struct tvec_base *base = per_cpu(tvec_bases, cpu);
+
+	spin_lock_irq(&base->lock);
+	seq_printf(m, "\ncpu: %d, base jiffies: %p\n\n",
+		cpu, (void *)(base->timer_jiffies));
+
+	for (i = 0; i < TVR_SIZE; i++)
+		print_timer_list(m, base->tv1.vec + i);
+	for (i = 0; i < TVN_SIZE; i++) {
+		print_timer_list(m, base->tv2.vec + i);
+		print_timer_list(m, base->tv3.vec + i);
+		print_timer_list(m, base->tv4.vec + i);
+		print_timer_list(m, base->tv5.vec + i);
+	}
+	spin_unlock_irq(&base->lock);
+}
+
+static int timer_list_show(struct seq_file *m, void *v)
+{
+	int cpu;
+
+	seq_printf(m, "Timer Wheel List Version: 1\n");
+	seq_printf(m, "Jiffies: %px\n", (void *)jiffies);
+
+	for_each_online_cpu(cpu) {
+		print_cpu_timers(m, cpu);
+	}
+
+	return 0;
+}
+
+static int timer_list_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, timer_list_show, NULL);
+}
+
+static struct file_operations timer_list_fops = {
+	.open		= timer_list_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init init_timer_list_procfs(void)
+{
+	struct proc_dir_entry *pe;
+
+	pe = proc_create("timer_wheel_list", 0444, NULL, &timer_list_fops);
+	if (!pe)
+		return -ENOMEM;
+	return 0;
+}
+late_initcall(init_timer_list_procfs);
+
+#endif /* CONFIG_PROC_FS */
+
 /**
  * msleep - sleep safely even with waitqueue interruptions
  * @msecs: Time in milliseconds to sleep for
