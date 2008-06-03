Return-Path: <linux-kernel-owner+w=401wt.eu-S1759778AbYFCW0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbYFCW0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758818AbYFCWZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:25:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:19831 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804AbYFCWZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=Yq5x7+ekKiN5XMA14uduWjTjLQZUhYBencdwTE9PXIZVu8vSssXOOqgrsnSfNl3uZcqcq5C2bjk4eUZLDVoBdMi+zgEpjAmJWWGtOchd0Un6MjSgDC1josrwBcOlZuLdqqdPIR3oYh2fCfFuC5dddUe5SrQ26sRxhclpHyVF8yY=
Message-ID: <4845C4D2.8050408@gmail.com>
Date: Wed, 04 Jun 2008 00:25:22 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [parch 4/4] vfs: utimensat(): fix write access check for futimens()
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

CC: Miklos Szeredi <miklos@szeredi.hu>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

--- linux-2.6.26-rc4/fs/utimes.c	2008-06-03 23:13:31.000000000 +0200
+++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c	2008-06-03 23:15:12.000000000 +0200
@@ -137,7 +137,8 @@

 		if (!is_owner_or_cap(inode)) {
 			if (f) {
-				if (!(f->f_mode & FMODE_WRITE))
+				error = permission(inode, MAY_WRITE, NULL);
+				if (error)
 					goto mnt_drop_write_and_out;
 			} else {
 				error = vfs_permission(&nd, MAY_WRITE);

