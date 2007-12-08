Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbXLHQiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbXLHQiu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 11:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbXLHQim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 11:38:42 -0500
Received: from waste.org ([66.93.16.53]:41287 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbXLHQil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 11:38:41 -0500
Date: Sat, 8 Dec 2007 10:37:49 -0600
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52, [2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071208163749.GI19691@waste.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208093039.GA28054@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 10:30:39AM +0100, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Subject		: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> > Submitter	: Ingo Molnar <mingo@elte.hu>
> > References	: http://lkml.org/lkml/2007/11/29/157
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9497
> > Handled-By	: Matt Mackall <mpm@selenic.com>
> > Patch		: http://lkml.org/lkml/2007/11/29/387
> 
> Matt, the above bug is still occuring en masse during random bootups:
> 

I was hoping for some discussion about whether it was the best fix.
The current kzalloc thing strikes me as a step backwards for all
allocators. We'd do better to have a single non-inline kzalloc
function rather than an extra branch in the normal kmalloc fast path.

But here's the patch again, with my sign-off:


Avoid calling page allocator with __GFP_ZERO, as we might be in atomic
context and this will make thing unhappy on highmem systems. Instead,
manually zero allocations from the page allocator.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r f7edf7226317 mm/slob.c
--- a/mm/slob.c	Wed Dec 05 15:57:06 2007 -0600
+++ b/mm/slob.c	Wed Dec 05 15:57:51 2007 -0600
@@ -223,6 +231,7 @@ static void *slob_new_page(gfp_t gfp, in
 {
 	void *page;
 
+	gfp &= ~__GFP_ZERO;
 #ifdef CONFIG_NUMA
 	if (node != -1)
 		page = alloc_pages_node(node, gfp, order);
@@ -457,6 +470,8 @@ void *__kmalloc_node(size_t size, gfp_t 
 			page = virt_to_page(ret);
 			page->private = size;
 		}
+		if (unlikely((gfp & __GFP_ZERO) && ret))
+			memset(ret, 0, size);
 		return ret;
 	}
 }


-- 
Mathematics is the supreme nostalgia of our time.
