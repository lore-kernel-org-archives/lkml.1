Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbXGUW3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbXGUW3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbXGUW3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:29:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53273 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbXGUW3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:29:03 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 2/3] take sparc32 enable_irq/disable_irq out of line
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Message-Id: <E1ICNRe-0000lc-Bf@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 21 Jul 2007 23:29:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/irq.c         |   25 ++++++++++++++++++++++---
 arch/sparc/kernel/irq.h         |   20 ++++++++++++++++++++
 arch/sparc/kernel/sparc_ksyms.c |    2 --
 arch/sparc/kernel/sun4d_irq.c   |    4 ++--
 arch/sparc/kernel/tick14.c      |    4 ++--
 include/asm-sparc/irq.h         |   32 +++-----------------------------
 6 files changed, 49 insertions(+), 38 deletions(-)

diff --git a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
index 5e9af30..75b2240 100644
--- a/arch/sparc/kernel/irq.c
+++ b/arch/sparc/kernel/irq.c
@@ -270,7 +270,7 @@ void free_irq(unsigned int irq, void *dev_id)
 	kfree(action);
 
 	if (!sparc_irq[cpu_irq].action)
-		disable_irq(irq);
+		__disable_irq(irq);
 
 out_unlock:
 	spin_unlock_irqrestore(&irq_action_lock, flags);
@@ -466,7 +466,7 @@ int request_fast_irq(unsigned int irq,
 
 	sparc_irq[cpu_irq].action = action;
 
-	enable_irq(irq);
+	__enable_irq(irq);
 
 	ret = 0;
 out_unlock:
@@ -546,7 +546,7 @@ int request_irq(unsigned int irq,
 
 	*actionp = action;
 
-	enable_irq(irq);
+	__enable_irq(irq);
 
 	ret = 0;
 out_unlock:
@@ -557,6 +557,25 @@ out:
 
 EXPORT_SYMBOL(request_irq);
 
+void disable_irq_nosync(unsigned int irq)
+{
+	return __disable_irq(irq);
+}
+EXPORT_SYMBOL(disable_irq_nosync);
+
+void disable_irq(unsigned int irq)
+{
+	return __disable_irq(irq);
+}
+EXPORT_SYMBOL(disable_irq);
+
+void enable_irq(unsigned int irq)
+{
+	return __enable_irq(irq);
+}
+
+EXPORT_SYMBOL(enable_irq);
+
 /* We really don't need these at all on the Sparc.  We only have
  * stubs here because they are exported to modules.
  */
diff --git a/arch/sparc/kernel/irq.h b/arch/sparc/kernel/irq.h
index 8254a86..32ef3eb 100644
--- a/arch/sparc/kernel/irq.h
+++ b/arch/sparc/kernel/irq.h
@@ -1,11 +1,31 @@
 #include <asm/btfixup.h>
 
+/* Dave Redman (djhr@tadpole.co.uk)
+ * changed these to function pointers.. it saves cycles and will allow
+ * the irq dependencies to be split into different files at a later date
+ * sun4c_irq.c, sun4m_irq.c etc so we could reduce the kernel size.
+ * Jakub Jelinek (jj@sunsite.mff.cuni.cz)
+ * Changed these to btfixup entities... It saves cycles :)
+ */
+
+BTFIXUPDEF_CALL(void, disable_irq, unsigned int)
+BTFIXUPDEF_CALL(void, enable_irq, unsigned int)
 BTFIXUPDEF_CALL(void, disable_pil_irq, unsigned int)
 BTFIXUPDEF_CALL(void, enable_pil_irq, unsigned int)
 BTFIXUPDEF_CALL(void, clear_clock_irq, void)
 BTFIXUPDEF_CALL(void, clear_profile_irq, int)
 BTFIXUPDEF_CALL(void, load_profile_irq, int, unsigned int)
 
+static inline void __disable_irq(unsigned int irq)
+{
+	BTFIXUP_CALL(disable_irq)(irq);
+}
+
+static inline void __enable_irq(unsigned int irq)
+{
+	BTFIXUP_CALL(enable_irq)(irq);
+}
+
 static inline void disable_pil_irq(unsigned int irq)
 {
 	BTFIXUP_CALL(disable_pil_irq)(irq);
diff --git a/arch/sparc/kernel/sparc_ksyms.c b/arch/sparc/kernel/sparc_ksyms.c
index d8e008a..55bac51 100644
--- a/arch/sparc/kernel/sparc_ksyms.c
+++ b/arch/sparc/kernel/sparc_ksyms.c
@@ -154,8 +154,6 @@ EXPORT_SYMBOL(BTFIXUP_CALL(___xchg32));
 #else
 EXPORT_SYMBOL(BTFIXUP_CALL(__hard_smp_processor_id));
 #endif
-EXPORT_SYMBOL(BTFIXUP_CALL(enable_irq));
-EXPORT_SYMBOL(BTFIXUP_CALL(disable_irq));
 EXPORT_SYMBOL(BTFIXUP_CALL(mmu_unlockarea));
 EXPORT_SYMBOL(BTFIXUP_CALL(mmu_lockarea));
 EXPORT_SYMBOL(BTFIXUP_CALL(mmu_get_scsi_sgl));
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index 7a09186..e0efab2 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -190,7 +190,7 @@ void sun4d_free_irq(unsigned int irq, void *dev_id)
 	kfree(action);
 
 	if (!(*actionp))
-		disable_irq(irq);
+		__disable_irq(irq);
 
 out_unlock:
 	spin_unlock_irqrestore(&irq_action_lock, flags);
@@ -348,7 +348,7 @@ int sun4d_request_irq(unsigned int irq,
 	else
 		*actionp = action;
 		
-	enable_irq(irq);
+	__enable_irq(irq);
 
 	ret = 0;
 out_unlock:
diff --git a/arch/sparc/kernel/tick14.c b/arch/sparc/kernel/tick14.c
index a55f046..707bfda 100644
--- a/arch/sparc/kernel/tick14.c
+++ b/arch/sparc/kernel/tick14.c
@@ -64,7 +64,7 @@ void claim_ticker14(irq_handler_t handler,
 
 	/* first we copy the obp handler instructions
 	 */
-	disable_irq(irq_nr);
+	__disable_irq(irq_nr);
 	if (!handler)
 		return;
     
@@ -81,6 +81,6 @@ void claim_ticker14(irq_handler_t handler,
 			 NULL)) {
 		install_linux_ticker();
 		load_profile_irq(cpu, timeout);
-		enable_irq(irq_nr);
+		__enable_irq(irq_nr);
 	}
 }
diff --git a/include/asm-sparc/irq.h b/include/asm-sparc/irq.h
index 4582793..afb88a5 100644
--- a/include/asm-sparc/irq.h
+++ b/include/asm-sparc/irq.h
@@ -7,41 +7,15 @@
 #ifndef _SPARC_IRQ_H
 #define _SPARC_IRQ_H
 
-#include <linux/linkage.h>
-#include <linux/threads.h>     /* For NR_CPUS */
 #include <linux/interrupt.h>
 
-#include <asm/system.h>     /* For SUN4M_NCPUS */
-#include <asm/btfixup.h>
-
 #define NR_IRQS    16
 
 #define irq_canonicalize(irq)	(irq)
 
-/* Dave Redman (djhr@tadpole.co.uk)
- * changed these to function pointers.. it saves cycles and will allow
- * the irq dependencies to be split into different files at a later date
- * sun4c_irq.c, sun4m_irq.c etc so we could reduce the kernel size.
- * Jakub Jelinek (jj@sunsite.mff.cuni.cz)
- * Changed these to btfixup entities... It saves cycles :)
- */
-BTFIXUPDEF_CALL(void, disable_irq, unsigned int)
-BTFIXUPDEF_CALL(void, enable_irq, unsigned int)
-
-static inline void disable_irq_nosync(unsigned int irq)
-{
-	BTFIXUP_CALL(disable_irq)(irq);
-}
-
-static inline void disable_irq(unsigned int irq)
-{
-	BTFIXUP_CALL(disable_irq)(irq);
-}
-
-static inline void enable_irq(unsigned int irq)
-{
-	BTFIXUP_CALL(enable_irq)(irq);
-}
+extern void disable_irq_nosync(unsigned int irq);
+extern void disable_irq(unsigned int irq);
+extern void enable_irq(unsigned int irq);
 
 extern int request_fast_irq(unsigned int irq, irq_handler_t handler, unsigned long flags, __const__ char *devname);
 
-- 
1.5.3.GIT
