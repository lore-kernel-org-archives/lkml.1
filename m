Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYJGNtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYJGNtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYJGNtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:49:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:37168 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbYJGNtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:49:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=nIUtJYgMbcgx7uiLExGR7YVQgLFLgZvsVLuTZGqrAU8fl8p3pgYTy74fu1gvG3bz9S
         lMrhynzJ8b0mZ2rdBb6te5dZiS7E1gRmWJ5oDIbgMsseSS8vtnIHbR/OmWoKe0oxCkby
         ko6M6FsAWUJZFTiOnhq+I7vl8Dgb3fzz8VMqA=
Message-ID: <cfd18e0f0810070649l391978f9v345a5591728bbf41@mail.gmail.com>
Date: Tue, 7 Oct 2008 15:49:00 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Roland McGrath" <roland@redhat.com>, "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <20080930194445.978351700@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080930194445.978351700@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Tue, Sep 30, 2008 at 9:48 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> sys_kill has a counterpart sys_tgkill which allows to send signals to
> a particular thread. sys_rt_sigqueueinfo is lacking such a counterpart.
>
> Aside of the asymetry it is a show stopper for migrating applications
> from other unix-alike RTOSes.
>
> The following patch series implements rt_tgsigqueueinfo and hooks it
> up for x86.

I'm not sure if I've run across a bug or (maybe more likely) have a
bug in my test code.  Could you take a look at the test programs
below.

When I use t_rt_tgsigqueueinfo.c to send a signal to my receiving
program it crashes because the siginfo_t argument to the signal
handler has a bad value (0x33); it's not obvious to me how it should
get to have that value (have I misconstructed something in the
t_rt_tgsigqueuinfo.c program?).

Cheers,

Michael

==========

$ ./multithread_sig_receiver 44 x
Established handler for signal 44
Main: TGID = 6105; TID = 6105
Thread 1: PID = 6105; TID = 6106; arg = x
Thread 1: about to pause
                                                              $
./t_rt_tgsigqueuinfo 6105 6106 44 1
PID = 6105; TID = 6106; caught signal 44:
0x33
Segmentation fault (core dumped)

=========

/*#* t_rt_tgsigqueueinfo.c

   Copyright 2008, Linux Foundation;
   written by Michael Kerrisk <mtk.manpages@gmail.com>
*/
#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <signal.h>
#include <sys/types.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

#if defined(__i386__)
#define SYS_rt_tgsigqueueinfo 333
#endif

static int
rt_tgsigqueueinfo(pid_t tgid, pid_t tid, int sig, siginfo_t *si)
{
    return syscall(SYS_rt_tgsigqueueinfo, tgid, tid, sig, si);
}


int
main(int argc, char *argv[])
{
    pid_t tgid, tid;
    siginfo_t si;
    int sig, val;

    if (argc < 5) {
        fprintf(stderr, "Usage: %s <tgid> <tid> <sig> <val>\n", argv[0]);
        exit(EXIT_SUCCESS);
    }

    printf("My PID is %ld\n", (long) getpid());

    tgid = atoi(argv[1]);
    tid = atoi(argv[2]);
    sig = atoi(argv[3]);
    val = atoi(argv[4]);

    si.si_signo = sig;
    si.si_code = SI_QUEUE;
    si.si_pid = getpid();
    si.si_uid = getuid();
    si.si_value.sival_int = val;

    if (rt_tgsigqueueinfo(tgid, tid, sig, &si) == -1)
        errExit("rt_tgsigqueueinfo");

    exit(EXIT_SUCCESS);
} /* main */

=====================

/*#* multithread_sig_receiver.c

   Copyright 2008, Linux Foundation;
   written by Michael Kerrisk <mtk.manpages@gmail.com>
*/
#define _GNU_SOURCE
#include <sys/syscall.h>
#include <ctype.h>
#include <unistd.h>
#include <signal.h>
#include <pthread.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

#define errExitEN(en, msg) \
                        do { errno = en; perror(msg); \
                             exit(EXIT_FAILURE); } while (0)

static int test_sig;

struct thread_arg {
    int   thread_num;
    char *argv_string;
};

static pid_t
gettid(void)
{
    return syscall(SYS_gettid);
}

static void
handler(int sig, siginfo_t *si, void *uc)
{
    printf("PID = %ld; TID = %ld; caught signal %d: \n",
            (long) getpid(), (long) gettid(), sig);
    printf("%p\n", si);
    printf("si_signo=%d ", si->si_signo);
    printf("si_code=%d ", si->si_code);
    printf("si_pid=%ld ", (long) si->si_pid);
    printf("si_uid=%ld ", (long) si->si_uid);
    printf("si_value.sival_int=%d\n", si->si_value.sival_int);
}

static void *
threadFunc(void *arg)
{
    struct thread_arg *ta = (struct thread_arg *) arg;
    sigset_t new;
    int s;

    printf("Thread %d: PID = %ld; TID = %ld; arg = %s\n", ta->thread_num,
            (long) getpid(), (long) gettid(), ta->argv_string);

    if (ta->argv_string[0] == 'b') {
        printf("Thread %d: blocking signal\n", ta->thread_num);
        sigemptyset(&new);
        sigaddset(&new, test_sig);
        s = pthread_sigmask(SIG_SETMASK, &new, NULL);
        if (s != 0)
            errExit("pthread_sigmask");
    }

    if (isdigit(ta->argv_string[1])) {
        sleep(atoi(&ta->argv_string[1]));
        printf("Thread %d: unblocking signal\n", ta->thread_num);
        sigemptyset(&new);
        s = pthread_sigmask(SIG_SETMASK, &new, NULL);
        if (s != 0)
            errExit("pthread_sigmask");
    }

    printf("Thread %d: about to pause\n", ta->thread_num);

    for (;;)
        pause();
} /* threadFunc */


#define MAX_ARGS 1000

int
main(int argc, char *argv[])
{
    pthread_t t;
    int s, j;
    struct sigaction sa;
    struct thread_arg ta[MAX_ARGS];
    sigset_t new;

    if (argc < 3) {
        fprintf(stderr, "Usage: %s <sig> <thread-config>...\n", argv[0]);
        exit(EXIT_SUCCESS);
    }

    if (argc > MAX_ARGS) {
        fprintf(stderr, "Too many arguments\n");
        exit(EXIT_SUCCESS);
    }

    test_sig = atoi(argv[1]);

    sigemptyset(&new);
    if (sigprocmask(SIG_SETMASK, &new, NULL) == -1)
        errExit("sigprocmask");

    sa.sa_flags = 0;
    sa.sa_sigaction = handler;
    sigemptyset(&sa.sa_mask);
    if (sigaction(test_sig, &sa, NULL) == -1)
        errExit("sigaction");
    printf("Established handler for signal %d\n", test_sig);

    printf("Main: TGID = %ld; TID = %ld\n",
            (long) getpid(), (long) gettid());

    for (j = 0; j + 2 < argc; j++) {
        ta[j].thread_num = j + 1;
        ta[j].argv_string = argv[j + 2];

        s = pthread_create(&t, NULL, threadFunc, &ta[j]);
        if (s != 0)
            errExitEN(s, "pthread_create");
    }

    pause();
} /* main */
