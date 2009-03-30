Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbZC3UDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbZC3UDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbZC3UDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:03:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38064 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816AbZC3UDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:03:11 -0400
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
In-reply-to: <E1LoNev-0007kP-U7@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 30 Mar 2009 22:00:37 +0200)
Subject: [patch 2/3] fuse: allow private mappings of "direct_io" files
References: <E1LoNev-0007kP-U7@pomaz-ex.szeredi.hu>
Message-Id: <E1LoNhP-0007lc-FC@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Mar 2009 22:03:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Allow MAP_PRIVATE mmaps of "direct_io" files.  This is necessary for
execute support.

MAP_SHARED mappings require some sort of coherency between the
underlying file and the mapping.  With "direct_io" it is difficult to
provide this, so for the moment just disallow shared (read-write and
read-only) mappings altogether.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c	2009-03-30 18:47:55.000000000 +0200
+++ linux-2.6/fs/fuse/file.c	2009-03-30 19:07:11.000000000 +0200
@@ -1291,6 +1291,15 @@ static int fuse_file_mmap(struct file *f
 	return 0;
 }
 
+static int fuse_direct_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	/* Can't provide the coherency needed for MAP_SHARED */
+	if (vma->vm_flags & VM_MAYSHARE)
+		return -ENODEV;
+
+	return generic_file_mmap(file, vma);
+}
+
 static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
 				  struct file_lock *fl)
 {
@@ -1925,6 +1934,7 @@ static const struct file_operations fuse
 	.llseek		= fuse_file_llseek,
 	.read		= fuse_direct_read,
 	.write		= fuse_direct_write,
+	.mmap		= fuse_direct_mmap,
 	.open		= fuse_open,
 	.flush		= fuse_flush,
 	.release	= fuse_release,
@@ -1934,7 +1944,7 @@ static const struct file_operations fuse
 	.unlocked_ioctl	= fuse_file_ioctl,
 	.compat_ioctl	= fuse_file_compat_ioctl,
 	.poll		= fuse_file_poll,
-	/* no mmap and splice_read */
+	/* no splice_read */
 };
 
 static const struct address_space_operations fuse_file_aops  = {
