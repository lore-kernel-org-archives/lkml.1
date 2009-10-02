Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbZJBRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbZJBRYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbZJBRYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:24:52 -0400
Received: from kroah.org ([198.145.64.141]:34736 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619AbZJBRYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:24:51 -0400
Date: Fri, 2 Oct 2009 10:20:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@csn.ul.ie>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: [patch 32/30] mm: fix anonymous dirtying
Message-ID: <20091002172038.GA12576@kroah.com>
References: <20091001233504.GA17709@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001233504.GA17709@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

commit 1ac0cb5d0e22d5e483f56b2bc12172dec1cf7536 upstream.

do_anonymous_page() has been wrong to dirty the pte regardless.
If it's not going to mark the pte writable, then it won't help
to mark it dirty here, and clogs up memory with pages which will
need swap instead of being thrown away.  Especially wrong if no
overcommit is chosen, and this vma is not yet VM_ACCOUNTed -
we could exceed the limit and OOM despite no overcommit.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2586,7 +2586,8 @@ static int do_anonymous_page(struct mm_s
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
-	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	if (vma->vm_flags & VM_WRITE)
+		entry = pte_mkwrite(pte_mkdirty(entry));
 
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!pte_none(*page_table))
