Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYFCUPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYFCUPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYFCUPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:15:11 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:25743 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYFCUPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:from;
        b=vSJ96qUeadHfCiBUq5lFxMy9S1kjT4JQT1W1S/jgsVIH7X05Ysf0C56fTut5qmO1asNa1reDg7wx18LvtS4u6AoktJns4Y6VzeSofv67hrJxCYeSLRa4Oc51PONQ2A+hNBkR4klYLxQe8dmeNu0zJZNYj+qfZDJY6cjN7g6YZJQ=
Message-ID: <4845A625.9000607@gmail.com>
Date: Tue, 03 Jun 2008 22:14:29 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michael Kerrisk <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: utimensat() non-conformances and fixes [v4] (test suite)
References: <48454F1D.6060507@gmail.com>
In-Reply-To: <48454F1D.6060507@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060106000602030705020700"
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060106000602030705020700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew,

Attached are two files:

test_utimensat.c
a program that can be used to perform command-line-driven tests
of most aspects of the operation of utimensat().

utimensat_tests.sh
a shell script that uses the preceding C program to perform
a battery of tests against utimensat().

Cheers,

Michael



--------------060106000602030705020700
Content-Type: text/x-csrc;
 name="test_utimensat.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test_utimensat.c"

/* test_utimensat.c

   Copyright (C) 2008, Michael Kerrisk <mtk.manpages@gmail.com>
   and Copyright (C) 2008, Linux Foundation

   Licensed under the GPLv2 or later.
  
   A command-line interface for testing the utimensat() system call.

   17 Mar 2008  Initial creation.
   31 May 2008  Reworked for easier test automation.
    2 Jun 2008  Renamed from t_utimensat.c to test_utimensat.c.
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

/* We use EXIT_FAILURE for an expected failure from utimensat()
   (e.g., EACCES and EPERM), and one of the following for unexpected
   failures (i.e., something broke in our test setup). */

#define EXIT_bad_usage 3
#define EXIT_failed_syscall 3

#define errExit(msg)    do { perror(msg); exit(EXIT_failed_syscall); \
                        } while (0)


#define __NR_utimensat          320     /* x86 syscall number */

# define UTIME_NOW      ((1l << 30) - 1l)
# define UTIME_OMIT     ((1l << 30) - 2l)

static inline int
utimensat_sc(int dirfd, const char *pathname,
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
    fprintf(stderr, "    -q        Quiet\n");
    fprintf(stderr, "    -w        Open directory file "
            "descriptor with O_RDWR|O_APPEND\n"
            "              (instead of O_RDONLY)\n");
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

    exit(EXIT_bad_usage);
}

int
main(int argc, char *argv[])
{
    int flags, dirfd, opt, oflag;
    struct timespec ts[2];
    struct timespec *tsp;
    char *pathname, *dirfdPath;
    struct stat sb;
    int verbose;

    /* Command-line argument parsing */

    flags = 0;
    verbose = 1;
    dirfd = AT_FDCWD;
    dirfdPath = NULL;
    oflag = O_RDONLY;

    while ((opt = getopt(argc, argv, "d:nqw")) != -1) {
        switch (opt) {
        case 'd':
            dirfdPath = optarg;
            break;

        case 'n':
            flags |= AT_SYMLINK_NOFOLLOW;
            if (verbose)
                printf("Not following symbolic links\n");
            break;

        case 'q':
            verbose = 0;
            break;

        case 'w':
            oflag = O_RDWR | O_APPEND;
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

        if (verbose) {
            printf("Opened dirfd %d", oflag);
            if ((oflag & O_ACCMODE) == O_RDWR)
                printf(" O_RDWR");
            if (oflag & O_APPEND)
                printf(" O_APPEND");
            printf(": %s\n", dirfdPath);
        }
    }

    pathname = (strcmp(argv[optind], "NULL") == 0) ?
                        NULL : argv[optind];

    /* Either, we get no values for 'times' fields, in which case
       we give a NULL pointer to utimensat(), or we get four values,
       for secs+nsecs for each of atime and mtime.  The special
       values 'n' and 'o' can be used for tv_nsec settings of
       UTIME_NOW and UTIME_OMIT, respectively. */

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

    /* For testing purposes, it may have been useful to run this program
       as set-user-ID-root so that a directory file descriptor could be
       opened as root.  (This allows us to obtain a file descriptor even
       if normal user doesn't have permissions on the file.)  Now we
       reset to the real UID before making the utimensat() call, so that
       the permission checking for the utimensat() call is performed
       under that UID. */

    if (geteuid() == 0) {
        uid_t u;

        u = getuid();

        if (verbose)
            printf("Resetting UIDs to %ld\n", (long) u);

        if (setresuid(u, u, u) == -1)
            errExit("setresuid");
    }

    /* Display information allowing user to verify arguments for call */ 

    if (verbose) {
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
    }

    /* Make the call and see what happened */

    if (utimensat_sc(dirfd, pathname, tsp, flags) == -1) {
        if (errno == EPERM) {
            if (verbose)
                printf("utimensat() failed with EPERM\n");
            else
                printf("EPERM\n");
            exit(EXIT_FAILURE);

        } else if (errno == EACCES) {
            if (verbose)
                printf("utimensat() failed with EACCES\n");
            else
                printf("EACCES\n");
            exit(EXIT_FAILURE);

        } else if (errno == EINVAL) {
            if (verbose)
                printf("utimensat() failed with EINVAL\n");
            else
                printf("EINVAL\n");
            exit(EXIT_FAILURE);

        } else {        /* Unexpected failure case from utimensat() */
            errExit("utimensat");
        }
    }

    if (verbose)
        printf("utimensat() succeeded\n");

    if (stat((pathname != NULL) ? pathname : dirfdPath, &sb) == -1)
        errExit("stat");

    if (verbose) {
        printf("Last file access:         %s", ctime(&sb.st_atime));
        printf("Last file modification:   %s", ctime(&sb.st_mtime));
        printf("Last status change:       %s", ctime(&sb.st_ctime));

    } else {
        printf("SUCCESS %ld %ld\n", (long) sb.st_atime, (long) sb.st_mtime);
    }

    exit(EXIT_SUCCESS);
}


--------------060106000602030705020700
Content-Type: application/x-shellscript;
 name="utimensat_tests.sh"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="utimensat_tests.sh"

IyEvYmluL3NoCiMKIyBBdXRvbWF0ZWQgdGVzdHMgZm9yIHV0aW1lbnNhdCgpCiMKIyBDb3B5
cmlnaHQgKEMpIDIwMDgsIExpbnV4IEZvdW5kYXRpb24KIyBXcml0dGVuIGJ5IE1pY2hhZWwg
S2VycmlzayA8bXRrLm1hbnBhZ2VzQGdtYWlsLmNvbT4KIyBMaWNlbnNlZCB1bmRlciBHUEx2
MiBvciBsYXRlcgojCiMgTm90ICh5ZXQpIGluY2x1ZGVkIGluIHRoaXMgYXV0b21hdGVkIHRl
c3Qgc2V0OgojICogQVRfU1lNTElOS19OT0ZPTExPVyBpbiBmbGFnczogSWYgcGF0aG5hbWUg
c3BlY2lmaWVzIGEgc3ltYm9saWMgbGluaywKIyAgIHRoZW4gdXBkYXRlIHRoZSB0aW1lc3Rh
bXBzIG9mIHRoZSBsaW5rLCByYXRoZXIgdGhhbiB0aGUgZmlsZSB0byB3aGljaAojICAgaXQg
cmVmZXJzLgojICogU2V0dGluZyBvZiBuYW5vc2Vjb25kIGNvbXBvbmVudHMgb2YgdGltZXN0
YW1wcyAoc3VwcG9ydCBmb3IKIyAgIG5hbm9zZWNvbmQgdGltZXN0YW1wcyBpcyBmaWxlLXN5
c3RlbS1kZXBlbmRlbnQpCiMgKiAiVXBkYXRlZCBmaWxlIHRpbWVzdGFtcHMgYXJlIHNldCB0
byB0aGUgZ3JlYXRlc3QgdmFsdWUgc3VwcG9ydGVkCiMgICBieSB0aGUgZmlsZSBzeXN0ZW0g
dGhhdCBpcyBub3QgZ3JlYXRlciB0aGFuIHRoZSBzcGVjaWZpZWQgdGltZS4iCiMgICAoaS5l
LiwgaWYgd2Ugc2V0IHRpbWVzdGFtcCB0byB7MCwgOTk5OTk5OTk5fSwgdGhlbiB0aGUgc2V0
dGluZwojICAgaXMgcm91bmRlZCBkb3duLCByYXRoZXIgdGhhbiB1cCwgdG8gdW5pdCBvZiB0
aW1lc3RhbXAgcmVzb2x1dGlvbi4KIyAqIFByaXZpbGVnZWQgcHJvY2Vzc2VzIHNob3VsZCBi
ZSBhYmxlIHRvIGJ5cGFzcyBwZXJtaXNzaW9uIGNoZWNrcy4KIyAgIChleGNlcHQgd2hlbiBm
aWxlIGlzIG1hcmtlZCB3aXRoIHRoZSAiSW1tdXRhYmxlIiBFRkEpLgoKIz09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQoKClJFU1VMVF9GSUxFPS90bXAvdXRpbWVuc2F0LnJlc3VsdAoKVEVTVF9ESVI9L3Rt
cC91dGltZW5zYXRfdGVzdHMKRklMRT0kVEVTVF9ESVIvdXRpbWVuc2F0LnRlc3RfZmlsZQoK
VEVTVF9QUk9HPS4vdGVzdF91dGltZW5zYXQKCiMgU3VtbWFyeSBjb3VudGVycyBvZiBhbGwg
dGVzdCByZXN1bHRzCgp0ZXN0X251bT0wCmZhaWxlZF9jbnQ9MApwYXNzZWRfY250PTAKZmFp
bGVkX2xpc3Q9IiIKCiM9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KCmZ1bmN0aW9uIHNldHVwX2ZpbGUoKQp7
CiMgJDEgaXMgdGVzdCBmaWxlIHBhdGhuYW1lCiMgJDIgaXMgb3duZXIgZm9yIHRlc3QgZmls
ZSAoY2hvd24oMSkpCiMgJDMgaXMgcGVybWlzc2lvbnMgZm9yIHRlc3QgZmlsZSAoY2htb2Qo
MSkpCiMgJDQgaXMgImV4dDIiIGV4dGVuZGVkIGZpbGUgYXR0cmlidXRlcyBmb3IgdGVzdCBm
aWxlIChjaGF0dHIoMSkpCgogICAgRklMRT0kMQoKICAgICMgTWFrZSBzdXJlIGFueSBvbGQg
dmVyaW9uIG9mIGZpbGUgaXMgZGVsZXRlZAoKICAgIGlmIHRlc3QgLWUgJEZJTEU7IHRoZW4K
ICAgICAgICBzdWRvIGNoYXR0ciAtYWkgJEZJTEUKICAgICAgICBzdWRvIHJtIC1mICRGSUxF
CiAgICBmaQoKICAgICMgQ3JlYXRlIGZpbGUgYW5kIG1ha2UgYXRpbWUgYW5kIG10aW1lIHpl
cm8uCgogICAgdG91Y2ggJEZJTEUKICAgIGlmICEgJFRFU1RfUFJPRyAtcSAkRklMRSAwIDAg
MCAwID4gJFJFU1VMVF9GSUxFOyB0aGVuCiAgICAgICAgZWNobyAiRmFpbGVkIHRvIHNldCB1
cCB0ZXN0IGZpbGUgJEZJTEUiIDE+JjIKICAgICAgICBleGl0IDEKICAgIGZpCgogICAgcmVh
ZCByZXMgYXRpbWUgbXRpbWUgPCAkUkVTVUxUX0ZJTEUKICAgIGlmIHRlc3QgIlgkcmVzIiAh
PSAiWFNVQ0NFU1MiIHx8CiAgICAgICAgICAgICAgICB0ZXN0ICRhdGltZSAtbmUgMCB8fCB0
ZXN0ICRtdGltZSAhPSAwOyB0aGVuCiAgICAgICAgZWNobyAiRmFpbGVkIHRvIHNldCBjb3Jy
ZWN0IHRpbWVzIG9uIHRlc3QgZmlsZSAkRklMRSIgMT4mMgogICAgICAgIGV4aXQgMQogICAg
ZmkKCiAgICAjIFNldCBvd25lciwgcGVybWlzc2lvbnMsIGFuZCBFRkFzIGZvciBmaWxlLgoK
ICAgIGlmIHRlc3QgLW4gIiQyIjsgdGhlbgogICAgICAgIHN1ZG8gY2hvd24gJDIgJEZJTEUK
ICAgIGZpCiAgICAKICAgIHN1ZG8gY2htb2QgJDMgJEZJTEUKCiAgICBpZiB0ZXN0IC1uICIk
NCI7IHRoZW4KICAgICAgICBzdWRvIGNoYXR0ciAkNCAkRklMRQogICAgZmkKCiAgICAjIERp
c3BsYXkgZmlsZSBzZXR1cCwgZm9yIHZpc3VhbCB2ZXJpZmljYXRpb24KCiAgICBscyAtbCAk
RklMRSB8IGF3ayAneyBwcmludGYgIk93bmVyPSVzOyBwZXJtcz0lczsgIiwgJDMsICQxfScK
ICAgIHN1ZG8gbHNhdHRyIC1sICRGSUxFIHwgc2VkICdzLywgLywvZycgfCBhd2sgJ3twcmlu
dCAiRUZBcz0iICQyfScKfQoKZnVuY3Rpb24gdGVzdF9mYWlsZWQoKQp7CiAgICBlY2hvICJG
QUlMRUQgdGVzdCAkdGVzdF9udW0iCgogICAgZmFpbGVkX2NudD0kKGV4cHIgJGZhaWxlZF9j
bnQgKyAxKQogICAgZmFpbGVkX2xpc3Q9IiRmYWlsZWRfbGlzdCAkdGVzdF9udW0iCn0KCmZ1
bmN0aW9uIGNoZWNrX3Jlc3VsdCgpCnsKICAgIFNUQVRVUz0kMSAgICAgICAgICAgICAgICAg
ICAjIEV4aXQgc3RhdHVzIGZyb20gdGVzdCBwcm9ncmFtCiAgICBFWFBFQ1RFRF9SRVNVTFQ9
JDIgICAgICAgICAgIyBTVUNDRVNTIC8gRUFDQ0VTIC8gRVBFUk0gLyBFSU5WQUwKICAgIEVY
UEVDVF9BVElNRV9DSEFOR0VEPSQzICAgICAjIFNob3VsZCBiZSAneScgb3IgJ24nIChvbmx5
IGZvciBTVUNDRVNTKQogICAgRVhQRUNUX01USU1FX0NIQU5HRUQ9JDQgICAgICMgU2hvdWxk
IGJlICd5JyBvciAnbicgKG9ubHkgZm9yIFNVQ0NFU1MpCgogICAgdGVzdF9udW09JChleHBy
ICR0ZXN0X251bSArIDEpCgogICAgIyBJZiBvdXIgdGVzdCBzZXR1cCBmYWlsZWQsIHN0b3Ag
aW1tZWRpYXRlbHkKCiAgICBpZiB0ZXN0ICRTVEFUVVMgLWd0IDE7IHRoZW4KICAgICAgICBl
Y2hvICJGQUlMRUQgKGJhZCB0ZXN0IHNldHVwKSIKICAgICAgICBleGl0IDEKICAgIGZpCgog
ICAgcmVhZCByZXMgYXRpbWUgbXRpbWUgPCAkUkVTVUxUX0ZJTEUKICAgIAogICAgZWNobyAi
RVhQRUNURUQ6ICRFWFBFQ1RFRF9SRVNVTFQgJEVYUEVDVF9BVElNRV9DSEFOR0VEICJcCiAg
ICAgICAgICIkRVhQRUNUX01USU1FX0NIQU5HRUQiCiAgICBlY2hvICJSRVNVTFQ6ICAgJHJl
cyAkYXRpbWUgJG10aW1lIgoKICAgIGlmIHRlc3QgIiRyZXMiICE9ICIkRVhQRUNURURfUkVT
VUxUIjsgdGhlbgogICAgICAgIHRlc3RfZmFpbGVkCiAgICAgICAgcmV0dXJuCiAgICBmaQog
ICAgCiAgICBwYXNzZWQ9MQoKICAgICMgSWYgdGhlIHRlc3QgcHJvZ3JhbSBleGl0ZWQgc3Vj
Y2Vzc2Z1bGx5LCB0aGVuIGNoZWNrIHRoYXQgYXRpbWUgYW5kCiAgICAjIGFuZCBtdGltZSB3
ZXJlIHVwZGF0ZWQgLyBub3QgdXBkYXRlZCwgYXMgZXhwZWN0ZWQuCgogICAgaWYgdGVzdCAk
RVhQRUNURURfUkVTVUxUID0gIlNVQ0NFU1MiOyB0aGVuCiAgICAgICAgaWYgdGVzdCAkRVhQ
RUNUX0FUSU1FX0NIQU5HRUQgPSAieSI7IHRoZW4KICAgICAgICAgICAgaWYgdGVzdCAkYXRp
bWUgLWVxIDA7IHRoZW4KICAgICAgICAgICAgICAgIGVjaG8gImF0aW1lIHNob3VsZCBoYXZl
IGNoYW5nZWQsIGJ1dCBkaWQgbm90IgogICAgICAgICAgICAgICAgcGFzc2VkPTAKICAgICAg
ICAgICAgZmkKICAgICAgICBlbHNlCiAgICAgICAgICAgIGlmIHRlc3QgJGF0aW1lIC1uZSAw
OyB0aGVuCiAgICAgICAgICAgICAgICBlY2hvICJhdGltZSBzaG91bGQgbm90IGhhdmUgY2hh
bmdlZCwgYnV0IGRpZCIKICAgICAgICAgICAgICAgIHBhc3NlZD0wCiAgICAgICAgICAgIGZp
CiAgICAgICAgZmkKICAgIAogICAgICAgIGlmIHRlc3QgJEVYUEVDVF9NVElNRV9DSEFOR0VE
ID0gInkiOyB0aGVuCiAgICAgICAgICAgIGlmIHRlc3QgJG10aW1lIC1lcSAwOyB0aGVuCiAg
ICAgICAgICAgICAgICBlY2hvICJtdGltZSBzaG91bGQgaGF2ZSBjaGFuZ2VkLCBidXQgZGlk
IG5vdCIKICAgICAgICAgICAgICAgIHBhc3NlZD0wCiAgICAgICAgICAgIGZpCiAgICAgICAg
ZWxzZQogICAgICAgICAgICBpZiB0ZXN0ICRtdGltZSAtbmUgMDsgdGhlbgogICAgICAgICAg
ICAgICAgZWNobyAibXRpbWUgc2hvdWxkIG5vdCBoYXZlIGNoYW5nZWQsIGJ1dCBkaWQiCiAg
ICAgICAgICAgICAgICBwYXNzZWQ9MAogICAgICAgICAgICBmaQogICAgICAgIGZpCiAgICAK
ICAgICAgICBpZiB0ZXN0ICRwYXNzZWQgLWVxIDA7IHRoZW4KICAgICAgICAgICAgdGVzdF9m
YWlsZWQKICAgICAgICAgICAgcmV0dXJuCiAgICAgICAgZmkKICAgIGZpCgogICAgcGFzc2Vk
X2NudD0kKGV4cHIgJHBhc3NlZF9jbnQgKyAxKQogICAgZWNobyAiUEFTU0VEIHRlc3QgJHRl
c3RfbnVtIgp9CgpmdW5jdGlvbiBydW5fdGVzdCgpCnsKICAgICMgQnkgZGVmYXVsdCwgd2Ug
ZG8gdGhyZWUgdHlwZXMgb2YgdGVzdDoKICAgICMgYSkgcGF0aG5hbWUgKHBhdGhuYW1lICE9
IE5VTEwpCiAgICAjIGIpIHJlYWRhYmxlIGZpbGUgZGVzY3JpcHRvciAocGF0aG5hbWUgPT0g
TlVMTCwgZGlyZmQgb3BlbmVkIE9fUkRPTkxZKQogICAgIyBjKSB3cml0YWJsZSBmaWxlIGRl
c2NyaXB0b3IgKHBhdGhuYW1lID09IE5VTEwsIGRpcmZkIG9wZW5lZCBPX1JEV1IpLgogICAg
IyAgICBGb3IgdGhpcyBjYXNlIHdlIGFsc28gaW5jbHVlIE9fQVBQRU5EIGluIG9wZW4gZmxh
Z3MsIHNpbmNlIHRoYXQKICAgICMgICAgaXMgbmVlZGVkIGlmIHRlc3Rpbmcgd2l0aCBhIGZp
bGUgdGhhdCBoYXMgdGhlIEFwcGVuZC1vbmx5CiAgICAjICAgIGF0dHJpYnV0ZSBlbmFibGVk
LgoKICAgICMgLVIgc2F5cyBkb24ndCBkbyB0ZXN0cyB3aXRoIHJlYWRhYmxlIGZpbGUgZGVz
Y3JpcHRvcgogICAgIyAtVyBzYXlzIGRvbid0IGRvIHRlc3RzIHdpdGggd3JpdGFibGUgZmls
ZSBkZXNjcmlwdG9yCgogICAgT1BUSU5EPTEKCiAgICBkb19yZWFkX2ZkX3Rlc3Q9MQogICAg
ZG9fd3JpdGVfZmRfdGVzdD0xCiAgICB3aGlsZSBnZXRvcHRzICJSVyIgb3B0OyBkbwogICAg
ICAgIGNhc2UgIiRvcHQiIGluCiAgICAgICAgUikgZG9fcmVhZF9mZF90ZXN0PTAKICAgICAg
ICAgICA7OwogICAgICAgIFcpIGRvX3dyaXRlX2ZkX3Rlc3Q9MAogICAgICAgICAgIDs7CiAg
ICAgICAgKikgZWNobyAicnVuX3Rlc3Q6IGJhZCB1c2FnZSIKICAgICAgICAgICBleGl0IDEK
ICAgICAgICAgICA7OwogICAgICAgIGVzYWMKICAgIGRvbmUKICAgIHNoaWZ0IGBleHByICRP
UFRJTkQgLSAxYAoKICAgIGVjaG8gIlBhdGhuYW1lIHRlc3QiCiAgICBzZXR1cF9maWxlICRG
SUxFICIkMSIgIiQyIiAiJDMiCiAgICBDTUQ9IiRURVNUX1BST0cgLXEgJEZJTEUgJDQiCiAg
ICBlY2hvICIkQ01EIgogICAgJENNRCA+ICRSRVNVTFRfRklMRQogICAgY2hlY2tfcmVzdWx0
ICQ/ICQ1ICQ2ICQ3CiAgICBlY2hvCgogICAgaWYgdGVzdCAkZG9fcmVhZF9mZF90ZXN0IC1u
ZSAwOyB0aGVuCiAgICAgICAgZWNobyAiUmVhZGFibGUgZmlsZSBkZXNjcmlwdG9yIChmdXRp
bWVucygzKSkgdGVzdCIKICAgICAgICBzZXR1cF9maWxlICRGSUxFICIkMSIgIiQyIiAiJDMi
CiAgICAgICAgQ01EPSIkVEVTVF9QUk9HIC1xIC1kICRGSUxFIE5VTEwgJDQiCiAgICAgICAg
ZWNobyAiJENNRCIKICAgICAgICAkQ01EID4gJFJFU1VMVF9GSUxFCiAgICAgICAgY2hlY2tf
cmVzdWx0ICQ/ICQ1ICQ2ICQ3CiAgICAgICAgZWNobwogICAgZmkKCiAgICAjIENhbid0IGRv
IHRoZSB3cml0YWJsZSBmaWxlIGRlc2NyaXB0b3IgdGVzdCBmb3IgaW1tdXRhYmxlIGZpbGVz
CiAgICAjIChldmVuIHJvb3QgY2FuJ3Qgb3BlbiBhbiBpbW11dGFibGUgZmlsZSBmb3Igd3Jp
dGluZykgCgogICAgaWYgdGVzdCAkZG9fd3JpdGVfZmRfdGVzdCAtbmUgMDsgdGhlbgogICAg
ICAgIGVjaG8gIldyaXRhYmxlIGZpbGUgZGVzY3JpcHRvciAoZnV0aW1lbnMoMykpIHRlc3Qi
CiAgICAgICAgc2V0dXBfZmlsZSAkRklMRSAiJDEiICIkMiIgIiQzIgogICAgICAgIENNRD0i
JFRFU1RfUFJPRyAtcSAtdyAtZCAkRklMRSBOVUxMICQ0IgogICAgICAgIGVjaG8gIiRDTUQi
CiAgICAgICAgJENNRCA+ICRSRVNVTFRfRklMRQogICAgICAgIGNoZWNrX3Jlc3VsdCAkPyAk
NSAkNiAkNwogICAgICAgIGVjaG8KICAgIGZpCgogICAgc3VkbyBjaGF0dHIgLWFpICRGSUxF
CiAgICBzdWRvIHJtIC1mICRGSUxFCn0KIz09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQoKbWtkaXIgLXAgJFRF
U1RfRElSCgpzdWRvIGNob3duIHJvb3QgJFRFU1RfUFJPRwpzdWRvIGNobW9kIHVnbyt4LHUr
cyAkVEVTVF9QUk9HCgojPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CgoKZWNobyAiPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09IgoKZWNobyAK
ZWNobyAiVGVzdGluZyByZWFkLW9ubHkgZmlsZSwgb3duZWQgYnkgc2VsZiIKZWNobyAKCmVj
aG8gIioqKioqIFRlc3RpbmcgdGltZXM9PU5VTEwgY2FzZSAqKioqKiIKcnVuX3Rlc3QgIiIg
NDAwICIiICIiIFNVQ0NFU1MgeSB5CgplY2hvICIqKioqKiBUZXN0aW5nIHRpbWVzPT17IFVU
SU1FX05PVywgVVRJTUVfTk9XIH0gY2FzZSAqKioqKiIKcnVuX3Rlc3QgIiIgNDAwICIiICIw
IG4gMCBuIiBTVUNDRVNTIHkgeQoKZWNobyAiKioqKiogVGVzdGluZyB0aW1lcz09eyBVVElN
RV9PTUlULCBVVElNRV9PTUlUIH0gY2FzZSAqKioqKiIKcnVuX3Rlc3QgIiIgNDAwICIiICIw
IG8gMCBvIiBTVUNDRVNTIG4gbgoKZWNobyAiKioqKiogVGVzdGluZyB0aW1lcz09eyBVVElN
RV9OT1csIFVUSU1FX09NSVQgfSBjYXNlICoqKioqIgpydW5fdGVzdCAiIiA0MDAgIiIgIjAg
biAwIG8iIFNVQ0NFU1MgeSBuCgplY2hvICIqKioqKiBUZXN0aW5nIHRpbWVzPT17IFVUSU1F
X09NSVQsIFVUSU1FX05PVyB9IGNhc2UgKioqKioiCnJ1bl90ZXN0ICIiIDQwMCAiIiAiMCBv
IDAgbiIgU1VDQ0VTUyBuIHkKCmVjaG8gIioqKioqIFRlc3RpbmcgdGltZXM9PXsgeCwgeSB9
IGNhc2UgKioqKioiCnJ1bl90ZXN0ICIiIDQwMCAiIiAiMSAxIDEgMSIgU1VDQ0VTUyB5IHkK
CmVjaG8gIj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PSIKCmVjaG8gCmVjaG8gIlRlc3RpbmcgcmVhZC1vbmx5IGZpbGUsIG5v
dCBvd25lZCBieSBzZWxmIgplY2hvIAoKZWNobyAiKioqKiogVGVzdGluZyB0aW1lcz09TlVM
TCBjYXNlICoqKioqIgpydW5fdGVzdCByb290IDQwMCAiIiAiIiBFQUNDRVMKCmVjaG8gIioq
KioqIFRlc3RpbmcgdGltZXM9PXsgVVRJTUVfTk9XLCBVVElNRV9OT1cgfSBjYXNlICoqKioq
IgpydW5fdGVzdCByb290IDQwMCAiIiAiMCBuIDAgbiIgRUFDQ0VTCgplY2hvICIqKioqKiBU
ZXN0aW5nIHRpbWVzPT17IFVUSU1FX09NSVQsIFVUSU1FX09NSVQgfSBjYXNlICoqKioqIgpy
dW5fdGVzdCByb290IDQwMCAiIiAiMCBvIDAgbyIgU1VDQ0VTUyBuIG4KCmVjaG8gIioqKioq
IFRlc3RpbmcgdGltZXM9PXsgVVRJTUVfTk9XLCBVVElNRV9PTUlUIH0gY2FzZSAqKioqKiIK
cnVuX3Rlc3Qgcm9vdCA0MDAgIiIgIjAgbiAwIG8iIEVQRVJNCgplY2hvICIqKioqKiBUZXN0
aW5nIHRpbWVzPT17IFVUSU1FX09NSVQsIFVUSU1FX05PVyB9IGNhc2UgKioqKioiCnJ1bl90
ZXN0IHJvb3QgNDAwICIiICIwIG8gMCBuIiBFUEVSTQoKZWNobyAiKioqKiogVGVzdGluZyB0
aW1lcz09eyB4LCB5IH0gY2FzZSAqKioqKiIKcnVuX3Rlc3Qgcm9vdCA0MDAgIiIgIjEgMSAx
IDEiIEVQRVJNCgplY2hvICI9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0iCgplY2hvIAplY2hvICJUZXN0aW5nIHdyaXRhYmxl
IGZpbGUsIG5vdCBvd25lZCBieSBzZWxmIgplY2hvIAoKZWNobyAiKioqKiogVGVzdGluZyB0
aW1lcz09TlVMTCBjYXNlICoqKioqIgpydW5fdGVzdCByb290IDY2NiAiIiAiIiBTVUNDRVNT
IHkgeQoKZWNobyAiKioqKiogVGVzdGluZyB0aW1lcz09eyBVVElNRV9OT1csIFVUSU1FX05P
VyB9IGNhc2UgKioqKioiCnJ1bl90ZXN0IHJvb3QgNjY2ICIiICIwIG4gMCBuIiBTVUNDRVNT
IHkgeQoKZWNobyAiKioqKiogVGVzdGluZyB0aW1lcz09eyBVVElNRV9PTUlULCBVVElNRV9P
TUlUIH0gY2FzZSAqKioqKiIKcnVuX3Rlc3Qgcm9vdCA2NjYgIiIgIjAgbyAwIG8iIFNVQ0NF
U1MgbiBuCgplY2hvICIqKioqKiBUZXN0aW5nIHRpbWVzPT17IFVUSU1FX05PVywgVVRJTUVf
T01JVCB9IGNhc2UgKioqKioiCnJ1bl90ZXN0IHJvb3QgNjY2ICIiICIwIG4gMCBvIiBFUEVS
TQoKZWNobyAiKioqKiogVGVzdGluZyB0aW1lcz09eyBVVElNRV9PTUlULCBVVElNRV9OT1cg
fSBjYXNlICoqKioqIgpydW5fdGVzdCByb290IDY2NiAiIiAiMCBvIDAgbiIgRVBFUk0KCmVj
aG8gIioqKioqIFRlc3RpbmcgdGltZXM9PXsgeCwgeSB9IGNhc2UgKioqKioiCnJ1bl90ZXN0
IHJvb3QgNjY2ICIiICIxIDEgMSAxIiBFUEVSTQoKZWNobyAiPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09IgoKZWNobyAKZWNo
byAiVGVzdGluZyBhcHBlbmQtb25seSBmaWxlLCBvd25lZCBieSBzZWxmIgplY2hvIAoKZWNo
byAiKioqKiogVGVzdGluZyB0aW1lcz09TlVMTCBjYXNlICoqKioqIgpydW5fdGVzdCAiIiA2
MDAgIithIiAiIiBTVUNDRVNTIHkgeQoKZWNobyAiKioqKiogVGVzdGluZyB0aW1lcz09eyBV
VElNRV9OT1csIFVUSU1FX05PVyB9IGNhc2UgKioqKioiCnJ1bl90ZXN0ICIiIDYwMCAiK2Ei
ICIwIG4gMCBuIiBTVUNDRVNTIHkgeQoKZWNobyAiKioqKiogVGVzdGluZyB0aW1lcz09eyBV
VElNRV9PTUlULCBVVElNRV9PTUlUIH0gY2FzZSAqKioqKiIKcnVuX3Rlc3QgIiIgNjAwICIr
YSIgIjAgbyAwIG8iIFNVQ0NFU1MgbiBuCgplY2hvICIqKioqKiBUZXN0aW5nIHRpbWVzPT17
IFVUSU1FX05PVywgVVRJTUVfT01JVCB9IGNhc2UgKioqKioiCnJ1bl90ZXN0ICIiIDYwMCAi
K2EiICIwIG4gMCBvIiBFUEVSTQoKZWNobyAiKioqKiogVGVzdGluZyB0aW1lcz09eyBVVElN
RV9PTUlULCBVVElNRV9OT1cgfSBjYXNlICoqKioqIgpydW5fdGVzdCAiIiA2MDAgIithIiAi
MCBvIDAgbiIgRVBFUk0KCmVjaG8gIioqKioqIFRlc3RpbmcgdGltZXM9PXsgeCwgeSB9IGNh
c2UgKioqKioiCnJ1bl90ZXN0ICIiIDYwMCAiK2EiICIxIDEgMSAxIiBFUEVSTQoKZWNobyAi
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09IgoKZWNobyAKZWNobyAiVGVzdGluZyBpbW11dGFibGUgZmlsZSwgb3duZWQgYnkg
c2VsZiIKZWNobyAKCmVjaG8gIioqKioqIFRlc3RpbmcgdGltZXM9PU5VTEwgY2FzZSAqKioq
KiIKcnVuX3Rlc3QgLVcgIiIgNjAwICIraSIgIiIgRUFDQ0VTCgplY2hvICIqKioqKiBUZXN0
aW5nIHRpbWVzPT17IFVUSU1FX05PVywgVVRJTUVfTk9XIH0gY2FzZSAqKioqKiIKcnVuX3Rl
c3QgLVcgIiIgNjAwICIraSIgIjAgbiAwIG4iIEVBQ0NFUwoKZWNobyAiKioqKiogVGVzdGlu
ZyB0aW1lcz09eyBVVElNRV9PTUlULCBVVElNRV9PTUlUIH0gY2FzZSAqKioqKiIKcnVuX3Rl
c3QgLVcgIiIgNjAwICIraSIgIjAgbyAwIG8iIFNVQ0NFU1MgbiBuCgplY2hvICIqKioqKiBU
ZXN0aW5nIHRpbWVzPT17IFVUSU1FX05PVywgVVRJTUVfT01JVCB9IGNhc2UgKioqKioiCnJ1
bl90ZXN0IC1XICIiIDYwMCAiK2kiICIwIG4gMCBvIiBFUEVSTQoKZWNobyAiKioqKiogVGVz
dGluZyB0aW1lcz09eyBVVElNRV9PTUlULCBVVElNRV9OT1cgfSBjYXNlICoqKioqIgpydW5f
dGVzdCAtVyAiIiA2MDAgIitpIiAiMCBvIDAgbiIgRVBFUk0KCmVjaG8gIioqKioqIFRlc3Rp
bmcgdGltZXM9PXsgeCwgeSB9IGNhc2UgKioqKioiCnJ1bl90ZXN0IC1XICIiIDYwMCAiK2ki
ICIxIDEgMSAxIiBFUEVSTQoKZWNobyAiPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09IgoKIyBJbW11dGFibGUrYXBwZW5kLW9u
bHkgc2hvdWxkIGhhdmUgc2FtZSByZXN1bHRzIGFzIGltbXV0YWJsZQoKZWNobyAKZWNobyAi
VGVzdGluZyBpbW11dGFibGUgYXBwZW5kLW9ubHkgZmlsZSwgb3duZWQgYnkgc2VsZiIKZWNo
byAKCmVjaG8gIioqKioqIFRlc3RpbmcgdGltZXM9PU5VTEwgY2FzZSAqKioqKiIKcnVuX3Rl
c3QgLVcgIiIgNjAwICIrYWkiICIiIEVBQ0NFUwoKZWNobyAiKioqKiogVGVzdGluZyB0aW1l
cz09eyBVVElNRV9OT1csIFVUSU1FX05PVyB9IGNhc2UgKioqKioiCnJ1bl90ZXN0IC1XICIi
IDYwMCAiK2FpIiAiMCBuIDAgbiIgRUFDQ0VTCgplY2hvICIqKioqKiBUZXN0aW5nIHRpbWVz
PT17IFVUSU1FX09NSVQsIFVUSU1FX09NSVQgfSBjYXNlICoqKioqIgpydW5fdGVzdCAtVyAi
IiA2MDAgIithaSIgIjAgbyAwIG8iIFNVQ0NFU1MgbiBuCgplY2hvICIqKioqKiBUZXN0aW5n
IHRpbWVzPT17IFVUSU1FX05PVywgVVRJTUVfT01JVCB9IGNhc2UgKioqKioiCnJ1bl90ZXN0
IC1XICIiIDYwMCAiK2FpIiAiMCBuIDAgbyIgRVBFUk0KCmVjaG8gIioqKioqIFRlc3Rpbmcg
dGltZXM9PXsgVVRJTUVfT01JVCwgVVRJTUVfTk9XIH0gY2FzZSAqKioqKiIKcnVuX3Rlc3Qg
LVcgIiIgNjAwICIrYWkiICIwIG8gMCBuIiBFUEVSTQoKZWNobyAiKioqKiogVGVzdGluZyB0
aW1lcz09eyB4LCB5IH0gY2FzZSAqKioqKiIKcnVuX3Rlc3QgLVcgIiIgNjAwICIrYWkiICIx
IDEgMSAxIiBFUEVSTQoKZWNobyAiPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09IgoKZWNobyAKCiMgRUlOVkFMIHNob3VsZCBy
ZXN1bHQsIGlmIHBhdGhuYW1lIGlzIE5VTEwsIGRpcmZkIGlzIG5vdAojIEFUX0ZEQ1dELCBh
bmQgZmxhZ3MgY29udGFpbnMgQVRfU1lNTElOS19OT0ZPTExPVy4KCmVjaG8gIioqKioqIFRl
c3RpbmcgcGF0aG5hbWU9PU5VTEwsIGRpcmZkIT1BVF9GRENXRCwgZmxhZ3MgaGFzIiBcCiAg
ICAgIkFUX1NZTUxJTktfTk9GT0xMT1cgKioqKioiCnNldHVwX2ZpbGUgJEZJTEUgIiIgNjAw
ICIiCkNNRD0iJFRFU1RfUFJPRyAtcSAtbiAtZCAkRklMRSBOVUxMICQ0IgplY2hvICIkQ01E
IgokQ01EID4gJFJFU1VMVF9GSUxFCmNoZWNrX3Jlc3VsdCAkPyBFSU5WQUwKZWNobwoKZWNo
byAiPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09IgoKZWNobyAKCiMgSWYgVVRJTUVfTk9XIC8gVVRJTUVfT01JVCBpbiB0dl9u
c2VjIGZpZWxkLCB0aGUgdHZfc2VjIHNob3VsZAojIGJlIGlnbm9yZWQuCgplY2hvICJ0dl9z
ZWMgc2hvdWxkIGJlIGlnbm9yZWQgaWYgdHZfbnNlYyBpcyBVVElNRV9PTUlUIG9yIFVUSU1F
X05PVyIKCmVjaG8gIioqKioqIFRlc3RpbmcgdGltZXM9PXsgVVRJTUVfTk9XLCBVVElNRV9O
T1cgfSBjYXNlICoqKioqIgpydW5fdGVzdCAtUlcgIiIgNjAwICIiICIxIG4gMSBuIiBTVUND
RVNTIHkgeQoKZWNobyAiKioqKiogVGVzdGluZyB0aW1lcz09eyBVVElNRV9PTUlULCBVVElN
RV9PTUlUIH0gY2FzZSAqKioqKiIKcnVuX3Rlc3QgLVJXICIiIDYwMCAiIiAiMSBvIDEgbyIg
U1VDQ0VTUyBuIG4KCmVjaG8gIj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PSIKCmVjaG8gCgp1bmFtZSAtYQpkYXRlCmVjaG8g
IlRvdGFsIHRlc3RzOiAkdGVzdF9udW07IHBhc3NlZDogJHBhc3NlZF9jbnQ7IGZhaWxlZDog
JGZhaWxlZF9jbnQiCmlmIHRlc3QgJGZhaWxlZF9jbnQgLWd0IDA7IHRoZW4KICAgIGVjaG8g
IkZhaWxlZCB0ZXN0czogJGZhaWxlZF9saXN0IgpmaQoKZXhpdAo=
--------------060106000602030705020700--
