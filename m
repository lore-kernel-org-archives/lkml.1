Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbXHHHHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbXHHHHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbXHHHHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:07:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbXHHHHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:07:25 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/25] [PATCH] irq_flags / halt routines
Date: Wed,  8 Aug 2007 01:18:50 -0300
Message-Id: <11865467662182-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1186546763582-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch turns the irq_flags and halt routines into the
native versions.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-x86_64/irqflags.h |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86_64/irqflags.h b/include/asm-x86_64/irqflags.h
index 86e70fe..4ba5241 100644
--- a/include/asm-x86_64/irqflags.h
+++ b/include/asm-x86_64/irqflags.h
@@ -16,6 +16,22 @@
  * Interrupt control:
  */
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#  ifdef CONFIG_X86_VSMP
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+	return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
+}
+#  else
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+	return !(flags & X86_EFLAGS_IF);
+}
+#  endif
+
+#else /* PARAVIRT */
+
 static inline unsigned long __raw_local_save_flags(void)
 {
 	unsigned long flags;
@@ -31,9 +47,6 @@ static inline unsigned long __raw_local_save_flags(void)
 	return flags;
 }
 
-#define raw_local_save_flags(flags) \
-		do { (flags) = __raw_local_save_flags(); } while (0)
-
 static inline void raw_local_irq_restore(unsigned long flags)
 {
 	__asm__ __volatile__(
@@ -88,6 +101,10 @@ static inline int raw_irqs_disabled_flags(unsigned long flags)
 
 #endif
 
+#endif /* CONFIG_PARAVIRT */
+
+#define raw_local_save_flags(flags) \
+		do { (flags) = __raw_local_save_flags(); } while (0)
 /*
  * For spinlocks, etc.:
  */
@@ -115,7 +132,7 @@ static inline int raw_irqs_disabled(void)
  * Used in the idle loop; sti takes one instruction cycle
  * to complete:
  */
-static inline void raw_safe_halt(void)
+static inline void native_raw_safe_halt(void)
 {
 	__asm__ __volatile__("sti; hlt" : : : "memory");
 }
@@ -124,11 +141,16 @@ static inline void raw_safe_halt(void)
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

