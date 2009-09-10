Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZIJDBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZIJDBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 23:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbZIJDA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 23:00:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46375 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZIJDA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 23:00:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Sep 2009 11:58:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH][mmotm][BUGFIX] kcore use registered physmem information
 ia64-fix (Was Re: mmotm 2009-09-03-16-35 uploaded
Message-Id: <20090910115859.c2291eb8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090910103850.9CCF.A69D9226@jp.fujitsu.com>
References: <20090909101446.4cf3f373.kamezawa.hiroyu@jp.fujitsu.com>
	<20090909103102.d71fee00.kamezawa.hiroyu@jp.fujitsu.com>
	<20090910103850.9CCF.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 10:39:28 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > > This release doesn't boot on my ia64 test box.
> > > > After following two patches reverted, booting was successful.
> > > > 
> > > > 	page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch 
> > > > 	Kamezawa-san's kcore patch series
> > > > 
> > > > 
> > > > Mel, Kamezawa-san, Can you please gime me any advise?
> > > 
> > > Kosaki-san, could you give me your .config ?
> > > 
> > Hmm, how about this ?
> 
> Still don't boot.
> 

Ok, I confirmed this one fixes the issue.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
kcore-use-registerd-physmem-information.patch registers physmem information
based on ioresource. Then, this addition is unnecessary.

Why panic:
  At boot, rebuilding kclist for physmem, all KCORE_RAM entries are kfreed.
  Because this ramaining one entires kclist of KCORE_RAM in kernel data area
  to ther list, this causes panic in kclist rebuilding which calls kfree().

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 arch/ia64/mm/init.c |    3 ---
 1 file changed, 3 deletions(-)

Index: mmotm-2.6.31-Sep3/arch/ia64/mm/init.c
===================================================================
--- mmotm-2.6.31-Sep3.orig/arch/ia64/mm/init.c
+++ mmotm-2.6.31-Sep3/arch/ia64/mm/init.c
@@ -617,7 +617,6 @@ mem_init (void)
 	long reserved_pages, codesize, datasize, initsize;
 	pg_data_t *pgdat;
 	int i;
-	static struct kcore_list kcore_mem;
 
 	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
 	BUG_ON(PTRS_PER_PMD * sizeof(pmd_t) != PAGE_SIZE);
@@ -639,8 +638,6 @@ mem_init (void)
 
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
-
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)
 			totalram_pages += free_all_bootmem_node(pgdat);

