Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYIIPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYIIPp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYIIPpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:45:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:41636 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbYIIPpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=PIeiZ+F7yBYfy3k3Rb5FEzpHeGsJxOjNWFyw+d72BrgmDx5NXNYtJ+ywvTEIzU825m
         QfMSdaXzJ40NqmAuHViEyYrIzTSL8LCiFBnfSgpLGwD9OW3N+3PUhidcbuPjdyd9xWlG
         WUGJRmCfgFNaEs6t1oXWc1bhf8VK9iz+Rgycw=
Message-ID: <517f3f820809090845o5dc772f8r2308a6c010f69561@mail.gmail.com>
Date: Tue, 9 Sep 2008 17:45:15 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Denys Vlasenko" <dvlasenk@redhat.com>
Subject: Re: [PATCH] make setpriority POSIX compliant; introduce PRIO_THREAD extension
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>
In-Reply-To: <1220278355.3866.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220278355.3866.21.camel@localhost.localdomain>
X-Google-Sender-Auth: 22f0e52283edd356
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys,

On 9/1/08, Denys Vlasenko <dvlasenk@redhat.com> wrote:
> POSIX and SUS say that setpriority(PRIO_PROCESS) should affect
>  all threads in the process:
>
>  SYNOPSIS
>        #include <sys/resource.h>
>        int getpriority(int which, id_t who);
>        int setpriority(int which, id_t who, int value);
>  DESCRIPTION
>        ...
>        The  nice value set with setpriority() shall be applied to
>        the process. If the process is multi-threaded, the nice value
>        shall affect all system scope threads in the process.
>
>  Currently, this is not the case. While PRIO_PGRP and PRIO_USER
>  do set priority to the selected group of processes, PRIO_PROCESS
>  sets priority only for the thread with tid == who.
>
>  This mostly goes unnoticed because single-threaded processes have
>  tid == pid.
>
>  However, in multi-threaded processes
>
>  setpriority(PRIO_PROCESS, getpid(), value)
>
>  sets new priority only for the thread with tid == pid, leaving
>  all other threads unaffected. This is wrong.
>
>  Attached patch changes setpriority(PRIO_PROCESS) to set priority
>  for all threads with selected pid. getpriority is changed accordingly,
>  to return the (numerical) max of all threads' priority.
>
>  In order to allow priority of individual threads to be manipulated,
>  patch adds PRIO_THREAD which acts on single thread, always.
>
>  Since there may be programs which use the fact that
>
>  setpriority(PRIO_PROCESS, tid, value)
>
>  prior to this patch was setting priority for selected thread,
>  this behavior is retained in case when tid != pid.
>
>  IOW: with PRIO_PROCESS, if pid specifies a thread group leader,
>  all threads' prios are set. Otherwise, only selected thread's priority
>  is set. (Alternative can be to just fail with ESRCH).
>
>  getpriority() is acting similarly.
>
>  Patch is run tested. I will post test program etc as a reply.

Tested-by: Michael Kerrisk <mtk.manpages@gmail.com>

Please do CC me on API changes, so that they might get documented in
the man pages.

Thanks for this work.  (I'm not sure whether or not it's a response to
my bug report, http://bugzilla.kernel.org/show_bug.cgi?id=6258 )

I tested your patch.  Most things seem to work as I would expect, but
there is one strangeness.

I would expect
setpriority(PRIO_PROCESS, getpid())
and
setpriority(PRIO_PROCESS, 0)
to have the same affect (because: which == PRIO_PRCESS, who == 0
conventionally means "the calling process").

But they do not: the latter call only changes the priority of the
calling thread.  Is this intended?

My test program is at the end of this mail.  Here are two tests
demonstrating the behavior in each of the above cases:

$ sudo ./thread_nice_test p p
root's password:
main(): TID = 6574, PID = 6574
main(): initial nice value is 0

Thread 1: TID = 6578
Thread 2: TID = 6579
Loop 0
    process nice value is 0
    main(): nice value is 0
    Thread 1: nice value is 0
    Thread 2: nice value is 0
Thread 1: setpriority() succeeded (0, 6574)
Loop 1
    process nice value is -10
    main(): nice value is -10
    Thread 1: nice value is -10
    Thread 2: nice value is -10
Loop 2
    process nice value is -10
    main(): nice value is -10
    Thread 1: nice value is -10
    Thread 2: nice value is -10


$ sudo ./thread_nice_test p 0
main(): TID = 6590, PID = 6590
main(): initial nice value is 0

Thread 1: TID = 6594
Thread 2: TID = 6595
Loop 0
    process nice value is 0
    main(): nice value is 0
    Thread 1: nice value is 0
    Thread 2: nice value is 0
Thread 1: setpriority() succeeded (0, 0)
Loop 1
    process nice value is -10
    main(): nice value is 0
    Thread 1: nice value is -10
    Thread 2: nice value is 0
Loop 2
    process nice value is -10
    main(): nice value is 0
    Thread 1: nice value is -10
    Thread 2: nice value is 0

=====

/* thread_nice_test.c

   Copyright 2008, Linux Foundation, written by Michael Kerrisk
        <mtk.manpages@gmail.com>
   Licensed under GNU GPL version 2 or later

   Creates two subthreads.
   The first thread does a setpriority() with arguments
   based on command-line arguments.
   The main() program loops, using getpriority() to monitor
   priority of all threads, and the process as a whole.
*/
#define _GNU_SOURCE
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <limits.h>
#include <string.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

#define PRIO_THREAD 3

#define errExit(msg)            { perror(msg); exit(EXIT_FAILURE); }

#define errExitEN(en, msg)      { errno = en; perror(msg); \
                                  exit(EXIT_FAILURE); }

#define fatal(msg)              { fprintf(stderr, "%s\n", msg); \
                                  exit(EXIT_FAILURE); }

#define NEW_NICE -10

static pid_t
gettid(void)
{
    return syscall(SYS_gettid);
}

static pid_t t1_tid, t2_tid, main_tid;
static char cwhich, cwho;

static void *
tf1_nice(void *x)
{
    int which, who;

    t1_tid = gettid();
    printf("Thread 1: TID = %ld\n", (long) gettid());

    sleep(1);

    which = (cwhich == 'p') ? PRIO_PROCESS :
            (cwhich == 't') ? PRIO_THREAD :
            9999;       /* Invalid value */
    who =   (cwho == '0') ? 0 :
            (cwho == 't') ? gettid() :
            (cwho == 'p') ? getpid() :
            (cwho == 'm') ? main_tid :
            -1;                 /* Invalid value */
    if (setpriority(which, who, NEW_NICE) == -1)
        errExit("setpriority");

    printf("Thread 1: setpriority() succeeded (%d, %d)\n", which, who);

    sleep(10);
    printf("Thread 1 terminating\n");
    return NULL;
}

static void *
tf2_nice(void *x)
{
    t2_tid = gettid();
    printf("Thread 2: TID = %ld\n", (long) gettid());

    sleep (10);

    printf("Thread 2 terminating\n");
    return NULL;
}


int
main(int argc, char *argv[])
{
    pthread_t t1, t2;
    int s;
    int nval;
    int j;

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <which> <who>\n", argv[0]);
        fprintf(stderr, "which is\n");
        fprintf(stderr, "    p   PRIO_PROCESS\n");
        fprintf(stderr, "    t   PRIO_THREAD\n");
        fprintf(stderr, "who is:\n");
        fprintf(stderr, "    0   0\n");
        fprintf(stderr, "    t   gettid()\n");
        fprintf(stderr, "    p   getpid()\n");
        fprintf(stderr, "    m   TID of main()\n");
        exit(EXIT_FAILURE);
    }

    main_tid = gettid();
    cwhich = argv[1][0];
    cwho = argv[2][0];

    printf("main(): TID = %ld, PID = %ld\n",
            (long) gettid(), (long) getpid());

    errno = 0;
    nval = getpriority(PRIO_PROCESS, gettid());
    if (nval == -1 && errno != 0)
        errExit("getpriority");
    printf("main(): initial nice value is %d\n", nval);


    printf("\n");

    s = pthread_create(&t1, NULL, tf1_nice, (void *) 1);
    if (s != 0)
        errExitEN(s, "pthread_create");

    s = pthread_create(&t2, NULL, tf2_nice, (void *) 2);
    if (s != 0)
        errExitEN(s, "pthread_create");

    usleep(200000);  /* Allow time for subthreads to set global vars */

    for (j = 0; j < 3; j++) {
        printf("Loop %d\n", j);
        errno = 0;
        nval = getpriority(PRIO_PROCESS, gettid());
        if (nval == -1 && errno != 0)
            errExit("getpriority");
        printf("    process nice value is %d\n", nval);

        errno = 0;
        nval = getpriority(PRIO_THREAD, gettid());
        if (nval == -1 && errno != 0)
            errExit("getpriority");
        printf("    main(): nice value is %d\n", nval);

        errno = 0;
        nval = getpriority(PRIO_THREAD, t1_tid);
        if (nval == -1 && errno != 0)
            errExit("getpriority");
        printf("    Thread 1: nice value is %d\n", nval);

        errno = 0;
        nval = getpriority(PRIO_THREAD, t2_tid);
        if (nval == -1 && errno != 0)
            errExit("getpriority");
        printf("    Thread 2: nice value is %d\n", nval);

        sleep(2);
    }

    exit(EXIT_SUCCESS);
} /* main */
