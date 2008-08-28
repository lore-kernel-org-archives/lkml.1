Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYH1UuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYH1UuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYH1Ut4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:49:56 -0400
Received: from iona.labri.fr ([147.210.8.143]:44838 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbYH1Utz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:49:55 -0400
X-Greylist: delayed 1648 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2008 16:49:54 EDT
Message-ID: <48B708E1.4070001@inria.fr>
Date: Thu, 28 Aug 2008 22:21:53 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: netdev@vger.kernel.org
Subject: [RFC] export irq_set/get_affinity() for multiqueue network drivers
Content-Type: multipart/mixed;
 boundary="------------050905020800000906090109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050905020800000906090109
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

Is there any way to setup IRQ masks from within a driver? myri10ge
currently relies on an external script (writing in
/proc/irq/*/smp_affinity) to bind each queue/MSI-X to a different
processor. By default, Linux will either:
* round-robin the interrupts (killing the benefit of DCA for instance)
* put all IRQs on the same CPU (killing much of the benefit of multislices)

With more and more drivers using multiqueues, I think we need a nice way
to bind MSI-X from within the drivers. I am not sure what's best, the
attached (untested) patch would just export the existing
irq_set_affinity() and add irq_get_affinity(). Comments?

thanks,
Brice


--------------050905020800000906090109
Content-Type: text/x-patch;
 name="export_irq_affinity.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="export_irq_affinity.patch"

[PATCH] export irq_set/get_affinity() to modules

Export irq_set_affinity() and add/export irq_get_affinity() so that
network drivers may access MSI-X interrupt masks to bind multiqueues
to different CPUs. Otherwise Linux will either:
* round-robin the interrupts (killing the benefit of DCA, for instance)
* put all IRQs on the same CPU (killing much of the benefit of multislices)

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
---
 include/linux/interrupt.h |    3 +++
 kernel/irq/manage.c       |   15 +++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -107,6 +107,7 @@ extern void enable_irq(unsigned int irq);
 extern cpumask_t irq_default_affinity;
 
 extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
+extern int irq_get_affinity(unsigned int irq, cpumask_t *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
@@ -117,6 +118,8 @@ static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 	return -EINVAL;
 }
 
+static inline int irq_get_affinity(unsigned int irq)  { return 0; }
+
 static inline int irq_can_set_affinity(unsigned int irq)
 {
 	return 0;
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -96,6 +96,21 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 #endif
 	return 0;
 }
+EXPORT_SYMBOL(irq_set_affinity);
+
+int irq_get_affinity(unsigned int irq, cpumask_t *cpumask)
+{
+	struct irq_desc *desc = irq_desc + irq;
+	cpumask_t *mask = &desc->affinity;
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	if (desc->status & IRQ_MOVE_PENDING)
+		mask = &desc->pending_mask;
+#endif
+	memcpy(cpumask, mask, sizeof(*mask);
+	return 0;
+}
+EXPORT_SYMBOL(irq_get_affinity);
 
 #ifndef CONFIG_AUTO_IRQ_AFFINITY
 /*

--------------050905020800000906090109--
