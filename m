Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbZGOLXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbZGOLXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZGOLXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:23:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57318 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZGOLXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:23:18 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Heinz Diehl <htd@fancy-poultry.org>, David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/3] profile: Suppress warning about large allocations when profile=1 is specified
Date: Wed, 15 Jul 2009 12:23:11 +0100
Message-Id: <1247656992-19846-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1247656992-19846-1-git-send-email-mel@csn.ul.ie>
References: <1247656992-19846-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When profile= is used, a large buffer is allocated early at boot. This
can be larger than what the page allocator can provide so it prints a
warning. However, the caller is able to handle the situation so this patch
suppresses the warning.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 kernel/profile.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 69911b5..419250e 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -117,11 +117,12 @@ int __ref profile_init(void)
 
 	cpumask_copy(prof_cpu_mask, cpu_possible_mask);
 
-	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
+	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL|__GFP_NOWARN);
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
+	prof_buffer = alloc_pages_exact(buffer_bytes,
+					GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
 	if (prof_buffer)
 		return 0;
 
-- 
1.5.6.5

