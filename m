Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYJQMop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYJQMop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYJQMoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:44:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:3922 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbYJQMoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VUx7kBduDsE9s1+9nIZ/tkAXJmtwJtJgHmCkxXALabic/geO9NxYdvb9Bee3X1byPZ
         Rz6eISHuwC1UuGgDTlCWvyvcGf/yhQR5kNe+2uFsg3aSzfFL3SSeh0EhlnpN4lc6Hz/a
         dw0kHupBcjOg15mVX/Wu9ER8v/UY9lsOAFA1Q=
Date: Fri, 17 Oct 2008 16:47:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 16/31] proc: move /proc/stat to fs/proc/stat.c
Message-ID: <20081017124732.GQ22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 57eb5bd503dcd48ae699cef37255493ec17eeeb1 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 5 Oct 2008 00:01:56 +0400
Subject: [PATCH 16/31] proc: move /proc/stat to fs/proc/stat.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile    |    1 +
 fs/proc/proc_misc.c |  135 --------------------------------------------
 fs/proc/stat.c      |  154 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 155 insertions(+), 135 deletions(-)
 create mode 100644 fs/proc/stat.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index c91cc9c..13ffa7b 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -14,6 +14,7 @@ proc-y	+= cpuinfo.o
 proc-y	+= devices.o
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
+proc-y	+= stat.o
 proc-y	+= uptime.o
 proc-y	+= version.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 24c4f8d..d49b956 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -197,140 +197,6 @@ static const struct file_operations proc_vmalloc_operations = {
 };
 #endif
 
-#ifndef arch_irq_stat_cpu
-#define arch_irq_stat_cpu(cpu) 0
-#endif
-#ifndef arch_irq_stat
-#define arch_irq_stat() 0
-#endif
-
-static int show_stat(struct seq_file *p, void *v)
-{
-	int i;
-	unsigned long jif;
-	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
-	cputime64_t guest;
-	u64 sum = 0;
-	struct timespec boottime;
-	unsigned int *per_irq_sum;
-
-	per_irq_sum = kzalloc(sizeof(unsigned int)*NR_IRQS, GFP_KERNEL);
-	if (!per_irq_sum)
-		return -ENOMEM;
-
-	user = nice = system = idle = iowait =
-		irq = softirq = steal = cputime64_zero;
-	guest = cputime64_zero;
-	getboottime(&boottime);
-	jif = boottime.tv_sec;
-
-	for_each_possible_cpu(i) {
-		int j;
-
-		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
-		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
-		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
-		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
-		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
-		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
-		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
-		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
-		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for (j = 0; j < NR_IRQS; j++) {
-			unsigned int temp = kstat_cpu(i).irqs[j];
-			sum += temp;
-			per_irq_sum[j] += temp;
-		}
-		sum += arch_irq_stat_cpu(i);
-	}
-	sum += arch_irq_stat();
-
-	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
-		(unsigned long long)cputime64_to_clock_t(user),
-		(unsigned long long)cputime64_to_clock_t(nice),
-		(unsigned long long)cputime64_to_clock_t(system),
-		(unsigned long long)cputime64_to_clock_t(idle),
-		(unsigned long long)cputime64_to_clock_t(iowait),
-		(unsigned long long)cputime64_to_clock_t(irq),
-		(unsigned long long)cputime64_to_clock_t(softirq),
-		(unsigned long long)cputime64_to_clock_t(steal),
-		(unsigned long long)cputime64_to_clock_t(guest));
-	for_each_online_cpu(i) {
-
-		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kstat_cpu(i).cpustat.user;
-		nice = kstat_cpu(i).cpustat.nice;
-		system = kstat_cpu(i).cpustat.system;
-		idle = kstat_cpu(i).cpustat.idle;
-		iowait = kstat_cpu(i).cpustat.iowait;
-		irq = kstat_cpu(i).cpustat.irq;
-		softirq = kstat_cpu(i).cpustat.softirq;
-		steal = kstat_cpu(i).cpustat.steal;
-		guest = kstat_cpu(i).cpustat.guest;
-		seq_printf(p,
-			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
-			i,
-			(unsigned long long)cputime64_to_clock_t(user),
-			(unsigned long long)cputime64_to_clock_t(nice),
-			(unsigned long long)cputime64_to_clock_t(system),
-			(unsigned long long)cputime64_to_clock_t(idle),
-			(unsigned long long)cputime64_to_clock_t(iowait),
-			(unsigned long long)cputime64_to_clock_t(irq),
-			(unsigned long long)cputime64_to_clock_t(softirq),
-			(unsigned long long)cputime64_to_clock_t(steal),
-			(unsigned long long)cputime64_to_clock_t(guest));
-	}
-	seq_printf(p, "intr %llu", (unsigned long long)sum);
-
-	for (i = 0; i < NR_IRQS; i++)
-		seq_printf(p, " %u", per_irq_sum[i]);
-
-	seq_printf(p,
-		"\nctxt %llu\n"
-		"btime %lu\n"
-		"processes %lu\n"
-		"procs_running %lu\n"
-		"procs_blocked %lu\n",
-		nr_context_switches(),
-		(unsigned long)jif,
-		total_forks,
-		nr_running(),
-		nr_iowait());
-
-	kfree(per_irq_sum);
-	return 0;
-}
-
-static int stat_open(struct inode *inode, struct file *file)
-{
-	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
-	char *buf;
-	struct seq_file *m;
-	int res;
-
-	/* don't ask for more than the kmalloc() max size, currently 128 KB */
-	if (size > 128 * 1024)
-		size = 128 * 1024;
-	buf = kmalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	res = single_open(file, show_stat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = size;
-	} else
-		kfree(buf);
-	return res;
-}
-static const struct file_operations proc_stat_operations = {
-	.open		= stat_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /*
  * /proc/interrupts
  */
@@ -510,7 +376,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-	proc_create("stat", 0, NULL, &proc_stat_operations);
 	proc_create("interrupts", 0, NULL, &proc_interrupts_operations);
 #ifdef CONFIG_SLABINFO
 	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
new file mode 100644
index 0000000..171642d
--- /dev/null
+++ b/fs/proc/stat.c
@@ -0,0 +1,154 @@
+#include <linux/cpumask.h>
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <asm/cputime.h>
+
+#ifndef arch_irq_stat_cpu
+#define arch_irq_stat_cpu(cpu) 0
+#endif
+#ifndef arch_irq_stat
+#define arch_irq_stat() 0
+#endif
+
+static int show_stat(struct seq_file *p, void *v)
+{
+	int i;
+	unsigned long jif;
+	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
+	cputime64_t guest;
+	u64 sum = 0;
+	struct timespec boottime;
+	unsigned int *per_irq_sum;
+
+	per_irq_sum = kzalloc(sizeof(unsigned int)*NR_IRQS, GFP_KERNEL);
+	if (!per_irq_sum)
+		return -ENOMEM;
+
+	user = nice = system = idle = iowait =
+		irq = softirq = steal = cputime64_zero;
+	guest = cputime64_zero;
+	getboottime(&boottime);
+	jif = boottime.tv_sec;
+
+	for_each_possible_cpu(i) {
+		int j;
+
+		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
+		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
+		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
+		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
+		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
+		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
+		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
+		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
+		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
+		for (j = 0; j < NR_IRQS; j++) {
+			unsigned int temp = kstat_cpu(i).irqs[j];
+			sum += temp;
+			per_irq_sum[j] += temp;
+		}
+		sum += arch_irq_stat_cpu(i);
+	}
+	sum += arch_irq_stat();
+
+	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
+		(unsigned long long)cputime64_to_clock_t(user),
+		(unsigned long long)cputime64_to_clock_t(nice),
+		(unsigned long long)cputime64_to_clock_t(system),
+		(unsigned long long)cputime64_to_clock_t(idle),
+		(unsigned long long)cputime64_to_clock_t(iowait),
+		(unsigned long long)cputime64_to_clock_t(irq),
+		(unsigned long long)cputime64_to_clock_t(softirq),
+		(unsigned long long)cputime64_to_clock_t(steal),
+		(unsigned long long)cputime64_to_clock_t(guest));
+	for_each_online_cpu(i) {
+
+		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
+		user = kstat_cpu(i).cpustat.user;
+		nice = kstat_cpu(i).cpustat.nice;
+		system = kstat_cpu(i).cpustat.system;
+		idle = kstat_cpu(i).cpustat.idle;
+		iowait = kstat_cpu(i).cpustat.iowait;
+		irq = kstat_cpu(i).cpustat.irq;
+		softirq = kstat_cpu(i).cpustat.softirq;
+		steal = kstat_cpu(i).cpustat.steal;
+		guest = kstat_cpu(i).cpustat.guest;
+		seq_printf(p,
+			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
+			i,
+			(unsigned long long)cputime64_to_clock_t(user),
+			(unsigned long long)cputime64_to_clock_t(nice),
+			(unsigned long long)cputime64_to_clock_t(system),
+			(unsigned long long)cputime64_to_clock_t(idle),
+			(unsigned long long)cputime64_to_clock_t(iowait),
+			(unsigned long long)cputime64_to_clock_t(irq),
+			(unsigned long long)cputime64_to_clock_t(softirq),
+			(unsigned long long)cputime64_to_clock_t(steal),
+			(unsigned long long)cputime64_to_clock_t(guest));
+	}
+	seq_printf(p, "intr %llu", (unsigned long long)sum);
+
+	for (i = 0; i < NR_IRQS; i++)
+		seq_printf(p, " %u", per_irq_sum[i]);
+
+	seq_printf(p,
+		"\nctxt %llu\n"
+		"btime %lu\n"
+		"processes %lu\n"
+		"procs_running %lu\n"
+		"procs_blocked %lu\n",
+		nr_context_switches(),
+		(unsigned long)jif,
+		total_forks,
+		nr_running(),
+		nr_iowait());
+
+	kfree(per_irq_sum);
+	return 0;
+}
+
+static int stat_open(struct inode *inode, struct file *file)
+{
+	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
+	char *buf;
+	struct seq_file *m;
+	int res;
+
+	/* don't ask for more than the kmalloc() max size, currently 128 KB */
+	if (size > 128 * 1024)
+		size = 128 * 1024;
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	res = single_open(file, show_stat, NULL);
+	if (!res) {
+		m = file->private_data;
+		m->buf = buf;
+		m->size = size;
+	} else
+		kfree(buf);
+	return res;
+}
+
+static const struct file_operations proc_stat_operations = {
+	.open		= stat_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_stat_init(void)
+{
+	proc_create("stat", 0, NULL, &proc_stat_operations);
+	return 0;
+}
+module_init(proc_stat_init);
-- 
1.5.6.5

