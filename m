Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZHSX5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZHSX5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZHSX5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:57:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:65426 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZHSX5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=H5pAHx3JOiqyZcOVTk2xSJYA1pWI06BqD6SPqsCr30n62w8pWJovAvdhz0ue/qzncb
         waLdSU/+RBWp+fJKxtXgqzigN4RbmyGzYdNyFY0BcaIJpeq8yfCNJHlj6N/6Y/pIhmTf
         EyCDOyL1OGuzRGOsssNuPIFIbb/SAz3V7n1G4=
Date: Thu, 20 Aug 2009 08:55:44 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: [PATCH] mm: Fix to infinite churning of mlocked page
Message-Id: <20090820085544.faed1ca4.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mlocked page might lost the isolatation race.
It cause the page to clear PG_mlocked while it remains
in VM_LOCKED vma. It means it can be put [in]active list.
We can rescue it by try_to_unmap in shrink_page_list.

But now, As Wu Fengguang pointed out, vmscan have a bug.
If the page has PG_referenced, it can't reach try_to_unmap
in shrink_page_list but put into active list. If the page
is referenced repeatedly, it can remain [in]active list
without moving unevictable list.

This patch can fix it.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <<kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/rmap.c   |    1 +
 mm/vmscan.c |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 7d6fe4e..28aafe2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -363,6 +363,7 @@ static int page_referenced_one(struct page *page,
 	 */
 	if (vma->vm_flags & VM_LOCKED) {
 		*mapcount = 1;	/* break early from loop */
+		*vm_flags |= VM_LOCKED;
 		goto out_unmap;
 	}

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 00596b9..70a63c4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -630,9 +630,14 @@ static unsigned long shrink_page_list(struct list_head *page_list,

 		referenced = page_referenced(page, 1,
 						sc->mem_cgroup, &vm_flags);
-		/* In active use or really unfreeable?  Activate it. */
+		/*
+		 * In active use or really unfreeable?  Activate it.
+		 * If page which have PG_mlocked lost isoltation race,
+		 * try_to_unmap moves it to unevictable list
+		 */
 		if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
-					referenced && page_mapping_inuse(page))
+					referenced && page_mapping_inuse(page)
+					&& !(vm_flags & VM_LOCKED))
 			goto activate_locked;

 		/*
--
1.5.4.3


-- 
Kind regards,
Minchan Kim
