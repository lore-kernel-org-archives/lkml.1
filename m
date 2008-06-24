Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYFXGHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYFXGHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYFXGGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:06:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbYFXGGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:06:51 -0400
Date: Tue, 24 Jun 2008 02:06:47 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net
Subject: [PATCH] limit irq nesting
In-Reply-To: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240203550.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another potential problem (found during code review) that could cause 
stack overflow is indefinite irq nesting. Linux doesn't have any limit on 
number of nested irq handlers, so there may be as many handlers on a stack 
as there are registered hardware interrupts --- enough to cause a crash.

This patch limits interrupt nesting to at most 2 levels.

--

IRQs without IRQF_DISABLED could nest to arbitrary level.

At worst this would mean having as many IRQ handlers stack frames, as there
are interrupts registered --- enough to cause a stack overflow.

This patch makes a limit to have at most two handlers on the stack.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/include/linux/interrupt.h
===================================================================
--- linux-2.6.26-rc7-devel.orig/include/linux/interrupt.h	2008-06-23 17:47:16.000000000 +0200
+++ linux-2.6.26-rc7-devel/include/linux/interrupt.h	2008-06-23 18:02:40.000000000 +0200
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
@@ -95,7 +100,7 @@
  #ifdef CONFIG_LOCKDEP
  # define local_irq_enable_in_hardirq()	do { } while (0)
  #else
-# define local_irq_enable_in_hardirq()	local_irq_enable()
+# define local_irq_enable_in_hardirq()	do { if (hardirq_count() < (MAX_NESTED_INTERRUPTS << HARDIRQ_SHIFT)) local_irq_enable(); } while (0)
  #endif

  extern void disable_irq_nosync(unsigned int irq);
