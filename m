Return-Path: <linux-kernel-owner+w=401wt.eu-S1759664AbZD2VLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664AbZD2VLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZD2VLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:11:10 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54990 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbZD2VLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:11:09 -0400
Date: Wed, 29 Apr 2009 22:09:48 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH mmotm] mm: alloc_large_system_hash check order
Message-ID: <Pine.LNX.4.64.0904292151350.30874@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an x86_64 with 4GB ram, tcp_init()'s call to alloc_large_system_hash(),
to allocate tcp_hashinfo.ehash, is now triggering an mmotm WARN_ON_ONCE on
order >= MAX_ORDER - it's hoping for order 11.  alloc_large_system_hash()
had better make its own check on the order.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Should probably follow
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch

Cc'ed DaveM and netdev, just in case they're surprised it was asking for
so much, or disappointed it's not getting as much as it was asking for.

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- 2.6.30-rc3-mm1/mm/page_alloc.c	2009-04-29 21:01:08.000000000 +0100
+++ mmotm/mm/page_alloc.c	2009-04-29 21:12:04.000000000 +0100
@@ -4765,7 +4765,10 @@ void *__init alloc_large_system_hash(con
 			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
 		else {
 			unsigned long order = get_order(size);
-			table = (void*) __get_free_pages(GFP_ATOMIC, order);
+
+			if (order < MAX_ORDER)
+				table = (void *)__get_free_pages(GFP_ATOMIC,
+								order);
 			/*
 			 * If bucketsize is not a power-of-two, we may free
 			 * some pages at the end of hash table.
