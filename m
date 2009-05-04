Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZEDKLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZEDKLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZEDKL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:11:26 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:34701 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZEDKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=to5fF8FWl4IzY0gLyXCt01lC71XvRpeBozlIFO3EdnCJFA6gNZpjjeTmYt3gVdz3Vt
         xn0vOk61zNOLHghY5min3e4V6BgQvR/B5ihqLI7T6kUgYoOSluL3OZUKpdAgu4vnHPWQ
         OP4qLkIsrzznjilzDynFpCwRz//zN0E7RgqA8=
Date: Mon, 4 May 2009 14:11:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: introducing __GFP_PANIC
Message-ID: <20090504101121.GE4173@lenovo>
References: <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com> <20090503172338.GG4615@lenovo> <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com> <20090503204542.GJ4615@lenovo> <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com> <20090504081454.GA4173@lenovo> <1241425941.21088.19.camel@penberg-laptop> <20090504090825.GC4173@lenovo> <1241431031.21088.21.camel@penberg-laptop> <20090504100106.GD4173@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504100106.GD4173@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, May 04, 2009 at 02:01:06PM +0400]
| [Pekka Enberg - Mon, May 04, 2009 at 12:57:11PM +0300]
| | On Mon, 2009-05-04 at 13:08 +0400, Cyrill Gorcunov wrote:
| | > Index: linux-2.6.git/mm/oom_kill.c
| | > =====================================================================
| | > --- linux-2.6.git.orig/mm/oom_kill.c
| | > +++ linux-2.6.git/mm/oom_kill.c
| | > @@ -422,6 +422,16 @@ static int oom_kill_process(struct task_
| | >  	return oom_kill_task(p);
| | >  }
| | >  
| | > +void oom_panic(gfp_t gfp_mask, unsigned int order)
| | > +{
| | > +	if (likely(!(gfp_mask & __GFP_PANIC)))
| | > +		return;
| | > +
| | > +	panic("Out of memory: panic due to __GFP_PANIC.\n"
| | > +		"%s order:%d, mode:0x%x\n", current->comm,
| | > +		order, gfp_mask);
| | > +}
| | 
| | I think this just makes things harder to follow. It has one call-site so
| | why not inline this there?
| | 
| 
| Indeed, will fix shortly, thanks.
| 
| 	-- Cyrill

I believe this version should be correct (still RFC).
__GFP_NOWARN has printk limit so instead of making
additional checks (while combining those prink in
original code) just adding panic with order and flags
should be cleaner (as it done at moment :)

	-- Cyrill
---
 include/linux/gfp.h |    4 +++-
 mm/failslab.c       |    3 +++
 mm/page_alloc.c     |   11 +++++++++--
 3 files changed, 15 insertions(+), 3 deletions(-)

Index: linux-2.6.git/include/linux/gfp.h
=====================================================================
--- linux-2.6.git.orig/include/linux/gfp.h
+++ linux-2.6.git/include/linux/gfp.h
@@ -58,7 +58,9 @@ struct vm_area_struct;
 #define __GFP_NOTRACK	((__force gfp_t)0)
 #endif
 
-#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
+#define __GFP_PANIC	((__force gfp_t)0x400000u) /* Panic on page alloction failure */
+
+#define __GFP_BITS_SHIFT 23	/* Room for 23 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
Index: linux-2.6.git/mm/failslab.c
=====================================================================
--- linux-2.6.git.orig/mm/failslab.c
+++ linux-2.6.git/mm/failslab.c
@@ -17,6 +17,9 @@ bool should_failslab(size_t size, gfp_t 
 	if (gfpflags & __GFP_NOFAIL)
 		return false;
 
+	if (gfpflags & __GFP_PANIC)
+		return false;
+
         if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
 		return false;
 
Index: linux-2.6.git/mm/page_alloc.c
=====================================================================
--- linux-2.6.git.orig/mm/page_alloc.c
+++ linux-2.6.git/mm/page_alloc.c
@@ -1185,6 +1185,8 @@ static int should_fail_alloc_page(gfp_t 
 		return 0;
 	if (gfp_mask & __GFP_NOFAIL)
 		return 0;
+	if (gfp_mask & __GFP_PANIC)
+		return 0;
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
 		return 0;
 	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_WAIT))
@@ -1506,7 +1508,7 @@ restart:
 		 * Happens if we have an empty zonelist as a result of
 		 * GFP_THISNODE being used on a memoryless node
 		 */
-		return NULL;
+		goto nopage;
 	}
 
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
@@ -1685,7 +1687,12 @@ nopage:
 		dump_stack();
 		show_mem();
 	}
-	return page;
+	if (unlikely((gfp_mask & __GFP_PANIC))) {
+		panic("Out of memory: panic due to __GFP_PANIC.\n"
+			"%s order:%d, mode:0x%x\n", p->comm,
+			order, gfp_mask);
+	}
+	return NULL;
 got_pg:
 	if (kmemcheck_enabled)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
