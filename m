Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZFVPnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZFVPnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196AbZFVPni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:43:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35180 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758168AbZFVPng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:43:36 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Heinz Diehl <htd@fancy-poultry.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/3] profile: Suppress warning about large allocations when profile=1 is specified
Date: Mon, 22 Jun 2009 16:43:33 +0100
Message-Id: <1245685414-8979-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245685414-8979-1-git-send-email-mel@csn.ul.ie>
References: <1245685414-8979-1-git-send-email-mel@csn.ul.ie>
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

