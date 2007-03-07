Return-Path: <linux-kernel-owner+w=401wt.eu-S1422933AbXCGRSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422933AbXCGRSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422924AbXCGRSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:18:41 -0500
Received: from ns.suse.de ([195.135.220.2]:44421 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422907AbXCGRSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:13 -0500
Message-Id: <20070307171621.859852338@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       nish.aravamudan@gmail.com, wli@holomorphy.com, kenchen@google.com,
       agl@us.ibm.com, hugh@veritas.com, david@gibson.dropbear.id.au,
       William Irwin <bill.irwin@oracle.com>
Subject: [patch 086/101] hugetlb: preserve hugetlb pte dirty state
Content-Disposition: inline; filename=hugetlb-preserve-hugetlb-pte-dirty-state.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Ken Chen" <kenchen@google.com>

__unmap_hugepage_range() is buggy that it does not preserve dirty state of
huge_pte when unmapping hugepage range.  It causes data corruption in the
event of dop_caches being used by sys admin.  For example, an application
creates a hugetlb file, modify pages, then unmap it.  While leaving the
hugetlb file alive, comes along sys admin doing a "echo 3 >
/proc/sys/vm/drop_caches".

drop_pagecache_sb() will happily free all pages that aren't marked dirty if
there are no active mapping.  Later when application remaps the hugetlb
file back and all data are gone, triggering catastrophic flip over on
application.

Not only that, the internal resv_huge_pages count will also get all messed
up.  Fix it up by marking page dirty appropriately.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: "Nish Aravamudan" <nish.aravamudan@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Acked-by: William Irwin <bill.irwin@oracle.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hugetlbfs/inode.c |    5 ++++-
 mm/hugetlb.c         |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.20.1.orig/fs/hugetlbfs/inode.c
+++ linux-2.6.20.1/fs/hugetlbfs/inode.c
@@ -449,10 +449,13 @@ static int hugetlbfs_symlink(struct inod
 }
 
 /*
- * For direct-IO reads into hugetlb pages
+ * mark the head page dirty
  */
 static int hugetlbfs_set_page_dirty(struct page *page)
 {
+	struct page *head = (struct page *)page_private(page);
+
+	SetPageDirty(head);
 	return 0;
 }
 
--- linux-2.6.20.1.orig/mm/hugetlb.c
+++ linux-2.6.20.1/mm/hugetlb.c
@@ -389,6 +389,8 @@ void __unmap_hugepage_range(struct vm_ar
 			continue;
 
 		page = pte_page(pte);
+		if (pte_dirty(pte))
+			set_page_dirty(page);
 		list_add(&page->lru, &page_list);
 	}
 	spin_unlock(&mm->page_table_lock);

--
