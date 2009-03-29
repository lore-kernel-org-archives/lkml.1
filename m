Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZC2Qxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZC2Qxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZC2Qxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:53:38 -0400
Received: from khc.piap.pl ([195.187.100.11]:52331 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZC2Qxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:53:37 -0400
To: linux-arm-kernel@lists.arm.linux.org.uk
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Some IRQ comment cleanups
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 29 Mar 2009 18:53:32 +0200
Message-ID: <m34oxcfeyb.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems IRQ_DELAYED_DISABLE is dead and desc->chip->handle_irq() now
lives as desc->handle_irq() (whitespace-damaged). Comments?

--- a/Documentation/DocBook/genericirq.tmpl
+++ b/Documentation/DocBook/genericirq.tmpl
@@ -417,8 +417,8 @@ desc->chip->end();
       </para>
       <para>
        To make use of the split implementation, replace the call to
-       __do_IRQ by a call to desc->chip->handle_irq() and associate
-        the appropriate handler function to desc->chip->handle_irq().
+       __do_IRQ by a call to desc->handle_irq() and associate
+        the appropriate handler function to desc->handle_irq().
        In most cases the generic handler implementations should
        be sufficient.
      </para>
--- a/arch/arm/include/asm/hw_irq.h
+++ b/arch/arm/include/asm/hw_irq.h
@@ -10,14 +10,6 @@ static inline void ack_bad_irq(int irq)
        irq_err_count++;
 }
 
-/*
- * Obsolete inline function for calling irq descriptor handlers.
- */
-static inline void desc_handle_irq(unsigned int irq, struct irq_desc *desc)
-{
-       desc->handle_irq(irq, desc);
-}
-
 void set_irq_flags(unsigned int irq, unsigned int flags);
 
 #define IRQF_VALID     (1 << 0)
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -251,7 +251,7 @@ extern int handle_IRQ_event(unsigned int irq, struct irqacti
 
 /*
  * Built-in IRQ handlers for various IRQ types,
- * callable via desc->chip->handle_irq()
+ * callable via desc->handle_irq()
  */
 extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);


Not sure what to do with the following (IRQ_DELAYED_DISABLE):

arch/x86/kernel/io_apic.c:
static int setup_ioapic_entry(int apic, int irq,
                              struct IO_APIC_route_entry *entry,
                              unsigned int destination, int trigger,
                              int polarity, int vector)
{
...
        /* Mask level triggered irqs.
         * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
         */
        if (trigger)
                entry->mask = 1;


Documentation/DocBook/genericirq.tmpl:
        <sect2 id="Delayed_interrupt_disable">
        <title>Delayed interrupt disable</title>
        <para>
        This per interrupt selectable feature, which was introduced by Russell
        King in the ARM interrupt implementation, does not mask an interrupt
        at the hardware level when disable_irq() is called. The interrupt is
        kept enabled and is masked in the flow handler when an interrupt event
        happens. This prevents losing edge interrupts on hardware which does
        not store an edge interrupt event while the interrupt is disabled at
        the hardware level. When an interrupt arrives while the IRQ_DISABLED
        flag is set, then the interrupt is masked at the hardware level and
        the IRQ_PENDING bit is set. When the interrupt is re-enabled by
        enable_irq() the pending bit is checked and if it is set, the
        interrupt is resent either via hardware or by a software resend
        mechanism. (It's necessary to enable CONFIG_HARDIRQS_SW_RESEND when
        you want to use the delayed interrupt disable feature and your
        hardware is not capable of retriggering an interrupt.)
        The delayed interrupt disable can be runtime enabled, per interrupt,
        by setting the IRQ_DELAYED_DISABLE flag in the irq_desc status field.
        </para>
        </sect2>

-- 
Krzysztof Halasa
