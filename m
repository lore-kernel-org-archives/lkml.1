Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbXGHRHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbXGHRHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 13:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXGHRG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 13:06:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbXGHRG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 13:06:58 -0400
Message-ID: <469119A3.6030409@redhat.com>
Date: Sun, 08 Jul 2007 10:06:43 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer	dereference
 - git-bisect result
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org> <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de>
In-Reply-To: <20070708152808.GA5902@gentoox2.trippelsdorf.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Markus Trippelsdorf wrote:
> I tested this further and it turned out that the Linus tree is also
> affected. So I ran git-bisect, after I found out that version
> 2.6.21.6 was not affected by this bug.

Try this patch.  The vfs_permission test can be skipped since the VFS
isn't involved.  We got the inode etc from a file descriptor.


Signed-Off-By: Ulrich Drepper <drepper@redhat.com>

diff --git a/fs/utimes.c b/fs/utimes.c
index 480f7c8..873edcb 100644
- --- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -106,7 +106,8 @@ long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags
                 if (IS_IMMUTABLE(inode))
                         goto dput_and_out;

- -               if (current->fsuid != inode->i_uid &&
+               if (f == NULL &&
+                   current->fsuid != inode->i_uid &&
                    (error = vfs_permission(&nd, MAY_WRITE)) != 0)
                        goto dput_and_out;
        }


- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGkRmj2ijCOnn/RHQRAkuyAJ41CIDhT8yKb6SKX14ylFXznO6gfwCfdtEo
4Gt9hPsotmKddwE2xdYkJmQ=
=JyVn
-----END PGP SIGNATURE-----
