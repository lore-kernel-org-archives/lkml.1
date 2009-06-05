Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbZFEIUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbZFEIUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbZFEIGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37571 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743AbZFEIGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:05 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 38/62] Blackfin: make deferred hardware errors more exact
Date: Fri,  5 Jun 2009 04:04:47 -0400
Message-Id: <1244189111-19639-39-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Hardware errors on the Blackfin architecture are queued by nature of the
hardware design.  Things that could generate a hardware level queue up at
the system interface and might not process until much later, at which
point the system would send a notification back to the core.

As such, it is possible for user space code to do something that would
trigger a hardware error, but have it delay long enough for the process
context to switch.  So when the hardware error does signal, we mistakenly
evaluate it as a different process or as kernel context and panic (erp!).
This makes it pretty difficult to find the offending context.  But wait,
there is good news somewhere.

By forcing a SSYNC in the interrupt entry, we force all pending queues at
the system level to be processed and all hardware errors to be signaled.
Then we check the current interrupt state to see if the hardware error is
now signaled.  If so, we re-queue the current interrupt and return thus
allowing the higher priority hardware error interrupt to process properly.
Since we haven't done any other context processing yet, the right context
will be selected and killed.  There is still the possibility that the
exact offending instruction will be unknown, but at least we'll have a
much better idea of where to look.

The downside of course is that this causes system-wide syncs at every
interrupt point which results in significant performance degradation.
Since this situation should not occur in any properly configured system
(as hardware errors are triggered by things like bad pointers), make it a
debug configuration option and disable it by default.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig.debug           |   13 +++++
 arch/blackfin/include/asm/entry.h     |   92 +++++++++++++++++++++++++++++++-
 arch/blackfin/mach-common/entry.S     |   59 +++++++++++++++------
 arch/blackfin/mach-common/interrupt.S |   27 ++++++++++
 4 files changed, 170 insertions(+), 21 deletions(-)

diff --git a/arch/blackfin/Kconfig.debug b/arch/blackfin/Kconfig.debug
index 79e7e63..1fc4981 100644
--- a/arch/blackfin/Kconfig.debug
+++ b/arch/blackfin/Kconfig.debug
@@ -54,6 +54,19 @@ config DEBUG_HWERR
 	  hardware error interrupts and need to know where they are coming
 	  from.
 
+config EXACT_HWERR
+	bool "Try to make Hardware errors exact"
+	depends on DEBUG_HWERR
+	help
+	  By default, the Blackfin hardware errors are not exact - the error
+          be reported multiple cycles after the error happens. This delay
+	  can cause the wrong application, or even the kernel to receive a
+	  signal to be killed. If you are getting HW errors in your system,
+	  try turning this on to ensure they are at least comming from the
+	  proper thread.
+
+	  On production systems, it is safe (and a small optimization) to say N.
+
 config DEBUG_DOUBLEFAULT
 	bool "Debug Double Faults"
 	default n
diff --git a/arch/blackfin/include/asm/entry.h b/arch/blackfin/include/asm/entry.h
index b30a296..ec58efc 100644
--- a/arch/blackfin/include/asm/entry.h
+++ b/arch/blackfin/include/asm/entry.h
@@ -35,21 +35,39 @@
 #else
 # define LOAD_IPIPE_IPEND
 #endif
+
+#ifndef CONFIG_EXACT_HWERR
+/* As a debugging aid - we save IPEND when DEBUG_KERNEL is on,
+ * otherwise it is a waste of cycles.
+ */
+# ifndef CONFIG_DEBUG_KERNEL
+#define INTERRUPT_ENTRY(N)						\
+    [--sp] = SYSCFG;							\
+    [--sp] = P0;	/*orig_p0*/					\
+    [--sp] = R0;	/*orig_r0*/					\
+    [--sp] = (R7:0,P5:0);						\
+    R0 = (N);								\
+    LOAD_IPIPE_IPEND							\
+    jump __common_int_entry;
+# else /* CONFIG_DEBUG_KERNEL */
 #define INTERRUPT_ENTRY(N)						\
     [--sp] = SYSCFG;							\
-									\
     [--sp] = P0;	/*orig_p0*/					\
     [--sp] = R0;	/*orig_r0*/					\
     [--sp] = (R7:0,P5:0);						\
+    p0.l = lo(IPEND);							\
+    p0.h = hi(IPEND);							\
+    r1 = [p0];								\
     R0 = (N);								\
     LOAD_IPIPE_IPEND							\
     jump __common_int_entry;
+# endif /* CONFIG_DEBUG_KERNEL */
 
 /* For timer interrupts, we need to save IPEND, since the user_mode
-	   macro accesses it to determine where to account time.  */
+ *macro accesses it to determine where to account time.
+ */
 #define TIMER_INTERRUPT_ENTRY(N)					\
     [--sp] = SYSCFG;							\
-									\
     [--sp] = P0;	/*orig_p0*/					\
     [--sp] = R0;	/*orig_r0*/					\
     [--sp] = (R7:0,P5:0);						\
@@ -58,6 +76,74 @@
     r1 = [p0];								\
     R0 = (N);								\
     jump __common_int_entry;
+#else /* CONFIG_EXACT_HWERR is defined */
+
+/* if we want hardware error to be exact, we need to do a SSYNC (which forces
+ * read/writes to complete to the memory controllers), and check to see that
+ * caused a pending HW error condition. If so, we assume it was caused by user
+ * space, by setting the same interrupt that we are in (so it goes off again)
+ * and context restore, and a RTI (without servicing anything). This should
+ * cause the pending HWERR to fire, and when that is done, this interrupt will
+ * be re-serviced properly.
+ * As you can see by the code - we actually need to do two SSYNCS - one to
+ * make sure the read/writes complete, and another to make sure the hardware
+ * error is recognized by the core.
+ */
+#define INTERRUPT_ENTRY(N)						\
+    SSYNC;								\
+    SSYNC;								\
+    [--sp] = SYSCFG;							\
+    [--sp] = P0;	/*orig_p0*/					\
+    [--sp] = R0;	/*orig_r0*/					\
+    [--sp] = (R7:0,P5:0);						\
+    R1 = ASTAT;								\
+    P0.L = LO(ILAT);							\
+    P0.H = HI(ILAT);							\
+    R0 = [P0];								\
+    CC = BITTST(R0, EVT_IVHW_P);					\
+    IF CC JUMP 1f;							\
+    ASTAT = R1;								\
+    p0.l = lo(IPEND);							\
+    p0.h = hi(IPEND);							\
+    r1 = [p0];								\
+    R0 = (N);								\
+    LOAD_IPIPE_IPEND							\
+    jump __common_int_entry;						\
+1:  ASTAT = R1;								\
+    RAISE N;								\
+    (R7:0, P5:0) = [SP++];						\
+    SP += 0x8;								\
+    SYSCFG = [SP++];							\
+    CSYNC;								\
+    RTI;
+
+#define TIMER_INTERRUPT_ENTRY(N)					\
+    SSYNC;								\
+    SSYNC;								\
+    [--sp] = SYSCFG;							\
+    [--sp] = P0;	/*orig_p0*/					\
+    [--sp] = R0;	/*orig_r0*/					\
+    [--sp] = (R7:0,P5:0);						\
+    R1 = ASTAT;								\
+    P0.L = LO(ILAT);							\
+    P0.H = HI(ILAT);							\
+    R0 = [P0];								\
+    CC = BITTST(R0, EVT_IVHW_P);					\
+    IF CC JUMP 1f;							\
+    ASTAT = R1;								\
+    p0.l = lo(IPEND);							\
+    p0.h = hi(IPEND);							\
+    r1 = [p0];								\
+    R0 = (N);								\
+    jump __common_int_entry;						\
+1:  ASTAT = R1;								\
+    RAISE N;								\
+    (R7:0, P5:0) = [SP++];						\
+    SP += 0x8;								\
+    SYSCFG = [SP++];							\
+    CSYNC;								\
+    RTI;
+#endif	/* CONFIG_EXACT_HWERR */
 
 /* This one pushes RETI without using CLI.  Interrupts are enabled.  */
 #define SAVE_CONTEXT_SYSCALL	save_context_syscall
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index f0636fd..da0558a 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -200,7 +200,18 @@ ENTRY(_ex_single_step)
 	cc = r7 == 0;
 	if !cc jump 1f;
 #endif
-
+#ifdef CONFIG_EXACT_HWERR
+	/* Read the ILAT, and to check to see if the process we are
+	 * single stepping caused a previous hardware error
+	 * If so, do not single step, (which lowers to IRQ5, and makes
+	 * us miss the error).
+	 */
+	p5.l = lo(ILAT);
+	p5.h = hi(ILAT);
+	r7 = [p5];
+	cc = bittst(r7, EVT_IVHW_P);
+	if cc jump 1f;
+#endif
 	/* Single stepping only a single instruction, so clear the trace
 	 * bit here.  */
 	r7 = syscfg;
@@ -262,15 +273,6 @@ ENTRY(_bfin_return_from_exception)
 	r6 = 0x25;
 	CC = R7 == R6;
 	if CC JUMP _double_fault;
-
-	/* Did we cause a HW error? */
-	p5.l = lo(ILAT);
-	p5.h = hi(ILAT);
-	r6 = [p5];
-	r7 = 0x20;		/* Did I just cause anther HW error? */
-	r6 = r7 & r6;
-	CC = R7 == R6;
-	if CC JUMP _double_fault;
 #endif
 
 	(R7:6,P5:4) = [sp++];
@@ -472,6 +474,16 @@ ENTRY(_trap) /* Exception: 4th entry into system event table(supervisor mode)*/
 	[--sp] = ASTAT;
 	[--sp] = (R7:6,P5:4);
 
+#ifdef CONFIG_EXACT_HWERR
+	/* Make sure all pending read/writes complete. This will ensure any
+	 * accesses which could cause hardware errors completes, and signal
+	 * the the hardware before we do something silly, like crash the
+	 * kernel. We don't need to work around anomaly 05000312, since
+	 * we are already atomic
+	 */
+	ssync;
+#endif
+
 #if ANOMALY_05000283 || ANOMALY_05000315
 	cc = r7 == r7;
 	p5.h = HI(CHIPID);
@@ -854,7 +866,7 @@ ENTRY(_ret_from_exception)
 	p1.h = _schedule_and_signal;
 	[p0] = p1;
 	csync;
-	raise 15;		/* raise evt14 to do signal or reschedule */
+	raise 15;		/* raise evt15 to do signal or reschedule */
 4:
 	r0 = syscfg;
 	bitclr(r0, 0);
@@ -915,7 +927,7 @@ ENTRY(_return_from_int)
 	p1.h = _schedule_and_signal_from_int;
 	[p0] = p1;
 	csync;
-#if ANOMALY_05000281
+#if ANOMALY_05000281 || ANOMALY_05000461
 	r0.l = lo(SAFE_USER_INSTRUCTION);
 	r0.h = hi(SAFE_USER_INSTRUCTION);
 	reti = r0;
@@ -929,18 +941,27 @@ ENTRY(_return_from_int)
 ENDPROC(_return_from_int)
 
 ENTRY(_lower_to_irq14)
-#if ANOMALY_05000281
+#if ANOMALY_05000281 || ANOMALY_05000461
 	r0.l = lo(SAFE_USER_INSTRUCTION);
 	r0.h = hi(SAFE_USER_INSTRUCTION);
 	reti = r0;
 #endif
-	r0 = 0x401f;
+
+#ifdef CONFIG_DEBUG_HWERR
+	/* enable irq14 & hwerr interrupt, until we transition to _evt14_softirq */
+	r0 = (EVT_IVG14 | EVT_IVHW | EVT_IRPTEN | EVT_EVX | EVT_NMI | EVT_RST | EVT_EMU);
+#else
+	/* Only enable irq14 interrupt, until we transition to _evt14_softirq */
+	r0 = (EVT_IVG14 | EVT_IRPTEN | EVT_EVX | EVT_NMI | EVT_RST | EVT_EMU);
+#endif
 	sti r0;
 	raise 14;
 	rti;
+ENDPROC(_lower_to_irq14)
+
 ENTRY(_evt14_softirq)
 #ifdef CONFIG_DEBUG_HWERR
-	r0 = 0x3f;
+	r0 = (EVT_IVHW | EVT_IRPTEN | EVT_EVX | EVT_NMI | EVT_RST | EVT_EMU);
 	sti r0;
 #else
 	cli r0;
@@ -948,8 +969,9 @@ ENTRY(_evt14_softirq)
 	[--sp] = RETI;
 	SP += 4;
 	rts;
+ENDPROC(_evt14_softirq)
 
-_schedule_and_signal_from_int:
+ENTRY(_schedule_and_signal_from_int)
 	/* To end up here, vector 15 was changed - so we have to change it
 	 * back.
 	 */
@@ -982,8 +1004,9 @@ _schedule_and_signal_from_int:
 	call _finish_atomic_sections;
 	sp += 12;
 	jump.s .Lresume_userspace;
+ENDPROC(_schedule_and_signal_from_int)
 
-_schedule_and_signal:
+ENTRY(_schedule_and_signal)
 	SAVE_CONTEXT_SYSCALL
 	/* To end up here, vector 15 was changed - so we have to change it
 	 * back.
@@ -1001,7 +1024,7 @@ _schedule_and_signal:
 1:
 	RESTORE_CONTEXT
 	rti;
-ENDPROC(_lower_to_irq14)
+ENDPROC(_schedule_and_signal)
 
 /* We handle this 100% in exception space - to reduce overhead
  * Only potiential problem is if the software buffer gets swapped out of the
diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
index 0069c2d..9c46680 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -145,6 +145,14 @@ __common_int_entry:
 
 /* interrupt routine for ivhw - 5 */
 ENTRY(_evt_ivhw)
+	/* In case a single action kicks off multiple memory transactions, (like
+	 * a cache line fetch, - this can cause multiple hardware errors, let's
+	 * catch them all. First - make sure all the actions are complete, and
+	 * the core sees the hardware errors.
+	 */
+	SSYNC;
+	SSYNC;
+
 	SAVE_ALL_SYS
 #ifdef CONFIG_FRAME_POINTER
 	fp = 0;
@@ -159,6 +167,25 @@ ENTRY(_evt_ivhw)
 1:
 #endif
 
+	/* Handle all stacked hardware errors
+	 * To make sure we don't hang forever, only do it 10 times
+	 */
+	R0 = 0;
+	R2 = 10;
+1:
+	P0.L = LO(ILAT);
+	P0.H = HI(ILAT);
+	R1 = [P0];
+	CC = BITTST(R1, EVT_IVHW_P);
+	IF ! CC JUMP 2f;
+	/* OK a hardware error is pending - clear it */
+	R1 = EVT_IVHW_P;
+	[P0] = R1;
+	R0 += 1;
+	CC = R1 == R2;
+	if CC JUMP 2f;
+	JUMP 1b;
+2:
 	# We are going to dump something out, so make sure we print IPEND properly
 	p2.l = lo(IPEND);
 	p2.h = hi(IPEND);
-- 
1.6.3.1

