Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbYGQBnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbYGQBnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 21:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYGQBnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 21:43:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbYGQBnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 21:43:06 -0400
Date: Wed, 16 Jul 2008 21:42:59 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Limit irq nesting
Message-ID: <Pine.LNX.4.64.0807162128060.24301@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

During examination of stack-overflows on sparc64, it was found that there 
is no limit for a number of nested IRQ handlers. Sparc64 is especially 
stack-hungry architecture, minimum frame size is 192 bytes and after 75 
frames it overflows.

If someone provides a legitimate reason for more than 2 nested handlers, 
you could increase the constant in the patch --- but there really should 
be some limit, so that many simultaneous interrupts can't blow the stack.

Mikulas

---

IRQs without IRQF_DISABLED could nest to arbitrary level.

At worst this would mean having as many IRQ handlers stack frames, as there
are interrupts registered --- enough to cause a stack overflow.

This patch makes a limit to have at most two handlers on the stack.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 include/linux/interrupt.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc8/include/linux/interrupt.h
===================================================================
--- linux-2.6.26-rc8.orig/include/linux/interrupt.h	2008-06-25 03:58:20.000000000 +0200
+++ linux-2.6.26-rc8/include/linux/interrupt.h	2008-07-01 17:42:44.000000000 +0200
@@ -16,6 +16,11 @@
 #include <asm/system.h>
 
 /*
+ * Max number of interrupt handlers on a stack. To prevent stack overflow.
+ */
+#define MAX_NESTED_INTERRUPTS	2
+
+/*
  * These correspond to the IORESOURCE_IRQ_* defines in
  * linux/ioport.h to select the interrupt line behaviour.  When
  * requesting an interrupt without specifying a IRQF_TRIGGER, the
@@ -95,7 +100,7 @@ extern void devm_free_irq(struct device 
 #ifdef CONFIG_LOCKDEP
 # define local_irq_enable_in_hardirq()	do { } while (0)
 #else
-# define local_irq_enable_in_hardirq()	local_irq_enable()
+# define local_irq_enable_in_hardirq()	do { if (hardirq_count() < (MAX_NESTED_INTERRUPTS << HARDIRQ_SHIFT)) local_irq_enable(); } while (0)
 #endif
 
 extern void disable_irq_nosync(unsigned int irq);
