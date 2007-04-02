Return-Path: <linux-kernel-owner+w=401wt.eu-S965320AbXDBJuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965320AbXDBJuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965322AbXDBJuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:50:54 -0400
Received: from saeurebad.de ([85.214.36.134]:50216 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965320AbXDBJux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:50:53 -0400
Date: Mon, 2 Apr 2007 11:50:49 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
       gorcunov@gmail.com
Subject: [PATCH] Catch kmalloc failure in kmem_cache_init() (was: [QUESTION] check for mem in slab)
Message-ID: <20070402095049.GA5831@saeurebad.de>
References: <20070329160434.GA10265@cvg> <20070330065641.GA8365@osiris.boeblingen.de.ibm.com> <84144f020703300455i4fe6bdc5yf4389c2105487bb0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <84144f020703300455i4fe6bdc5yf4389c2105487bb0@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

> On 3/30/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> >> in file mm/slab.c and routine kmem_cache_init() I found there
> >> is no checking for allocated memory on line:
> >>
> >>       /* 4) Replace the bootstrap head arrays */
> >>       {
> >>               struct array_cache *ptr;
> >>
> >>               ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
> >>
> >> --> no check for ptr == NULL <--
> >[...]
> >> is that OK? or it's a bug?
> >
> >It's ok. If that allocation fails your machine won't come up anyway.
> 
> We ought to add a BUG_ON or comment at least there as this keeps
> popping up again and again.

Done. Patch attached.

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="slab-cache-init-kmalloc-failure-catch.patch"

diff --git a/mm/slab.c b/mm/slab.c
index 57f7aa4..6d7e486 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1512,6 +1512,7 @@ void __init kmem_cache_init(void)
 		struct array_cache *ptr;
 
 		ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+		BUG_ON(!ptr);
 
 		local_irq_disable();
 		BUG_ON(cpu_cache_get(&cache_cache) != &initarray_cache.cache);
@@ -1526,6 +1527,7 @@ void __init kmem_cache_init(void)
 		local_irq_enable();
 
 		ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+		BUG_ON(!ptr);
 
 		local_irq_disable();
 		BUG_ON(cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep)

--H1spWtNR+x+ondvy--
