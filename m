Return-Path: <linux-kernel-owner+w=401wt.eu-S1758445AbZELX27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445AbZELX27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZELXZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:32 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36198
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753793AbZELXZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/17] xen: use acpi_get_override_irq() to get triggering for legacy irqs
Date: Tue, 12 May 2009 16:25:19 -0700
Message-Id: <1242170724-13349-13-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

We need to set up proper IO apic entries for legacy irqs, which are
not normally configured by either normal acpi interrupt routing or
PNP.

This also generalizes the acpi interrupt setup, so we can remove it
as a special case.

[ Impact: compatibility with legacy/ISA hardware ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 00ad6df..db0c74c 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -65,19 +65,15 @@ void __init xen_setup_pirqs(void)
 {
 	int irq;
 
-#ifdef CONFIG_ACPI
-	/*
-	 * Set up acpi interrupt in acpi_gbl_FADT.sci_interrupt.
-	 */
-	if (acpi_gbl_FADT.sci_interrupt > 0) {
-		irq = xen_allocate_pirq(acpi_gbl_FADT.sci_interrupt);
-
-		printk(KERN_INFO "xen: allocated irq %d for acpi %d\n",
-		       irq, acpi_gbl_FADT.sci_interrupt);
-	}
-#endif
-
 	/* Pre-allocate legacy irqs */
-	for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
-		xen_allocate_pirq(irq);
+	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
+		int trigger, polarity;
+
+		if (acpi_get_override_irq(irq, &trigger, &polarity) == -1)
+			continue;
+
+		xen_register_gsi(irq,
+			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE,
+			polarity ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH);
+	}
 }
-- 
1.6.0.6

