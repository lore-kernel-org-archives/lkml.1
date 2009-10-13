Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbZJMODL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbZJMODL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZJMODK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:03:10 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:60044 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbZJMODJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:03:09 -0400
X-Trace: 273778390/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.12.149/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.12.149
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHMl1EpQKQyV/2dsb2JhbACBUY4nAcgthC0E
X-IronPort-AV: E=Sophos;i="4.44,551,1249254000"; 
   d="scan'208";a="273778390"
Date: Tue, 13 Oct 2009 15:02:11 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Wu Fengguang <fengguang.wu@intel.com>, Izik Eidus <ieidus@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] hwpoison: fix oops on ksm pages
Message-ID: <Pine.LNX.4.64.0910131451280.4698@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory failure on a KSM page currently oopses on its NULL anon_vma in
page_lock_anon_vma(): that may not be much worse than the consequence
of ignoring it, but it is better to be consistent with how ZERO_PAGE
and hugetlb pages and other awkward cases are treated.  Just skip it.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
We could fix it for 2.6.32 at the KSM end, by putting a dummy anon_vma
pointer in there; but that would get harder next time, when KSM will
put a pointer to something else there (and I'm not currently planning
to do any work to open that up to memory_failure).  So I would prefer
this simple PageKsm test, until the other exceptions are handled.

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 2.6.32-rc4/mm/memory-failure.c	2009-09-28 00:28:41.000000000 +0100
+++ linux/mm/memory-failure.c	2009-10-13 14:09:12.000000000 +0100
@@ -35,6 +35,7 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/sched.h>
+#include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
@@ -661,7 +662,7 @@ static void hwpoison_user_mappings(struc
 	int i;
 	int kill = 1;
 
-	if (PageReserved(p) || PageCompound(p) || PageSlab(p))
+	if (PageReserved(p) || PageCompound(p) || PageSlab(p) || PageKsm(p))
 		return;
 
 	if (!PageLRU(p))
