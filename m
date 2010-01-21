Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596Ab0AUFH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab0AUFH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 00:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332Ab0AUFH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 00:07:59 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40512 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0AUFH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 00:07:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ji2C3NspvrhELzPqWEWtOiX/8t+3cvxx3xFuelvQb/FZ9EdjpuBVyaLhsbuEu1fXY4
         k952sqX+J3IrEj8+gA67zRHF/mGEhLyCOy49J5D5VvKH04SNrP7LL+v9+yPZTtXRiBjy
         ubFfoEh/QhbfGwjR1+yZIpJaSOEz5eXlgo8bg=
MIME-Version: 1.0
Date: Thu, 21 Jan 2010 13:07:57 +0800
Message-ID: <979dd0561001202107v4ddc1eb7xa59a7c16c452f7a2@mail.gmail.com>
Subject: [PATCH] Flush dcache before writing into page to avoid alias
From: anfei zhou <anfei.zhou@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux@arm.linux.org.uk, Jamie Lokier <jamie@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache alias problem will happen if the changes of user shared mapping
is not flushed before copying, then user and kernel mapping may be mapped
into two different cache line, it is impossible to guarantee the coherence
after iov_iter_copy_from_user_atomic.  So the right steps should be:
	flush_dcache_page(page);
	kmap_atomic(page);
	write to page;
	kunmap_atomic(page);
	flush_dcache_page(page);
More precisely, we might create two new APIs flush_dcache_user_page and
flush_dcache_kern_page to replace the two flush_dcache_page accordingly.

Here is a snippet tested on omap2430 with VIPT cache, and I think it is
not ARM-specific:
	int val = 0x11111111;
	fd = open("abc", O_RDWR);
	addr = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	*(addr+0) = 0x44444444;
	tmp = *(addr+0);
	*(addr+1) = 0x77777777;
	write(fd, &val, sizeof(int));
	close(fd);
The results are not always 0x11111111 0x77777777 at the beginning as expected.

Signed-off-by: Anfei <anfei.zhou@gmail.com>
---
 fs/fuse/file.c |    3 +++
 mm/filemap.c   |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c18913a..a9f5e13 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -828,6 +828,9 @@ static ssize_t fuse_fill_write_pages(struct fuse_req *req,
 		if (!page)
 			break;

+		if (mapping_writably_mapped(mapping))
+			flush_dcache_page(page);
+
 		pagefault_disable();
 		tmp = iov_iter_copy_from_user_atomic(page, ii, offset, bytes);
 		pagefault_enable();
diff --git a/mm/filemap.c b/mm/filemap.c
index 96ac6b0..07056fb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2196,6 +2196,9 @@ again:
 		if (unlikely(status))
 			break;

+		if (mapping_writably_mapped(mapping))
+			flush_dcache_page(page);
+
 		pagefault_disable();
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
 		pagefault_enable();
-- 
1.6.3.1
