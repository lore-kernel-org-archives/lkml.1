Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZIHJNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZIHJNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 05:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZIHJNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 05:13:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59646 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbZIHJND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 05:13:03 -0400
Date: Tue, 8 Sep 2009 11:13:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090908091304.GQ18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk> <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk> <20090907204458.GJ18599@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+jhVVhN62yS6hEJ8"
Content-Disposition: inline
In-Reply-To: <20090907204458.GJ18599@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 07 2009, Jens Axboe wrote:
> On Mon, Sep 07 2009, Jens Axboe wrote:
> > > And yes, it would be wonderful to get a test-app from you that would 
> > > express the kind of pain you are seeing during compile jobs.
> > 
> > I was hoping this one would, but it's not showing anything. I even added
> > support for doing the ping and wakeup over a socket, to see if the pipe
> > test was doing well because of the sync wakeup we do there. The net
> > latency is a little worse, but still good. So no luck in making that app
> > so far.
> 
> Here's a version that bounces timestamps between a producer and a number
> of consumers (clients). Not really tested much, but perhaps someone can
> compare this on a box that boots BFS and see what happens.

And here's a newer version. It ensures that clients are running before
sending a timestamp, and it drops the first and last log entry to
eliminate any weird effects there. Accuracy should also be improved.

On an idle box, it'll usually log all zeroes. Sometimes I see 3-4msec
latencies, weird.

-- 
Jens Axboe


--+jhVVhN62yS6hEJ8
Content-Type: text/x-csrc; charset=us-ascii
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

struct delays {
	unsigned long nr_delays;
	unsigned long total_entries;
	unsigned long max_delay;
	unsigned long delays[0];
};

#define entries_to_size(n)	\
	((n) * sizeof(unsigned long) + sizeof(struct delays))

static struct delays *delays;
static int pipes[MAX_CLIENTS][2];

static unsigned long avg;
static double stddev;

static pid_t app_pid;

#define CLOCKSOURCE		CLOCK_MONOTONIC

#define DEF_ENTRIES		1024

struct mutex {
	pthread_mutex_t lock;
	pthread_cond_t cond;
	int value;
	int waiters;
};

static void init_mutex(struct mutex *mutex)
{
	pthread_mutexattr_t attr;
	pthread_condattr_t cond;

	pthread_mutexattr_init(&attr);
	pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
	pthread_condattr_init(&cond);
	pthread_condattr_setpshared(&cond, PTHREAD_PROCESS_SHARED);
	pthread_cond_init(&mutex->cond, &cond);
	pthread_mutex_init(&mutex->lock, &attr);

	mutex->value = 0;
	mutex->waiters = 0;
}

static void mutex_down(struct mutex *mutex)
{
	pthread_mutex_lock(&mutex->lock);

	while (!mutex->value) {
		mutex->waiters++;
		pthread_cond_wait(&mutex->cond, &mutex->lock);
		mutex->waiters--;
	}

	mutex->value--;
	pthread_mutex_unlock(&mutex->lock);
}

static void mutex_up(struct mutex *mutex)
{
	pthread_mutex_lock(&mutex->lock);
	if (!mutex->value && mutex->waiters)
		pthread_cond_signal(&mutex->cond);
	mutex->value++;
	pthread_mutex_unlock(&mutex->lock);
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
	long secs, nsecs;

	secs = end->tv_sec - start->tv_sec;
	nsecs = end->tv_nsec - start->tv_nsec;

	return secs * 1000000L + nsecs / 1000;
}

static void log_delay(unsigned long delay)
{
	if (verbose)
		printf("log delay %8lu usec\n", delay);

	if (delays->nr_delays == delays->total_entries) {
		unsigned long new_size;

		delays->total_entries <<= 1;
		new_size = entries_to_size(delays->total_entries);
		delays = realloc(delays, new_size);
	}

	delays->delays[delays->nr_delays++] = delay;
}

/*
 * Reads a timestamp (which is ignored, it's just a wakeup call), and replies
 * with the timestamp of when we saw it
 */
static void run_child(int *pipe, struct mutex *mutex)
{
	struct timespec ts;

	mutex_up(mutex);

	do {
		int ret;

		ret = read(pipe[0], &ts, sizeof(ts));
		if (ret <= 0)
			break;

		clock_gettime(CLOCKSOURCE, &ts);

		ret = write(pipe[1], &ts, sizeof(ts));
		if (ret <= 0)
			break;
	} while (1);
}

/*
 * Do a random sleep between min and max delay
 */
static void do_rand_sleep(void)
{
	unsigned int msecs;

	msecs = min_delay + ((float) max_delay * (rand() / (RAND_MAX + 1.0)));
	usleep(msecs * 1000);
}

static void kill_connection(void)
{
	int i;

	for (i = 0; i < clients; i++) {
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

static int __write_ts(int fd, struct timespec *ts)
{
	clock_gettime(CLOCKSOURCE, ts);

	return write(fd, ts, sizeof(*ts)) != sizeof(*ts);
}

static int write_ts(struct pollfd *pfd, unsigned int nr, struct timespec *ts)
{
	unsigned int i;

	for (i = 0; i < clients; i++) {
		if (pfd[i].revents & (POLLERR | POLLHUP | POLLNVAL))
			return 1;
		if (pfd[i].revents & POLLOUT) {
			pfd[i].events = 0;
			if (__write_ts(pfd[i].fd, &ts[i]))
				return 1;
			nr--;
		}
		if (!nr)
			break;
	}

	return 0;
}

static long __read_ts(int fd, struct timespec *ts)
{
	struct timespec t;

	if (read(fd, &t, sizeof(t)) != sizeof(t))
		return -1;

	return usec_since(ts, &t);
}

static long read_ts(struct pollfd *pfd, unsigned int nr, struct timespec *ts)
{
	long delay, max_delay = 0;
	unsigned int i;

	for (i = 0; i < clients; i++) {
		if (pfd[i].revents & (POLLERR | POLLHUP | POLLNVAL))
			return -1L;
		if (pfd[i].revents & POLLIN) {
			pfd[i].events = 0;
			delay = __read_ts(pfd[i].fd, &ts[i]);
			if (delay < 0)
				return -1L;
			else if (delay > max_delay)
				max_delay = delay;
			nr--;
		}
		if (!nr)
			break;
	}

	return max_delay;
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
static void run_parent(void)
{
	struct pollfd *ipfd, *opfd;
	int do_exit = 0, i;
	struct timespec *t1;

	t1 = malloc(sizeof(struct timespec) * clients);
	opfd = malloc(sizeof(struct pollfd) * clients);
	ipfd = malloc(sizeof(struct pollfd) * clients);

	srand(1234);

	do {
		unsigned long max_delay = 0;
		unsigned pending_events;

		do_rand_sleep();

		for (i = 0; i < clients; i++) {
			ipfd[i].fd = pipes[i][0];
			ipfd[i].events = POLLIN;
			opfd[i].fd = pipes[i][1];
			opfd[i].events = POLLOUT;
		}

		/*
		 * Write wakeup calls
		 */
		pending_events = clients;
		while (pending_events) {
			int evts = poll(opfd, clients, 0);

			if (app_has_exited()) {
				do_exit = 1;
				break;
			}

			if (evts < 0) {
				do_exit = 1;
				break;
			} else if (!evts)
				continue;

			if (write_ts(opfd, evts, t1)) {
				do_exit = 1;
				break;
			}

			pending_events -= evts;
		}

		if (do_exit)
			break;

		/*
		 * Poll and read replies
		 */
		pending_events = clients;
		while (pending_events) {
			int evts = poll(ipfd, clients, 0);

			if (app_has_exited()) {
				do_exit = 1;
				break;
			}

			if (evts < 0) {
				do_exit = 1;
				break;
			} else if (!evts)
				continue;

			max_delay = read_ts(ipfd, evts, t1);
			if (max_delay < 0) {
				do_exit = 1;
				break;
			}

			pending_events -= evts;
		}
		log_delay(max_delay);
	} while (!do_exit);

	free(t1);
	free(ipfd);
	free(opfd);
	kill_connection();
}

static void run_test(void)
{
	struct mutex *mutex;
	pid_t *cpids;
	int i, status;

	mutex = mmap(NULL, sizeof(*mutex), PROT_READ|PROT_WRITE,
			MAP_SHARED | MAP_ANONYMOUS, 0, 0);
	if (mutex == MAP_FAILED) {
		perror("mmap");
		return;
	}

	init_mutex(mutex);

	for (i = 0; i < clients; i++) {
		if (pipe(pipes[i])) {
			perror("pipe");
			return;
		}
	}

	cpids = malloc(sizeof(pid_t) * clients);

	for (i = 0; i < clients; i++) {
		cpids[i] = fork();
		if (cpids[i]) {
			mutex_down(mutex);
			continue;
		}

		run_child(pipes[i], mutex);
		exit(0);
	}

	run_parent();

	for (i = 0; i < clients; i++)
		kill(cpids[i], SIGQUIT);
	for (i = 0; i < clients; i++)
		waitpid(cpids[i], &status, 0);

	free(cpids);
	munmap(mutex, sizeof(*mutex));
}

static void setup_log(void)
{
	delays = malloc(entries_to_size(DEF_ENTRIES));
	delays->nr_delays = 0;
	delays->total_entries = DEF_ENTRIES;
}

/*
 * Calculate average and stddev for the entries in the log. Drop the
 * first and last entry.
 */
static int calc_latencies(void)
{
	unsigned long long sum = 0;
	int i;

	if (delays->nr_delays <= 2)
		return 1;

	for (i = 1; i < delays->nr_delays - 1; i++) {
		unsigned long delay = delays->delays[i];

		if (delay > delays->max_delay)
			delays->max_delay = delay;

		sum += delay;
	}

	avg = sum / (delays->nr_delays - 2);

	if (delays->nr_delays <= 3)
		return 0;

	sum = 0;
	for (i = 1; i < delays->nr_delays - 1; i++) {
		long diff;

		diff = delays->delays[i] - avg;
		sum += (diff * diff);
	}

	stddev = sqrt(sum / (delays->nr_delays - 3));
	return 0;
}

static void handle_sigint(int sig)
{
	kill(app_pid, SIGINT);
}

int main(int argc, char *argv[])
{
	int app_offset, off;
	char app[256];

	setup_log();

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

	if (calc_latencies()) {
		printf("Runtime too short to render result\n");
		return 1;
	}

	printf("Entries: %lu (clients=%d)\n", delays->nr_delays, clients);
	printf("\nAverages:\n");
	printf("------------------------------\n");
	printf("\tMax\t %8lu usec\n", delays->max_delay);
	printf("\tAvg\t %8lu usec\n", avg);
	printf("\tStdev\t %8.0f usec\n", stddev);

	free(delays);
	return 0;
}

--+jhVVhN62yS6hEJ8--
