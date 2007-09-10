Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbXIJPQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbXIJPQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 11:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759956AbXIJPQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 11:16:13 -0400
Received: from sacred.ru ([62.205.161.221]:47380 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886AbXIJPQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 11:16:13 -0400
X-Greylist: delayed 3423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Sep 2007 11:16:12 EDT
Message-ID: <46E551BD.5020404@openvz.org>
Date: Mon, 10 Sep 2007 18:16:29 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: [PATCH] Leases can be hidden by flocks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 10 Sep 2007 18:18:53 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

---

diff --git a/fs/locks.c b/fs/locks.c
index 6068f82..0db1a14 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -781,7 +781,7 @@ find_conflict:
 	if (request->fl_flags & FL_ACCESS)
 		goto out;
 	locks_copy_lock(new_fl, request);
-	locks_insert_lock(&inode->i_flock, new_fl);
+	locks_insert_lock(before, new_fl);
 	new_fl = NULL;
 	error = 0;
 
