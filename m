Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYLLMV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYLLMV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 07:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbYLLMVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 07:21:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35265 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbYLLMVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 07:21:17 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: [RFC][PATCH] Give up reclaim quickly when fatal signal received.
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081212211621.62F5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 12 Dec 2008 21:21:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't mesure any performance yet.
This is purely discussion purpose patch.

==
Subject: [RFC][PATCH] Give up reclaim quickly when fatal signal received.

In some hosting service and data center and HPC server, process watching
daemon watch to exist bad boy process periodically. and if exist, the watcher
send SIGKILL to bad boy. 
It assume to dead SIGKILLed process immediately.

In the other hand, reclaim is generally very slow processing.
if process is reclaiming, the process is not dead long time although process
die can make much free memory than reclaim.

But, there is one big risk. there are low quality and poor error handling
driver in the world. alloc_page(GFP_KERNEL) failure can expose these 
poor driver mistake and panic kernel.


Luckily, any driver don't use __GFP_RECLAIMABLE and __GFP_MOVABLE. these flags 
indicate caller need for userland memory.
Therefore we can assume this flag mean alloc_pages() failure safe.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |    3 +++
 mm/vmscan.c     |   11 +++++++++++
 2 files changed, 14 insertions(+)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1536,6 +1536,9 @@ restart:
 	/* This allocation should allow future memory freeing. */
 
 rebalance:
+	if ((gfp_mask & GFP_MOVABLE_MASK) && fatal_signal_pending(current))
+		goto nopage;
+
 	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
 			&& !in_interrupt()) {
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1514,6 +1514,11 @@ static void shrink_zones(int priority, s
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 		if (!populated_zone(zone))
 			continue;
+
+		if ((sc->gfp_mask & GFP_MOVABLE_MASK) &&
+		    fatal_signal_pending(current))
+			break;
+
 		/*
 		 * Take care memory controller reclaiming has small influence
 		 * to global LRU.
@@ -1610,6 +1615,12 @@ static unsigned long do_try_to_free_page
 			ret = sc->nr_reclaimed;
 			goto out;
 		}
+		if ((sc->gfp_mask & GFP_MOVABLE_MASK) &&
+		    fatal_signal_pending(current)) {
+			/* if ret = 0, caller invoke oom killer. */
+			ret = 1;
+			goto out;
+		}
 
 		/*
 		 * Try to write back as many pages as we just scanned.  This


