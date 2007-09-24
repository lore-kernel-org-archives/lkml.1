Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbXIXQee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbXIXQee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758785AbXIXQ0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:34 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47501 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760663AbXIXQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:32 -0400
Date: Mon, 24 Sep 2007 09:21:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bfields@fieldses.org,
       trond.myklebust@fys.uio.no, xemul@openvz.org
Subject: [26/50] Leases can be hidden by flocks
Message-ID: <20070924162127.GA13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="leases-can-be-hidden-by-flocks.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Pavel Emelyanov <xemul@openvz.org>

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
                        printf("Read lease\n");
                        break;
                case F_WRLCK:
                        printf("Write lease\n");
                        break;
                case F_UNLCK:
                        printf("No leases\n");
                        break;
                default:
                        printf("Some shit\n");
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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -786,7 +786,7 @@ find_conflict:
 	if (request->fl_flags & FL_ACCESS)
 		goto out;
 	locks_copy_lock(new_fl, request);
-	locks_insert_lock(&inode->i_flock, new_fl);
+	locks_insert_lock(before, new_fl);
 	new_fl = NULL;
 	error = 0;
 

-- 
