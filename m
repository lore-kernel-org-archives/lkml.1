Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbZJBBiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbZJBBiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbZJBBeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:20 -0400
Received: from kroah.org ([198.145.64.141]:33553 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807AbZJBBeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:26 2009
Message-Id: <20091002012426.168639081@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@csn.ul.ie>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: [121/136] mm: fix anonymous dirtying
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=mm-fix-anonymous-dirtying.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2638,7 +2638,8 @@ static int do_anonymous_page(struct mm_s
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
-	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	if (vma->vm_flags & VM_WRITE)
+		entry = pte_mkwrite(pte_mkdirty(entry));
 
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!pte_none(*page_table))


