Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZIGUo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZIGUo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 16:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZIGUo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 16:44:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39214 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZIGUo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 16:44:56 -0400
Date: Mon, 7 Sep 2009 22:44:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907204458.GJ18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk> <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7LkOrbQMr4cezO2T"
Content-Disposition: inline
In-Reply-To: <20090907173846.GB18599@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 07 2009, Jens Axboe wrote:
> > And yes, it would be wonderful to get a test-app from you that would 
> > express the kind of pain you are seeing during compile jobs.
> 
> I was hoping this one would, but it's not showing anything. I even added
> support for doing the ping and wakeup over a socket, to see if the pipe
> test was doing well because of the sync wakeup we do there. The net
> latency is a little worse, but still good. So no luck in making that app
> so far.

Here's a version that bounces timestamps between a producer and a number
of consumers (clients). Not really tested much, but perhaps someone can
compare this on a box that boots BFS and see what happens.

To run it, use -cX where X is the number of children that you wait for a
response from. The max delay between this children is logged for each
wakeup. You can invoke it ala:

$ ./latt -c4 'make -j4'

and it'll dump the max/avg/stddev bounce time after make has completed,
or if you just want to play around, start the compile in one xterm and
do:

$ ./latt -c4 'sleep 5'

to just log for a small period of time. Vary the number of clients to
see how that changes the aggregated latency. 1 should be fast, adding
more clients quickly adds up.

Additionally, it has a -f and -t option that controls the window of
sleep time for the parent between each message. The numbers are in
msecs, and it defaults to a minimum of 100msecs and up to 500msecs.

-- 
Jens Axboe


--7LkOrbQMr4cezO2T
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="latt.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <getopt.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <time.h>
#include <math.h>


/*
 * In msecs
 */
static unsigned int min_delay = 100;
static unsigned int max_delay = 500;
static unsigned int clients = 1;

#define MAX_CLIENTS		512

struct delays {
	unsigned long nr_delays;
	unsigned long mmap_entries;
	unsigned long max_delay;
	unsigned long delays[0];
};

static struct delays *delays;
static int pipes[MAX_CLIENTS][2];

static unsigned long avg;
static double stddev;

static pid_t app_pid;

#define CLOCKSOURCE		CLOCK_MONOTONIC

#define DEF_ENTRIES		1024

static int parse_options(int argc, char *argv[])
{
	struct option l_opts[] = {
		{ "min-delay", 	1, 	NULL,	'f' },
		{ "max-delay",	1,	NULL,	't' },
		{ "clients",	1,	NULL,	'c' }
	};
	int c, res, index = 0;

	while ((c = getopt_long(argc, argv, "f:t:c:", l_opts, &res)) != -1) {
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

#define entries_to_size(n)	((n) * sizeof(unsigned long) + sizeof(struct delays))

static unsigned long usec_since(struct timespec *start, struct timespec *end)
{
	long secs, nsecs, delay;

	secs = end->tv_sec - start->tv_sec;
	nsecs = end->tv_nsec - start->tv_nsec;

	delay = secs * 1000000L;
	delay += (nsecs / 1000L);

	return delay;
}

static unsigned long usec_since_now(struct timespec *start)
{
	struct timespec e;

	clock_gettime(CLOCKSOURCE, &e);
	return usec_since(start, &e);
}

static void log_delay(unsigned long delay)
{
	if (delays->nr_delays == delays->mmap_entries) {
		unsigned long new_size;

		delays->mmap_entries <<= 1;
		new_size = entries_to_size(delays->mmap_entries);
		delays = realloc(delays, new_size);
	}

	delays->delays[delays->nr_delays++] = delay;

	if (delay > delays->max_delay)
		delays->max_delay = delay;
}

static void run_child(int *pipe)
{
	struct timespec ts;

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

static void run_parent(void)
{
	struct timespec *t1, t2;
	int status, ret, do_exit = 0, i;

	t1 = malloc(sizeof(struct timespec) * clients);

	srand(1234);

	do {
		unsigned long delay, max_delay = 0;

		do_rand_sleep();

		ret = waitpid(app_pid, &status, WNOHANG);
		if (ret < 0) {
			perror("waitpid");
			break;
		} else if (ret == app_pid &&
			   (WIFSIGNALED(status) || WIFEXITED(status))) {
			do_exit = 1;
			kill_connection();
		}
			
		for (i = 0; i < clients; i++) {
			clock_gettime(CLOCKSOURCE, &t1[i]);
			if (write(pipes[i][1], &t1[i], sizeof(t2)) != sizeof(t2)) {
				do_exit = 1;
				break;
			}
		}

		for (i = 0; i < clients; i++) {
			if (read(pipes[i][0], &t2, sizeof(t2)) != sizeof(t2)) {
				do_exit = 1;
				break;
			}
			delay = usec_since(&t1[i], &t2);
			if (delay > max_delay)
				max_delay = delay;
		}

		log_delay(max_delay);
	} while (!do_exit);

	kill_connection();
}

static void parent_setup_connection(void)
{
	int i;

	for (i = 0; i < clients; i++) {
		if (pipe(pipes[i])) {
			perror("pipe");
			return;
		}
	}
}

static void run_test(void)
{
	pid_t cpids[MAX_CLIENTS];
	int i, status;

	parent_setup_connection();

	for (i = 0; i < clients; i++) {
		cpids[i] = fork();
		if (cpids[i])
			continue;

		run_child(pipes[i]);
		exit(0);
	}

	run_parent();

	for (i = 0; i < clients; i++)
		kill(cpids[i], SIGQUIT);
	for (i = 0; i < clients; i++)
		waitpid(cpids[i], &status, 0);
}

static void setup_shared_area(void)
{
	delays = malloc(entries_to_size(DEF_ENTRIES));
	delays->nr_delays = 0;
	delays->mmap_entries = DEF_ENTRIES;
}

static void calc_latencies(void)
{
	unsigned long long sum = 0;
	int i;

	if (!delays->nr_delays)
		return;

	for (i = 0; i < delays->nr_delays; i++)
		sum += delays->delays[i];

	avg = sum / delays->nr_delays;

	if (delays->nr_delays < 2)
		return;

	sum = 0;
	for (i = 0; i < delays->nr_delays; i++) {
		long diff;

		diff = delays->delays[i] - avg;
		sum += (diff * diff);
	}

	stddev = sqrt(sum / (delays->nr_delays - 1));
}

static void handle_sigint(int sig)
{
	kill(app_pid, SIGINT);
}

int main(int argc, char *argv[])
{
	int app_offset, off;
	char app[256];

	setup_shared_area();

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
	app_pid = fork_off(app);
	run_test();

	calc_latencies();

	printf("Entries: %lu (clients=%d)\n", delays->nr_delays, clients);
	printf("\nAverages (in usecs)\n");
	printf("-------------------\n");
	printf("\tMax\t %lu\n", delays->max_delay);
	printf("\tAvg\t %lu\n", avg);
	printf("\tStdev\t %.0f\n", stddev);

	free(delays);
	return 0;
}

--7LkOrbQMr4cezO2T--
