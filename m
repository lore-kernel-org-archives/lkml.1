Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbZFPQT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbZFPQT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbZFPQTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:19:21 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:41496 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbZFPQTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:19:21 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [git pull] vfs patches, part 1 
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090612014507.GA8633@ZenIV.linux.org.uk>
References: <20090612014507.GA8633@ZenIV.linux.org.uk>
Date: Wed, 17 Jun 2009 01:19:09 +0900
Message-ID: <11056.1245169149@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> * more pushing of lock_super() and BKL down into fs (by now only ->get_sb()
>   has the latter held by caller and nothing in VFS touches the former) (me,
>   hch, Alessio Igor Bogani)
	:::
> Al Viro (36):
	:::
>       Push BKL down into do_remount_sb()
	:::
> Alessio Igor Bogani (1):
>       Push BKL down into ->remount_fs()

These two patches conflict, or are unmatched.
Al's patch adds one lock_kernel() call and several unlock_kernel() into
do_remount_sb(), and then Alessio's patch removes only single pair of
lock/unlock_kernel().
Finally a few unlock_kernel() are left in do_remount_sb().

I guess Alessio's base was different from Al's.


J. R. Okajima

commit 8219ce0904f57cd0893092369fbde39471cfb5a7
Author: J. R. Okajima <hooanon05@yahoo.co.jp>
Date:   Wed Jun 17 01:16:50 2009 +0900

    remove unlock_kernel() left accidentally
    
    commit 337eb00a2c3a421999c39c94ce7e33545ee8baa7
    Push BKL down into ->remount_fs()
    and
    commit 4aa98cf768b6f2ea4b204620d949a665959214f6
    Push BKL down into do_remount_sb()
    
    were uncorrectly merged.
    The former removes one pair of lock/unlock_kernel(), but the latter adds
    several unlock_kernel(). Finally a few unlock_kernel() calls left.
    
    Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>

diff --git a/fs/super.c b/fs/super.c
index 83b4741..d40d53a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -545,24 +545,18 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
 		if (force)
 			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb)) {
-			unlock_kernel();
+		else if (!fs_may_remount_ro(sb))
 			return -EBUSY;
-		}
 		retval = vfs_dq_off(sb, 1);
-		if (retval < 0 && retval != -ENOSYS) {
-			unlock_kernel();
+		if (retval < 0 && retval != -ENOSYS)
 			return -EBUSY;
-		}
 	}
 	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		if (retval) {
-			unlock_kernel();
+		if (retval)
 			return retval;
-		}
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 	if (remount_rw)
