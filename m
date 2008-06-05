Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbYFEKAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbYFEKAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 06:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbYFEJ4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:56:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:59888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbYFEJ4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:56:34 -0400
Message-Id: <20080605094825.530462000@nick.local0.net>
References: <20080605094300.295184000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Thu, 05 Jun 2008 19:43:01 +1000
From: npiggin@suse.de
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       paulus@samba.org
Subject: [patch 1/7] mm: readahead scan lockless
Content-Disposition: inline; filename=mm-readahead-scan-lockless.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radix_tree_next_hole is implemented as a series of radix_tree_lookup()s. So
it can be called locklessly, under rcu_read_lock().

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/mm/readahead.c
===================================================================
--- linux-2.6.orig/mm/readahead.c
+++ linux-2.6/mm/readahead.c
@@ -382,9 +382,9 @@ ondemand_readahead(struct address_space 
 	if (hit_readahead_marker) {
 		pgoff_t start;
 
-		read_lock_irq(&mapping->tree_lock);
-		start = radix_tree_next_hole(&mapping->page_tree, offset, max+1);
-		read_unlock_irq(&mapping->tree_lock);
+		rcu_read_lock();
+		start = radix_tree_next_hole(&mapping->page_tree, offset,max+1);
+		rcu_read_unlock();
 
 		if (!start || start - offset > max)
 			return 0;

-- 

