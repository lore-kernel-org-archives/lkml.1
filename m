Return-Path: <linux-kernel-owner+w=401wt.eu-S1760522AbXIJONb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522AbXIJONb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760303AbXIJONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:13:09 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45327 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760289AbXIJONH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:13:07 -0400
Message-ID: <46E550E1.9080903@bull.net>
Date: Mon, 10 Sep 2007 16:12:49 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RESEND 2][PATCH 1/4] Introduce a new field "guest" in cpustat
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 16:18:45,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 16:18:47,
	Serialize complete at 10/09/2007 16:18:47
Content-Type: multipart/mixed;
 boundary="------------020105040200080009000300"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020105040200080009000300
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

[PATCH 1/4] as recent CPUs introduce a third running state, after "user" and
"system", we need a new field, "guest", in cpustat to store the time used by
the CPU to run virtual CPU. Modify /proc/stat to display this new field.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth



--------------020105040200080009000300
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="proc_stat_guest"
Content-Disposition: inline;
 filename="proc_stat_guest"

Index: linux-2.6/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_misc.c	2007-09-10 14:15:55.000000000 +0200
+++ linux-2.6/fs/proc/proc_misc.c	2007-09-10 14:18:02.000000000 +0200
@@ -443,6 +443,7 @@ static int show_stat(struct seq_file *p,
 	int i;
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
+	cputime64_t guest;
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int *per_irq_sum;
@@ -453,6 +454,7 @@ static int show_stat(struct seq_file *p,
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
+	guest = cputime64_zero;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
@@ -467,6 +469,7 @@ static int show_stat(struct seq_file *p,
 		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
+		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		for (j = 0; j < NR_IRQS; j++) {
 			unsigned int temp = kstat_cpu(i).irqs[j];
 			sum += temp;
@@ -474,7 +477,7 @@ static int show_stat(struct seq_file *p,
 		}
 	}
 
-	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu\n",
+	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
 		(unsigned long long)cputime64_to_clock_t(user),
 		(unsigned long long)cputime64_to_clock_t(nice),
 		(unsigned long long)cputime64_to_clock_t(system),
@@ -482,7 +485,8 @@ static int show_stat(struct seq_file *p,
 		(unsigned long long)cputime64_to_clock_t(iowait),
 		(unsigned long long)cputime64_to_clock_t(irq),
 		(unsigned long long)cputime64_to_clock_t(softirq),
-		(unsigned long long)cputime64_to_clock_t(steal));
+		(unsigned long long)cputime64_to_clock_t(steal),
+		(unsigned long long)cputime64_to_clock_t(guest));
 	for_each_online_cpu(i) {
 
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
@@ -494,7 +498,9 @@ static int show_stat(struct seq_file *p,
 		irq = kstat_cpu(i).cpustat.irq;
 		softirq = kstat_cpu(i).cpustat.softirq;
 		steal = kstat_cpu(i).cpustat.steal;
-		seq_printf(p, "cpu%d %llu %llu %llu %llu %llu %llu %llu %llu\n",
+		guest = kstat_cpu(i).cpustat.guest;
+		seq_printf(p,
+			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
 			i,
 			(unsigned long long)cputime64_to_clock_t(user),
 			(unsigned long long)cputime64_to_clock_t(nice),
@@ -503,7 +509,8 @@ static int show_stat(struct seq_file *p,
 			(unsigned long long)cputime64_to_clock_t(iowait),
 			(unsigned long long)cputime64_to_clock_t(irq),
 			(unsigned long long)cputime64_to_clock_t(softirq),
-			(unsigned long long)cputime64_to_clock_t(steal));
+			(unsigned long long)cputime64_to_clock_t(steal),
+			(unsigned long long)cputime64_to_clock_t(guest));
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
Index: linux-2.6/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.orig/include/linux/kernel_stat.h	2007-09-10 14:15:55.000000000 +0200
+++ linux-2.6/include/linux/kernel_stat.h	2007-09-10 14:17:01.000000000 +0200
@@ -23,6 +23,7 @@ struct cpu_usage_stat {
 	cputime64_t idle;
 	cputime64_t iowait;
 	cputime64_t steal;
+	cputime64_t guest;
 };
 
 struct kernel_stat {

--------------020105040200080009000300--
