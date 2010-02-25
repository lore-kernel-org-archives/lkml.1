Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab0BYPq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:46:56 -0500
Received: from www.tglx.de ([62.245.132.106]:45911 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645Ab0BYPqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:46:55 -0500
Date: Thu, 25 Feb 2010 16:42:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [patch] x86: pci: Prevent mmconfig memory corruption
Message-ID: <alpine.LFD.2.00.1002251638230.4245@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ff097ddd4 (x86/PCI: MMCONFIG: manage pci_mmcfg_region as a
list, not a table) introduced a nasty memory corruption when
pci_mmcfg_list is empty.

pci_mmcfg_check_end_bus_number() dereferences pci_mmcfg_list.prev even
when the list is empty. The following write hits some variable near to
pci_mmcfg_list.

Further down a similar problem exists, where cfg->list.next is
dereferenced unconditionally and a comparison with some variable near
to pci_mmcfg_list happens.

Add a check for the last element into the for_each_entry() loop and
remove all the other crappy logic which is just a leftover of the old
array based code which was replaced by the list conversion.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: stable@kernel.org
---
 arch/x86/pci/mmconfig-shared.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -303,22 +303,17 @@ static void __init pci_mmcfg_check_end_b
 {
 	struct pci_mmcfg_region *cfg, *cfgx;
 
-	/* last one*/
-	cfg = list_entry(pci_mmcfg_list.prev, typeof(*cfg), list);
-	if (cfg)
-		if (cfg->end_bus < cfg->start_bus)
-			cfg->end_bus = 255;
-
-	if (list_is_singular(&pci_mmcfg_list))
-		return;
-
-	/* don't overlap please */
+	/* Fixup overlaps */
 	list_for_each_entry(cfg, &pci_mmcfg_list, list) {
 		if (cfg->end_bus < cfg->start_bus)
 			cfg->end_bus = 255;
 
+		/* Don't access the list head ! */
+		if (cfg->list.next == &pci_mmcfg_list)
+			break;
+
 		cfgx = list_entry(cfg->list.next, typeof(*cfg), list);
-		if (cfg != cfgx && cfg->end_bus >= cfgx->start_bus)
+		if (cfg->end_bus >= cfgx->start_bus)
 			cfg->end_bus = cfgx->start_bus - 1;
 	}
 }
