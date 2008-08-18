Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYHRVxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYHRVxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbYHRVuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:50:18 -0400
Received: from adsl-69-107-80-255.dsl.pltn13.pacbell.net ([69.107.80.255]:45361
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753837AbYHRVuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:50:09 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 9 of 9] smp function calls: add kernel parameter to disable
	multiple queues
X-Mercurial-Node: 550e974a4de69f976426e6f4072c3132de5b81c8
Message-Id: <550e974a4de69f976426.1219083826@localhost>
In-Reply-To: <patchbomb.1219083817@localhost>
Date: Mon, 18 Aug 2008 11:23:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was some concern that using multiple queues - and their
associated APIC vectors - may trigger bugs in various dubious APIC
implementations.  This patch adds a command line option to force the
kernel to use a single queue, even if the architecture can support
more.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 Documentation/kernel-parameters.txt |    5 +++++
 arch/x86/kernel/smp.c               |    2 +-
 arch/x86/xen/smp.c                  |    6 ++++--
 include/linux/smp.h                 |   26 ++++++++++++++++++++++++++
 kernel/smp.c                        |   14 +++++++++++++-
 5 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1901,6 +1901,11 @@
 	simeth=		[IA-64]
 	simscsi=
 
+	single_ipi_queue [X86]
+			Force the use of a single queue for smp function calls.
+			This means that only a single vector is used, which may avoid
+			bugs in some APIC implementations.
+
 	slram=		[HW,MTD]
 
 	slub_debug[=options[,slabs]]	[MM, SLUB]
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -129,7 +129,7 @@
 void native_send_call_func_ipi(cpumask_t mask)
 {
 	cpumask_t allbutself;
-	unsigned queue = smp_processor_id() % CONFIG_GENERIC_SMP_QUEUES;
+	unsigned queue = smp_ipi_choose_queue();
 
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -373,7 +373,7 @@
 static void xen_smp_send_call_function_ipi(cpumask_t mask)
 {
 	int cpu;
-	unsigned queue = smp_processor_id() % CONFIG_GENERIC_SMP_QUEUES;
+	unsigned queue = smp_ipi_choose_queue();
 
 	/*
 	 * We can't afford to allocate N callfunc vectors * M cpu
@@ -411,10 +411,12 @@
 	unsigned queue;
 
 	irq_enter();
+
 	queue = start_queue;
 	do {
 		generic_smp_call_function_interrupt(queue);
-		queue = (queue + 1) % CONFIG_GENERIC_SMP_QUEUES;
+		if (++queue == smp_ipi_nqueues())
+			queue = 0;
 	} while(queue != start_queue);
 
 #ifdef CONFIG_X86_32
diff --git a/include/linux/smp.h b/include/linux/smp.h
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -170,4 +170,30 @@
 
 void smp_setup_processor_id(void);
 
+#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
+extern bool __read_mostly smp_single_ipi_queue;
+
+static inline unsigned smp_ipi_nqueues(void)
+{
+	unsigned nqueues = 1;
+
+#ifdef CONFIG_GENERIC_SMP_QUEUES
+	nqueues = CONFIG_GENERIC_SMP_QUEUES;
+#endif
+
+	return nqueues;
+}
+
+static inline unsigned smp_ipi_choose_queue(void)
+{
+	unsigned cpu = smp_processor_id();
+	unsigned nqueues = smp_ipi_nqueues();
+
+	if (nqueues == 1 || smp_single_ipi_queue)
+		return 0;
+
+	return cpu % nqueues;
+}
+#endif
+
 #endif /* __LINUX_SMP_H */
diff --git a/kernel/smp.c b/kernel/smp.c
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -10,6 +10,8 @@
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
 #include <linux/smp.h>
+
+bool __read_mostly smp_single_ipi_queue = false;
 
 #ifdef CONFIG_GENERIC_SMP_QUEUES
 #define	NQUEUES	CONFIG_GENERIC_SMP_QUEUES
@@ -347,7 +349,7 @@
 	cpus_and(mask, mask, allbutself);
 	num_cpus = cpus_weight(mask);
 
-	queue_no = cpu % NQUEUES;
+	queue_no = smp_ipi_choose_queue();
 	queue = &call_function_queues[queue_no];
 
 	/*
@@ -466,6 +468,16 @@
 		spin_lock_init(&call_function_queues[i].lock);
 	}
 
+	printk(KERN_INFO "smp function calls: using %d/%d queues\n",
+	       smp_ipi_nqueues(), NQUEUES);
+
 	return 0;
 }
 early_initcall(init_smp_function_call);
+
+static __init int set_single_ipi_queue(char *str)
+{
+	smp_single_ipi_queue = true;
+	return 0;
+}
+early_param("single_ipi_queue", set_single_ipi_queue);


