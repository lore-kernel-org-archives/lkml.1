Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbZASGGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbZASGGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 01:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZASGGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 01:06:46 -0500
Received: from ozlabs.org ([203.10.76.45]:36693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbZASGGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 01:06:45 -0500
To: <linux-kernel@vger.kernel.org>
Cc: linux-pci@vger.kernel.org, <tglx@linutronix.de>, <mingo@redhat.com>,
       <hpa@zytor.com>, <matthew@wil.cx>
Message-Id: <2882ab91a8588e9fe2ea45c89d1bc386850a94a3.1232345159.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] x86: Remove never-called arch_setup_msi_irq()
Date: Mon, 19 Jan 2009 17:06:42 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 75c46fa, "x64, x2apic/intr-remap: MSI and MSI-X
support for interrupt remapping infrastructure", x86 has had an
implementation of arch_setup_msi_irqs().

That implementation does not call arch_setup_msi_irq(), instead it calls
setup_irq(). No other x86 code calls arch_setup_msi_irq().

That leaves only arch_setup_msi_irqs() in drivers/pci/msi.c, but that
routine is overridden by the x86 version of arch_setup_msi_irqs().

So arch_setup_msi_irq() is dead code, remove it.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/x86/kernel/io_apic.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 1c4a130..9f41c22 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3463,40 +3463,6 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	return 0;
 }
 
-int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc)
-{
-	unsigned int irq;
-	int ret;
-	unsigned int irq_want;
-
-	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want);
-	if (irq == 0)
-		return -1;
-
-#ifdef CONFIG_INTR_REMAP
-	if (!intr_remapping_enabled)
-		goto no_ir;
-
-	ret = msi_alloc_irte(dev, irq, 1);
-	if (ret < 0)
-		goto error;
-no_ir:
-#endif
-	ret = setup_msi_irq(dev, msidesc, irq);
-	if (ret < 0) {
-		destroy_irq(irq);
-		return ret;
-	}
-	return 0;
-
-#ifdef CONFIG_INTR_REMAP
-error:
-	destroy_irq(irq);
-	return ret;
-#endif
-}
-
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	unsigned int irq;
-- 
1.5.5

