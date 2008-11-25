Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYKYXPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYKYXPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYKYXPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:15:05 -0500
Received: from flusers.ccur.com ([12.192.68.2]:59136 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752472AbYKYXPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:15:04 -0500
Date: Tue, 25 Nov 2008 18:14:45 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add per-cpu indexing to /proc/timer_list
Message-ID: <20081125231445.GA24326@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20081125224439.GA24042@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125224439.GA24042@tsunami.ccur.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-cpu indexing of /proc/timer_list.

/proc/timer_list, potentially a very large file, is in
danger of overflowing its seq_file buffer.  So 'split up'
the buffering on cpu ID boundaries.  This should make this
file more likely to be useful on largish SMP systems.

The model followed is that in /proc/interrupts, which
splits up its buffering on (most) irq boundaries.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.28-rc6/kernel/time/timer_list.c
===================================================================
--- 2.6.28-rc6.orig/kernel/time/timer_list.c	2008-11-25 17:50:43.000000000 -0500
+++ 2.6.28-rc6/kernel/time/timer_list.c	2008-11-25 18:03:44.000000000 -0500
@@ -250,36 +250,70 @@
 static int timer_list_show(struct seq_file *m, void *v)
 {
 	u64 now = ktime_to_ns(ktime_get());
-	int cpu;
+	int i = *(loff_t *)v;
 
-	SEQ_printf(m, "Timer List Version: v0.4\n");
-	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
-	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
-
-	for_each_online_cpu(cpu)
-		print_cpu(m, cpu, now);
-
-	SEQ_printf(m, "\n");
-	timer_list_show_tickdevices(m);
+	if (i == 0) {
+		SEQ_printf(m, "Timer List Version: v0.4\n");
+		SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n",
+			HRTIMER_MAX_CLOCK_BASES);
+		SEQ_printf(m, "now at %lld nsecs\n",
+			(unsigned long long)now);
+	}
+
+	if (i < nr_cpu_ids) {
+		if (cpu_online(i))
+			print_cpu(m, i, now);
+	}
+
+	if (i == nr_cpu_ids) {
+		SEQ_printf(m, "\n");
+		timer_list_show_tickdevices(m);
+	}
 
 	return 0;
 }
 
 void sysrq_timer_list_show(void)
 {
-	timer_list_show(NULL, NULL);
+	int i;
+	for (i = 0; i <= nr_cpu_ids; i++) {
+		loff_t v = i;
+		timer_list_show(NULL, &v);
+	}
+}
+
+static void *timer_list_start(struct seq_file *m, loff_t *pos)
+{
+	return (*pos <= nr_cpu_ids) ? pos : NULL;
 }
 
+static void *timer_list_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos > nr_cpu_ids)
+		return NULL;
+	return pos;
+}
+
+static void timer_list_stop(struct seq_file *m, void *v) { }
+
+static const struct seq_operations timer_list_seq_ops = {
+	.start = timer_list_start,
+	.next  = timer_list_next,
+	.stop  = timer_list_stop,
+	.show  = timer_list_show
+};
+
 static int timer_list_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, timer_list_show, NULL);
+	return seq_open(filp, &timer_list_seq_ops);
 }
 
 static struct file_operations timer_list_fops = {
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= seq_release,
 };
 
 static int __init init_timer_list_procfs(void)

