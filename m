Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbXGCVz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbXGCVz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXGCVzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:55:48 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58412 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbXGCVzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:55:47 -0400
Subject: Re: [PATCH] Re: Sparc32: random invalid instruction occourances on
	sparc32 (sun4c)
From: David Woodhouse <dwmw2@infradead.org>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Christoph Lameter <clameter@engr.sgi.com>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <Pine.LNX.4.61.0707032209230.30376@mtfhpc.demon.co.uk>
References: <468A7D14.1050505@googlemail.com>
	 <Pine.LNX.4.61.0707031817050.29930@mtfhpc.demon.co.uk>
	 <Pine.LNX.4.61.0707031910280.29930@mtfhpc.demon.co.uk>
	 <1183490778.29081.35.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0707032209230.30376@mtfhpc.demon.co.uk>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 17:56:21 -0400
Message-Id: <1183499781.29081.46.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 22:25 +0100, Mark Fortescue wrote:
> The problem is that sun4c Sparc32 can't handle un-aligned variables so 
> having a 64bit readzone word that is not aligned on a 64bit boundary is a 
> problem.

Surely, it can. You just have to tell the compiler that it's not
properly aligned, and it'll emit code to cope. Hence the suggestion that
you use 'unsigned long long __attribute__((aligned(BYTES_PER_WORD))'.
But it's probably better just to make sure it remains aligned; you're
right.

> In addition, having looked at the size calculations, it looks to me as if 
> not all of them got updated to handle 64bit redzone words. 

Really? Other than the alignment of the second redzone, what's wrong?
Remember that the 'user word' is still not necessarily 64-bit. And in
fact I suspect that's what is causing the problem -- your object _size_
will be aligned to 8 bytes, including the user word, and then we look
for the second redzone word 12 bytes before the end of the object.

Does this fix it?

diff --git a/mm/slab.c b/mm/slab.c
index 6d65cf4..3b15671 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -547,7 +547,7 @@ static unsigned long long *dbg_redzone2(struct kmem_cache *cachep, void *objp)
 	if (cachep->flags & SLAB_STORE_USER)
 		return (unsigned long long *)(objp + cachep->buffer_size -
 					      sizeof(unsigned long long) -
-					      BYTES_PER_WORD);
+					      max(BYTES_PER_WORD, __alignof__(unsigned long long)));
 	return (unsigned long long *) (objp + cachep->buffer_size -
 				       sizeof(unsigned long long));
 }
@@ -2262,9 +2262,14 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	}
 	if (flags & SLAB_STORE_USER) {
 		/* user store requires one word storage behind the end of
-		 * the real object.
+		 * the real object. But if the second red zone must be
+		 * aligned 'better' than that, allow for it.
 		 */
-		size += BYTES_PER_WORD;
+		if (flags & SLAB_RED_ZONE
+		    && BYTES_PER_WORD < __alignof__(unsigned long long))
+			size += __alignof__(unsigned long long);
+		else
+			size += BYTES_PER_WORD;
 	}
 #if FORCED_DEBUG && defined(CONFIG_DEBUG_PAGEALLOC)
 	if (size >= malloc_sizes[INDEX_L3 + 1].cs_size


-- 
dwmw2

