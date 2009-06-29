Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbZF2LFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbZF2LFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZF2LFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:05:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:31939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZF2LFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:05:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,309,1243839600"; 
   d="scan'208";a="426149705"
Subject: [patch] fix hugepage unuseable issu on non-NUMA machine
From: "alex.shi" <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: Yinghai@kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Chen, Tim C" <tim.c.chen@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 19:10:02 +0800
Message-Id: <1246273802.3160.28.camel@alexs-hp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

73d60b7f747176dbdff826c4127d22e1fd3f9f74 commit introduced a nodes_clear
function for NUMA machine. But seems the commit omits non-NUMA machine.
If find_zone_movable_pfns_for_nodes/early_calculate_totalpages has no
chance to run. nodes_clear will block HUPEPAGE using in my specjbb2005
testing. 


So maybe we need to disable nodes_clear sometimes. With the following
patch. specjbb2005 recovered. 


Signed-off-by: Alex Shi <alex.shi@intel.com>
---
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5d714f8..46ff861 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4246,7 +4246,8 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 	 * find_zone_movable_pfns_for_nodes/early_calculate_totalpages init
 	 * that node_mask, clear it at first
 	 */
-	nodes_clear(node_states[N_HIGH_MEMORY]);
+	if (required_kernelcore)
+		nodes_clear(node_states[N_HIGH_MEMORY]);
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();




