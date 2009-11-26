Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbZKZJ4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbZKZJ4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZKZJ42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:56:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:59962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115AbZKZJ4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:56:22 -0500
Date: Thu, 26 Nov 2009 09:55:30 GMT
From: tip-bot for Mike Travis <travis@sgi.com>
Cc: mingo@redhat.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
       yhlu.kernel@gmail.com, rostedt@goodmis.org, gregkh@suse.de,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, rientjes@google.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, andi@firstfloor.org,
       travis@sgi.com, seto.hidetoshi@jp.fujitsu.com, rdunlap@xenotime.net,
       rdreier@cisco.com, steiner@sgi.com, tj@kernel.org, mingo@elte.hu
Reply-To: mingo@redhat.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
       yhlu.kernel@gmail.com, rostedt@goodmis.org, gregkh@suse.de,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, rientjes@google.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, andi@firstfloor.org,
       travis@sgi.com, seto.hidetoshi@jp.fujitsu.com, rdunlap@xenotime.net,
       steiner@sgi.com, rdreier@cisco.com, tj@kernel.org, mingo@elte.hu
In-Reply-To: <20091118002219.889552000@alcatraz.americas.sgi.com>
References: <20091118002219.889552000@alcatraz.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timers, init: Limit the number of per cpu calibration bootup messages
Message-ID: <tip-feae3203d711db0a9965300ee6d592257fdaae4f@git.kernel.org>
Git-Commit-ID: feae3203d711db0a9965300ee6d592257fdaae4f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  feae3203d711db0a9965300ee6d592257fdaae4f
Gitweb:     http://git.kernel.org/tip/feae3203d711db0a9965300ee6d592257fdaae4f
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Tue, 17 Nov 2009 18:22:13 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:18:42 +0100

timers, init: Limit the number of per cpu calibration bootup messages

Limit the number of per cpu calibration messages by only
printing out results for the first cpu to boot.

Also, don't print "CPUx is down" as this is expected, and we
don't need 4096 reminders... ;-)

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091118002219.889552000@alcatraz.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/calibrate.c |   24 +++++++++++++++---------
 kernel/cpu.c     |    5 ++---
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index a379c90..6eb48e5 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -123,23 +123,26 @@ void __cpuinit calibrate_delay(void)
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
@@ -170,7 +173,10 @@ void __cpuinit calibrate_delay(void)
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
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 6ba0f1e..7c4e271 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -392,10 +392,9 @@ int disable_nonboot_cpus(void)
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
