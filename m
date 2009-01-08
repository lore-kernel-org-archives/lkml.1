Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbZAHK7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbZAHK7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZAHK7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:59:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46588 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbZAHK7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:59:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1231345823-27376-1-git-send-email-cooloney@kernel.org>
References: <1231345823-27376-1-git-send-email-cooloney@kernel.org>
To: Bryan Wu <cooloney@kernel.org>, Graf Yang <graf.yang@analog.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ramfs/nommu: fix bug - kernel crash when (nr != lpages)
Date: Thu, 08 Jan 2009 10:58:53 +0000
Message-ID: <21627.1231412333@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bryan Wu <cooloney@kernel.org> wrote:

> Avoiding kernel crash when (nr != lpages), and return -ENOMEM,
> let the user space application handle this error.

A better patch is attached.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Fix cleanup handling in ramfs_nommu_get_umapped_area()

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
 
