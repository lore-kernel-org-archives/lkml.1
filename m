Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbYGHXTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbYGHXTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbYGHXOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:48 -0400
Received: from gw.goop.org ([64.81.55.164]:51213 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbYGHXOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 20 of 55] x86_64: add workaround for no %gs-based percpu
X-Mercurial-Node: ff02968a6b0b75b55b166b12b3127761b254bacf
Message-Id: <ff02968a6b0b75b55b16.1215554802@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a stopgap until Mike Travis's x86-64 gs-based percpu patches are
ready, provide workaround functions for x86_read/write_percpu for
Xen's use.

Specifically, this means that we can't really make use of vcpu
placement, because we can't use a single gs-based memory access to get
to vcpu fields.  So disable all that for now.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/head64.c |   11 ++++++++---
 arch/x86/xen/enlighten.c |    5 +++++
 include/asm-x86/percpu.h |   26 ++++++++++++++++++++++++++
 include/asm-x86/setup.h  |    1 +
 4 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -38,6 +38,13 @@
 #else
 static struct x8664_pda *__cpu_pda[NR_CPUS] __read_mostly;
 #endif
+
+void __init x86_64_init_pda(void)
+{
+	_cpu_pda = __cpu_pda;
+	cpu_pda(0) = &_boot_cpu_pda;
+	pda_init(0);
+}
 
 static void __init zap_identity_mappings(void)
 {
@@ -102,9 +109,7 @@
 
 	early_printk("Kernel alive\n");
 
-	_cpu_pda = __cpu_pda;
-	cpu_pda(0) = &_boot_cpu_pda;
-	pda_init(0);
+	x86_64_init_pda();
 
 	early_printk("Kernel really alive\n");
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -971,6 +971,7 @@
 
 	/* xen_vcpu_setup managed to place the vcpu_info within the
 	   percpu area for all cpus, so make use of it */
+#ifdef CONFIG_X86_32
 	if (have_vcpu_info_placement) {
 		printk(KERN_INFO "Xen: using vcpu_info placement\n");
 
@@ -980,6 +981,7 @@
 		pv_irq_ops.irq_enable = xen_irq_enable_direct;
 		pv_mmu_ops.read_cr2 = xen_read_cr2_direct;
 	}
+#endif
 }
 
 static unsigned xen_patch(u8 type, u16 clobbers, void *insnbuf,
@@ -1000,10 +1002,12 @@
 	goto patch_site
 
 	switch (type) {
+#ifdef CONFIG_X86_32
 		SITE(pv_irq_ops, irq_enable);
 		SITE(pv_irq_ops, irq_disable);
 		SITE(pv_irq_ops, save_fl);
 		SITE(pv_irq_ops, restore_fl);
+#endif /* CONFIG_X86_32 */
 #undef SITE
 
 	patch_site:
@@ -1323,6 +1327,7 @@
 #ifdef CONFIG_X86_64
 	/* Disable until direct per-cpu data access. */
 	have_vcpu_info_placement = 0;
+	x86_64_init_pda();
 #endif
 
 	xen_smp_init();
diff --git a/include/asm-x86/percpu.h b/include/asm-x86/percpu.h
--- a/include/asm-x86/percpu.h
+++ b/include/asm-x86/percpu.h
@@ -21,6 +21,32 @@
 #include <asm-generic/percpu.h>
 
 DECLARE_PER_CPU(struct x8664_pda, pda);
+
+/*
+ * These are supposed to be implemented as a single instruction which
+ * operates on the per-cpu data base segment.  x86-64 doesn't have
+ * that yet, so this is a fairly inefficient workaround for the
+ * meantime.  The single instruction is atomic with respect to
+ * preemption and interrupts, so we need to explicitly disable
+ * interrupts here to achieve the same effect.  However, because it
+ * can be used from within interrupt-disable/enable, we can't actually
+ * disable interrupts; disabling preemption is enough.
+ */
+#define x86_read_percpu(var)						\
+	({								\
+		typeof(per_cpu_var(var)) __tmp;				\
+		preempt_disable();					\
+		__tmp = __get_cpu_var(var);				\
+		preempt_enable();					\
+		__tmp;							\
+	})
+
+#define x86_write_percpu(var, val)					\
+	do {								\
+		preempt_disable();					\
+		__get_cpu_var(var) = (val);				\
+		preempt_enable();					\
+	} while(0)
 
 #else /* CONFIG_X86_64 */
 
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -57,6 +57,7 @@
 extern unsigned long init_pg_tables_end;
 
 #else
+void __init x86_64_init_pda(void);
 void __init x86_64_start_kernel(char *real_mode);
 void __init x86_64_start_reservations(char *real_mode_data);
 


