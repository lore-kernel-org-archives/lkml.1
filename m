Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbYHMS2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbYHMS2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYHMS2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:28:11 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:65361 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYHMS2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:28:10 -0400
X-BigFish: VPS-30(zz9370P98dR4015M936fQzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5JXYD-01-LRF-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH](retry 2) Re: invalidate caches before going into suspend
Date: Wed, 13 Aug 2008 13:33:17 -0500
User-Agent: KMail/1.9.9
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200808131141.18003.mark.langsdorf@amd.com> <200808131230.07581.mark.langsdorf@amd.com> <20080813175232.GA1127@elte.hu>
In-Reply-To: <20080813175232.GA1127@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <200808131333.17850.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 13 Aug 2008 18:27:58.0354 (UTC) FILETIME=[4F984F20:01C8FD72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008, Ingo Molnar wrote:

> Thanks, this looks much better. Please create a wbinvd_halt() variant 
> a'la safe_halt() and please also add comments why that is needed.


When a CPU core is shut down, all of its caches need to be flushed
to prevent stale data from causing errors if the core is resumed.
Current Linux suspend code performs an assignment after the flush,
which can add dirty data back to the cache.  On some AMD platforms,
additional speculative reads have caused crashes on resume because
of this dirty data.

Relocate the cache flush to be the very last thing done before 
halting.  Tie into an assembly line so the compile will not
reorder it.  Add some documentation explaining what is going
on and why we're doing this.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Acked-by: Mark Borden <mark.borden@amd.com>
Acked-by: Michael Hohmuth <michael.hohmuth@amd.com>
diff -r 1e74a821dd00 arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c	Tue Aug 12 12:04:12 2008 -0500
+++ b/arch/x86/kernel/process_32.c	Wed Aug 13 08:05:36 2008 -0500
@@ -95,7 +95,6 @@ static inline void play_dead(void)
 {
 	/* This must be done before dead CPU ack */
 	cpu_exit_clear();
-	wbinvd();
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
@@ -104,8 +103,12 @@ static inline void play_dead(void)
 	 * With physical CPU hotplug, we should halt the cpu
 	 */
 	local_irq_disable();
-	while (1)
-		halt();
+	/* mask all interrupts, flush any and all caches, and halt */
+	if (cpu_has_clflush)
+		wbinvd_halt();
+	else
+		while (1)
+			halt();
 }
 #else
 static inline void play_dead(void)
diff -r 1e74a821dd00 arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c	Tue Aug 12 12:04:12 2008 -0500
+++ b/arch/x86/kernel/process_64.c	Wed Aug 13 08:05:41 2008 -0500
@@ -93,14 +93,17 @@ static inline void play_dead(void)
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
+	if (cpu_has_clflush)
+		wbinvd_halt();
+	else
+		while (1)
+			halt();
 }
 #else
 static inline void play_dead(void)
diff -r 1e74a821dd00 include/asm-x86/irqflags.h
--- a/include/asm-x86/irqflags.h	Tue Aug 12 12:04:12 2008 -0500
+++ b/include/asm-x86/irqflags.h	Wed Aug 13 07:52:10 2008 -0500
@@ -47,6 +47,16 @@ static inline void native_halt(void)
 static inline void native_halt(void)
 {
 	asm volatile("hlt": : :"memory");
+}
+
+/* 
+ * flush all caches and go into a halt
+ *  used to guarantee that caches are clean before halting
+ *  during suspend/resume operations
+ */
+static inline void wbinvd_halt(void)
+{
+	asm volatile("cli; wbinvd; 1: hlt; jmp 1b": : :"memory");
 }
 
 #endif


