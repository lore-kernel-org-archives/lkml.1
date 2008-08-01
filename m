Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbYHAV6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbYHAV6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYHAV6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:58:35 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:12347 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYHAV6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:58:34 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] ACPI: bounds check IRQ to prevent memory corruption
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Jack Steiner <steiner@sgi.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Aug 2008 15:58:17 -0600
Message-ID: <20080801215755.4761.92512.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


acpi_penalize_isa_irq() should validate irq before using it to
index the acpi_irq_penalty[] table.

Here's the path I'm concerned about:

    pnpacpi_parse_allocated_irqresource()
    {
	...
	irq = acpi_register_gsi(gsi, triggering, polarity);
	if (irq >= 0)
		pcibios_penalize_isa_irq(irq, 1);

There's no guarantee that acpi_register_gsi() will return an IRQ
within the bounds of acpi_irq_penalty[].

I have not seen a failure I can attribute to this.  However,
ACPI_MAX_IRQS is only 256, and I'm pretty sure ia64 can have
IRQs larger than that.

I think this should go in 2.6.27.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/acpi/pci_link.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index 89f3b2a..cf47805 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -849,7 +849,7 @@ static int __init acpi_irq_penalty_update(char *str, int used)
 		if (irq < 0)
 			continue;
 
-		if (irq >= ACPI_MAX_IRQS)
+		if (irq >= ARRAY_SIZE(acpi_irq_penalty))
 			continue;
 
 		if (used)
@@ -872,10 +872,12 @@ static int __init acpi_irq_penalty_update(char *str, int used)
  */
 void acpi_penalize_isa_irq(int irq, int active)
 {
-	if (active)
-		acpi_irq_penalty[irq] += PIRQ_PENALTY_ISA_USED;
-	else
-		acpi_irq_penalty[irq] += PIRQ_PENALTY_PCI_USING;
+	if (irq >= 0 && irq < ARRAY_SIZE(acpi_irq_penalty)) {
+		if (active)
+			acpi_irq_penalty[irq] += PIRQ_PENALTY_ISA_USED;
+		else
+			acpi_irq_penalty[irq] += PIRQ_PENALTY_PCI_USING;
+	}
 }
 
 /*

