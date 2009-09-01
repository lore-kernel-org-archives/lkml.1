Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZIAKD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZIAKD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 06:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZIAKD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 06:03:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60854 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbZIAKDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 06:03:53 -0400
Date: Tue, 1 Sep 2009 11:03:56 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: page allocator regression on nommu
Message-ID: <20090901100356.GA27393@csn.ul.ie>
References: <20090831074842.GA28091@linux-sh.org> <20090831103056.GA29627@csn.ul.ie> <20090831104315.GB30264@linux-sh.org> <20090831105952.GC29627@csn.ul.ie> <20090901004627.GA531@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090901004627.GA531@linux-sh.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 09:46:27AM +0900, Paul Mundt wrote:
> > What is the output of the following debug patch?
> > 
> 
> ...
> Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)
> ------------[ cut here ]------------
> Badness at mm/page_alloc.c:1046
> 

Ok, it looks like ownership was not being taken properly and the first
patch was incomplete. Please try

====

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d052abb..5596880 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -817,13 +815,15 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 			 * agressive about taking ownership of free pages
 			 */
 			if (unlikely(current_order >= (pageblock_order >> 1)) ||
-					start_migratetype == MIGRATE_RECLAIMABLE) {
+					start_migratetype == MIGRATE_RECLAIMABLE ||
+					page_group_by_mobility_disabled) {
 				unsigned long pages;
 				pages = move_freepages_block(zone, page,
 								start_migratetype);
 
 				/* Claim the whole block if over half of it is free */
-				if (pages >= (1 << (pageblock_order-1)))
+				if (pages >= (1 << (pageblock_order-1)) ||
+						page_group_by_mobility_disabled)
 					set_pageblock_migratetype(page,
 								start_migratetype);
 
