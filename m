Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbZDVUMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbZDVUMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZDVULw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:11:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36982 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbZDVULu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:11:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Ke8/3GmFYHMNhPNqj+mfUzBy2XTOmuCAMs9//sHIojy7qQ/laGJLEy8O1qvwjUXNg
	XYAtNhi5onCqex+/KCXSA==
Date: Wed, 22 Apr 2009 13:11:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/22] Do not sanity check order in the fast path
In-Reply-To: <20090422171151.GF15367@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0904221244030.14558@chino.kir.corp.google.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-3-git-send-email-mel@csn.ul.ie> <1240416791.10627.78.camel@nimitz> <20090422171151.GF15367@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, Mel Gorman wrote:

> If there are users with good reasons, then we could convert this to WARN_ON
> to fix up the callers. I suspect that the allocator can already cope with
> recieving a stupid order silently but slowly. It should go all the way to the
> bottom and just never find anything useful and return NULL.  zone_watermark_ok
> is the most dangerous looking part but even it should never get to MAX_ORDER
> because it should always find there are not enough free pages and return
> before it overruns.
> 

slub: enforce MAX_ORDER

slub_max_order may not be equal to or greater than MAX_ORDER.

Additionally, if a single object cannot be placed in a slab of
slub_max_order, it still must allocate slabs below MAX_ORDER.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1909,7 +1909,7 @@ static inline int calculate_order(int size)
 	 * Doh this slab cannot be placed using slub_max_order.
 	 */
 	order = slab_order(size, 1, MAX_ORDER, 1);
-	if (order <= MAX_ORDER)
+	if (order < MAX_ORDER)
 		return order;
 	return -ENOSYS;
 }
@@ -2522,6 +2522,7 @@ __setup("slub_min_order=", setup_slub_min_order);
 static int __init setup_slub_max_order(char *str)
 {
 	get_option(&str, &slub_max_order);
+	slub_max_order = min(slub_max_order, MAX_ORDER - 1);
 
 	return 1;
 }
