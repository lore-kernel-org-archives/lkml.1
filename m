Return-Path: <linux-kernel-owner+w=401wt.eu-S1422963AbXBHM0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422963AbXBHM0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422962AbXBHM0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:26:37 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:45467 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422960AbXBHM0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:26:36 -0500
Date: Thu, 8 Feb 2007 13:22:22 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       jack@suse.cz, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
In-Reply-To: <20070207190632.GA3350@infradead.org>
Message-ID: <Pine.LNX.4.61.0702081315060.1364@yvahk01.tjqt.qr>
References: <20070206132333.GA9919@lst.de> <20070206155001.22ab74f6.akpm@linux-foundation.org>
 <20070207072259.GA22083@lst.de> <Pine.LNX.4.61.0702071901150.20245@yvahk01.tjqt.qr>
 <20070207190632.GA3350@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 7 2007 19:06, Christoph Hellwig wrote:
>On Wed, Feb 07, 2007 at 07:03:05PM +0100, Jan Engelhardt wrote:
>
>> With filesystems that can turn on their quota after mount time (about 
>> every fs except xfs), I can surely have a ton of files open, and hence, 
>> if I understand correctly, have lots of inodes instantiated.
>
>Yes, you can in theory.  But turning on quota on a filesystem in full
>steam useage is not a common use case and thus there is no point in
>optimizing for it.

I put it to a test in a default scenario (quotaon sometime at boot).
SUSE Linux 10.1 with reiserfs(usrquota,grpquota).
This is the result:

add_dquot_ref: 30 files in sb->s_files for hda2
add_dquot_ref: Restarting after 12 files
add_dquot_ref: 30 files in sb->s_files for hda2
add_dquot_ref: Restarted 1 times
add_dquot_ref: 30 files in sb->s_files for hda2
add_dquot_ref: Restarting after 12 files
add_dquot_ref: 30 files in sb->s_files for hda2
add_dquot_ref: Restarted 1 times

Surprisingly few. I had expected to see more instantiated (but not necessarily
open) files.

Patch for reference:

Index: 18/fs/dquot.c
===================================================================
--- 18.orig/fs/dquot.c
+++ 18/fs/dquot.c
@@ -689,22 +689,35 @@ static int dqinit_needed(struct inode *i
 static void add_dquot_ref(struct super_block *sb, int type)
 {
 	struct list_head *p;
+        int restart = 0;
+        int num_files;
 
 restart:
 	file_list_lock();
+        num_files = 0;
+        list_for_each(p, &sb->s_files) {
+            ++num_files;
+        }
+        printk(KERN_WARNING "add_dquot_ref: %d files in sb->s_files for %s\n",
+            num_files, sb->s_id);
+        num_files = 0;
 	list_for_each(p, &sb->s_files) {
 		struct file *filp = list_entry(p, struct file, f_u.fu_list);
 		struct inode *inode = filp->f_dentry->d_inode;
+                ++num_files;
 		if (filp->f_mode & FMODE_WRITE && dqinit_needed(inode, type)) {
 			struct dentry *dentry = dget(filp->f_dentry);
 			file_list_unlock();
 			sb->dq_op->initialize(inode, type);
 			dput(dentry);
 			/* As we may have blocked we had better restart... */
+                        printk(KERN_WARNING "add_dquot_ref: Restarting after %d files\n", num_files);
+                        ++restart;
 			goto restart;
 		}
 	}
 	file_list_unlock();
+        printk(KERN_WARNING "add_dquot_ref: Restarted %d times\n", restart);
 }
 
 /* Return 0 if dqput() won't block (note that 1 doesn't necessarily mean blocking) */


BTW, whilst looking for the function to return a readable name, I came
across reiserfs_bdevname() and bdevname(). The former uses sb->s_id, the
latter struct gendisk->hd_name+partition number.
Could someone elaborate on why there are two ways?


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
