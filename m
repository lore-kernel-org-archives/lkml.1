Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYGXKwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYGXKwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYGXKvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:51:38 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60195 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYGXKvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:51:36 -0400
Date: Thu, 24 Jul 2008 12:48:53 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Linux-rt <linux-rt-users@vger.kernel.org>
Cc: linux-ppc <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Tim Chavez <tinytim@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
Subject: [PATCH 1/2][RT] powerpc - XICS: move the call to irq_radix_revmap
 from xics_startup to xics_host_map
Message-ID: <20080724124853.43a1157c@bull.net>
In-Reply-To: <20080724122352.3bc76bda@bull.net>
References: <20080724122352.3bc76bda@bull.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Dugue <sebastien.dugue@bull.net>
Date: Tue, 22 Jul 2008 13:05:24 +0200
Subject: [PATCH][RT] powerpc - XICS: move the call to irq_radix_revmap from xics_startup to xics_host_map

  This patch moves the insertion of an irq into the reverse mapping radix tree
from xics_startup() into xics_host_map().

  The reason for this change is that xics_startup() is called with preemption
disabled (which is not the case for xics_host_map()) which is a problem under a
preempt-rt kernel as we cannot even allocate GFP_ATOMIC memory for the radix tree
nodes.


Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>

---
 arch/powerpc/platforms/pseries/xics.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6.25.8-rt7/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6.25.8-rt7.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6.25.8-rt7/arch/powerpc/platforms/pseries/xics.c
@@ -311,12 +311,6 @@ static void xics_mask_irq(unsigned int v
 
 static unsigned int xics_startup(unsigned int virq)
 {
-	unsigned int irq;
-
-	/* force a reverse mapping of the interrupt so it gets in the cache */
-	irq = (unsigned int)irq_map[virq].hwirq;
-	irq_radix_revmap(xics_host, irq);
-
 	/* unmask it */
 	xics_unmask_irq(virq);
 	return 0;
@@ -529,8 +523,14 @@ static int xics_host_match(struct irq_ho
 static int xics_host_map_direct(struct irq_host *h, unsigned int virq,
 				irq_hw_number_t hw)
 {
+	unsigned int irq;
+
 	pr_debug("xics: map_direct virq %d, hwirq 0x%lx\n", virq, hw);
 
+	/* force a reverse mapping of the interrupt so it gets in the cache */
+	irq = (unsigned int)irq_map[virq].hwirq;
+	irq_radix_revmap(xics_host, irq);
+
 	get_irq_desc(virq)->status |= IRQ_LEVEL;
 	set_irq_chip_and_handler(virq, &xics_pic_direct, handle_fasteoi_irq);
 	return 0;
@@ -539,8 +539,14 @@ static int xics_host_map_direct(struct i
 static int xics_host_map_lpar(struct irq_host *h, unsigned int virq,
 			      irq_hw_number_t hw)
 {
+	unsigned int irq;
+
 	pr_debug("xics: map_direct virq %d, hwirq 0x%lx\n", virq, hw);
 
+	/* force a reverse mapping of the interrupt so it gets in the cache */
+	irq = (unsigned int)irq_map[virq].hwirq;
+	irq_radix_revmap(xics_host, irq);
+
 	get_irq_desc(virq)->status |= IRQ_LEVEL;
 	set_irq_chip_and_handler(virq, &xics_pic_lpar, handle_fasteoi_irq);
 	return 0;
