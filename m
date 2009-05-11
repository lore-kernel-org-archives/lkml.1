Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbZEKWv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbZEKWv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759889AbZEKWvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:51:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759595AbZEKWvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:51:45 -0400
Date: Mon, 11 May 2009 15:46:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: gregkh@suse.de, npiggin@suse.de, mel@csn.ul.ie, a.p.zijlstra@chello.nl,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com, san@android.com,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
Message-Id: <20090511154603.0fb0acbf.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905111529090.2234@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com>
	<20090511142936.dd68005b.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0905111444070.466@chino.kir.corp.google.com>
	<20090511151130.9a949cb7.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0905111529090.2234@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 15:31:04 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 11 May 2009, Andrew Morton wrote:
> 
> > __GFP_NOFAIL is a bad fiction.  Allocations _can_ fail, and callers should
> > detect and suitably handle this (and not by lamely moving the infinite
> > loop up to the caller level either).
> > 
> > Attempting to use __GFP_NOFAIL for a higher-order allocation is even
> > worse, so add a once-off runtime check for this to slap people around for
> > even thinking about trying it.
> > 
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Mel Gorman <mel@csn.ul.ie>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> This only emits a warning when you have CONFIG_DEBUG_KERNEL, 
> CONFIG_FAULT_INJECTION, and CONFIG_FAIL_PAGE_ALLOC, which is all related 
> to fault injection (since we never want to inject a fault into anything 
> using __GFP_NOFAIL).  So it may be helpful in tracking down such callers, 
> but is unrelated to the config options that enable it and it may not get 
> the best coverage.

oh, well that was pretty useless then.  I was trying to find a handy
spot where we can avoid adding fastpath cycles.

How about we sneak it into the order>0 leg inside buffered_rmqueue()?


--- a/mm/page_alloc.c~page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation
+++ a/mm/page_alloc.c
@@ -1130,6 +1130,20 @@ again:
 		list_del(&page->lru);
 		pcp->count--;
 	} else {
+		if (unlikely(gfp_mask & __GFP_NOFAIL)) {
+			/*
+			 * __GFP_NOFAIL is not to be used in new code.
+			 *
+			 * All __GFP_NOFAIL callers should be fixed so that they
+			 * properly detect and handle allocation failures.
+			 *
+			 * We most definitely don't want callers attempting to
+			 * allocate greater than single-page units with
+			 * __GFP_NOFAIL.
+			 */
+			WARN_ON_ONCE(order > 0);
+			return 0;
+		}
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
 		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
_

