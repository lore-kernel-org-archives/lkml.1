Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbXLVNhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbXLVNhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXLVNhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:37:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41848 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbXLVNho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:37:44 -0500
Date: Sat, 22 Dec 2007 14:37:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, clameter@sgi.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] slub: /proc/slabinfo ABI compatibility
Message-ID: <20071222133727.GA12031@elte.hu>
References: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI> <20071222131601.GB32558@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222131601.GB32558@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > This adds a read-only /proc/slabinfo file that is ABI compatible with 
> > SLAB for SLUB.
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

Pekka, i stuck your patch into the x86.git random-test-grid, and it 
found the following build error after a few iterations:

  mm/slub.c: In function 's_show':
  mm/slub.c:4188: error: implicit declaration of function 'count_partial'

find the (tested) fix below.

	Ingo

----------------->
Subject: SLUB: build fix
From: Ingo Molnar <mingo@elte.hu>

fix:

 mm/slub.c: In function 's_show':
 mm/slub.c:4188: error: implicit declaration of function 'count_partial'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/slub.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -3079,6 +3079,19 @@ void *__kmalloc_node_track_caller(size_t
 	return slab_alloc(s, gfpflags, node, caller);
 }
 
+static unsigned long count_partial(struct kmem_cache_node *n)
+{
+	unsigned long flags;
+	unsigned long x = 0;
+	struct page *page;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+	list_for_each_entry(page, &n->partial, lru)
+		x += page->inuse;
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return x;
+}
+
 #if defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)
 static int validate_slab(struct kmem_cache *s, struct page *page,
 						unsigned long *map)
@@ -3464,19 +3477,6 @@ static int list_locations(struct kmem_ca
 	return n;
 }
 
-static unsigned long count_partial(struct kmem_cache_node *n)
-{
-	unsigned long flags;
-	unsigned long x = 0;
-	struct page *page;
-
-	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry(page, &n->partial, lru)
-		x += page->inuse;
-	spin_unlock_irqrestore(&n->list_lock, flags);
-	return x;
-}
-
 enum slab_stat_type {
 	SL_FULL,
 	SL_PARTIAL,
