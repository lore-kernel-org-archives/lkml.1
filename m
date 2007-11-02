Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXKBKqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXKBKqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 06:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbXKBKp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 06:45:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXKBKp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 06:45:56 -0400
Date: Fri, 2 Nov 2007 11:45:54 +0100
From: Nick Piggin <npiggin@suse.de>
To: David Miller <davem@davemloft.net>
Cc: duaneg@dghda.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Message-ID: <20071102104554.GA941@wotan.suse.de>
References: <20071030.235600.254712083.davem@davemloft.net> <20071031074106.GE12189@wotan.suse.de> <20071031.004425.12962203.davem@davemloft.net> <20071101.220204.254984189.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101.220204.254984189.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 10:02:04PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 31 Oct 2007 00:44:25 -0700 (PDT)
> 
> > From: Nick Piggin <npiggin@suse.de>
> > Date: Wed, 31 Oct 2007 08:41:06 +0100
> > 
> > > You could possibly even do a generic "best effort" kind of thing with
> > > regular IPIs, that will timeout and continue if some CPUs don't handle
> > > them, and should be pretty easy to get working with existing smp_call_
> > > function stuff. Not exactly clean, but it would be better than nothing.
> > 
> > Without a doubt.
> 
> Putting my code where my mouth is, here is an example implementation
> of a special SysRQ "g" "dump regs globally" debugging tool for
> sparc64.
> 
> The only thing that has to happen is the SysRQ trigger.  So if you can
> either SysRQ-'g' at the console or "echo 'g' >/proc/sysrq-trigger" you
> can get the registers from the cpus in the system.
> 
> The only case the remote cpu registers would not be capturable would
> be if they were stuck looping in the trap entry, trap exit, or low
> level TLB handler code.
> 
> This means that even if some cpu is stuck in a spinlock loop with
> interrupts disabled, you'd see it with this thing.  The way it works
> is that cross cpu vectored interrupts are disabled independently of
> the processor interrupt level on sparc64.

That's really sweet. I'd better put my code where my mouth is as well...
this patch seems to be about the best we can do as a generic fallback
without getting a dedicated vector (which has to be done in arch
code anyway).

Maybe it can be improved, I don't know... I also don't know if I'm doing
exactly the right thing with pt_regs, but it seems to work.

One thing I'm doing is just dumping a single CPU, on a rotational basis. 
Don't know whether that's better or worse, but just an idea.

Now I don't know what's the best way for an arch to override this with
their own enhanced handler (an ARCH_HAVE ifdef?)

Index: linux-2.6/arch/x86/kernel/smp_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smp_64.c
+++ linux-2.6/arch/x86/kernel/smp_64.c
@@ -504,8 +504,10 @@ asmlinkage void smp_reschedule_interrupt
 	add_pda(irq_resched_count, 1);
 }
 
-asmlinkage void smp_call_function_interrupt(void)
+asmlinkage void smp_call_function_interrupt(struct pt_regs *regs)
 {
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
 	void (*func) (void *info) = call_data->func;
 	void *info = call_data->info;
 	int wait = call_data->wait;
@@ -515,7 +517,7 @@ asmlinkage void smp_call_function_interr
 	 * Notify initiating CPU that I've grabbed the data and am
 	 * about to execute the function
 	 */
-	mb();
+	smp_rmb();
 	atomic_inc(&call_data->started);
 	/*
 	 * At this point the info structure may be out of scope unless wait==1
@@ -526,8 +528,10 @@ asmlinkage void smp_call_function_interr
 	add_pda(irq_call_count, 1);
 	irq_exit();
 	if (wait) {
-		mb();
+		smp_mb();
 		atomic_inc(&call_data->finished);
 	}
+
+	set_irq_regs(old_regs);
 }
 
Index: linux-2.6/drivers/char/sysrq.c
===================================================================
--- linux-2.6.orig/drivers/char/sysrq.c
+++ linux-2.6/drivers/char/sysrq.c
@@ -196,12 +196,72 @@ static struct sysrq_key_op sysrq_showloc
 #define sysrq_showlocks_op (*(struct sysrq_key_op *)0)
 #endif
 
-static void sysrq_handle_showregs(int key, struct tty_struct *tty)
+static void show_registers(struct pt_regs *regs)
 {
-	struct pt_regs *regs = get_irq_regs();
 	if (regs)
 		show_regs(regs);
 }
+
+static void show_cpu_registers(void)
+{
+	show_registers(get_irq_regs());
+}
+
+static void show_global_regs(void *arg)
+{
+	show_cpu_registers();
+}
+
+static DEFINE_SPINLOCK(global_rotate_lock);
+static cpumask_t global_rotate_cpu;
+
+static void sysrq_handle_global_showregs_work_fn(struct work_struct *work)
+{
+	int cpu, next, thiscpu;
+
+	spin_lock(&global_rotate_lock);
+	if (cpus_weight(global_rotate_cpu) == 0)
+		cpu = smp_processor_id();
+	else
+		cpu = first_cpu(global_rotate_cpu);
+
+	next = next_cpu(cpu, cpu_online_map);
+	if (next == NR_CPUS)
+		next = first_cpu(cpu_online_map);
+	cpu_clear(cpu, global_rotate_cpu);
+	cpu_set(next, global_rotate_cpu);
+	BUG_ON(cpus_weight(global_rotate_cpu) != 1);
+	spin_unlock(&global_rotate_lock);
+
+	thiscpu = get_cpu();
+	if (cpu == thiscpu)
+		show_registers(task_pt_regs(current));
+	else {
+		if (smp_call_function_single(cpu, show_global_regs, NULL, 1, 1)
+				== -1) {
+			printk("Could not interrogate CPU registers\n");
+			return;
+		}
+	}
+	put_cpu();
+}
+static DECLARE_WORK(global_showregs_work, sysrq_handle_global_showregs_work_fn);
+static void sysrq_handle_global_showregs(int key, struct tty_struct *tty)
+{
+	schedule_work(&global_showregs_work);
+}
+static struct sysrq_key_op sysrq_global_showregs_op = {
+	.handler	= sysrq_handle_global_showregs,
+	.help_msg	= "showGlobalPc",
+	.action_msg	= "Show Global CPU Regs",
+	.enable_mask	= SYSRQ_ENABLE_DUMP,
+};
+
+
+static void sysrq_handle_showregs(int key, struct tty_struct *tty)
+{
+	show_cpu_registers();
+}
 static struct sysrq_key_op sysrq_showregs_op = {
 	.handler	= sysrq_handle_showregs,
 	.help_msg	= "showPc",
@@ -336,7 +396,7 @@ static struct sysrq_key_op *sysrq_key_ta
 	&sysrq_term_op,			/* e */
 	&sysrq_moom_op,			/* f */
 	/* g: May be registered by ppc for kgdb */
-	NULL,				/* g */
+	&sysrq_global_showregs_op,	/* g */
 	NULL,				/* h */
 	&sysrq_kill_op,			/* i */
 	NULL,				/* j */
