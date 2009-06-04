Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZFDFSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZFDFSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZFDFSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:18:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:54450 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZFDFSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:18:23 -0400
Message-ID: <4A2758CB.9090404@kernel.org>
Date: Wed, 03 Jun 2009 22:16:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com
CC: mel@csn.ul.ie, cl@linux-foundation.org, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       rusty@rustcorp.com.au, steiner@sgi.com, rientjes@google.com
Subject: [RESEND PATCH] mm: clear N_HIGH_MEMORY map before se set it again
 -v2
References: <4A05269D.8000701@kernel.org>	<20090512111623.GG25923@csn.ul.ie>	<4A0A64FB.4080504@kernel.org>	<20090513145950.GB28097@csn.ul.ie>	<4A0C4910.7090508@kernel.org>	<4A0C4A2A.6080009@kernel.org>	<20090514095414.ba8356e5.akpm@linux-foundation.org>	<4A0C4F67.5080802@kernel.org> <20090514102554.b3a36f19.akpm@linux-foundation.org> <4A0C563A.3020100@kernel.org>
In-Reply-To: <4A0C563A.3020100@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in case some system strange SRAT table. some kind of small range.
or with mem= boot option etc

if the wrong SRAT table, have small range for some node. that node will not be
onlined.  In the early checking, the bit in node_states[N_HIGH_MEMORY] for the
node is set even that node has less RAM like 1M, and it is not cleared before
the bit is set again in the following loop according online nodes finally.

for 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too

v2: fix typo

Signed-off-by: Yinghai Lu <Yinghai@kernel.org>
Tested-by: Jack Steiner <steiner@sgi.com>

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
