Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbXHTNNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbXHTNNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbXHTNNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:13:35 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39260 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141AbXHTNNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:13:34 -0400
Message-ID: <46C99384.8020904@bull.net>
Date: Mon, 20 Aug 2007 15:13:40 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: [PATCH 1/4] Introduce a new field "guest" in cpustat
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 15:18:47,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 15:18:48,
	Serialize complete at 20/08/2007 15:18:48
Content-Type: multipart/mixed;
 boundary="------------010501080606030903020100"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010501080606030903020100
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

[PATCH 1/4] as recent CPUs introduce a third running state, after "user" and
"system", we need a new field, "guest", in cpustat to store the time used by
the CPU to run virtual CPU. Modify /proc/stat to display this new field.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------010501080606030903020100
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="proc_stat_guest"
Content-Disposition: inline;
 filename="proc_stat_guest"

Index: kvm/fs/proc/proc_misc.c
===================================================================
--- kvm.orig/fs/proc/proc_misc.c	2007-08-20 14:17:13.000000000 +0200
+++ kvm/fs/proc/proc_misc.c	2007-08-20 14:17:16.000000000 +0200
@@ -443,6 +443,9 @@ static int show_stat(struct seq_file *p,
 	int i;
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
+#ifdef CONFIG_GUEST_ACCOUNTING
+	cputime64_t guest;
+#endif
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int *per_irq_sum;
@@ -453,6 +456,9 @@ static int show_stat(struct seq_file *p,
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
+#ifdef CONFIG_GUEST_ACCOUNTING
+	guest = cputime64_zero;
+#endif
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
@@ -467,6 +473,9 @@ static int show_stat(struct seq_file *p,
 		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
+#ifdef CONFIG_GUEST_ACCOUNTING
+		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
+#endif
 		for (j = 0; j < NR_IRQS; j++) {
 			unsigned int temp = kstat_cpu(i).irqs[j];
 			sum += temp;
@@ -474,6 +483,18 @@ static int show_stat(struct seq_file *p,
 		}
 	}
 
+#ifdef CONFIG_GUEST_ACCOUNTING
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
+#else
 	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu\n",
 		(unsigned long long)cputime64_to_clock_t(user),
 		(unsigned long long)cputime64_to_clock_t(nice),
@@ -483,6 +504,7 @@ static int show_stat(struct seq_file *p,
 		(unsigned long long)cputime64_to_clock_t(irq),
 		(unsigned long long)cputime64_to_clock_t(softirq),
 		(unsigned long long)cputime64_to_clock_t(steal));
+#endif
 	for_each_online_cpu(i) {
 
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
@@ -494,6 +516,21 @@ static int show_stat(struct seq_file *p,
 		irq = kstat_cpu(i).cpustat.irq;
 		softirq = kstat_cpu(i).cpustat.softirq;
 		steal = kstat_cpu(i).cpustat.steal;
+#ifdef CONFIG_GUEST_ACCOUNTING
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
+#else
 		seq_printf(p, "cpu%d %llu %llu %llu %llu %llu %llu %llu %llu\n",
 			i,
 			(unsigned long long)cputime64_to_clock_t(user),
@@ -504,6 +541,7 @@ static int show_stat(struct seq_file *p,
 			(unsigned long long)cputime64_to_clock_t(irq),
 			(unsigned long long)cputime64_to_clock_t(softirq),
 			(unsigned long long)cputime64_to_clock_t(steal));
+#endif
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
Index: kvm/include/linux/kernel_stat.h
===================================================================
--- kvm.orig/include/linux/kernel_stat.h	2007-08-20 14:17:13.000000000 +0200
+++ kvm/include/linux/kernel_stat.h	2007-08-20 14:17:16.000000000 +0200
@@ -23,6 +23,9 @@ struct cpu_usage_stat {
 	cputime64_t idle;
 	cputime64_t iowait;
 	cputime64_t steal;
+#ifdef CONFIG_GUEST_ACCOUNTING
+	cputime64_t guest;
+#endif
 };
 
 struct kernel_stat {
Index: kvm/init/Kconfig
===================================================================
--- kvm.orig/init/Kconfig	2007-08-20 14:17:13.000000000 +0200
+++ kvm/init/Kconfig	2007-08-20 14:17:35.000000000 +0200
@@ -167,6 +167,10 @@ config BSD_PROCESS_ACCT_V3
 	  for processing it. A preliminary version of these tools is available
 	  at <http://www.physik3.uni-rostock.de/tim/kernel/utils/acct/>.
 
+config GUEST_ACCOUNTING
+	bool
+	default n
+
 config TASKSTATS
 	bool "Export task/process statistics through netlink (EXPERIMENTAL)"
 	depends on NET

--------------010501080606030903020100--
