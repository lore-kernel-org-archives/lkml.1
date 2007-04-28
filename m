Return-Path: <linux-kernel-owner+w=401wt.eu-S1163452AbXD1SRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163452AbXD1SRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163297AbXD1SPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:15:55 -0400
Received: from ns2.suse.de ([195.135.220.15]:38591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163288AbXD1Rwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Andrew Morton <akpm@osdl.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [1/35] i386: revert i386-fix-the-verify_quirk_intel_irqbalance
Message-Id: <20070428175224.D785A151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@osdl.org>

This is unneeded with Ingo's genapic rework.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/quirks.c |   33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

Index: linux/arch/i386/kernel/quirks.c
===================================================================
--- linux.orig/arch/i386/kernel/quirks.c
+++ linux/arch/i386/kernel/quirks.c
@@ -10,38 +10,13 @@
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 static void __devinit verify_quirk_intel_irqbalance(struct pci_dev *dev)
 {
-	u8 config, rev;
-	u32 word;
-
-	/* BIOS may enable hardware IRQ balancing for
-	 * E7520/E7320/E7525(revision ID 0x9 and below)
-	 * based platforms.
-	 * For those platforms, make sure that the genapic is set to 'flat'
-	 */
-	pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
-	if (rev > 0x9)
-		return;
-
-	/* enable access to config space*/
-	pci_read_config_byte(dev, 0xf4, &config);
-	pci_write_config_byte(dev, 0xf4, config|0x2);
-
-	/* read xTPR register */
-	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
-
-	if (!(word & (1 << 13))) {
 #ifdef CONFIG_X86_64
-		if (genapic !=  &apic_flat)
-			panic("APIC mode must be flat on this system\n");
+	if (genapic !=  &apic_flat)
+		panic("APIC mode must be flat on this system\n");
 #elif defined(CONFIG_X86_GENERICARCH)
-		if (genapic != &apic_default)
-			panic("APIC mode must be default(flat) on this system. Use apic=default\n");
+	if (genapic != &apic_default)
+		panic("APIC mode must be default(flat) on this system. Use apic=default\n");
 #endif
-	}
-
-	/* put back the original value for config space*/
-	if (!(config & 0x2))
-		pci_write_config_byte(dev, 0xf4, config);
 }
 
 void __init quirk_intel_irqbalance(void)
