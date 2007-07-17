Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbXGQILi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbXGQILi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764143AbXGQIKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:10:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:56461 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759287AbXGQIKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:10:41 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX19ggEhqXw9g0FObicsw1z/G/WWnOTS1YkknreEA+j
	pKfNTcteppwyP2
Message-ID: <469C6F81.7070600@gmx.net>
Date: Tue, 17 Jul 2007 09:28:01 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: timerfd read only gets single byte?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

While writing a test program to incorporate into the timerfd.2 man page, I
think I've found a bug.  It looks like only the least significant byte of
ticks is being returned from read(2), even though I am providing a 4 byte
buffer.

The test program takes 3 command line arguments:

1) seconds for the initial expiration
2) seconds for the timer interval
3) number of timer expirations to catch before terminating

I tried running this program and suspending it for a few minutes, to see if
I could get a large overrun value.  When I do this on 2.6.22-rc4 (the built
kernel I have to hand), I see the following:

============
$ ./timerfd_demo 1 1 500
0.000: timer started
1.005: read: 1; total=1
2.005: read: 1; total=2
3.005: read: 1; total=3
4.005: read: 1; total=4
5.006: read: 1; total=5
^Z
[1]+  Stopped                 ./timerfd_demo 1 1 500
$ date
Tue Jul 17 09:18:11 CEST 2007
$ date
Tue Jul 17 09:23:40 CEST 2007
$ fg
./timerfd_demo 1 1 500
339.769: read: 78; total=83
340.004: read: 1; total=84
341.004: read: 1; total=85
^C
==============

The after bringing the program back into the foreground, I would have
expected to get an overrun count of 334 or thereabouts, but it looks as
though I'm only getting the least significant byte from read(2).

Cheers,

Michael


/* Link with -lrt */

#define _GNU_SOURCE
#include <sys/syscall.h>
#include <unistd.h>
#include <time.h>
#if defined(__i386__)
#define __NR_timerfd 322
#endif

static int
timerfd(int ufd, int clockid, int flags, struct itimerspec *utmr) {
    return syscall(__NR_timerfd, ufd, clockid, flags, utmr);
}

#define TFD_TIMER_ABSTIME (1 << 0)

////////////////////////////////////////////////////////////

// #include <sys/timerfd.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>     /* Definition of uint32_t */

#define die(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)

static void
print_elapsed_time(void)
{
    static struct timespec start;
    struct timespec curr;
    static int first_call = 1;
    int secs, nsecs;

    if (first_call) {
        first_call = 0;
        if (clock_gettime(CLOCK_MONOTONIC, &start) == -1)
            die("clock_gettime");
    }

    if (clock_gettime(CLOCK_MONOTONIC, &curr) == -1)
        die("clock_gettime");

    secs = curr.tv_sec - start.tv_sec;
    nsecs = curr.tv_nsec - start.tv_nsec;
    if (nsecs < 0) {
        secs--;
        nsecs += 1000000000;
    }
    printf("%d.%03d: ", secs, (nsecs + 500000) / 1000000);
}

int
main(int argc, char *argv[])
{
    struct itimerspec utmr;
    int max_exp, tot_exp, tfd;
    struct timespec now;
    uint32_t exp;
    ssize_t s;

    if ((argc != 2) && (argc != 4)) {
        fprintf(stderr, "%s init-secs [interval-secs max-exp]\n",
                argv[0]);
        exit(EXIT_FAILURE);
    }

    if (clock_gettime(CLOCK_REALTIME, &now) == -1)
        die("clock_gettime");

    /* Create a CLOCK_REALTIME absolute timer with initial
       expiration and interval as specified in command line */

    utmr.it_value.tv_sec = now.tv_sec + atoi(argv[1]);
    utmr.it_value.tv_nsec = now.tv_nsec;
    if (argc == 2) {
        utmr.it_interval.tv_sec = 0;
        max_exp = 1;
    } else {
        utmr.it_interval.tv_sec = atoi(argv[2]);
        max_exp = atoi(argv[3]);
    }
    utmr.it_interval.tv_nsec = 0;

    tfd = timerfd(-1, CLOCK_REALTIME, TFD_TIMER_ABSTIME, &utmr);
    if (tfd == -1)
        die("timerfd");

    print_elapsed_time();
    printf("timer started\n");

    exp = 0; // ????? Without this initialization, the results from
             // read() are strange; it appears that read() is only
             // returning one byte of tick information, not four.
    for (tot_exp = 0; tot_exp < max_exp;) {
        s = read(tfd, &exp, sizeof(uint32_t));
        if (s != sizeof(uint32_t))
            die("read");

        tot_exp += exp;
        print_elapsed_time();
        printf("read: %u; total=%d\n", exp, tot_exp);
    }

    exit(EXIT_SUCCESS);
}

