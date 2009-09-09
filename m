Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZIISEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZIISEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZIISEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:04:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36442 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZIISEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:04:08 -0400
Date: Wed, 9 Sep 2009 20:04:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090909180404.GA11027@elte.hu>
References: <20090907173846.GB18599@kernel.dk> <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20090909122006.GA18599@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Sep 09 2009, Jens Axboe wrote:
> > On Wed, Sep 09 2009, Jens Axboe wrote:
> > > On Wed, Sep 09 2009, Mike Galbraith wrote:
> > > > On Wed, 2009-09-09 at 08:13 +0200, Ingo Molnar wrote:
> > > > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > 
> > > > > > On Tue, Sep 08 2009, Peter Zijlstra wrote:
> > > > > > > On Tue, 2009-09-08 at 11:13 +0200, Jens Axboe wrote:
> > > > > > > > And here's a newer version.
> > > > > > > 
> > > > > > > I tinkered a bit with your proglet and finally found the 
> > > > > > > problem.
> > > > > > > 
> > > > > > > You used a single pipe per child, this means the loop in 
> > > > > > > run_child() would consume what it just wrote out until it got 
> > > > > > > force preempted by the parent which would also get woken.
> > > > > > > 
> > > > > > > This results in the child spinning a while (its full quota) and 
> > > > > > > only reporting the last timestamp to the parent.
> > > > > > 
> > > > > > Oh doh, that's not well thought out. Well it was a quick hack :-) 
> > > > > > Thanks for the fixup, now it's at least usable to some degree.
> > > > > 
> > > > > What kind of latencies does it report on your box?
> > > > > 
> > > > > Our vanilla scheduler default latency targets are:
> > > > > 
> > > > >   single-core: 20 msecs
> > > > >     dual-core: 40 msecs
> > > > >     quad-core: 60 msecs
> > > > >     opto-core: 80 msecs
> > > > > 
> > > > > You can enable CONFIG_SCHED_DEBUG=y and set it directly as well via 
> > > > > /proc/sys/kernel/sched_latency_ns:
> > > > > 
> > > > >    echo 10000000 > /proc/sys/kernel/sched_latency_ns
> > > > 
> > > > He would also need to lower min_granularity, otherwise, it'd be larger
> > > > than the whole latency target.
> > > > 
> > > > I'm testing right now, and one thing that is definitely a problem is the
> > > > amount of sleeper fairness we're giving.  A full latency is just too
> > > > much short term fairness in my testing.  While sleepers are catching up,
> > > > hogs languish.  That's the biggest issue going on.
> > > > 
> > > > I've also been doing some timings of make -j4 (looking at idle time),
> > > > and find that child_runs_first is mildly detrimental to fork/exec load,
> > > > as are buddies.
> > > > 
> > > > I'm running with the below at the moment.  (the kthread/workqueue thing
> > > > is just because I don't see any reason for it to exist, so consider it
> > > > to be a waste of perfectly good math;)
> > > 
> > > Using latt, it seems better than -rc9. The below are entries logged
> > > while running make -j128 on a 64 thread box. I did two runs on each, and
> > > latt is using 8 clients.
> > > 
> > > -rc9
> > >         Max                23772 usec
> > >         Avg                 1129 usec
> > >         Stdev               4328 usec
> > >         Stdev mean           117 usec
> > > 
> > >         Max                32709 usec
> > >         Avg                 1467 usec
> > >         Stdev               5095 usec
> > >         Stdev mean           136 usec
> > > 
> > > -rc9 + patch
> > > 
> > >         Max                11561 usec
> > >         Avg                 1532 usec
> > >         Stdev               1994 usec
> > >         Stdev mean            48 usec
> > > 
> > >         Max                 9590 usec
> > >         Avg                 1550 usec
> > >         Stdev               2051 usec
> > >         Stdev mean            50 usec
> > > 
> > > max latency is way down, and much smaller variation as well.
> > 
> > Things are much better with this patch on the notebook! I cannot compare
> > with BFS as that still doesn't run anywhere I want it to run, but it's
> > way better than -rc9-git stock. latt numbers on the notebook have 1/3
> > the max latency, average is lower, and stddev is much smaller too.
> 
> BFS210 runs on the laptop (dual core intel core duo). With make -j4
> running, I clock the following latt -c8 'sleep 10' latencies:
> 
> -rc9
> 
>         Max                17895 usec
>         Avg                 8028 usec
>         Stdev               5948 usec
>         Stdev mean           405 usec
> 
>         Max                17896 usec
>         Avg                 4951 usec
>         Stdev               6278 usec
>         Stdev mean           427 usec
> 
>         Max                17885 usec
>         Avg                 5526 usec
>         Stdev               6819 usec
>         Stdev mean           464 usec
> 
> -rc9 + mike
> 
>         Max                 6061 usec
>         Avg                 3797 usec
>         Stdev               1726 usec
>         Stdev mean           117 usec
> 
>         Max                 5122 usec
>         Avg                 3958 usec
>         Stdev               1697 usec
>         Stdev mean           115 usec
> 
>         Max                 6691 usec
>         Avg                 2130 usec
>         Stdev               2165 usec
>         Stdev mean           147 usec

At least in my tests these latencies were mainly due to a bug in 
latt.c - i've attached the fixed version.

The other reason was wakeup batching. If you do this:

   echo 0 > /proc/sys/kernel/sched_wakeup_granularity_ns 

... then you can switch on insta-wakeups on -tip too.

With a dual-core box and a make -j4 background job running, on 
latest -tip i get the following latencies:

 $ ./latt -c8 sleep 30
 Entries: 656 (clients=8)

 Averages:
 ------------------------------ 
 	Max	      158 usec 
	Avg	       12 usec
	Stdev	       10 usec

Thanks,

	Ingo

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="latt.c"

/*
 * Simple latency tester that combines multiple processes.
 *
 * Compile: gcc -Wall -O2 -D_GNU_SOURCE -lrt -lm -o latt latt.c
 *
 * Run with: latt -c8 'program --args'
 *
 * Options:
 *
 *	-cX	Use X number of clients
 *	-fX	Use X msec as the minimum sleep time for the parent
 *	-tX	Use X msec as the maximum sleep time for the parent
 *	-v	Print all delays as they are logged
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <getopt.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <time.h>
#include <math.h>
#include <poll.h>
#include <pthread.h>


/*
 * In msecs
 */
static unsigned int min_delay = 100;
static unsigned int max_delay = 500;
static unsigned int clients = 1;
static unsigned int verbose;

#define MAX_CLIENTS		512

struct stats
{
	double n, mean, M2, max;
	int max_pid;
};

static void update_stats(struct stats *stats, unsigned long long val)
{
	double delta, x = val;

	stats->n++;
	delta = x - stats->mean;
	stats->mean += delta / stats->n;
	stats->M2 += delta*(x - stats->mean);

	if (stats->max < x)
		stats->max = x;
}

static unsigned long nr_stats(struct stats *stats)
{
	return stats->n;
}

static double max_stats(struct stats *stats)
{
	return stats->max;
}

static double avg_stats(struct stats *stats)
{
	return stats->mean;
}

/*
 * http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
 *
 *       (\Sum n_i^2) - ((\Sum n_i)^2)/n
 * s^2 = -------------------------------
 *                  n - 1
 *
 * http://en.wikipedia.org/wiki/Stddev
 */
static double stddev_stats(struct stats *stats)
{
	double variance = stats->M2 / (stats->n - 1);

	return sqrt(variance);
}

struct stats delay_stats;

static int pipes[MAX_CLIENTS*2][2];

static pid_t app_pid;

#define CLOCKSOURCE		CLOCK_MONOTONIC

struct sem {
	pthread_mutex_t lock;
	pthread_cond_t cond;
	int value;
	int waiters;
};

static void init_sem(struct sem *sem)
{
	pthread_mutexattr_t attr;
	pthread_condattr_t cond;

	pthread_mutexattr_init(&attr);
	pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
	pthread_condattr_init(&cond);
	pthread_condattr_setpshared(&cond, PTHREAD_PROCESS_SHARED);
	pthread_cond_init(&sem->cond, &cond);
	pthread_mutex_init(&sem->lock, &attr);

	sem->value = 0;
	sem->waiters = 0;
}

static void sem_down(struct sem *sem)
{
	pthread_mutex_lock(&sem->lock);

	while (!sem->value) {
		sem->waiters++;
		pthread_cond_wait(&sem->cond, &sem->lock);
		sem->waiters--;
	}

	sem->value--;
	pthread_mutex_unlock(&sem->lock);
}

static void sem_up(struct sem *sem)
{
	pthread_mutex_lock(&sem->lock);
	if (!sem->value && sem->waiters)
		pthread_cond_signal(&sem->cond);
	sem->value++;
	pthread_mutex_unlock(&sem->lock);
}

static int parse_options(int argc, char *argv[])
{
	struct option l_opts[] = {
		{ "min-delay", 	1, 	NULL,	'f' },
		{ "max-delay",	1,	NULL,	't' },
		{ "clients",	1,	NULL,	'c' },
		{ "verbose",	1,	NULL,	'v' }
	};
	int c, res, index = 0;

	while ((c = getopt_long(argc, argv, "f:t:c:v", l_opts, &res)) != -1) {
		index++;
		switch (c) {
			case 'f':
				min_delay = atoi(optarg);
				break;
			case 't':
				max_delay = atoi(optarg);
				break;
			case 'c':
				clients = atoi(optarg);
				if (clients > MAX_CLIENTS)
					clients = MAX_CLIENTS;
				break;
			case 'v':
				verbose = 1;
				break;
		}
	}

	return index + 1;
}

static pid_t fork_off(const char *app)
{
	pid_t pid;

	pid = fork();
	if (pid)
		return pid;

	exit(system(app));
}

static unsigned long usec_since(struct timespec *start, struct timespec *end)
{
	unsigned long long s, e;

	s = start->tv_sec * 1000000000ULL + start->tv_nsec;
	e =   end->tv_sec * 1000000000ULL +   end->tv_nsec;

	return (e - s) / 1000;
}

static void log_delay(unsigned long delay)
{
	if (verbose) {
		fprintf(stderr, "log delay %8lu usec (pid %d)\n", delay, getpid());
		fflush(stderr);
	}

	update_stats(&delay_stats, delay);
}

/*
 * Reads a timestamp (which is ignored, it's just a wakeup call), and replies
 * with the timestamp of when we saw it
 */
static void run_child(int *in, int *out, struct sem *sem)
{
	struct timespec ts;

	if (verbose) {
		fprintf(stderr, "present: %d\n", getpid());
		fflush(stderr);
	}

	sem_up(sem);

	do {
		int ret;

		ret = read(in[0], &ts, sizeof(ts));
		if (ret <= 0)
			break;

		if (ret != sizeof(ts))
			printf("bugger3\n");

		clock_gettime(CLOCKSOURCE, &ts);

		ret = write(out[1], &ts, sizeof(ts));
		if (ret <= 0)
			break;

		if (ret != sizeof(ts))
			printf("bugger4\n");

		if (verbose) {
			fprintf(stderr, "alife: %d\n", getpid());
			fflush(stderr);
		}
	} while (1);
}

/*
 * Do a random sleep between min and max delay
 */
static void do_rand_sleep(void)
{
	unsigned int msecs;

	msecs = min_delay + ((float) max_delay * (rand() / (RAND_MAX + 1.0)));
	if (verbose) {
		fprintf(stderr, "sleeping for: %u msec\n", msecs);
		fflush(stderr);
	}
	usleep(msecs * 1000);
}

static void kill_connection(void)
{
	int i;

	for (i = 0; i < 2*clients; i++) {
		if (pipes[i][0] != -1) {
			close(pipes[i][0]);
			pipes[i][0] = -1;
		}
		if (pipes[i][1] != -1) {
			close(pipes[i][1]);
			pipes[i][1] = -1;
		}
	}
}

static int __write_ts(int i, struct timespec *ts)
{
	int fd = pipes[2*i][1];

	clock_gettime(CLOCKSOURCE, ts);

	return write(fd, ts, sizeof(*ts)) != sizeof(*ts);
}

static long __read_ts(int i, struct timespec *ts, pid_t *cpids)
{
	int fd = pipes[2*i+1][0];
	struct timespec t;

	if (read(fd, &t, sizeof(t)) != sizeof(t))
		return -1;

	log_delay(usec_since(ts, &t));
	if (verbose)
		fprintf(stderr, "got delay %ld from child %d [pid %d]\n", usec_since(ts, &t), i, cpids[i]);

	return 0;
}

static int read_ts(struct pollfd *pfd, unsigned int nr, struct timespec *ts,
		   pid_t *cpids)
{
	unsigned int i;

	for (i = 0; i < clients; i++) {
		if (pfd[i].revents & (POLLERR | POLLHUP | POLLNVAL))
			return -1L;
		if (pfd[i].revents & POLLIN) {
			pfd[i].events = 0;
			if (__read_ts(i, &ts[i], cpids))
				return -1L;
			nr--;
		}
		if (!nr)
			break;
	}

	return 0;
}

static int app_has_exited(void)
{
	int ret, status;

	/*
	 * If our app has exited, stop
	 */
	ret = waitpid(app_pid, &status, WNOHANG);
	if (ret < 0) {
		perror("waitpid");
		return 1;
	} else if (ret == app_pid &&
		   (WIFSIGNALED(status) || WIFEXITED(status))) {
		return 1;
	}

	return 0;
}

/*
 * While our given app is running, send a timestamp to each client and
 * log the maximum latency for each of them to wakeup and reply
 */
static void run_parent(pid_t *cpids)
{
	struct pollfd *ipfd;
	int do_exit = 0, i;
	struct timespec *t1;

	t1 = malloc(sizeof(struct timespec) * clients);
	ipfd = malloc(sizeof(struct pollfd) * clients);

	srand(1234);

	do {
		unsigned pending_events;

		do_rand_sleep();

		if (app_has_exited())
			break;

		for (i = 0; i < clients; i++) {
			ipfd[i].fd = pipes[2*i+1][0];
			ipfd[i].events = POLLIN;
		}

		/*
		 * Write wakeup calls
		 */
		for (i = 0; i < clients; i++) {
			if (verbose) {
				fprintf(stderr, "waking: %d\n", cpids[i]);
				fflush(stderr);
			}

			if (__write_ts(i, t1+i)) {
				do_exit = 1;
				break;
			}
		}

		if (do_exit)
			break;

		/*
		 * Poll and read replies
		 */
		pending_events = clients;
		while (pending_events) {
			int evts = poll(ipfd, clients, -1);

			if (evts < 0) {
				do_exit = 1;
				break;
			} else if (!evts) {
				printf("bugger2\n");
				continue;
			}

			if (read_ts(ipfd, evts, t1, cpids)) {
				do_exit = 1;
				break;
			}

			pending_events -= evts;
		}
	} while (!do_exit);

	free(t1);
	free(ipfd);
	kill_connection();
}

static void run_test(void)
{
	struct sem *sem;
	pid_t *cpids;
	int i, status;

	sem = mmap(NULL, sizeof(*sem), PROT_READ|PROT_WRITE,
			MAP_SHARED | MAP_ANONYMOUS, 0, 0);
	if (sem == MAP_FAILED) {
		perror("mmap");
		return;
	}

	init_sem(sem);

	for (i = 0; i < 2*clients; i++) {
		if (pipe(pipes[i])) {
			perror("pipe");
			return;
		}
	}

	cpids = malloc(sizeof(pid_t) * clients);

	for (i = 0; i < clients; i++) {
		cpids[i] = fork();
		if (cpids[i]) {
			sem_down(sem);
			continue;
		}

		run_child(pipes[2*i], pipes[2*i+1], sem);
		exit(0);
	}

	run_parent(cpids);

	for (i = 0; i < clients; i++)
		kill(cpids[i], SIGQUIT);
	for (i = 0; i < clients; i++)
		waitpid(cpids[i], &status, 0);

	free(cpids);
	munmap(sem, sizeof(*sem));
}

static void handle_sigint(int sig)
{
	kill(app_pid, SIGINT);
}

int main(int argc, char *argv[])
{
	int app_offset, off;
	char app[256];

	off = 0;
	app_offset = parse_options(argc, argv);
	while (app_offset < argc) {
		if (off) {
			app[off] = ' ';
			off++;
		}
		off += sprintf(app + off, "%s", argv[app_offset]);
		app_offset++;
	}

	signal(SIGINT, handle_sigint);

	/*
	 * Start app and start logging latencies
	 */
	app_pid = fork_off(app);
	run_test();

	printf("Entries: %lu (clients=%d)\n", nr_stats(&delay_stats), clients);
	printf("\nAverages:\n");
	printf("------------------------------\n");
	printf("\tMax\t %8.0f usec\n", max_stats(&delay_stats));
	printf("\tAvg\t %8.0f usec\n", avg_stats(&delay_stats));
	printf("\tStdev\t %8.0f usec\n", stddev_stats(&delay_stats));

	return 0;
}

--WIyZ46R2i8wDzkSu--
