Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZCVShv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZCVShv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 14:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZCVShl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 14:37:41 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55471 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZCVShl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 14:37:41 -0400
Date: Sun, 22 Mar 2009 18:36:42 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH mmotm] mm: page_mkwrite change prototype to match fault: fix
 sysfs
Message-ID: <Pine.LNX.4.64.0903221833140.17976@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warnings and return values in sysfs bin_page_mkwrite(), fixing
fs/sysfs/bin.c: In function `bin_page_mkwrite':
fs/sysfs/bin.c:250: warning: passing argument 2 of `bb->vm_ops->page_mkwrite' from incompatible pointer type
fs/sysfs/bin.c: At top level:
fs/sysfs/bin.c:280: warning: initialization from incompatible pointer type

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
To follow mm-page_mkwrite-change-prototype-to-match-fault.patch
Expects to have my [PATCH next] sysfs: fix some bin_vm_ops errors

 fs/sysfs/bin.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- next/fs/sysfs/bin.c	2009-03-21 18:01:26.000000000 +0000
+++ mmotm/fs/sysfs/bin.c	2009-03-21 18:28:51.000000000 +0000
@@ -234,7 +234,7 @@ static int bin_fault(struct vm_area_stru
 	return ret;
 }
 
-static int bin_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
 	struct bin_buffer *bb = file->private_data;
@@ -242,15 +242,15 @@ static int bin_page_mkwrite(struct vm_ar
 	int ret;
 
 	if (!bb->vm_ops)
-		return -EINVAL;
+		return VM_FAULT_SIGBUS;
 
 	if (!bb->vm_ops->page_mkwrite)
 		return 0;
 
 	if (!sysfs_get_active_two(attr_sd))
-		return -EINVAL;
+		return VM_FAULT_SIGBUS;
 
-	ret = bb->vm_ops->page_mkwrite(vma, page);
+	ret = bb->vm_ops->page_mkwrite(vma, vmf);
 
 	sysfs_put_active_two(attr_sd);
 	return ret;
