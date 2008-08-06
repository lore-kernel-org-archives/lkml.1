Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbYHFPh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbYHFPh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYHFPdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:33:32 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:32153 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602AbYHFPd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:33:29 -0400
X-BigFish: VPS3(z5edJz1cddkzz10d3izzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 7,
X-WSS-ID: 0K56R5L-01-ZER-01
Message-ID: <20080806152320.298570641@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 6 Aug 2008 17:21:22 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 5/5] [PATCH 5/5] x86: Run AMD microcode updates via workqueue.
References: <20080806152117.198754464@amd.com>
Content-Disposition: inline;
	filename="0005-x86-Run-AMD-microcode-updates-via-workqueue.patch"
X-OriginalArrivalTime: 06 Aug 2008 15:32:10.0165 (UTC) FILETIME=[977E2650:01C8F7D9]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode_amd.c |  106 ++++++++++++++++++++++++--------------
 1 files changed, 67 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 33b2a21..37d26ec 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -14,6 +14,7 @@
  *  License version 2. See file COPYING for details.
 */
 
+/* #define DEBUG */ /* pr_debug */
 #include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -40,7 +41,7 @@
 
 MODULE_DESCRIPTION("AMD Microcode Update Driver");
 MODULE_AUTHOR("Peter Oruba <peter.oruba@amd.com>");
-MODULE_LICENSE("GPL v2");
+MODULE_LICENSE("GPL");
 
 #define UCODE_MAGIC                0x00414d44
 #define UCODE_EQUIV_CPU_TABLE_TYPE 0x00000000
@@ -65,11 +66,16 @@ extern struct mutex (microcode_mutex);
 struct equiv_cpu_entry *equiv_cpu_table;
 
 extern struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
+extern struct ucode_work_info ucode_work_info[NR_CPUS];
 
-static void collect_cpu_info_amd(int cpu)
+static inline struct ucode_cpu_info *get_ucode_cpu_info(int cpu)
+{
+	return &ucode_work_info[cpu].uci;
+}
+
+static void collect_cpu_info_amd(int cpu, struct ucode_cpu_info *uci)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 	/* We should bind the task to the CPU */
 	BUG_ON(raw_smp_processor_id() != cpu);
@@ -95,7 +101,7 @@ static void collect_cpu_info_amd(int cpu)
 
 static int get_matching_microcode_amd(void *mc, int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu);
 	struct microcode_header_amd *mc_header = mc;
 	unsigned long total_size = get_totalsize(mc_header);
 	void *new_mc;
@@ -215,7 +221,7 @@ static void apply_microcode_amd(int cpu)
 	unsigned int eax, edx;
 	unsigned int rev;
 	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu_num);
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
@@ -437,61 +443,83 @@ static int cpu_request_microcode_amd(int cpu)
 	return error;
 }
 
-static int apply_microcode_check_cpu_amd(int cpu)
+static void microcode_fini_cpu_amd(int cpu)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	unsigned int rev;
-	cpumask_t old;
-	int err = 0;
+	struct ucode_work_info *wi = ucode_work_info + cpu;
 
-	/* Check if the microcode is available */
-	if (!uci->mc.mc_amd)
-		return 0;
+	mutex_lock(&microcode_mutex);
+	wi->uci.valid = 0;
+	vfree(wi->uci.mc.mc_amd);
+	wi->uci.mc.mc_amd = NULL;
+	wi->resume = 0;
+	mutex_unlock(&microcode_mutex);
+}
+
+static int microcode_resume_cpu(int cpu, struct ucode_cpu_info *new_uci)
+{
+	struct ucode_work_info *wi = ucode_work_info + cpu;
+	struct ucode_cpu_info *uci = &wi->uci;
 
-	old = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	if (!wi->resume)
+		return 0;
 
-	/* Check if the microcode we have in memory matches the CPU */
-	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 16)
-		err = -EINVAL;
+	pr_debug("microcode: CPU%d resumed (ucode: %p)\n",
+		 cpu, uci->mc.mc_amd);
 
-	if (!err) {
-		asm volatile("movl %1, %%ecx; rdmsr"
-		     : "=a" (rev)
-		     : "i" (0x0000008B) : "ecx");
+	wi->resume = 0;
 
-		if (uci->rev != rev)
-			err = -EINVAL;
-	}
+        /* check if the 'cached' microcode is ok: */
+	if (!uci->mc.mc_amd)
+		return 1;
 
-	if (!err)
+	if (new_uci->sig == uci->sig &&
+	    new_uci->pf  == uci->pf &&
+	    new_uci->rev == uci->rev) {
 		apply_microcode_amd(cpu);
-	else
-		printk(KERN_ERR "microcode: Could not apply microcode to CPU%d:"
-		       " rev=0x%x\n",
-		       cpu,  uci->rev);
+	} else {
+		microcode_fini_cpu_amd(cpu);
+		*uci = *new_uci;
+	}
 
-	set_cpus_allowed(current, old);
-	return err;
+	return 1;
 }
 
-static void microcode_fini_cpu_amd(int cpu)
+static void microcode_update_cpu_amd(struct work_struct *w)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_work_info *wi = container_of(w, struct ucode_work_info,
+						  work);
+	int cpu = raw_smp_processor_id(); /* keventd is per-cpu */
+	struct ucode_cpu_info new_uci;
+
+	pr_debug("microcode: CPU%d workqueue\n", cpu);
+
+	memset(&new_uci, 0, sizeof(new_uci));
 
 	mutex_lock(&microcode_mutex);
-	uci->valid = 0;
-	vfree(uci->mc.mc_amd);
-	uci->mc.mc_amd = NULL;
+
+	collect_cpu_info_amd(cpu, &new_uci);
+
+	if (new_uci.valid) {
+		/*
+		 * Check if the system resume is in progress,
+		 * otherwise just request a firmware:
+		 */
+		if (!microcode_resume_cpu(cpu, &new_uci)) {
+			wi->uci = new_uci;
+
+			if (system_state == SYSTEM_RUNNING)
+				cpu_request_microcode_amd(cpu);
+		}
+	}
+
 	mutex_unlock(&microcode_mutex);
 }
 
 static struct microcode_ops microcode_amd_ops = {
 	.get_next_ucode                   = get_next_ucode_amd,
+	.microcode_update_cpu             = microcode_update_cpu_amd,
 	.get_matching_microcode           = get_matching_microcode_amd,
 	.microcode_sanity_check           = NULL,
-	.apply_microcode_check_cpu        = apply_microcode_check_cpu_amd,
 	.cpu_request_microcode            = cpu_request_microcode_amd,
 	.collect_cpu_info                 = collect_cpu_info_amd,
 	.apply_microcode                  = apply_microcode_amd,
-- 
1.5.4.5




