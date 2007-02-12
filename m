Return-Path: <linux-kernel-owner+w=401wt.eu-S964935AbXBLOab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935AbXBLOab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 09:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964940AbXBLOab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 09:30:31 -0500
Received: from ms-smtp-03.texas.rr.com ([24.93.47.42]:38295 "EHLO
	ms-smtp-03.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935AbXBLOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 09:30:30 -0500
From: Dave McCracken <dave.mccracken@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>, Dave McCracken <dave.mccracken@oracle.com>
Date: Mon, 12 Feb 2007 08:28:02 -0600
Message-Id: <20070212142802.15738.80487.sendpatchset@wildcat.int.mccr.org>
Subject: [PATCH 1/1] Enable fully functional truncate for hugetlbfs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the full functionality of truncate for hugetlbfs
files.  Truncate was originally limited to reducing the file size
because page faults were not supported for hugetlbfs.  Now that page
faults have been implemented it is now possible to fully support
truncate.

Signed-off-by: Dave McCracken <dave.mccracken@oracle.com>

---
 inode.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- 2.6.20/./fs/hugetlbfs/inode.c	2007-02-04 12:44:54.000000000 -0600
+++ 2.6.20-htrunc/./fs/hugetlbfs/inode.c	2007-02-05 13:02:00.000000000 -0600
@@ -298,9 +298,10 @@ static int hugetlb_vmtruncate(struct ino
 {
 	pgoff_t pgoff;
 	struct address_space *mapping = inode->i_mapping;
+	unsigned long limit;
 
 	if (offset > inode->i_size)
-		return -EINVAL;
+		goto do_expand;
 
 	BUG_ON(offset & ~HPAGE_MASK);
 	pgoff = offset >> PAGE_SHIFT;
@@ -312,6 +313,24 @@ static int hugetlb_vmtruncate(struct ino
 	spin_unlock(&mapping->i_mmap_lock);
 	truncate_hugepages(inode, offset);
 	return 0;
+
+do_expand:
+	limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+	if (limit != RLIM_INFINITY && offset > limit)
+		goto out_sig;
+	if (offset > inode->i_sb->s_maxbytes)
+		goto out_big;
+	if (hugetlb_reserve_pages(inode, inode->i_size >> HPAGE_SHIFT,
+				  offset >> HPAGE_SHIFT))
+		goto out_mem;
+	i_size_write(inode, offset);
+	return 0;
+out_sig:
+	send_sig(SIGXFSZ, current, 0);
+out_big:
+	return -EFBIG;
+out_mem:
+	return -ENOMEM;
 }
 
 static int hugetlbfs_setattr(struct dentry *dentry, struct iattr *attr)
