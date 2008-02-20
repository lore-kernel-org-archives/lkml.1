Return-Path: <linux-kernel-owner+w=401wt.eu-S1762435AbYBTIlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435AbYBTIlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYBTIkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:40:03 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42881 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbYBTIj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:39:59 -0500
Date: Wed, 20 Feb 2008 00:36:54 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/4] x86_64: fix dma_alloc_pages v2
In-reply-to: <200802200015.43547.yinghai.lu@sun.com>
To: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802200036.54406.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802200015.43547.yinghai.lu@sun.com>
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

this patch will use updated dev_to node, so remove check about fist_node etc

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/pci-dma_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma_64.c
+++ linux-2.6/arch/x86/kernel/pci-dma_64.c
@@ -53,12 +53,6 @@ dma_alloc_pages(struct device *dev, gfp_
 	int node;
 
 	node = dev_to_node(dev);
-	if (node == -1)
-		node = numa_node_id();
-
-	if (node < first_node(node_online_map))
-		node = first_node(node_online_map);
-
 	page = alloc_pages_node(node, gfp, order);
 	return page ? page_address(page) : NULL;
 }
