Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbZFXTMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbZFXTMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbZFXTM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:12:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56888 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbZFXTM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:12:26 -0400
Date: Wed, 24 Jun 2009 22:12:26 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <alpine.LFD.2.01.0906241147460.3240@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0906242210520.25779@melkki.cs.Helsinki.FI>
References: <20090624080753.4f677847@infradead.org> 
 <20090624094622.d0b0fd82.akpm@linux-foundation.org> 
 <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> 
 <20090624105517.904f93da.akpm@linux-foundation.org>  <4A426825.80905@cs.helsinki.fi>
  <20090624113037.7d72ed59.akpm@linux-foundation.org> 
 <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain>
 <84144f020906241144of2c85c7xc5f258a7837896c9@mail.gmail.com>
 <alpine.LFD.2.01.0906241147460.3240@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, 24 Jun 2009, Pekka Enberg wrote:
> > 
> > That said, I do think we ought to fix SLUB not to use __GFP_FAIL for
> > the higher order allocation regardless of this patch.
 
On Wed, 24 Jun 2009, Linus Torvalds wrote:
> I agree. Within the context of SLUB, it makes absolute sense.
> 
> That's especially true since SLUB already uses __GFP_NORETRY or whatever. 
> 
> The combination of __GFP_NOFAIL | __GFP_NORETRY is just insane. So your 
> patch to remove __GFP_NOFAIL when adding __GFP_NORETRY is absolutely the 
> ObviouslyCorrectThingToDo(tm).
> 
> Please integrate that, and take my patch too if you would (add my sign-off 
> or just do your own version)? Or should I just apply them?

Whatever suits you best. I don't have my laptop with me at home so I can't 
test them or send a pull request. I'm including a compile-tested patch 
here in case you want to go ahead and merge them. If you don't want to do 
that, I'll integrate both of the tomorrow morning and send you a pull 
request.

			Pekka

>From 7c251e5a5e7948626bfbcf406f7c90c60f182abd Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 24 Jun 2009 21:59:51 +0300
Subject: [PATCH] SLUB: Don't pass __GFP_FAIL for the initial allocation

SLUB uses higher order allocations by default but falls back to small
orders under memory pressure. Make sure the GFP mask used in the initial
allocation doesn't include __GFP_NOFAIL.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index ce62b77..819f056 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1085,11 +1085,17 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	struct page *page;
 	struct kmem_cache_order_objects oo = s->oo;
+	gfp_t alloc_gfp;
 
 	flags |= s->allocflags;
 
-	page = alloc_slab_page(flags | __GFP_NOWARN | __GFP_NORETRY, node,
-									oo);
+	/*
+	 * Let the initial higher-order allocation fail under memory pressure
+	 * so we fall-back to the minimum order allocation.
+	 */
+	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
+
+	page = alloc_slab_page(alloc_gfp, node, oo);
 	if (unlikely(!page)) {
 		oo = s->min;
 		/*
-- 
1.5.6.4

