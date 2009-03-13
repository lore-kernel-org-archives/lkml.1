Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbZCMQpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbZCMQpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbZCMQnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:43:16 -0400
Received: from gw.goop.org ([64.81.55.164]:57280 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758887AbZCMQnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:43:15 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/17] xen: use acpi_get_override_irq() to get triggering for legacy irqs
Date: Fri, 13 Mar 2009 09:42:33 -0700
Message-Id: <1236962558-13748-13-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

We need to set up proper IO apic entries for legacy irqs, which are
not normally configured by either normal acpi interrupt routing or
PNP.

This also generalizes the acpi interrupt setup, so we can remove it
as a special case.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index e88f85e..f55532d 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -64,19 +64,15 @@ void __init xen_setup_pirqs(void)
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
-	for (irq=0; irq < NR_IRQS_LEGACY; irq++)
-		xen_allocate_pirq(irq);
+	for (irq=0; irq < NR_IRQS_LEGACY; irq++) {
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

