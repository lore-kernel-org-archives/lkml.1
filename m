Return-Path: <linux-kernel-owner+w=401wt.eu-S1422854AbXCGRgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422854AbXCGRgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422768AbXCGRe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:34:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422861AbXCGRQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:39 -0500
Message-Id: <20070307171454.776245687@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, fabbione@ubuntu.com, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 064/101] Fix interrupt probing on E450 sparc64 systems
Content-Disposition: inline; filename=fix-interrupt-probing-on-e450-sparc64-systems.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

[SPARC64]: Fix PCI interrupts on E450 et al.

When the PCI controller OBP node lacks an interrupt-map
and interrupt-map-mask property, we need to form the
INO by hand.  The PCI swizzle logic was not doing that
properly.

This was a regression added by the of_device code.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/of_device.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

--- linux-2.6.20.1.orig/arch/sparc64/kernel/of_device.c
+++ linux-2.6.20.1/arch/sparc64/kernel/of_device.c
@@ -708,7 +708,7 @@ static unsigned int __init pci_irq_swizz
 					   unsigned int irq)
 {
 	struct linux_prom_pci_registers *regs;
-	unsigned int devfn, slot, ret;
+	unsigned int bus, devfn, slot, ret;
 
 	if (irq < 1 || irq > 4)
 		return irq;
@@ -717,10 +717,46 @@ static unsigned int __init pci_irq_swizz
 	if (!regs)
 		return irq;
 
+	bus = (regs->phys_hi >> 16) & 0xff;
 	devfn = (regs->phys_hi >> 8) & 0xff;
 	slot = (devfn >> 3) & 0x1f;
 
-	ret = ((irq - 1 + (slot & 3)) & 3) + 1;
+	if (pp->irq_trans) {
+		/* Derived from Table 8-3, U2P User's Manual.  This branch
+		 * is handling a PCI controller that lacks a proper set of
+		 * interrupt-map and interrupt-map-mask properties.  The
+		 * Ultra-E450 is one example.
+		 *
+		 * The bit layout is BSSLL, where:
+		 * B: 0 on bus A, 1 on bus B
+		 * D: 2-bit slot number, derived from PCI device number as
+		 *    (dev - 1) for bus A, or (dev - 2) for bus B
+		 * L: 2-bit line number
+		 *
+		 * Actually, more "portable" way to calculate the funky
+		 * slot number is to subtract pbm->pci_first_slot from the
+		 * device number, and that's exactly what the pre-OF
+		 * sparc64 code did, but we're building this stuff generically
+		 * using the OBP tree, not in the PCI controller layer.
+		 */
+		if (bus & 0x80) {
+			/* PBM-A */
+			bus  = 0x00;
+			slot = (slot - 1) << 2;
+		} else {
+			/* PBM-B */
+			bus  = 0x10;
+			slot = (slot - 2) << 2;
+		}
+		irq -= 1;
+
+		ret = (bus | slot | irq);
+	} else {
+		/* Going through a PCI-PCI bridge that lacks a set of
+		 * interrupt-map and interrupt-map-mask properties.
+		 */
+		ret = ((irq - 1 + (slot & 3)) & 3) + 1;
+	}
 
 	return ret;
 }

--
