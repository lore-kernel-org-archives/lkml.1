Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZKMIQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZKMIQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZKMIQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:16:32 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51022 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZKMIQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:16:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 2/6] mm: mlocking in try_to_unmap_one
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0911111048170.12126@sister.anvils>
References: <20091111102400.FD36.A69D9226@jp.fujitsu.com> <Pine.LNX.4.64.0911111048170.12126@sister.anvils>
Message-Id: <20091113143930.33BF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 13 Nov 2009 17:16:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 11 Nov 2009, KOSAKI Motohiro wrote:
> 
> Though it doesn't quite answer your question,
> I'll just reinsert the last paragraph of my description here...
> 
> > > try_to_unmap_file()'s TTU_MUNLOCK nonlinear handling was particularly
> > > amusing: once unravelled, it turns out to have been choosing between
> > > two different ways of doing the same nothing.  Ah, no, one way was
> > > actually returning SWAP_FAIL when it meant to return SWAP_SUCCESS.
> 
> ... 
> > > @@ -1081,45 +1053,23 @@ static int try_to_unmap_file(struct page
> ...
> > >
> > > -	if (list_empty(&mapping->i_mmap_nonlinear))
> > > +	/* We don't bother to try to find the munlocked page in nonlinears */
> > > +	if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
> > >  		goto out;
> > 
> > I have dumb question.
> > Does this shortcut exiting code makes any behavior change?
> 
> Not dumb.  My intention was to make no behaviour change with any of
> this patch; but in checking back before completing the description,
> I suddenly realized that that shortcut intentionally avoids the
> 
> 	if (max_nl_size == 0) {	/* all nonlinears locked or reserved ? */
> 		ret = SWAP_FAIL;
> 		goto out;
> 	}
> 
> (which doesn't show up in the patch: you'll have to look at rmap.c),
> which used to have the effect of try_to_munlock() returning SWAP_FAIL
> in the case when there were one or more VM_NONLINEAR vmas of the file,
> but none of them (and none of the covering linear vmas) VM_LOCKED.
> 
> That should have been a SWAP_SUCCESS case, or with my changes
> another SWAP_AGAIN, either of which would make munlock_vma_page()
> 				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
> which would be correct; but the SWAP_FAIL meant that count was not
> incremented in this case.

Ah, correct.
Then, we lost the capability unevictability of non linear mapping pages, right.
if so, following additional patch makes more consistent?


> 
> Actually, I've double-fixed that, because I also changed
> munlock_vma_page() to increment the count whenever ret != SWAP_MLOCK;
> which seemed more appropriate, but would have been a no-op if
> try_to_munlock() only returned SWAP_SUCCESS or SWAP_AGAIN or SWAP_MLOCK
> as it claimed.
> 
> But I wasn't very inclined to boast of fixing that bug, since my testing
> didn't give confidence that those /proc/vmstat unevictable_pgs_*lock*
> counts are being properly maintained anyway - when I locked the same
> pages in two vmas then unlocked them in both, I ended up with mlocked
> bigger than munlocked (with or without my 2/6 patch); which I suspect
> is wrong, but rather off my present course towards KSM swapping...

Ah, vmstat inconsistent is weird. I'll try to debug it later.
Thanks this notice.


----------------------------------
>From 3fd3bc58dc6505af73ecf92c981609ecf8b6ac40 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 13 Nov 2009 16:52:03 +0900
Subject: [PATCH] [RFC] mm: non linear mapping page don't mark as PG_mlocked

Now, try_to_unmap_file() lost the capability to treat VM_NONLINEAR.
Then, mlock() shouldn't mark the page of non linear mapping as
PG_mlocked. Otherwise the page continue to drinker walk between
evictable and unevictable lru.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mlock.c |   37 +++++++++++++++++++++++--------------
 1 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 48691fb..4187f9c 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -266,25 +266,34 @@ long mlock_vma_pages_range(struct vm_area_struct *vma,
 	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 		goto no_mlock;
 
-	if (!((vma->vm_flags & (VM_DONTEXPAND | VM_RESERVED)) ||
+	if ((vma->vm_flags & (VM_DONTEXPAND | VM_RESERVED)) ||
 			is_vm_hugetlb_page(vma) ||
-			vma == get_gate_vma(current))) {
+			vma == get_gate_vma(current)) {
+
+		/*
+		 * User mapped kernel pages or huge pages:
+		 * make these pages present to populate the ptes, but
+		 * fall thru' to reset VM_LOCKED--no need to unlock, and
+		 * return nr_pages so these don't get counted against task's
+		 * locked limit.  huge pages are already counted against
+		 * locked vm limit.
+		 */
+		make_pages_present(start, end);
+		goto no_mlock;
+	}
 
+	if (vma->vm_flags & VM_NONLINEAR)
+		/*
+		 * try_to_munmap() doesn't treat VM_NONLINEAR. let's make
+		 * consist.
+		 */
+		make_pages_present(start, end);
+	else
 		__mlock_vma_pages_range(vma, start, end);
 
-		/* Hide errors from mmap() and other callers */
-		return 0;
-	}
+	/* Hide errors from mmap() and other callers */
+	return 0;
 
-	/*
-	 * User mapped kernel pages or huge pages:
-	 * make these pages present to populate the ptes, but
-	 * fall thru' to reset VM_LOCKED--no need to unlock, and
-	 * return nr_pages so these don't get counted against task's
-	 * locked limit.  huge pages are already counted against
-	 * locked vm limit.
-	 */
-	make_pages_present(start, end);
 
 no_mlock:
 	vma->vm_flags &= ~VM_LOCKED;	/* and don't come back! */
-- 
1.6.2.5



