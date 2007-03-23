Return-Path: <linux-kernel-owner+w=401wt.eu-S2992502AbXCWQL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992502AbXCWQL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992504AbXCWQLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:11:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59461 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992500AbXCWQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:11:21 -0400
Subject: [Patch 5/7] integrity: mtime patch for mmap files
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com, staubach@redhat.com,
       akpm@osdl.org
Content-Type: text/plain
Date: Fri, 23 Mar 2007 12:09:58 -0400
Message-Id: <1174666198.11149.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mmaped files are hashed and hmac'ed properly by EVM after being modified
when the file's mtime is updated correctly.  Peter Staubach's 'memory
mapped files not updating timestamps v2' patch properly updates the
mmapped file's mtime.  In those cases when an application does not
first msync the file before calling munmap, the mtime is eventually
updated, but not before file_close is called.  This patch forces the
mtime for mmaped files to be updated in a timely manner.

signed-off-by: Mimi Zohar <zohar@us.ibm.com>
----
Index: linux-2.6.21-rc4-mm1/mm/mmap.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/mm/mmap.c
+++ linux-2.6.21-rc4-mm1/mm/mmap.c
@@ -1790,6 +1790,7 @@ int do_munmap(struct mm_struct *mm, unsi
 {
 	unsigned long end;
 	struct vm_area_struct *vma, *prev, *last;
+	struct file *file;
 
 	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
 		return -EINVAL;
@@ -1808,6 +1809,10 @@ int do_munmap(struct mm_struct *mm, unsi
 	if (vma->vm_start >= end)
 		return 0;
 
+	file = vma->vm_file;
+	if (file && test_and_clear_bit(AS_MCTIME, &file->f_mapping->flags))
+		file_update_time(file);
+
 	/*
 	 * If we need to split any vma, do it now to save pain later.
 	 *






