Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbXHPP6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbXHPP6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764262AbXHPP5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:57:45 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56809 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764192AbXHPP5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:57:43 -0400
Message-ID: <46C473FD.3050009@bull.net>
Date: Thu, 16 Aug 2007 17:57:49 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: kvm-devel@lists.sourceforge.net
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC 1/4]Introduce a new field "guest" in cpustat
References: <46C4719A.2060308@bull.net>
In-Reply-To: <46C4719A.2060308@bull.net>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 16/08/2007 18:02:52,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 16/08/2007 18:02:54,
	Serialize complete at 16/08/2007 18:02:54
Content-Type: multipart/mixed;
 boundary="------------090406080801040303060903"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090406080801040303060903
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

[PATCH 1/4] as modern CPUs introduce a third running state, after "user" and
"system", we need a new field, "guest", in cpustat to store the time used by
the CPU to run virtual CPU. Modify /proc/stat to display this new field.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------090406080801040303060903
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="proc_stat_guest"
Content-Disposition: inline;
 filename="proc_stat_guest"

Index: kvm/fs/proc/proc_misc.c
===================================================================
--- kvm.orig/fs/proc/proc_misc.c	2007-08-10 16:49:42.000000000 +0200
+++ kvm/fs/proc/proc_misc.c	2007-08-10 16:51:34.000000000 +0200
@@ -443,6 +443,7 @@
 	int i;
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
+	cputime64_t guest;
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int *per_irq_sum;
@@ -452,7 +453,7 @@
 		return -ENOMEM;
 
 	user = nice = system = idle = iowait =
-		irq = softirq = steal = cputime64_zero;
+		irq = softirq = steal = guest = cputime64_zero;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
@@ -467,6 +468,7 @@
 		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
+		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		for (j = 0; j < NR_IRQS; j++) {
 			unsigned int temp = kstat_cpu(i).irqs[j];
 			sum += temp;
@@ -474,7 +476,7 @@
 		}
 	}
 
-	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu\n",
+	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
 		(unsigned long long)cputime64_to_clock_t(user),
 		(unsigned long long)cputime64_to_clock_t(nice),
 		(unsigned long long)cputime64_to_clock_t(system),
@@ -482,7 +484,8 @@
 		(unsigned long long)cputime64_to_clock_t(iowait),
 		(unsigned long long)cputime64_to_clock_t(irq),
 		(unsigned long long)cputime64_to_clock_t(softirq),
-		(unsigned long long)cputime64_to_clock_t(steal));
+		(unsigned long long)cputime64_to_clock_t(steal),
+		(unsigned long long)cputime64_to_clock_t(guest));
 	for_each_online_cpu(i) {
 
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
@@ -494,7 +497,8 @@
 		irq = kstat_cpu(i).cpustat.irq;
 		softirq = kstat_cpu(i).cpustat.softirq;
 		steal = kstat_cpu(i).cpustat.steal;
-		seq_printf(p, "cpu%d %llu %llu %llu %llu %llu %llu %llu %llu\n",
+		guest = kstat_cpu(i).cpustat.guest;
+		seq_printf(p, "cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
 			i,
 			(unsigned long long)cputime64_to_clock_t(user),
 			(unsigned long long)cputime64_to_clock_t(nice),
@@ -503,7 +507,8 @@
 			(unsigned long long)cputime64_to_clock_t(iowait),
 			(unsigned long long)cputime64_to_clock_t(irq),
 			(unsigned long long)cputime64_to_clock_t(softirq),
-			(unsigned long long)cputime64_to_clock_t(steal));
+			(unsigned long long)cputime64_to_clock_t(steal),
+			(unsigned long long)cputime64_to_clock_t(guest));
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
Index: kvm/include/linux/kernel_stat.h
===================================================================
--- kvm.orig/include/linux/kernel_stat.h	2007-08-10 16:49:42.000000000 +0200
+++ kvm/include/linux/kernel_stat.h	2007-08-10 16:49:59.000000000 +0200
@@ -23,6 +23,7 @@
 	cputime64_t idle;
 	cputime64_t iowait;
 	cputime64_t steal;
+	cputime64_t guest;
 };
 
 struct kernel_stat {

--------------090406080801040303060903--
