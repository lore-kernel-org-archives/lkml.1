Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYK1LIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYK1LIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYK1LIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:08:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55055 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbYK1LIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:08:09 -0500
Date: Fri, 28 Nov 2008 06:08:03 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       akpm@linux-foundation.org
Subject: [PATCH] vmscan: skip freeing memory from zones with lots free
Message-ID: <20081128060803.73cd59bd@bree.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip freeing memory from zones that already have lots of free memory.
If one memory zone has harder to free memory, we want to avoid freeing
excessive amounts of memory from other zones, if only because pageout
IO from the other zones can slow down page freeing from the problem zone.

This is similar to the check already done by kswapd in balance_pgdat().

Signed-off-by: Rik van Riel <riel@redhat.com>
---
Kosaki-san, this should address point (3) from your list.

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.28-rc5/mm/vmscan.c
===================================================================
--- linux-2.6.28-rc5.orig/mm/vmscan.c	2008-11-28 05:53:56.000000000 -0500
+++ linux-2.6.28-rc5/mm/vmscan.c	2008-11-28 06:05:29.000000000 -0500
@@ -1510,6 +1510,9 @@ static unsigned long shrink_zones(int pr
 			if (zone_is_all_unreclaimable(zone) &&
 						priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
+			if (zone_watermark_ok(zone, sc->order,
+					4*zone->pages_high, high_zoneidx, 0))
+				continue;	/* Lots free already */
 			sc->all_unreclaimable = 0;
 		} else {
 			/*
