Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbYHJHtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbYHJHtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYHJHjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:39:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:3148 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbYHJHjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qpp6KbuVswl4SPl/r9iQzzDsq3IDtL9g+96moU79f+uU7DsNfZcznKO6+yeUzeJ/mK
         0gx3cnJzkjdEbNPqZn93Dlq7h71+ZryL1do7HWkd0p5/ECLQPRojMwNc0wBMkT4ShZW0
         ccG0UqprjaQJoJPbh4o27aoh5WDMfhJ07SoDI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 34/43] replace loop with nr_irqs for proc/stat
Date: Sun, 10 Aug 2008 00:36:23 -0700
Message-Id: <1218353792-3355-35-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-34-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-5-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-6-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-7-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-10-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-11-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-12-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-13-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-14-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-15-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-16-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-17-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-18-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-19-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-20-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-21-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-22-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-23-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-24-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-25-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-26-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-27-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-28-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-29-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-30-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-31-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-32-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-33-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-34-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so don't all irq_desc at begining to allocate all.
and only call that when needed

v2: make sure arch without GENERIC_HARDIRQS works too

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 fs/proc/proc_misc.c       |   41 +++++++++++++++++++++++++++--------------
 include/linux/interrupt.h |    5 +++++
 2 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index aeb0a40..1131f07 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -495,17 +495,16 @@ static const struct file_operations proc_vmalloc_operations = {
 
 static int show_stat(struct seq_file *p, void *v)
 {
-	int i;
+	int i, j;
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
 	cputime64_t guest;
 	u64 sum = 0;
 	struct timespec boottime;
-	unsigned int *per_irq_sum;
-
-	per_irq_sum = kzalloc(sizeof(unsigned int)*nr_irqs, GFP_KERNEL);
-	if (!per_irq_sum)
-		return -ENOMEM;
+	unsigned int per_irq_sum;
+#ifdef CONFIG_GENERIC_HARDIRQS
+	struct irq_desc *desc;
+#endif
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -514,8 +513,6 @@ static int show_stat(struct seq_file *p, void *v)
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		int j;
-
 		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
 		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
 		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
@@ -525,10 +522,12 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for (j = 0; j < nr_irqs; j++) {
-			unsigned int temp = kstat_irqs_cpu(j, i);
+		for_each_irq_desc(j, desc)
+		{
+			unsigned int temp;
+
+			temp = kstat_irqs_cpu(j, i);
 			sum += temp;
-			per_irq_sum[j] += temp;
 		}
 		sum += arch_irq_stat_cpu(i);
 	}
@@ -571,8 +570,23 @@ static int show_stat(struct seq_file *p, void *v)
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
-	for (i = 0; i < nr_irqs; i++)
-		seq_printf(p, " %u", per_irq_sum[i]);
+	/* sum again ? it could be updated? */
+	for_each_irq_desc(j, desc)
+	{
+		per_irq_sum = 0;
+		for_each_possible_cpu(i) {
+			unsigned int temp;
+
+			temp = kstat_irqs_cpu(j, i);
+			per_irq_sum += temp;
+		}
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+		seq_printf(p, " %u:%u", j, per_irq_sum);
+#else
+		seq_printf(p, " %u", per_irq_sum);
+#endif
+	}
 
 	seq_printf(p,
 		"\nctxt %llu\n"
@@ -586,7 +600,6 @@ static int show_stat(struct seq_file *p, void *v)
 		nr_running(),
 		nr_iowait());
 
-	kfree(per_irq_sum);
 	return 0;
 }
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 21022ce..d6f1782 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -17,6 +17,11 @@
 
 extern int nr_irqs;
 
+#ifndef CONFIG_GENERIC_HARDIRQS
+#define for_each_irq_desc(irq, desc)		\
+	for (irq = 0; irq < nr_irqs; irq++])
+#endif
+
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
  * linux/ioport.h to select the interrupt line behaviour.  When
-- 
1.5.4.5

