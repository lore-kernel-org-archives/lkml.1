Return-Path: <linux-kernel-owner+w=401wt.eu-S1030757AbXDKDiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030757AbXDKDiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030352AbXDKDis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:38:48 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15870 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbXDKDim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=gei256hXsn6lk19Xv07T3JMCoZtzUycnCOrc6uYSPVcNqhzR5zF2qbPgL9JfkjqWigjjItnz6Rodmjpa5d7UMWKr4mo3pvmENXNVnuGCrRPaUjsJa0Mp0SMvgt2lJepndI+j+kh/D90mhg8ULns+IIhiJTErgnSnBPnIa0PtHq8=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.7609.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 7/13] nfs: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of the newly deprecated memclear_highpage_flush().

Signed-off-by: Nate Diller <nate.diller@gmail.com>

--- 

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/nfs/read.c linux-2.6.21-rc6-mm1-test/fs/nfs/read.c
--- linux-2.6.21-rc6-mm1/fs/nfs/read.c	2007-04-09 17:23:48.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/nfs/read.c	2007-04-09 18:18:23.000000000 -0700
@@ -79,7 +79,7 @@ void nfs_readdata_release(void *data)
 static
 int nfs_return_empty_page(struct page *page)
 {
-	memclear_highpage_flush(page, 0, PAGE_CACHE_SIZE);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
@@ -103,10 +103,10 @@ static void nfs_readpage_truncate_uninit
 	pglen = PAGE_CACHE_SIZE - base;
 	for (;;) {
 		if (remainder <= pglen) {
-			memclear_highpage_flush(*pages, base, remainder);
+			zero_user_page(*pages, base, remainder);
 			break;
 		}
-		memclear_highpage_flush(*pages, base, pglen);
+		zero_user_page(*pages, base, pglen);
 		pages++;
 		remainder -= pglen;
 		pglen = PAGE_CACHE_SIZE;
@@ -130,7 +130,7 @@ static int nfs_readpage_async(struct nfs
 		return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len);
 
 	nfs_list_add_request(new, &one_request);
 	nfs_pagein_one(&one_request, inode);
@@ -561,7 +561,7 @@ readpage_async_filler(void *data, struct
 			return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len);
 	nfs_list_add_request(new, desc->head);
 	return 0;
 }
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/nfs/write.c linux-2.6.21-rc6-mm1-test/fs/nfs/write.c
--- linux-2.6.21-rc6-mm1/fs/nfs/write.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/nfs/write.c	2007-04-09 18:18:23.000000000 -0700
@@ -169,7 +169,7 @@ static void nfs_mark_uptodate(struct pag
 	if (count != nfs_page_length(page))
 		return;
 	if (count != PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, count, PAGE_CACHE_SIZE - count);
+		zero_user_page(page, count, PAGE_CACHE_SIZE - count);
 	SetPageUptodate(page);
 }
 
