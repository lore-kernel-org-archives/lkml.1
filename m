Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYHUCmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYHUCmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYHUCmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:42:43 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34306 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752896AbYHUCmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:42:43 -0400
Date: Wed, 20 Aug 2008 21:42:40 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com, stable@kernel.org
Subject: Re: [RFC][PATCH 0/2] Quicklist is slighly problematic.
Message-ID: <20080821024240.GC23397@sgi.com>
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080820113131.f032c8a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820113131.f032c8a2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, that's a fatal bug and it's present in 2.6.25.x and 2.6.26.x.  A
> serious issue.
> 
> The patches do apply to both stable kernels and I have tagged them for
> backporting into them.  They're nice and small, but I didn't get a
> really solid yes-this-is-what-we-should-do from Christoph?
> 
> 
> This (from [patch 2/2]): "(Although its patch applied, quicklist can
> waste 64GB on 1TB server (= 1TB / 16), it is still too much??)" is a
> bit of a worry.  Yes, 64GB is too much!  But at least this is now only
> a performance issue rather than a stability issue, yes?

That 64GB is not quite correct.  That assumes all 1TB is free.  The
quicklists are trimmed down as the nodes undergo allocations.  The
problem I see right now is that page tables allocated on one node and
freed on a cpu on a different node could be placed early enough on the
quicklist that it will not be freed until the other node gets under
memory pressure.

Could you give the following a try?  It hasn't even been compiled.  I
think this in addition to your cpus per node change are the right thing
to do.

Thanks,
Robin

Index: ia64-cleanups/include/linux/quicklist.h
===================================================================
--- ia64-cleanups.orig/include/linux/quicklist.h	2008-08-20 21:35:10.000000000 -0500
+++ ia64-cleanups/include/linux/quicklist.h	2008-08-20 21:38:00.891943270 -0500
@@ -66,6 +66,15 @@ static inline void __quicklist_free(int 
 
 static inline void quicklist_free(int nr, void (*dtor)(void *), void *pp)
 {
+#ifdef CONFIG_NUMA
+	unsigned long nid = page_to_nid(virt_to_page(pp));
+
+	if (unlikely(nid != numa_node_id())) {
+		free_page((unsigned long)pp);
+		return;
+	}
+#endif
+
 	__quicklist_free(nr, dtor, pp, virt_to_page(pp));
 }
 
