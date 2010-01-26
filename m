Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602Ab0AZX76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0AZX76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570Ab0AZX7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:59:49 -0500
Received: from kroah.org ([198.145.64.141]:35205 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab0AZXnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:25 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:25 2010
Message-Id: <20100126233925.070897535@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Travis <travis@sgi.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [32/98] timers, init: Limit the number of per cpu calibration bootup messages
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Travis <travis@sgi.com>

commit feae3203d711db0a9965300ee6d592257fdaae4f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/calibrate.c |   24 +++++++++++++++---------
 kernel/cpu.c     |    5 ++---
 2 files changed, 17 insertions(+), 12 deletions(-)

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
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -400,10 +400,9 @@ int disable_nonboot_cpus(void)
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


