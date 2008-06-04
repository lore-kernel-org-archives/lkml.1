Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbYFDNOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbYFDNOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYFDNOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:14:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:64748 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314AbYFDNOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=IsxLDMtq4Nrb8q6fmKwsDOxQWpxNBzI2uMHMVJnhf9wKs1kiIrVjQhkKkadwt3apYi
         9u5e1AMiRFSbnEXtqMhCy6N5fCZggPlBrkav8rdAUiz5mU9+gg9oRI6Z51Pz9UFAF1e1
         vOhNtY48g09nqopDa8gIohSBff8Te7GdtQbPs=
Message-ID: <484694F9.5090501@gmail.com>
Date: Wed, 04 Jun 2008 15:13:29 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [patch 4/4 v2] vfs: utimensat(): fix write access check for futimens()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The POSIX.1 draft spec for futimens()/utimensat() says:

        Only a process with the effective user ID equal to the
        user ID of the file, *or with write access to the file*,
        or with appropriate privileges may use futimens() or
        utimensat() with a null pointer as the times argument
        or with both tv_nsec fields set to the special value
        UTIME_NOW.

The important piece here is "with write access to the file", and
this matters for futimens(), which deals with an argument that
is a file descriptor referring to the file whose timestamps are
being updated,  The standard is saying that the "writability"
check is based on the file permissions, not the access mode with
which the file is opened.  (This behavior is consistent with the
semantics of FreeBSD's futimes().)  However, Linux is currently
doing the latter -- futimens(fd, times) is a library
function implemented as

       utimensat(fd, NULL, times, 0)

and within the utimensat() implementation we have the code:

                f = fget(dfd);  // dfd is 'fd'
                ...
                if (f) {
                        if (!(f->f_mode & FMODE_WRITE))
                                goto mnt_drop_write_and_out;

The check should instead be based on the file permissions.

Thanks to Miklos for pointing out how to do this check.
Miklos also pointed out a simplification that could be
made to my first version of this patch, since the checks
for the pathname and file descriptor cases can now be
conflated.

CC: Miklos Szeredi <miklos@szeredi.hu>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>


--- linux-2.6.26-rc4/fs/utimes.c	2008-06-04 13:38:11.000000000 +0200
+++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c	2008-06-04 13:39:02.000000000 +0200
@@ -148,14 +148,9 @@
 			goto mnt_drop_write_and_out;

 		if (!is_owner_or_cap(inode)) {
-			if (f) {
-				if (!(f->f_mode & FMODE_WRITE))
-					goto mnt_drop_write_and_out;
-			} else {
-				error = vfs_permission(&nd, MAY_WRITE);
-				if (error)
-					goto mnt_drop_write_and_out;
-			}
+			error = permission(inode, MAY_WRITE, NULL);
+			if (error)
+				goto mnt_drop_write_and_out;
 		}
 	}
 	mutex_lock(&inode->i_mutex);

