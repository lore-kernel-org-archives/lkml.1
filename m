Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0BQQu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:50:56 -0500
Received: from relay3.sgi.com ([192.48.152.1]:56289 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751846Ab0BQQuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:50:55 -0500
Date: Wed, 17 Feb 2010 10:50:50 -0600
From: Russ Anderson <rja@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: Russ Anderson <rja@sgi.com>
Subject: [PATCH] x86: Enable NMI on all cpus on UV
Message-ID: <20100217165049.GA26331@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable NMI on all cpus in UV system and add an NMI handler
to dump_stack on each cpu.

Signed-off-by: Russ Anderson <rja@sgi.com>

---

By default on x86 all the cpus except the boot cpu have NMI
masked off.  This patch enables NMI on all cpus in UV system
and adds an NMI handler to dump_stack on each cpu.  This
way if a system hangs we can NMI the machine and get a 
backtrace from all the cpus.


 arch/x86/include/asm/uv/uv.h       |    1 
 arch/x86/kernel/apic/x2apic_uv_x.c |   49 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c          |    2 +
 3 files changed, 52 insertions(+)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-02-17 10:21:55.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-02-17 10:32:20.000000000 -0600
@@ -20,6 +20,7 @@
 #include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/kdebug.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -39,6 +40,53 @@ static u64 gru_start_paddr, gru_end_padd
 int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
 
+int uv_handle_nmi(struct notifier_block *self,
+		  unsigned long reason, void *data)
+{
+	unsigned long flags;
+	static DEFINE_SPINLOCK(uv_nmi_lock);
+
+	if (reason != DIE_NMI_IPI)
+		return NOTIFY_OK;
+	/*
+	 * Use a lock so only one cpu prints at a time
+	 * to prevent intermixed output.
+	 */
+	spin_lock_irqsave(&uv_nmi_lock, flags);
+	printk(KERN_INFO "NMI stack dump cpu %u:\n",
+				smp_processor_id());
+	dump_stack();
+	spin_unlock_irqrestore(&uv_nmi_lock, flags);
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block uv_dump_stack_nmi_nb = {
+  .notifier_call = uv_handle_nmi,
+  .next = NULL,
+  .priority = 0
+};
+
+void uv_register_nmi_notifier(void)
+{
+	if (register_die_notifier(&uv_dump_stack_nmi_nb))
+		printk(KERN_WARNING "UV NMI handler failed to register\n");
+}
+
+/*
+ * Called on each cpu to unmask NMI.
+ */
+void __cpuinit uv_nmi_init(void)
+{
+	unsigned int value;
+
+	/*
+	 * Unmask NMI on all cpus
+	 */
+	value = apic_read(APIC_LVT1) | APIC_DM_NMI;
+	value &= ~APIC_LVT_MASKED;
+	apic_write(APIC_LVT1, value);
+}
 
 static int is_GRU_range(u64 start, u64 end)
 {
@@ -718,5 +766,6 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
+	uv_register_nmi_notifier();
 	proc_mkdir("sgi_uv", NULL);
 }
Index: linux/arch/x86/include/asm/uv/uv.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv.h	2010-02-17 10:21:55.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv.h	2010-02-17 10:32:20.000000000 -0600
@@ -11,6 +11,7 @@ struct mm_struct;
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
+extern void uv_nmi_init(void);
 extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
Index: linux/arch/x86/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86/kernel/smpboot.c	2010-02-17 10:21:55.000000000 -0600
+++ linux/arch/x86/kernel/smpboot.c	2010-02-17 10:32:20.000000000 -0600
@@ -320,6 +320,8 @@ notrace static void __cpuinit start_seco
 	unlock_vector_lock();
 	ipi_call_unlock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+	if (is_uv_system())
+		uv_nmi_init();
 
 	/* enable local interrupts */
 	local_irq_enable();
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
