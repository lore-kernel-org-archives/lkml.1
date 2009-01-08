Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbZAHMzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbZAHMzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbZAHMym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:54:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40697 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbZAHMyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:54:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/10] NOMMU: Fix cleanup handling in
	ramfs_nommu_get_umapped_area() [ver #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: bernds_cb1@t-online.de, dhowells@redhat.com, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 12:53:51 +0000
Message-ID: <20090108125351.28454.81007.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
References: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix cleanup handling in ramfs_nommu_get_umapped_area() by only freeing the
number of pages that find_get_pages() said it had returned (nr) rather than
attempting to free the number of pages we asked for (lpages) - thus avoiding
the situation whereby put_page() may be handed NULL pointers if
find_get_pages() returned fewer pages that were requested.

Also avoid a warning about nr being uninitialised and the need for an
if-statement in the cleanup path by using appropriate gotos.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ramfs/file-nommu.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)


diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 76acdbc..b9b567a 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -262,11 +262,11 @@ unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 	ret = -ENOMEM;
 	pages = kzalloc(lpages * sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
-		goto out;
+		goto out_free;
 
 	nr = find_get_pages(inode->i_mapping, pgoff, lpages, pages);
 	if (nr != lpages)
-		goto out; /* leave if some pages were missing */
+		goto out_free_pages; /* leave if some pages were missing */
 
 	/* check the pages for physical adjacency */
 	ptr = pages;
@@ -274,19 +274,18 @@ unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 	page++;
 	for (loop = lpages; loop > 1; loop--)
 		if (*ptr++ != page++)
-			goto out;
+			goto out_free_pages;
 
 	/* okay - all conditions fulfilled */
 	ret = (unsigned long) page_address(pages[0]);
 
- out:
-	if (pages) {
-		ptr = pages;
-		for (loop = lpages; loop > 0; loop--)
-			put_page(*ptr++);
-		kfree(pages);
-	}
-
+out_free_pages:
+	ptr = pages;
+	for (loop = nr; loop > 0; loop--)
+		put_page(*ptr++);
+out_free:
+	kfree(pages);
+out:
 	return ret;
 }
 

