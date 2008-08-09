Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbYHIWNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbYHIWNh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYHIWN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:13:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44932 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbYHIWNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:13:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai.lu@amd.com>,
       Andi Kleen <ak@suse.de>, Glauber Costa <gcosta@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 09 Aug 2008 15:09:02 -0700
Message-ID: <m11w0xu9hd.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] [PATCH] x86:  Restore proper vector locking during cpu hotplug
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Having cpu_online_map change during assign_irq_vector can result
in some really nasty and weird things happening.  The one that
bit me last time was accessing non existent per cpu memory for non
existent cpus.

This locking was removed in a sloppy x86_64 and x86_32 merge patch.

Guys can we please try and avoid subtly breaking x86 when we are
merging files together?

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/io_apic_32.c |    6 +-----
 arch/x86/kernel/io_apic_64.c |   25 +++++++++++++++----------
 arch/x86/kernel/smpboot.c    |   12 +++++++++---
 include/asm-x86/hw_irq.h     |   12 ++++++++++--
 4 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index de9aa0e..09cddb5 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -57,7 +57,7 @@ atomic_t irq_mis_count;
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 
 static DEFINE_SPINLOCK(ioapic_lock);
-static DEFINE_SPINLOCK(vector_lock);
+DEFINE_SPINLOCK(vector_lock);
 
 int timer_through_8259 __initdata;
 
@@ -1209,10 +1209,6 @@ static int assign_irq_vector(int irq)
 	return vector;
 }
 
-void setup_vector_irq(int cpu)
-{
-}
-
 static struct irq_chip ioapic_chip;
 
 #define IOAPIC_AUTO	-1
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 8269434..61a83b7 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -101,7 +101,7 @@ int timer_through_8259 __initdata;
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 
 static DEFINE_SPINLOCK(ioapic_lock);
-DEFINE_SPINLOCK(vector_lock);
+static DEFINE_SPINLOCK(vector_lock);
 
 /*
  * # of IRQ routing registers
@@ -697,6 +697,19 @@ static int pin_2_irq(int idx, int apic, int pin)
 	return irq;
 }
 
+void lock_vector_lock(void)
+{
+	/* Used to the online set of cpus does not change
+	 * during assign_irq_vector.
+	 */
+	spin_lock(&vector_lock);
+}
+
+void unlock_vector_lock(void)
+{
+	spin_unlock(&vector_lock);
+}
+
 static int __assign_irq_vector(int irq, cpumask_t mask)
 {
 	/*
@@ -802,7 +815,7 @@ static void __clear_irq_vector(int irq)
 	cpus_clear(cfg->domain);
 }
 
-static void __setup_vector_irq(int cpu)
+void __setup_vector_irq(int cpu)
 {
 	/* Initialize vector_irq on a new cpu */
 	/* This function must be called with vector_lock held */
@@ -825,14 +838,6 @@ static void __setup_vector_irq(int cpu)
 	}
 }
 
-void setup_vector_irq(int cpu)
-{
-	spin_lock(&vector_lock);
-	__setup_vector_irq(smp_processor_id());
-	spin_unlock(&vector_lock);
-}
-
-
 static struct irq_chip ioapic_chip;
 
 static void ioapic_register_intr(int irq, unsigned long trigger)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3325127..da10f07 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -326,12 +326,16 @@ static void __cpuinit start_secondary(void *unused)
 	 * for which cpus receive the IPI. Holding this
 	 * lock helps us to not include this cpu in a currently in progress
 	 * smp_call_function().
+	 *
+	 * We need to hold vector_lock so there the set of online cpus
+	 * does not change while we are assigning vectors to cpus.  Holding
+	 * this lock ensures we don't half assign or remove an irq from a cpu.
 	 */
 	ipi_call_lock_irq();
-#ifdef CONFIG_X86_IO_APIC
-	setup_vector_irq(smp_processor_id());
-#endif
+	lock_vector_lock();
+	__setup_vector_irq(smp_processor_id());
 	cpu_set(smp_processor_id(), cpu_online_map);
+	unlock_vector_lock();
 	ipi_call_unlock_irq();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 
@@ -1336,7 +1340,9 @@ int __cpu_disable(void)
 	remove_siblinginfo(cpu);
 
 	/* It's now safe to remove this processor from the online map */
+	lock_vector_lock();
 	remove_cpu_from_maps(cpu);
+	unlock_vector_lock();
 	fixup_irqs(cpu_online_map);
 	return 0;
 }
diff --git a/include/asm-x86/hw_irq.h b/include/asm-x86/hw_irq.h
index 77ba51d..edd0b95 100644
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -98,9 +98,17 @@ extern void (*const interrupt[NR_IRQS])(void);
 #else
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
-extern spinlock_t vector_lock;
 #endif
-extern void setup_vector_irq(int cpu);
+
+#if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_X86_64)
+extern void lock_vector_lock(void);
+extern void unlock_vector_lock(void);
+extern void __setup_vector_irq(int cpu);
+#else
+static inline void lock_vector_lock(void) {}
+static inline void unlock_vector_lock(void) {}
+static inline void __setup_vector_irq(int cpu) {}
+#endif
 
 #endif /* !ASSEMBLY_ */
 
-- 
1.5.3.rc6.17.g1911

