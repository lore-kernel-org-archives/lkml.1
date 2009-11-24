Return-Path: <linux-kernel-owner+w=401wt.eu-S933526AbZKXQva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526AbZKXQva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933483AbZKXQv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:51:29 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:48626 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932116AbZKXQv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:51:29 -0500
X-Trace: 292688524/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBAMKdC0tPRTgw/2dsb2JhbAAI1haEOQSBcA
X-IronPort-AV: E=Sophos;i="4.47,280,1257120000"; 
   d="scan'208";a="292688524"
Date: Tue, 24 Nov 2009 16:51:13 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 6/9] ksm: mem cgroup charge swapin copy
In-Reply-To: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
Message-ID: <Pine.LNX.4.64.0911241648520.25288@sister.anvils>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But ksm swapping does require one small change in mem cgroup handling.
When do_swap_page()'s call to ksm_might_need_to_copy() does indeed
substitute a duplicate page to accommodate a different anon_vma (or a
different index), that page escaped mem cgroup accounting, because of
the !PageSwapCache check in mem_cgroup_try_charge_swapin().

That was returning success without charging, on the assumption that
pte_same() would fail after, which is not the case here.  Originally I
proposed that success, so that an unshrinkable mem cgroup at its limit
would not fail unnecessarily; but that's a minor point, and there are
plenty of other places where we may fail an overallocation which might
later prove unnecessary.  So just go ahead and do what all the other
exceptions do: proceed to charge current mm.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- ksm5/mm/memcontrol.c	2009-11-14 10:17:02.000000000 +0000
+++ ksm6/mm/memcontrol.c	2009-11-22 20:40:37.000000000 +0000
@@ -1862,11 +1862,12 @@ int mem_cgroup_try_charge_swapin(struct
 		goto charge_cur_mm;
 	/*
 	 * A racing thread's fault, or swapoff, may have already updated
-	 * the pte, and even removed page from swap cache: return success
-	 * to go on to do_swap_page()'s pte_same() test, which should fail.
+	 * the pte, and even removed page from swap cache: in those cases
+	 * do_swap_page()'s pte_same() test will fail; but there's also a
+	 * KSM case which does need to charge the page.
 	 */
 	if (!PageSwapCache(page))
-		return 0;
+		goto charge_cur_mm;
 	mem = try_get_mem_cgroup_from_swapcache(page);
 	if (!mem)
 		goto charge_cur_mm;
