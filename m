Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbZGOUdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbZGOUdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932324AbZGOUdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:33:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24747 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbZGOUdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:33:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=krBxMP2kz9gxdIMrWcjp1ycKi81xKspPpYB+/kQ7n4z2WSI2W7iMRZ1Flp8wrY7/+
	IYrevGjZgL4ZWtZnc9DpA==
Date: Wed, 15 Jul 2009 13:33:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: [patch] mm: update alloc_flags after oom killer has been called
Message-ID: <alpine.DEB.2.00.0907151332320.24006@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for the oom killer to select current as the task to kill.  
When this happens, alloc_flags needs to be updated accordingly to set 
ALLOC_NO_WATERMARKS so the subsequent allocation attempt may use memory 
reserves as the result of its thread having TIF_MEMDIE set if the 
allocation is not __GFP_NOMEMALLOC.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1756,6 +1756,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	wake_all_kswapd(order, zonelist, high_zoneidx);
 
+restart:
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
 	 * reclaim. Now things get more complex, so set up alloc_flags according
@@ -1763,7 +1764,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
-restart:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
