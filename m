Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbZAHBco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbZAHBco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 20:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbZAHBcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 20:32:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62285 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbZAHBce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 20:32:34 -0500
Message-ID: <4965573B.60801@cn.fujitsu.com>
Date: Thu, 08 Jan 2009 09:30:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [BUG] sched: fair group's bug
Content-Type: multipart/mixed;
 boundary="------------020709090602050502000909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020709090602050502000909
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I tested fair group scheduler on my hyper-threading x86_64 box(2 CPU * 2 HT)
and found the deviation of the groups' CPU usage was larger than 2.6.26
when *offline* a CPU or do hotplug frequently. It is less than 1% On 2.6.26，but
On current kernel, it is often greater than 4%, even than 10% by accident.

A test program which reproduces the problem on current kernel is attached.
This program forks a lot of child tasks and attachs these child tasks into each
CPU controller group, then the parent task gets and checks the CPU usage of
every group every 5 seconds.(All of the child tasks do the same work - repeat
doing sqrt)
						Child Task 1
						  while(!end)
						      sqrt(f);
				Group 1		......
						Child Task m
						  while(!end)
						      sqrt(f);
				-----------------------------
Parent Task             	Group 2		......
  get and check the CPU		......		......
  usage of every group		-----------------------------
						Child Task m*n-m+1
						  while(!end)
						      sqrt(f);
				Group n		......
						Child Task m*n
						  while(!end)
						      sqrt(f);

Steps to reproduce:
# mkdir /dev/cpuctl
# mount -t cgroup -o cpu,noprefix xxx /dev/cpuctl
# ./cpuctl

output on current kernel:
-------------------------
Group   Shares  Actual(%)       Expect(%)
0       1024    41.68           50.00
1       1024    58.32           50.00
0th group's usage is out of range(deviation = 8.32)
1th group's usage is out of range(deviation = 8.32)
--------------------------

output on 2.6.26
-------------------------
Group   Shares  Actual(%)       Expect(%)
0       1024    50.03           50.00
1       1024    49.97           50.00
--------------------------

On 2.6.26, the deviation may be greater than 4% at the beginning, but the scheduler
adjusts soon, and don't occur the large deviation for ever.

Bisect located below patch:
commit c09595f63bb1909c5dc4dca288f4fe818561b5f3
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jun 27 13:41:14 2008 +0200

    sched: revert revert of: fair-group: SMP-nice for group scheduling

    Try again..

    Initial commit: 18d95a2832c1392a2d63227a7a6d433cb9f2037e
    Revert: 6363ca57c76b7b83639ca8c83fc285fa26a7880e

    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


Besides that, We found other problems by the attached program.
1. some tasks are hungry in the fair group.
	Steps to reproduce:
	# mkdir /dev/cpuctl
	# mount -t cgroup -o cpu,noprefix xxx /dev/cpuctl
	# ./cpuctl -g 1 -v
	--------------------
	1th Check Result:
	Group	Shares	Actual(%)	Expect(%)
	0	1024	100.00		100.00
	Each task's usage:
		Task in Group 0:
			Task	Usage(%)
			5395	0.000000
			5396	0.000000
		 	5397	0.000000
			5398	16.677785
			5399	16.677785
			5400	16.744496
			5401	16.611074
			5402	33.288859

2. some groups broke the limit of the fair group and get more CPU time When
   the groups is hiberarchy. Such as:
		top group
		    |
		 group 1
		/	\
	      task1	group 2
			   |
			task 2
	Steps to reproduce:
	# mkdir /dev/cpuctl
	# mount -t cgroup -o cpu,noprefix xxx /dev/cpuctl
	# ./cpuctl -H
	-------------------------
	Group	Shares	Actual(%)	Expect(%)
	0	1024	60.17		88.89
	1	1024    39.83		11.11

--------------020709090602050502000909
Content-Type: text/x-csrc;
 name="cpuctl.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cpuctl.c"

/* compile with 'gcc cpuctl.c -o cpuctl -Wall -g -Wextra -lm -lrt' */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
#include <ctype.h>
#include <signal.h>
#include <sched.h>
#include <fcntl.h>
#include <time.h>
#include <dirent.h>
#include <limits.h>
#include <errno.h>
#include <err.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/wait.h>

#define UNUSED __attribute__ ((unused))

#define PROGNAME			"cpuctl"

#define SYS_CPU_DIR			"/sys/devices/system/cpu"
#define CPUCTL				"/dev/cpuctl"

#ifndef PATH_MAX
# define PATH_MAX			1024
#endif

#define NICE_0_WEIGHT			1024
#define DECIMAL				10

#define LIMIT				3.0F
#define TIME_INTERVAL			5	/* Time interval in seconds */
#define MAX_NPROCS			1024
#define MAX_NGROUPS			128
#define	DEF_NGROUPS			2
#define DEF_NTASKS_PER_GROUP_CPU	2
#define BUFFSIZE			512


/* New groups' relation */
#define GROUP_SIBLING			0
#define GROUP_HIERARCHY			1

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

#define while_each_childdir(basepath, p_relpath, c_relpath, c_pathlen)	\
{									\
	struct dirent *direntp;						\
	DIR *dp;							\
	struct stat st;							\
	char fullpath[PATH_MAX];					\
	int pathlen;							\
	int start = 0;							\
									\
	if (basepath[strlen(basepath) - 1] == '/'			\
		&& p_relpath[0] == '/')					\
		start = 1;						\
									\
	snprintf(fullpath, sizeof(fullpath), "%s%s", basepath,		\
		p_relpath + start);					\
	pathlen = strlen(fullpath);					\
									\
	if ((dp = opendir(fullpath)) == NULL)				\
		return -1;						\
									\
	while ((direntp = readdir(dp)) != NULL) {			\
		if (!strcmp(direntp->d_name, ".")			\
			|| !strcmp(direntp->d_name, ".."))		\
			continue;					\
		if (fullpath[pathlen - 1] == '/') {			\
			fullpath[pathlen - 1] = '\0';			\
			pathlen--;					\
		}							\
		sprintf(fullpath + pathlen, "/%s", direntp->d_name);	\
		stat(fullpath, &st);					\
		if (S_ISDIR(st.st_mode)) {				\
			start = strlen(basepath);			\
			if (basepath[start - 1] == '/')			\
				start--;				\
			snprintf(c_relpath, c_pathlen, "%s",		\
					fullpath + start);

#define	end_while_each_childdir						\
		}							\
	}								\
									\
	closedir(dp);							\
}

#define USAGE	("Usage: %s [-p nprocs] [-g ngroups] [-s|H] [-v] [-h]\n"\
		 "\t-p nprocs\n"					\
		 "\t\tThe num of the procs per group * cpu. [Def: 2]\n"	\
		 "\t-g ngroups\n"					\
		 "\t\tThe num of the groups.[Def: 2, Max: 128]\n"	\
		 "\t-s|h\n"						\
		 "\t\tAll new groups is sibling(s) or hierarchy(H)\n"	\
		 "\t\t[Def: s]\n"					\
		 "\t-v\tVerbose mode. output every task's usage\n"	\
		 "\t-h\tHelp\n")

int nprocs;
volatile int end;
int ngroups = DEF_NGROUPS;
int nprocs_per_group_cpu = DEF_NTASKS_PER_GROUP_CPU;
int nprocs_per_group;
/* New groups' relation: 0 - sibling, 1 - hierarchy */
int group_relation = GROUP_SIBLING;
int ncpus;

int verbose;

const char *shmname = "/cpuctl_shmem";
int *shmem;
int fd;
int shm_size;

int *child_end;

int get_ncpus(void)
{
	int cpu;
	char c_relpath[PATH_MAX];
	int ncpus = 0;

	while_each_childdir(SYS_CPU_DIR, "/", c_relpath,
				sizeof(c_relpath)) {
		if (!strncmp(c_relpath + 1, "cpu", 3)
		    && sscanf(c_relpath + 4, "%d", &cpu) > 0) {
			if (cpu >= 0)
				ncpus++;
		}
	} end_while_each_childdir
	return ncpus;
}

/**
 * get_task_usage - get the task's cpu usage by reading the /proc/<pid>/stat
 * if pid is zero, the function will get current task's cpu usage.
 *
 * On success, 0 is returned; On error, -1 is returned.
 */
int get_task_usage(pid_t pid, unsigned long *tsk_time)
{
	int fd = -1;
	char path[PATH_MAX];
	char buff[BUFFSIZE];
	unsigned long utime, stime;

	if (tsk_time == NULL) {
		warnx("get_task_usage: task time is NULL.\n");
		return -1;
	}

	if (pid < 0) {
		warnx("get_task_usage: pid(%d) is wrong.\n", pid);
		return -1;
	}

	if (pid == 0)
		snprintf(path, sizeof(path), "/proc/self/stat");
	else
		snprintf(path, sizeof(path), "/proc/%d/stat", pid);

	fd = open(path, O_RDONLY);
	if (fd < 0) {
		warn("open task's stat failed.\n");
		return -1;
	}

	if (read(fd, buff, sizeof(buff)) < 1) {
		warn("read task's stat failed.\n");
		close(fd);
		return -1;
	}

	close(fd);
	sscanf(buff, "%*u %*s %*s %*u %*u"
		     "%*u %*u %*u %*u %*u"
		     "%*u %*u %*u %lu %lu",
		     &utime, &stime);
	*tsk_time = utime + stime;
	return 0;
}

/**
 * get_usages - get the usage of the tasks which is specified by the array pids
 * if is_comp is !0, calculate every task's cpu usage and write it into usage
 *
 * On success, 0 is returned; On error, -1 is returned.
 */
int get_usages(pid_t *pids, unsigned long *tms, double *usages, int nprocs,
		int is_comp)
{
	int i;
	unsigned long tm, delta;
	long clocks_per_second;

	clocks_per_second = sysconf(_SC_CLK_TCK);
	if (clocks_per_second <= 0) {
		warn("sysconf()");
		return -1;
	}

	if (pids == NULL) {
		warnx("pids is NULL.\n");
		return -1;
	}

	if (tms == NULL) {
		warnx("tms is NULL.\n");
		return -1;
	}

	if (is_comp && usages == NULL) {
		warnx("usages is NULL");
		return -1;
	}

	for (i = 0; i < nprocs; i++) {
		if (get_task_usage(pids[i], &tm) != 0)
			return -1;
		if (is_comp) {
			delta= tm - tms[i];
			usages[i] = (double)delta / (double)clocks_per_second;
		}
		tms[i] = tm;
	}
	return 0;
}

/**
 * print_usage - print every task's cpu usage.
 * if status is 1, print it into stderr.
 * if status is 0, print it into stdout.
 */
void print_usage(pid_t *pids, double *usage, double *sum_usages, double *expect_usages,
		int *shares, int status)
{
	FILE *output = NULL;
	int i, j;
	int index;

	if (usage == NULL || pids == NULL || sum_usages == NULL
			|| expect_usages == NULL || shares == NULL)
		return;

	if (status == 0)
		output = stdout;
	else
		output = stderr;

	fprintf(output, "Group\tShares\tActual(%%)\tExpect(%%)\n");
	for (i = 0; i < ngroups; i++) {
		fprintf(output, "%d\t%d\t%.2lf\t\t%.2lf\n",
			i, shares[i], sum_usages[i], expect_usages[i]);
	}

	if (verbose) {
		fprintf(output, "Each task's usage:\n");
		for (i = 0; i < ngroups; i++) {
			fprintf(output, "\tTask in Group %d:\n", i);
			fprintf(output, "\t\tTask\tUsage(%%)\n");
			for (j = 0; j < nprocs_per_group; j++) {
				index = i * nprocs_per_group + j;
				fprintf(output, "\t\t%d\t%lf\n", pids[index],
					usage[index]);
			}
		}
	}
}

int check_usage(pid_t *pids, double *usages, int *shares)
{
	int i, j;
	int sum_shares = 0;
	double sum_groups = 0;
	double delta;
	double *sum_per_group, *expects;
	double total_usage = 100;
	static int count = 0;
	int ret = 0;

	if (usages == NULL) {
		warnx("usages is NULL.\n");
		return -1;
	}

	if (shares == NULL) {
		warnx("shares is NULL.\n");
		return -1;
	}

	if (pids == NULL) {
		warnx("pids is NULL.\n");
		return -1;
	}

	sum_per_group = (double *)malloc(ngroups * sizeof(double));
	if (sum_per_group == NULL) {
		warn("alloc for sum_per_group failed.\n");
		return -1;
	}
	memset(sum_per_group, 0, ngroups * sizeof(double));

	expects = (double *)malloc(ngroups * sizeof(double));
	if (expects == NULL) {
		warn("alloc for expects failed.\n");
		free(sum_per_group);
		return -1;
	}
	memset(expects, 0, ngroups * sizeof(double));

	for (i = 0; i < ngroups; i++) {
		for (j = 0; j < nprocs_per_group; j++)
			sum_per_group[i] += usages[i * nprocs_per_group + j];

		if (group_relation == GROUP_SIBLING)
			sum_shares += shares[i];
		sum_groups += sum_per_group[i];
	}

	if (group_relation == GROUP_HIERARCHY)
		sum_shares = NICE_0_WEIGHT * nprocs_per_group;

	for (i = 0; i < ngroups; i++) {
		sum_per_group[i] = sum_per_group[i] * 100 / sum_groups;
		for (j = 0; j < nprocs_per_group; j++) {
			usages[i * nprocs_per_group + j] = 100
					* usages[i * nprocs_per_group + j]
					/ sum_groups;
		}

		if (group_relation == GROUP_SIBLING)
			expects[i] = total_usage * shares[i] / sum_shares;
		else {
			if (i == ngroups - 1)
				expects[i] = total_usage;
			else {
				expects[i] = total_usage * sum_shares
						/ (sum_shares + shares[i+1]);
				total_usage = total_usage - expects[i];
			}
		}
	}

	count++;
	printf("\n%dth Check Result:\n", count);
	print_usage(pids, usages, sum_per_group, expects, shares, 0);

	for (i = 0; i < ngroups; i++) {
		delta = expects[i] - sum_per_group[i];
		if (fabs(delta) > LIMIT) {
			printf("%dth group's usage is out of range"
				"(deviation = %.2lf)\n", i, fabs(delta));
			ret = 1;
		}
	}

	fflush(NULL);
	free(sum_per_group);
	free(expects);
	return ret;
}

void sigusr1_handler(UNUSED int signo)
{
}

void sigint_handler(UNUSED int signo)
{
	end = 1;
}

void usage(char *prog_name, int status)
{
	FILE *output = NULL;

	if (prog_name == NULL)
		prog_name = PROGNAME;

	if (status)
		output = stderr;
	else
		output = stdout;

	fprintf(output, USAGE, prog_name);
	exit(status);
}

void checkopt(int argc, char **argv)
{
	char c = '\0';
	char *endptr = NULL;
	long opt_value = 0;
	int opt_colliding = 0;

	while ((c = getopt(argc, argv, "p:g:sHvh")) != -1) {
		switch (c) {
		case 'p':
			if (optarg[0] == '-' && !isdigit(optarg[1]))
				OPT_MISSING(argv[0], c);
			else {
				opt_value = strtol(optarg, &endptr, DECIMAL);
				if (errno || (endptr != NULL && *endptr != '\0')
				    || opt_value <= 0)
					ARG_WRONG(argv[0], c, optarg);
				nprocs_per_group_cpu = atoi(optarg);
			}
			break;
		case 'g':
			if (optarg[0] == '-' && !isdigit(optarg[1]))
				OPT_MISSING(argv[0], c);
			else {
				opt_value = strtol(optarg, &endptr, DECIMAL);
				if (errno 
				    || (endptr != NULL && *endptr != '\0')
				    || opt_value <= 0
				    || opt_value > MAX_NGROUPS)
					ARG_WRONG(argv[0], c, optarg);
				ngroups = atoi(optarg);
			}
			break;
		case 's':
			group_relation = GROUP_SIBLING;
			opt_colliding |= 0x1;
			break;
		case 'H':
			group_relation = GROUP_HIERARCHY;
			opt_colliding |= 0x2;
			break;
		case 'v':
			verbose = 1;
			break;
		case 'h':   /* usage message */
			usage(argv[0], 0);
			break;
		default:
			usage(argv[0], 1);
			break;
		}
	}

	if (opt_colliding == 3)
		OPT_COLLIDING(argv[0], 's', 'h');

	/* get the num of cpus including offline cpu. */
	ncpus = get_ncpus();
	nprocs = nprocs_per_group_cpu * ngroups * ncpus;
	if (nprocs <= 0 || nprocs > MAX_NPROCS)
		errx(EXIT_FAILURE, "Num of procs is wrong(%d).\n", nprocs);

	nprocs_per_group = nprocs_per_group_cpu * ncpus;

	printf("Total Groups: \t\t\t\t%d\n",ngroups);
	printf("Total CPUs(including offline CPUs): \t%d\n", ncpus);
	printf("nTasks per Group * CPU: \t\t%d\n", nprocs_per_group_cpu);
	printf("Total Tasks: \t\t\t\t%d\n", nprocs);
	printf("Group Relation: \t\t\t%s\n",
		group_relation == GROUP_SIBLING ? "SIBLING" : "HIERARCHY");
	printf("Interval for check(Unit: s): \t\t%d\n", TIME_INTERVAL);
	printf("Verbose mode: \t\t\t\t%s\n", verbose ? "ON" : "OFF");
	printf("Acceptable deviation range: \t\t+/-%.2f\n", LIMIT);
	printf("\n");
}

void initialize(void)
{
	struct sigaction sa1, sa2;

	sa1.sa_handler = sigint_handler;
	if (sigemptyset(&sa1.sa_mask) < 0)
		err(EXIT_FAILURE, "sigemptyset()");

	sa1.sa_flags = 0;
	if (sigaction(SIGINT, &sa1, NULL) < 0)
		err(EXIT_FAILURE, "sigaction()");

	sa2.sa_handler = sigusr1_handler;
	if (sigemptyset(&sa2.sa_mask) < 0)
		err(EXIT_FAILURE, "sigemptyset()");

	sa2.sa_flags = 0;
	if (sigaction(SIGUSR1, &sa2, NULL) < 0)
		err(EXIT_FAILURE, "sigaction()");

	/* setup shared memory */
	shm_size = sizeof(int);

	fd = shm_open(shmname, O_CREAT | O_RDWR, 0644);
	if (fd < 0)
		err(errno, "shm_open()");

	if (shm_unlink(shmname) < 0)
		err(errno, "shm_unlink()");

	if (ftruncate(fd, shm_size) < 0)
		err(errno, "ftruncate()");

	shmem = (int *)mmap(NULL, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED,
		     fd, 0);
	if (shmem == (int *)-1)
		err(errno, "mmap()");

	memset(shmem, 0, shm_size);
	child_end = shmem;
}

void cleanup_resources(void)
{
	munmap(shmem, shm_size);
	close(fd);
}

void cpu_hog(void)
{
	double f = 213199432.217897127;
	sigset_t sigset;

	sigemptyset(&sigset);
	sigsuspend(&sigset);

	while (! *child_end)
		f = sqrt(f * f);

	exit(0);
}

/*
 * do_check - get every task's usage and check it
 *
 * RETURN VALUE:
 * 	0  - success
 * 	1  - wrong cpu usage
 * 	-1 - other error
 */
int do_check(pid_t *pids, int *shares)
{
	unsigned long *tms;
	double *usages;
	struct sched_param param;
	int nfaults = 0;
	int ret = 0;

	/*
	 * set checking process as realtime process, and it can be woken up on
	 * time.
	 */
	param.sched_priority = sched_get_priority_max(SCHED_FIFO);
	sched_setscheduler(0, SCHED_FIFO, &param);

	/* check the parameter */
	if (pids == NULL) {
		warnx("pids is NULL.\n");
		return -1;
	}
	if (shares == NULL) {
		warnx("shares is NULL.\n");
		return -1;
	}

	/* 
	 * alloc memory space for tms and usages. tms keeps tasks' run time
	 * (sum of sys time and user time). usages keeps tasks' cpu usage
	 */
	tms = (unsigned long *)malloc(sizeof(unsigned long) * nprocs);
	if (tms == NULL) {
		warn("alloc memory space for tasks' time failed.\n");
		return -1;
	}
	memset(tms, 0, sizeof(unsigned long) * nprocs);

	usages = (double *)malloc(sizeof(double) * nprocs);
	if (usages == NULL) {
		warn("alloc memory space for usages failed.\n");
		free(tms);
		return -1;
	}
	memset(usages, 0, sizeof(double) * nprocs);

	/* prepare to start test, wake up all the child processes at first */
	ret = kill(0, SIGUSR1);
	if (ret != 0) {
		warn("send signal to child failed.\n");
		goto err;
	}

	printf("Wait 10 seconds for running steadily!\n");
	fflush(NULL);
	/* wait for running steadily */
	sleep(10);

	printf("Test start\n");
	/* init the tms of every tasks */
	if (get_usages(pids, tms, NULL, nprocs, 0) != 0) {
		ret = -1;
		goto err;
	}

	while (!end) {
		sleep(TIME_INTERVAL);

		/* get every task's tms and calculate cpu usage */
		if (get_usages(pids, tms, usages, nprocs, 1) != 0) {
			ret = -1;
			goto err;
		}

		/* check the usage */
		if (check_usage(pids, usages, shares)
				!= 0) {
			nfaults++;
			ret = 1;
		}
	}

	if (ret == 0)
		printf("\nTest OK!\n");
	else
		printf("\nTest Fault. %d times out of range\n", nfaults);

err:
	free(usages);
	free(tms);
	return ret;
}

/* 
 * cleanup_groups - delete all groups
 * ngrps: the num of groups
 *
 * RETURN VALUE:
 * 	0  - success
 * 	-1 - error
 */
int cleanup_groups(int ngrps)
{
	char path[PATH_MAX];
	int i;

	if (chdir(CPUCTL) < 0) {
		warn("cleanup_group chdir error.");
		return -1;
	}

	if (group_relation == GROUP_HIERARCHY) {
		for (i = 0; i < ngrps - 1; i++) {
			snprintf(path, sizeof(path), "%d", i);
			if (chdir(path) < 0) {
				warn("cleanup_group chdir error.");
				return -1;
			}
		}
	}

	for (i = ngrps - 1; i >= 0; i--) {
		snprintf(path, sizeof(path), "%d", i);
		if (rmdir(path) < 0) {
			warn("cleanup_group rmdir error.");
			return -1;
		}
		if (group_relation == GROUP_HIERARCHY) {
			if (chdir("..") < 0) {
				warn("cleanup_group chdir error.");
				return -1;
			}
		}
	}
	return 0;
}

/* 
 * create_group - create groups
 * shares: the array to keep the groups' shares
 *
 * RETURN VALUE:
 * Upon successful return, the function return the number of groups created.
 * If on error, a negative value is returned.
 */
int create_groups(int *shares)
{
	int i;
	char buf[30];

	if (shares == NULL) {
		warnx("create_groups: shares is NULL.\n");
		return -1;
	}

	if (chdir(CPUCTL) < 0) {
		warn("create_groups chdir error.");
		return -1;
	}

	for (i = 0; i < ngroups; i++) {
		sprintf(buf, "%d", i);
		if (mkdir(buf, 0755) < 0) {
			warn("create_groups mkdir error.");
			break;
		}

		shares[i] = NICE_0_WEIGHT;

		if (group_relation == GROUP_HIERARCHY && chdir(buf) < 0) {
			warn("create_groups chdir error.");
			i++;
			break;
		}
	}
	return i;

}

/* 
 * attach_tasks - attach tasks into groups
 * pids: the array of tasks' pid
 *
 * RETURN VALUE:
 * 	0  - success
 * 	-1 - error
 */
int attach_tasks(pid_t *pids)
{
	char buf[30], pidbuf[30];
	int i, j;
	int fd;

	if (pids == NULL) {
		warnx("attach_tasks: pids is NULL.\n");
		return -1;
	}

	if (chdir(CPUCTL) < 0) {
		warn("attach_tasks: chdir error.");
		return -1;
	}

	for (i = 0; i < ngroups; i++) {
		sprintf(buf, "%d", i);
		if (chdir(buf) < 0) {
			warn("attach_tasks: chdir error.");
			return -1;
		}

		for (j = 0; j < nprocs_per_group; j++) {
			sprintf(pidbuf, "%d", pids[i * nprocs_per_group + j]);
			fd = open("tasks", O_WRONLY);
			if (fd == -1) {
				warn("attach_tasks: open tasks error.");
				return -1;
			}

			if (write(fd, pidbuf, strlen(pidbuf)) <= 0) {
				warn("attach_tasks: write pid error.");
				return -1;
			}
			close(fd);
		}

		if (group_relation == GROUP_SIBLING)
			if (chdir("..") < 0) {
				warn("attach_tasks: chdir error.");
				return -1;
			}
	}
	return 0;
}

int main(int argc, char *argv[])
{
	int i;
	int ngrps = 0;
	pid_t *pids;
	int *shares;
	int ret;

	checkopt(argc, argv);
	initialize();

	pids = (pid_t *)malloc(sizeof(pid_t) * nprocs);
	if (pids == NULL)
		err(EXIT_FAILURE, "malloc for pids failed");
	memset(pids, 0, sizeof(pid_t) * nprocs);

	shares = (int *)malloc(sizeof(int) * ngroups);
	if (shares == NULL)
		err(EXIT_FAILURE, "malloc for shares failed");
	memset(shares, 0, sizeof(int) * ngroups);

	fflush(NULL);
	for (i = 0; i < nprocs; i++) {
		pids[i] = fork();
		if (pids[i] < 0) {
			*child_end = 1;
			kill(0, SIGUSR1);
			err(EXIT_FAILURE, "fork()");
		} else if (pids[i] == 0)
			cpu_hog();
	}

	ngrps = create_groups(shares);
	if (ngrps != ngroups) {
		kill(0, SIGUSR1);
		ret = EXIT_FAILURE;
		goto err;
	}

	ret = attach_tasks(pids);
	if (ret != 0) {
		kill(0, SIGUSR1);
		goto err;
	}

	ret = do_check(pids, shares);

err:
	*child_end = 1;

	for (i = 0; i < nprocs; i++)
		wait(NULL);

	sleep(1);
	cleanup_groups(ngrps);

	cleanup_resources();
	return ret;
}


--------------020709090602050502000909--

