Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbZD3NG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbZD3NG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbZD3NGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:06:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:36727 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbZD3NGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:06:15 -0400
Date: Thu, 30 Apr 2009 15:05:42 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Sachin Sant <sachinp@in.ibm.com>,
       linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
Message-ID: <20090430130542.GF6900@wotan.suse.de>
References: <49F87FAB.9050408@in.ibm.com> <20090430041146.GB23746@wotan.suse.de> <49F938E4.2030703@in.ibm.com> <20090430064127.GF23746@wotan.suse.de> <49F973A0.8070106@in.ibm.com> <20090430103528.GA6900@wotan.suse.de> <1241087884.19252.5.camel@penberg-laptop> <20090430210004.05a61841.sfr@canb.auug.org.au> <20090430111825.GC6900@wotan.suse.de> <1241090429.19252.7.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241090429.19252.7.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 02:20:29PM +0300, Pekka Enberg wrote:
> On Thu, 2009-04-30 at 13:18 +0200, Nick Piggin wrote:
> > OK thanks. So I think we have 2 problems. One with MAX_ORDER <= 9
> > that is fixed by the previous patch, and another which is probably
> > due to having no memory on node 0 which I will take another look
> > at now.
> > 
> > We can merge the previous patch now, though.
> 
> Hmm, I'll bet this BUG_ON triggers for Stephen.
> 
> diff --git a/mm/slqb.c b/mm/slqb.c
> index a651843..e4b3859 100644
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -1391,6 +1391,7 @@ static noinline void *__slab_alloc_page(struct kmem_cache *s,
>  		struct kmem_cache_node *n;
>  
>  		n = s->node_slab[slqb_page_to_nid(page)];
> +		BUG_ON(!n);
>  		l = &n->list;
>  		page->list = l;

Hmm, this might do it. The following code now passes some stress testing
in a userspace harness wheras before it did not (and was obviously wrong).

---
SLQB: fix dumb early allocation cache

The dumb early allocation cache had a bug where it could allow allocation
to go past the end of a page, which could cause crashes or random memory
corruption. Fix this and simplify the logic.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 mm/slqb.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

Index: linux-2.6/mm/slqb.c
===================================================================
--- linux-2.6.orig/mm/slqb.c
+++ linux-2.6/mm/slqb.c
@@ -2185,8 +2185,11 @@ static void *kmem_cache_dyn_array_alloc(
 {
 	size_t size = sizeof(void *) * ids;
 
+	BUG_ON(!size);
+
 	if (unlikely(!slab_is_available())) {
 		static void *nextmem;
+		static size_t nextleft;
 		void *ret;
 
 		/*
@@ -2194,16 +2197,16 @@ static void *kmem_cache_dyn_array_alloc(
 		 * never get freed by definition so we can do it rather
 		 * simply.
 		 */
-		if (!nextmem) {
-			nextmem = alloc_pages_exact(size, GFP_KERNEL);
-			if (!nextmem)
-				return NULL;
+		if (size > nextleft) {
+                        nextmem = alloc_pages_exact(size, GFP_KERNEL);
+                        if (!nextmem)
+                                return NULL;
+			nextleft = roundup(size, PAGE_SIZE);
 		}
+
 		ret = nextmem;
-		nextmem = (void *)((unsigned long)ret + size);
-		if ((unsigned long)ret >> PAGE_SHIFT !=
-				(unsigned long)nextmem >> PAGE_SHIFT)
-			nextmem = NULL;
+		nextleft -= size;
+		nextmem += size;
 		memset(ret, 0, size);
 		return ret;
 	} else {
