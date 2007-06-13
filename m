Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbXFMU45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbXFMU45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbXFMU4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:56:49 -0400
Received: from ext-ch1gw-8.online-age.net ([64.37.194.16]:36960 "EHLO
	ext-ch1gw-8.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916AbXFMU4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:56:48 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 16:56:48 EDT
Date: Wed, 13 Jun 2007 15:48:03 -0500
From: Rich Coe <Richard.Coe@med.ge.com>
To: torvalds@osdl.org, jack@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: PATCH: udf fs corruption on linux-2.6
Message-Id: <20070613154803.a1ad874a.Richard.Coe@med.ge.com>
Organization: CSE
X-Mailer: Sylpheed 2.4.0beta4 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: richard.coe@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, 

This patch fixes directory and missing files corruption in fs/udf which
occurs on all known 2.6 releases.

The corruption occurs because blocks which were pre-alloc'd for a directory 
are released back to the fs freelist, but the inode's alloc block information
is not updated to reflect this.

You would not see corruption if the number of files in any directory is 
less than 41, because the pre-alloc routine does not allocate blocks for the
directory until the number of files is over 40.

The problem occurs during unmounting because fs/udf incorrectly calls 
udf_discard_prealloc() from udf_clear_inode().  udf_discard_prealloc() will
update the inode and schedule it for write, but no write will ever occur 
because the fs is in the process of being umount'd. 

The solution is to add a put_inode routine to update the inode contents
and release the pre-alloc'd blocks to disk prior to clearing the inode
from the kernel.

Test case:
    mkuddfs /dev/scd0
    mount -o sync /dev/scd0 /mnt/cdrom
    mkdir /mnt/cdrom/A /mnt/cdrom/B
    cp A/* /mnt/cdrom/A		[ A contains 90 files of various sizes ]
    cp B/* /mnt/cdrom/B 	[ B contains 20 or fewer files ]
    umount /mnt/cdrom

Here you can see how 7 blocks starting at sector 139 are free and listed in the
directory entry for 'A'.  I used udfdump to get the following information:
    [ ... ]
    Free space found on this partition
	[00000139 - 00000159]   [00000161 - 00000191]   [00000193 - 00000223]   
	[00004464 - 00004475]   [00004485 - 00524286]   [00524287 - 01048573]
	[01048574 - 01572860]   [01572861 - 02097147]   [02097148 - 02235039]   
    [ ... ]
    Filename `A`
    [ ... ]
    [ blob at sector     2038 for     2048 bytes in logical partion 0 ] 
    [ blob at sector      137 for     4096 bytes in logical partion 0 ] 
    [ blob at sector      139 for    14336 bytes in logical partion 0 flags 1 ] 

-- 
Rich Coe		richard.coe@med.ge.com
Virtual Principle Engineer  General Electric Healthcare Technologies
Global Software Platforms, Computer Technology Team

Signed-off-by: Rich Coe <richard.coe@med.ge.com>
---
diff -urNp linux-2.6.20.orig/fs/udf/inode.c linux-2.6.20/fs/udf/inode.c
--- linux-2.6.20.orig/fs/udf/inode.c	2007-02-04 12:44:54.000000000 -0600
+++ linux-2.6.20/fs/udf/inode.c	2007-06-13 11:32:41.930983471 -0500
@@ -102,14 +102,17 @@ no_delete:
 
 void udf_clear_inode(struct inode *inode)
 {
+	kfree(UDF_I_DATA(inode));
+	UDF_I_DATA(inode) = NULL;
+}
+
+void udf_put_inode(struct inode *inode)
+{
 	if (!(inode->i_sb->s_flags & MS_RDONLY)) {
 		lock_kernel();
 		udf_discard_prealloc(inode);
 		unlock_kernel();
 	}
-
-	kfree(UDF_I_DATA(inode));
-	UDF_I_DATA(inode) = NULL;
 }
 
 static int udf_writepage(struct page *page, struct writeback_control *wbc)
diff -urNp linux-2.6.20.orig/fs/udf/super.c linux-2.6.20/fs/udf/super.c
--- linux-2.6.20.orig/fs/udf/super.c	2007-02-04 12:44:54.000000000 -0600
+++ linux-2.6.20/fs/udf/super.c	2007-06-13 11:31:23.793017185 -0500
@@ -166,6 +166,7 @@ static struct super_operations udf_sb_op
 	.write_inode		= udf_write_inode,
 	.delete_inode		= udf_delete_inode,
 	.clear_inode		= udf_clear_inode,
+	.put_inode		= udf_put_inode,
 	.put_super		= udf_put_super,
 	.write_super		= udf_write_super,
 	.statfs			= udf_statfs,
diff -urNp linux-2.6.20.orig/fs/udf/udfdecl.h linux-2.6.20/fs/udf/udfdecl.h
--- linux-2.6.20.orig/fs/udf/udfdecl.h	2007-02-04 12:44:54.000000000 -0600
+++ linux-2.6.20/fs/udf/udfdecl.h	2007-06-13 11:31:16.684293910 -0500
@@ -97,6 +97,7 @@ extern void udf_truncate(struct inode *)
 extern void udf_read_inode(struct inode *);
 extern void udf_delete_inode(struct inode *);
 extern void udf_clear_inode(struct inode *);
+extern void udf_put_inode(struct inode *);
 extern int udf_write_inode(struct inode *, int);
 extern long udf_block_map(struct inode *, long);
 extern int8_t inode_bmap(struct inode *, int, kernel_lb_addr *, uint32_t *, kernel_lb_addr *, uint32_t *, uint32_t *, struct buffer_head **);
