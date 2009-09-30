Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbZI3VKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbZI3VKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZI3VKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:10:34 -0400
Received: from cmpxchg.org ([85.214.51.133]:56399 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZI3VKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:10:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [rfc patch 1/3] mm: always pass mapping in zap_details
Date: Wed, 30 Sep 2009 23:09:22 +0200
Message-Id: <1254344964-8124-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, unmap_mapping_range() only fills in the address space
information in zap details when it wants to filter private COW pages
and the zapping loops need to compare page->mapping against it.

For unmapping private COW pages on truncation, we will need this
information also in the opposite case to filter shared pages.

Demux this one check_mapping member by adding an explicit mode flag
and always pass along the address space.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mm.h |    3 ++-
 mm/memory.c        |   11 ++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -732,7 +732,8 @@ extern void user_shm_unlock(size_t, stru
  */
 struct zap_details {
 	struct vm_area_struct *nonlinear_vma;	/* Check page->index if set */
-	struct address_space *check_mapping;	/* Check page->mapping if set */
+	struct address_space *mapping;		/* Backing address space */
+	bool keep_private;			/* Do not touch private pages */
 	pgoff_t	first_index;			/* Lowest page->index to unmap */
 	pgoff_t last_index;			/* Highest page->index to unmap */
 	spinlock_t *i_mmap_lock;		/* For unmap_mapping_range: */
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -824,8 +824,8 @@ static unsigned long zap_pte_range(struc
 				 * invalidate cache without truncating:
 				 * unmap shared but keep private pages.
 				 */
-				if (details->check_mapping &&
-				    details->check_mapping != page->mapping)
+				if (details->keep_private &&
+				    details->mapping != page->mapping)
 					continue;
 				/*
 				 * Each page->index must be checked when
@@ -863,7 +863,7 @@ static unsigned long zap_pte_range(struc
 			continue;
 		}
 		/*
-		 * If details->check_mapping, we leave swap entries;
+		 * If details->keep_private, we leave swap entries;
 		 * if details->nonlinear_vma, we leave file entries.
 		 */
 		if (unlikely(details))
@@ -936,7 +936,7 @@ static unsigned long unmap_page_range(st
 	pgd_t *pgd;
 	unsigned long next;
 
-	if (details && !details->check_mapping && !details->nonlinear_vma)
+	if (details && !details->keep_private && !details->nonlinear_vma)
 		details = NULL;
 
 	BUG_ON(addr >= end);
@@ -2433,7 +2433,8 @@ void unmap_mapping_range(struct address_
 			hlen = ULONG_MAX - hba + 1;
 	}
 
-	details.check_mapping = even_cows? NULL: mapping;
+	details.mapping = mapping;
+	details.keep_private = !even_cows;
 	details.nonlinear_vma = NULL;
 	details.first_index = hba;
 	details.last_index = hba + hlen - 1;
