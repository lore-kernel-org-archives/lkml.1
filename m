Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab0BXHNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:13:45 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:42102 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab0BXHNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:13:42 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 02:13:13 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=gsRNmVP6gBOWa4PfSx5Yz76nMRlTZcfckWOVemoUS1cFjrx5a8eY/+m5i08IoFTtRq
         Yc10yxJBA8wkUYMy5aHMLvHA1rheRcH6LNriONIT8KkB8EXm9V60UeAnhNx0iw6Ba5G/
         L/zPKHv1DKELMgM7HmBKn6lkqqznROGHSPSpg=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 6/6] mqueue: fix mq_open() file descriptor leak on user-space processes
Date: Tue, 23 Feb 2010 04:04:28 -0300
Message-Id: <a3a62a6cd7cc0ba011949396a1f2c7f9c32aa4b9.1266907496.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <cover.1266907495.git.andre.goddard@gmail.com>
References: <cover.1266907495.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can be triggered by the following test program:

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <mqueue.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/resource.h>

int main(int argc, char *argv[])
{
	struct rlimit limit;
	char queue_name[] = "/mq_open/bug";
	char tmp_name[]   = "/tmp/tmp";
	int fd, i = 1;

	if (getrlimit(RLIMIT_NOFILE, &limit) != 0) {
		printf("%s\n", "Failed to get RLIMIT_NOFILE");
		return EXIT_FAILURE;
	}
	printf("Max number of open files is: %d\n", limit.rlim_cur);

	while (i <= limit.rlim_cur) {
		mqd_t queue;

		errno = 0;
		queue = mq_open(queue_name, O_CREAT |O_RDWR, S_IRUSR | S_IWUSR
		    , NULL);
		if (queue != (mqd_t)-1) {
			/* Success opening mqueue, no leak will happen */
			printf("Successfully opened an mqueue[%d]\n", queue);
			printf("mq_close(%d) = %d\n", queue, mq_close(queue));
			return EXIT_SUCCESS;
		}
		/* Failed to open mqueue, maybe a leak is happening... */
		if (errno == EMFILE)
		{
			printf("\nRun out of file descriptors");
			break;
		}
		printf("\rLeaking [%d] files?!?!", i++);
		fflush(stdout);
		usleep(500);
	}
	/* Double check that no file descriptor is available anymore indeed */
	putchar('\n');
	errno = 0;
	fd = open(tmp_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
	if (fd == -1) {
		printf("open() failed: %s\n", strerror(errno));
		if (errno == EMFILE) {
			printf("%s\n", "Cannot open new files, fds exhausted");
			return EXIT_FAILURE;
		}
	} else
		printf("close(%d) = %d\n", fd, close(fd));
	printf("%s\n", "Expected output: kernel is not leaking any fds!");

	return EXIT_SUCCESS;
}

## Preparing for testing

$ touch /tmp/tmp
$ gcc -g main_mq_open_fd_leak.c -lrt

## Linux kernel with the fix applied:

$ ./a.out
Max number of open files is: 1024
Leaking [1024] files?!?!
close(3) = 0
Expected output: kernel is not leaking any fds!

## Linux kernel without the fix:

## Shell execution:

$ ./a.out
Max number of open files is: 1024
Leaking [1019] files?!?!
Run out of file descriptors
Segmentation fault

## Valgrind execution:

$ valgrind --track-fds=yes ./a.out
==2895== Memcheck, a memory error detector
==2895== Copyright (C) 2002-2009, and GNU GPL'd, by Julian Seward et al.
==2895== Using Valgrind-3.6.0.SVN and LibVEX; rerun with -h for copyright info
==2895== Command: ./a.out
==2895==
Max number of open files is: 1024
Leaking [1024] files?!?!
open() failed: Too many open files
Cannot open new files, fds exhausted
==2895==
==2895== FILE DESCRIPTORS: 5 open at exit.
==2895== Open file descriptor 13:
==2895==    <inherited from parent>
==2895==
==2895== Open file descriptor 12:
==2895==    <inherited from parent>
==2895==
==2895== Open file descriptor 2: /dev/pts/1
==2895==    <inherited from parent>
==2895==
==2895== Open file descriptor 1: /dev/pts/1
==2895==    <inherited from parent>
==2895==
==2895== Open file descriptor 0: /dev/pts/1
==2895==    <inherited from parent>
==2895==
==2895==
==2895== HEAP SUMMARY:
==2895==     in use at exit: 0 bytes in 0 blocks
==2895==   total heap usage: 0 allocs, 0 frees, 0 bytes allocated
==2895==
==2895== All heap blocks were freed -- no leaks are possible
==2895==
==2895== For counts of detected and suppressed errors, rerun with: -v
==2895== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 2 from 2)

When not running valgrind, user-space program segfaults trying to execute
strerror(errno). With valgrind, it executes successfully and prints the
5 open files: stdin, stdout, stderr, pipe[0] and pipe[1].

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 ipc/mqueue.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index e47c9eb..b6cb064 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -710,7 +710,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
 	dentry = lookup_one_len(name, ipc_ns->mq_mnt->mnt_root, strlen(name));
 	if (IS_ERR(dentry)) {
 		error = PTR_ERR(dentry);
-		goto out_err;
+		goto out_putfd;
 	}
 	mntget(ipc_ns->mq_mnt);
 
@@ -749,7 +749,6 @@ out:
 	mntput(ipc_ns->mq_mnt);
 out_putfd:
 	put_unused_fd(fd);
-out_err:
 	fd = error;
 out_upsem:
 	mutex_unlock(&ipc_ns->mq_mnt->mnt_root->d_inode->i_mutex);
-- 
1.7.0.87.g0901d

