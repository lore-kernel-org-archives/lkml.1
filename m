Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXKKIk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXKKIk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 03:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbXKKIkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 03:40:18 -0500
Received: from ns.suse.de ([195.135.220.2]:52600 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbXKKIkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 03:40:16 -0500
Date: Sun, 11 Nov 2007 09:40:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch] mm: unlockless reclaim
Message-ID: <20071111084012.GB19816@wotan.suse.de>
References: <20071110051222.GA16018@wotan.suse.de> <20071110054343.GA17803@wotan.suse.de> <1194695495.20832.27.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194695495.20832.27.camel@lappy>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Combined with the previous and subsequent patches, throughput of pages through
the pagecache on an Opteron system here goes up by anywhere from 50% to 500%,
depending on the number of files and threads involved.
--

unlock_page is fairly expensive. It can be avoided in page reclaim.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c
+++ linux-2.6/mm/vmscan.c
@@ -589,7 +589,14 @@ static unsigned long shrink_page_list(st
 			goto keep_locked;
 
 free_it:
-		unlock_page(page);
+		/*
+		 * At this point, we have no other references and there is
+		 * no way to pick any more up (removed from LRU, removed
+		 * from pagecache). Can use non-atomic bitops now (and
+		 * we obviously don't have to worry about waking up a process
+		 * waiting on the page lock, because there are no references.
+		 */
+		__clear_page_locked(page);
 		nr_reclaimed++;
 		if (!pagevec_add(&freed_pvec, page))
 			__pagevec_release_nonlru(&freed_pvec);
