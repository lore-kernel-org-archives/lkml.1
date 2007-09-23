Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbXIWRgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbXIWRgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 13:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXIWRgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 13:36:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:36127 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754155AbXIWRgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 13:36:37 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18GoYcxnugGmfLvOOo1x1/CQf0M8B2qTksKGfcgwu
	dqDqCGwjcljW1N
Message-ID: <46F6A37C.9010009@gmx.net>
Date: Sun, 23 Sep 2007 19:33:48 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@xenotime.net>,
       vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       =?ISO-8859-1?Q?David_H=E4r?= =?ISO-8859-1?Q?deman?= 
	<david@hardeman.nu>
Subject: Re: RFC: A revised timerfd API
References: <46EF7DDA.2070401@gmx.net> <Pine.LNX.4.64.0709180936480.22956@alien.or.mcafeemobile.com> <46F514C9.5010208@gmx.net> <Pine.LNX.4.64.0709221359190.22085@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709221359190.22085@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

Davide Libenzi wrote:
> On Sat, 22 Sep 2007, Michael Kerrisk wrote:
> 
>> So I'm inclined to implement option (b), unless someone has strong
>> objections.  Davide, could I persuade you to help?
> 
> I guess I better do, otherwise you'll continue to stress me ;)

Thanks -- that was more than I hoped for!

> int timerfd_create(int clockid);
> int timerfd_settime(int ufd, int flags,
>                     const struct itimerspec *utmr,
>                     struct itimerspec *otmr);
> int timerfd_gettime(int ufd, struct itimerspec *otmr);
> 
> Patch below. Builds, not tested yet (you need to remove the "broken" 
> status from CONFIG_TIMERFD in case you want to test - and plug the new 
> syscall to arch/xxx).

I applied this patch against 2.6.27-rc7, and wired up the syscalls as shown
in the definitions below.  When I ran the the program below, my system
immediately froze.  Can you try it on your system please.

Cheers,

Michael

/* Link with -lrt */

#define _GNU_SOURCE
#include <sys/syscall.h>
#include <unistd.h>
#include <time.h>
#if defined(__i386__)
#define __NR_timerfd_create 325
#define __NR_timerfd_settime 326
#define __NR_timerfd_gettime 327
17170:man-pages/man2> cat timerfd3_test.c
/* Link with -lrt */

#define _GNU_SOURCE
#include <sys/syscall.h>
#include <unistd.h>
#include <time.h>
#if defined(__i386__)
#define __NR_timerfd_create 325
#define __NR_timerfd_settime 326
#define __NR_timerfd_gettime 327
#endif

static int
timerfd_create(int clockid)
{
    return syscall(__NR_timerfd_create, clockid);
}

static int
timerfd_settime(int ufd, int flags, struct itimerspec *utmr,
        struct itimerspec *outmr)
{
    return syscall(__NR_timerfd_settime, ufd, flags, utmr, outmr);
}

static int
timerfd_gettime(int ufd, struct itimerspec *outmr)
{
    return syscall(__NR_timerfd_gettime, ufd, outmr);
}

/*
static int
timerfd(int ufd, int clockid, int flags, struct itimerspec *utmr,
        struct itimerspec *outmr)
{
    return syscall(__NR_timerfd, ufd, clockid, flags, utmr, outmr);
}

*/


/*
int timerfd_settime(int ufd, int flags,
> >                     const struct itimerspec *utmr,
> >                     struct itimerspec *otmr);
> > int timerfd_gettime(int ufd, struct itimerspec *otmr)
*/
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
    struct itimerspec utmr, outmr;
    int ufd;
    struct timespec now;
    int j, s;
    uint64_t exp;
    time_t start;

    if (argc < 2) {
        fprintf(stderr, "%s init-secs [interval-secs]\n",
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
    } else {
        utmr.it_interval.tv_sec = atoi(argv[2]);
    }
    utmr.it_interval.tv_nsec = 0;

    ufd = timerfd_create(CLOCK_REALTIME);
    if (ufd == -1)
        die("timerfd");
    s = timerfd_settime(ufd, TFD_TIMER_ABSTIME, &utmr, NULL);
    if (ufd == -1)
        die("timerfd");

    start = time(NULL);
    for (j = 0; ; j++) {
        sleep(1);
        if (0 && (j % 10) == 0) {
            printf("Resetting timer\n");
            utmr.it_value.tv_sec += 1;
            utmr.it_interval.tv_sec += 2;
            s = timerfd_settime(ufd, 0, &utmr, &outmr);
            if (s == -1)
                die("timerfd-2");

        }
        s = timerfd_gettime(ufd, &outmr);
        printf("Retrieval %3d (%3ld) - Got: %ld %ld; %ld %ld\n",
                j, (long) (time(NULL) - start),
                (long) outmr.it_value.tv_sec,
                (long) outmr.it_value.tv_nsec,
                (long) outmr.it_interval.tv_sec,
                (long) outmr.it_interval.tv_nsec);
        if ((j % 30) == 0 && j > 0) {
            printf("About to read\n");
            s = read(ufd, &exp, sizeof(uint64_t));
            if (s != sizeof(uint64_t))
                die("read");
            printf("Read: %lld\n", exp);
        }
    }

    exit(EXIT_SUCCESS);
}

