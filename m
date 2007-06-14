Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbXFNPl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbXFNPl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXFNPlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:41:51 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:18902 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbXFNPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:41:50 -0400
Subject: [patch] xip sendfile removal
From: Carsten Otte <cotte@de.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, jaredeh@gmail.com
Cc: Christian Borntraeger <cborntra@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
	Aufsichtsrats: Johann Weihen =?ISO-8859-1?Q?Gesch=E4ftsf=FChrung=3A?=
	Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-1?Q?B=F6blingen?=
	Registergericht: Amtsgericht Stuttgart, HRB 243294
Date: Thu, 14 Jun 2007 17:41:47 +0200
Message-Id: <1181835707.7222.13.camel@cotte.boeblingen.de.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes xip_file_sendfile, the sendfile implementation for
xip without replacement. Those customers that use xip on s390 are not
using sendfile() as far as we know, and so far s390 is the only platform
this could potentially be used on so far.
Having sendfile is not a popular feature for execute in place file
systems, however we have a working implementation of splice_read() based
on fs/splice.c if anyone asks for it.
At this point in time, it does not seem preferable to merge
splice_read() for xip because it causes extra maintenence effort due to
code duplication and it requires struct page behind the xip memory
segment. We'd like to get rid of that in favor of supporting flash based
embedded platforms (Monta Vista work) soon.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
---
Index: linux-2.6.21/fs/ext2/file.c
===================================================================
--- linux-2.6.21.orig/fs/ext2/file.c
+++ linux-2.6.21/fs/ext2/file.c
@@ -70,7 +70,6 @@ const struct file_operations ext2_xip_fi
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_sync_file,
-	.sendfile	= xip_file_sendfile,
 };
 #endif
 
Index: linux-2.6.21/include/linux/fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/fs.h
+++ linux-2.6.21/include/linux/fs.h
@@ -1764,9 +1764,6 @@ extern int nonseekable_open(struct inode
 #ifdef CONFIG_FS_XIP
 extern ssize_t xip_file_read(struct file *filp, char __user *buf, size_t len,
 			     loff_t *ppos);
-extern ssize_t xip_file_sendfile(struct file *in_file, loff_t *ppos,
-				 size_t count, read_actor_t actor,
-				 void *target);
 extern int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
 extern ssize_t xip_file_write(struct file *filp, const char __user *buf,
 			      size_t len, loff_t *ppos);
Index: linux-2.6.21/mm/filemap_xip.c
===================================================================
--- linux-2.6.21.orig/mm/filemap_xip.c
+++ linux-2.6.21/mm/filemap_xip.c
@@ -159,28 +159,6 @@ xip_file_read(struct file *filp, char __
 }
 EXPORT_SYMBOL_GPL(xip_file_read);
 
-ssize_t
-xip_file_sendfile(struct file *in_file, loff_t *ppos,
-	     size_t count, read_actor_t actor, void *target)
-{
-	read_descriptor_t desc;
-
-	if (!count)
-		return 0;
-
-	desc.written = 0;
-	desc.count = count;
-	desc.arg.data = target;
-	desc.error = 0;
-
-	do_xip_mapping_read(in_file->f_mapping, &in_file->f_ra, in_file,
-			    ppos, &desc, actor);
-	if (desc.written)
-		return desc.written;
-	return desc.error;
-}
-EXPORT_SYMBOL_GPL(xip_file_sendfile);
-
 /*
  * __xip_unmap is invoked from xip_unmap and
  * xip_write


