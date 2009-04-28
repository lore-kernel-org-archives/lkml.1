Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZD1X3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZD1X3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZD1X3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:29:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52023 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbZD1X3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:29:36 -0400
Date: Tue, 28 Apr 2009 19:29:07 -0400
From: Rik van Riel <riel@redhat.com>
To: Elladan <elladan@eskimo.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, tytso@mit.edu,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Subject: [PATCH] vmscan: evict use-once pages first
Message-ID: <20090428192907.556f3a34@bree.surriel.com>
In-Reply-To: <20090428044426.GA5035@eskimo.com>
References: <20090428044426.GA5035@eskimo.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the file LRU lists are dominated by streaming IO pages,
evict those pages first, before considering evicting other
pages.

This should be safe from deadlocks or performance problems
because only three things can happen to an inactive file page:
1) referenced twice and promoted to the active list
2) evicted by the pageout code
3) under IO, after which it will get evicted or promoted

The pages freed in this way can either be reused for streaming
IO, or allocated for something else. If the pages are used for
streaming IO, this pageout pattern continues. Otherwise, we will
fall back to the normal pageout pattern.

Signed-off-by: Rik van Riel <riel@redhat.com>

--- 
Elladan, does this patch fix the issue you are seeing?

Peter, Kosaki, Ted, does this patch look good to you?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eac9577..4c0304e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1489,6 +1489,21 @@ static void shrink_zone(int priority, struct zone *zone,
 			nr[l] = scan;
 	}
 
+	/*
+	 * When the system is doing streaming IO, memory pressure here
+	 * ensures that active file pages get deactivated, until more
+	 * than half of the file pages are on the inactive list.
+	 *
+	 * Once we get to that situation, protect the system's working
+	 * set from being evicted by disabling active file page aging
+	 * and swapping of swap backed pages.  We still do background
+	 * aging of anonymous pages.
+	 */
+	if (nr[LRU_INACTIVE_FILE] > nr[LRU_ACTIVE_FILE]) {
+		nr[LRU_ACTIVE_FILE] = 0;
+		nr[LRU_INACTIVE_ANON] = 0;
+	}
+
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
 		for_each_evictable_lru(l) {
