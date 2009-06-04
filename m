Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZFDR22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZFDR22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZFDR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:28:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:47052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbZFDR2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:28:20 -0400
Message-ID: <4A2803D1.4070001@kernel.org>
Date: Thu, 04 Jun 2009 10:26:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, mel@csn.ul.ie
CC: tglx@linutronix.de, hpa@zytor.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       rusty@rustcorp.com.au, steiner@sgi.com, rientjes@google.com
Subject: [PATCH] mm: clear N_HIGH_MEMORY map before se set it again -v4
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie> <4A0A64FB.4080504@kernel.org> <20090513145950.GB28097@csn.ul.ie> <4A0C4910.7090508@kernel.org> <4A0C4A2A.6080009@kernel.org> <20090514095414.ba8356e5.akpm@linux-foundation.org> <4A0C4F67.5080802@kernel.org> <20090514102554.b3a36f19.akpm@linux-foundation.org> <4A0C563A.3020100@kernel.org> <4A2758CB.9090404@kernel.org> <alpine.DEB.1.10.0906041236520.5377@gentwo.org> <4A27FAD4.2010104@kernel.org> <alpine.DEB.1.10.0906041309230.8080@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0906041309230.8080@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


SRAT tables may contains nodes of very small size. The arch code may
decide to not activate such a node. However, currently the early boot code
sets N_HIGH_MEMORY for such nodes. These nodes therefore seem to be active
although these nodes have no present pages.

for 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too

v4: update description according to Christoph

Signed-off-by: Yinghai Lu <Yinghai@kernel.org>
Tested-by: Jack Steiner <steiner@sgi.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -4041,6 +4041,11 @@ void __init free_area_init_nodes(unsigne
 						early_node_map[i].start_pfn,
 						early_node_map[i].end_pfn);
 
+	/*
+	 * find_zone_movable_pfns_for_nodes/early_calculate_totalpages init
+	 * that node_mask, clear it at first
+	 */
+	nodes_clear(node_states[N_HIGH_MEMORY]);
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
