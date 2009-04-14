Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZDNMTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZDNMTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZDNMTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:19:01 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:38543 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbZDNMTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:19:00 -0400
Date: Tue, 14 Apr 2009 14:18:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC][PATCH] /proc/stat idle field for idle cpus
Message-ID: <20090414141851.3174f880@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The cpu idle field in the output of /proc/stat is too small for cpus
that have been idle for more than a tick. Add the architecture hook
arch_idle_time that allows to add the not accounted idle time of a
sleeping cpu without waking the cpu.

The s390 implementation of arch_idle_time uses the already existing
s390_idle_data per_cpu variable to find the sleep time of a neighboring
idle cpu.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/include/asm/cputime.h |    4 ++++
 arch/s390/kernel/vtime.c        |   16 ++++++++++++++++
 fs/proc/stat.c                  |    8 ++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/s390/include/asm/cputime.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/cputime.h
+++ linux-2.6/arch/s390/include/asm/cputime.h
@@ -174,4 +174,8 @@ cputime64_to_clock_t(cputime64_t cputime
        return __div(cputime, 4096000000ULL / USER_HZ);
 }
 
+cputime64_t s390_get_idle_time(int cpu);
+
+#define arch_idle_time(cpu) s390_get_idle_time(cpu)
+
 #endif /* _S390_CPUTIME_H */
Index: linux-2.6/arch/s390/kernel/vtime.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/vtime.c
+++ linux-2.6/arch/s390/kernel/vtime.c
@@ -238,6 +238,22 @@ void vtime_stop_cpu(void)
 	}
 }
 
+cputime64_t s390_get_idle_time(int cpu)
+{
+	struct s390_idle_data *idle;
+	unsigned long long now, idle_time, idle_enter;
+
+	idle = &per_cpu(s390_idle, cpu);
+	spin_lock(&idle->lock);
+	now = get_clock();
+	idle_time = 0;
+	idle_enter = idle->idle_enter;
+	if (idle_enter != 0ULL && idle_enter < now)
+		idle_time = now - idle_enter;
+	spin_unlock(&idle->lock);
+	return idle_time;
+}
+
 /*
  * Sorted add to a list. List is linear searched until first bigger
  * element is found.
Index: linux-2.6/fs/proc/stat.c
===================================================================
--- linux-2.6.orig/fs/proc/stat.c
+++ linux-2.6/fs/proc/stat.c
@@ -18,6 +18,9 @@
 #ifndef arch_irq_stat
 #define arch_irq_stat() 0
 #endif
+#ifndef arch_idle_time
+#define arch_idle_time(cpu) 0
+#endif
 
 static int show_stat(struct seq_file *p, void *v)
 {
@@ -39,7 +42,8 @@ static int show_stat(struct seq_file *p,
 		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
 		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
 		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
-		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
+		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle +
+				     arch_idle_time(i));
 		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
 		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
@@ -68,7 +72,7 @@ static int show_stat(struct seq_file *p,
 		user = kstat_cpu(i).cpustat.user;
 		nice = kstat_cpu(i).cpustat.nice;
 		system = kstat_cpu(i).cpustat.system;
-		idle = kstat_cpu(i).cpustat.idle;
+		idle = kstat_cpu(i).cpustat.idle + arch_idle_time(i);
 		iowait = kstat_cpu(i).cpustat.iowait;
 		irq = kstat_cpu(i).cpustat.irq;
 		softirq = kstat_cpu(i).cpustat.softirq;
