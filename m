Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZFQUm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZFQUm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760366AbZFQUl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:41:58 -0400
Received: from ottawa-hs-64-26-170-27.d-ip.magma.ca ([64.26.170.27]:59296 "EHLO
	gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756393AbZFQUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:41:57 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: torvalds@linux-foundation.org, jbarnes@virtuousgeek.org
Cc: andrew.patterson@hp.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 4/4] ia64: Fix resource assignment for root busses
Date: Wed, 17 Jun 2009 16:33:36 -0400
Message-Id: <1245270816-11755-5-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245270816-11755-1-git-send-email-willy@linux.intel.com>
References: <1245270816-11755-1-git-send-email-willy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 was assigning resources to root busses after allocations had
been made for child busses.  Calling pcibios_setup_root_windows() from
pcibios_fixup_bus() solves this problem by assigning the resources to
the root bus before child busses are scanned.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Andrew Patterson <andrew.patterson@hp.com>
---
 arch/ia64/pci/pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 61f1af5..ae5ee8a 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -371,8 +371,6 @@ pci_acpi_scan_root(struct acpi_device *device, int domain, int bus)
 	 * such quirk. So we just ignore the case now.
 	 */
 	pbus = pci_scan_bus_parented(NULL, bus, &pci_root_ops, controller);
-	if (pbus)
-		pcibios_setup_root_windows(pbus, controller);
 
 	return pbus;
 
@@ -490,6 +488,8 @@ pcibios_fixup_bus (struct pci_bus *b)
 	if (b->self) {
 		pci_read_bridge_bases(b);
 		pcibios_fixup_bridge_resources(b->self);
+	} else {
+		pcibios_setup_root_windows(b, b->sysdata);
 	}
 	list_for_each_entry(dev, &b->devices, bus_list)
 		pcibios_fixup_device_resources(dev);
-- 
1.6.3.1

