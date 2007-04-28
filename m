Return-Path: <linux-kernel-owner+w=401wt.eu-S1030998AbXD1DNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030998AbXD1DNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030977AbXD1DNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:13:00 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:47963 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030968AbXD1DM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:12:59 -0400
Subject: [PATCH -rt] yet another irq storm
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 23:12:44 -0400
Message-Id: <1177729964.19619.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Must be global warming, I'm getting a lot more irq storms than usual.

Now that I switched over to x86_64, I booted up and got another irq
storm. So I added my previous patch and it didn't fix it.  Looking
further, I found that the mask and unmask is done directly in the
x86_64/io_apic.c file.

This patch does basically the same thing as my previous patch, but to
the x86_64/io_apic.c file.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rt1/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux-2.6.21-rt1.orig/arch/x86_64/kernel/io_apic.c
+++ linux-2.6.21-rt1/arch/x86_64/kernel/io_apic.c
@@ -1437,7 +1437,8 @@ static void ack_apic_level(unsigned int 
 	irq_complete_move(irq);
 #if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING) &&
+	    !(irq_desc[irq].status & IRQ_INPROGRESS)) {
 		do_unmask_irq = 1;
 		mask_IO_APIC_irq(irq);
 	}


