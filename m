Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXK2FVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXK2FVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 00:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXK2FVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 00:21:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58629 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbXK2FVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 00:21:23 -0500
Date: Thu, 29 Nov 2007 14:24:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Lee.Schermerhorn@hp.com" <Lee.Schermerhorn@hp.com>
Subject: Re: 2.6.24-rc3-mm2 (bugfix for memory cgroup per-zone-struct
 allocation.)
Message-Id: <20071129142416.f6d1ffcd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071129122329.4c56c052.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	<20071129122329.4c56c052.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 12:23:29 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> I noticed CONFIG_NUMA + CONFIG_CGROUP_MEM_CONT + CONFIG_SLUB cannot boot because of my patch.
> (SLAB is ok.)
> I'll post workaround soon.
> 
==
This is a fix. tested on my ia64/NUMA box both on SLAB/SLUB.
This patch fixes kmalloc_node() is called against node-without-memory.

It's better to add memory hotplug callback for supporing possible nodes
(memory hotplug) but here just uses kmalloc().

Should be revisited later.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/memcontrol.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc3-mm2/mm/memcontrol.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/mm/memcontrol.c
+++ linux-2.6.24-rc3-mm2/mm/memcontrol.c
@@ -1117,8 +1117,18 @@ static int alloc_mem_cgroup_per_zone_inf
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup_per_zone *mz;
 	int zone;
-
-	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	/*
+	 * This routine is called against possible nodes.
+	 * But it's BUG to call kmalloc() against offline node.
+	 *
+	 * TODO: this routine can waste much memory for nodes which will
+	 *       never be onlined. It's better to use memory hotplug callback
+	 *       function.
+	 */
+	if (node_state(node, N_HIGH_MEMORY))
+		pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	else
+		pn = kmalloc(sizeof(*pn), GFP_KERNEL);
 	if (!pn)
 		return 1;
 

