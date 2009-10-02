Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZJBJa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZJBJa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbZJBJa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:30:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:29728 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbZJBJaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:30:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=L2Z2K1nTyUUjeqiOAHqAl6QIqvkikM48JCaM1suVs0UeurArFbS3MUiQcpJ0kDLDe
	xwe9JxV/fyRimHHlcz7PA==
Date: Fri, 2 Oct 2009 02:30:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Neil Brown <neilb@suse.de>
cc: Suresh Jayaraman <sjayaraman@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 03/31] mm: expose gfp_to_alloc_flags()
In-Reply-To: <19141.35274.513790.845711@notabene.brown>
Message-ID: <alpine.DEB.1.00.0910020217400.21163@chino.kir.corp.google.com>
References: <1254405903-15760-1-git-send-email-sjayaraman@suse.de> <alpine.DEB.1.00.0910011355230.32006@chino.kir.corp.google.com> <19141.35274.513790.845711@notabene.brown>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Neil Brown wrote:

> So something like this?
> Then change every occurrence of
> +		if (!(gfp_to_alloc_flags(gfpflags) & ALLOC_NO_WATERMARKS))
> to
> +		if (!(gfp_has_no_watermarks(gfpflags)))
> 
> ??
> 

No, it's not even necessary to call gfp_to_alloc_flags() at all, just 
create a globally exported function such as can_alloc_use_reserves() and 
use it in gfp_to_alloc_flags().

 [ Using 'p' in gfp_to_alloc_flags() is actually wrong since
   test_thread_flag() only works on current anyway, so it would be
   inconsistent if p were set to anything other than current; we can
   get rid of that auto variable. ]

Something like the following, which you can fold into this patch proposal 
and modify later for GFP_MEMALLOC.

Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 557bdad..7dd62a0 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -265,6 +265,8 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
+int can_alloc_use_reserves(void);
+
 struct page *
 __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 		       struct zonelist *zonelist, nodemask_t *nodemask);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bf72055..cf1d765 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1744,10 +1744,19 @@ void wake_all_kswapd(unsigned int order, struct zonelist *zonelist,
 		wakeup_kswapd(zone, order);
 }
 
+/*
+ * Does the current context allow the allocation to utilize memory reserves
+ * by ignoring watermarks for all zones?
+ */
+int can_alloc_use_reserves(void)
+{
+	return !in_interrupt() && ((current->flags & PF_MEMALLOC) ||
+				   unlikely(test_thread_flag(TIF_MEMDIE)));
+}
+
 static inline int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
-	struct task_struct *p = current;
 	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 
@@ -1769,15 +1778,12 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
-	} else if (unlikely(rt_task(p)))
+	} else if (unlikely(rt_task(current)))
 		alloc_flags |= ALLOC_HARDER;
 
-	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
-		if (!in_interrupt() &&
-		    ((p->flags & PF_MEMALLOC) ||
-		     unlikely(test_thread_flag(TIF_MEMDIE))))
+	if (likely(!(gfp_mask & __GFP_NOMEMALLOC)))
+		if (can_alloc_use_reserves())
 			alloc_flags |= ALLOC_NO_WATERMARKS;
-	}
 
 	return alloc_flags;
 }
