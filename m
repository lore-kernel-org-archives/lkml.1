Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbZAER4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbZAER4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZAER4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:56:46 -0500
Received: from relay3.sgi.com ([192.48.171.31]:49105 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750834AbZAER4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:56:45 -0500
Date: Mon, 5 Jan 2009 11:56:41 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Greg KH <greg@kroah.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>
Subject: 2.6.27.8 scheduler bug - threads not being scheduled for long periods
Message-ID: <20090105175641.GA17055@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This concerns a scheduler bug that we've been looking at in 2.6.27.8 on
ia64 Altix machines.

Below is the current testcase that we're using to reproduce this problem.

The test should be run as follows:
	taskset -c <cpu> t -c <another cpu> -n <non-zero nice level>

It creates 5 pthreads.  Each of those threads changes their thread affinity
to the cpu passed in, sets their nice value to the passed in value, and
counts in a loop.

Depending on what cpus are chosen for the pair of cpus passed into taskset
and the test itself, output will look something like the following:

# taskset -c 3 t -c 2 -n -5
Create thread 0
Create thread 1
slave 0: pid 4086 cpu 2 nlevel -5
Create thread 2
slave 1: pid 4087 cpu 2 nlevel -5
Create thread 3
slave 2: pid 4088 cpu 2 nlevel -5
Create thread 4
slave 3: pid 4089 cpu 2 nlevel -5
slave 4: pid 4090 cpu 2 nlevel -5
Wait ready
GO
Counts:
0: 47996540
1: 47548033
2: 3419
3: 3249
4: 67665404

Counts:
0: 96877777
1: 95094916
2: 3419
3: 3249
4: 116545241

Note that threads 2 and 3 have stopped running.   They will eventually run
at some time in the future, but this length of time can be extremely long
depending on the pair of cpus chosen.  The test usually fails with the same
pattern if the same pair of cpus is always chosen.  It will run differently
for different cpu pairs, and will run fine for certain pairs of cpus.

After some examination we've found the overall reason for this.  The
runqueue rb tree is sorted by the vruntime value associated with each
thread.  These vruntime values can occasionally get set to values far above
other thread's vruntime values, leaving those threads to starve waiting to
be moved up in the runqueue.

One place we've found this happens is in update_curr(), which calculates a
delta_exec value as follows:
	delta_exec = (unsigned long)(now - curr->exec_start);

Sometimes this value will be very large, as 'now' (the rq clock time) will
be less than 'exec_start'.  When this happens, __update_curr() will
calculate a delta_exec_weighted based on this large value and add it to the
thread's vruntime:
	curr->vruntime += delta_exec_weighted;

For this particular case, we've found that if we add a hack to clamp the
calculation of delta_exec to always be positive, this will allow the above
testcase to run.

+	if (now < curr->exec_start)
+		curr->exec_start = now - 1;

	delta_exec = (unsigned long)(now - curr->exec_start);


I'm wondering if anyone else has run into this problem, and whether they've
found a resolution for it?


/*
 * gcc -o jtest jtest.c -lpthread
 * jtest -c8 -v
 */
#define _GNU_SOURCE 1
#include <sched.h>
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/syscall.h>
#include <sys/types.h>

#define NTHR 5
#define perrorx(s) do {perror(s); exit(1);} while (0)

extern int optind, opterr;
extern char *optarg;

static void *slave(void *arg);

volatile int ready, go = 0;

struct slave_s {
	int cpu;
	int id;
	int nlevel;
} slave_t[NTHR];

unsigned long x[NTHR];

static int runonx(int cpu)
{
        cpu_set_t mask;

        if (cpu < 0 || cpu >= 1024)
                return -1;
        memset(&mask, 0, sizeof (mask));
        CPU_SET(cpu, &mask);
        if (sched_setaffinity(0, sizeof(mask), &mask) < 0)
                perrorx("setaffinity failed");
        return 0;
}

int main(int argc, char **argv)
{
        int c, th, k = 0, er = 0;
        int cpu = 1;
	int nlevel = 0;
	unsigned loops = (unsigned)-1;
	unsigned long i = 0;
        static char optstr[] = "c:l:n:v";
        pthread_t *threads;

        opterr = 1;
        while ((c = getopt(argc, argv, optstr)) != EOF)
                switch (c) {
                case 'c':
                        cpu = atoi(optarg);
                        break;
                case 'l':
                        loops = atoi(optarg);
                        break;
                case 'n':
                        nlevel = atoi(optarg);
                        break;
                case '?':
                        er = 1;
                        break;
                }

        if (er)
                exit(1);

sleep(1);
        threads = malloc(sizeof(pthread_t) * NTHR);
        for (th = 0; th < NTHR; th++) {
                printf("Create thread %d\n", th);
		slave_t[th].cpu = cpu;
		slave_t[th].id = th;
		slave_t[th].nlevel = nlevel;
                if (pthread_create(&threads[th], NULL, slave, (void *)&slave_t[th]) != 0)
                        perrorx("pthread_create failed:");
        }
	runonx(cpu);
	if (1 || nlevel) {
		errno = 0;
		if (nice(nlevel) == -1 && errno) {
			perror("nice");
			exit(-1);
		}
	}

        printf("Wait ready\n");
        while (ready < NTHR)
                usleep(10000);
        printf("GO\n");
	while(k<loops) {
		i++;
		if (i % 10000000 == 0) {
			int j;
			printf("Counts:\n");
			for (j=0; j<NTHR; j++)
				printf("%d: %lu\n",j,x[j]);
			printf("\n");
			k++;
		}
	}
        go++;
        for (th = 0; th < NTHR; th++)
                pthread_join(threads[th], NULL);
        printf("Master Done\n");
        return 0;
}


static void *slave(void *arg)
{
        struct slave_s * s = (struct slave_s *)arg;

	runonx(s->cpu);
	if (1 || s->nlevel) {
		errno = 0;
		if (nice(s->nlevel) == -1 && errno) {
			perror("nice");
			exit(-1);
		}
	}
        printf("slave %d: pid %ld cpu %d nlevel %d\n", s->id, syscall(SYS_gettid), s->cpu, s->nlevel);
        (void)__sync_fetch_and_add(&ready, 1);

        while (!go) {
		x[s->id]++;
	}

        printf("slave %d done\n", s->id);

        pthread_exit(0);
}
