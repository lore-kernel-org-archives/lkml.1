Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbXLHRtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbXLHRtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXLHRtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:49:03 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40154 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbXLHRtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:49:01 -0500
Date: Sat, 8 Dec 2007 09:47:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
 [2.6.24-rc4-git5: Reported regressions from 2.6.23]
In-Reply-To: <20071208163749.GI19691@waste.org>
Message-ID: <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Dec 2007, Matt Mackall wrote:
> 
> Avoid calling page allocator with __GFP_ZERO, as we might be in atomic
> context and this will make thing unhappy on highmem systems. Instead,
> manually zero allocations from the page allocator.

I think this is fine, but didn't we fix the warning already? Calling page 
allocators with __GFP_ZERO should be fine, as long as __GFP_HIGHMEM isn't 
set, and slab/slub/slob/kmalloc cannot use GFP_HIGHMEM *anyway*. 

But I'll apply it anyway, because it looks "obviously correct" from the 
standpoint that the _other_ slob user already clears the end result 
explicitly later on, and we simply should never pass down __GFP_ZERO to 
the actual page allocator.

On that note, shouldn't we also do this for slub.c? Christoph?

			Linus

---
 mm/slub.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b9f37cb..9c1d9f3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1468,6 +1468,9 @@ static void *__slab_alloc(struct kmem_cache *s,
 	void **object;
 	struct page *new;
 
+	/* We handle __GFP_ZERO in the caller */
+	gfpflags &= ~__GFP_ZERO;
+
 	if (!c->page)
 		goto new_slab;
 
