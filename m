Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbXLHRz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbXLHRz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbXLHRzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:55:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36123 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbXLHRzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:55:14 -0500
Date: Sat, 8 Dec 2007 09:54:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
 [2.6.24-rc4-git5: Reported regressions from 2.6.23]
In-Reply-To: <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Dec 2007, Linus Torvalds wrote:
> 
> But I'll apply it anyway, because it looks "obviously correct" from the 
> standpoint that the _other_ slob user already clears the end result 
> explicitly later on, and we simply should never pass down __GFP_ZERO to 
> the actual page allocator.

Actually, I take that back. The other slob users are different. They share 
pages, this codepath does not.

So I think a more proper solution would be:
 (a) Something like this patch (which includes my previous mm/slub.c 
     change)
 (b) don't warn about atomic GFP_ZERO's - unless they have GFP_HIGHMEM set 
     *too*.

So which warning is it that triggers the bogus error?

		Linus
---
 mm/slob.c |    2 +-
 mm/slub.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index ee2ef8a..773a7aa 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -330,7 +330,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
 
 	/* Not enough space: must allocate a new page */
 	if (!b) {
-		b = slob_new_page(gfp, 0, node);
+		b = slob_new_page(gfp & ~__GFP_ZERO, 0, node);
 		if (!b)
 			return 0;
 		sp = (struct slob_page *)virt_to_page(b);
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
 
