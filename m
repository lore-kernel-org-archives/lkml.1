Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbYCSUZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbYCSUZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbYCSTjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbYCSTjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:05 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 50/79] [PATCH] use create_idle struct in do_boot_cpu
Date: Wed, 19 Mar 2008 14:25:45 -0300
Message-Id: <12059478013647-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477974089-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Use a new worker, with help of the create_idle struct
to fork the idle thread. We now have two workers, the first
of them triggered by __smp_prepare_cpu. But the later is
going away soon.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   86 ++++++++++++++++++++++++++++-------------
 1 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index c30abed..fc1eb52 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -79,6 +79,24 @@ static void map_cpu_to_logical_apicid(void);
 /* State of each CPU. */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
+/* Store all idle threads, this can be reused instead of creating
+* a new thread. Also avoids complicated thread destroy functionality
+* for idle threads.
+*/
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
+ * removed after init for !CONFIG_HOTPLUG_CPU.
+ */
+static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
+#define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
+#define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
+#else
+struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
+#define get_idle_for_cpu(x)      (idle_thread_array[(x)])
+#define set_idle_for_cpu(x, p)   (idle_thread_array[(x)] = (p))
+#endif
+
 static atomic_t init_deasserted;
 
 static void __cpuinit smp_callin(void)
@@ -513,30 +531,21 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 
 extern cpumask_t cpu_initialized;
 
-#ifdef CONFIG_HOTPLUG_CPU
-static struct task_struct * __cpuinitdata cpu_idle_tasks[NR_CPUS];
-static inline struct task_struct * __cpuinit alloc_idle_task(int cpu)
-{
+struct create_idle {
+	struct work_struct work;
 	struct task_struct *idle;
+	struct completion done;
+	int cpu;
+};
 
-	if ((idle = cpu_idle_tasks[cpu]) != NULL) {
-		/* initialize thread_struct.  we really want to avoid destroy
-		 * idle tread
-		 */
-		idle->thread.sp = (unsigned long)task_pt_regs(idle);
-		init_idle(idle, cpu);
-		return idle;
-	}
-	idle = fork_idle(cpu);
+static void __cpuinit do_fork_idle(struct work_struct *work)
+{
+	struct create_idle *c_idle =
+		container_of(work, struct create_idle, work);
 
-	if (!IS_ERR(idle))
-		cpu_idle_tasks[cpu] = idle;
-	return idle;
+	c_idle->idle = fork_idle(c_idle->cpu);
+	complete(&c_idle->done);
 }
-#else
-#define alloc_idle_task(cpu) fork_idle(cpu)
-#endif
-
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
@@ -544,11 +553,15 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
  * Returns zero if CPU booted OK, else error code from wakeup_secondary_cpu.
  */
 {
-	struct task_struct *idle;
 	unsigned long boot_error;
 	int timeout;
 	unsigned long start_eip;
 	unsigned short nmi_high = 0, nmi_low = 0;
+	struct create_idle c_idle = {
+		.cpu = cpu,
+		.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
+	};
+	INIT_WORK(&c_idle.work, do_fork_idle);
 
 	/*
 	 * Save current MTRR state in case it was changed since early boot
@@ -556,19 +569,38 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	 */
 	mtrr_save_state();
 
+	c_idle.idle = get_idle_for_cpu(cpu);
+
 	/*
 	 * We can't use kernel_thread since we must avoid to
 	 * reschedule the child.
 	 */
-	idle = alloc_idle_task(cpu);
-	if (IS_ERR(idle))
-		panic("failed fork for CPU %d", cpu);
+	if (c_idle.idle) {
+		c_idle.idle->thread.sp = (unsigned long) (((struct pt_regs *)
+			(THREAD_SIZE +  task_stack_page(c_idle.idle))) - 1);
+		init_idle(c_idle.idle, cpu);
+		goto do_rest;
+	}
+
+	if (!keventd_up() || current_is_keventd())
+		c_idle.work.func(&c_idle.work);
+	else {
+		schedule_work(&c_idle.work);
+		wait_for_completion(&c_idle.done);
+	}
+
+	if (IS_ERR(c_idle.idle)) {
+		printk(KERN_ERR "failed fork for CPU %d\n", cpu);
+		return PTR_ERR(c_idle.idle);
+	}
 
+	set_idle_for_cpu(cpu, c_idle.idle);
+do_rest:
+	per_cpu(current_task, cpu) = c_idle.idle;
 	init_gdt(cpu);
- 	per_cpu(current_task, cpu) = idle;
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 
-	idle->thread.ip = (unsigned long) start_secondary;
+	c_idle.idle->thread.ip = (unsigned long) start_secondary;
 	/* start_eip had better be page-aligned! */
 	start_eip = setup_trampoline();
 
@@ -577,7 +609,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	/* So we see what's up   */
 	printk("Booting processor %d/%d ip %lx\n", cpu, apicid, start_eip);
 	/* Stack for startup_32 can be just as for start_secondary onwards */
-	stack_start.sp = (void *) idle->thread.sp;
+	stack_start.sp = (void *) c_idle.idle->thread.sp;
 
 	irq_ctx_init(cpu);
 
-- 
1.5.0.6

