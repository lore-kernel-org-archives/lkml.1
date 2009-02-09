Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZBIJ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZBIJ2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZBIJ2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:28:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:30375 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZBIJ2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:28:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=bbaeK1SLPOEWjnp2wWhwKkbimHTg8qyqYqEAwlsmrbuOR0rvmoqkG6xwdIhibQQ/qj
         /u9o5UcvsikeK2mBobjEmzDSzl94U0V00hi9y21JpIikkNh9RoSIHTL+iT99I/hulmVU
         cNOPfpTJoH1Oh/umRvAo5Yq4HOS9BUBDB+/Es=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0902081510150.18839@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902081510150.18839@alien.or.mcafeemobile.com>
Date: Mon, 9 Feb 2009 22:28:36 +1300
Message-ID: <cfd18e0f0902090128i1a4902f4of0d4d830b567602f@mail.gmail.com>
Subject: Re: [patch 2/2] timerfd extend clockid support
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 12:23 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> The following patch extends timerfd clockid support to cover the ones
> supported by timer_create().
> It exports the invalid_clockid() function outside posix-timers.c to allow
> timerfd to properly check input parameters.
> Andrew, this is (eventually) .30 material, and do not take the patch
> until you have Thomas sign off.
> Thomas, timerfd uses core hrtimer functions for its tasks. By extending
> the clockid support, I assume that the clockids other than CLOCK_MONOTONIC
> and CLOCK_REALTIME, behaves the same from a hrtimer caller POV. Right?

Hi Davide,

Have you done any testing of this patch?  My attempts at testing with
clocks other than REALTIME and MONOTONIC all don't work so far.  In
some cases, my test programs causes the system to hang.  Try
experimenting with the (not yet well tested) test program below, to
check the behavior with other clocks.

Cheers,

Michael

/* timerfd_demo.c

   Compile with -lrt
*/
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <errno.h>
#include <time.h>
#include <sys/timerfd.h>
#include <pthread.h>
#include <stdint.h>               /* Definition of uint64_t */

#define SIG SIGUSR1

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

static void *
thread_func(void *arg)
{
    printf("Thread burning CPU\n");
    for (;;)
        ;
}

int
main(int argc, char *argv[])
{
    timer_t timer_id;
    struct itimerspec its;
    clockid_t clock_id;
    int flags, s, fd;
    struct timespec ts;
    uint64_t numExp;

    if (argc < 4) {
        fprintf(stderr, "Usage: %s <clockid> <flags> <num-secs> "
                "[<clock-adj-secs>]\n", argv[0]);
#define fpe(str) fprintf(stderr, str);
        fpe("<clockid> is one of:\n");
        fpe("\tm  CLOCK_MONOTONIC\n");
        fpe("\tr  CLOCK_REALTIME\n");
        fpe("\tp  CLOCK_PROCESS_CPUTIME_ID\n");
        fpe("\tC  clock of a child process that burns CPU time\n");
        fpe("\tT  clock of a sub-thread that burns CPU time\n");
        fpe("<flags> is one of:\n");
        fpe("\ta  absolute timer (<num-secs> is added to current\n");
        fpe("\t   clock value)\n")
        fpe("\t-  relative timer\n")
        fpe("<num-secs> is the initial expiration time for the timer\n");
        fpe("<clock-adj-secs> is number of seconds by which clock\n");
        fpe("\tshould be adjusted (clock_settime()) after timer\n");
        fpe("\thas started\n")
        exit(EXIT_FAILURE);
    }

    if (argv[1][0] == 'C') {
        pid_t cpid;

        cpid = fork();
        if (cpid == -1)
            errExit("fork");

        if (cpid == 0) {
            usleep(10000);
            printf("Child process burning CPU time\n");
            alarm(100); /* Ensure child eventually dies */
            for (;;)
                ;
        } else {        /* Parent gets CPU clock ID of child and
                           falls through */
            if (clock_getcpuclockid(cpid, &clock_id) == -1)
                errExit("clock_getcpuclockid");
        }

    } else if (argv[1][0] == 'T') {
        pthread_t t;

        errno = pthread_create(&t, NULL, thread_func, NULL);
        if (errno != 0)
            errExit("pthread_create");
        errno = pthread_getcpuclockid(t, &clock_id);
        if (errno != 0)
            errExit("pthread_getcpuclockid");

    } else {
        clock_id = (argv[1][0] == 'm') ? CLOCK_MONOTONIC :
                   (argv[1][0] == 'r') ? CLOCK_REALTIME :
                   (argv[1][0] == 'p') ? CLOCK_PROCESS_CPUTIME_ID :
                   -999999;     /* Unlikely to be a valid clock ID */

        if (clock_id == CLOCK_PROCESS_CPUTIME_ID) {
            pthread_t t;

            errno = pthread_create(&t, NULL, thread_func, NULL);
            if (errno != 0)
                errExit("pthread_create");
        }
    }

    fd = timerfd_create(clock_id, 0);
    if (fd == -1)
        errExit("timerfd_create");

    printf("clock ID is 0x%lx\n", (long) clock_id);
    printf("timer ID is 0x%lx\n", (long) timer_id);

    flags = (argv[2][0] == 'a') ? TFD_TIMER_ABSTIME : 0;

    if (flags & TFD_TIMER_ABSTIME) {
        printf("Absolute timer\n");
        if (clock_gettime(clock_id, &ts) == -1)
            errExit("clock_gettime");
        printf("Current clock value = %ld\n", (long) ts.tv_sec);
        its.it_value.tv_sec = ts.tv_sec + atoi(argv[3]);
        its.it_value.tv_nsec = ts.tv_nsec;
    } else {
        its.it_value.tv_sec = atoi(argv[3]);
        its.it_value.tv_nsec = 0;
    }

    its.it_interval.tv_sec = 1;
    its.it_interval.tv_nsec = 0;

    printf("its.it_value.tv_sec = %ld\n",
            (long) its.it_value.tv_sec);

    if (timerfd_settime(fd, flags, &its, NULL) == -1)
         errExit("timer_settime");

    if (argc > 4) {
        if (clock_gettime(clock_id, &ts) == -1)
            errExit("clock_gettime");
        ts.tv_sec += atoi(argv[4]);
        printf("About to adjust clock to %ld\n", (long) ts.tv_sec);
        if (clock_settime(clock_id, &ts) == -1)
            errExit("clock_settime");
    }

    s = read(fd, &numExp, sizeof(uint64_t));
    if (s != sizeof(uint64_t))
        errExit("read");
    printf("number of expirations = %lld\n",
            (unsigned long long) numExp);
}
