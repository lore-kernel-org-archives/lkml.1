Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYA2LVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYA2LVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbYA2LVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:21:23 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:37603 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYA2LVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:21:22 -0500
Date: Tue, 29 Jan 2008 11:21:20 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: [PATCH 2/2] MIPS: Mark all but i8259 interrupts as no-probe.
Message-ID: <20080129112120.GB8665@linux-mips.org>
References: <200801280217.38273.rob@landley.net> <20080129111622.GC7237@linux-mips.org> <20080129112048.GA8665@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129112048.GA8665@linux-mips.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use set_irq_noprobe() to mark all MIPS interrupts as non-probe.  Override
that default for i8259 interrupts.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/kernel/i8259.c |    4 +++-
 arch/mips/kernel/irq.c   |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-mips/arch/mips/kernel/i8259.c
===================================================================
--- linux-mips.orig/arch/mips/kernel/i8259.c
+++ linux-mips/arch/mips/kernel/i8259.c
@@ -338,8 +338,10 @@ void __init init_i8259_irqs(void)
 
 	init_8259A(0);
 
-	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++)
+	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++) {
 		set_irq_chip_and_handler(i, &i8259A_chip, handle_level_irq);
+		set_irq_probe(i);
+	}
 
 	setup_irq(I8259A_IRQ_BASE + PIC_CASCADE_IR, &irq2);
 }
Index: linux-mips/arch/mips/kernel/irq.c
===================================================================
--- linux-mips.orig/arch/mips/kernel/irq.c
+++ linux-mips/arch/mips/kernel/irq.c
@@ -145,6 +145,11 @@ __setup("nokgdb", nokgdb);
 
 void __init init_IRQ(void)
 {
+	int i;
+
+	for (i = 0; i < NR_IRQS; i++)
+		set_irq_noprobe(i);
+
 	arch_init_irq();
 
 #ifdef CONFIG_KGDB
