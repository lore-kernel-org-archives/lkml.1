Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbYBSKNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbYBSKNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYBSKNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:13:30 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54508 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYBSKN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:13:29 -0500
Date: Tue, 19 Feb 2008 02:21:45 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: fix dma_alloc_pages
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802190221.46552.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


one system with two nodes and two ht links on every node.
the bios already have _pxm for two links.

when no ram installed for node1 will have panic.

reason: the device on second chain will get node = 1 from dev_to_node...via
pci_acpi_scan_root.
but node1 doesn't have ram installed.
in dma_alloc_pages it will pass check with first_node(node_online_map)...
and will have problem with __alloc_pages in alloc_pages_node.

this patch will check the if the node is online..., if not will get numa_node_id
to get one node with ram.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index a82473d..931b51a 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -53,12 +53,9 @@ dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
 	int node;
 
 	node = dev_to_node(dev);
-	if (node == -1)
+	if (node == -1 || !node_online(node))
 		node = numa_node_id();
 
-	if (node < first_node(node_online_map))
-		node = first_node(node_online_map);
-
 	page = alloc_pages_node(node, gfp, order);
 	return page ? page_address(page) : NULL;
 }
