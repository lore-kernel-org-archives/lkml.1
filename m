Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbZAIKtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbZAIKtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZAIKsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:48:54 -0500
Received: from ozlabs.org ([203.10.76.45]:44383 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZAIKsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:48:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.11125.554464.391290@cargo.ozlabs.ibm.com>
Date: Fri, 9 Jan 2009 21:48:21 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/9] powerpc: Provide a way to defer perf counter work until interrupts are enabled
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because 64-bit powerpc uses lazy (soft) interrupt disabling, it is
possible for a performance monitor exception to come in when the
kernel thinks interrupts are disabled (i.e. when they are
soft-disabled but hard-enabled).  In such a situation the performance
monitor exception handler might have some processing to do (such as
process wakeups) which can't be done in what is effectively an NMI
handler.

This provides a way to defer that work until interrupts get enabled,
either in raw_local_irq_restore() or by returning from an interrupt
handler to code that had interrupts enabled.  We have a per-processor
flag that indicates that there is work pending to do when interrupts
subsequently get re-enabled.  This flag is checked in the interrupt
return path and in raw_local_irq_restore(), and if it is set,
perf_counter_do_pending() is called to do the pending work.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index f75a5fc..e10f151 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -131,5 +131,36 @@ static inline int irqs_disabled_flags(unsigned long flags)
  */
 struct hw_interrupt_type;
 
+#ifdef CONFIG_PERF_COUNTERS
+static inline unsigned long get_perf_counter_pending(void)
+{
+	unsigned long x;
+
+	asm volatile("lbz %0,%1(13)"
+		: "=r" (x)
+		: "i" (offsetof(struct paca_struct, perf_counter_pending)));
+	return x;
+}
+
+static inline void set_perf_counter_pending(int x)
+{
+	asm volatile("stb %0,%1(13)" : :
+		"r" (x),
+		"i" (offsetof(struct paca_struct, perf_counter_pending)));
+}
+
+extern void perf_counter_do_pending(void);
+
+#else
+
+static inline unsigned long get_perf_counter_pending(void)
+{
+	return 0;
+}
+
+static inline void set_perf_counter_pending(int x) {}
+static inline void perf_counter_do_pending(void) {}
+#endif /* CONFIG_PERF_COUNTERS */
+
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_HW_IRQ_H */
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 082b3ae..6ef0557 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -99,6 +99,7 @@ struct paca_struct {
 	u8 soft_enabled;		/* irq soft-enable flag */
 	u8 hard_enabled;		/* set if irqs are enabled in MSR */
 	u8 io_sync;			/* writel() needs spin_unlock sync */
+	u8 perf_counter_pending;	/* PM interrupt while soft-disabled */
 
 	/* Stuff for accurate time accounting */
 	u64 user_time;			/* accumulated usermode TB ticks */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 661d07d..cea4629 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -127,6 +127,7 @@ int main(void)
 	DEFINE(PACAKMSR, offsetof(struct paca_struct, kernel_msr));
 	DEFINE(PACASOFTIRQEN, offsetof(struct paca_struct, soft_enabled));
 	DEFINE(PACAHARDIRQEN, offsetof(struct paca_struct, hard_enabled));
+	DEFINE(PACAPERFPEND, offsetof(struct paca_struct, perf_counter_pending));
 	DEFINE(PACASLBCACHE, offsetof(struct paca_struct, slb_cache));
 	DEFINE(PACASLBCACHEPTR, offsetof(struct paca_struct, slb_cache_ptr));
 	DEFINE(PACACONTEXTID, offsetof(struct paca_struct, context.id));
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 383ed6e..f30b4e5 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -526,6 +526,15 @@ ALT_FW_FTR_SECTION_END_IFCLR(FW_FEATURE_ISERIES)
 2:
 	TRACE_AND_RESTORE_IRQ(r5);
 
+#ifdef CONFIG_PERF_COUNTERS
+	/* check paca->perf_counter_pending if we're enabling ints */
+	lbz	r3,PACAPERFPEND(r13)
+	and.	r3,r3,r5
+	beq	27f
+	bl	.perf_counter_do_pending
+27:
+#endif /* CONFIG_PERF_COUNTERS */
+
 	/* extract EE bit and use it to restore paca->hard_enabled */
 	ld	r3,_MSR(r1)
 	rldicl	r4,r3,49,63		/* r0 = (r3 >> 15) & 1 */
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index ac222d0..4efb886 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -104,6 +104,13 @@ static inline notrace void set_soft_enabled(unsigned long enable)
 	: : "r" (enable), "i" (offsetof(struct paca_struct, soft_enabled)));
 }
 
+#ifdef CONFIG_PERF_COUNTERS
+notrace void __weak perf_counter_do_pending(void)
+{
+	set_perf_counter_pending(0);
+}
+#endif
+
 notrace void raw_local_irq_restore(unsigned long en)
 {
 	/*
@@ -135,6 +142,9 @@ notrace void raw_local_irq_restore(unsigned long en)
 			iseries_handle_interrupts();
 	}
 
+	if (get_perf_counter_pending())
+		perf_counter_do_pending();
+
 	/*
 	 * if (get_paca()->hard_enabled) return;
 	 * But again we need to take care that gcc gets hard_enabled directly
