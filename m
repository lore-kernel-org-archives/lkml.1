Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZLCV1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZLCV1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZLCV1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:27:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37084 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbZLCV1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:27:14 -0500
Date: Thu, 3 Dec 2009 22:27:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uv for v2.6.33
Message-ID: <20091203212704.GA28163@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-uv-for-linus

 Thanks,

	Ingo

------------------>
Dimitri Sivanich (5):
      x86: UV RTC: Fix early expiry handling
      x86: UV RTC: Add clocksource only boot option
      x86: UV RTC: Clean up error handling
      x86: UV RTC: Rename generic_interrupt to x86_platform_ipi
      x86: UV RTC: Always enable RTC clocksource


 arch/x86/include/asm/entry_arch.h  |    2 +-
 arch/x86/include/asm/hardirq.h     |    2 +-
 arch/x86/include/asm/hw_irq.h      |    4 +-
 arch/x86/include/asm/irq.h         |    2 +-
 arch/x86/include/asm/irq_vectors.h |    2 +-
 arch/x86/kernel/entry_64.S         |    4 +-
 arch/x86/kernel/irq.c              |   20 ++++----
 arch/x86/kernel/irqinit.c          |    4 +-
 arch/x86/kernel/uv_time.c          |   80 ++++++++++++++++++++++--------------
 9 files changed, 69 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index f5693c8..8e8ec66 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -34,7 +34,7 @@ BUILD_INTERRUPT3(invalidate_interrupt7,INVALIDATE_TLB_VECTOR_START+7,
 		 smp_invalidate_interrupt)
 #endif
 
-BUILD_INTERRUPT(generic_interrupt, GENERIC_INTERRUPT_VECTOR)
+BUILD_INTERRUPT(x86_platform_ipi, X86_PLATFORM_IPI_VECTOR)
 
 /*
  * every pentium local APIC has two 'local interrupts', with a
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 82e3e8f..beaabd7 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -12,7 +12,7 @@ typedef struct {
 	unsigned int apic_timer_irqs;	/* arch dependent */
 	unsigned int irq_spurious_count;
 #endif
-	unsigned int generic_irqs;	/* arch dependent */
+	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
 	unsigned int apic_pending_irqs;
 #ifdef CONFIG_SMP
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index ba180d9..95207ca 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -27,7 +27,7 @@
 
 /* Interrupt handlers registered during init_IRQ */
 extern void apic_timer_interrupt(void);
-extern void generic_interrupt(void);
+extern void x86_platform_ipi(void);
 extern void error_interrupt(void);
 extern void perf_pending_interrupt(void);
 
@@ -101,7 +101,7 @@ extern void eisa_set_level_irq(unsigned int irq);
 /* SMP */
 extern void smp_apic_timer_interrupt(struct pt_regs *);
 extern void smp_spurious_interrupt(struct pt_regs *);
-extern void smp_generic_interrupt(struct pt_regs *);
+extern void smp_x86_platform_ipi(struct pt_regs *);
 extern void smp_error_interrupt(struct pt_regs *);
 #ifdef CONFIG_X86_IO_APIC
 extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ddda6cb..fcbc6d1 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -36,7 +36,7 @@ static inline int irq_canonicalize(int irq)
 extern void fixup_irqs(void);
 #endif
 
-extern void (*generic_interrupt_extension)(void);
+extern void (*x86_platform_ipi_callback)(void);
 extern void native_init_IRQ(void);
 extern bool handle_irq(unsigned irq, struct pt_regs *regs);
 
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 5b21f0e..6a635bd 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -106,7 +106,7 @@
 /*
  * Generic system vector for platform specific use
  */
-#define GENERIC_INTERRUPT_VECTOR	0xed
+#define X86_PLATFORM_IPI_VECTOR		0xed
 
 /*
  * Performance monitoring pending work vector:
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b5c061f..6714432 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -969,8 +969,8 @@ apicinterrupt UV_BAU_MESSAGE \
 #endif
 apicinterrupt LOCAL_TIMER_VECTOR \
 	apic_timer_interrupt smp_apic_timer_interrupt
-apicinterrupt GENERIC_INTERRUPT_VECTOR \
-	generic_interrupt smp_generic_interrupt
+apicinterrupt X86_PLATFORM_IPI_VECTOR \
+	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_SMP
 apicinterrupt INVALIDATE_TLB_VECTOR_START+0 \
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3912061..9375dce 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -18,7 +18,7 @@
 atomic_t irq_err_count;
 
 /* Function pointer for generic interrupt vector handling */
-void (*generic_interrupt_extension)(void) = NULL;
+void (*x86_platform_ipi_callback)(void) = NULL;
 
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
@@ -72,10 +72,10 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_pending_irqs);
 	seq_printf(p, "  Performance pending work\n");
 #endif
-	if (generic_interrupt_extension) {
+	if (x86_platform_ipi_callback) {
 		seq_printf(p, "%*s: ", prec, "PLT");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", irq_stats(j)->generic_irqs);
+			seq_printf(p, "%10u ", irq_stats(j)->x86_platform_ipis);
 		seq_printf(p, "  Platform interrupts\n");
 	}
 #ifdef CONFIG_SMP
@@ -187,8 +187,8 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->apic_perf_irqs;
 	sum += irq_stats(cpu)->apic_pending_irqs;
 #endif
-	if (generic_interrupt_extension)
-		sum += irq_stats(cpu)->generic_irqs;
+	if (x86_platform_ipi_callback)
+		sum += irq_stats(cpu)->x86_platform_ipis;
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
 	sum += irq_stats(cpu)->irq_call_count;
@@ -252,9 +252,9 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 }
 
 /*
- * Handler for GENERIC_INTERRUPT_VECTOR.
+ * Handler for X86_PLATFORM_IPI_VECTOR.
  */
-void smp_generic_interrupt(struct pt_regs *regs)
+void smp_x86_platform_ipi(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -264,10 +264,10 @@ void smp_generic_interrupt(struct pt_regs *regs)
 
 	irq_enter();
 
-	inc_irq_stat(generic_irqs);
+	inc_irq_stat(x86_platform_ipis);
 
-	if (generic_interrupt_extension)
-		generic_interrupt_extension();
+	if (x86_platform_ipi_callback)
+		x86_platform_ipi_callback();
 
 	run_local_timers();
 	irq_exit();
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 40f3077..d593222 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -200,8 +200,8 @@ static void __init apic_intr_init(void)
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
-	/* generic IPI for platform specific use */
-	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
+	/* IPI for X86 platform specific use */
+	alloc_intr_gate(X86_PLATFORM_IPI_VECTOR, x86_platform_ipi);
 
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index 583f11d..3c84aa0 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -74,7 +74,7 @@ struct uv_rtc_timer_head {
  */
 static struct uv_rtc_timer_head		**blade_info __read_mostly;
 
-static int				uv_rtc_enable;
+static int				uv_rtc_evt_enable;
 
 /*
  * Hardware interface routines
@@ -90,7 +90,7 @@ static void uv_rtc_send_IPI(int cpu)
 	pnode = uv_apicid_to_pnode(apicid);
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	      (apicid << UVH_IPI_INT_APIC_ID_SHFT) |
-	      (GENERIC_INTERRUPT_VECTOR << UVH_IPI_INT_VECTOR_SHFT);
+	      (X86_PLATFORM_IPI_VECTOR << UVH_IPI_INT_VECTOR_SHFT);
 
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
@@ -115,7 +115,7 @@ static int uv_setup_intr(int cpu, u64 expires)
 	uv_write_global_mmr64(pnode, UVH_EVENT_OCCURRED0_ALIAS,
 		UVH_EVENT_OCCURRED0_RTC1_MASK);
 
-	val = (GENERIC_INTERRUPT_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
+	val = (X86_PLATFORM_IPI_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
 		((u64)cpu_physical_id(cpu) << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
 
 	/* Set configuration */
@@ -123,7 +123,10 @@ static int uv_setup_intr(int cpu, u64 expires)
 	/* Initialize comparator value */
 	uv_write_global_mmr64(pnode, UVH_INT_CMPB, expires);
 
-	return (expires < uv_read_rtc(NULL) && !uv_intr_pending(pnode));
+	if (uv_read_rtc(NULL) <= expires)
+		return 0;
+
+	return !uv_intr_pending(pnode);
 }
 
 /*
@@ -223,6 +226,7 @@ static int uv_rtc_set_timer(int cpu, u64 expires)
 
 	next_cpu = head->next_cpu;
 	*t = expires;
+
 	/* Will this one be next to go off? */
 	if (next_cpu < 0 || bcpu == next_cpu ||
 			expires < head->cpu[next_cpu].expires) {
@@ -231,7 +235,7 @@ static int uv_rtc_set_timer(int cpu, u64 expires)
 			*t = ULLONG_MAX;
 			uv_rtc_find_next_timer(head, pnode);
 			spin_unlock_irqrestore(&head->lock, flags);
-			return 1;
+			return -ETIME;
 		}
 	}
 
@@ -244,7 +248,7 @@ static int uv_rtc_set_timer(int cpu, u64 expires)
  *
  * Returns 1 if this timer was pending.
  */
-static int uv_rtc_unset_timer(int cpu)
+static int uv_rtc_unset_timer(int cpu, int force)
 {
 	int pnode = uv_cpu_to_pnode(cpu);
 	int bid = uv_cpu_to_blade_id(cpu);
@@ -256,14 +260,15 @@ static int uv_rtc_unset_timer(int cpu)
 
 	spin_lock_irqsave(&head->lock, flags);
 
-	if (head->next_cpu == bcpu && uv_read_rtc(NULL) >= *t)
+	if ((head->next_cpu == bcpu && uv_read_rtc(NULL) >= *t) || force)
 		rc = 1;
 
-	*t = ULLONG_MAX;
-
-	/* Was the hardware setup for this timer? */
-	if (head->next_cpu == bcpu)
-		uv_rtc_find_next_timer(head, pnode);
+	if (rc) {
+		*t = ULLONG_MAX;
+		/* Was the hardware setup for this timer? */
+		if (head->next_cpu == bcpu)
+			uv_rtc_find_next_timer(head, pnode);
+	}
 
 	spin_unlock_irqrestore(&head->lock, flags);
 
@@ -310,32 +315,32 @@ static void uv_rtc_timer_setup(enum clock_event_mode mode,
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		uv_rtc_unset_timer(ced_cpu);
+		uv_rtc_unset_timer(ced_cpu, 1);
 		break;
 	}
 }
 
 static void uv_rtc_interrupt(void)
 {
-	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
 	int cpu = smp_processor_id();
+	struct clock_event_device *ced = &per_cpu(cpu_ced, cpu);
 
 	if (!ced || !ced->event_handler)
 		return;
 
-	if (uv_rtc_unset_timer(cpu) != 1)
+	if (uv_rtc_unset_timer(cpu, 0) != 1)
 		return;
 
 	ced->event_handler(ced);
 }
 
-static int __init uv_enable_rtc(char *str)
+static int __init uv_enable_evt_rtc(char *str)
 {
-	uv_rtc_enable = 1;
+	uv_rtc_evt_enable = 1;
 
 	return 1;
 }
-__setup("uvrtc", uv_enable_rtc);
+__setup("uvrtcevt", uv_enable_evt_rtc);
 
 static __init void uv_rtc_register_clockevents(struct work_struct *dummy)
 {
@@ -350,27 +355,32 @@ static __init int uv_rtc_setup_clock(void)
 {
 	int rc;
 
-	if (!uv_rtc_enable || !is_uv_system() || generic_interrupt_extension)
+	if (!is_uv_system())
 		return -ENODEV;
 
-	generic_interrupt_extension = uv_rtc_interrupt;
-
 	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
 				clocksource_uv.shift);
 
+	/* If single blade, prefer tsc */
+	if (uv_num_possible_blades() == 1)
+		clocksource_uv.rating = 250;
+
 	rc = clocksource_register(&clocksource_uv);
-	if (rc) {
-		generic_interrupt_extension = NULL;
+	if (rc)
+		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
+	else
+		printk(KERN_INFO "UV RTC clocksource registered freq %lu MHz\n",
+			sn_rtc_cycles_per_second/(unsigned long)1E6);
+
+	if (rc || !uv_rtc_evt_enable || x86_platform_ipi_callback)
 		return rc;
-	}
 
 	/* Setup and register clockevents */
 	rc = uv_rtc_allocate_timers();
-	if (rc) {
-		clocksource_unregister(&clocksource_uv);
-		generic_interrupt_extension = NULL;
-		return rc;
-	}
+	if (rc)
+		goto error;
+
+	x86_platform_ipi_callback = uv_rtc_interrupt;
 
 	clock_event_device_uv.mult = div_sc(sn_rtc_cycles_per_second,
 				NSEC_PER_SEC, clock_event_device_uv.shift);
@@ -383,11 +393,19 @@ static __init int uv_rtc_setup_clock(void)
 
 	rc = schedule_on_each_cpu(uv_rtc_register_clockevents);
 	if (rc) {
-		clocksource_unregister(&clocksource_uv);
-		generic_interrupt_extension = NULL;
+		x86_platform_ipi_callback = NULL;
 		uv_rtc_deallocate_timers();
+		goto error;
 	}
 
+	printk(KERN_INFO "UV RTC clockevents registered\n");
+
+	return 0;
+
+error:
+	clocksource_unregister(&clocksource_uv);
+	printk(KERN_INFO "UV RTC clockevents failed rc %d\n", rc);
+
 	return rc;
 }
 arch_initcall(uv_rtc_setup_clock);
