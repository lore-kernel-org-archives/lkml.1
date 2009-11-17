Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZKQTSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZKQTSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 14:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbZKQTSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 14:18:01 -0500
Received: from relay3.sgi.com ([192.48.152.1]:46633 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756193AbZKQTR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 14:17:57 -0500
Message-Id: <20091117191758.564400000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 13:17:54 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] INIT: Limit the number of per cpu calibration bootup messages
References: <20091117191752.164451000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=limit_init_boot_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the number of per cpu calibration messages by only printing
out results for the boot cpu.

Don't print "CPUx is down" as this is expected, and we don't need
4096 reminders... ;-)

Signed-off-by: Mike Travis <travis@sgi.com>
---
 init/calibrate.c |   24 +++++++++++++++---------
 kernel/cpu.c     |    5 ++---
 2 files changed, 17 insertions(+), 12 deletions(-)

--- linux.orig/init/calibrate.c
+++ linux/init/calibrate.c
@@ -123,23 +123,26 @@
 {
 	unsigned long ticks, loopbit;
 	int lps_precision = LPS_PREC;
+	static bool printed;
 
 	if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
-		printk(KERN_INFO
-			"Calibrating delay loop (skipped) preset value.. ");
-	} else if ((smp_processor_id() == 0) && lpj_fine) {
+		if (!printed)
+			pr_info("Calibrating delay loop (skipped) "
+				"preset value.. ");
+	} else if ((!printed) && lpj_fine) {
 		loops_per_jiffy = lpj_fine;
-		printk(KERN_INFO
-			"Calibrating delay loop (skipped), "
+		pr_info("Calibrating delay loop (skipped), "
 			"value calculated using timer frequency.. ");
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
-		printk(KERN_INFO
-			"Calibrating delay using timer specific routine.. ");
+		if (!printed)
+			pr_info("Calibrating delay using timer "
+				"specific routine.. ");
 	} else {
 		loops_per_jiffy = (1<<12);
 
-		printk(KERN_INFO "Calibrating delay loop... ");
+		if (!printed)
+			pr_info("Calibrating delay loop... ");
 		while ((loops_per_jiffy <<= 1) != 0) {
 			/* wait for "start of" clock tick */
 			ticks = jiffies;
@@ -170,7 +173,10 @@
 				loops_per_jiffy &= ~loopbit;
 		}
 	}
-	printk(KERN_CONT "%lu.%02lu BogoMIPS (lpj=%lu)\n",
+	if (!printed)
+		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
 			loops_per_jiffy/(500000/HZ),
 			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
+
+	printed = true;
 }
--- linux.orig/kernel/cpu.c
+++ linux/kernel/cpu.c
@@ -392,10 +392,9 @@
 		if (cpu == first_cpu)
 			continue;
 		error = _cpu_down(cpu, 1);
-		if (!error) {
+		if (!error)
 			cpumask_set_cpu(cpu, frozen_cpus);
-			printk("CPU%d is down\n", cpu);
-		} else {
+		else {
 			printk(KERN_ERR "Error taking CPU%d down: %d\n",
 				cpu, error);
 			break;

