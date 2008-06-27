Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbYF0IHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbYF0IHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYF0IHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:07:24 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:29924 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbYF0IG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gC8HM/PL+eU9z3QUWN2jMUhZO7dEG5D6xHAfNUWvmzZ9OXRGAoVtp4UTmez4N9s0H7
         uO7PNYK3ep1FNdYcD4z1DFEF+OGOLSZnXnO0GbKcSU2AfeQFuQsBOLpNycPzUnsgY/6S
         /iEB8i359dClTYQxCR7vn7ugAvrlmTeDySN/I=
Message-ID: <cfd18e0f0806270106s5088327dja804c973bee117d@mail.gmail.com>
Date: Fri, 27 Jun 2008 10:06:56 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [patch] make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bart Van Assche" <bart.vanassche@gmail.com>,
       "Roland McGrath" <roland@redhat.com>
In-Reply-To: <cfd18e0f0806260809n4370c6eqc07c05ff93029658@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0806250749od875635r9e533d9f834bd8c4@mail.gmail.com>
	 <20080625153806.GA499@tv-sign.ru>
	 <cfd18e0f0806260809n4370c6eqc07c05ff93029658@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 5:09 PM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> On Wed, Jun 25, 2008 at 5:38 PM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
>> On 06/25, Michael Kerrisk wrote:
>>>
>>> --- /home/mtk/ARCHIVE/KERNEL/linux-2.6.26-rc7/kernel/signal.c.orig    2008-06-24
>>> 16:20:39.000000000 +0200
>>> +++ /home/mtk/ARCHIVE/KERNEL/linux-2.6.26-rc7/kernel/signal.c 2008-06-24
>>> 16:22:17.000000000 +0200
>>> @@ -1379,10 +1379,9 @@
>>>
>>>       info.si_uid = tsk->uid;
>>>
>>> -     /* FIXME: find out whether or not this is supposed to be c*time. */
>>> -     info.si_utime = cputime_to_jiffies(cputime_add(tsk->utime,
>>> +     info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
>>>                                                      tsk->signal->utime));
>>> -     info.si_stime = cputime_to_jiffies(cputime_add(tsk->stime,
>>> +     info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
>>>                                                      tsk->signal->stime));
>>>
>>>       info.si_status = tsk->exit_code & 0x7f;
>>> @@ -1450,9 +1449,8 @@
>>>
>>>       info.si_uid = tsk->uid;
>>>
>>> -     /* FIXME: find out whether or not this is supposed to be c*time. */
>>> -     info.si_utime = cputime_to_jiffies(tsk->utime);
>>> -     info.si_stime = cputime_to_jiffies(tsk->stime);
>>> +     info.si_utime = cputime_to_clock_t(tsk->utime);
>>> +     info.si_stime = cputime_to_clock_t(tsk->stime);
>>>
>>>       info.si_code = why;
>>>       switch (why) {
>>
>> This looks like the obviously good fix to me.
>
> Tested now, and it does what I expect.
>
>> The patch also deletes the comment about signal_struct->cXtime,
>> this also looks right: why should we use cutime/cstime ?
>
> Hmmm -- maybe I was wrong to delete that comment.  I think the point
> of the comment was: should the time returned vie these fields of the
> signinfo structure also include the times for (grand)children of the
> process that had terminated and been wait()ed for.  My first take on
> that was "no".  But now I'm not 100% sure.  A quick test on Solaris 8
> suggests that these fields *do* include the times of waited for
> children.  (None of this is specified in POSIX.1, which doesn't
> specify si_utime and si_stime.)  I've not yet tested FreeBSD (not sure
> if it supports these fields or not).

So, FreeBSD doesn't implement these fields.  A more extensive test
(see below) on Solaris (8) shows that it does indeed include the times
of waited-for children in the si_utime and si_stime fields.

I'm not sure if we should emulate that behavior or not - it'd be easy
enough to do so of course.  Thoughts, anyone?

Cheers,

Michael

Test
====

(If anyone has access to Tru64 or Irix, I'd be interested to see
results from the test program below.)

Using the test program below allows us to see the difference if the
child doesn't wait on it's child versus if it does wait.

# Child creates (grand)child that burns 1 second of CPU
# Child burns 2 seconds of CPU, and waits for 4 seconds
# Child does not wait on (grand)child

$ ./a.out 2 4 1
Child 17838 about to burn 1 secs
Child 17838 done
Finished burn
Finished sleep
waited for 0 children
SIGCHLD     si_status=0x0;  si_utime=37  si_stime=164

# Child creates (grand)child that burns 1 second of CPU
# Child burns 2 seconds of CPU, and waits for 4 seconds
# Child waits on (grand)child

$ ./a.out 2 4 1w
Child 17841 about to burn 1 secs
Child 17841 done
Finished burn
Finished sleep
About to wait for child 3 (1w), PID 17841
waited for 1 children
SIGCHLD     si_status=0x0;  si_utime=59  si_stime=243

==================

/* sigchld_siginfo_time_test.c

   Copyright 2008, Linux Foundation
   Author: Michael Kerrisk <mtk.manpages@gmail.com>
   Licensed under GPLv2 or later
*/
#include <signal.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>


#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

#define usageErr(msg, progName) \
                        do { fprintf(stderr, "Usage: "); \
                             fprintf(stderr, msg, progName); \
                             exit(EXIT_FAILURE); } while (0)

static void
handler(int sig, siginfo_t *siginfo, void *arg)
{
    printf("SIGCHLD     si_status=0x%x;  ",
            (unsigned int) siginfo->si_status);
    printf("si_utime=%ld  si_stime=%ld\n",
            siginfo->si_utime, siginfo->si_stime);
} /* handler */


static void
burn(int nsecs)
{
    struct rusage start, curr;
    float t;

    if (getrusage(RUSAGE_SELF, &start) == -1) errExit("getrusage");

    for (;;) {
        if (getrusage(RUSAGE_SELF, &curr) == -1)
            errExit("getrusage");

        t = (curr.ru_utime.tv_sec - start.ru_utime.tv_sec) * 1000000 +
                        (curr.ru_utime.tv_usec - start.ru_utime.tv_usec) +
            (curr.ru_stime.tv_sec - start.ru_stime.tv_sec) * 1000000 +
                        (curr.ru_stime.tv_usec - start.ru_stime.tv_usec);

        if (t > nsecs * 1000000)
            break;
    }
} /* burn */


static void
doChild(int argc, char *argv[])
{
    int cn, waited, rtime;
    pid_t *childList;
    char *ep;

    if (signal(SIGCHLD, SIG_DFL) == SIG_ERR) errExit("signal");

    childList = calloc(argc, sizeof(pid_t));
    if (childList == NULL)
        errExit("calloc");

    for (cn = 3; cn < argc; cn++) {
        rtime = strtol(argv[cn], &ep, 0);

        childList[cn] = fork();
        if (childList[cn] == -1)
            errExit("fork");

        if (childList[cn] == 0) {
            printf("Child %ld about to burn %d secs\n",
                    (long) getpid(), rtime);
            burn(rtime);
            printf("Child %ld done\n", (long) getpid());
            exit(EXIT_SUCCESS);
        } else {
            if (*ep == '\0')
                childList[cn] = -childList[cn]; /* Don't waitpid() */
        }
    }

    /* Burn some CPU time ourselves */

    burn(atoi(argv[1]));
    printf("Finished burn\n");

    /* Optionally sleep for a while, so as to allow children that we
       don't wait for to terminate */

    sleep(atoi(argv[2]));
    printf("Finished sleep\n");

    /* Wait for children */

    waited = 0;
    for (cn = 3; cn < argc; cn++) {
        if (childList[cn] > 0) {
            printf("About to wait for child %d (%s), PID %ld\n",
                    cn, argv[cn], (long) childList[cn]);
            if (waitpid(childList[cn], NULL, 0) == -1) errExit("waitpid");
            waited++;
        }
    }

    printf("waited for %d children\n", waited);
} /* doChild */

int
main(int argc, char *argv[])
{
    struct sigaction sa;
    pid_t childPid;

    if (argc < 4 || strcmp(argv[1], "--help") == 0)
        usageErr("%s <child-run-time> <child-sleep-time> "
                "<nsecs>[w]...\n", argv[0]);

    sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = handler;
    sigemptyset(&sa.sa_mask);
    if (sigaction(SIGCHLD, &sa, NULL) == -1) errExit("sigaction");

    childPid = fork();

    if (childPid == -1)
        errExit("fork");

    if (childPid == 0) {
        doChild(argc, argv);
        exit(EXIT_SUCCESS);
    }

    pause();    /* Wait for SIGCHLD */

    exit(EXIT_SUCCESS);
} /* main */
