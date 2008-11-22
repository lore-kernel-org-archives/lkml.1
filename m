Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYKVE1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYKVE1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 23:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYKVE1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 23:27:13 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:35445 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYKVE1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 23:27:11 -0500
Date: Fri, 21 Nov 2008 20:27:08 -0800
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       h-shimamoto@ct.jp.nec.com
Subject: [PATCH 2/3 v2] proc: Export statistics for softirq to /proc
Message-Id: <20081121202708.95ec8b3f.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20081121202232.0489f84b.kobayashi.kk@ncos.nec.co.jp>
References: <20081121202232.0489f84b.kobayashi.kk@ncos.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export statistics for softirq in /proc/softirqs and /proc/stat.

1. /proc/softirqs
Implement /proc/softirqs which shows the number of softirq
for each CPU like /proc/interrupts.

2. /proc/stat
Add the "softirq" line to /proc/stat.
This line shows the number of softirq for all cpu.
The first column is the total of all softirqs and
each subsequent column is the total for particular softirq.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Reviewed-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 fs/proc/Makefile   |    1 +
 fs/proc/softirqs.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/stat.c     |   17 +++++++++++++++
 3 files changed, 75 insertions(+), 0 deletions(-)
 create mode 100644 fs/proc/softirqs.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 63d9651..11a7b5c 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -18,6 +18,7 @@ proc-y	+= meminfo.o
 proc-y	+= stat.o
 proc-y	+= uptime.o
 proc-y	+= version.o
+proc-y	+= softirqs.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
diff --git a/fs/proc/softirqs.c b/fs/proc/softirqs.c
new file mode 100644
index 0000000..543f9d9
--- /dev/null
+++ b/fs/proc/softirqs.c
@@ -0,0 +1,57 @@
+#include <linux/init.h>
+#include <linux/kernel_stat.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+static const char *desc_array[] = {
+	"HI",
+	"TIMER",
+	"NET_TX",
+	"NET_RX",
+	"BLOCK",
+	"TASKLET",
+	"SCHED",
+#ifdef CONFIG_HIGH_RES_TIMERS
+	"HRTIMER",
+#endif
+	"RCU"};
+
+/*
+ * /proc/softirqs  ... display the number of softirqs
+ */
+static int show_softirqs(struct seq_file *p, void *v)
+{
+	int i, j;
+
+	seq_printf(p, "                ");
+	for_each_possible_cpu(i)
+		seq_printf(p, "CPU%-8d", i);
+	seq_printf(p, "\n");
+
+	for (i = 0; i < NR_SOFTIRQS; i++) {
+		seq_printf(p, "%-9s", desc_array[i]);
+		for_each_possible_cpu(j)
+			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
+		seq_printf(p, "\n");
+	}
+	return 0;
+}
+
+static int softirqs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_softirqs, NULL);
+}
+
+static const struct file_operations proc_softirqs_operations = {
+	.open		= softirqs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_softirqs_init(void)
+{
+	proc_create("softirqs", 0, NULL, &proc_softirqs_operations);
+	return 0;
+}
+module_init(proc_softirqs_init);
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 81904f0..74ac85a 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -25,6 +25,7 @@ static int show_stat(struct seq_file *p, void *v)
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
 	cputime64_t guest;
 	u64 sum = 0;
+	u64 sum_softirq = 0;
 	struct timespec boottime;
 	unsigned int per_irq_sum;
 
@@ -49,6 +50,10 @@ static int show_stat(struct seq_file *p, void *v)
 			sum += kstat_irqs_cpu(j, i);
 
 		sum += arch_irq_stat_cpu(i);
+
+		for (j = 0; j < NR_SOFTIRQS; j++)
+			sum_softirq += kstat_softirqs_cpu(j, i);
+
 	}
 	sum += arch_irq_stat();
 
@@ -111,6 +116,18 @@ static int show_stat(struct seq_file *p, void *v)
 		nr_running(),
 		nr_iowait());
 
+	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
+
+	for (i = 0; i < NR_SOFTIRQS; i++) {
+		per_irq_sum = 0;
+
+		for_each_possible_cpu(j)
+			per_irq_sum += kstat_softirqs_cpu(i, j);
+
+		seq_printf(p, " %u", per_irq_sum);
+	}
+	seq_printf(p, "\n");
+
 	return 0;
 }
 
-- 
1.5.0.6

