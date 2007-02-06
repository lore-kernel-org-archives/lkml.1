Return-Path: <linux-kernel-owner+w=401wt.eu-S1751093AbXBFLXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbXBFLXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 06:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbXBFLXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 06:23:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35604 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXBFLXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 06:23:48 -0500
Date: Tue, 6 Feb 2007 20:23:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: GOTO <y-goto@jp.fujitsu.com>, Christoph Lameter <clameter@engr.sgi.com>,
       Andrew Morton <akpm@osdl.org>
Subject: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

current mempolicy just checks whether a node is online or not.
If there is memory-less-node, mempolicy's target node can be
invalid.
This patch adds a check whether a node has memory or not.

This is an back-trace in which a program uses MPOL_MBIND just includes
memory-less-node.

== backtrace from crash (linux-2.6.20) ==
 #0 [BSP:e000000121f412d8] schedule at a00000010061ccc0
 #1 [BSP:e000000121f41280] rwsem_down_failed_common at a000000100290490
 #2 [BSP:e000000121f41260] rwsem_down_read_failed at a000000100620d30
 #3 [BSP:e000000121f41240] down_read at a0000001000b01a0
 #4 [BSP:e000000121f411e8] ia64_do_page_fault at a000000100625710
 #5 [BSP:e000000121f411e8] ia64_leave_kernel at a00000010000c660
  EFRAME: e000000121f47100
      B0: a00000010013cc40      CR_IIP: a00000010012aa30
 CR_IPSR: 0000101008022018      CR_IFS: 8000000000000205
  AR_PFS: 0000000000000309      AR_RSC: 0000000000000003
 AR_UNAT: 0000000000000000     AR_RNAT: 0000000000000000
  AR_CCV: 0000000000000000     AR_FPSR: 0009804c8a70033f
  LOADRS: 0000000000000000 AR_BSPSTORE: 0000000000000000
      B6: a00000010003f040          B7: a00000010000ccd0
      PR: 000000000055a9a5          R1: a000000100d5a5b0
      R2: e00000010c50df7c          R3: 0000000000000030
      R8: 0000000000000000          R9: e00000011dc52930
     R10: e00000011dc52928         R11: e00000010c50df80
     R12: e000000121f472c0         R13: e000000121f40000
     R14: 0000000000000002         R15: 000000003fffff00
     R16: 0000000010400000         R17: e000000121f40000
     R18: a000000100b5a9d0         R19: e000000121f40018
     R20: e000000121f40c84         R21: 0000000000000000
     R22: e000000121f47330         R23: e000000121f47334
     R24: e000000121f40b88         R25: e000000121f47340
     R26: e000000121f47334         R27: 0000000000000000
     R28: 0000000000000000         R29: e000000121f47338
     R30: 000000007fffffff         R31: a000000100b5b5e0
      F6: 1003eccd55056199632ec     F7: 1003e9e3779b97f4a7c16
      F8: 1003e0a00000010001422     F9: 1003e000000000fa00000
     F10: 1003e000000003b9aca00    F11: 1003e431bde82d7b634db
 #6 [BSP:e000000121f411c0] slab_node at a00000010012aa30
 #7 [BSP:e000000121f41190] alternate_node_alloc at a00000010013cc40
 #8 [BSP:e000000121f41160] kmem_cache_alloc at a00000010013dc40
 #9 [BSP:e000000121f41100] desc_prologue at a00000010003ee00
#10 [BSP:e000000121f410c0] unw_decode_r2 at a00000010003f0c0
#11 [BSP:e000000121f41068] find_save_locs at a00000010003fbf0
#12 [BSP:e000000121f41038] unw_init_frame_info at a000000100040900
#13 [BSP:e000000121f41010] unw_init_running at a00000010000ccf0
==
This panic(hang) was found by a numa test-set on a system with 3 nodes, where
node(2) was memory-less-node.

This means an access to NULL,here.
==
unsigned slab_node(struct mempolicy *policy)
{
        case MPOL_BIND:
                /*
                 * Follow bind policy behavior and start allocation at the
                 * first node.
                 */
                return zone_to_nid(policy->v.zonelist->zones[0]);
}
==
length of this zonelist was 0.
It seems fixing a NULL access here is also O.K. 
This patch is just an idea.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



Index: linux-2.6.20/mm/mempolicy.c
===================================================================
--- linux-2.6.20.orig/mm/mempolicy.c	2007-02-06 20:02:31.000000000 +0900
+++ linux-2.6.20/mm/mempolicy.c	2007-02-06 20:09:47.000000000 +0900
@@ -116,6 +116,8 @@
 static int mpol_check_policy(int mode, nodemask_t *nodes)
 {
 	int empty = nodes_empty(*nodes);
+	int nd;
+	nodemask_t node_with_memory;
 
 	switch (mode) {
 	case MPOL_DEFAULT:
@@ -130,7 +132,12 @@
 			return -EINVAL;
 		break;
 	}
-	return nodes_subset(*nodes, node_online_map) ? 0 : -EINVAL;
+	nodes_clear(node_with_memory);
+	for_each_online_node(nd) {
+		if (node_present_pages(nd))
+			node_set(nd, node_with_memory);
+	}
+	return nodes_subset(*nodes, node_with_memory) ? 0 : -EINVAL;
 }
 
 /* Generate a custom zonelist for the BIND policy. */

