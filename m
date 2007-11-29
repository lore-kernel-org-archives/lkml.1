Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbXK2CVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbXK2CVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 21:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758817AbXK2CVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 21:21:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51750 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbXK2CVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 21:21:09 -0500
Date: Thu, 29 Nov 2007 11:24:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [3/10] per-zone active inactive counter
Message-Id: <20071129112406.c6820a5e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071129103702.cbc5cf73.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
	<20071127120048.ef5f2005.kamezawa.hiroyu@jp.fujitsu.com>
	<1196284799.5318.34.camel@localhost>
	<20071129103702.cbc5cf73.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 10:37:02 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Maybe zonelists of NODE_DATA() is not initialized. you are right.
> I think N_HIGH_MEMORY will be suitable here...(I'll consider node-hotplug case later.)
> 
> Thank you for test!
> 
Could you try this ? 

Thanks,
-Kame
==

Don't call kmalloc() against possible but offline node.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/memcontrol.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: test-2.6.24-rc3-mm1/mm/memcontrol.c
===================================================================
--- test-2.6.24-rc3-mm1.orig/mm/memcontrol.c
+++ test-2.6.24-rc3-mm1/mm/memcontrol.c
@@ -1117,8 +1117,14 @@ static int alloc_mem_cgroup_per_zone_inf
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup_per_zone *mz;
 	int zone;
-
-	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	/*
+	 * This routine is called against possible nodes.
+	 * But it's BUG to call kmalloc() against offline node.
+	 */
+	if (node_state(N_ONLINE, node))
+		pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	else
+		pn = kmalloc(sizeof(*pn), GFP_KERNEL);
 	if (!pn)
 		return 1;
 

