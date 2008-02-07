Return-Path: <linux-kernel-owner+w=401wt.eu-S1764656AbYBGAuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764656AbYBGAuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbYBGAj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:39:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:37585 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764060AbYBGAjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:39:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:content-type:organization:date:
	message-id:mime-version:x-mailer;
	b=JhbGWr1rcrhV7BZb0tgonF3PxkY4iphmUNXso9i/uT2Hc1oQjIYsCLEceUmya+EVE
	yIJluLRvQ0eePg/8MXhqg==
Subject: Weird hang with NPTL and SIGPROF.
From: Frank Mayhar <fmayhar@google.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-wkD3mvd9M1LyVJ2PV3mA"
Organization: Google, Inc.
Date: Wed, 06 Feb 2008 16:37:31 -0800
Message-Id: <1202344651.8525.28.camel@peace.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wkD3mvd9M1LyVJ2PV3mA
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I have a testcase that demonstrates a strange hang of the latest kernel
(as well as previous ones).  In the process of investigating the NPTL,
we wrote a test that just creates a bunch of threads, then does a
barrier wait to synchronize them all, after which everybody exits.
That's all it does.

This works fine under most circumstances.  Unfortunately, we also want
to do profiling, so we catch SIGPROF and turn on ITIMER_PROF.  In this
case, at somewhere between 4000 and 4500 threads, and using the NPTL,
the system hangs.  It's not a hard hang, interrupts are still working
and clocks are ticking, but nothing is making progress.  It becomes
noticeable when the softlockup_tick() warning goes off after the
watchdog has been starved long enough.

Sometimes the system recovers and gets going again.  Other times it
doesn't.  I've examined the state of things several times with kdb and
there's certainly nothing obvious going on.  Something, perhaps having
to do with the scheduler, is certainly getting into a bad state, but I
haven't yet been able to figure out what that is.  I've even run it with
KFT and have seen nothing obvious there, either, except for the fact
that when it hangs it becomes obvious that it stops making progress and
it begins to fill up with smp_apic_timer_interrupt() and do_softirq()
entries.  I've also seen smp_apic_timer_interrupt() appear twice or more
on the stack, as if the previous run(s) didn't finish before the next
tick happened.

Any hints would be very much appreciated.  If you want to try to
reproduce it yourself, I've attached the testcase; I built it (under
Ubuntu) with
	gcc -D_GNU_SOURCE -c hangc-2.c -o hangc-2.o
	gcc -lpthread -o hangc-2 hangc-2.o

Note that I've also opened a Bugzilla bug for this issue, with the same
information and testcase, at
	http://bugzilla.kernel.org/show_bug.cgi?id=9906
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

--=-wkD3mvd9M1LyVJ2PV3mA
Content-Disposition: attachment; filename=hangc-2.c
Content-Type: text/x-csrc; name=hangc-2.c; charset=us-ascii
Content-Transfer-Encoding: 7bit


#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/time.h>
#include <unistd.h>
#include <ucontext.h>
#include <string.h>
#include <errno.h>

static void *
LinuxThreadTestRoutine(
	void *pid)
{
	pid_t *pid_ptr = (pid_t *) (pid);

	*pid_ptr = getpid();
	return NULL;
}

int
id_runningNPTL(void)
{
	int cc;
	pthread_t thread;
	pid_t child_pid;

	cc = pthread_create(&thread, NULL, &LinuxThreadTestRoutine, &child_pid);
	if (cc != 0) {
		perror("pthread_create");
		exit(1);
	}
	cc = pthread_join(thread, NULL);
	if (cc != 0) {
		perror("pthread_join");
		exit(1);
	}
	int is_linux_threads = (child_pid != getpid());

	return !is_linux_threads;
}



char const *
id_threads_package_string(void)
{
	return id_runningNPTL()? "NPTL" : "LinuxThreads";
}


typedef struct shared_args_t {
	unsigned n;
	pthread_barrier_t barrier;
} shared_args_t;

shared_args_t g_args;

void prof_handler(int sig, siginfo_t *foo, void *signal_ucontext)
{
	static int stk = 0;
	int saved_errno = errno;

	stk = 0;
	errno = saved_errno;
}

void *
nop1_inner(
	void *varg)
{
	int cc;
	cc = pthread_barrier_wait(&g_args.barrier);
	if ((cc != 0) && (cc != PTHREAD_BARRIER_SERIAL_THREAD)) {
		perror("pthread_barrier_wait");
		exit(1);
	}
	return NULL;
}

#define MAXTHREADS  (1024 * 1024)
pthread_t threads[MAXTHREADS];

int
main(
	int argc,
	char **argv)
{
	pthread_attr_t attr;
	unsigned nthreads;
	unsigned nops;
	unsigned i;
	int cc;
	struct sigaction sa;
	struct itimerval timer;

	sa.sa_sigaction = prof_handler;
	sa.sa_flags = SA_RESTART | SA_SIGINFO;
	sigemptyset(&sa.sa_mask);
	sigaction(SIGPROF, &sa, NULL);

	timer.it_interval.tv_sec = 0;
	timer.it_interval.tv_usec = 1000000 / 100;
	timer.it_value = timer.it_interval;
	setitimer(ITIMER_PROF, &timer, 0);
	cc = pthread_attr_init(&attr);
	if (cc != 0) {
		perror("pthread_attr_init");
		exit(1);
	}
	cc = pthread_attr_setstacksize(&attr, 16 * 1024);
	if (cc != 0) {
		perror("pthread_attr_setstacksize");
		exit(1);
	}
	if (argc != 3) {
		fputs("Usage: hangc THREADS BARRIER-OPS-PER-THREAD\n", stderr);
		exit(1);
	}

	nthreads = strtoul(argv[1], NULL, 0);
	if (nthreads > MAXTHREADS) {
		perror("internal error: static allocation too small for THREADS arg");
		exit(1);
	}
	nops = strtoul(argv[2], NULL, 0);

	cc = pthread_barrier_init(&g_args.barrier, NULL, nthreads + 1);
	if (cc != 0) {
		perror("pthread_barrier_init");
		exit(1);
	}

	g_args.n = nops;

	for (i = 0; i < nthreads; ++i) {
		cc = pthread_create(&threads[i], &attr, nop1_inner, NULL);
		if (cc != 0) {
			perror("pthread_create");
			exit(1);
		}
	}

	printf("threads: %s\n", id_threads_package_string());
	exit(0);
}

--=-wkD3mvd9M1LyVJ2PV3mA--

