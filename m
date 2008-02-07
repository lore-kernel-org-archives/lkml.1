Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbYBGBB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbYBGBB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 20:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759779AbYBGBBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 20:01:05 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3972 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759207AbYBGBBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 20:01:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer;
	b=ltNxRuG09VSsaC+p7DrWi/pLV+0vAC1vy3OpiXt+MyL9XbmSX84tXMaGhHOgXhdIo
	GrtR/xaCTvb8uXASO3dsQ==
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
From: Frank Mayhar <fmayhar@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
In-Reply-To: <20080206165045.89b809cc.akpm@linux-foundation.org>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080206165045.89b809cc.akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-3DUK/7UqYBfjFq+42+tz"
Organization: Google, Inc.
Date: Wed, 06 Feb 2008 16:58:13 -0800
Message-Id: <1202345893.8525.33.camel@peace.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3DUK/7UqYBfjFq+42+tz
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2008-02-06 at 16:50 -0800, Andrew Morton wrote:
> It's probably better to handle this one via email, so please send that
> testcase vie reply-to-all to this email, thanks.

Testcase attached.

Build with
        gcc -D_GNU_SOURCE -c hangc-2.c -o hangc-2.o
        gcc -lpthread -o hangc-2 hangc-2.o

Run with
        hangc-2 4500 4500

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

--=-3DUK/7UqYBfjFq+42+tz
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

--=-3DUK/7UqYBfjFq+42+tz--

