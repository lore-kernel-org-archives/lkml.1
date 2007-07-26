Return-Path: <linux-kernel-owner+w=401wt.eu-S1765201AbXGZJ0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765201AbXGZJ0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbXGZJ0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:26:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45875 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbXGZJ0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:26:24 -0400
Subject: Re: [bug] SLUB & freeing locks [was: Re: 2.6.23-rc1: known
	regressions with patches]
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070726091048.GA7366@elte.hu>
References: <46A47940.7030801@googlemail.com>
	 <20070726091048.GA7366@elte.hu>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 11:26:03 +0200
Message-Id: <1185441963.8197.67.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 11:10 +0200, Ingo Molnar wrote:
> there's a new regression:
> 
> SLUB does not seem to call debug_check_no_locks_freed() - hence on SLUB 
> we will not notice certain types of freeing races. (such as freeing an 
> object still locked and used on another CPU.) SLAB does this corretly.

Does this help?

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -1131,6 +1131,7 @@ static void __free_slab(struct kmem_cach
 		slab_pad_check(s, page);
 		for_each_object(p, s, page_address(page))
 			check_object(s, page, p, 0);
+		ClearSlabDebug(page);
 	}
 
 	mod_zone_page_state(page_zone(page),
@@ -1169,7 +1170,6 @@ static void discard_slab(struct kmem_cac
 
 	atomic_long_dec(&n->nr_slabs);
 	reset_page_mapcount(page);
-	ClearSlabDebug(page);
 	__ClearPageSlab(page);
 	free_slab(s, page);
 }


