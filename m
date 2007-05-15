Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbXEOQgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbXEOQgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 12:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbXEOQf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 12:35:56 -0400
Received: from mail128.messagelabs.com ([216.82.250.131]:48458 "HELO
	mail128.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756672AbXEOQfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 12:35:55 -0400
X-VirusChecked: Checked
X-Env-Sender: Steve.Hawkes@motorola.com
X-Msg-Ref: server-8.tower-128.messagelabs.com!1179246954!10076705!1
X-StarScan-Version: 5.5.10.7.1; banners=-,-,-
X-Originating-IP: [129.188.136.8]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Signal state of threads can be set incorrectly
Date: Tue, 15 May 2007 11:35:52 -0500
Message-ID: <7BFDACCD6948EF4D8FE8F4888A91596A01636E70@tx14exm60.ds.mot.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Signal state of threads can be set incorrectly
thread-index: AceXDxptzn6Vld8/Q2CEE+JPZIDLrg==
From: "Hawkes Steve-FSH016" <Steve.Hawkes@motorola.com>
To: <linux-kernel@vger.kernel.org>
X-Vontu: Pass
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've run into a scenario recently where the signal processing state of a
process can get out of whack--threads have a signal pending and
unblocked,
but the threads do not run.

I was pulled in to debug an issue where sometimes signals stopped being
processed in some threads within a process. It turns out the application
involved was using system() to invoke a command. While it is true that
system() is not multithread-safe and hence the application was not
properly
coded, it is disturbing that this particular application causes the
state of
threads within a process to be wrong.

Here's the scenario:

1) A process installs a signal handler for SIGINT.
2) The process sets SIGQUIT handling to SIG_IGN.
3) The process blocks a realtime signal it plans on using to implement a
timer.
4) The process creates several threads.
5) One of the threads is designed to process the timer events and calls
sigwaitinfo() to wait for the timer signal.
6) Another thread calls system() to run a command.
7) The timer expires and delivers the timer signal.
8) The thread blocked on sigwaitinfo() never wakes up even though the
kernel
shows that the signal is unblocked (due to the sigwaitinfo() call) and
queued.

After determining what triggered the failure, I wrote a test application
that duplicated the basic sequence of events. To increase the likelihood
of
the problem occurring, I increased the number of threads calling
sigwaitinfo() to ten. The test code is at the bottom of this message.
I've
reproduced the failure with reasonable consistency on both a 2.6.10 PPC
kernel and a 2.6.20 PPC kernel; I haven't yet reproduced it on the 2.6.9
i386 kernel I have available. Note that the failure mode is highly
timing
dependent and doesn't always occur.

When the test program works successfully, the output should look
something
like this:

Setting signal 2 to signal handler
Setting signal 3 to ignore
Blocking signal 41
signalThread 1 waiting for signal 41
signalThread 2 waiting for signal 41
signalThread 3 waiting for signal 41
signalThread 4 waiting for signal 41
signalThread 5 waiting for signal 41
signalThread 6 waiting for signal 41
signalThread 7 waiting for signal 41
signalThread 8 waiting for signal 41
signalThread 9 waiting for signal 41
signalThread 10 waiting for signal 41
system() returned 0
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
signalThread 2 exiting
signalThread 3 exiting
signalThread 4 exiting
signalThread 5 exiting
signalThread 6 exiting
signalThread 7 exiting
signalThread 8 exiting
signalThread 9 exiting
signalThread 10 exiting
signalThread 1 exiting

Here all of the threads blocked on sigwaitinfo() successfully completed
the
call and exited. In the failure mode typically only one thread unblocks,
as
shown below:

Setting signal 2 to signal handler
Setting signal 3 to ignore
Blocking signal 41
signalThread 1 waiting for signal 41
signalThread 2 waiting for signal 41
signalThread 3 waiting for signal 41
signalThread 4 waiting for signal 41
signalThread 5 waiting for signal 41
signalThread 6 waiting for signal 41
signalThread 7 waiting for signal 41
signalThread 8 waiting for signal 41
signalThread 9 waiting for signal 41
signalThread 10 waiting for signal 41
system() returned 0
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
Sending signal 41
signalThread 1 exiting

Checking the status of the threads with ps shows the following:

ps -mwopid,tid,stat,sig_pend,sig_block,sig_ignore,sig_catch,comm,wchan
<pid of test>

  PID   TID STAT           SIGNAL          BLOCKED          IGNORED
CATCHED COMMAND         WCHAN
12489     - -    0000010000000000                -                -
- signalbug4      -
    - 12489 Sl   0000000000000000 0000010000000000 0000000000000004
0000000180000002 -               hrtimer_nanosleep
    - 12490 Sl   0000000000000000 0000010000000000 0000000000000004
0000000180000002 -               futex
    - 12492 Sl   0000000000000000 0000000000000000 0000000000000004
0000000180000002 -               rt_sigtimedwait
    - 12493 Sl   0000000000000000 0000000000000000 0000000000000004
0000000180000002 -               rt_sigtimedwait
    - 12494 Sl   0000000000000000 0000000000000000 0000000000000004
0000000180000002 -               rt_sigtimedwait
    - 12495 Sl   0000000000000000 0000000000000000 0000000000000004
0000000180000002 -               rt_sigtimedwait
    - 12496 Sl   0000000000000000 0000000000000000 0000000000000004
0000000180000002 -               rt_sigtimedwait
    - 12497 Sl   0000000000000000 0000000000000000 0000000000000004
0000000180000002 -               rt_sigtimedwait
    - 12498 Sl   0000000000000000 0000000000000000 0000000000000004
0000000180000002 -               rt_sigtimedwait
    - 12499 Sl   0000000000000000 0000000000000000 0000000000000004
0000000180000002 -               rt_sigtimedwait
    - 12500 Sl   0000000000000000 0000000000000000 0000000000000004
0000000180000002 -               rt_sigtimedwait

The ps output shows the realtime signal is pending against the process
and
is unblocked and not ignored in the threads blocked on sigwaitinfo(),
but
yet those threads are not processing the signal. After instrumenting the
kernel I noticed that the task state for the problem threads had
TIF_SIGPENDING set, indicating they were ready to process the pending
signal.

The problem is triggered by use of the system() function. When the child
process spawned by system() exits, it delivers a SIGCHLD signal to the
parent process and also wakes up the parent process. At this point, the
thread that called system() has SIGCHLD blocked (due to internal
implementation of system()). However, other threads in the process do
not
have it blocked.

Now we have a race condition as to which runs first: a thread handling
SIGCHLD, or the thread blocked on waitpid() inside of system(). In the
former case, everything works fine; SIGCHLD is discarded by the thread
that
handles it because the process signal handler is SIG_IGN, then the
system()
thread unblocks and completes execution of system().

The failure occurs when the system() thread wins the race. In this case,
the SIGCHLD signal is pending and system() restores the previous signal
handlers for SIGINT and SIGQUIT. When restoring SIGQUIT to SIG_IGN, the
kernel executes the following do_sigaction() code in kernel/signal.c:

		if (act->sa.sa_handler == SIG_IGN ||
		   (act->sa.sa_handler == SIG_DFL &&
sig_kernel_ignore(sig))) {
			struct task_struct *t = current;
			sigemptyset(&mask);
			sigaddset(&mask, sig);
			rm_from_queue_full(&mask,
&t->signal->shared_pending);
			do {
				rm_from_queue_full(&mask, &t->pending);
				recalc_sigpending_tsk(t);
				t = next_thread(t);
			} while (t != current);
		}

Here the kernel goes through each thread in the process and clears any
pending instance of the signal if the handler is being set to SIG_IGN,
and
recalculates whether the threads are ready to process a pending signal
(recalc_sigpending_tsk()). In this specific scenario, SIGCHLD is pending
and
unblocked in most of the threads, so the TIF_SIGPENDING flag gets set
for
these threads. The system() code then unblocks SIGCHLD and completes,
and
one of the threads in the process handles the pending SIGCHLD signal.
Unfortunately, the remaining threads with TIF_SIGPENDING set are never
awakened nor do they have their state adjusted to reflect that the
signal
they were ready to process has gone away.

When the test code then queues a realtime signal to the threads blocked
on
sigwaitinfo(), those with TIF_SIGPENDING set are not unblocked even
though
they should be ready to complete the sigwaitinfo() call. This happens
because __group_complete_signal() determines through the wants_signal()
macro that the threads do not want the signal (because TIF_SIGPENDING is
already set). The end result is that the threads waiting in
sigwaitinfo()
with TIF_SIGPENDING set never awaken. Repeated delivery of the realtime
signal eventually causes the signal queue to be exhausted (which is what
caused us to notice the initial problem).

Note that suspending the process or attaching to it with gdb while it is
in
this state kicks things back into shape, presumably because the thread
signal state is properly recalculated as a result.

While the failure is triggered by improper use of system in a
multithreaded
application, is it reasonable that such an application error should
cause
the kernel to get confused on the signal state of threads? I'm also
concerned
that a similar failure could occur in a properly coded program using
sigaction().

Please copy steve dot hawkes at motorola dot com in follow-up posts.

Thanks,
Steve

----
/* gcc -o signaltest signaltest.c -lrt */
#include <stdio.h>
#include <pthread.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>


#define NUM_THREADS	10
#define SIG_TEST	(SIGRTMIN + 7)


pthread_mutex_t	systemMutex = PTHREAD_MUTEX_INITIALIZER;


void
signalHandler(int		sigNum,
		 siginfo_t*	sigInfo,
		 void*		context)
{
    printf("Signal %d signal handler\n", sigNum);
}

void*
systemThread(void*	arg)
{
    sleep(1);
    
    printf("system() returned %d\n", system("df > /dev/null"));

    pthread_mutex_lock(&systemMutex);
    printf("systemThread exiting\n");

    return (0);
}

void*
signalThread(void*	arg)
{
    sigset_t	sigSet;
    siginfo_t	sigInfo;

    sigemptyset(&sigSet);
    sigaddset(&sigSet, SIG_TEST);

    printf("signalThread %d waiting for signal %d\n", (int)arg,
SIG_TEST);
    while (sigwaitinfo(&sigSet, &sigInfo) < 0)
	;
    printf("signalThread %d exiting\n", (int)arg);
    
    return (0);
}

int
main(int	argc,
     char**	argv)
{
    int			count = 0;
    int			i;
    struct sigaction	sigAction;
    pthread_t		signalThreadId[NUM_THREADS];
    sigset_t		sigSet;
    union sigval	sigValue = { 0 };
    pthread_t		systemThreadId;

    printf("Setting signal %d to signal handler\n", SIGINT);
    sigAction.sa_sigaction =  signalHandler;
    sigAction.sa_flags     =  SA_SIGINFO;
    sigemptyset(&sigAction.sa_mask);
    sigaction(SIGINT, &sigAction, 0);

    printf("Setting signal %d to ignore\n", SIGQUIT);
    sigAction.sa_handler =  SIG_IGN;
    sigaction(SIGQUIT, &sigAction, 0);

    printf("Blocking signal %d\n", SIG_TEST);
    sigemptyset(&sigSet);
    sigaddset(&sigSet, SIG_TEST);
    pthread_sigmask(SIG_BLOCK, &sigSet, 0);
    
    pthread_mutex_lock(&systemMutex);

    pthread_create(&systemThreadId, 0, systemThread, 0);
    for (i = 0;  i < NUM_THREADS;  i++)
	pthread_create(&signalThreadId[i], 0, signalThread,
(void*)++count);

    sleep(5);
    for (i = 0;  i < NUM_THREADS;  i++)
    {
	printf("Sending signal %d\n", SIG_TEST);
	sigqueue(getpid(), SIG_TEST, sigValue);
    }
    
    sleep(10);
    
    return (0);
}
----
