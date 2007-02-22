Return-Path: <linux-kernel-owner+w=401wt.eu-S1945922AbXBVHeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945922AbXBVHeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945928AbXBVHeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:34:21 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:41926 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945922AbXBVHeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:34:21 -0500
To: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH] ecryptfs remove unnecessary flush_dcache_page
References: <87wt2ew716.fsf@sw.ru>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Thu, 22 Feb 2007 10:34:00 +0300
In-Reply-To: <87wt2ew716.fsf@sw.ru> (Dmitriy Monakhov's message of "Mon, 19 Feb 2007 17:34:13 +0300")
Message-ID: <87r6si7ijb.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Dmitriy Monakhov <dmonakhov@openvz.org> writes:

> 1)Function ecryptfs_do_readpage() calls flush_dcache_page(lower_page),
>   but lower_page was't changed here. So remove this line.
>
> 2)prepare_write ret val was ignored in ecryptfs_write_inode_size_to_header().
> If error happends we can't call commit_write, just do cleanup and fial.
> It is issue easy to reproduce with full lower_fs, in this case prepare_write()
Second issue was fixed by "ecryptfs-resolve-lower-page-unlocking-problem.patch",
but first issue was't.

[LOG]
  Function ecryptfs_do_readpage() calls flush_dcache_page(lower_page),
  but lower_page was't changed here. Even if it was changed by 
  lower_a_ops->readpage() dcache was flushed by readpage() itself.
  So remove this unnecessary line.
Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>


--=-=-=
Content-Disposition: inline; filename=diff-mm-ecryptfs-false-flush_dcache

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 1e5d2ba..2e45513 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -238,7 +238,6 @@ int ecryptfs_do_readpage(struct file *file, struct page *page,
 	lower_page_data = kmap_atomic(lower_page, KM_USER1);
 	memcpy(page_data, lower_page_data, PAGE_CACHE_SIZE);
 	kunmap_atomic(lower_page_data, KM_USER1);
-	flush_dcache_page(lower_page);
 	kunmap_atomic(page_data, KM_USER0);
 	flush_dcache_page(page);
 	rc = 0;

--=-=-=--

