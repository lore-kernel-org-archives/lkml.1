Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab0BYTpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:45:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933401Ab0BYTpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:45:30 -0500
X-Authority-Analysis: v=1.0 c=1 a=U_Rj2Ix5_e8A:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=AsTUDov5T3xtj3-ytsAA:9 a=LqOh9ZEZREGmklJ-HDgA:7 a=svGCVfusJzbnDYPs1oQPk40jqD4A:4 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=y8QFKBub2-xAXe0o:21 a=WQ0NJqm7seGPBmp8:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100225194528.640084706@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 25 Feb 2010 14:43:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/7] ftrace: Remove memory barriers from NMI code when not needed
References: <20100225194355.707261669@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Remove-memory-barriers-from-NMI-code-when-not.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code in stop_machine that modifies the kernel text has a bit
of logic to handle the case of NMIs. stop_machine does not prevent
NMIs from executing, and if an NMI were to trigger on another CPU
as the modifying CPU is changing the NMI text, a GPF could result.

To prevent the GPF, the NMI calls ftrace_nmi_enter() which may
modify the code first, then any other NMIs will just change the
text to the same content which will do no harm. The code that
stop_machine called must wait for NMIs to finish while it changes
each location in the kernel. That code may also change the text
to what the NMI changed it to. The key is that the text will never
change content while another CPU is executing it.

To make the above work, the call to ftrace_nmi_enter() must also
do a smp_mb() as well as atomic_inc().  But for applications like
perf that require a high number of NMIs for profiling, this can have
a dramatic effect on the system. Not only is it doing a full memory
barrier on both nmi_enter() as well as nmi_exit() it is also
modifying a global variable with an atomic operation. This kills
performance on large SMP machines.

Since the memory barriers are only needed when ftrace is in the
process of modifying the text (which is seldom), this patch
adds a "modifying_code" variable that gets set before stop machine
is executed and cleared afterwards.

The NMIs will check this variable and store it in a per CPU
"save_modifying_code" variable that it will use to check if it
needs to do the memory barriers and atomic dec on NMI exit.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3096892..605ef19 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -30,14 +30,32 @@
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+/*
+ * modifying_code is set to notify NMIs that they need to use
+ * memory barriers when entering or exiting. But we don't want
+ * to burden NMIs with unnecessary memory barriers when code
+ * modification is not being done (which is most of the time).
+ *
+ * A mutex is already held when ftrace_arch_code_modify_prepare
+ * and post_process are called. No locks need to be taken here.
+ *
+ * Stop machine will make sure currently running NMIs are done
+ * and new NMIs will see the updated variable before we need
+ * to worry about NMIs doing memory barriers.
+ */
+static int modifying_code __read_mostly;
+static DEFINE_PER_CPU(int, save_modifying_code);
+
 int ftrace_arch_code_modify_prepare(void)
 {
 	set_kernel_text_rw();
+	modifying_code = 1;
 	return 0;
 }
 
 int ftrace_arch_code_modify_post_process(void)
 {
+	modifying_code = 0;
 	set_kernel_text_ro();
 	return 0;
 }
@@ -149,6 +167,11 @@ static void ftrace_mod_code(void)
 
 void ftrace_nmi_enter(void)
 {
+	__get_cpu_var(save_modifying_code) = modifying_code;
+
+	if (!__get_cpu_var(save_modifying_code))
+		return;
+
 	if (atomic_inc_return(&nmi_running) & MOD_CODE_WRITE_FLAG) {
 		smp_rmb();
 		ftrace_mod_code();
@@ -160,6 +183,9 @@ void ftrace_nmi_enter(void)
 
 void ftrace_nmi_exit(void)
 {
+	if (!__get_cpu_var(save_modifying_code))
+		return;
+
 	/* Finish all executions before clearing nmi_running */
 	smp_mb();
 	atomic_dec(&nmi_running);
-- 
1.6.5


