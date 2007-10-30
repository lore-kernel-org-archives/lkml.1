Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbXJ3JbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbXJ3JbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbXJ3JbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:31:13 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:36597 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbXJ3JbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:31:12 -0400
Date: Tue, 30 Oct 2007 10:31:01 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093101.GI11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- New file include/asm-cris/irq_regs.h.
- Change handling of registers for do_IRQ.
- Add GENERIC_HARDIRQS to Kconfig.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 arch/cris/Kconfig                            |    4 ++++
 linux-2.6.23-mod/include/asm-cris/irq_regs.h |    1 +
 linux-2.6.23/arch/cris/kernel/irq.c          |    6 ++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

--- /dev/null	2007-10-06 06:38:38.348072750 +0200
+++ linux-2.6.23-mod/include/asm-cris/irq_regs.h	2007-10-22 11:13:32.000000000 +0200
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/arch/cris/kernel/irq.c linux-2.6.23/arch/cris/kernel/irq.c
--- clean_linux-2.6.23/arch/cris/kernel/irq.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/kernel/irq.c	2007-10-22 11:07:34.000000000 +0200
@@ -2,7 +2,7 @@
  *
  *	linux/arch/cris/kernel/irq.c
  *
- *      Copyright (c) 2000,2001 Axis Communications AB
+ *      Copyright (c) 2000,2007 Axis Communications AB
  *
  *      Authors: Bjorn Wesen (bjornw@axis.com)
  *
@@ -92,14 +92,16 @@
 asmlinkage void do_IRQ(int irq, struct pt_regs * regs)
 {
 	unsigned long sp;
+	struct pt_regs *old_regs = set_irq_regs(regs);
 	irq_enter();
 	sp = rdsp();
 	if (unlikely((sp & (PAGE_SIZE - 1)) < (PAGE_SIZE/8))) {
 		printk("do_IRQ: stack overflow: %lX\n", sp);
 		show_stack(NULL, (unsigned long *)sp);
 	}
-	__do_IRQ(irq, regs);
+	__do_IRQ(irq);
         irq_exit();
+	set_irq_regs(old_regs);
 }
 
 void weird_irq(void)
--- clean_linux-2.6.23/./arch/cris/Kconfig	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/Kconfig	2007-10-26 11:05:17.000000000 +0200
@@ -57,6 +57,10 @@
 
 source "fs/Kconfig.binfmt"
 
+config GENERIC_HARDIRQS
+	bool
+	default y
+
 config ETRAX_CMDLINE
 	string "Kernel command line"
 	default "root=/dev/mtdblock3"

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
