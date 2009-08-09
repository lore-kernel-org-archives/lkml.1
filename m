Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbZHITy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbZHITy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZHITy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:54:28 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:45798 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbZHITy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JjfbYIgWqdfoymT7lDDhVZEEOmMsYJYYiVn5pItlMaX3fZ3OFKf/RW7V64yG5dkYAO
         4f/qm6R3i046MHsSJv4pXyachRB/ajOHdes/nibHru1L5V5TXJscwGKGeBmnxB3VucCM
         FI9hH5xSfaV9yyCsvJYumZOUgGqrRmGbn+OZ8=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH 03/14] powerpc: use printk_once
Date: Sun,  9 Aug 2009 21:53:58 +0200
Message-Id: <1249847649-11631-4-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/iommu.c      |    6 +-----
 arch/powerpc/kernel/irq.c        |    5 ++---
 arch/powerpc/sysdev/ppc4xx_pci.c |    9 ++-------
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index fd51578..c7fa258 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -502,7 +502,6 @@ static void iommu_table_clear(struct iommu_table *tbl)
 struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 {
 	unsigned long sz;
-	static int welcomed = 0;
 	struct page *page;
 
 	/* Set aside 1/4 of the table for large allocations. */
@@ -523,11 +522,8 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 
 	iommu_table_clear(tbl);
 
-	if (!welcomed) {
-		printk(KERN_INFO "IOMMU table initialized, virtual merging %s\n",
+	printk_once(KERN_INFO "IOMMU table initialized, virtual merging %s\n",
 		       novmerge ? "disabled" : "enabled");
-		welcomed = 1;
-	}
 
 	return tbl;
 }
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index f7f376e..05ebd21 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -231,7 +231,6 @@ skip:
 void fixup_irqs(cpumask_t map)
 {
 	unsigned int irq;
-	static int warned;
 
 	for_each_irq(irq) {
 		cpumask_t mask;
@@ -246,8 +245,8 @@ void fixup_irqs(cpumask_t map)
 		}
 		if (irq_desc[irq].chip->set_affinity)
 			irq_desc[irq].chip->set_affinity(irq, &mask);
-		else if (irq_desc[irq].action && !(warned++))
-			printk("Cannot set affinity for irq %i\n", irq);
+		else if (irq_desc[irq].action)
+			printk_once("Cannot set affinity for irq %i\n", irq);
 	}
 
 	local_irq_enable();
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index 6ff9d71..4282dff 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -1243,19 +1243,14 @@ static int ppc4xx_pciex_validate_bdf(struct ppc4xx_pciex_port *port,
 				     struct pci_bus *bus,
 				     unsigned int devfn)
 {
-	static int message;
-
 	/* Endpoint can not generate upstream(remote) config cycles */
 	if (port->endpoint && bus->number != port->hose->first_busno)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	/* Check we are within the mapped range */
 	if (bus->number > port->hose->last_busno) {
-		if (!message) {
-			printk(KERN_WARNING "Warning! Probing bus %u"
-			       " out of range !\n", bus->number);
-			message++;
-		}
+		printk_once(KERN_WARNING
+			"Warning! Probing bus %u out of range!\n", bus->number);
 		return PCIBIOS_DEVICE_NOT_FOUND;
 	}
 
-- 
1.6.3.3

