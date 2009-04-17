Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbZDQFps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbZDQFps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbZDQFpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:45:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63676 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbZDQFpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:45:10 -0400
Message-ID: <49E8167D.8000005@cn.fujitsu.com>
Date: Fri, 17 Apr 2009 13:41:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] sched: fix the nice-unfairness on SMP when offline a
 CPU
Content-Type: multipart/mixed;
 boundary="------------060006040005080500060709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060006040005080500060709
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I tested the fairness of scheduler on my multi-core box(2 CPUs * 2 Cores), and
found the nice-fairness was broken when I offlined a CPU. The CPU time gotten
by half of tasks was half as much as the others.

A test program which reproduces the problem on current kernel is attached.
This program forks a lot of child tasks, then the parent task gets the loop
count of every task and figures out the average and standard deviation every
5 seconds. (All of the child tasks do the same work - repeat doing sqrt)

Steps to reproduce:
 # echo 0 > /sys/devices/system/cpu/cpu3/online
 # ./sched-fair -p 8 -i 5 -v

By debuging, we found it is caused by the __cpu_power of the sched group. If
I offlined a CPU, the partition of sched groups in the CPU-level sched domain
is:
	+-----------+----------+
	| CPU0 CPU1 |   CPU2   |
	+-----------+----------+
and the __cpu_power of each sched group was 1024. It is strange that the first
sched group had two logic CPUs, the __cpu_power should be double times of the
second sched group. If both of the sched groups' __cpu_power was 1024, the load
balance program would balance the load fifty-fifty between these two sched
group, so half of the test tasks was moved to logic CPU2, and they got less CPU
time.

The code that caused this problem is following:
static void init_sched_groups_power(int cpu, struct sched_domain *sd)
{
	[snip]
	/*
	 * For perf policy, if the groups in child domain share resources
	 * (for example cores sharing some portions of the cache hierarchy
	 * or SMT), then set this domain groups cpu_power such that each group
	 * can handle only one task, when there are other idle groups in the
	 * same sched domain.
	 */
	if (!child || (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
		       (child->flags &
			(SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
		return;
	}
	[snip]
}
According to the above comment, this design was in view of performance. But I
found there was no regression after applying this patch.

Test result on multi-core x86_64 box:
Before applying this patch:
AVERAGE		STD-DEV
1297.500	432.518

After applying this patch:
AVERAGE		STD-DEV
1297.250	118.857

Test result on hyper-threading x86_64 box:
Before applying this patch:
AVERAGE		STD-DEV
536.750		176.265

After applying this patch:
AVERAGE		STD-DEV
535.625		53.979

Maybe we need more test for it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 kernel/sched.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5724508..07b08b2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7956,16 +7956,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	sd->groups->__cpu_power = 0;
 
-	/*
-	 * For perf policy, if the groups in child domain share resources
-	 * (for example cores sharing some portions of the cache hierarchy
-	 * or SMT), then set this domain groups cpu_power such that each group
-	 * can handle only one task, when there are other idle groups in the
-	 * same sched domain.
-	 */
-	if (!child || (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
-		       (child->flags &
-			(SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
+	if (!child) {
 		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
 		return;
 	}
-- 
1.6.0.3


--------------060006040005080500060709
Content-Type: text/x-csrc;
 name="sched-fair.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched-fair.c"

/* gcc sched-fair.c -o sched-fair -lm -lrt -Wall -g -Wextra */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <signal.h>
#include <time.h>
#include <sched.h>
#include <ctype.h>
#include <pwd.h>
#include <math.h>
#include <err.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/wait.h>

#define UNUSED __attribute__ ((unused))
#define DECIMAL		10

#define OPT_MISSING(prog, opt) do {				\
	fprintf(stderr, "%s: option -%c ", prog, opt);		\
	fprintf(stderr, "requires an argument\n");		\
	usage(prog, 1);						\
} while (0)

#define OPT_COLLIDING(prog, opt1, opt2) do {			\
	fprintf(stderr,						\
		"%s: option -%c collides with option -%c\n",	\
		prog, opt1, opt2);				\
	usage(prog, 1);						\
} while (0)

#define ARG_WRONG(prog, opt, arg) do {				\
	fprintf(stderr, "%s: Wrong argument -%c %s\n",		\
		prog, opt, arg);				\
	usage(prog, 1);						\
} while (0)

#define DEFAULT_INTERVAL		5
#define DEFAULT_RUNTIME			300
#define DEFAULT_NPROCS			10
#define MAX_NPROCS			1024
#define USAGE  ("Usage : %s [-p nprocs] [-i secs] [-t secs] [-v] [-h]\n"      \
		"\t-p nprocs\n"						      \
		"\t       The num of the procs. [Default = %d]\n"	      \
		"\t-i secs\n"						      \
		"\t       The interval time to get the loops executed by "    \
		"per-task.\n"						      \
		"\t       [Unit:sec, Default: %d seconds]\n"		      \
		"\t-t secs\n"						      \
		"\t       The running time of the test program.\n"	      \
		"\t       [Unit:sec, Default: %d seconds]\n"		      \
		"\t-v     Verbose\n"					      \
		"\t-h     Help.\n")

unsigned long loops_per_ms;
/*  the interval time to get the loops executed by per-task.
 *	Unit:second
 *	Default: 5 seconds
 */
int interval = DEFAULT_INTERVAL;
int runsecs = DEFAULT_RUNTIME;
int nprocs = DEFAULT_NPROCS;

time_t *start;

const char *shmname = "/sched_fair_shmem";
void *shmem;
int fd;
int shm_size;

unsigned long *loops_count;
int *procs_count;

pid_t *pids;

int verbose;

void burn_loops(unsigned long loops)
{
	unsigned long i;
	double f = 213199432.217897127;

	for (i = 0 ; i < loops ; i++)
		f = sqrt(f * f);
}

void initialize(void)
{
	sigset_t sigset;

	if (sigemptyset(&sigset) < 0)
		err(errno, "sigemptyset()");
	if (sigaddset(&sigset, SIGUSR1) < 0)
		err(errno, "sigaddset()");
        if (sigprocmask(SIG_BLOCK, &sigset, NULL) < 0)
		err(errno, "sigprocmask()");

	pids = malloc(nprocs * sizeof(pid_t));
	if (pids == NULL)
		err(errno, "malloc()");

	/* setup shared memory */
	shm_size = sizeof(time_t) + nprocs
			* sizeof(unsigned long)	+ sizeof(int);

	fd = shm_open(shmname, O_CREAT | O_RDWR, 0644);
	if (fd < 0)
		err(errno, "shm_open()");

	if (shm_unlink(shmname) < 0)
		err(errno, "shm_unlink()");

	if (ftruncate(fd, shm_size) < 0)
		err(errno, "ftruncate()");

	shmem = mmap(NULL, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED,
		     fd, 0);
	if (shmem == (void *)-1)
		err(errno, "mmap()");

	memset(shmem, 0, shm_size);
	start = (time_t *)shmem;
	loops_count = (unsigned long *)(shmem + sizeof(time_t));
	procs_count = (int *)(shmem + sizeof(time_t) + nprocs
			* sizeof(unsigned long));

}

void cleanup_resources(void)
{
	free(pids);
	munmap(shmem, shm_size);
	close(fd);
}

void usage(char *prog_name, int status)
{
	FILE *output = NULL;

	if (prog_name == NULL)
		prog_name = "sched-fair";

	if (status)
		output = stderr;
	else
		output = stdout;

	fprintf(output, USAGE, prog_name, DEFAULT_NPROCS, DEFAULT_INTERVAL,
		DEFAULT_RUNTIME);
	exit(status);
}

void sighandler(UNUSED int signo)
{
}

void child_job(int index)
{
	time_t current;
	sigset_t sigset;
	struct sigaction sa;
	int return_code = 0;

	sa.sa_handler = sighandler;
	if (sigemptyset(&sa.sa_mask) < 0) {
		fprintf(stderr, "Task %d: sigemptyset() failed.\n", index);
		return_code = errno;
		goto err_return;
	}
	sa.sa_flags = 0;
	if (sigaction(SIGUSR1, &sa, NULL) < 0) {
		fprintf(stderr, "Task %d: sigaction() failed.\n", index);
		return_code = errno;
		goto err_return;
	}
	if (sigemptyset(&sigset) < 0) {
		fprintf(stderr, "Task %d: sigfillset() failed.\n", index);
		return_code = errno;
		goto err_return;
	}
	sigsuspend(&sigset);
	if (errno != EINTR) {
		fprintf(stderr, "Task %d: sigsuspend() failed.\n", index);
		return_code = errno;
		goto err_return;
	}
	/* main loop */
	do {
		burn_loops(100000);
		loops_count[index]++;
		if (time(&current) == -1) {
			fprintf(stderr, "Task %d: time() failed.\n", index);
			return_code = errno;
			goto err_return;
		}
	} while (difftime(current, *start) < runsecs);
err_return:
	(*procs_count)++;
	exit(return_code);
}

/*
 * compute the average and standard deviation of the unsigned long integer
 * array.
 *
 * @data:pointer to unsigned long integer array.
 * @size:the size of the array.
 * @std_dv:pointer to double variable saved the standard deviation 
 *
 * this function returns the average of the array.
 */
double compute_lu_avg_stddv(unsigned long *data, int size, double *std_dv)
{
	int i;
	double average = 0, tmp = 0;

	if (std_dv == NULL) {
		fprintf(stderr, "The address of std_dv is NULL.\n");
		return 0;
	}

	if (data == NULL) {
		fprintf(stderr, "The address of data is NULL.\n");
		*std_dv = 0;
		return 0;
	}

	if (size <= 0) {
		fprintf(stdout, "The size of array is wrong.(size = %d)\n",
			size);
		*std_dv = 0;
		return 0;
	}

	*std_dv = 0;

	for (i = 0; i < size; i++)
		average += (double)data[i];
	average /= (double) size;

	for (i = 0; i < size; i++) {
			tmp = (double)data[i] - average;
			tmp = tmp * tmp;
			*std_dv += tmp;
	}
	*std_dv /= (double) size;
	*std_dv = sqrt(*std_dv);
	return average;
}

int report(void)
{
	int count = 0;
	time_t current;
	double average = 0, std_dv = 0;
	int  i = 0;

	do {
		sleep(interval);

		count++;
		fprintf(stdout, "===%dth report:===\n", count);
		fprintf(stdout, "AVERAGE\t\tSTD-DEV\n");
		average = compute_lu_avg_stddv(loops_count, nprocs, &std_dv);
		fprintf(stdout, "%.3lf\t\t%.3lf\n", average, std_dv);

		if (verbose)
			fprintf(stdout, "\nDetails:\n");

		for (i = 0; i < nprocs; i++) {
			if (verbose) {
				fprintf(stdout, "%lu\t",
					loops_count[i]);
					if (i % 10 == 9)
						fprintf(stdout, "\n  ");
			}
			loops_count[i] = 0;
		}
		if (verbose)
			fprintf(stdout, "\n");
		fprintf(stdout, "========================================"
			"\n\n\n");
		if (time(&current) == -1) {
			fprintf(stderr, "Parent Process: time() failed.\n");
			perror("time()");
			return -1;
		}
	} while (difftime(current, *start) < runsecs
		 || *procs_count < nprocs);

	return 0;
}

void checkopt(int argc, char **argv)
{
	char c = '\0';
	char *endptr = NULL;
	long opt_value = 0;

	if (getuid() != 0) {
		fprintf(stderr, "ERROR: ONLY root user can run this program."
			"\n");
		exit(1);
	}

	while ((c = getopt(argc, argv, "p:i:t:vh")) != -1) {
		switch (c) {
		case 'i':   /* the interval time. */
			if (optarg[0] == '-' && !isdigit(optarg[1]))
				OPT_MISSING(argv[0], c);
			else {
				opt_value = strtol(optarg, &endptr, DECIMAL);
				if (errno || (endptr != NULL && *endptr != '\0')
				    || opt_value <= 0)
					ARG_WRONG(argv[0], c, optarg);
				interval = atoi(optarg);
			}
			break;
		case 'h':   /* usage message */
			usage(argv[0], 0);
			break;
		case 't':   /* the running time */
			if (optarg[0] == '-' && !isdigit(optarg[1]))
				OPT_MISSING(argv[0], c);
			else {
				opt_value = strtol(optarg, &endptr, DECIMAL);
				if (errno
				    || (endptr != NULL && *endptr != '\0'))
					ARG_WRONG(argv[0], c, optarg);
				runsecs = atoi(optarg);
				if (runsecs <= 0)
					ARG_WRONG(argv[0], c, optarg);
			}
			break;
		case 'p':   /* the number of processes */
			if (optarg[0] == '-' && !isdigit(optarg[1]))
				OPT_MISSING(argv[0], c);
			else {
				opt_value = strtol(optarg, &endptr, DECIMAL);
				if (errno
				    || (endptr != NULL && *endptr != '\0'))
					ARG_WRONG(argv[0], c, optarg);
				nprocs = atoi(optarg);
				if (nprocs <= 0
				    || nprocs
				       > MAX_NPROCS)
					ARG_WRONG(argv[0], c, optarg);
			}
			break;
		case 'v':   /* Verbose mode*/
			verbose = 1;
			break;
		default:
			usage(argv[0], 1);
			break;
		}
	}

	if (interval*5 >= runsecs) {
		fprintf(stderr, "WARNING:The interval time is too long or the "
			"running time is too short.Using default.\n");
		interval = DEFAULT_INTERVAL;
		runsecs = DEFAULT_RUNTIME;
	}
}

int main(int argc, char **argv)
{
	int i, j;
	int return_code = 0;
	sigset_t sigset;
	struct sched_param param = { .sched_priority = 1 };
	int status;
	char tempbuffer[50];

	checkopt(argc, argv);

	initialize();
	for (i = 0; i < nprocs; i++) {
		pids[i] = fork();
		if (pids[i] == -1) {
			warn("fork() failed\n");
			return_code = 1;
			goto err_proc;
		}
		if (pids[i] == 0)
			child_job(i);
	}

	if (sigemptyset(&sigset) < 0) {
		warn("sigemptyset()");
		goto err_proc;
	}
	if (sigprocmask(SIG_UNBLOCK, &sigset, NULL) < 0) {
		warn("sigprocmask()");
		goto err_proc;
	}

	param.sched_priority = sched_get_priority_max(SCHED_FIFO);
	sched_setscheduler(0, SCHED_FIFO, &param);

	gethostname(tempbuffer, 40);

	fprintf(stdout,
		"Host name:\t\t%s\n"
		"User name:\t\t%s\n"
		"Interval(sec):\t\t%d\n"
		"Run time(sec):\t\t%d\n"
		"Total procs:\t\t%d\n\n",
		tempbuffer,
		getpwuid(geteuid())->pw_name,
		interval,
		runsecs,
		nprocs);

	fprintf(stdout, "\nSched Fair Test Start\n");
	if (time(start) < 0) {
		warn("time()");
		goto err_proc;
	}
	if ((kill(0, SIGUSR1)) == -1) {
		warn("kill()");
		goto err_proc;
	}

	return_code = report();
	if (return_code == -1)
		goto err_proc;

	fprintf(stdout, "\nSched Fair Test End\n");
	for (j = 0; j < nprocs; j++) {
		if (wait(&status) < 0) {
			warn("wait() failed");
			goto err_proc;
		}
	}
	cleanup_resources();
	return 0;
err_proc:
	for (; i >= 0; --i)
		if (kill(pids[i], SIGKILL) < 0)
			if (errno != ESRCH)
				warn("kill() failed");
	cleanup_resources();
	exit(return_code);
	return 0;
}

--------------060006040005080500060709--

