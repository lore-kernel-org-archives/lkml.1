Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZEMDTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZEMDTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbZEMDHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:07:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47733 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415AbZEMDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:07:31 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 3/4] vmscan: zone_reclaim use may_swap
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090513120155.5879.A69D9226@jp.fujitsu.com>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com>
Message-Id: <20090513120651.5882.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 May 2009 12:07:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] vmscan: zone_reclaim use may_swap

Documentation/sysctl/vm.txt says

	zone_reclaim_mode:

	Zone_reclaim_mode allows someone to set more or less aggressive approaches to
	reclaim memory when a zone runs out of memory. If it is set to zero then no
	zone reclaim occurs. Allocations will be satisfied from other zones / nodes
	in the system.

	This is value ORed together of

	1	= Zone reclaim on
	2	= Zone reclaim writes dirty pages out
	4	= Zone reclaim swaps pages


So, "(zone_reclaim_mode & RECLAIM_SWAP) == 0" mean we don't want to reclaim
swap-backed pages. not mapped file.

Thus, may_swap is better than may_unmap.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2387,8 +2387,8 @@ static int __zone_reclaim(struct zone *z
 	int priority;
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
-		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
-		.may_swap = 1,
+		.may_unmap = 1,
+		.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.swap_cluster_max = max_t(unsigned long, nr_pages,
 					SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,


