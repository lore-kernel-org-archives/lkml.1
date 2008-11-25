Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbYKYVZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbYKYVZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYKYVZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:25:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:40166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYKYVZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:25:00 -0500
Date: Tue, 25 Nov 2008 13:26:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mpm@selenic.com, akpm@linux-foundation.org
Subject: [PATCH] random: add a way to get some random bits into the entropy
 pools early on
Message-ID: <20081125132600.5112fb24@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5b3b09ac82316c2d4000460d586ebe59303c12c2 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 25 Nov 2008 11:41:37 -0800
Subject: [PATCH] random: add a way to get some random bits into the entropy pools early on

currently the entropy pool gets seeded on the module_init() level, but there
is at least one consumer of random bits (the oops ID that is printed as part
of the oops).
As a result of this, kerneloops.org is seeing a lot of oopses that all share
the same 'random' number; which used to get filed away as "duplicate".

This patch adds a function to the random driver so that various pieces of
the kernel can add random bits (but not entropy!) to the pool, to avoid
this dupicate ID problem.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/apic.c |    7 +++++++
 drivers/char/random.c  |   29 +++++++++++++++++++++++++++++
 include/linux/random.h |    3 +++
 kernel/panic.c         |    1 +
 4 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 04a7f96..11f7c7d 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/dmi.h>
 #include <linux/dmar.h>
+#include <linux/random.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -691,6 +692,12 @@ static int __init calibrate_APIC_clock(void)
 	} else
 		local_irq_enable();
 
+	/*
+	 * by now we have enough time spent that there is some value in
+	 * pushing the timestamp to the random pools for early kernel use.
+	 */
+	seed_random_pools();
+
 	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
 		printk(KERN_WARNING
 		       "APIC timer disabled due to verification failure.\n");
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 675076f..236d285 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -929,6 +929,35 @@ static int rand_initialize(void)
 }
 module_init(rand_initialize);
 
+/*
+ * seed_std_data - seed pool with system timing data
+ *
+ * @r: pool to initialize
+ *
+ * This function mixes some system data into the pool to prepare it for use.
+ * This function can be called really early during boot to at least get some
+ * randomness from the system if random numbers are needed early, for example
+ * as part of the early oops printing.
+ *
+ * No entropy is credited for this seeding.
+ */
+static void seed_std_data(struct entropy_store *r)
+{
+	ktime_t now;
+	unsigned long flags;
+
+	now = ktime_get_real();
+	mix_pool_bytes(r, &now, sizeof(now));
+}
+
+int seed_random_pools(void)
+{
+	seed_std_data(&input_pool);
+	seed_std_data(&blocking_pool);
+	seed_std_data(&nonblocking_pool);
+	return 0;
+}
+
 void rand_initialize_irq(int irq)
 {
 	struct timer_rand_state *state;
diff --git a/include/linux/random.h b/include/linux/random.h
index 36f125c..d23d284 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -72,6 +72,9 @@ unsigned long randomize_range(unsigned long start, unsigned long end, unsigned l
 u32 random32(void);
 void srandom32(u32 seed);
 
+int seed_random_pools(void);
+
+
 #endif /* __KERNEL___ */
 
 #endif /* _LINUX_RANDOM_H */
diff --git a/kernel/panic.c b/kernel/panic.c
index 6513aac..d71b167 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -295,6 +295,7 @@ static u64 oops_id;
 
 static int init_oops_id(void)
 {
+	seed_random_pools();
 	if (!oops_id)
 		get_random_bytes(&oops_id, sizeof(oops_id));
 
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
