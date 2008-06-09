Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbYFIOVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbYFIOVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760588AbYFIOS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760516AbYFIOSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:54 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 09/15] x86: change __setup_vector_irq with setup_vector_irq
Date: Mon,  9 Jun 2008 11:16:52 -0300
Message-Id: <1213021018-14159-10-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-9-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
 <1213021018-14159-9-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We create a version of it for i386, and then take the CONFIG_X86_64
ifdef out of the game. We could create a __setup_vector_irq for i386,
but it would incur in an unnecessary lock taking. Moreover, it is better
practice to only export setup_vector_irq anyway.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/io_apic_32.c |    5 +++++
 arch/x86/kernel/io_apic_64.c |    9 ++++++++-
 arch/x86/kernel/smpboot.c    |   11 ++---------
 include/asm-x86/hw_irq.h     |    2 +-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 9dbe7e9..7fc071f 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1209,6 +1209,11 @@ static int assign_irq_vector(int irq)
 
 	return vector;
 }
+
+void setup_vector_irq(int cpu)
+{
+}
+
 static struct irq_chip ioapic_chip;
 
 #define IOAPIC_AUTO	-1
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 5ea376d..97d67c9 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -780,7 +780,7 @@ static void __clear_irq_vector(int irq)
 	cpus_clear(cfg->domain);
 }
 
-void __setup_vector_irq(int cpu)
+static void __setup_vector_irq(int cpu)
 {
 	/* Initialize vector_irq on a new cpu */
 	/* This function must be called with vector_lock held */
@@ -803,6 +803,13 @@ void __setup_vector_irq(int cpu)
 	}
 }
 
+void setup_vector_irq(int cpu)
+{
+	spin_lock(&vector_lock);
+	__setup_vector_irq(smp_processor_id());
+	spin_unlock(&vector_lock);
+}
+
 
 static struct irq_chip ioapic_chip;
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 50d307e..9d8dfec 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -329,15 +329,8 @@ static void __cpuinit start_secondary(void *unused)
 	 * smp_call_function().
 	 */
 	lock_ipi_call_lock();
-#ifdef CONFIG_X86_64
-	spin_lock(&vector_lock);
-
-	/* Setup the per cpu irq handling data structures */
-	__setup_vector_irq(smp_processor_id());
-	/*
-	 * Allow the master to continue.
-	 */
-	spin_unlock(&vector_lock);
+#ifdef CONFIG_X86_IO_APIC
+	setup_vector_irq(smp_processor_id());
 #endif
 	cpu_set(smp_processor_id(), cpu_online_map);
 	unlock_ipi_call_lock();
diff --git a/include/asm-x86/hw_irq.h b/include/asm-x86/hw_irq.h
index 1428b41..18f067c 100644
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -97,9 +97,9 @@ extern void (*const interrupt[NR_IRQS])(void);
 #else
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
-extern void __setup_vector_irq(int cpu);
 extern spinlock_t vector_lock;
 #endif
+extern void setup_vector_irq(int cpu);
 
 #endif /* !ASSEMBLY_ */
 
-- 
1.5.4.5

