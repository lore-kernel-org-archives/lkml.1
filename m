Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbXI0LZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbXI0LZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbXI0LYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:24:55 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:54523 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbXI0LYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:24:54 -0400
Date: Thu, 27 Sep 2007 12:24:48 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Molnar Ingo <mingo@elte.hu>,
       benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH] Compile handle_percpu_irq even for uniprocessor kernels
Message-ID: <20070927112448.GA16909@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling handle_percpu_irq only on uniprocessor generates an artificial
special case so a typical use like:

  set_irq_chip_and_handler(irq, &some_irq_type, handle_percpu_irq);

needs to be conditionally compiled only on SMP systems as well and an
alternative UP construct is usually needed - for no good reason.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

---
This fixes uniprocessor configurations for some MIPS SMP systems.

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f1a73f0..9b5dff6 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -503,7 +503,6 @@ out_unlock:
 	spin_unlock(&desc->lock);
 }
 
-#ifdef CONFIG_SMP
 /**
  *	handle_percpu_IRQ - Per CPU local irq handler
  *	@irq:	the interrupt number
@@ -529,8 +528,6 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 		desc->chip->eoi(irq);
 }
 
-#endif /* CONFIG_SMP */
-
 void
 __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name)
