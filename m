Return-Path: <linux-kernel-owner+w=401wt.eu-S1763062AbXHKTBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763062AbXHKTBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760013AbXHKS6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:17 -0400
Received: from 1wt.eu ([62.212.114.60]:1521 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762313AbXHKS6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:12 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184838.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:01 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Bob Picco <bob.picco@hp.com>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 09/28] sparsemem: fix oops in x86_64 show_mem
Content-Disposition: inline; filename=0009-sparsemem-fix-oops-in-x86_64-show_mem.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We aren't sampling for holes in memory. Thus we encounter a section hole with
empty section map pointer for SPARSEMEM and OOPs for show_mem. This issue
has been seen in 2.6.21, current git and current mm. This patch is for
2.6.21 stable. It was tested against sparsemem.

Previous to commit f0a5a58aa812b31fd9f197c4ba48245942364eae memory_present
was called for node_start_pfn to node_end_pfn. This would cover the hole(s)
with reserved pages and valid sections. Most SPARSEMEM supported arches
do a pfn_valid check in show_mem before computing the page structure address.

This issue was brought to my attention on IRC by Arnaldo Carvalho de Melo at
acme@redhat.com. Thanks to Arnaldo for testing.

Signed-off-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86_64/mm/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index 2489aa7..e67cc4f 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -72,6 +72,8 @@ void show_mem(void)
 
 	for_each_online_pgdat(pgdat) {
                for (i = 0; i < pgdat->node_spanned_pages; ++i) {
+			if (!pfn_valid(pgdat->node_start_pfn + i))
+				continue;
 			page = pfn_to_page(pgdat->node_start_pfn + i);
 			total++;
 			if (PageReserved(page))
-- 
1.5.2.4

-- 
