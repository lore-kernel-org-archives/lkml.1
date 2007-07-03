Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbXGCXgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbXGCXgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbXGCXfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:35:53 -0400
Received: from canuck.infradead.org ([209.217.80.40]:51168 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXGCXfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:35:52 -0400
Subject: Re: [PATCH] Re: Sparc32: random invalid instruction occourances on
	sparc32 (sun4c)
From: David Woodhouse <dwmw2@infradead.org>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Christoph Lameter <clameter@engr.sgi.com>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <Pine.LNX.4.61.0707032317590.30376@mtfhpc.demon.co.uk>
References: <468A7D14.1050505@googlemail.com>
	 <Pine.LNX.4.61.0707031817050.29930@mtfhpc.demon.co.uk>
	 <Pine.LNX.4.61.0707031910280.29930@mtfhpc.demon.co.uk>
	 <1183490778.29081.35.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0707032209230.30376@mtfhpc.demon.co.uk>
	 <1183499781.29081.46.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0707032317590.30376@mtfhpc.demon.co.uk>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 19:36:27 -0400
Message-Id: <1183505787.29081.62.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 23:47 +0100, Mark Fortescue wrote:
> Hi David,
> 
> I will try out your patch shortly.

Thanks.

> I may be wrong about the size calculations but if you take a look at lines 
> 2174 to 2188 and 2207 to 2203, reading the comments suggest to me that 
> these need to be changed to match the changes to the RedZone words. 
> Failing to change these means that 32bit aligned access of the 64bit 
> RedZone words is still posible and this will kill sun4c.

Why do we need more than the existing:

	if (flags & SLAB_RED_ZONE || flags & SLAB_STORE_USER)
		ralign = __alignof__(unsigned long long);

> For the 64bit RedZone word to be 64bit aligned (required by sun4c), the 
> User word must be 64bit aligned. I don't see where in your patch, this is 
> enforced.

Where __alignof__(long long) > BYTES_PER_WORD my patch should lead to
this layout (32-bit words):

    [ redzone1 bits 63-32 ]
    [ redzone1 bits 31-0  ]
    [    ... object ...   ]
    [    ... object ...   ]
    [ redzone2 bits 63-32 ]
    [ redzone2 bits 31-0  ]
    [        unused       ]
    [      user word      ]

The user word is a 32-bit value; there's no requirement for _it_ to be
aligned.

Hm, actually I think my patch may be incomplete -- I need to adjust the
size of the actual object too. This patch should be better...

diff --git a/mm/slab.c b/mm/slab.c
index a9c4472..8081c07 100644
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
@@ -2223,8 +2223,11 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	 * overridden by architecture or caller mandated alignment if either
 	 * is greater than BYTES_PER_WORD.
 	 */
-	if (flags & SLAB_RED_ZONE || flags & SLAB_STORE_USER)
+	if (flags & SLAB_RED_ZONE || flags & SLAB_STORE_USER) {
 		ralign = __alignof__(unsigned long long);
+		size += (__alignof__(unsigned long long) - 1);
+		size &= ~(__alignof__(unsigned long long) - 1);
+	}
 
 	/* 2) arch mandated alignment */
 	if (ralign < ARCH_SLAB_MINALIGN) {
@@ -2261,9 +2264,14 @@ kmem_cache_create (const char *name, size_t size, size_t align,
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

