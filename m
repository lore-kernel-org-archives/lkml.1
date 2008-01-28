Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYA1B7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYA1B7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbYA1B7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:59:34 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:41985 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755354AbYA1B7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:59:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Message-Id:Content-Type;
  b=jisfbUoiPhqvOPaHEugoC/LaLzR3xH9Uj1lqCOh1sDs8WJF9GLHzEOxFuIJY3h08/W5ZL+N+nXBT2VCyV8v5Zk5E0yx7FpGaiu+8qN5C0IHmYUnlwm9dDT2Tq3seUfqe7wAqFQZ4ex5Ks+GC4OYfCx7NREr3zRnL7nIdE0/eyf8=  ;
X-YMail-OSG: GCIQGnMVM1lV9.T.7_.OOZbcel1xKY9G2dhRISQ_sSSpYMlQdeifiMhhbcXaRXhl9GqiOlT6DA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [0/18] Implement some low hanging BKL removal fruit in fs/*
Date: Mon, 28 Jan 2008 12:59:14 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
MIME-Version: 1.0
Message-Id: <200801281259.15198.nickpiggin@yahoo.com.au>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zbTnHVXP47qS2jD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_zbTnHVXP47qS2jD
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 27 January 2008 13:17, Andi Kleen wrote:
> [Andrew: I believe this is -mm material for .25]
>
> - Convert some more file systems (generally those who don't use the BKL
> for anything except mount) to use unlocked_bkl.
> - Implement BKL less fasync (see patch for the rationale)
> This is currently a separate entry point, but since the number of fasync
> users in the tree is relatively small I hope the older entry point can
> be removed then in the not too far future
> [help from other people converting more fasync users to unlocked_fasync
> would be appreciated]
> - Implement BKL less remote_llseek
> - While I was at it I also added a few missing compat ioctl handlers
> - Fix a few comments
>
> This fixes a lot of relatively trivial BKL users in fs/*. The main
> remaining non legacy offenders are now locks.c, nfs/nfsd and reiserfs.
> I believe BKL removal for all of those is being worked on by other people.
> Also a lot of "legacy" file systems still use it, but converting those
> does not seem to be very pressing.

BTW. here is a patch I did a while back for minix. I know it isn't
a big deal, but the work is done so I guess I should send it along.

--Boundary-00=_zbTnHVXP47qS2jD
Content-Type: text/x-diff;
  charset="utf-8";
  name="minix-no-bkl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="minix-no-bkl.patch"

The minix filesystem uses bkl to protect access to metadata. Switch
to a per-superblock mutex.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/minix/bitmap.c
===================================================================
--- linux-2.6.orig/fs/minix/bitmap.c
+++ linux-2.6/fs/minix/bitmap.c
@@ -69,11 +69,11 @@ void minix_free_block(struct inode *inod
 		return;
 	}
 	bh = sbi->s_zmap[zone];
-	lock_kernel();
+	mutex_lock(&sbi->s_mutex);
 	if (!minix_test_and_clear_bit(bit, bh->b_data))
 		printk("minix_free_block (%s:%lu): bit already cleared\n",
 		       sb->s_id, block);
-	unlock_kernel();
+	mutex_unlock(&sbi->s_mutex);
 	mark_buffer_dirty(bh);
 	return;
 }
@@ -88,18 +88,18 @@ int minix_new_block(struct inode * inode
 		struct buffer_head *bh = sbi->s_zmap[i];
 		int j;
 
-		lock_kernel();
+		mutex_lock(&sbi->s_mutex);
 		j = minix_find_first_zero_bit(bh->b_data, bits_per_zone);
 		if (j < bits_per_zone) {
 			minix_set_bit(j, bh->b_data);
-			unlock_kernel();
+			mutex_unlock(&sbi->s_mutex);
 			mark_buffer_dirty(bh);
 			j += i * bits_per_zone + sbi->s_firstdatazone-1;
 			if (j < sbi->s_firstdatazone || j >= sbi->s_nzones)
 				break;
 			return j;
 		}
-		unlock_kernel();
+		mutex_unlock(&sbi->s_mutex);
 	}
 	return 0;
 }
@@ -211,10 +211,10 @@ void minix_free_inode(struct inode * ino
 	minix_clear_inode(inode);	/* clear on-disk copy */
 
 	bh = sbi->s_imap[ino];
-	lock_kernel();
+	mutex_lock(&sbi->s_mutex);
 	if (!minix_test_and_clear_bit(bit, bh->b_data))
 		printk("minix_free_inode: bit %lu already cleared\n", bit);
-	unlock_kernel();
+	mutex_unlock(&sbi->s_mutex);
 	mark_buffer_dirty(bh);
  out:
 	clear_inode(inode);		/* clear in-memory copy */
@@ -237,7 +237,7 @@ struct inode * minix_new_inode(const str
 	j = bits_per_zone;
 	bh = NULL;
 	*error = -ENOSPC;
-	lock_kernel();
+	mutex_lock(&sbi->s_mutex);
 	for (i = 0; i < sbi->s_imap_blocks; i++) {
 		bh = sbi->s_imap[i];
 		j = minix_find_first_zero_bit(bh->b_data, bits_per_zone);
@@ -245,17 +245,17 @@ struct inode * minix_new_inode(const str
 			break;
 	}
 	if (!bh || j >= bits_per_zone) {
-		unlock_kernel();
+		mutex_unlock(&sbi->s_mutex);
 		iput(inode);
 		return NULL;
 	}
 	if (minix_test_and_set_bit(j, bh->b_data)) {	/* shouldn't happen */
-		unlock_kernel();
+		mutex_unlock(&sbi->s_mutex);
 		printk("minix_new_inode: bit already set\n");
 		iput(inode);
 		return NULL;
 	}
-	unlock_kernel();
+	mutex_unlock(&sbi->s_mutex);
 	mark_buffer_dirty(bh);
 	j += i * bits_per_zone;
 	if (!j || j > sbi->s_ninodes) {
Index: linux-2.6/fs/minix/dir.c
===================================================================
--- linux-2.6.orig/fs/minix/dir.c
+++ linux-2.6/fs/minix/dir.c
@@ -102,7 +102,7 @@ static int minix_readdir(struct file * f
 	char *name;
 	__u32 inumber;
 
-	lock_kernel();
+	mutex_lock(&sbi->s_mutex);
 
 	pos = (pos + chunk_size-1) & ~(chunk_size-1);
 	if (pos >= inode->i_size)
@@ -146,7 +146,7 @@ static int minix_readdir(struct file * f
 
 done:
 	filp->f_pos = (n << PAGE_CACHE_SHIFT) | offset;
-	unlock_kernel();
+	mutex_unlock(&sbi->s_mutex);
 	return 0;
 }
 
Index: linux-2.6/fs/minix/inode.c
===================================================================
--- linux-2.6.orig/fs/minix/inode.c
+++ linux-2.6/fs/minix/inode.c
@@ -174,6 +174,7 @@ static int minix_fill_super(struct super
 	sbi->s_firstdatazone = ms->s_firstdatazone;
 	sbi->s_log_zone_size = ms->s_log_zone_size;
 	sbi->s_max_size = ms->s_max_size;
+	mutex_init(&sbi->s_mutex);
 	s->s_magic = ms->s_magic;
 	if (s->s_magic == MINIX_SUPER_MAGIC) {
 		sbi->s_version = MINIX_V1;
Index: linux-2.6/fs/minix/minix.h
===================================================================
--- linux-2.6.orig/fs/minix/minix.h
+++ linux-2.6/fs/minix/minix.h
@@ -1,6 +1,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/minix_fs.h>
+#include <linux/mutex.h>
 
 /*
  * change the define below to 0 if you want names > info->s_namelen chars to be
@@ -43,6 +44,8 @@ struct minix_sb_info {
 	struct minix_super_block * s_ms;
 	unsigned short s_mount_state;
 	unsigned short s_version;
+
+	struct mutex s_mutex;
 };
 
 extern struct inode *minix_iget(struct super_block *, unsigned long);

--Boundary-00=_zbTnHVXP47qS2jD--
