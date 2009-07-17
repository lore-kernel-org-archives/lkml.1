Return-Path: <linux-kernel-owner+w=401wt.eu-S933774AbZGQAGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774AbZGQAGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933744AbZGQAGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:06:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39138 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933735AbZGQAGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:06:01 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 17/21] Blackfin: drop per-cpu loops_per_jiffy tracking
Date: Thu, 16 Jul 2009 20:05:42 -0400
Message-Id: <1247789146-18786-18-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

On Blackfin SMP, a per-cpu loops_per_jiffy is pointless since both cores
always run at the same CCLK.  In addition, the current implementation has
flaws since the main consumer for loops_per_jiffy (asm/delay.h) uses the
global kernel loops_per_jiffy and not the per_cpu one.  So punt all of the
per-cpu handling and go back to the global shared one.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/cpu.h |    1 -
 arch/blackfin/kernel/setup.c    |    7 +++----
 arch/blackfin/mach-common/smp.c |    2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/include/asm/cpu.h b/arch/blackfin/include/asm/cpu.h
index 565b813..fadfa82 100644
--- a/arch/blackfin/include/asm/cpu.h
+++ b/arch/blackfin/include/asm/cpu.h
@@ -32,7 +32,6 @@ struct blackfin_cpudata {
 	struct task_struct *idle;
 	unsigned int imemctl;
 	unsigned int dmemctl;
-	unsigned long loops_per_jiffy;
 	unsigned long dcache_invld_count;
 	unsigned long icache_invld_count;
 };
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 98c2f79..6225eda 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -168,7 +168,6 @@ void __cpuinit bfin_setup_cpudata(unsigned int cpu)
 	struct blackfin_cpudata *cpudata = &per_cpu(cpu_data, cpu);
 
 	cpudata->idle = current;
-	cpudata->loops_per_jiffy = loops_per_jiffy;
 	cpudata->imemctl = bfin_read_IMEM_CONTROL();
 	cpudata->dmemctl = bfin_read_DMEM_CONTROL();
 }
@@ -1159,9 +1158,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		sclk/1000000, sclk%1000000);
 	seq_printf(m, "bogomips\t: %lu.%02lu\n"
 		"Calibration\t: %lu loops\n",
-		(cpudata->loops_per_jiffy * HZ) / 500000,
-		((cpudata->loops_per_jiffy * HZ) / 5000) % 100,
-		(cpudata->loops_per_jiffy * HZ));
+		(loops_per_jiffy * HZ) / 500000,
+		((loops_per_jiffy * HZ) / 5000) % 100,
+		(loops_per_jiffy * HZ));
 
 	/* Check Cache configutation */
 	switch (cpudata->dmemctl & (1 << DMC0_P | 1 << DMC1_P)) {
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 6184005..e6e3429 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -450,7 +450,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
 	unsigned int cpu;
 
 	for_each_online_cpu(cpu)
-		bogosum += per_cpu(cpu_data, cpu).loops_per_jiffy;
+		bogosum += loops_per_jiffy;
 
 	printk(KERN_INFO "SMP: Total of %d processors activated "
 	       "(%lu.%02lu BogoMIPS).\n",
-- 
1.6.3.3

