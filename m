Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbYDMKgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbYDMKgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 06:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbYDMKgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 06:36:42 -0400
Received: from saeurebad.de ([85.214.36.134]:50633 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbYDMKgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 06:36:41 -0400
X-Mailbox-Line: From hannes@symbol.fehenstaub.lan Sun Apr 13 00:58:50 2008
Message-Id: <20080412225850.704752615@symbol.fehenstaub.lan>
References: <20080412223319.372887160@symbol.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Sun, 13 Apr 2008 00:33:21 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
Content-Disposition: inline; filename=node-agnostic-free_bootmem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make free_bootmem() look up the node holding the specified address
range which lets it work transparently on single-node and multi-node
configurations.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andi Kleen <ak@suse.de>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---

Patch tested on x86_32 uma.

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -421,7 +421,15 @@ int __init reserve_bootmem(unsigned long
 
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	bootmem_data_t *bdata;
+
+	list_for_each_entry (bdata, &bdata_list, list) {
+		if (addr < bdata->node_boot_start)
+			continue;
+		free_bootmem_core(bdata, addr, size);
+		return;
+	}
+	BUG();
 }
 
 unsigned long __init free_all_bootmem(void)
