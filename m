Return-Path: <linux-kernel-owner+w=401wt.eu-S1763563AbXJMO4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763563AbXJMO4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762086AbXJMOnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:43:00 -0400
Received: from 1wt.eu ([62.212.114.60]:3040 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762063AbXJMOm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:58 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143504.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:46 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Pavel Emelyanov <xemul@openvz.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 24/35] Leases can be hidden by flocks
Content-Disposition: inline; filename=0079-Leases-can-be-hidden-by-flocks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0e2f6db88a6900bc9db576d6b478b12ee60d61f7 in mainline.

The inode->i_flock list contains the leases, flocks and posix
locks in the specified order. However, the flocks are added in
the head of this list thus hiding the leases from F_GETLEASE
command, from time_out_leases() and other code that expects
the leases to come first.

The following example will demonstrate this:

#define _GNU_SOURCE

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/file.h>

static void show_lease(int fd)
{
        int res;

        res = fcntl(fd, F_GETLEASE);
        switch (res) {
                case F_RDLCK:
                        printf("Read lease
");
                        break;
                case F_WRLCK:
                        printf("Write lease
");
                        break;
                case F_UNLCK:
                        printf("No leases
");
                        break;
                default:
                        printf("Some shit
");
                        break;
        }
}

int main(int argc, char **argv)
{
        int fd, res;

        fd = open(argv[1], O_RDONLY);
        if (fd == -1) {
                perror("Can't open file");
                return 1;
        }

        res = fcntl(fd, F_SETLEASE, F_WRLCK);
        if (res == -1) {
                perror("Can't set lease");
                return 1;
        }

        show_lease(fd);

        if (flock(fd, LOCK_SH) == -1) {
                perror("Can't flock shared");
                return 1;
        }

        show_lease(fd);

        return 0;
}

The first call to show_lease() will show the write lease set, but
the second will show no leases.

Fix the flock adding so that the leases always stay in the head
of this list.

Found during making the flocks pid-namespaces aware.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/locks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: 2.6/fs/locks.c
===================================================================
--- 2.6.orig/fs/locks.c
+++ 2.6/fs/locks.c
@@ -790,7 +790,7 @@ find_conflict:
 	if (request->fl_flags & FL_ACCESS)
 		goto out;
 	locks_copy_lock(new_fl, request);
-	locks_insert_lock(&inode->i_flock, new_fl);
+	locks_insert_lock(before, new_fl);
 	new_fl = NULL;
 	error = 0;
 

-- 
