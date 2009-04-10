Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbZDJVmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbZDJVmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 17:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZDJVly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 17:41:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:5233 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZDJVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 17:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=MMA93T3P6DzFDAXk1t+EUI/108MREFB3bZU4cKY7yLVOonXoz2t10L1Xdx1nUfATzL
         agb1nHUfQLsal4fE0lvTd1gF02xSC6zgux1YS2gqZHP1P5t/XpWuWAonk+g5ElhCkJsd
         YBit/fpKKFqrhCMVpHrA4ANvwMmf+jvq9+DK4=
Message-ID: <49DFBD0F.3030800@gmail.com>
Date: Fri, 10 Apr 2009 23:41:35 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Miklos Szeredi <mszeredi@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fuse: fix possible bug in fuse_direct_io on 64-bit system
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix possible bug on 64-bit system when user requests > 4GB of data by
direct_io read/write, but provides smaller buffer.

(passing nbytes>4GB to fuse_get_user_pages truncates nbytes and get_user_pages
is called with wrong value of npages)

Found by gcc:
fs/fuse/file.c: In function 'fuse_direct_io':
fs/fuse/file.c:1002: warning: passing argument 3 of 'fuse_get_user_pages' from incompatible pointer type

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 2b25133..0bb60c3 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -938,9 +938,9 @@ static void fuse_release_user_pages(struct fuse_req *req, int write)
 }
 
 static int fuse_get_user_pages(struct fuse_req *req, const char __user *buf,
-			       unsigned *nbytesp, int write)
+			       size_t *nbytesp, int write)
 {
-	unsigned nbytes = *nbytesp;
+	size_t nbytes = *nbytesp;
 	unsigned long user_addr = (unsigned long) buf;
 	unsigned offset = user_addr & ~PAGE_MASK;
 	int npages;
@@ -955,7 +955,7 @@ static int fuse_get_user_pages(struct fuse_req *req, const char __user *buf,
 		return 0;
 	}
 
-	nbytes = min(nbytes, (unsigned) FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT);
+	nbytes = min(nbytes, (size_t) FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT);
 	npages = (nbytes + offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	npages = clamp(npages, 1, FUSE_MAX_PAGES_PER_REQ);
 	down_read(&current->mm->mmap_sem);
-- 

