Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYILRkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYILRkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYILRjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:39:54 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:41165 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753647AbYILRjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:39:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UOy5aH4EJ6paWbqS5h8hRYDKEMGkftnojFTUGbsN6HFJWwclaEUdnYBwkmHEiSDwg7Dt5vrrzlrAeEPtKEno1AeHVUnuJ7ZxI584255LjRCcPItXzs+FyAuxnKBaghOaQkrK4eZsYMoniiBAzHg9ZehLH2O8Ma/LbMjw+Iip5c4=  ;
X-YMail-OSG: kLLA7M4VM1kidOvfHAPGm07bLEgIsezCD3vddfcZvKGYPsESyv8JAesloepMxvsAmAn2uEicV1hcdg9f2gQ5FQpEp8W8oyboSBYZAx6oNSgLdMd8YU9lI6Aw5AvEsRhSLM6znXSTKfWx0mf06eYzwnEG
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.27-rc6] genirq: record trigger type
Date: Fri, 12 Sep 2008 10:15:22 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121015.22505.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Genirq hasn't previously recorded the trigger type used by any
given IRQ, although some irq_chip support has done so.  That
data can be useful when troubleshooting.  This patch records it
in the relevant irq_desc.status bits, and improves consistency
between the two driver-visible calls affected:

 - Make set_irq_type() usage match request_irq() usage:
    * IRQ_TYPE_NONE should be a NOP; succeed, so irq_chip methods
      won't have to handle that case any more (many do it wrong).
    * IRQ_TYPE_PROBE is ignored; any buggy out-of-tree callers
      might need to switch over to the real IRQ probing code.
    * emit the same diagnostics (from shared utility code)

 - Their kerneldoc now reflects usage:
    * request_irq() flags include IRQF_TRIGGER_* to specify
      active edge(s)/level ... docs previously omitted that
    * set_irq_type() is declared in <linux/irq.h> so callers
      should use the (bit-equivalent) IRQ_TYPE_* symbols there

Also:  adds a warning about shared IRQs that don't end up using
the requested trigger mode; and fix an unrelated "sparse" warning.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 kernel/irq/chip.c      |   16 +++++++++-------
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |   21 ++++++++++++++++++---
 3 files changed, 30 insertions(+), 10 deletions(-)

--- a/kernel/irq/chip.c	2008-08-15 16:38:16.000000000 -0700
+++ b/kernel/irq/chip.c	2008-08-15 18:17:23.000000000 -0700
@@ -111,9 +111,9 @@ int set_irq_chip(unsigned int irq, struc
 EXPORT_SYMBOL(set_irq_chip);
 
 /**
- *	set_irq_type - set the irq type for an irq
+ *	set_irq_type - set the irq trigger type for an irq
  *	@irq:	irq number
- *	@type:	interrupt type - see include/linux/interrupt.h
+ *	@type:	IRQ_TYPE_{LEVEL,EDGE}_* value - see include/linux/irq.h
  */
 int set_irq_type(unsigned int irq, unsigned int type)
 {
@@ -126,12 +126,14 @@ int set_irq_type(unsigned int irq, unsig
 		return -ENODEV;
 	}
 
+	if (type == IRQ_TYPE_NONE)
+		return 0;
+
 	desc = irq_desc + irq;
-	if (desc->chip->set_type) {
-		spin_lock_irqsave(&desc->lock, flags);
-		ret = desc->chip->set_type(irq, type);
-		spin_unlock_irqrestore(&desc->lock, flags);
-	}
+	spin_lock_irqsave(&desc->lock, flags);
+	ret = __irq_set_trigger(desc, irq, flags);
+	spin_unlock_irqrestore(&desc->lock, flags);
+
 	return ret;
 }
 EXPORT_SYMBOL(set_irq_type);
--- a/kernel/irq/internals.h	2008-08-15 16:38:16.000000000 -0700
+++ b/kernel/irq/internals.h	2008-08-15 18:17:14.000000000 -0700
@@ -10,6 +10,9 @@ extern void irq_chip_set_defaults(struct
 /* Set default handler: */
 extern void compat_irq_chip_set_default_handler(struct irq_desc *desc);
 
+extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
+		unsigned long flags);
+
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq);
 extern void register_handler_proc(unsigned int irq, struct irqaction *action);
--- a/kernel/irq/manage.c	2008-08-15 17:46:41.000000000 -0700
+++ b/kernel/irq/manage.c	2008-08-15 18:28:42.000000000 -0700
@@ -216,7 +216,7 @@ void enable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(enable_irq);
 
-int set_irq_wake_real(unsigned int irq, unsigned int on)
+static int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	int ret = -ENXIO;
@@ -305,10 +305,11 @@ void compat_irq_chip_set_default_handler
 		desc->handle_irq = NULL;
 }
 
-static int __irq_set_trigger(struct irq_chip *chip, unsigned int irq,
+int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags)
 {
 	int ret;
+	struct irq_chip *chip = desc->chip;
 
 	if (!chip || !chip->set_type) {
 		/*
@@ -326,6 +327,11 @@ static int __irq_set_trigger(struct irq_
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
 				(int)(flags & IRQF_TRIGGER_MASK),
 				irq, chip->set_type);
+	else {
+		/* note that IRQF_TRIGGER_MASK == IRQ_TYPE_SENSE_MASK */
+		desc->status &= ~IRQ_TYPE_SENSE_MASK;
+		desc->status |= flags & IRQ_TYPE_SENSE_MASK;
+	}
 
 	return ret;
 }
@@ -404,7 +410,7 @@ int setup_irq(unsigned int irq, struct i
 
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
-			ret = __irq_set_trigger(desc->chip, irq, new->flags);
+			ret = __irq_set_trigger(desc, irq, new->flags);
 
 			if (ret) {
 				spin_unlock_irqrestore(&desc->lock, flags);
@@ -433,6 +439,14 @@ int setup_irq(unsigned int irq, struct i
 
 		/* Set default affinity mask once everything is setup */
 		irq_select_affinity(irq);
+
+	} else if ((new->flags & IRQF_TRIGGER_MASK)
+			&& (new->flags & IRQF_TRIGGER_MASK)
+				!= (desc->status & IRQ_TYPE_SENSE_MASK)) {
+		/* hope the handler works with the actual trigger mode... */
+		pr_warning("IRQ %d uses trigger mode %d; requested %d\n",
+				irq, (int)(desc->status & IRQ_TYPE_SENSE_MASK),
+				(int)(new->flags & IRQF_TRIGGER_MASK));
 	}
 
 	*p = new;
@@ -589,6 +603,7 @@ EXPORT_SYMBOL(free_irq);
  *	IRQF_SHARED		Interrupt is shared
  *	IRQF_DISABLED	Disable local interrupts while processing
  *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
+ *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
  */
 int request_irq(unsigned int irq, irq_handler_t handler,
