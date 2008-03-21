Return-Path: <linux-kernel-owner+w=401wt.eu-S1764111AbYCUWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764111AbYCUWy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763572AbYCUWtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:49:45 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59035 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763565AbYCUWto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:49:44 -0400
Message-Id: <20080321224340.966183178@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:05 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 15/76] IRQ_NOPROBE helper functions
Content-Disposition: inline; filename=irq_noprobe-helper-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Ralf Baechle <ralf@linux-mips.org>

Probing non-ISA interrupts using the handle_percpu_irq as their handle_irq
method may crash the system because handle_percpu_irq does not check
IRQ_WAITING.  This for example hits the MIPS Qemu configuration.

This patch provides two helper functions set_irq_noprobe and set_irq_probe to
set rsp.  clear the IRQ_NOPROBE flag.  The only current caller is MIPS code
but this really belongs into generic code.

As an aside, interrupt probing these days has become a mostly obsolete if not
dangerous art.  I think Linux interrupts should be changed to default to
non-probing but that's subject of this patch.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-and-tested-by: Rob Landley <rob@landley.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/irq.h |    3 +++
 kernel/irq/chip.c   |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

--- linux-2.6.24.3.orig/include/linux/irq.h
+++ linux-2.6.24.3/include/linux/irq.h
@@ -367,6 +367,9 @@ set_irq_chained_handler(unsigned int irq
 	__set_irq_handler(irq, handle, 1, NULL);
 }
 
+extern void set_irq_noprobe(unsigned int irq);
+extern void set_irq_probe(unsigned int irq);
+
 /* Handle dynamic irq creation and destruction */
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
--- linux-2.6.24.3.orig/kernel/irq/chip.c
+++ linux-2.6.24.3/kernel/irq/chip.c
@@ -607,3 +607,39 @@ set_irq_chip_and_handler_name(unsigned i
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

-- 
