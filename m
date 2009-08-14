Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZHNMm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZHNMm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbZHNMm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:42:58 -0400
Received: from www.tglx.de ([62.245.132.106]:49730 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703AbZHNMm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:42:56 -0400
Message-Id: <20090814123548.213452171@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:42:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [patch 02/11] fat: cleanup fat_put_super()
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline; filename=fat-cleanup-nls-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unload_nls() can be called with a NULL pointer now. Remove the pointer
checks and the NULLification of the pointers as the data structure
which contains the pointers is kfree'd right away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/inode.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

Index: linux-2.6-tip/fs/fat/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/fat/inode.c
+++ linux-2.6-tip/fs/fat/inode.c
@@ -470,19 +470,11 @@ static void fat_put_super(struct super_b
 
 	iput(sbi->fat_inode);
 
-	if (sbi->nls_disk) {
-		unload_nls(sbi->nls_disk);
-		sbi->nls_disk = NULL;
-		sbi->options.codepage = fat_default_codepage;
-	}
-	if (sbi->nls_io) {
-		unload_nls(sbi->nls_io);
-		sbi->nls_io = NULL;
-	}
-	if (sbi->options.iocharset != fat_default_iocharset) {
+	unload_nls(sbi->nls_disk);
+	unload_nls(sbi->nls_io);
+
+	if (sbi->options.iocharset != fat_default_iocharset)
 		kfree(sbi->options.iocharset);
-		sbi->options.iocharset = fat_default_iocharset;
-	}
 
 	sb->s_fs_info = NULL;
 	kfree(sbi);


