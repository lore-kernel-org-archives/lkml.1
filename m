Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYJCK7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYJCK7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYJCK6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:58:47 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:33804 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYJCK6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:58:45 -0400
Message-Id: <20081003105753.764849778@de.ibm.com>
References: <20081003105632.357231142@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Oct 2008 12:56:35 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: rusty@rustcorp.com.au, jens.axboe@oracle.com, schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 3/4] s390: convert etr/stp to stop_machine interface
Content-Disposition: inline; filename=etr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The s390 etr and stp code uses smp_call_function in order to synchronize
all cpus without allocating any memory.

The semantics of the old smp_call_function guaranteed that it returned
only after the IPIs have been delivered to all other cpus. That way it was
known that all other cpus were running in an interrupt handler with
interrupts disabled.
This semantic is gone with the new generic IPI infrastructure and prevented
s390 to use it yet.
With the new stop_machine interface stop_machine_get_threads we can create
the kstop threads in advance. This allows to use the stop_machine interface
to synchronize all cpus without allocating any memory.
So convert the etr/stp code to use stop_machine instead.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/time.c |  182 ++++++++++++++++++++++++++++++------------------
 1 file changed, 115 insertions(+), 67 deletions(-)

Index: linux-2.6/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/time.c
+++ linux-2.6/arch/s390/kernel/time.c
@@ -20,6 +20,8 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
+#include <linux/cpu.h>
+#include <linux/stop_machine.h>
 #include <linux/time.h>
 #include <linux/sysdev.h>
 #include <linux/delay.h>
@@ -450,9 +452,13 @@ static void etr_reset(void)
 static int __init etr_init(void)
 {
 	struct etr_aib aib;
+	int rc;
 
 	if (!test_bit(CLOCK_SYNC_HAS_ETR, &clock_sync_flags))
 		return 0;
+	rc = stop_machine_get_threads();
+	if (rc)
+		return rc;
 	/* Check if this machine has the steai instruction. */
 	if (etr_steai(&aib, ETR_STEAI_STEPPING_PORT) == 0)
 		etr_steai_available = 1;
@@ -643,14 +649,16 @@ static int etr_aib_follows(struct etr_ai
 }
 
 struct clock_sync_data {
+	atomic_t cpus;
 	int in_sync;
 	unsigned long long fixup_cc;
+	int etr_port;
+	struct etr_aib *etr_aib;
 };
 
-static void clock_sync_cpu_start(void *dummy)
+static void clock_sync_cpu(struct clock_sync_data *sync)
 {
-	struct clock_sync_data *sync = dummy;
-
+	atomic_dec(&sync->cpus);
 	enable_sync_clock();
 	/*
 	 * This looks like a busy wait loop but it isn't. etr_sync_cpus
@@ -676,39 +684,35 @@ static void clock_sync_cpu_start(void *d
 	fixup_clock_comparator(sync->fixup_cc);
 }
 
-static void clock_sync_cpu_end(void *dummy)
-{
-}
-
 /*
  * Sync the TOD clock using the port refered to by aibp. This port
  * has to be enabled and the other port has to be disabled. The
  * last eacr update has to be more than 1.6 seconds in the past.
  */
-static int etr_sync_clock(struct etr_aib *aib, int port)
+static int etr_sync_clock(void *data)
 {
-	struct etr_aib *sync_port;
-	struct clock_sync_data etr_sync;
+	static int first;
 	unsigned long long clock, old_clock, delay, delta;
-	int follows;
+	struct clock_sync_data *etr_sync;
+	struct etr_aib *sync_port, *aib;
+	int port;
 	int rc;
 
-	/* Check if the current aib is adjacent to the sync port aib. */
-	sync_port = (port == 0) ? &etr_port0 : &etr_port1;
-	follows = etr_aib_follows(sync_port, aib, port);
-	memcpy(sync_port, aib, sizeof(*aib));
-	if (!follows)
-		return -EAGAIN;
+	etr_sync = data;
 
-	/*
-	 * Catch all other cpus and make them wait until we have
-	 * successfully synced the clock. smp_call_function will
-	 * return after all other cpus are in etr_sync_cpu_start.
-	 */
-	memset(&etr_sync, 0, sizeof(etr_sync));
-	preempt_disable();
-	smp_call_function(clock_sync_cpu_start, &etr_sync, 0);
-	local_irq_disable();
+	if (xchg(&first, 1) == 1) {
+		/* Slave */
+		clock_sync_cpu(etr_sync);
+		return 0;
+	}
+
+	/* Wait until all other cpus entered the sync function. */
+	while (atomic_read(&etr_sync->cpus) != 0)
+		cpu_relax();
+
+	port = etr_sync->etr_port;
+	aib = etr_sync->etr_aib;
+	sync_port = (port == 0) ? &etr_port0 : &etr_port1;
 	enable_sync_clock();
 
 	/* Set clock to next OTE. */
@@ -725,16 +729,16 @@ static int etr_sync_clock(struct etr_aib
 		delay = (unsigned long long)
 			(aib->edf2.etv - sync_port->edf2.etv) << 32;
 		delta = adjust_time(old_clock, clock, delay);
-		etr_sync.fixup_cc = delta;
+		etr_sync->fixup_cc = delta;
 		fixup_clock_comparator(delta);
 		/* Verify that the clock is properly set. */
 		if (!etr_aib_follows(sync_port, aib, port)) {
 			/* Didn't work. */
 			disable_sync_clock(NULL);
-			etr_sync.in_sync = -EAGAIN;
+			etr_sync->in_sync = -EAGAIN;
 			rc = -EAGAIN;
 		} else {
-			etr_sync.in_sync = 1;
+			etr_sync->in_sync = 1;
 			rc = 0;
 		}
 	} else {
@@ -742,12 +746,33 @@ static int etr_sync_clock(struct etr_aib
 		__ctl_clear_bit(0, 29);
 		__ctl_clear_bit(14, 21);
 		disable_sync_clock(NULL);
-		etr_sync.in_sync = -EAGAIN;
+		etr_sync->in_sync = -EAGAIN;
 		rc = -EAGAIN;
 	}
-	local_irq_enable();
-	smp_call_function(clock_sync_cpu_end, NULL, 0);
-	preempt_enable();
+	xchg(&first, 0);
+	return rc;
+}
+
+static int etr_sync_clock_stop(struct etr_aib *aib, int port)
+{
+	struct clock_sync_data etr_sync;
+	struct etr_aib *sync_port;
+	int follows;
+	int rc;
+
+	/* Check if the current aib is adjacent to the sync port aib. */
+	sync_port = (port == 0) ? &etr_port0 : &etr_port1;
+	follows = etr_aib_follows(sync_port, aib, port);
+	memcpy(sync_port, aib, sizeof(*aib));
+	if (!follows)
+		return -EAGAIN;
+	memset(&etr_sync, 0, sizeof(etr_sync));
+	etr_sync.etr_aib = aib;
+	etr_sync.etr_port = port;
+	get_online_cpus();
+	atomic_set(&etr_sync.cpus, num_online_cpus() - 1);
+	rc = stop_machine(etr_sync_clock, &etr_sync, &cpu_online_map);
+	put_online_cpus();
 	return rc;
 }
 
@@ -904,7 +929,7 @@ static void etr_update_eacr(struct etr_e
 }
 
 /*
- * ETR tasklet. In this function you'll find the main logic. In
+ * ETR work. In this function you'll find the main logic. In
  * particular this is the only function that calls etr_update_eacr(),
  * it "controls" the etr control register.
  */
@@ -1037,7 +1062,7 @@ static void etr_work_fn(struct work_stru
 	etr_update_eacr(eacr);
 	set_bit(CLOCK_SYNC_ETR, &clock_sync_flags);
 	if (now < etr_tolec + (1600000 << 12) ||
-	    etr_sync_clock(&aib, sync_port) != 0) {
+	    etr_sync_clock_stop(&aib, sync_port) != 0) {
 		/* Sync failed. Try again in 1/2 second. */
 		eacr.es = 0;
 		etr_update_eacr(eacr);
@@ -1366,8 +1391,16 @@ static void __init stp_reset(void)
 
 static int __init stp_init(void)
 {
-	if (test_bit(CLOCK_SYNC_HAS_STP, &clock_sync_flags) && stp_online)
-		schedule_work(&stp_work);
+	int rc;
+
+	if (!test_bit(CLOCK_SYNC_HAS_STP, &clock_sync_flags))
+		return 0;
+	rc = stop_machine_get_threads();
+	if (rc)
+		return rc;
+	if (!stp_online)
+		return 0;
+	schedule_work(&stp_work);
 	return 0;
 }
 
@@ -1415,38 +1448,26 @@ void stp_island_check(void)
 	schedule_work(&stp_work);
 }
 
-/*
- * STP tasklet. Check for the STP state and take over the clock
- * synchronization if the STP clock source is usable.
- */
-static void stp_work_fn(struct work_struct *work)
+
+static int stp_sync_clock(void *data)
 {
-	struct clock_sync_data stp_sync;
+	static int first;
 	unsigned long long old_clock, delta;
+	struct clock_sync_data *stp_sync;
 	int rc;
 
-	if (!stp_online) {
-		chsc_sstpc(stp_page, STP_OP_CTRL, 0x0000);
-		return;
-	}
+	stp_sync = data;
 
-	rc = chsc_sstpc(stp_page, STP_OP_CTRL, 0xb0e0);
-	if (rc)
-		return;
+	if (xchg(&first, 1) == 1) {
+		/* Slave */
+		clock_sync_cpu(stp_sync);
+		return 0;
+	}
 
-	rc = chsc_sstpi(stp_page, &stp_info, sizeof(struct stp_sstpi));
-	if (rc || stp_info.c == 0)
-		return;
+	/* Wait until all other cpus entered the sync function. */
+	while (atomic_read(&stp_sync->cpus) != 0)
+		cpu_relax();
 
-	/*
-	 * Catch all other cpus and make them wait until we have
-	 * successfully synced the clock. smp_call_function will
-	 * return after all other cpus are in clock_sync_cpu_start.
-	 */
-	memset(&stp_sync, 0, sizeof(stp_sync));
-	preempt_disable();
-	smp_call_function(clock_sync_cpu_start, &stp_sync, 0);
-	local_irq_disable();
 	enable_sync_clock();
 
 	set_bit(CLOCK_SYNC_STP, &clock_sync_flags);
@@ -1470,16 +1491,43 @@ static void stp_work_fn(struct work_stru
 	}
 	if (rc) {
 		disable_sync_clock(NULL);
-		stp_sync.in_sync = -EAGAIN;
+		stp_sync->in_sync = -EAGAIN;
 		clear_bit(CLOCK_SYNC_STP, &clock_sync_flags);
 		if (etr_port0_online || etr_port1_online)
 			schedule_work(&etr_work);
 	} else
-		stp_sync.in_sync = 1;
+		stp_sync->in_sync = 1;
+	xchg(&first, 0);
+	return 0;
+}
+
+/*
+ * STP work. Check for the STP state and take over the clock
+ * synchronization if the STP clock source is usable.
+ */
+static void stp_work_fn(struct work_struct *work)
+{
+	struct clock_sync_data stp_sync;
+	int rc;
 
-	local_irq_enable();
-	smp_call_function(clock_sync_cpu_end, NULL, 0);
-	preempt_enable();
+	if (!stp_online) {
+		chsc_sstpc(stp_page, STP_OP_CTRL, 0x0000);
+		return;
+	}
+
+	rc = chsc_sstpc(stp_page, STP_OP_CTRL, 0xb0e0);
+	if (rc)
+		return;
+
+	rc = chsc_sstpi(stp_page, &stp_info, sizeof(struct stp_sstpi));
+	if (rc || stp_info.c == 0)
+		return;
+
+	memset(&stp_sync, 0, sizeof(stp_sync));
+	get_online_cpus();
+	atomic_set(&stp_sync.cpus, num_online_cpus() - 1);
+	stop_machine(stp_sync_clock, &stp_sync, &cpu_online_map);
+	put_online_cpus();
 }
 
 /*

-- 
