Return-Path: <linux-kernel-owner+w=401wt.eu-S934395AbZGQKaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395AbZGQKaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 06:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934383AbZGQKaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 06:30:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9889 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934323AbZGQKaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 06:30:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=bHR+XaCeIo2NQCI2FGqXncmYgnCeK13Po4+EbPi5fIsIixlBrmPfFzMUKh1LHCTZJ
	j6gQgPmQ2IVFrXoHPI57Q==
Date: Fri, 17 Jul 2009 03:29:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] page-allocator: Ensure that processes that have been
 OOM killed exit the page allocator (resend)
In-Reply-To: <20090717092157.GA9835@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0907170326400.18608@chino.kir.corp.google.com>
References: <20090715104944.GC9267@csn.ul.ie> <alpine.DEB.2.00.0907151326350.22582@chino.kir.corp.google.com> <20090716110328.GB22499@csn.ul.ie> <alpine.DEB.2.00.0907161202500.27201@chino.kir.corp.google.com> <20090717092157.GA9835@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Mel Gorman wrote:

> Ok, lets go with this patch then. Thanks
> 

Ok, thanks, I'll add that as your acked-by and I'll write a formal patch 
description for it.


mm: avoid endless looping for oom killed tasks

If a task is oom killed and still cannot find memory when trying with no 
watermarks, it's better to fail the allocation attempt than to loop 
endlessly.  Direct reclaim has already failed and the oom killer will be a 
no-op since current has yet to die, so there is no other alternative for 
allocations that are not __GFP_NOFAIL.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
---
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
