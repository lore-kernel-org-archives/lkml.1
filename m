Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYIGT0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYIGT0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 15:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbYIGT0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 15:26:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:63607 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbYIGT0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 15:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Dr4HykUQsiKbZctbg66SXnKRwtAl/fdIkSN0nCCNdvTrvyWCRYrcENIC5A73Kfy4vT
         6nSDFL+/hLzRa5FmDLqfhK1EkbiW08rdo9SnVv8tvTAJMMkQqfBuirxHyQMNXBzrLNxA
         BH/TjI01YoPC7XfqKbKZysSRV6lIa7zxK+6yE=
Date: Sun, 7 Sep 2008 23:26:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC] x86: io-apic - convert DO_ACTION macro into function
Message-ID: <20080907192625.GC7515@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert DO_ACTION macro into more obvious io_apic_modify_irq
function with callers
---

 I found it more readable then original was. Especialy we could grep
the callers in normal way. It's just an attempt - free to drop this
patch. I hope I don't messed with all these masks :) So the question
is rather NOT about details but idea in general.

 io_apic.c |  102 ++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 50 insertions(+), 52 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-07 22:18:55.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-07 23:17:31.000000000 +0400
@@ -641,65 +641,63 @@ static void __init replace_pin_at_irq(un
 		add_pin_to_irq(irq, newapic, newpin);
 }
 
-#define __DO_ACTION(R, ACTION_ENABLE, ACTION_DISABLE, FINAL)		\
-									\
-{									\
-	int pin;							\
-	struct irq_cfg *cfg;						\
-	struct irq_pin_list *entry;					\
-									\
-	cfg = irq_cfg(irq);						\
-	entry = cfg->irq_2_pin;						\
-	for (;;) {							\
-		unsigned int reg;					\
-		if (!entry)						\
-			break;						\
-		pin = entry->pin;					\
-		reg = io_apic_read(entry->apic, 0x10 + R + pin*2);	\
-		reg ACTION_DISABLE;					\
-		reg ACTION_ENABLE;					\
-		io_apic_modify(entry->apic, 0x10 + R + pin*2, reg);	\
-		FINAL;							\
-		if (!entry->next)					\
-			break;						\
-		entry = entry->next;					\
-	}								\
-}
-
-#define DO_ACTION(name,R, ACTION_ENABLE, ACTION_DISABLE, FINAL)		\
-									\
-	static void name##_IO_APIC_irq (unsigned int irq)		\
-	__DO_ACTION(R, ACTION_ENABLE, ACTION_DISABLE, FINAL)
+/* modify chained irqs */
+static void io_apic_modify_irq(unsigned int irq, int io_reg,
+				int mask_and, int mask_or,
+				int mask_and_not, int read_after_mod)
+{
+	int pin;
+	struct irq_cfg *cfg;
+	struct irq_pin_list *entry;
 
-/* mask = 0 */
-DO_ACTION(__unmask,	0, |= 0, &= ~IO_APIC_REDIR_MASKED, )
+	cfg = irq_cfg(irq);
+	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+		unsigned int reg;
+		pin = entry->pin;
+		reg = io_apic_read(entry->apic, 0x10 + io_reg + pin * 2);
+		if (mask_and)
+			reg &= mask_and;
+		if (mask_or)
+			reg |= mask_or;
+		if (mask_and_not)
+			reg &= !mask_and_not;
+		io_apic_modify(entry->apic, 0x10 + io_reg + pin * 2, reg);
+		if (read_after_mod) {
+			/* dummy read to sync IO-APIC and CPU */
+			struct io_apic __iomem *p = io_apic_base(entry->apic);
+			readl(&p->data);
+		}
+	}
+}
 
-#ifdef CONFIG_X86_64
-/*
- * Synchronize the IO-APIC and the CPU by doing
- * a dummy read from the IO-APIC
- */
-static inline void io_apic_sync(unsigned int apic)
+static void __unmask_IO_APIC_irq(unsigned int irq)
 {
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
-	readl(&io_apic->data);
+	io_apic_modify_irq(irq, 0, ~IO_APIC_REDIR_MASKED, 0, 0, 0);
 }
 
-/* mask = 1 */
-DO_ACTION(__mask,	0, |= IO_APIC_REDIR_MASKED, &= ~0, io_apic_sync(entry->apic))
-
-#else
-
-/* mask = 1 */
-DO_ACTION(__mask,	0, |= IO_APIC_REDIR_MASKED, &= ~0, )
-
-/* mask = 1, trigger = 0 */
-DO_ACTION(__mask_and_edge, 0, |= IO_APIC_REDIR_MASKED, &= ~IO_APIC_REDIR_LEVEL_TRIGGER, )
+#ifdef CONFIG_X86_64
+static void __mask_IO_APIC_irq(unsigned int irq)
+{
+	io_apic_modify_irq(irq, 0, ~0, IO_APIC_REDIR_MASKED, 0, 1);
+}
+#else /* CONFIG_X86_32 */
+static void __mask_IO_APIC_irq(unsigned int irq)
+{
+	io_apic_modify_irq(irq, 0, ~0, IO_APIC_REDIR_MASKED, 0, 0);
+}
 
-/* mask = 0, trigger = 1 */
-DO_ACTION(__unmask_and_level, 0, |= IO_APIC_REDIR_LEVEL_TRIGGER, &= ~IO_APIC_REDIR_MASKED, )
+static void __mask_and_edge_IO_APIC_irq(unsigned int irq)
+{
+	io_apic_modify_irq(irq, 0, ~IO_APIC_REDIR_LEVEL_TRIGGER,
+			IO_APIC_REDIR_MASKED, 0, 0);
+}
 
-#endif
+static void __unmask_and_level_IO_APIC_irq(unsigned int irq)
+{
+	io_apic_modify_irq(irq, 0, ~IO_APIC_REDIR_MASKED,
+			IO_APIC_REDIR_LEVEL_TRIGGER, 0, 0);
+}
+#endif /* CONFIG_X86_32 */
 
 static void mask_IO_APIC_irq (unsigned int irq)
 {
