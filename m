Return-Path: <linux-kernel-owner+w=401wt.eu-S933579AbXKPO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbXKPO1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932590AbXKPOZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:25:36 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:24025 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761608AbXKPOZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:25:29 -0500
Message-Id: <20071116142527.252876230@de.ibm.com>
References: <20071116142441.484714036@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:24:48 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 07/10] Optimize storage key handling for anonymous pages
Content-Disposition: inline; filename=007-dirty-bit.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

page_mkclean used to call page_clear_dirty for every given page. This
is different to all other architectures, where the dirty bit in the
PTEs is only resetted, if page_mapping() returns a non-NULL pointer.
We can move the page_test_dirty/page_clear_dirty sequence into the 
2nd if to avoid unnecessary iske/sske sequences, which are expensive.

This change also helps kvm for s390 as the host must transfer the 
dirty bit into the guest status bits. By moving the page_clear_dirty
operation into the 2nd if, the vm will only call page_clear_dirty
for pages where it walks the mapping anyway. There it calls
ptep_clear_flush for writable ptes, so we can transfer the dirty bit
to the guest. 

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 mm/rmap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/mm/rmap.c linux-2.6-patched/mm/rmap.c
--- linux-2.6/mm/rmap.c	2007-11-16 14:27:35.000000000 +0100
+++ linux-2.6-patched/mm/rmap.c	2007-11-16 14:27:43.000000000 +0100
@@ -471,11 +471,12 @@ int page_mkclean(struct page *page)
 
 	if (page_mapped(page)) {
 		struct address_space *mapping = page_mapping(page);
-		if (mapping)
+		if (mapping) {
 			ret = page_mkclean_file(mapping, page);
-		if (page_test_dirty(page)) {
-			page_clear_dirty(page);
-			ret = 1;
+			if (page_test_dirty(page)) {
+				page_clear_dirty(page);
+				ret = 1;
+			}
 		}
 	}
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

