Return-Path: <linux-kernel-owner+w=401wt.eu-S935944AbXHNV45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935944AbXHNV45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932208AbXHNViB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:38:01 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:53515 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552AbXHNVh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:37:58 -0400
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, clameter@sgi.com,
       bob.picco@hp.com, nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       mel@skynet.ie, akpm@linux-foundation.org,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
In-Reply-To: <20070814204951.GA2065@vino.hallyn.com>
References: <20070812152126.GA26239@linux.vnet.ibm.com>
	 <20070813201215.GA16908@vino.hallyn.com>
	 <1187103831.6281.24.camel@localhost>
	 <20070814180339.GA32553@vino.hallyn.com>
	 <1187115224.6281.40.camel@localhost>
	 <20070814192306.GB32553@vino.hallyn.com>
	 <20070814204951.GA2065@vino.hallyn.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 14 Aug 2007 17:37:12 -0400
Message-Id: <1187127432.6281.135.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 15:49 -0500, Serge E. Hallyn wrote:
<snip>
> 
> Here is a patch which fixes the bug on my system.  As noted in
> the patch description, there are other calls to node_set_state() in
> mm/page_alloc.c which might also need to be switched to node_set(),
> if this is deemed the right solution.

Here's an update to that patch to handle the other 2 places I found
where node_set_state() would be a no-op when MAX_NUMNODES == 1.

I'm continuing to look at uses of node_online_map throughout the kernel.
I'll look at current usage of the node state wrappers as well.  However,
you probably want to fix these other 2 places as well, or you might run
into other issues with empty 'NORMAL_MEMORY and 'CPU node state masks...

Lee

[PATCH 1/1] memoryless: actually set node_states[N_HIGH_MEMORY] - v2

v1 -> v2"
+  switch to node_set() to initialize N_NORMAL_MEMORY and N_CPU
   node_states[] as well.

If CONFIG_NODES_SHIFT is unset, then MAX_NUMNODES=1, and
node_set_state() does nothing.  This means that __build_all_zonelists()
does not actually set node_states[N_HIGH_MEMORY].  cpusets needs
 node_states[N_HIGH_MEMORY] to be correctly set, or it will raise a
bug when a new cpuset is created.

Switch to using node_set() in __build_all_zonelists() to
make sure it is actually set.

Note there are other calls to node_set_state() in mm/page_alloc.c,
which perhaps should also be modified.  Since this area is completely
foreign to me I thought I'd first make sure this is the right approach.

	addressed in v2 --lts

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: Linux/mm/page_alloc.c
===================================================================
--- Linux.orig/mm/page_alloc.c	2007-08-14 16:48:28.000000000 -0400
+++ Linux/mm/page_alloc.c	2007-08-14 16:57:24.000000000 -0400
@@ -2425,7 +2425,8 @@ static void check_for_regular_memory(pg_
 	for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
 		if (zone->present_pages)
-			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
+			node_set(zone_to_nid(zone),
+					node_states[N_NORMAL_MEMORY]);
 	}
 #endif
 }
@@ -2443,7 +2444,7 @@ static int __build_all_zonelists(void *d
 
 		/* Any memory on that node */
 		if (pgdat->node_present_pages)
-			node_set_state(nid, N_HIGH_MEMORY);
+			node_set(nid, node_states[N_HIGH_MEMORY]);
 		check_for_regular_memory(pgdat);
 	}
 	return 0;
@@ -2793,7 +2794,7 @@ static int __cpuinit process_zones(int c
 			 	(zone->present_pages / percpu_pagelist_fraction));
 	}
 
-	node_set_state(node, N_CPU);
+	node_set(node, node_states[N_CPU]);
 	return 0;
 bad:
 	for_each_zone(dzone) {


