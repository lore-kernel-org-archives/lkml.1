Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbXGHSbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbXGHSbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbXGHSbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:31:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992AbXGHSbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:31:10 -0400
Date: Sun, 8 Jul 2007 11:30:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: Al Viro <viro@ftp.linux.org.uk>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer dereference
 - git-bisect result
In-Reply-To: <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707081126260.31544@woody.linux-foundation.org>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
 <20070708012016.455ce8d5.akpm@linux-foundation.org>
 <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de>
 <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk>
 <469121DA.6030600@redhat.com>
 <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 8 Jul 2007, Linus Torvalds wrote:
> 
> No.
> 
> notify_change() does *not* do permission checks for 
> ATTR_CTIME/MTIME/ATIME.
> 
> It does them for the "xxx_SET" attributes, but MTIME/ATIME is expected to 
> change when other things change, so notify_change() expects that those 
> _other_ changes have been validated from a security standpoint!
> 
> utimes() is special.

This might be an acceptable patch.

Al? What do you think? Basically, it says that

 - the file owner can always set MTIME/ATIME, of course

 - non-owners can set it only when they have write permissions, and if it 
   was a file descriptor, the only way for us to know that they have write 
   permissions is if it's opened writably, which is hopefully equivalent 
   to that MAY_WRITE test (except the MAY_WRITE test was done at _open_ 
   time).

This would seem to be the minimal change, and I think it's right.

		Linus

---
 fs/utimes.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index 480f7c8..b3c8895 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -106,9 +106,16 @@ long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags
                 if (IS_IMMUTABLE(inode))
                         goto dput_and_out;
 
-		if (current->fsuid != inode->i_uid &&
-		    (error = vfs_permission(&nd, MAY_WRITE)) != 0)
-			goto dput_and_out;
+		if (current->fsuid != inode->i_uid) {
+			if (f) {
+				if (!(f->f_mode & FMODE_WRITE))
+					goto dput_and_out;
+			} else {
+				error = vfs_permission(&nd, MAY_WRITE);
+				if (error)
+					goto dput_and_out;
+			}
+		}
 	}
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
