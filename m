Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZGOLXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZGOLXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZGOLXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:23:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57326 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZGOLXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:23:18 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Heinz Diehl <htd@fancy-poultry.org>, David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/3] net-dccp: Suppress warning about large allocations from DCCP
Date: Wed, 15 Jul 2009 12:23:12 +0100
Message-Id: <1247656992-19846-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1247656992-19846-1-git-send-email-mel@csn.ul.ie>
References: <1247656992-19846-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DCCP protocol tries to allocate some large hash tables during
initialisation using the largest size possible.  This can be larger than
what the page allocator can provide so it prints a warning. However, the
caller is able to handle the situation so this patch suppresses the warning.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 net/dccp/proto.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 94ca8ea..3281013 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1066,7 +1066,7 @@ static int __init dccp_init(void)
 		       (dccp_hashinfo.ehash_size - 1))
 			dccp_hashinfo.ehash_size--;
 		dccp_hashinfo.ehash = (struct inet_ehash_bucket *)
-			__get_free_pages(GFP_ATOMIC, ehash_order);
+			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, ehash_order);
 	} while (!dccp_hashinfo.ehash && --ehash_order > 0);
 
 	if (!dccp_hashinfo.ehash) {
@@ -1091,7 +1091,7 @@ static int __init dccp_init(void)
 		    bhash_order > 0)
 			continue;
 		dccp_hashinfo.bhash = (struct inet_bind_hashbucket *)
-			__get_free_pages(GFP_ATOMIC, bhash_order);
+			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, bhash_order);
 	} while (!dccp_hashinfo.bhash && --bhash_order >= 0);
 
 	if (!dccp_hashinfo.bhash) {
-- 
1.5.6.5

