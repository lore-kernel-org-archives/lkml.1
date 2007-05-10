Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbXEJF0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbXEJF0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbXEJF02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:26:28 -0400
Received: from ozlabs.org ([203.10.76.45]:49204 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494AbXEJF00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:26:26 -0400
To: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 10 May 2007 15:25:58 +1000
Subject: [PATCH 2/3] Add hard_irq_disable()
Message-Id: <20070510052622.3E8D5DDF4B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures, like powerpc, implement lazy disabling of
interrupts. That means that on those, local_irq_disable() doesn't
actually disable interrupts on the CPU, but only sets some per
CPU flag which cause them to be disabled only if an interrupt actually
occurs.

However, in some cases, such as stop_machine, we really want
interrupts to be fully disabled. For example, I have code using
stop machine to do ECC error injection, used to verify operations
of the ECC hardware, that sort of thing. It really needs to make
sure that nothing is actually writing to memory while the injection
happens. Similar examples can be found in other low level bits and
pieces.

This patch implements a generic hard_irq_disable() function which
is meant to be called -after- local_irq_disable() and ensures that
interrupts are fully disabled on that CPU. The default implementation
is a nop, though powerpc does already provide an appropriate one.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

 include/linux/interrupt.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-cell/include/linux/interrupt.h
===================================================================
--- linux-cell.orig/include/linux/interrupt.h	2007-05-10 14:51:22.000000000 +1000
+++ linux-cell/include/linux/interrupt.h	2007-05-10 15:18:04.000000000 +1000
@@ -241,6 +241,16 @@ static inline void __deprecated save_and
 #define save_and_cli(x)	save_and_cli(&x)
 #endif /* CONFIG_SMP */
 
+/* Some architectures might implement lazy enabling/disabling of
+ * interrupts. In some cases, such as stop_machine, we might want
+ * to ensure that after a local_irq_disable(), interrupts have
+ * really been disabled in hardware. Such architectures need to
+ * implement the following hook.
+ */
+#ifndef hard_irq_disable
+#define hard_irq_disable()	do { } while(0)
+#endif
+
 /* PLEASE, avoid to allocate new softirqs, if you need not _really_ high
    frequency threaded job scheduling. For almost all the purposes
    tasklets are more than enough. F.e. all serial device BHs et
