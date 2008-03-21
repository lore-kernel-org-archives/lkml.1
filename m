Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbYCUWpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbYCUWpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbYCUWpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:45:39 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34660 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049AbYCUWpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:45:39 -0400
Message-Id: <20080321224343.041836908@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:06 -0700
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
Subject: [patch 16/76] MIPS: Mark all but i8259 interrupts as no-probe.
Content-Disposition: inline; filename=mips-mark-all-but-i8259-interrupts-as-no-probe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Ralf Baechle <ralf@linux-mips.org>

Use set_irq_noprobe() to mark all MIPS interrupts as non-probe.  Override that
default for i8259 interrupts.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-and-tested-by: Rob Landley <rob@landley.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/mips/kernel/i8259.c |    4 +++-
 arch/mips/kernel/irq.c   |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- linux-2.6.24.3.orig/arch/mips/kernel/i8259.c
+++ linux-2.6.24.3/arch/mips/kernel/i8259.c
@@ -338,8 +338,10 @@ void __init init_i8259_irqs(void)
 
 	init_8259A(0);
 
-	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++)
+	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++) {
 		set_irq_chip_and_handler(i, &i8259A_chip, handle_level_irq);
+		set_irq_probe(i);
+	}
 
 	setup_irq(I8259A_IRQ_BASE + PIC_CASCADE_IR, &irq2);
 }
--- linux-2.6.24.3.orig/arch/mips/kernel/irq.c
+++ linux-2.6.24.3/arch/mips/kernel/irq.c
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

-- 
