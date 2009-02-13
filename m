Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbZBMFzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbZBMFzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 00:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbZBMFzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 00:55:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45700 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZBMFzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 00:55:32 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>
Subject: [PATCH] mm: adding comment why mark_page_accessed() would be better than pte_mkyoung() in follow_page()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090213145039.77C8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Feb 2009 14:55:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I and hugh discussed about mark_page_accessed() in follow_page() should be
change or not. and we agreed it isn't needed without adding comment.

==
At first look, mark_page_accessed() in follow_page() seems a bit strange.
it seems pte_mkyoung() would be better and to consist other kernel code.

However, it is intentionally. past commitlog said, 

    ------------------------------------------------
    commit 9e45f61d69be9024a2e6bef3831fb04d90fac7a8
    Author: akpm <akpm>
    Date:   Fri Aug 15 07:24:59 2003 +0000

    [PATCH] Use mark_page_accessed() in follow_page()

    Touching a page via follow_page() counts as a reference so we should be
    either setting the referenced bit in the pte or running mark_page_accessed().

    Altering the pte is tricky because we haven't implemented an atomic
    pte_mkyoung().  And mark_page_accessed() is better anyway because it has more
    aging state: it can move the page onto the active list.

    BKrev: 3f3c8acbplT8FbwBVGtth7QmnqWkIw
    ------------------------------------------------

The atomic issue is still true nowadays. adding comment help to understand 
code intention and it would be better.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>
---
 mm/memory.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/mm/memory.c
===================================================================
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1151,6 +1151,11 @@ struct page *follow_page(struct vm_area_
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
 			set_page_dirty(page);
+		/*
+		 * pte_mkyoung() would be more correct here, but atomic care
+		 * is needed to avoid losing dirty bit: easier to
+		 * mark_page_accessed().
+		 */
 		mark_page_accessed(page);
 	}
 unlock:


