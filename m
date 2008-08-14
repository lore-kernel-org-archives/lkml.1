Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbYHNNjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbYHNNjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYHNNjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:39:46 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:33127 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYHNNjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:39:45 -0400
X-BigFish: VPS-5(zz936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K5LF9W-02-IBJ-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH](retry 3) invalidate caches before going into suspend
Date: Thu, 14 Aug 2008 08:45:04 -0500
User-Agent: KMail/1.9.9
CC: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <200808131141.18003.mark.langsdorf@amd.com> <6453C3CB8E2B3646B0D020C112613273C5AC6B@sausexmb4.amd.com> <20080813143206.07550498@infradead.org>
In-Reply-To: <20080813143206.07550498@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <200808140845.05160.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 14 Aug 2008 13:39:38.0037 (UTC) FILETIME=[32372E50:01C8FE13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU core is shut down, all of its caches need to be flushed
to prevent stale data from causing errors if the core is resumed.
Current Linux suspend code performs an assignment after the flush,
which can add dirty data back to the cache.  On some AMD platforms,
additional speculative reads have caused crashes on resume because
of this dirty data.

Relocate the cache flush to be the very last thing done before 
halting.  Tie into an assembly line so the compile will not
reorder it.  Add some documentation explaining what is going
on and why we're doing this.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Acked-by: Mark Borden <mark.borden@amd.com>
Acked-by: Michael Hohmuth <michael.hohmuth@amd.com>

diff -r 1e74a821dd00 arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c	Tue Aug 12 12:04:12 2008 -0500
+++ b/arch/x86/kernel/process_32.c	Thu Aug 14 03:04:52 2008 -0500
@@ -65,6 +65,28 @@ EXPORT_PER_CPU_SYMBOL(cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
 
 /*
+ * on systems with caches, caches must be flashed as the absolute
+ * last instruction before going into a suspended halt.  Otherwise,
+ * dirty data can linger in the cache and become stale on resume,
+ * leading to strange errors.
+ *
+ * perform a variety of operations to guarantee that the compiler
+ * will not reorder instructions.  wbinvd itself is serializing
+ * so the processor will not reorder.
+ *
+ * Systems without cache can just go into halt.
+ */
+static void wbinvd_halt(void) {
+        mb();
+        /* check for clflush to determine if wbinvd is legal */
+        if (cpu_has_clflush)
+		asm volatile("cli; wbinvd; 1: hlt; jmp 1b": : :"memory");
+        else
+                while (1)
+                        halt();
+}
+
+/*
  * Return saved PC of a blocked thread.
  */
 unsigned long thread_saved_pc(struct task_struct *tsk)
@@ -95,7 +117,6 @@ static inline void play_dead(void)
 {
 	/* This must be done before dead CPU ack */
 	cpu_exit_clear();
-	wbinvd();
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
@@ -104,8 +125,8 @@ static inline void play_dead(void)
 	 * With physical CPU hotplug, we should halt the cpu
 	 */
 	local_irq_disable();
-	while (1)
-		halt();
+	/* mask all interrupts, flush any and all caches, and halt */
+	wbinvd_halt();
 }
 #else
 static inline void play_dead(void)
diff -r 1e74a821dd00 arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c	Tue Aug 12 12:04:12 2008 -0500
+++ b/arch/x86/kernel/process_64.c	Thu Aug 14 03:04:42 2008 -0500
@@ -58,6 +58,28 @@ unsigned long kernel_thread_flags = CLON
 
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
 
+/*
+ * on systems with caches, caches must be flashed as the absolute
+ * last instruction before going into a suspended halt.  Otherwise,
+ * dirty data can linger in the cache and become stale on resume,
+ * leading to strange errors.
+ *
+ * perform a variety of operations to guarantee that the compiler
+ * will not reorder instructions.  wbinvd itself is serializing
+ * so the processor will not reorder.
+ *
+ * Systems without cache can just go into halt.
+ */
+static void wbinvd_halt(void) {
+	mb(); 
+	/* check for clflush to determine if wbinvd is legal */
+	if (cpu_has_clflush)
+		asm volatile("cli; wbinvd; 1: hlt; jmp 1b": : :"memory");
+	else
+		while (1)
+			halt();
+}
+
 void idle_notifier_register(struct notifier_block *n)
 {
 	atomic_notifier_chain_register(&idle_notifier, n);
@@ -93,14 +115,13 @@ static inline void play_dead(void)
 static inline void play_dead(void)
 {
 	idle_task_exit();
-	wbinvd();
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
 
 	local_irq_disable();
-	while (1)
-		halt();
+	/* mask all interrupts, flush any and all caches, and halt */
+	wbinvd_halt();
 }
 #else
 static inline void play_dead(void)

