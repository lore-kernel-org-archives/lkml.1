Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab0CLQle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 11:41:34 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40205 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756987Ab0CLQl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 11:41:29 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 02/11] mm,migration: Do not try to migrate unmapped anonymous pages
Date: Fri, 12 Mar 2010 16:41:18 +0000
Message-Id: <1268412087-13536-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rmap_walk_anon() was triggering errors in memory compaction that looks like
use-after-free errors in anon_vma. The problem appears to be that between
the page being isolated from the LRU and rcu_read_lock() being taken, the
mapcount of the page dropped to 0 and the anon_vma was freed. This patch
skips the migration of anon pages that are not mapped by anyone.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
---
 mm/migrate.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 98eaaf2..3c491e3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -602,6 +602,16 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 	 * just care Anon page here.
 	 */
 	if (PageAnon(page)) {
+		/*
+		 * If the page has no mappings any more, just bail. An
+		 * unmapped anon page is likely to be freed soon but worse,
+		 * it's possible its anon_vma disappeared between when
+		 * the page was isolated and when we reached here while
+		 * the RCU lock was not held
+		 */
+		if (!page_mapcount(page))
+			goto uncharge;
+
 		rcu_read_lock();
 		rcu_locked = 1;
 		anon_vma = page_anon_vma(page);
-- 
1.6.5

