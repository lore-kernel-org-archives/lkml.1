Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZDNPzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZDNPzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZDNPvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45993 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755415AbZDNPvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:48 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 08/14] [VOYAGER] x86: eliminate subarchitecture file do_timer.h
Date: Tue, 14 Apr 2009 10:51:34 -0500
Message-Id: <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one's a bit complex: voyager still needs a timer interrupt hook
because it doesn't have local apic timers and the scheduler relies on
each CPU ticking, so voyager must rebroadcast the pit clock.

Pull in the standard do_timer.h to time_32.c: all it was doing was
calling the global_clock_event event_handler.  However, also add a
specific voyager hook: voyager_timer_interrupt().

Hedge the asm/voyager.h file around with proper include guards and
make sure voyager_timer_interrupt() is inline empty if
CONFIG_X86_VOYAGER isn't defined.  Also add an is_voyager() check to
terminate the voyager_timer_interrupt() hook in case voyager is
compiled in but booted on a non-voayger architecture.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/include/asm/do_timer.h              |   16 ----------------
 arch/x86/include/asm/mach-voyager/do_timer.h |   17 -----------------
 arch/x86/include/asm/voyager.h               |   14 ++++++++++++++
 arch/x86/kernel/time_32.c                    |   11 +++++++----
 arch/x86/mach-voyager/voyager_basic.c        |    3 +++
 5 files changed, 24 insertions(+), 37 deletions(-)
 delete mode 100644 arch/x86/include/asm/do_timer.h
 delete mode 100644 arch/x86/include/asm/mach-voyager/do_timer.h

diff --git a/arch/x86/include/asm/do_timer.h b/arch/x86/include/asm/do_timer.h
deleted file mode 100644
index 23ecda0..0000000
--- a/arch/x86/include/asm/do_timer.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* defines for inline arch setup functions */
-#include <linux/clockchips.h>
-
-#include <asm/i8259.h>
-#include <asm/i8253.h>
-
-/**
- * do_timer_interrupt_hook - hook into timer tick
- *
- * Call the pit clock event handler. see asm/i8253.h
- **/
-
-static inline void do_timer_interrupt_hook(void)
-{
-	global_clock_event->event_handler(global_clock_event);
-}
diff --git a/arch/x86/include/asm/mach-voyager/do_timer.h b/arch/x86/include/asm/mach-voyager/do_timer.h
deleted file mode 100644
index 9e5a459..0000000
--- a/arch/x86/include/asm/mach-voyager/do_timer.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* defines for inline arch setup functions */
-#include <linux/clockchips.h>
-
-#include <asm/voyager.h>
-#include <asm/i8253.h>
-
-/**
- * do_timer_interrupt_hook - hook into timer tick
- *
- * Call the pit clock event handler. see asm/i8253.h
- **/
-static inline void do_timer_interrupt_hook(void)
-{
-	global_clock_event->event_handler(global_clock_event);
-	voyager_timer_interrupt();
-}
-
diff --git a/arch/x86/include/asm/voyager.h b/arch/x86/include/asm/voyager.h
index c03a6aa..b38a241 100644
--- a/arch/x86/include/asm/voyager.h
+++ b/arch/x86/include/asm/voyager.h
@@ -3,11 +3,15 @@
  * Author: J.E.J.Bottomley@HansenPartnership.com
  *
  * Standard include definitions for the NCR Voyager system */
+#ifndef _ASM_VOYAGER_H
+#define _ASM_VOYAGER_H
 
 #include <asm/voyager_bios.h>
 #include <asm/voyager_boot.h>
 #include <asm/voyager_vectors.h>
 
+#ifdef CONFIG_X86_VOYAGER
+
 #undef	VOYAGER_DEBUG
 #undef	VOYAGER_CAT_DEBUG
 
@@ -530,3 +534,13 @@ extern asmlinkage void qic_invalidate_interrupt(void);
 extern asmlinkage void qic_reschedule_interrupt(void);
 extern asmlinkage void qic_enable_irq_interrupt(void);
 extern asmlinkage void qic_call_function_interrupt(void);
+
+#else /* CONFIG_X86_VOYAGER */
+
+static inline void voyager_timer_interrupt(void)
+{
+}
+
+#endif /* CONFIG_X86_VOYAGER */
+
+#endif
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 5c5d87f..dcbe82a 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -28,6 +28,7 @@
  *	serialize accesses to xtime/lost_ticks).
  */
 
+#include <linux/clockchips.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/time.h>
@@ -37,8 +38,9 @@
 #include <asm/hpet.h>
 #include <asm/time.h>
 #include <asm/timer.h>
-
-#include <asm/do_timer.h>
+#include <asm/i8253.h>
+#include <asm/i8259.h>
+#include <asm/voyager.h>
 
 int timer_ack;
 
@@ -91,8 +93,9 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 		spin_unlock(&i8259A_lock);
 	}
 #endif
-
-	do_timer_interrupt_hook();
+	if (global_clock_event->event_handler)
+		global_clock_event->event_handler(global_clock_event);
+	voyager_timer_interrupt();
 
 #ifdef CONFIG_MCA
 	if (MCA_bus) {
diff --git a/arch/x86/mach-voyager/voyager_basic.c b/arch/x86/mach-voyager/voyager_basic.c
index 7581b5f..7c97c9a 100644
--- a/arch/x86/mach-voyager/voyager_basic.c
+++ b/arch/x86/mach-voyager/voyager_basic.c
@@ -161,6 +161,9 @@ int __init voyager_memory_detect(int region, __u32 * start, __u32 * length)
  * internal timer (The QIC does, but that's another story). */
 void voyager_timer_interrupt(void)
 {
+	if (!is_voyager())
+		return;
+
 	if ((jiffies & 0x3ff) == 0) {
 
 		/* There seems to be something flaky in either
-- 
1.6.2.1

