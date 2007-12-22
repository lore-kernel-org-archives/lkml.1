Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbXLVBdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbXLVBdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXLVBdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:33:20 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54001 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751043AbXLVBdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:33:18 -0500
Message-ID: <398287206.44012@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071222013315.557435210@mail.ustc.edu.cn>
References: <20071222013147.897522982@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sat, 22 Dec 2007 09:31:55 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] readahead: move max_sane_readahead() calls into force_page_cache_readahead()
Content-Disposition: inline; filename=readahead-check-max_sane_readahead.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify code by moving max_sane_readahead() calls into
force_page_cache_readahead().

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/fadvise.c   |    2 +-
 mm/filemap.c   |    3 +--
 mm/madvise.c   |    3 +--
 mm/readahead.c |    1 +
 4 files changed, 4 insertions(+), 5 deletions(-)

--- linux-2.6.24-rc5-mm1.orig/mm/fadvise.c
+++ linux-2.6.24-rc5-mm1/mm/fadvise.c
@@ -89,7 +89,7 @@ asmlinkage long sys_fadvise64_64(int fd,
 		
 		ret = force_page_cache_readahead(mapping, file,
 				start_index,
-				max_sane_readahead(nrpages));
+				nrpages);
 		if (ret > 0)
 			ret = 0;
 		break;
--- linux-2.6.24-rc5-mm1.orig/mm/filemap.c
+++ linux-2.6.24-rc5-mm1/mm/filemap.c
@@ -1242,8 +1242,7 @@ do_readahead(struct address_space *mappi
 	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
 		return -EINVAL;
 
-	force_page_cache_readahead(mapping, filp, index,
-					max_sane_readahead(nr));
+	force_page_cache_readahead(mapping, filp, index, nr);
 	return 0;
 }
 
--- linux-2.6.24-rc5-mm1.orig/mm/madvise.c
+++ linux-2.6.24-rc5-mm1/mm/madvise.c
@@ -123,8 +123,7 @@ static long madvise_willneed(struct vm_a
 		end = vma->vm_end;
 	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
-	force_page_cache_readahead(file->f_mapping,
-			file, start, max_sane_readahead(end - start));
+	force_page_cache_readahead(file->f_mapping, file, start, end - start);
 	return 0;
 }
 
--- linux-2.6.24-rc5-mm1.orig/mm/readahead.c
+++ linux-2.6.24-rc5-mm1/mm/readahead.c
@@ -187,6 +187,7 @@ int force_page_cache_readahead(struct ad
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
 		return -EINVAL;
 
+	nr_to_read = max_sane_readahead(nr_to_read);
 	while (nr_to_read) {
 		int err;
 

-- 
