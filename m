Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbXHPN2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbXHPN2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbXHPN17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:27:59 -0400
Received: from tayrelbas04.tay.hp.com ([161.114.80.247]:59723 "EHLO
	tayrelbas04.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbXHPN15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:27:57 -0400
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: akpm@linux-foundation.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       Christoph Lameter <clameter@sgi.com>
Cc: bob.picco@hp.com, nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       mel@skynet.ie, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
In-Reply-To: <20070815165234.GC1179@linux.vnet.ibm.com>
References: <1187115224.6281.40.camel@localhost>
	 <20070814192306.GB32553@vino.hallyn.com>
	 <20070814204951.GA2065@vino.hallyn.com>
	 <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
	 <1187127685.6281.139.camel@localhost>
	 <Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
	 <1187185392.5422.13.camel@localhost>
	 <20070815143125.GA11582@vino.hallyn.com>
	 <1187195028.5422.30.camel@localhost>
	 <20070815163142.GA12850@vino.hallyn.com>
	 <20070815165234.GC1179@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 16 Aug 2007 09:26:37 -0400
Message-Id: <1187270797.5900.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew:  this one should go with the other memoryless node patches.

Lee

---------------------------------------

PATCH	Initialize N_*_MEMORY and N_CPU masks for non-NUMA config

Against:  2.6.23-rc2-mm2

The N_*_MEMORY and N_CPU node state masks are not being initialized
for !NUMA because node_set_state() becomes a no-op for that config.
This causes one to hit a BUG_ON() attempting to mount cpusets to partition
cpus.  Discovered and diagnosed by Serge Hallyn and Dhaval Giani.

Statically initialize the N_*_MEMORY and N_CPU node state masks
for !NUMA configurations.  This static initialization is required
because the node_set_state() function becomes a no-op for !NUMA.
Other generic code assumes that these masks are set correctly.

Note that in NUMA configurations, these masks will be populated
correctly, so don't bother with static initialization.  No sense
in making assumptions that could be broken down the road, resulting
in extra work for someone to debug.  Unlikely, perhaps, but who
needs the aggravation...

Tested on i386 !NUMA by Dhaval Giani.  Fixes cpuset BUG.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: Linux/mm/page_alloc.c
===================================================================
--- Linux.orig/mm/page_alloc.c	2007-08-15 10:01:23.000000000 -0400
+++ Linux/mm/page_alloc.c	2007-08-15 10:05:41.000000000 -0400
@@ -52,7 +52,14 @@
  */
 nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_POSSIBLE] = NODE_MASK_ALL,
-	[N_ONLINE] = { { [0] = 1UL } }
+	[N_ONLINE] = { { [0] = 1UL } },
+#ifndef CONFIG_NUMA
+	[N_NORMAL_MEMORY] = { { [0] = 1UL } },
+#ifdef CONFIG_HIGHMEM
+	[N_HIGH_MEMORY] = { { [0] = 1UL } },
+#endif
+	[N_CPU] = { { [0] = 1UL } },
+#endif	/* NUMA */
 };
 EXPORT_SYMBOL(node_states);
 


