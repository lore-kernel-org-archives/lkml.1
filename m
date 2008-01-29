Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbYA2LVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbYA2LVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYA2LUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:20:54 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:37591 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYA2LUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:20:52 -0500
Date: Tue, 29 Jan 2008 11:20:48 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: [PATCH 1/2] IRQ_NOPROBE helper functions
Message-ID: <20080129112048.GA8665@linux-mips.org>
References: <200801280217.38273.rob@landley.net> <20080129111622.GC7237@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129111622.GC7237@linux-mips.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probing non-ISA interrupts using the handle_percpu_irq as their handle_irq
method may crash the system because handle_percpu_irq does not check
IRQ_WAITING.  This for example hits the MIPS Qemu configuration.

This patch provides two helper functions set_irq_noprobe and set_irq_probe
to set rsp. clear the IRQ_NOPROBE flag.  The only current caller is MIPS
code but this really belongs into generic code.

As an aside, interrupt probing these days has become a mostly obsolete if
not dangerous art.  I think Linux interrupts should be changed to default
to non-probing but that's subject of this patch.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 include/linux/irq.h |    3 +++
 kernel/irq/chip.c   |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

Index: linux-mips/include/linux/irq.h
===================================================================
--- linux-mips.orig/include/linux/irq.h
+++ linux-mips/include/linux/irq.h
@@ -367,6 +367,9 @@ set_irq_chained_handler(unsigned int irq
 	__set_irq_handler(irq, handle, 1, NULL);
 }
 
+extern void set_irq_noprobe(unsigned int irq);
+extern void set_irq_probe(unsigned int irq);
+
 /* Handle dynamic irq creation and destruction */
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
Index: linux-mips/kernel/irq/chip.c
===================================================================
--- linux-mips.orig/kernel/irq/chip.c
+++ linux-mips/kernel/irq/chip.c
@@ -589,3 +589,39 @@ set_irq_chip_and_handler_name(unsigned i
 	set_irq_chip(irq, chip);
 	__set_irq_handler(irq, handle, 0, name);
 }
+
+void __init set_irq_noprobe(unsigned int irq)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+
+	if (irq >= NR_IRQS) {
+		printk(KERN_ERR "Trying to mark IRQ%d non-probeable\n", irq);
+
+		return;
+	}
+
+	desc = irq_desc + irq;
+
+	spin_lock_irqsave(&desc->lock, flags);
+	desc->status |= IRQ_NOPROBE;
+	spin_unlock_irqrestore(&desc->lock, flags);
+}
+
+void __init set_irq_probe(unsigned int irq)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+
+	if (irq >= NR_IRQS) {
+		printk(KERN_ERR "Trying to mark IRQ%d probeable\n", irq);
+
+		return;
+	}
+
+	desc = irq_desc + irq;
+
+	spin_lock_irqsave(&desc->lock, flags);
+	desc->status &= ~IRQ_NOPROBE;
+	spin_unlock_irqrestore(&desc->lock, flags);
+}
