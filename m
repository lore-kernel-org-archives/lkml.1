Return-Path: <linux-kernel-owner+w=401wt.eu-S936277AbZLQEHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936277AbZLQEHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936219AbZLQEFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:55 -0500
Received: from kroah.org ([198.145.64.141]:56070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936208AbZLQEFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:53 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:01 2009
Message-Id: <20091217035701.281685524@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [141/151] mm: sigbus instead of abusing oom
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

commit d99be1a8ecf377c2c9b3372d36411ad6547bbd4c upstream.

When do_nonlinear_fault() realizes that the page table must have been
corrupted for it to have been called, it does print_bad_pte() and returns
...  VM_FAULT_OOM, which is hard to understand.

It made some sense when I did it for 2.6.15, when do_page_fault() just
killed the current process; but nowadays it lets the OOM killer decide who
to kill - so page table corruption in one process would be liable to kill
another.

Change it to return VM_FAULT_SIGBUS instead: that doesn't guarantee that
the process will be killed, but is good enough for such a rare
abnormality, accompanied as it is by the "BUG: Bad page map" message.

And recent HWPOISON work has copied that code into do_swap_page(), when it
finds an impossible swap entry: fix that to VM_FAULT_SIGBUS too.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2514,7 +2514,7 @@ static int do_swap_page(struct mm_struct
 			ret = VM_FAULT_HWPOISON;
 		} else {
 			print_bad_pte(vma, address, orig_pte, NULL);
-			ret = VM_FAULT_OOM;
+			ret = VM_FAULT_SIGBUS;
 		}
 		goto out;
 	}
@@ -2910,7 +2910,7 @@ static int do_nonlinear_fault(struct mm_
 		 * Page table corrupted: show pte and kill process.
 		 */
 		print_bad_pte(vma, address, orig_pte, NULL);
-		return VM_FAULT_OOM;
+		return VM_FAULT_SIGBUS;
 	}
 
 	pgoff = pte_to_pgoff(orig_pte);


