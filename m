Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYEKSPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYEKSPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYEKSPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:15:37 -0400
Received: from mx1.riseup.net ([204.13.164.18]:33544 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbYEKSPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:15:36 -0400
Date: Sun, 11 May 2008 20:15:30 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 1/2] HFS: Convert bitmap_lock in a mutex
Message-ID: <20080511181530.GB21359@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	zippel@linux-m68k.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20080511174331.584439618@kaehlcke.net> <20080511174332.994796915@kaehlcke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511174332.994796915@kaehlcke.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apple Macintosh file system: The semaphore bitmap_lock is used as a mutex. 
Convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

Index: linux-2.6/fs/hfs/bitmap.c
===================================================================
--- linux-2.6.orig/fs/hfs/bitmap.c	2008-05-11 20:10:11.000000000 +0200
+++ linux-2.6/fs/hfs/bitmap.c	2008-05-11 20:10:18.000000000 +0200
@@ -145,7 +145,7 @@
 	if (!*num_bits)
 		return 0;
 
-	down(&HFS_SB(sb)->bitmap_lock);
+	mutex_lock(&HFS_SB(sb)->bitmap_lock);
 	bitmap = HFS_SB(sb)->bitmap;
 
 	pos = hfs_find_set_zero_bits(bitmap, HFS_SB(sb)->fs_ablocks, goal, num_bits);
@@ -162,7 +162,7 @@
 	HFS_SB(sb)->free_ablocks -= *num_bits;
 	hfs_bitmap_dirty(sb);
 out:
-	up(&HFS_SB(sb)->bitmap_lock);
+	mutex_unlock(&HFS_SB(sb)->bitmap_lock);
 	return pos;
 }
 
@@ -205,7 +205,7 @@
 	if ((start + count) > HFS_SB(sb)->fs_ablocks)
 		return -2;
 
-	down(&HFS_SB(sb)->bitmap_lock);
+	mutex_lock(&HFS_SB(sb)->bitmap_lock);
 	/* bitmap is always on a 32-bit boundary */
 	curr = HFS_SB(sb)->bitmap + (start / 32);
 	len = count;
@@ -236,7 +236,7 @@
 	}
 out:
 	HFS_SB(sb)->free_ablocks += len;
-	up(&HFS_SB(sb)->bitmap_lock);
+	mutex_unlock(&HFS_SB(sb)->bitmap_lock);
 	hfs_bitmap_dirty(sb);
 
 	return 0;
Index: linux-2.6/fs/hfs/hfs_fs.h
===================================================================
--- linux-2.6.orig/fs/hfs/hfs_fs.h	2008-05-11 20:10:11.000000000 +0200
+++ linux-2.6/fs/hfs/hfs_fs.h	2008-05-11 20:14:08.000000000 +0200
@@ -11,6 +11,7 @@
 
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
 
@@ -139,7 +140,7 @@
 
 	struct nls_table *nls_io, *nls_disk;
 
-	struct semaphore bitmap_lock;
+	struct mutex bitmap_lock;
 
 	unsigned long flags;
 
Index: linux-2.6/fs/hfs/super.c
===================================================================
--- linux-2.6.orig/fs/hfs/super.c	2008-05-11 20:10:11.000000000 +0200
+++ linux-2.6/fs/hfs/super.c	2008-05-11 20:10:18.000000000 +0200
@@ -372,7 +372,7 @@
 
 	sb->s_op = &hfs_super_operations;
 	sb->s_flags |= MS_NODIRATIME;
-	init_MUTEX(&sbi->bitmap_lock);
+	mutex_init(&sbi->bitmap_lock);
 
 	res = hfs_mdb_get(sb);
 	if (res) {

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

              La posibilidad de realizar un suenyo es lo
                 que hace que la vida sea interesante
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
