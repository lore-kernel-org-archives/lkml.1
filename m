Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbXGWGM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbXGWGM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXGWGMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:12:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182AbXGWGMU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:12:20 -0400
Date: Sun, 22 Jul 2007 23:12:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?IkouQS4gTWFnYWxs824i?= <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops with touch and unknown uid [was Re: 2.6.22-rc6-mm1]
Message-Id: <20070722231202.b1c4471f.akpm@linux-foundation.org>
In-Reply-To: <20070722234814.0f792452@werewolf-wl>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070722234814.0f792452@werewolf-wl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 23:48:14 +0200 "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Thu, 28 Jun 2007 03:43:21 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
> > 
> 
> I have noticed a funny problem.
> Lets say 666 is not an uid used on you system. This oopses:
> 
> rm -f dummy
> touch dummy
> chown 666 dummy
> touch dummy

Does Linus's fix fix it?

commit 1e5de2837c166535f9bb4232bfe97ea1f9fc7a1c
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Sun Jul 8 12:02:55 2007 -0700

    Fix permission checking for the new utimensat() system call
    
    Commit 1c710c896eb461895d3c399e15bb5f20b39c9073 added the utimensat()
    system call, but didn't handle the case of checking for the writability
    of the target right, when the target was a file descriptor, not a
    filename.
    
    We cannot use vfs_permission(MAY_WRITE) for that case, and need to
    simply check whether the file descriptor is writable.  The oops from
    using the wrong function was noticed and narrowed down by Markus
    Trippelsdorf.
    
    Cc: Ulrich Drepper <drepper@redhat.com>
    Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Acked-by: Al Viro <viro@ftp.linux.org.uk>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/utimes.c b/fs/utimes.c
index 480f7c8..b3c8895 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -106,9 +106,16 @@ long do_utimes(int dfd, char __user *fil
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

