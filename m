Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbYBYBhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbYBYBhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 20:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYBYBhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 20:37:09 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:6498 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbYBYBhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 20:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MWIHXayjqNRQORfZ7DGcBj2UnRcTmxXYZ1//TtwmW+YYg5jrF6Op11ArDHZy9gRTAhKzpA7SG0EVLh6sbyuMzRcrkHenp7NW749QMEYvKpVXCXQNVG96k40QsVhh6Hv5tFPafVFpTfHwsLRJuAW2YPL3g+wBvcXY6eOvqVRvVdE=
Message-ID: <93564eb70802241736l741e7406o29fab05a611c12c7@mail.gmail.com>
Date: Mon, 25 Feb 2008 10:36:59 +0900
From: "Samuel Masham" <samuel.masham@gmail.com>
To: stable@kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-mips@vger.kernel.org
Subject: 2.6.24 patches for mips qemu target needed for stable.
Cc: "Ralf Baechle" <ralf@linux-mips.org>, "Rob Landley" <rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stable team,

The mips build for qemu (and possibly other targets) crashes when
doing any irq probe.

Specifically this happens on boot when brining up the ne driver.

This is fixed by the following two patches from linus's tree

46f4f8f665080900e865392f4b3593be463bf0d8 - IRQ_NOPROBE helper functions
24649c00ca334955ac7d8a79f5a7834fc7ea441d - MIPS: Mark all but i8259
interrupts as no-probe.

They have no impact on any other architecture so I hope are simple to
include in the stable tree.

Thanks

Samuel

ps: Included below for reference but gmail will probably mangle the
white spaces...

commit 46f4f8f665080900e865392f4b3593be463bf0d8
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Fri Feb 8 04:22:01 2008 -0800

    IRQ_NOPROBE helper functions

    Probing non-ISA interrupts using the handle_percpu_irq as their handle_irq
    method may crash the system because handle_percpu_irq does not check
    IRQ_WAITING.  This for example hits the MIPS Qemu configuration.

    This patch provides two helper functions set_irq_noprobe and
set_irq_probe to
    set rsp.  clear the IRQ_NOPROBE flag.  The only current caller is MIPS code
    but this really belongs into generic code.

    As an aside, interrupt probing these days has become a mostly
obsolete if not
    dangerous art.  I think Linux interrupts should be changed to default to
    non-probing but that's subject of this patch.

    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
    Acked-and-tested-by: Rob Landley <rob@landley.net>
    Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/irq.h b/include/linux/irq.h
index a19b381..bfd9efb 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -367,6 +367,9 @@ set_irq_chained_handler(unsigned int irq,
 	__set_irq_handler(irq, handle, 1, NULL);
 }

+extern void set_irq_noprobe(unsigned int irq);
+extern void set_irq_probe(unsigned int irq);
+
 /* Handle dynamic irq creation and destruction */
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 10e0066..cc54c62 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -589,3 +589,39 @@ set_irq_chip_and_handler_name(unsigned int irq,
struct irq_chip *chip,
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
+		printk(KERN_ERR "Trying to mark IRQ%d non-probeable(J\(Bn", irq);
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
+		printk(KERN_ERR "Trying to mark IRQ%d probeable(J\(Bn", irq);
+
+		return;
+	}
+
+	desc = irq_desc + irq;
+
+	spin_lock_irqsave(&desc->lock, flags);
+	desc->status &= (J~(BIRQ_NOPROBE;
+	spin_unlock_irqrestore(&desc->lock, flags);
+}

commit 24649c00ca334955ac7d8a79f5a7834fc7ea441d
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Fri Feb 8 04:22:02 2008 -0800

    MIPS: Mark all but i8259 interrupts as no-probe.

    Use set_irq_noprobe() to mark all MIPS interrupts as non-probe.
Override that
    default for i8259 interrupts.

    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
    Acked-and-tested-by: Rob Landley <rob@landley.net>
    Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
index 197d797..413bd1d 100644
--- a/arch/mips/kernel/i8259.c
+++ b/arch/mips/kernel/i8259.c
@@ -338,8 +338,10 @@ void __init init_i8259_irqs(void)

 	init_8259A(0);

-	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++)
+	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++) {
 		set_irq_chip_and_handler(i, &i8259A_chip, handle_level_irq);
+		set_irq_probe(i);
+	}

 	setup_irq(I8259A_IRQ_BASE + PIC_CASCADE_IR, &irq2);
 }
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index d06e9c9..e3309ff 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
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
