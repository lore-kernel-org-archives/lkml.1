Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYHPKJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYHPKJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYHPKIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:08:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:46012 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbYHPKIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AuXPMghJlRLknyOsE+qA5qe4tUQbZPd+fPWjHFxVLEkLG2UQ9YqphTL7mpZiWcO6Kv
         n28DifFuIxk2r3+ugonSK6e7MNH+4JoiMyvWA9kgG1NAJNZ8y7+6McUsuukLnrNa0k/v
         kyGtj3phOi2gwj8CUElwhdAoYRG5EiHR7MV2k=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/5] x86: unify mask_IO_APIC_irq
Date: Sat, 16 Aug 2008 03:07:28 -0700
Message-Id: <1218881249-3028-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218881249-3028-4-git-send-email-yhlu.kernel@gmail.com>
References: <1218881249-3028-1-git-send-email-yhlu.kernel@gmail.com>
 <1218881249-3028-2-git-send-email-yhlu.kernel@gmail.com>
 <1218881249-3028-3-git-send-email-yhlu.kernel@gmail.com>
 <1218881249-3028-4-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use MACRO for 32 bit too

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic.c |   80 ++++++++++++----------------------------------
 1 file changed, 21 insertions(+), 59 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -608,18 +608,7 @@ static void __init replace_pin_at_irq(un
 		add_pin_to_irq(irq, newapic, newpin);
 }
 
-#ifdef CONFIG_X86_64
-/*
- * Synchronize the IO-APIC and the CPU by doing
- * a dummy read from the IO-APIC
- */
-static inline void io_apic_sync(unsigned int apic)
-{
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
-	readl(&io_apic->data);
-}
-
-#define __DO_ACTION(R, ACTION, FINAL)					\
+#define __DO_ACTION(R, ACTION_ENABLE, ACTION_DISABLE, FINAL)		\
 									\
 {									\
 	int pin;							\
@@ -634,7 +623,8 @@ static inline void io_apic_sync(unsigned
 			break;						\
 		pin = entry->pin;					\
 		reg = io_apic_read(entry->apic, 0x10 + R + pin*2);	\
-		reg ACTION;						\
+		reg ACTION_DISABLE;					\
+		reg ACTION_ENABLE;					\
 		io_apic_modify(entry->apic, 0x10 + R + pin*2, reg);	\
 		FINAL;							\
 		if (!entry->next)					\
@@ -643,66 +633,38 @@ static inline void io_apic_sync(unsigned
 	}								\
 }
 
-#define DO_ACTION(name,R,ACTION, FINAL)					\
+#define DO_ACTION(name,R, ACTION_ENABLE, ACTION_DISABLE, FINAL)		\
 									\
 	static void name##_IO_APIC_irq (unsigned int irq)		\
-	__DO_ACTION(R, ACTION, FINAL)
-
-/* mask = 1 */
-DO_ACTION(__mask,	0, |= IO_APIC_REDIR_MASKED, io_apic_sync(entry->apic))
+	__DO_ACTION(R, ACTION_ENABLE, ACTION_DISABLE, FINAL)
 
 /* mask = 0 */
-DO_ACTION(__unmask,	0, &= ~IO_APIC_REDIR_MASKED, )
+DO_ACTION(__unmask,	0, |= 0, &= ~IO_APIC_REDIR_MASKED, )
 
-#else
-
-static void __modify_IO_APIC_irq(unsigned int irq, unsigned long enable, unsigned long disable)
+#ifdef CONFIG_X86_64
+/*
+ * Synchronize the IO-APIC and the CPU by doing
+ * a dummy read from the IO-APIC
+ */
+static inline void io_apic_sync(unsigned int apic)
 {
-	struct irq_cfg *cfg;
-	struct irq_pin_list *entry;
-	unsigned int pin, reg;
-
-	cfg = irq_cfg(irq);
-	entry = cfg->irq_2_pin;
-	for (;;) {
-		if (!entry)
-			break;
-		pin = entry->pin;
-		reg = io_apic_read(entry->apic, 0x10 + pin*2);
-		reg &= ~disable;
-		reg |= enable;
-		io_apic_modify(entry->apic, 0x10 + pin*2, reg);
-		if (!entry->next)
-			break;
-		entry = entry->next;
-	}
+	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	readl(&io_apic->data);
 }
 
 /* mask = 1 */
-static void __mask_IO_APIC_irq(unsigned int irq)
-{
-	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_MASKED, 0);
-}
+DO_ACTION(__mask,	0, |= IO_APIC_REDIR_MASKED, &= ~0, io_apic_sync(entry->apic))
 
-/* mask = 0 */
-static void __unmask_IO_APIC_irq(unsigned int irq)
-{
-	__modify_IO_APIC_irq(irq, 0, IO_APIC_REDIR_MASKED);
-}
+#else
+
+/* mask = 1 */
+DO_ACTION(__mask,	0, |= IO_APIC_REDIR_MASKED, &= ~0, )
 
 /* mask = 1, trigger = 0 */
-static void __mask_and_edge_IO_APIC_irq(unsigned int irq)
-{
-	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_MASKED,
-				IO_APIC_REDIR_LEVEL_TRIGGER);
-}
+DO_ACTION(__mask_and_edge, 0, |= IO_APIC_REDIR_MASKED, &= ~IO_APIC_REDIR_LEVEL_TRIGGER, )
 
 /* mask = 0, trigger = 1 */
-static void __unmask_and_level_IO_APIC_irq(unsigned int irq)
-{
-	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_LEVEL_TRIGGER,
-				IO_APIC_REDIR_MASKED);
-}
+DO_ACTION(__unmask_and_level, 0, |= IO_APIC_REDIR_LEVEL_TRIGGER, &= ~IO_APIC_REDIR_MASKED, )
 
 #endif
 
