Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbYGOUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbYGOUKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbYGOUKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:10:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758197AbYGOUKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:10:12 -0400
Date: Tue, 15 Jul 2008 16:09:48 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH][RFC] evict streaming IO cache first
Message-ID: <20080715160948.097b14a4@cuia.bos.redhat.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch still needs some testing under various workloads
on different hardware - the approach should work but the
threshold may need tweaking.


When there is a lot of streaming IO going on, we do not want
to scan or evict pages from the working set.  The old VM used
to skip any mapped page, but still evict indirect blocks and
other data that is useful to cache.

This patch adds logic to skip scanning the anon lists and
the active file list if most of the file pages are on the
inactive file list (where streaming IO pages live), while
at the lowest scanning priority.

If the system is not doing a lot of streaming IO, eg. the
system is running a database workload, then more often used
file pages will be on the active file list and this logic
is automatically disabled.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/mmzone.h |    1 +
 mm/vmscan.c            |   18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc8-mm1/include/linux/mmzone.h
===================================================================
--- linux-2.6.26-rc8-mm1.orig/include/linux/mmzone.h	2008-07-07 15:41:32.000000000 -0400
+++ linux-2.6.26-rc8-mm1/include/linux/mmzone.h	2008-07-15 14:58:50.000000000 -0400
@@ -453,6 +453,7 @@ static inline int zone_is_oom_locked(con
  * queues ("queue_length >> 12") during an aging round.
  */
 #define DEF_PRIORITY 12
+#define PRIO_CACHE_ONLY DEF_PRIORITY+1
 
 /* Maximum number of zones on a zonelist */
 #define MAX_ZONES_PER_ZONELIST (MAX_NUMNODES * MAX_NR_ZONES)
Index: linux-2.6.26-rc8-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc8-mm1.orig/mm/vmscan.c	2008-07-07 15:41:33.000000000 -0400
+++ linux-2.6.26-rc8-mm1/mm/vmscan.c	2008-07-15 15:10:05.000000000 -0400
@@ -1481,6 +1481,20 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
+	/*
+	 * If there is a lot of sequential IO going on, most of the
+	 * file pages will be on the inactive file list.  We start
+	 * out by reclaiming those pages, without putting pressure on
+	 * the working set.  We only do this if the bulk of the file pages
+	 * are not in the working set (on the active file list).
+	 */
+	if (priority == PRIO_CACHE_ONLY &&
+			(nr[LRU_INACTIVE_FILE] > nr[LRU_ACTIVE_FILE]))
+		for_each_evictable_lru(l)
+			/* Scan only the inactive_file list. */
+			if (l != LRU_INACTIVE_FILE)
+				nr[l] = 0;
+
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
 		for_each_evictable_lru(l) {
@@ -1609,7 +1623,7 @@ static unsigned long do_try_to_free_page
 		}
 	}
 
-	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
+	for (priority = PRIO_CACHE_ONLY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
@@ -1771,7 +1785,7 @@ loop_again:
 	for (i = 0; i < pgdat->nr_zones; i++)
 		temp_priority[i] = DEF_PRIORITY;
 
-	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
+	for (priority = PRIO_CACHE_ONLY; priority >= 0; priority--) {
 		int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 		unsigned long lru_pages = 0;
 

