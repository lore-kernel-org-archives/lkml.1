Return-Path: <linux-kernel-owner+w=401wt.eu-S1762094AbZE1NA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbZE1NA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbZE1NAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:00:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:59563 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbZE1NAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:00:13 -0400
From: Olaf Kirch <okir@suse.de>
To: linux-kernel@vger.kernel.org
Subject: CFS Performance Issues
Date: Thu, 28 May 2009 15:02:22 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: mingo@redhat.com, Andreas Gruenbacher <agruen@suse.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_etoHK7gn4r87wru"
Message-Id: <200905281502.22487.okir@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_etoHK7gn4r87wru
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi Ingo,

As you probably know, we've been chasing a variety of performance issues
on our SLE11 kernel, and one of the suspects has been CFS for quite a
while. The benchmarks that pointed to CFS include AIM7, dbench, and a few
others, but the picture has been a bit hazy as to what is really the problem here.

Now IBM recently told us they had played around with some scheduler
tunables and found that by turning off NEW_FAIR_SCHEDULERS, they
could make the regression on a compute benchmark go away completely.
We're currently working on rerunning other benchmarks with NEW_FAIR_SLEEPERS
turned off to see whether it has an impact on these as well.

Of course, the first question we asked ourselves was, how can NEW_FAIR_SLEEPERS
affect a benchmark that rarely sleeps, or not at all?

The answer was, it's not affecting the benchmark processes, but some noise
going on in the background. When I was first able to reproduce this on my work
station, it was knotify4 running in the background - using hardly any CPU, but
getting woken up ~1000 times a second. Don't ask me what it's doing :-)

So I sat down and reproduced this; the most recent iteration of the test program
is courtesy of Andreas Gruenbacher (see below).

This program spawns a number of processes that just spin in a loop. It also spawns
a single process that wakes up 1000 times a second. Every second, it computes the
average time slice per process (utime / number of involuntary context switches),
and prints out the overall average time slice and average utime.

While running this program, you can conveniently enable or disable fair sleepers.
When I do this on my test machine (no desktop in the background this time :-)
I see this:

./slice 16
    avg slice:  1.12 utime: 216263.187500
    avg slice:  0.25 utime: 125507.687500
    avg slice:  0.31 utime: 125257.937500
    avg slice:  0.31 utime: 125507.812500
    avg slice:  0.12 utime: 124507.875000
    avg slice:  0.38 utime: 124757.687500
    avg slice:  0.31 utime: 125508.000000
    avg slice:  0.44 utime: 125757.750000
    avg slice:  2.00 utime: 128258.000000
 ------ here I turned off new_fair_sleepers ----
    avg slice: 10.25 utime: 137008.500000
    avg slice:  9.31 utime: 139008.875000
    avg slice: 10.50 utime: 141508.687500
    avg slice:  9.44 utime: 139258.750000
    avg slice: 10.31 utime: 140008.687500
    avg slice:  9.19 utime: 139008.625000
    avg slice: 10.00 utime: 137258.625000
    avg slice: 10.06 utime: 135258.562500
    avg slice:  9.62 utime: 138758.562500

As you can see, the average time slice is *extremely* low with new fair
sleepers enabled. Turning it off, we get ~10ms time slices, and a
performance that is roughly 10% higher. It looks like this kind of
"silly time slice syndrome" is what is really eating performance here.

After staring at place_entity for a while, and by watching the process'
vruntime for a while, I think what's happening is this.

With fair sleepers turned off, a process that just got woken up will
get the vruntime of the process that's leftmost in the rbtree, and will
thus be placed to the right of the current task.

However, with fair_sleepers enabled, a newly woken up process
will retain its old vruntime as long as it's less than sched_latency
in the past, and thus it will be placed to the very left in the rbtree.
Since a task that is mostly sleeping will never accrue vruntime at
the same rate a cpu-bound task does, it will always preempt any
running task almost immediately after it's scheduled.

Does this make sense?

Any insight you can offer here is greatly appreciated!

Thanks,
Olaf
-- 
Neo didn't bring down the Matrix. SOA did.
				--soafacts.com


--Boundary-00=_etoHK7gn4r87wru
Content-Type: text/x-csrc;
  charset="UTF-8";
  name="slice.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="slice.c"

/*
 * from agruen - 2009 05 28
 *
 * Test time slices given to each process
 */
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <sys/stat.h>
#include <signal.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#undef WITH_PER_PROCESS_SLICES

struct msg {
	long mtype;
	long nivcsw;
	long utime;
};

int msqid;

void report_to_parent(int dummy) {
	static long old_nivcsw, old_utime;
	long utime;
	struct rusage usage;
	struct msg msg;

	getrusage(RUSAGE_SELF, &usage);

	utime = usage.ru_utime.tv_sec * 1000000 + usage.ru_utime.tv_usec;

	msg.mtype = 1;
	msg.nivcsw = usage.ru_nivcsw - old_nivcsw;
	msg.utime = utime - old_utime;
	msgsnd(msqid, &msg, sizeof(msg) - sizeof(long), 0);

	old_nivcsw = usage.ru_nivcsw;
	old_utime = utime;
}

void worker(void) {
	struct sigaction sa;

	sa.sa_handler = report_to_parent;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	sigaction(SIGALRM, &sa, NULL);

	while (1)
		/* do nothing */ ;
}

void sleeper(void) {

	while (1) {
		usleep(1000);
	}
}

int main(int argc, char *argv[])
{
	int n, nproc;
	pid_t *pid;

	if (argc != 2) {
		fprintf(stderr, "Usage: %s <number-of-processes>\n", argv[0]);
		return 1;
	}
	
	msqid = msgget(IPC_PRIVATE, S_IRUSR | S_IWUSR);

	nproc = atoi(argv[1]);
	pid = malloc(nproc * sizeof(pid_t));
	for (n = 0; n < nproc; n++) {
		pid[n] = fork();
		if (pid[n] == 0)
			worker();
	}

	/* Fork sleeper(s) */
	for (n = 0; n < (nproc + 7)/8; n++)
		if (fork() == 0)
			sleeper();
	for(;;) {
		long avg_slice = 0, avg_utime = 0;

		sleep(1);
		for (n = 0; n < nproc; n++)
			kill(pid[n], SIGALRM);
		for (n = 0; n < nproc; n++) {
			struct msg msg;
			double slice;

			msgrcv(msqid, &msg, sizeof(msg) - sizeof(long), 0, 0);
			slice = 0.001 * msg.utime /
				        (msg.nivcsw ? msg.nivcsw : 1);
#ifdef WITH_PER_PROCESS_SLICES
			printf("%6.1f ", slice);
#endif

			avg_slice += slice;
			avg_utime += msg.utime;
		}

		printf("    avg slice: %5.2f utime: %f",
				(double) avg_slice / nproc,
				(double) avg_utime / nproc);
		printf("\n");
	}

	return 0;
}

--Boundary-00=_etoHK7gn4r87wru--
