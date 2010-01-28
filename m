Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548Ab0A1GoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab0A1GoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 01:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000Ab0A1GoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 01:44:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab0A1GoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 01:44:04 -0500
Date: Thu, 28 Jan 2010 01:43:12 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       aarcange@redhat.com
Subject: [PATCH -mm] rmap: remove obsolete check from __page_check_anon_rmap
Message-ID: <20100128014312.47c5045d@annuminas.surriel.com>
In-Reply-To: <20100128002000.2bf5e365@annuminas.surriel.com>
References: <20100128002000.2bf5e365@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an anonymous page is inherited from a parent process, the
vma->anon_vma can differ from the page anon_vma.  This can trip
up __page_check_anon_rmap, which is indirectly called from
do_swap_page().

Remove that obsolete check to prevent an oops.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
The previous patch survived a short AIM7 run and only got upset when I
invoked pkill.  Presumably pkill paged in a page that was created in the
parent process of the process is was scanning.  With this patch it all
seems to be stable.

diff --git a/mm/rmap.c b/mm/rmap.c
index de7fde0..9e63424 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -755,9 +755,6 @@ static void __page_check_anon_rmap(struct page *page,
 	 * are initially only visible via the pagetables, and the pte is locked
 	 * over the call to page_add_new_anon_rmap.
 	 */
-	struct anon_vma *anon_vma = vma->anon_vma;
-	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
-	BUG_ON(page->mapping != (struct address_space *)anon_vma);
 	BUG_ON(page->index != linear_page_index(vma, address));
 #endif
 }
