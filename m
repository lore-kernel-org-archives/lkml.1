Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbXGLErz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbXGLErz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 00:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbXGLErp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 00:47:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33604 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751004AbXGLEro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 00:47:44 -0400
Date: Thu, 12 Jul 2007 14:47:36 +1000
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: [PATCH 2 of 2] Make XFS use block_page_mkwrite
Message-ID: <20070712044736.GR31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement ->page_mkwrite in XFS.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/linux-2.6/xfs_file.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_file.c	2007-02-07 23:00:10.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c	2007-02-07 23:15:20.170880823 +1100
@@ -446,6 +446,20 @@ xfs_file_open_exec(
 }
 #endif /* HAVE_FOP_OPEN_EXEC */
 
+/*
+ * mmap()d file has taken write protection fault and is being made
+ * writable. We can set the page state up correctly for a writable
+ * page, which means we can do correct delalloc accounting (ENOSPC
+ * checking!) and unwritten extent mapping.
+ */
+STATIC int
+xfs_vm_page_mkwrite(
+	struct vm_area_struct	*vma,
+	struct page		*page)
+{
+	return block_page_mkwrite(vma, page, xfs_get_blocks);
+}
+
 const struct file_operations xfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -503,12 +517,14 @@ const struct file_operations xfs_dir_fil
 static struct vm_operations_struct xfs_file_vm_ops = {
 	.nopage		= filemap_nopage,
 	.populate	= filemap_populate,
+	.page_mkwrite	= xfs_vm_page_mkwrite,
 };
 
 #ifdef HAVE_DMAPI
 static struct vm_operations_struct xfs_dmapi_file_vm_ops = {
 	.nopage		= xfs_vm_nopage,
 	.populate	= filemap_populate,
+	.page_mkwrite	= xfs_vm_page_mkwrite,
 #ifdef HAVE_VMOP_MPROTECT
 	.mprotect	= xfs_vm_mprotect,
 #endif
