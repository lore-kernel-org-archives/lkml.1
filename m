Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYDHVLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYDHVLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYDHVKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:10:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:63721 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYDHVKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=CKGAAu70DoKg7sKKWGCdPcE+T1K3HH9JIvQVpcGu+QmtOUOrNrGYMj7RujR9/RzLE5fgg+ZjDvCcn/Ky6/++geV8OYvztCt7Sc9FTfz4bpq4YJp+JiZDMB9z+k05hUyC4JpHs3+9pSRKDEDR8F4DJXF4kP7r9tscmWL/lx7XU9I=
Message-ID: <47FBDF12.8090400@gmail.com>
Date: Tue, 08 Apr 2008 23:09:38 +0200
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: signalfd() not handling sigqueue() sigval data correctly
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

I was doing some playing about with signalfd(), and seem to have encountered a
bug: when a signalfd read() fetches data for a signal that was sent by
sigqueue(), the data accompanying the signal is not returned.  Instead
ssi_int/ssi_ptr is zero.

I've not looked into the cause of the problem, but the programs below can be
used to demonstrate it.

Here's an example run:

# Run in the background, waiting for signal 44.
$ ./signalfd_sigval 44 &
./signalfd_sigval: PID = 14783
[1] 14783
# Send signal 44 to PID 14783 with accompanying data 123
$ ./sigqueue 14783 44 123
/home/mtk/alp/signals/sigqueue: PID = 14784
Got signal 44
   ssi_code= -1
   ssi_pid = 14784
   ssi_uid = 1000
   ssi_int = 0        <= should be 123 here
   ssi_ptr = 0        <= and here the hex version of 123

Could you take a look at this?

Cheers,

Michael


/* signalfd_sigval.c */

#define _GNU_SOURCE
#include <sys/syscall.h>
#include <unistd.h>
#include <stdint.h>
#include <signal.h>
#if defined(__i386__)
#define __NR_signalfd 321
#endif

struct signalfd_siginfo {
    uint32_t  ssi_signo;
    int32_t   ssi_errno;
    int32_t   ssi_code;
    uint32_t  ssi_pid;
    uint32_t  ssi_uid;
    int32_t   ssi_fd;
    uint32_t  ssi_tid;
    uint32_t  ssi_band;
    uint32_t  ssi_overrun;
    uint32_t  ssi_trapno;
    int32_t   ssi_status;
    int32_t   ssi_int;
    uint64_t  ssi_ptr;
    uint64_t  ssi_utime;
    uint64_t  ssi_stime;
    uint64_t  ssi_addr;
    uint8_t  __pad[48];
};

static int
signalfd(int ufd, sigset_t const *mask)
{
#define SIZEOF_SIG (_NSIG / 8)
#define SIZEOF_SIGSET (SIZEOF_SIG > sizeof(sigset_t) ? \
                       sizeof(sigset_t): SIZEOF_SIG)
    return syscall(__NR_signalfd, ufd, mask, SIZEOF_SIGSET);
}

// #include <sys/signalfd.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define errExit(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)

int
main(int argc, char *argv[])
{
    sigset_t mask;
    int sfd;
    struct signalfd_siginfo fdsi;
    ssize_t s;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s sig-num\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    printf("%s: PID = %ld\n", argv[0], (long) getpid());

    sigemptyset(&mask);
    sigaddset(&mask, atoi(argv[1]));

    if (sigprocmask(SIG_BLOCK, &mask, NULL) == -1)
        errExit("sigprocmask");

    sfd = signalfd(-1, &mask);
    if (sfd == -1)
        errExit("signalfd");

    for (;;) {
        s = read(sfd, &fdsi, sizeof(struct signalfd_siginfo));
        if (s != sizeof(struct signalfd_siginfo))
            errExit("read");

        printf("Got signal %d\n", fdsi.ssi_signo);
        printf("   ssi_code= %d\n", fdsi.ssi_code);
        printf("   ssi_pid = %d\n", fdsi.ssi_pid);
        printf("   ssi_uid = %d\n", fdsi.ssi_uid);
        printf("   ssi_int = %d\n", fdsi.ssi_int);
        printf("   ssi_ptr = %llx\n", fdsi.ssi_ptr);
    }
}



/* sigqueue.c */

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

int
main(int argc, char *argv[])
{
    union sigval sv;

    if (argc != 4) {
        fprintf(stderr, "Usage: %s pid sig-num data\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    printf("%s: PID = %ld\n", argv[0], (long) getpid());

    sv.sival_int = atoi(argv[3]);
    if (sigqueue(atoi(argv[1]), atoi(argv[2]), sv) == -1)
        errExit("sigqueue");

    exit(EXIT_SUCCESS);
}

