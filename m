Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbZIGVjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbZIGVjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZIGVjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:39:13 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:9424 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170AbZIGVjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:39:13 -0400
X-Trace: 255183178/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.94.54/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.94.54
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAI8apUpPRV42/2dsb2JhbACBU9dAhBgF
X-IronPort-AV: E=Sophos;i="4.44,348,1249254000"; 
   d="scan'208";a="255183178"
Date: Mon, 7 Sep 2009 22:38:29 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 6/8] mm: fix anonymous dirtying
In-Reply-To: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
Message-ID: <Pine.LNX.4.64.0909072237190.15430@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_anonymous_page() has been wrong to dirty the pte regardless.
If it's not going to mark the pte writable, then it won't help
to mark it dirty here, and clogs up memory with pages which will
need swap instead of being thrown away.  Especially wrong if no
overcommit is chosen, and this vma is not yet VM_ACCOUNTed -
we could exceed the limit and OOM despite no overcommit.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: stable@kernel.org
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mm5/mm/memory.c	2009-09-07 13:16:46.000000000 +0100
+++ mm6/mm/memory.c	2009-09-07 13:16:53.000000000 +0100
@@ -2608,7 +2608,8 @@ static int do_anonymous_page(struct mm_s
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
-	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	if (vma->vm_flags & VM_WRITE)
+		entry = pte_mkwrite(pte_mkdirty(entry));
 
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!pte_none(*page_table))
