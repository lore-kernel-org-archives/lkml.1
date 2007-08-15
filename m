Return-Path: <linux-kernel-owner+w=401wt.eu-S1765235AbXHONCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765235AbXHONCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762147AbXHOMzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:55:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762057AbXHOMzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:55:37 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/25][V3] irq_flags / halt routines
Date: Wed, 15 Aug 2007 09:49:23 -0300
Message-Id: <11871822163867-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11871822062386-git-send-email-gcosta@redhat.com>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch turns the irq_flags and halt routines into the
native versions.

[ updates from v1
Move raw_irqs_disabled_flags outside of the PARAVIRT ifdef to
avoid increasing the mess, suggested by Andi Kleen
]

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-x86_64/irqflags.h |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/include/asm-x86_64/irqflags.h b/include/asm-x86_64/irqflags.h
index 86e70fe..fe0d346 100644
--- a/include/asm-x86_64/irqflags.h
+++ b/include/asm-x86_64/irqflags.h
@@ -16,6 +16,10 @@
  * Interrupt control:
  */
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else /* PARAVIRT */
+
 static inline unsigned long __raw_local_save_flags(void)
 {
 	unsigned long flags;
@@ -31,9 +35,6 @@ static inline unsigned long __raw_local_save_flags(void)
 	return flags;
 }
 
-#define raw_local_save_flags(flags) \
-		do { (flags) = __raw_local_save_flags(); } while (0)
-
 static inline void raw_local_irq_restore(unsigned long flags)
 {
 	__asm__ __volatile__(
@@ -64,11 +65,6 @@ static inline void raw_local_irq_enable(void)
 	raw_local_irq_restore((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
 }
 
-static inline int raw_irqs_disabled_flags(unsigned long flags)
-{
-	return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
-}
-
 #else /* CONFIG_X86_VSMP */
 
 static inline void raw_local_irq_disable(void)
@@ -81,13 +77,27 @@ static inline void raw_local_irq_enable(void)
 	__asm__ __volatile__("sti" : : : "memory");
 }
 
+#endif /* CONFIG_X86_VSMP */
+#endif /* CONFIG_PARAVIRT */
+
+/* Those are not paravirt stubs, so they live out of the PARAVIRT ifdef */
+
+#ifdef CONFIG_X86_VSMP
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+	return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
+}
+
+#else
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
 	return !(flags & X86_EFLAGS_IF);
 }
 
-#endif
+#endif /* CONFIG_X86_VSMP */
 
+#define raw_local_save_flags(flags) \
+		do { (flags) = __raw_local_save_flags(); } while (0)
 /*
  * For spinlocks, etc.:
  */
@@ -115,7 +125,7 @@ static inline int raw_irqs_disabled(void)
  * Used in the idle loop; sti takes one instruction cycle
  * to complete:
  */
-static inline void raw_safe_halt(void)
+static inline void native_raw_safe_halt(void)
 {
 	__asm__ __volatile__("sti; hlt" : : : "memory");
 }
@@ -124,11 +134,16 @@ static inline void raw_safe_halt(void)
  * Used when interrupts are already enabled or to
  * shutdown the processor:
  */
-static inline void halt(void)
+static inline void native_halt(void)
 {
 	__asm__ __volatile__("hlt": : :"memory");
 }
 
+#ifndef CONFIG_PARAVIRT
+#define raw_safe_halt	native_raw_safe_halt
+#define halt		native_halt
+#endif /* ! CONFIG_PARAVIRT */
+
 #else /* __ASSEMBLY__: */
 # ifdef CONFIG_TRACE_IRQFLAGS
 #  define TRACE_IRQS_ON		call trace_hardirqs_on_thunk
-- 
1.4.4.2

