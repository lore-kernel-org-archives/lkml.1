Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZKJWGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZKJWGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbZKJWGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:06:45 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:56923 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbZKJWGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:06:44 -0500
X-Trace: 287471638/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.44.180/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.44.180
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkFANZy+UpPRSy0/2dsb2JhbACBTt0ohD4E
X-IronPort-AV: E=Sophos;i="4.44,718,1249254000"; 
   d="scan'208";a="287471638"
Date: Tue, 10 Nov 2009 22:06:49 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 6/6] mm: sigbus instead of abusing oom
In-Reply-To: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
Message-ID: <Pine.LNX.4.64.0911102202500.2816@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do_nonlinear_fault() realizes that the page table must have been
corrupted for it to have been called, it does print_bad_pte() and
returns ... VM_FAULT_OOM, which is hard to understand.

It made some sense when I did it for 2.6.15, when do_page_fault()
just killed the current process; but nowadays it lets the OOM killer
decide who to kill - so page table corruption in one process would
be liable to kill another.

Change it to return VM_FAULT_SIGBUS instead: that doesn't guarantee
that the process will be killed, but is good enough for such a rare
abnormality, accompanied as it is by the "BUG: Bad page map" message.

And recent HWPOISON work has copied that code into do_swap_page(),
when it finds an impossible swap entry: fix that to VM_FAULT_SIGBUS too.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
This one has nothing whatever to do with KSM swapping,
just something that KAMEZAWA-san and Minchan noticed recently.

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mm5/mm/memory.c	2009-11-02 12:32:34.000000000 +0000
+++ mm6/mm/memory.c	2009-11-07 14:44:58.000000000 +0000
@@ -2529,7 +2529,7 @@ static int do_swap_page(struct mm_struct
 			ret = VM_FAULT_HWPOISON;
 		} else {
 			print_bad_pte(vma, address, orig_pte, NULL);
-			ret = VM_FAULT_OOM;
+			ret = VM_FAULT_SIGBUS;
 		}
 		goto out;
 	}
@@ -2925,7 +2925,7 @@ static int do_nonlinear_fault(struct mm_
 		 * Page table corrupted: show pte and kill process.
 		 */
 		print_bad_pte(vma, address, orig_pte, NULL);
-		return VM_FAULT_OOM;
+		return VM_FAULT_SIGBUS;
 	}
 
 	pgoff = pte_to_pgoff(orig_pte);
