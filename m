Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZD1K2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZD1K2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbZD1K1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:27:49 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38488 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbZD1K1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:27:47 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
References: <20090408210745.GE11159@us.ibm.com>
	<86802c440904081503k545bf7b4n3d44aa3c9d101e0d@mail.gmail.com>
	<20090408230820.GA14412@us.ibm.com>
	<86802c440904102346lfbc85f2w4508bded0572ec58@mail.gmail.com>
	<20090413193717.GB8393@us.ibm.com> <m1bpr0e2au.fsf@fess.ebiederm.org>
	<20090428000536.GA7347@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 28 Apr 2009 03:27:36 -0700
In-Reply-To: <20090428000536.GA7347@us.ibm.com> (Gary Hade's message of "Mon\, 27 Apr 2009 17\:05\:36 -0700")
Message-ID: <m1bpqhjco7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, mingo@elte.hu, yhlu.kernel@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gary Hade <garyhade@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 3/3] [BUGFIX] x86/x86_64: fix IRQ migration triggered active device IRQ interrruption
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> The I/O redirection table register write with the remote
> IRR set issue has reproduced on every IBM System x server
> I have tried including the x460, x3850, x3550 M2, and x3950 M2.
> Nobody has responded to my request to test for the presence
> of this issue on non-IBM systems but I think it is pretty safe
> to assume that the problem is not IBM specific.

There is no question.  The problem can be verified from a simple
code inspection.  It results from the brokenness of the current
fixup_irqs.

Your suggested change at the very least is likely to result in
dropped irqs at runtime.  Something some drivers do not
tolerate well.

> After incorporating the fix that avoids writes to the 
> the I/O redirection table registers while the remote IRR
> bit is set, I have _not_ observed any other issues that 
> might be related to the ioapic fragility that you mentioned.
> This of course does not prove that you are wrong and that
> there is not a need for the changes you are suggesting.
> However, until someone has the bandwidth to tackle the difficult
> changes that you suggest, I propose that we continue to repair
> problems that are found in the current implementation with fixes
> such as those that I provided.

The changes I suggest are not difficult.

How is APIC routing setup on your hardware?
"Setting APIC routing to flat"  Is what my laptop reports.

My apologies for asking it badly last time.  For understanding what
you are testing that is a critical piece of information.

Below is my draft patch that stops cpu shutdown when irqs can not be
migrated off.  The code to do that is trivial, and is guaranteed
to fix all of your lost irq problems.

Beyond that everything I am proposing is very localized.

You have proposed making interrupts behave like they can be migrated
in process context when in fact extensive testing over the years have
shown in the general case interrupts can only be migrated from the irq
handler, from a location where the irqs are naturally disabled.

I propose detecting the cases that we know are safe to migrate in
process context, aka logical deliver with less than 8 cpus aka "flat"
routing mode and modifying the code so that those work in process
context and simply deny cpu hotplug in all of the rest of the cases.

That gives us: Code that always works.  An incremental easily testable
path.  No need to loose sleep at night worrying about the weird failure
modes.  Ultimately less complex code.

Eric

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index f38481b..c585a0e 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -47,4 +47,12 @@ extern unsigned int do_IRQ(struct pt_regs *regs);
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
 extern int vector_used_by_percpu_irq(unsigned int vector);
 
+#ifdef CONFIG_X86_IO_APIC
+extern void cleanup_pending_irqs(unsigned int cpu);
+#else
+static inline void cleanup_pending_irqs(unsigned int cpu)
+{
+}
+#endif
+
 #endif /* _ASM_X86_IRQ_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 767fe7e..88a5235 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4202,3 +4202,57 @@ static int __init ioapic_insert_resources(void)
 /* Insert the IO APIC resources after PCI initialization has occured to handle
  * IO APICS that are mapped in on a BAR in PCI space. */
 late_initcall(ioapic_insert_resources);
+
+#ifndef CONFIG_HOTPLUG_CPUS
+void cleanup_pending_irqs(unsigned me)
+{
+	/* Called with irqs disabled */
+	unsigned vector;
+
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+		unsigned long flags;
+		unsigned int irq;
+		unsigned int irr;
+		struct irq_desc *desc;
+		struct irq_cfg *cfg;
+		int bug = 0;
+
+		irq = __get_cpu_var(vector_irq)[vector];
+
+		if (irq == -1)
+			continue;
+
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		cfg = irq_cfg(irq);
+
+		spin_lock_irqsave(&desc->lock, flags);
+		bug = 1;
+		if (!cfg->move_cleanup_count)
+			goto unlock;
+		
+		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
+			goto unlock;
+
+		bug = 0; /* It's not a bug only if a move is pending */
+
+		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+		/*
+		 * Check if the vector that needs to be cleaned up is
+		 * registered at the cpu's IRR.  If so then resend the
+		 * irq so we don't loose it.
+		 */
+		if (irr & (1 << (vector % 32)))
+			desc->chip->retrigger(irq);
+		__get_cpu_var(vector_irq)[vector] = -1;
+		cfg->move_cleanup_count--;
+	unlock:
+		spin_unlock_irqrestore(&desc->lock, flags);
+		
+		if (bug)
+			printk(KERN_EMERG "irq: %i left on downed cpu %d\n", irq, me);
+	}
+}
+#endif
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index c3fe010..e2082ad 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -253,3 +253,98 @@ void smp_generic_interrupt(struct pt_regs *regs)
 }
 
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
+
+#ifdef CONFIG_HOTPLUG_CPU
+static int irq_cpu_notify(struct notifier_block *self, unsigned long action,
+			  void *hcpu)
+{
+	int cpu = (long)hcpu;
+	unsigned int irq;
+	struct irq_desc *desc;
+	int ret = NOTIFY_OK;
+
+	if ((action != CPU_DOWN_PREPARE) && (action != CPU_DOWN_PREPARE_FROZEN))
+		goto out;
+
+	for_each_irq_desc(irq, desc) {
+		if (!desc)
+			continue;
+		if (irq == 2)
+			continue;
+		if (desc->status & IRQ_MOVE_PCNTXT)
+			continue;
+		if (!cpu_isset(cpu, *desc->affinity))
+			continue;
+#if 0
+		/* Should I allow these? */
+		if (!desc->action)
+			continue;
+		if (desc->status & IRQ_MASKED)
+			continue;
+#endif
+		ret = NOTIFY_BAD;
+		goto out;
+	}
+out:
+#if 1
+	printk(KERN_DEBUG "%s action: %lx cpu_down_prepare: %d cpu_down_prepare_frozen: %d done\n",
+		__func__, action,
+		(action == CPU_DOWN_PREPARE), (action == CPU_DOWN_PREPARE_FROZEN));
+#endif
+	return ret;
+}
+
+static struct notifier_block irq_cpu_notifier = {
+	.notifier_call = irq_cpu_notify,
+};
+
+static __init int setup_irq_cpu_notifier(void)
+{
+#if 1
+	printk(KERN_DEBUG "%s\n",__func__);
+#endif
+	return register_cpu_notifier(&irq_cpu_notifier);
+}
+module_init(setup_irq_cpu_notifier);
+
+
+/* The current cpu has been removed from cpu_online_mask.  Reset irq affinities. */
+void fixup_irqs(void)
+{
+	unsigned int irq;
+	static int warned;
+	struct irq_desc *desc;
+	int cpu = smp_processor_id();
+
+	for_each_irq_desc(irq, desc) {
+		const struct cpumask *affinity;
+		int ret;
+
+		if (!desc)
+			continue;
+		if (irq == 2)
+			continue;
+		affinity = desc->affinity;
+		if (!cpu_isset(cpu, *affinity))
+			continue;
+		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
+			printk("Breaking affinity for irq %i\n", irq);
+			affinity = cpu_all_mask;
+		}
+		ret = -EINVAL;
+		if (desc->status & IRQ_MOVE_PCNTXT)
+			ret = irq_set_affinity(irq, affinity);
+		if (ret && desc->action && !(warned++))
+			printk("Cannot set affinity for irq %i\n", irq);
+#if 1
+		printk(KERN_DEBUG "irq: %i moved: %d action: %p\n",
+			irq, ret == 0, desc->action);
+#endif
+	}
+	cleanup_pending_irqs(cpu);
+#if 1
+	printk(KERN_DEBUG "%s done\n", __func__);
+#endif
+}
+
+#endif /* CONFIG_HOTPLUG_CPU */
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 3b09634..e11eea7 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -212,48 +212,3 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 	return true;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-void fixup_irqs(void)
-{
-	unsigned int irq;
-	static int warned;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(irq, desc) {
-		const struct cpumask *affinity;
-
-		if (!desc)
-			continue;
-		if (irq == 2)
-			continue;
-
-		affinity = desc->affinity;
-		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
-			printk("Breaking affinity for irq %i\n", irq);
-			affinity = cpu_all_mask;
-		}
-		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, affinity);
-		else if (desc->action && !(warned++))
-			printk("Cannot set affinity for irq %i\n", irq);
-	}
-
-#if 0
-	barrier();
-	/* Ingo Molnar says: "after the IO-APIC masks have been redirected
-	   [note the nop - the interrupt-enable boundary on x86 is two
-	   instructions from sti] - to flush out pending hardirqs and
-	   IPIs. After this point nothing is supposed to reach this CPU." */
-	__asm__ __volatile__("sti; nop; cli");
-	barrier();
-#else
-	/* That doesn't seem sufficient.  Give it 1ms. */
-	local_irq_enable();
-	mdelay(1);
-	local_irq_disable();
-#endif
-}
-#endif
-
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 977d8b4..c2f9bd5 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -62,65 +62,6 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 	return true;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-void fixup_irqs(void)
-{
-	unsigned int irq;
-	static int warned;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(irq, desc) {
-		int break_affinity = 0;
-		int set_affinity = 1;
-		const struct cpumask *affinity;
-
-		if (!desc)
-			continue;
-		if (irq == 2)
-			continue;
-
-		/* interrupt's are disabled at this point */
-		spin_lock(&desc->lock);
-
-		affinity = desc->affinity;
-		if (!irq_has_action(irq) ||
-		    cpumask_equal(affinity, cpu_online_mask)) {
-			spin_unlock(&desc->lock);
-			continue;
-		}
-
-		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
-			break_affinity = 1;
-			affinity = cpu_all_mask;
-		}
-
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
-
-		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, affinity);
-		else if (!(warned++))
-			set_affinity = 0;
-
-		if (desc->chip->unmask)
-			desc->chip->unmask(irq);
-
-		spin_unlock(&desc->lock);
-
-		if (break_affinity && set_affinity)
-			printk("Broke affinity for irq %i\n", irq);
-		else if (!set_affinity)
-			printk("Cannot set affinity for irq %i\n", irq);
-	}
-
-	/* That doesn't seem sufficient.  Give it 1ms. */
-	local_irq_enable();
-	mdelay(1);
-	local_irq_disable();
-}
-#endif
-
 extern void call_softirq(void);
 
 asmlinkage void do_softirq(void)
