Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZJWQWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZJWQWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZJWQWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:22:32 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40508 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZJWQW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=d4xrT38iTpjnqCljBkBRva2uUmKZRHMOttvmIGoy2n2KnkGTWNAgjJXi/LBFowEjrb
         8LSEsEvh9w59akv6hJbuRkaHtkPmnEcey4BeA8Qt5/Tzl836iy0T+v0mKfCyQ6EkSDWs
         rLHfhO+EnxFqymw5uCIkTPA3OgXA8KtZ6t6rI=
From: Ryota Ozaki <ozaki.ryota@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH -tip] sched, cpuacct: fix niced guest time accounting
Date: Sat, 24 Oct 2009 01:20:10 +0900
Message-Id: <1256314810-7897-1-git-send-email-ozaki.ryota@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU time of a guest is always accounted in 'user' time
without concern for the nice value of its counterpart
process although the guest is scheduled under the nice
value.

This patch fixes the defect and accounts cpu time of
a niced guest in 'nice' time as same as a niced process.

And also the patch adds 'guest_nice' to cpuacct. The
value provides niced guest cpu time which is like 'nice'
to 'user'.

The original discussions can be found here.
http://www.mail-archive.com/kvm@vger.kernel.org/msg23982.html
http://www.mail-archive.com/kvm@vger.kernel.org/msg23860.html

Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
Acked-by: Avi Kivity <avi@redhat.com>
---
 Documentation/filesystems/proc.txt |    3 ++-
 fs/proc/stat.c                     |   19 +++++++++++++------
 include/linux/kernel_stat.h        |    1 +
 kernel/sched.c                     |    9 +++++++--
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 2c48f94..4af0018 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1072,7 +1072,8 @@ second).  The meanings of the columns are as follows, from left to right:
 - irq: servicing interrupts
 - softirq: servicing softirqs
 - steal: involuntary wait
-- guest: running a guest
+- guest: running a normal guest
+- guest_nice: running a niced guest
 
 The "intr" line gives counts of interrupts  serviced since boot time, for each
 of the  possible system interrupts.   The first  column  is the  total of  all
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 7cc726c..b9b7aad 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -27,7 +27,7 @@ static int show_stat(struct seq_file *p, void *v)
 	int i, j;
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
-	cputime64_t guest;
+	cputime64_t guest, guest_nice;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
@@ -36,7 +36,7 @@ static int show_stat(struct seq_file *p, void *v)
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
-	guest = cputime64_zero;
+	guest = guest_nice = cputime64_zero;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
@@ -51,6 +51,8 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
+		guest_nice = cputime64_add(guest_nice,
+			kstat_cpu(i).cpustat.guest_nice);
 		for_each_irq_nr(j) {
 			sum += kstat_irqs_cpu(j, i);
 		}
@@ -65,7 +67,8 @@ static int show_stat(struct seq_file *p, void *v)
 	}
 	sum += arch_irq_stat();
 
-	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
+	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
+		"%llu\n",
 		(unsigned long long)cputime64_to_clock_t(user),
 		(unsigned long long)cputime64_to_clock_t(nice),
 		(unsigned long long)cputime64_to_clock_t(system),
@@ -74,7 +77,8 @@ static int show_stat(struct seq_file *p, void *v)
 		(unsigned long long)cputime64_to_clock_t(irq),
 		(unsigned long long)cputime64_to_clock_t(softirq),
 		(unsigned long long)cputime64_to_clock_t(steal),
-		(unsigned long long)cputime64_to_clock_t(guest));
+		(unsigned long long)cputime64_to_clock_t(guest),
+		(unsigned long long)cputime64_to_clock_t(guest_nice));
 	for_each_online_cpu(i) {
 
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
@@ -88,8 +92,10 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = kstat_cpu(i).cpustat.softirq;
 		steal = kstat_cpu(i).cpustat.steal;
 		guest = kstat_cpu(i).cpustat.guest;
+		guest_nice = kstat_cpu(i).cpustat.guest_nice;
 		seq_printf(p,
-			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
+			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
+			"%llu\n",
 			i,
 			(unsigned long long)cputime64_to_clock_t(user),
 			(unsigned long long)cputime64_to_clock_t(nice),
@@ -99,7 +105,8 @@ static int show_stat(struct seq_file *p, void *v)
 			(unsigned long long)cputime64_to_clock_t(irq),
 			(unsigned long long)cputime64_to_clock_t(softirq),
 			(unsigned long long)cputime64_to_clock_t(steal),
-			(unsigned long long)cputime64_to_clock_t(guest));
+			(unsigned long long)cputime64_to_clock_t(guest),
+			(unsigned long long)cputime64_to_clock_t(guest_nice));
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 348fa88..c059044 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -25,6 +25,7 @@ struct cpu_usage_stat {
 	cputime64_t iowait;
 	cputime64_t steal;
 	cputime64_t guest;
+	cputime64_t guest_nice;
 };
 
 struct kernel_stat {
diff --git a/kernel/sched.c b/kernel/sched.c
index 00f9e71..8dd285e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5017,8 +5017,13 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	p->gtime = cputime_add(p->gtime, cputime);
 
 	/* Add guest time to cpustat. */
-	cpustat->user = cputime64_add(cpustat->user, tmp);
-	cpustat->guest = cputime64_add(cpustat->guest, tmp);
+	if (TASK_NICE(p) > 0) {
+		cpustat->nice = cputime64_add(cpustat->nice, tmp);
+		cpustat->guest_nice = cputime64_add(cpustat->guest_nice, tmp);
+	} else {
+		cpustat->user = cputime64_add(cpustat->user, tmp);
+		cpustat->guest = cputime64_add(cpustat->guest, tmp);
+	}
 }
 
 /*
-- 
1.6.2.5

