Return-Path: <linux-kernel-owner+w=401wt.eu-S932342AbZGOVAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbZGOVAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932323AbZGOVAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:00:01 -0400
Received: from smtp-out.google.com ([216.239.45.13]:29881 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbZGOVAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:00:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FUlvjKCjWSc/WFld/gXGQijunuD+vz4x25xI7960tLoruL4kd5KlLM1ONr81mNn4S
	oC2WuUlbb02Dzo/pKIJjQ==
Date: Wed, 15 Jul 2009 13:59:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] page-allocator: Ensure that processes that have been
 OOM killed exit the page allocator (resend)
In-Reply-To: <alpine.DEB.2.00.0907151326350.22582@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0907151358400.25459@chino.kir.corp.google.com>
References: <20090715104944.GC9267@csn.ul.ie> <alpine.DEB.2.00.0907151326350.22582@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, David Rientjes wrote:

> This only works for GFP_ATOMIC since the next iteration of the page 
> allocator will (probably) fail reclaim and simply invoke the oom killer 
> again, which will notice current has TIF_MEMDIE set and choose to do 
> nothing, at which time the allocator simply loops again.
> 

In other words, I'd propose this as an alternative patch.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1789,6 +1789,10 @@ rebalance:
 	if (p->flags & PF_MEMALLOC)
 		goto nopage;
 
+	/* Avoid allocations with no watermarks from looping endlessly */
+	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
+		goto nopage;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
