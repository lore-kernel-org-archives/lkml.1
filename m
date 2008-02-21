Return-Path: <linux-kernel-owner+w=401wt.eu-S933437AbYBUUv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbYBUUv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYBUUvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:51:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642AbYBUUvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:51:12 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       pzijlstr@redhat.com, arjan@infradead.org,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 1/2] turn c_idle into a pointer
Date: Thu, 21 Feb 2008 17:40:55 -0300
Message-Id: <1203626456-3101-2-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1203626456-3101-1-git-send-email-gcosta@redhat.com>
References: <1203626456-3101-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not useful by itself, but part of making the
underlying work_struct have a static address.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index d53bd6f..f15b774 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -553,11 +553,12 @@ static int __cpuinit do_boot_cpu(int cpu
 	unsigned long boot_error;
 	int timeout;
 	unsigned long start_rip;
-	struct create_idle c_idle = {
-		.work = __WORK_INITIALIZER(c_idle.work, do_fork_idle),
+	struct create_idle create_idle = {
+		.work = __WORK_INITIALIZER(create_idle.work, do_fork_idle),
 		.cpu = cpu,
-		.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
+		.done = COMPLETION_INITIALIZER_ONSTACK(create_idle.done),
 	};
+	struct create_idle *c_idle = &create_idle;
 
 	/* allocate memory for gdts of secondary cpus. Hotplug is considered */
 	if (!cpu_gdt_descr[cpu].address &&
@@ -584,12 +585,12 @@ static int __cpuinit do_boot_cpu(int cpu
 
 	alternatives_smp_switch(1);
 
-	c_idle.idle = get_idle_for_cpu(cpu);
+	c_idle->idle = get_idle_for_cpu(cpu);
 
-	if (c_idle.idle) {
-		c_idle.idle->thread.sp = (unsigned long) (((struct pt_regs *)
-			(THREAD_SIZE +  task_stack_page(c_idle.idle))) - 1);
-		init_idle(c_idle.idle, cpu);
+	if (c_idle->idle) {
+		c_idle->idle->thread.sp = (unsigned long) (((struct pt_regs *)
+			(THREAD_SIZE +  task_stack_page(c_idle->idle))) - 1);
+		init_idle(c_idle->idle, cpu);
 		goto do_rest;
 	}
 
@@ -604,29 +605,29 @@ static int __cpuinit do_boot_cpu(int cpu
 	 * thread.
 	 */
 	if (!keventd_up() || current_is_keventd())
-		c_idle.work.func(&c_idle.work);
+		c_idle->work.func(&c_idle->work);
 	else {
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
+		schedule_work(&c_idle->work);
+		wait_for_completion(&c_idle->done);
 	}
 
-	if (IS_ERR(c_idle.idle)) {
+	if (IS_ERR(c_idle->idle)) {
 		printk("failed fork for CPU %d\n", cpu);
-		return PTR_ERR(c_idle.idle);
+		return PTR_ERR(c_idle->idle);
 	}
 
-	set_idle_for_cpu(cpu, c_idle.idle);
+	set_idle_for_cpu(cpu, c_idle->idle);
 
 do_rest:
 
-	cpu_pda(cpu)->pcurrent = c_idle.idle;
+	cpu_pda(cpu)->pcurrent = c_idle->idle;
 
 	start_rip = setup_trampoline();
 
-	init_rsp = c_idle.idle->thread.sp;
-	load_sp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
+	init_rsp = c_idle->idle->thread.sp;
+	load_sp0(&per_cpu(init_tss, cpu), &c_idle->idle->thread);
 	initial_code = start_secondary;
-	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
+	clear_tsk_thread_flag(c_idle->idle, TIF_FORK);
 
 	printk(KERN_INFO "Booting processor %d/%d APIC 0x%x\n", cpu,
 		cpus_weight(cpu_present_map),
-- 
1.4.2

