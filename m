Return-Path: <linux-kernel-owner+w=401wt.eu-S1763797AbYDPMsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763797AbYDPMsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763319AbYDPMsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:48:04 -0400
Received: from saeurebad.de ([85.214.36.134]:58558 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763301AbYDPMsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:48:01 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Wed Apr 16 13:37:19 2008
Message-Id: <20080416113719.092060936@skyscraper.fehenstaub.lan>
References: <20080416113629.947746497@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 13:36:31 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][patch 2/5] mm: Node-setup agnostic free_bootmem()
Content-Disposition: inline; filename=mm-node-setup-agnostic-free_bootmem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make free_bootmem() look up the node holding the specified address
range which lets it work transparently on single-node and multi-node
configurations.

If the address range exceeds the node range, it well be marked free
across node boundaries, too.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 mm/bootmem.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

Index: tree-linus/mm/bootmem.c
===================================================================
--- tree-linus.orig/mm/bootmem.c
+++ tree-linus/mm/bootmem.c
@@ -421,7 +421,32 @@ int __init reserve_bootmem(unsigned long
 
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	bootmem_data_t *bdata;
+	unsigned long pos = addr;
+	unsigned long partsize = size;
+
+	list_for_each_entry(bdata, &bdata_list, list) {
+		unsigned long remainder = 0;
+
+		if (pos < bdata->node_boot_start)
+			continue;
+
+		if (PFN_DOWN(pos + partsize) > bdata->node_low_pfn) {
+			remainder = PFN_DOWN(pos + partsize) - bdata->node_low_pfn;
+			partsize -= remainder;
+		}
+
+		free_bootmem_core(bdata, pos, partsize);
+
+		if (!remainder)
+			return;
+
+		pos = PFN_PHYS(bdata->node_low_pfn + 1);
+	}
+	printk(KERN_ERR "free_bootmem: request: addr=%lx, size=%lx, "
+			"state: pos=%lx, partsize=%lx\n", addr, size,
+			pos, partsize);
+	BUG();
 }
 
 unsigned long __init free_all_bootmem(void)

-- 

