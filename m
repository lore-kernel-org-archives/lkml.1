Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZKJUPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZKJUPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757982AbZKJUPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:15:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757972AbZKJUPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:15:38 -0500
Date: Tue, 10 Nov 2009 12:15:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: jblunck@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, matthew@wil.cx, viro@zeniv.linux.org.uk
Subject: Re: BKL: Remove BKL from Squashfs
Message-Id: <20091110121511.5adca8a9.akpm@linux-foundation.org>
In-Reply-To: <E1N5L6K-0008LW-6y@dylan.lougher.demon.co.uk>
References: <E1N5L6K-0008LW-6y@dylan.lougher.demon.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Nov 2009 15:15:16 +0000
Phillip Lougher <phillip@lougher.demon.co.uk> wrote:

> 
> BKL is only used in fill_super/put_super.  It is safe to remove it.
> 

What kernel are you trying to patch here?

Most of your patch is already present in mainline.  Against mainline,
this what is left of your patch:

--- a/fs/squashfs/super.c~bkl-remove-bkl-from-squashfs
+++ a/fs/squashfs/super.c
@@ -30,7 +30,6 @@
 #include <linux/fs.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -339,8 +338,6 @@ static int squashfs_remount(struct super
 
 static void squashfs_put_super(struct super_block *sb)
 {
-	lock_kernel();
-
 	if (sb->s_fs_info) {
 		struct squashfs_sb_info *sbi = sb->s_fs_info;
 		squashfs_cache_delete(sbi->block_cache);
@@ -353,8 +350,6 @@ static void squashfs_put_super(struct su
 		kfree(sb->s_fs_info);
 		sb->s_fs_info = NULL;
 	}
-
-	unlock_kernel();
 }
 

So someone has decided to remove lots of lock_kernel()'s but chose to
leave the squashfs_put_super() ones behind.

Why did they do that?  Your patch effectively asserts that their
decision was incorrect.


So please rethink, update the changelog appropriately and resend.
