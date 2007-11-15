Return-Path: <linux-kernel-owner+w=401wt.eu-S1764514AbXKOKfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764514AbXKOKfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760491AbXKOKff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:35:35 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58880 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbXKOKfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:35:34 -0500
Date: Thu, 15 Nov 2007 19:35:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       apw@shadowen.org, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [PATCH][2.6.24-rc2-mm1] memory hotplug x86_64 fix [2/3] fix section
 mismatch in vmammap_allock_block
Message-Id: <20071115193544.eb0629e1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115005657.99856c28.akpm@linux-foundation.org>
	<20071115181816.1f0cb905.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes section mismatch below.

WARNING: vmlinux.o(.text+0x946b5): Section mismatch: reference to .init.text:'
__alloc_bootmem_node (between 'vmemmap_alloc_block' and 'vmemmap_pgd_populate')

Changelog
 - changed bootmem alloc wrapper function's name to be
	__earlyonly_bootmem_alloc().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


 mm/sparse-vmemmap.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc2-mm1/mm/sparse-vmemmap.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/mm/sparse-vmemmap.c
+++ linux-2.6.24-rc2-mm1/mm/sparse-vmemmap.c
@@ -34,6 +34,16 @@
  * or to back the page tables that are used to create the mapping.
  * Uses the main allocators if they are available, else bootmem.
  */
+
+static void * __init_refok __earlyonly_bootmem_alloc(int node,
+				unsigned long size,
+				unsigned long align,
+				unsigned long goal)
+{
+	return __alloc_bootmem_node(NODE_DATA(node), size, align, goal);
+}
+
+
 void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 {
 	/* If the main allocator is up use that, fallback to bootmem. */
@@ -44,7 +54,7 @@ void * __meminit vmemmap_alloc_block(uns
 			return page_address(page);
 		return NULL;
 	} else
-		return __alloc_bootmem_node(NODE_DATA(node), size, size,
+		return __earlyonly_bootmem_alloc(node, size, size,
 				__pa(MAX_DMA_ADDRESS));
 }
 

