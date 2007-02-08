Return-Path: <linux-kernel-owner+w=401wt.eu-S1422877AbXBHCGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422877AbXBHCGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422886AbXBHCGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:06:40 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59402 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422877AbXBHCGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:06:39 -0500
Date: Thu, 8 Feb 2007 11:06:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: clameter@sgi.com, Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       GOTO <y-goto@jp.fujitsu.com>
Subject: [BUG][PATCH] fix mempolcy's check on a system with memory-less-node
 take2
Message-Id: <20070208110606.ebf668d3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, This is much easier fix than previous one...
--
following is back trace of NULL pointer access in slab_node().
This patch fix this.
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

This patch fixes zero-length zonelist problem in MPOL_MBIND.
If the length of zonelist is zero, just returns -EINVAL.

Changelog: v1 -> v2
- avoid extra pgdat scanning....it is not necessary.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Index: linux-2.6.20/mm/mempolicy.c
===================================================================
--- linux-2.6.20.orig/mm/mempolicy.c	2007-02-08 09:50:45.000000000 +0900
+++ linux-2.6.20/mm/mempolicy.c	2007-02-08 10:35:53.000000000 +0900
@@ -144,7 +144,7 @@
 	max++;			/* space for zlcache_ptr (see mmzone.h) */
 	zl = kmalloc(sizeof(struct zone *) * max, GFP_KERNEL);
 	if (!zl)
-		return NULL;
+		return PTR_ERR(-ENOMEM);
 	zl->zlcache_ptr = NULL;
 	num = 0;
 	/* First put in the highest zones from all nodes, then all the next 
@@ -162,6 +162,10 @@
 			break;
 		k--;
 	}
+	if (!num) {
+		kfree(zl);
+		return PTR_ERR(-EINVAL);
+	}
 	zl->zones[num] = NULL;
 	return zl;
 }
@@ -170,6 +174,7 @@
 static struct mempolicy *mpol_new(int mode, nodemask_t *nodes)
 {
 	struct mempolicy *policy;
+	void  *val;
 
 	PDprintk("setting mode %d nodes[0] %lx\n", mode, nodes_addr(*nodes)[0]);
 	if (mode == MPOL_DEFAULT)
@@ -192,11 +197,12 @@
 			policy->v.preferred_node = -1;
 		break;
 	case MPOL_BIND:
-		policy->v.zonelist = bind_zonelist(nodes);
-		if (policy->v.zonelist == NULL) {
+		val = bind_zonelist(nodes);
+		if (IS_ERR(val)) {
 			kmem_cache_free(policy_cache, policy);
-			return ERR_PTR(-ENOMEM);
+			return val;
 		}
+		policy->v.zonelist = val;
 		break;
 	}
 	policy->policy = mode;
@@ -1662,12 +1668,12 @@
 
 		zonelist = bind_zonelist(&nodes);
 
-		/* If no mem, then zonelist is NULL and we keep old zonelist.
+		/* If no mem, then zonelist is ERR_PTR and we keep old zonelist.
 		 * If that old zonelist has no remaining mems_allowed nodes,
 		 * then zonelist_policy() will "FALL THROUGH" to MPOL_DEFAULT.
 		 */
 
-		if (zonelist) {
+		if (!IS_ERR(zonelist)) {
 			/* Good - got mem - substitute new zonelist */
 			kfree(pol->v.zonelist);
 			pol->v.zonelist = zonelist;

