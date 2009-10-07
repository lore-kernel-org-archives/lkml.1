Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbZJGSiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbZJGSiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbZJGSiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:38:03 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:42329 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853AbZJGSiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:38:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch] mm: order evictable rescue in LRU putback
Date: Wed,  7 Oct 2009 20:36:50 +0200
Message-Id: <1254940610-27324-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isolators putting a page back to the LRU do not hold the page lock,
and if the page is mlocked, another thread might munlock it
concurrently.

Expecting this, the putback code re-checks the evictability of a page
when it just moved it to the unevictable list in order to correct its
decision.

The problem, however, is that ordering is not garuanteed between
setting PG_lru when moving the page to the list and checking
PG_mlocked afterwards:

	#0:				#1

	spin_lock()
					if (TestClearPageMlocked())
					  if (PageLRU())
					    move to evictable list
	SetPageLRU()
	spin_unlock()
	if (!PageMlocked())
	  move to evictable list

The PageMlocked() check may get reordered before SetPageLRU() in #0,
resulting in #0 not moving the still mlocked page, and in #1 failing
to isolate and move the page as well.  The page is now stranded on the
unevictable list.

The race condition is very unlikely.  The consequence currently is one
page falling off the reclaim grid and eventually getting freed with
PG_unevictable set, which triggers a warning in the page allocator.

TestClearPageMlocked() in #1 already provides full memory barrier
semantics.

This patch adds an explicit full barrier to force ordering between
SetPageLRU() and PageMlocked() so that either one of the competitors
rescues the page.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -544,6 +544,16 @@ redo:
 		 */
 		lru = LRU_UNEVICTABLE;
 		add_page_to_unevictable_list(page);
+		/*
+		 * When racing with an mlock clearing (page is
+		 * unlocked), make sure that if the other thread does
+		 * not observe our setting of PG_lru and fails
+		 * isolation, we see PG_mlocked cleared below and move
+		 * the page back to the evictable list.
+		 *
+		 * The other side is TestClearPageMlocked().
+		 */
+		smp_mb();
 	}
 
 	/*
