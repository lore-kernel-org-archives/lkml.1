Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbZFQUml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbZFQUml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760954AbZFQUl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:41:59 -0400
Received: from ottawa-hs-64-26-170-27.d-ip.magma.ca ([64.26.170.27]:59299 "EHLO
	gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756488AbZFQUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:41:57 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: torvalds@linux-foundation.org, jbarnes@virtuousgeek.org
Cc: andrew.patterson@hp.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 3/4] x86: Use pci_claim_resource
Date: Wed, 17 Jun 2009 16:33:35 -0400
Message-Id: <1245270816-11755-4-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245270816-11755-1-git-send-email-willy@linux.intel.com>
References: <1245270816-11755-1-git-send-email-willy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding pci_find_parent_resource and request_resource,
just call pci_claim_resource.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/x86/pci/i386.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index a85bef2..0fb56db 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -116,7 +116,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 	struct pci_bus *bus;
 	struct pci_dev *dev;
 	int idx;
-	struct resource *r, *pr;
+	struct resource *r;
 
 	/* Depth-First Search on bus tree */
 	list_for_each_entry(bus, bus_list, node) {
@@ -126,9 +126,8 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 				r = &dev->resource[idx];
 				if (!r->flags)
 					continue;
-				pr = pci_find_parent_resource(dev, r);
-				if (!r->start || !pr ||
-				    request_resource(pr, r) < 0) {
+				if (!r->start ||
+				    pci_claim_resource(dev, idx) < 0) {
 					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
 					/*
 					 * Something is wrong with the region.
@@ -149,7 +148,7 @@ static void __init pcibios_allocate_resources(int pass)
 	struct pci_dev *dev = NULL;
 	int idx, disabled;
 	u16 command;
-	struct resource *r, *pr;
+	struct resource *r;
 
 	for_each_pci_dev(dev) {
 		pci_read_config_word(dev, PCI_COMMAND, &command);
@@ -168,8 +167,7 @@ static void __init pcibios_allocate_resources(int pass)
 					(unsigned long long) r->start,
 					(unsigned long long) r->end,
 					r->flags, disabled, pass);
-				pr = pci_find_parent_resource(dev, r);
-				if (!pr || request_resource(pr, r) < 0) {
+				if (pci_claim_resource(dev, idx) < 0) {
 					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
 					/* We'll assign a new address later */
 					r->end -= r->start;
@@ -197,7 +195,7 @@ static void __init pcibios_allocate_resources(int pass)
 static int __init pcibios_assign_resources(void)
 {
 	struct pci_dev *dev = NULL;
-	struct resource *r, *pr;
+	struct resource *r;
 
 	if (!(pci_probe & PCI_ASSIGN_ROMS)) {
 		/*
@@ -209,8 +207,7 @@ static int __init pcibios_assign_resources(void)
 			r = &dev->resource[PCI_ROM_RESOURCE];
 			if (!r->flags || !r->start)
 				continue;
-			pr = pci_find_parent_resource(dev, r);
-			if (!pr || request_resource(pr, r) < 0) {
+			if (pci_claim_resource(dev, PCI_ROM_RESOURCE) < 0) {
 				r->end -= r->start;
 				r->start = 0;
 			}
-- 
1.6.3.1

