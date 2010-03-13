Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904Ab0CMAU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:20:26 -0500
Received: from kroah.org ([198.145.64.141]:60605 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934841Ab0CMATp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:45 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:07 2010
Message-Id: <20100313001506.929414064@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 020/123] x86/PCI: Prevent mmconfig memory corruption
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Thomas Gleixner <tglx@linutronix.de>

commit bb8d41330ce27edb91adb6922d3f8e1a8923f727 upstream.

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
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/mmconfig-shared.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
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


