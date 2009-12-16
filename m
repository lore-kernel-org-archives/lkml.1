Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbZLPG0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbZLPG0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761629AbZLPG0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:26:48 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46391 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761643AbZLPG0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:26:37 -0500
Date: Wed, 16 Dec 2009 17:26:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: hwpoison tree build failure
Message-Id: <20091216172633.93c361ee.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Today's linux-next build (x86_64 allmodconfig) failed like this:

mm/memory-failure.c: In function 'soft_offline_page':
mm/memory-failure.c:1266: error: too few arguments to function 'migrate_pages'

Caused by commit c71d409184af558ddac0fd0167061d6282428872 ("HWPOISON: Add
soft page offline support") from the hwpoison tree interacting with
commit 62b61f611eb5e20f7e9f8619bfd03bdfe8af6348 ("ksm: memory hotremove
migration only") from Linus' tree.

I added the following merge fix for today (I don't know if it is correct)
and can carry it for a while:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 16 Dec 2009 17:19:40 +1100
Subject: [PATCH] hwpoison: fix for migrate_pages API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/memory-failure.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 7f3f627..bcce287 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1263,7 +1263,7 @@ int soft_offline_page(struct page *page, int flags)
 		LIST_HEAD(pagelist);
 
 		list_add(&page->lru, &pagelist);
-		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL);
+		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0);
 		if (ret) {
 			pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
 				pfn, ret, page->flags);
-- 
1.6.5.4


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
