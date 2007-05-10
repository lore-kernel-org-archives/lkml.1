Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbXEJTSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbXEJTSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbXEJTSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:18:15 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:32621 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755528AbXEJTSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:18:15 -0400
X-YMail-OSG: rzLi4g8VM1lwuKS7lr7B799ngIHuL.ptI6Tt21Yx4885vCJmIRrBaPIvOy_xnUZWpf7CRdFkyw--
Date: Thu, 10 May 2007 12:18:11 -0700
From: Chris Wedgwood <cw@f00f.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: William Lee Irwin III <wli@holomorphy.com>, trond.myklebust@fys.uio.no
Subject: [RFC] nfs: memclear_highpage_flush -> zero_user_page conversion
Message-ID: <20070510191811.GA17220@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does this look correct?

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 9a55807..7bd7cb9 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -79,7 +79,7 @@ void nfs_readdata_release(void *data)
 static
 int nfs_return_empty_page(struct page *page)
 {
-	memclear_highpage_flush(page, 0, PAGE_CACHE_SIZE);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
@@ -103,10 +103,10 @@ static void nfs_readpage_truncate_uninitialised_page(struct nfs_read_data *data)
 	pglen = PAGE_CACHE_SIZE - base;
 	for (;;) {
 		if (remainder <= pglen) {
-			memclear_highpage_flush(*pages, base, remainder);
+			zero_user_page(*pages, base, remainder, KM_USER0);
 			break;
 		}
-		memclear_highpage_flush(*pages, base, pglen);
+		zero_user_page(*pages, base, pglen, KM_USER0);
 		pages++;
 		remainder -= pglen;
 		pglen = PAGE_CACHE_SIZE;
@@ -130,7 +130,7 @@ static int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
 		return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
 
 	nfs_list_add_request(new, &one_request);
 	if (NFS_SERVER(inode)->rsize < PAGE_CACHE_SIZE)
@@ -532,7 +532,7 @@ readpage_async_filler(void *data, struct page *page)
 			return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
 	nfs_pageio_add_request(desc->pgio, new);
 	return 0;
 }
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index de92b95..211d0b1 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -168,7 +168,7 @@ static void nfs_mark_uptodate(struct page *page, unsigned int base, unsigned int
 	if (count != nfs_page_length(page))
 		return;
 	if (count != PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, count, PAGE_CACHE_SIZE - count);
+		zero_user_page(page, count, PAGE_CACHE_SIZE - count, KM_USER0);
 	SetPageUptodate(page);
 }
 


