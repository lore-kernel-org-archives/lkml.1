Return-Path: <linux-kernel-owner+w=401wt.eu-S940794AbXGSSO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940794AbXGSSO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762299AbXGSSOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:14:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756401AbXGSSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:14:16 -0400
Date: Thu, 19 Jul 2007 11:11:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: Re: kmalloc zero size changes break i386
In-Reply-To: <adamyxsfmnc.fsf@cisco.com>
Message-ID: <alpine.LFD.0.999.0707191107570.27353@woody.linux-foundation.org>
References: <200707191201.35777.ak@suse.de> <84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com>
 <adamyxsfmnc.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jul 2007, Roland Dreier wrote:
>
> I think the oops below is related -- Michael reports that avoiding
> kmalloc(0) in the mlx4_ib driver makes it go away.

Ok, I think I see it: I think the mm/slab.c conversion of kmalloc(0) is
totally broken.

The problem? It returns ZERO_SIZE_PTR from __find_general_cachep(), not 
from __kmalloc(). So anythign that uses __find_general_cachep() will get 
an invalid cachep pointer, which was not the point.

We're deprecating SLAB, and a lot of people are already using SLUB, 
which hid this. 

Does something like this fix it?

Christoph, please go over this and see if there are other cases like that.

		Linus

---
diff --git a/mm/slab.c b/mm/slab.c
index 88bc633..4bc4bc0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -775,8 +775,6 @@ static inline struct kmem_cache *__find_general_cachep(size_t size,
 	 */
 	BUG_ON(malloc_sizes[INDEX_AC].cs_cachep == NULL);
 #endif
-	if (!size)
-		return ZERO_SIZE_PTR;
 
 	while (size > csizep->cs_size)
 		csizep++;
@@ -3684,6 +3682,9 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 {
 	struct kmem_cache *cachep;
 
+	if (!size)
+		return ZERO_SIZE_PTR;
+
 	/* If you want to save a few bytes .text space: replace
 	 * __ with kmem_.
 	 * Then kmalloc uses the uninlined functions instead of the inline
