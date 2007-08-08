Return-Path: <linux-kernel-owner+w=401wt.eu-S1763847AbXHHHNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763847AbXHHHNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760005AbXHHHI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbXHHHI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:26 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7/25] [PATCH] interrupt related native paravirt functions.
Date: Wed,  8 Aug 2007 01:18:54 -0300
Message-Id: <11865467812610-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865467773012-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt initialization routine becomes native_init_IRQ and will
be overriden later in case paravirt is on.

The interrupt vector is made global, so paravirt guests can reference
it in their initializations. However, "interrupt" is such a common
name, and could lead to clashes, so it is renamed.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/i8259.c |   15 +++++++++++----
 include/asm-x86_64/irq.h   |    2 ++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86_64/kernel/i8259.c b/arch/x86_64/kernel/i8259.c
index 948cae6..8dda872 100644
--- a/arch/x86_64/kernel/i8259.c
+++ b/arch/x86_64/kernel/i8259.c
@@ -75,8 +75,12 @@ BUILD_16_IRQS(0xc) BUILD_16_IRQS(0xd) BUILD_16_IRQS(0xe) BUILD_16_IRQS(0xf)
 	IRQ(x,8), IRQ(x,9), IRQ(x,a), IRQ(x,b), \
 	IRQ(x,c), IRQ(x,d), IRQ(x,e), IRQ(x,f)
 
-/* for the irq vectors */
-static void (*interrupt[NR_VECTORS - FIRST_EXTERNAL_VECTOR])(void) = {
+/*
+ * For the irq vectors. It is global rather than static to allow for
+ * paravirtualized guests to use it in their own interrupt initialization
+ * routines
+ */
+void (*interrupt_vector[NR_VECTORS - FIRST_EXTERNAL_VECTOR])(void) = {
 					  IRQLIST_16(0x2), IRQLIST_16(0x3),
 	IRQLIST_16(0x4), IRQLIST_16(0x5), IRQLIST_16(0x6), IRQLIST_16(0x7),
 	IRQLIST_16(0x8), IRQLIST_16(0x9), IRQLIST_16(0xa), IRQLIST_16(0xb),
@@ -484,7 +488,10 @@ static int __init init_timer_sysfs(void)
 
 device_initcall(init_timer_sysfs);
 
-void __init init_IRQ(void)
+/* Overridden in paravirt.c */
+void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
+
+void __init native_init_IRQ(void)
 {
 	int i;
 
@@ -497,7 +504,7 @@ void __init init_IRQ(void)
 	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
 		if (vector != IA32_SYSCALL_VECTOR)
-			set_intr_gate(vector, interrupt[i]);
+			set_intr_gate(vector, interrupt_vector[i]);
 	}
 
 #ifdef CONFIG_SMP
diff --git a/include/asm-x86_64/irq.h b/include/asm-x86_64/irq.h
index 5006c6e..be55299 100644
--- a/include/asm-x86_64/irq.h
+++ b/include/asm-x86_64/irq.h
@@ -46,6 +46,8 @@ static __inline__ int irq_canonicalize(int irq)
 extern void fixup_irqs(cpumask_t map);
 #endif
 
+void native_init_IRQ(void);
+
 #define __ARCH_HAS_DO_SOFTIRQ 1
 
 #endif /* _ASM_IRQ_H */
-- 
1.4.4.2

