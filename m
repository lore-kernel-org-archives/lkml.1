Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbYEPIfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbYEPIfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYEPIfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:35:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:58314 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYEPIfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=qo2lbsLonRtZshLhL7AKKzxX/TkW+fLazVxGtPFfN/cg2gx7DxV2AHa6Y4qGWPykMQJfZovFtEkej0Ts09Wzix1rjz7XKFxZ722SprBxJlpF8jJVOecE6afonoM/LOcremEHJ4zk0Rdi3f93BMA0rKmat39SO/dgcEF+ewkKrtY=
Message-ID: <482D4717.3030105@gmail.com>
Date: Fri, 16 May 2008 10:34:31 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, Ulrich Drepper <drepper@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] utimensat() non-conformances and fixes -- version 2
References: <482D4665.4050401@gmail.com>
In-Reply-To: <482D4665.4050401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For completeness here's the test program again:

/* t_utimensat.c

   Copyright (C) 2008, Michael Kerrisk <mtk.manpages@gmail.com>

   Licensed under the GPLv2 or later.

   A command-line interface for testing the utimensat() system
   call.

   17 Mar 2008  Initial creation
*/
#define _GNU_SOURCE
#define _ATFILE_SOURCE
#include <stdio.h>
#include <time.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <fcntl.h>
#include <string.h>
#include <sys/stat.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)


#define __NR_utimensat          320     /* x86 syscall number */

# define UTIME_NOW      ((1l << 30) - 1l)
# define UTIME_OMIT     ((1l << 30) - 2l)

static inline int
utimensat(int dirfd, const char *pathname,
          const struct timespec times[2], int flags)
{
    return syscall(__NR_utimensat, dirfd, pathname, times, flags);
}

static void
usageError(char *progName)
{
    fprintf(stderr, "Usage: %s pathname [atime-sec "
            "atime-nsec mtime-sec mtime-nsec]\n\n", progName);
    fprintf(stderr, "Permitted options are:\n");
    fprintf(stderr, "    [-d path] "
            "open a directory file descriptor"
            " (instead of using AT_FDCWD)\n");
    fprintf(stderr, "    -w        Open directory file "
            "descriptor with O_RDWR (instead of O_RDONLY)\n");
    fprintf(stderr, "    -n        Use AT_SYMLINK_NOFOLLOW\n");
    fprintf(stderr, "\n");

    fprintf(stderr, "pathname can be \"NULL\" to use NULL "
            "argument in call\n");
    fprintf(stderr, "\n");

    fprintf(stderr, "Either nsec field can be\n");
    fprintf(stderr, "    'n' for UTIME_NOW\n");
    fprintf(stderr, "    'o' for UTIME_OMIT\n");
    fprintf(stderr, "\n");

    fprintf(stderr, "If the time fields are omitted, "
            "then a NULL 'times' argument is used\n");
    fprintf(stderr, "\n");

    exit(EXIT_FAILURE);
}

int
main(int argc, char *argv[])
{
    int flags, dirfd, opt, oflag;
    struct timespec ts[2];
    struct timespec *tsp;
    char *pathname, *dirfdPath;
    struct stat sb;

    flags = 0;
    dirfd = AT_FDCWD;
    dirfdPath = NULL;
    oflag = O_RDONLY;

    while ((opt = getopt(argc, argv, "d:nw")) != -1) {
        switch (opt) {
        case 'd':
            dirfdPath = optarg;
            break;

        case 'n':
            flags |= AT_SYMLINK_NOFOLLOW;
            printf("Not following symbolic links\n");
            break;

        case 'w':
            oflag = O_RDWR;
            break;

        default:
            usageError(argv[0]);
        }
    }

    if ((optind + 5 != argc) && (optind + 1 != argc))
        usageError(argv[0]);

    if (dirfdPath != NULL) {
        dirfd = open(dirfdPath, oflag);
        if (dirfd == -1) errExit("open");

        printf("Opened dirfd");
        printf(" O_RDWR");
        printf(": %s\n", dirfdPath);
    }

    pathname = (strcmp(argv[optind], "NULL") == 0) ?
                        NULL : argv[optind];

    if (argc == optind + 1) {
        tsp = NULL;

    } else {
        ts[0].tv_sec = atoi(argv[optind + 1]);
        if (argv[optind + 2][0] == 'n') {
            ts[0].tv_nsec = UTIME_NOW;
        } else if (argv[optind + 2][0] == 'o') {
            ts[0].tv_nsec = UTIME_OMIT;
        } else {
            ts[0].tv_nsec = atoi(argv[optind + 2]);
        }

        ts[1].tv_sec = atoi(argv[optind + 3]);
        if (argv[optind + 4][0] == 'n') {
            ts[1].tv_nsec = UTIME_NOW;
        } else if (argv[optind + 4][0] == 'o') {
            ts[1].tv_nsec = UTIME_OMIT;
        } else {
            ts[1].tv_nsec = atoi(argv[optind + 4]);
        }

        tsp = ts;
    }

    /* For testing purposes, it may have been useful to run this
       program as set-user-ID-root so that a directory file
       descriptor could be opened as root.  Now we reset to the
       real UID before making the utimensat() call, so that the
       permission checking is performed under that UID. */

    if (geteuid() == 0) {
        uid_t u;

        u = getuid();

        printf("Resettng UIDs to %ld\n", (long) u);

        if (setresuid(u, u, u) == -1)
            errExit("setresuid");
    }

    printf("dirfd is %d\n", dirfd);
    printf("pathname is %s\n", pathname);
    printf("tsp is %p", tsp);
    if (tsp != NULL) {
        printf("; struct  = { %ld, %ld } { %ld, %ld }",
                (long) tsp[0].tv_sec, (long) tsp[0].tv_nsec,
                (long) tsp[1].tv_sec, (long) tsp[1].tv_nsec);
    }
    printf("\n");
    printf("flags is %d\n", flags);

    if (utimensat(dirfd, pathname, tsp, flags) == -1) {
        if (errno == EPERM)
            printf("utimensat failed with EPERM\n");
        else if (errno == EACCES)
            printf("utimensat failed with EACCES\n");
        else
            perror("utimensat");
        exit(EXIT_FAILURE);
    }

    printf("utimensat() succeeded\n");

    if (stat(pathname, &sb) == -1) errExit("stat");
    printf("Last file access:         %s", ctime(&sb.st_atime));
    printf("Last file modification:   %s", ctime(&sb.st_mtime));
    printf("Last status change:       %s", ctime(&sb.st_ctime));

    exit(EXIT_SUCCESS);
}

