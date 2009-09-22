Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZIVFuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZIVFuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbZIVFuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:50:04 -0400
Received: from ozlabs.org ([203.10.76.45]:46451 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbZIVFuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:50:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] stop_machine: disable preempt in stop machine path
Date: Tue, 22 Sep 2009 15:20:03 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Kathy Staples <kathy.staples@au1.ibm.com>
References: <4AB0933E.8020901@cn.fujitsu.com>
In-Reply-To: <4AB0933E.8020901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909221520.04583.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 04:56:54 pm Xiao Guangrong wrote:
> We can disable preempt in stop_cpu(), It can reduce the cpu's waiting time
> and make stop_machine path faster.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Do you have a benchmark?  I had a lot of trouble showing any latency
problem with stop_machine...

Thanks!
Rusty.

Here's the rough code I used (modprobe does a stop_machine, so makes a
convenient test), Kathy helped write it:

#define _GNU_SOURCE
#include <sched.h>
#include <sys/time.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <err.h>
#include <string.h>
#include "time_diff.h"

/* "Copyright 2007 <kathy.staples@au.ibm.com> IBM Corp" */
#define streq(a,b) (strcmp((a),(b)) == 0)

static uint64_t timeval_to_usecs(struct timeval convert)
{	/* this function works out the number of microseconds  */
	return (convert.tv_sec * (uint64_t)1000000 + convert.tv_usec);
}

static void *grab_file(const char *filename, unsigned long *size)
{
	unsigned int max = 16384;
	int ret, fd;
	void *buffer = malloc(max);
	if (!buffer)
		return NULL;

	if (streq(filename, "-"))
		fd = dup(STDIN_FILENO);
	else
		fd = open(filename, O_RDONLY, 0);

	if (fd < 0)
		return NULL;

	*size = 0;
	while ((ret = read(fd, buffer + *size, max - *size)) > 0) {
		*size += ret;
		if (*size == max)
			buffer = realloc(buffer, max *= 2);
	}
	if (ret < 0) {
		free(buffer);
		buffer = NULL;
	}
	close(fd);
	return buffer;
}

extern long init_module(void *, unsigned long, const char *);

/* If module is NULL, merely go through the motions. */
static void do_modprobe(int cpu, int pollfd, int secs, const char *module)
{
	struct sched_param sparam = { .sched_priority = 99 };
	cpu_set_t this_cpu;
	fd_set readfds;
	int error;
	struct timeval timeout = { .tv_sec = 5 };
	void *file;
	unsigned long len;

	if (module) {
		file = grab_file(module, &len);
		if (!file)
			err(1, "Loading file %s", module);
	}

	CPU_ZERO(&this_cpu);
	CPU_SET(cpu, &this_cpu);
	if (sched_setaffinity(getpid(), sizeof(cpu_set_t), &this_cpu) != 0)
		err(1, "Could not move modprobe to cpu %i", cpu);
	if (sched_setscheduler(getpid(), SCHED_FIFO, &sparam) != 0)
		err(1, "Could not set FIFO scheduler for modprobe");

	/* Wait for go signal. */
	FD_ZERO(&readfds);
	FD_SET(pollfd, &readfds);

	/* We can timeout. */
	if (select(pollfd + 1, &readfds, NULL, NULL, &timeout) != 1)
		exit(1);

	/* Sleep until halfway through. */
	usleep(secs * 500000);

	if (module) {
		error = init_module(file, len, "");
		if (error)
			err(1, "init_module '%s'", module);
	}
	printf("Modprobe done on cpu %i\n", cpu);
	exit(0);
}

static void measure_latency(int cpu, int secs, int writefd, int pollfd)
{
	struct timeval start_time, now, elapsed_time, previous_time, diff;
	uint64_t least, max_diff, no_of_diffs;
	cpu_set_t this_cpu;
	fd_set readfds;
	struct timeval timeout = { .tv_sec = 5 };
	char buf[1024];
	struct sched_param sparam = { .sched_priority = 50 };

	least = UINT64_MAX;
	max_diff = 0;
	no_of_diffs = 0;

	CPU_ZERO(&this_cpu);
	CPU_SET(cpu, &this_cpu);
	if (sched_setaffinity(getpid(), sizeof(cpu_set_t), &this_cpu) != 0)
		err(1, "Could not move to cpu %i", cpu);
	if (sched_setscheduler(getpid(), SCHED_FIFO, &sparam) != 0)
		err(1, "Could not set FIFO scheduler");

	/* Note that we're ready. */
	write(writefd, "", 1);

	/* Wait for go signal. */
	FD_ZERO(&readfds);
	FD_SET(pollfd, &readfds);

	/* We can timeout. */
	if (select(pollfd + 1, &readfds, NULL, NULL, &timeout) != 1)
		exit(1);

	gettimeofday(&start_time, NULL);
	previous_time = start_time;
	do {
		gettimeofday(&now, NULL); 
		/* call conv_timeval func; apply to now and previous time; calc diff */
			
		time_diff(&previous_time, &now, &diff);

		if (timeval_to_usecs(diff) > max_diff)
			max_diff = timeval_to_usecs(diff);

		if (timeval_to_usecs(diff) < least)   /* This should always return 0 */
			least = timeval_to_usecs(diff);
					
		/* Work out time to elapse since the starting time */
		time_diff(&start_time, &now, &elapsed_time);
			
		/* reset previous_time to now */
		previous_time = now; 

		no_of_diffs++;
	} while (elapsed_time.tv_sec < secs);

	sprintf(buf, "CPU %u: %llu diffs, min/avg/max = %llu/%llu/%llu\n",
		cpu, no_of_diffs,
		least,
		timeval_to_usecs(elapsed_time) / no_of_diffs,
		max_diff);

	write(STDOUT_FILENO, buf, strlen(buf));
	exit(0);
}

int main(int argc, char *argv[])
{
	int i, secs, status, tochildren[2], fromchild[2], arg;
	const char *module;

	if (argc < 3) {
		printf("Usage: %s [--modprobe=<module>] <seconds> <cpunum>...\n", argv[0]);
		exit(1);
	}

	arg = 1;
	if (strncmp(argv[arg], "--modprobe=", strlen("--modprobe=")) == 0) {
		module = argv[arg] + 11;
		arg++;
	} else
		module = NULL;

	if (pipe(tochildren) != 0 || pipe(fromchild) != 0)
		err(1, "Creating pipes");

	secs = atoi(argv[arg++]);

	switch (fork()) {
	case -1:
		err(1, "fork failed");
	case 0:
		do_modprobe(atoi(argv[arg]), tochildren[0], secs, module);
	}

	for (i = arg+1; i < argc; i++) {
		char c;
		switch (fork()) {
		case -1:
			err(1, "fork failed");
		case 0:
			measure_latency(atoi(argv[i]), secs, 
					fromchild[1], tochildren[0]);
		}
		if (read(fromchild[0], &c, 1) != 1)
			err(1, "Read from child failed");
	}

	/* Tell them to go. */
	write(tochildren[1], "", 1);

	/* Wait for the children. */
	status = 0;
	for (i = arg; i < argc; i++) {
		if (status == 0) {
			wait(&status);
			if (!WIFEXITED(status) || WEXITSTATUS(status) != 0)
				status = 1;
		} else
			wait(NULL);
	}

	return status;
}


	
