Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXLRR1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXLRR1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXLRR1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:27:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50298 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbXLRR1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:27:39 -0500
Date: Tue, 18 Dec 2007 18:27:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [git pull] x86, genirq, timer fixes
Message-ID: <20071218172713.GA31104@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest following misc-fixes (x86, genirq, timer) 
tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

It has 8 bugfixes and one missing inline fix. Thanks,

	Ingo

------------------>
Adrian Bunk (1):
      timer: kernel/timer.c section fixes

Barry Kasindorf (1):
      oprofile: op_model_athlon.c support for AMD family 10h barcelona performance counters

Ingo Molnar (1):
      x86: fix "Kernel panic - not syncing: IO-APIC + timer doesn't work!"

Jan Beulich (1):
      x86: also define AT_VECTOR_SIZE_ARCH

Kevin Hilman (1):
      genirq: add unlocked version of set_irq_handler()

Masami Hiramatsu (2):
      x86: jprobe bugfix
      x86: kprobes bugfix

Steven Rostedt (1):
      genirq: revert lazy irq disable for simple irqs

Thomas Gleixner (1):
      clockevents: fix reprogramming decision in oneshot broadcast

 arch/x86/kernel/io_apic_32.c        |   16 +++++++---
 arch/x86/kernel/io_apic_64.c        |   16 +++++++---
 arch/x86/kernel/kprobes_32.c        |    4 --
 arch/x86/kernel/kprobes_64.c        |   47 ++++++++++++------------------
 arch/x86/oprofile/op_model_athlon.c |   22 ++++++++++----
 include/asm-x86/kprobes_32.h        |    2 -
 include/asm-x86/kprobes_64.h        |    2 -
 include/asm-x86/system_64.h         |    7 ++++
 include/linux/irq.h                 |    7 ++++
 kernel/irq/chip.c                   |    9 +----
 kernel/time/tick-broadcast.c        |   56 +++++++++++++-----------------------
 kernel/timer.c                      |    4 +-
 12 files changed, 102 insertions(+), 90 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 6cf2731..c3a565b 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1882,13 +1882,16 @@ __setup("no_timer_check", notimercheck);
 static int __init timer_irq_works(void)
 {
 	unsigned long t1 = jiffies;
+	unsigned long flags;
 
 	if (no_timer_check)
 		return 1;
 
+	local_save_flags(flags);
 	local_irq_enable();
 	/* Let ten ticks pass... */
 	mdelay((10 * 1000) / HZ);
+	local_irq_restore(flags);
 
 	/*
 	 * Expect a few ticks at least, to be sure some possible
@@ -2167,6 +2170,9 @@ static inline void __init check_timer(void)
 	int apic1, pin1, apic2, pin2;
 	int vector;
 	unsigned int ver;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
 	ver = apic_read(APIC_LVR);
 	ver = GET_APIC_VERSION(ver);
@@ -2219,7 +2225,7 @@ static inline void __init check_timer(void)
 			}
 			if (disable_timer_pin_1 > 0)
 				clear_IO_APIC_pin(0, pin1);
-			return;
+			goto out;
 		}
 		clear_IO_APIC_pin(apic1, pin1);
 		printk(KERN_ERR "..MP-BIOS bug: 8254 timer not connected to "
@@ -2242,7 +2248,7 @@ static inline void __init check_timer(void)
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
 			}
-			return;
+			goto out;
 		}
 		/*
 		 * Cleanup, just in case ...
@@ -2266,7 +2272,7 @@ static inline void __init check_timer(void)
 
 	if (timer_irq_works()) {
 		printk(" works.\n");
-		return;
+		goto out;
 	}
 	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | vector);
 	printk(" failed.\n");
@@ -2282,11 +2288,13 @@ static inline void __init check_timer(void)
 
 	if (timer_irq_works()) {
 		printk(" works.\n");
-		return;
+		goto out;
 	}
 	printk(" failed :(.\n");
 	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
 		"report.  Then try booting with the 'noapic' option");
+out:
+	local_irq_restore(flags);
 }
 
 /*
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 435a8c9..cbac167 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1281,10 +1281,13 @@ void disable_IO_APIC(void)
 static int __init timer_irq_works(void)
 {
 	unsigned long t1 = jiffies;
+	unsigned long flags;
 
+	local_save_flags(flags);
 	local_irq_enable();
 	/* Let ten ticks pass... */
 	mdelay((10 * 1000) / HZ);
+	local_irq_restore(flags);
 
 	/*
 	 * Expect a few ticks at least, to be sure some possible
@@ -1655,6 +1658,9 @@ static inline void check_timer(void)
 {
 	struct irq_cfg *cfg = irq_cfg + 0;
 	int apic1, pin1, apic2, pin2;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
 	/*
 	 * get/set the timer IRQ vector:
@@ -1696,7 +1702,7 @@ static inline void check_timer(void)
 			}
 			if (disable_timer_pin_1 > 0)
 				clear_IO_APIC_pin(0, pin1);
-			return;
+			goto out;
 		}
 		clear_IO_APIC_pin(apic1, pin1);
 		apic_printk(APIC_QUIET,KERN_ERR "..MP-BIOS bug: 8254 timer not "
@@ -1718,7 +1724,7 @@ static inline void check_timer(void)
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
 			}
-			return;
+			goto out;
 		}
 		/*
 		 * Cleanup, just in case ...
@@ -1741,7 +1747,7 @@ static inline void check_timer(void)
 
 	if (timer_irq_works()) {
 		apic_printk(APIC_VERBOSE," works.\n");
-		return;
+		goto out;
 	}
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
 	apic_printk(APIC_VERBOSE," failed.\n");
@@ -1756,10 +1762,12 @@ static inline void check_timer(void)
 
 	if (timer_irq_works()) {
 		apic_printk(APIC_VERBOSE," works.\n");
-		return;
+		goto out;
 	}
 	apic_printk(APIC_VERBOSE," failed :(.\n");
 	panic("IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter\n");
+out:
+	local_irq_restore(flags);
 }
 
 static int __init notimercheck(char *s)
diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index d87a523..3a020f7 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -727,9 +727,7 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 
 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
 		if (&regs->esp != kcb->jprobe_saved_esp) {
-			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_esp,
-					    struct pt_regs, esp);
+			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
 			printk("current esp %p does not match saved esp %p\n",
 			       &regs->esp, kcb->jprobe_saved_esp);
 			printk("Saved registers for jprobe %p\n", jp);
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 0c46764..5df19a9 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -485,7 +485,6 @@ static void __kprobes resume_execution(struct kprobe *p,
 		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
 	unsigned long *tos = (unsigned long *)regs->rsp;
-	unsigned long next_rip = 0;
 	unsigned long copy_rip = (unsigned long)p->ainsn.insn;
 	unsigned long orig_rip = (unsigned long)p->addr;
 	kprobe_opcode_t *insn = p->ainsn.insn;
@@ -494,46 +493,42 @@ static void __kprobes resume_execution(struct kprobe *p,
 	if (*insn >= 0x40 && *insn <= 0x4f)
 		insn++;
 
+	regs->eflags &= ~TF_MASK;
 	switch (*insn) {
-	case 0x9c:		/* pushfl */
+	case 0x9c:	/* pushfl */
 		*tos &= ~(TF_MASK | IF_MASK);
 		*tos |= kcb->kprobe_old_rflags;
 		break;
-	case 0xc3:		/* ret/lret */
-	case 0xcb:
-	case 0xc2:
+	case 0xc2:	/* iret/ret/lret */
+	case 0xc3:
 	case 0xca:
-		regs->eflags &= ~TF_MASK;
-		/* rip is already adjusted, no more changes required*/
-		return;
-	case 0xe8:		/* call relative - Fix return addr */
+	case 0xcb:
+	case 0xcf:
+	case 0xea:	/* jmp absolute -- ip is correct */
+		/* ip is already adjusted, no more changes required */
+		goto no_change;
+	case 0xe8:	/* call relative - Fix return addr */
 		*tos = orig_rip + (*tos - copy_rip);
 		break;
 	case 0xff:
 		if ((insn[1] & 0x30) == 0x10) {
 			/* call absolute, indirect */
-			/* Fix return addr; rip is correct. */
-			next_rip = regs->rip;
+			/* Fix return addr; ip is correct. */
 			*tos = orig_rip + (*tos - copy_rip);
+			goto no_change;
 		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
 			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
-			/* rip is correct. */
-			next_rip = regs->rip;
+			/* ip is correct. */
+			goto no_change;
 		}
-		break;
-	case 0xea:		/* jmp absolute -- rip is correct */
-		next_rip = regs->rip;
-		break;
 	default:
 		break;
 	}
 
-	regs->eflags &= ~TF_MASK;
-	if (next_rip) {
-		regs->rip = next_rip;
-	} else {
-		regs->rip = orig_rip + (regs->rip - copy_rip);
-	}
+	regs->rip = orig_rip + (regs->rip - copy_rip);
+no_change:
+
+	return;
 }
 
 int __kprobes post_kprobe_handler(struct pt_regs *regs)
@@ -716,10 +711,8 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if ((long *)regs->rsp != kcb->jprobe_saved_rsp) {
-			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_rsp,
-					    struct pt_regs, rsp);
+		if ((unsigned long *)regs->rsp != kcb->jprobe_saved_rsp) {
+			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
 			printk("current rsp %p does not match saved rsp %p\n",
 			       (long *)regs->rsp, kcb->jprobe_saved_rsp);
 			printk("Saved registers for jprobe %p\n", jp);
diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 3057a19..c3ee433 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -1,6 +1,6 @@
 /**
  * @file op_model_athlon.h
- * athlon / K7 model-specific MSR operations
+ * athlon / K7 / K8 / Family 10h model-specific MSR operations
  *
  * @remark Copyright 2002 OProfile authors
  * @remark Read the file COPYING
@@ -31,12 +31,16 @@
 #define CTRL_WRITE(l,h,msrs,c) do {wrmsr(msrs->controls[(c)].addr, (l), (h));} while (0)
 #define CTRL_SET_ACTIVE(n) (n |= (1<<22))
 #define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
-#define CTRL_CLEAR(x) (x &= (1<<21))
+#define CTRL_CLEAR_LO(x) (x &= (1<<21))
+#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
 #define CTRL_SET_ENABLE(val) (val |= 1<<20)
 #define CTRL_SET_USR(val,u) (val |= ((u & 1) << 16))
 #define CTRL_SET_KERN(val,k) (val |= ((k & 1) << 17))
 #define CTRL_SET_UM(val, m) (val |= (m << 8))
-#define CTRL_SET_EVENT(val, e) (val |= e)
+#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
+#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
+#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
+#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
 static unsigned long reset_value[NUM_COUNTERS];
  
@@ -70,7 +74,8 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
 		if (unlikely(!CTRL_IS_RESERVED(msrs,i)))
 			continue;
 		CTRL_READ(low, high, msrs, i);
-		CTRL_CLEAR(low);
+		CTRL_CLEAR_LO(low);
+		CTRL_CLEAR_HI(high);
 		CTRL_WRITE(low, high, msrs, i);
 	}
 
@@ -89,12 +94,17 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
 			CTR_WRITE(counter_config[i].count, msrs, i);
 
 			CTRL_READ(low, high, msrs, i);
-			CTRL_CLEAR(low);
+			CTRL_CLEAR_LO(low);
+			CTRL_CLEAR_HI(high);
 			CTRL_SET_ENABLE(low);
 			CTRL_SET_USR(low, counter_config[i].user);
 			CTRL_SET_KERN(low, counter_config[i].kernel);
 			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT(low, counter_config[i].event);
+			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
+			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
+			CTRL_SET_HOST_ONLY(high, 0);
+			CTRL_SET_GUEST_ONLY(high, 0);
+
 			CTRL_WRITE(low, high, msrs, i);
 		} else {
 			reset_value[i] = 0;
diff --git a/include/asm-x86/kprobes_32.h b/include/asm-x86/kprobes_32.h
index b772d5b..9fe8f3b 100644
--- a/include/asm-x86/kprobes_32.h
+++ b/include/asm-x86/kprobes_32.h
@@ -73,7 +73,7 @@ struct kprobe_ctlblk {
 	unsigned long kprobe_status;
 	unsigned long kprobe_old_eflags;
 	unsigned long kprobe_saved_eflags;
-	long *jprobe_saved_esp;
+	unsigned long *jprobe_saved_esp;
 	struct pt_regs jprobe_saved_regs;
 	kprobe_opcode_t jprobes_stack[MAX_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;
diff --git a/include/asm-x86/kprobes_64.h b/include/asm-x86/kprobes_64.h
index 53f4d85..743d762 100644
--- a/include/asm-x86/kprobes_64.h
+++ b/include/asm-x86/kprobes_64.h
@@ -66,7 +66,7 @@ struct kprobe_ctlblk {
 	unsigned long kprobe_status;
 	unsigned long kprobe_old_rflags;
 	unsigned long kprobe_saved_rflags;
-	long *jprobe_saved_rsp;
+	unsigned long *jprobe_saved_rsp;
 	struct pt_regs jprobe_saved_regs;
 	kprobe_opcode_t jprobes_stack[MAX_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;
diff --git a/include/asm-x86/system_64.h b/include/asm-x86/system_64.h
index 4cb2384..6e9e484 100644
--- a/include/asm-x86/system_64.h
+++ b/include/asm-x86/system_64.h
@@ -7,6 +7,13 @@
 
 #ifdef __KERNEL__
 
+/* entries in ARCH_DLINFO: */
+#ifdef CONFIG_IA32_EMULATION
+# define AT_VECTOR_SIZE_ARCH 2
+#else
+# define AT_VECTOR_SIZE_ARCH 1
+#endif
+
 #define __SAVE(reg,offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
 #define __RESTORE(reg,offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index efc8853..4669be0 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -339,6 +339,13 @@ extern void
 __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name);
 
+/* caller has locked the irq_desc and both params are valid */
+static inline void __set_irq_handler_unlocked(int irq,
+					      irq_flow_handler_t handler)
+{
+	irq_desc[irq].handle_irq = handler;
+}
+
 /*
  * Set a highlevel flow handler for a given IRQ:
  */
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 9b5dff6..44019ce 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -297,18 +297,13 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
+	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 	kstat_cpu(cpu).irqs[irq]++;
 
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
-		desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-		desc->status |= IRQ_PENDING;
+	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
 		goto out_unlock;
-	}
 
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING | IRQ_PENDING);
 	desc->status |= IRQ_INPROGRESS;
 	spin_unlock(&desc->lock);
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index aa82d7b..5b86698 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -384,45 +384,19 @@ int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 }
 
 /*
- * Reprogram the broadcast device:
- *
- * Called with tick_broadcast_lock held and interrupts disabled.
- */
-static int tick_broadcast_reprogram(void)
-{
-	ktime_t expires = { .tv64 = KTIME_MAX };
-	struct tick_device *td;
-	int cpu;
-
-	/*
-	 * Find the event which expires next:
-	 */
-	for (cpu = first_cpu(tick_broadcast_oneshot_mask); cpu != NR_CPUS;
-	     cpu = next_cpu(cpu, tick_broadcast_oneshot_mask)) {
-		td = &per_cpu(tick_cpu_device, cpu);
-		if (td->evtdev->next_event.tv64 < expires.tv64)
-			expires = td->evtdev->next_event;
-	}
-
-	if (expires.tv64 == KTIME_MAX)
-		return 0;
-
-	return tick_broadcast_set_event(expires, 0);
-}
-
-/*
  * Handle oneshot mode broadcasting
  */
 static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 {
 	struct tick_device *td;
 	cpumask_t mask;
-	ktime_t now;
+	ktime_t now, next_event;
 	int cpu;
 
 	spin_lock(&tick_broadcast_lock);
 again:
 	dev->next_event.tv64 = KTIME_MAX;
+	next_event.tv64 = KTIME_MAX;
 	mask = CPU_MASK_NONE;
 	now = ktime_get();
 	/* Find all expired events */
@@ -431,19 +405,31 @@ again:
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
 			cpu_set(cpu, mask);
+		else if (td->evtdev->next_event.tv64 < next_event.tv64)
+			next_event.tv64 = td->evtdev->next_event.tv64;
 	}
 
 	/*
-	 * Wakeup the cpus which have an expired event. The broadcast
-	 * device is reprogrammed in the return from idle code.
+	 * Wakeup the cpus which have an expired event.
+	 */
+	tick_do_broadcast(mask);
+
+	/*
+	 * Two reasons for reprogram:
+	 *
+	 * - The global event did not expire any CPU local
+	 * events. This happens in dyntick mode, as the maximum PIT
+	 * delta is quite small.
+	 *
+	 * - There are pending events on sleeping CPUs which were not
+	 * in the event mask
 	 */
-	if (!tick_do_broadcast(mask)) {
+	if (next_event.tv64 != KTIME_MAX) {
 		/*
-		 * The global event did not expire any CPU local
-		 * events. This happens in dyntick mode, as the
-		 * maximum PIT delta is quite small.
+		 * Rearm the broadcast device. If event expired,
+		 * repeat the above
 		 */
-		if (tick_broadcast_reprogram())
+		if (tick_broadcast_set_event(next_event, 0))
 			goto again;
 	}
 	spin_unlock(&tick_broadcast_lock);
diff --git a/kernel/timer.c b/kernel/timer.c
index a05817c..d4527dc 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1219,11 +1219,11 @@ asmlinkage long sys_sysinfo(struct sysinfo __user *info)
  */
 static struct lock_class_key base_lock_keys[NR_CPUS];
 
-static int __devinit init_timers_cpu(int cpu)
+static int __cpuinit init_timers_cpu(int cpu)
 {
 	int j;
 	tvec_base_t *base;
-	static char __devinitdata tvec_base_done[NR_CPUS];
+	static char __cpuinitdata tvec_base_done[NR_CPUS];
 
 	if (!tvec_base_done[cpu]) {
 		static char boot_done;
