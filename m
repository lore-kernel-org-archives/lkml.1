Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbZHXNrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbZHXNrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 09:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZHXNrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 09:47:47 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:60738 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbZHXNrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 09:47:46 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counters issue with enable_on_exec
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 15:46:58 +0200
Message-Id: <1251121618.7538.262.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:49 +0200, stephane eranian wrote:
> Hi,
> 
> I am running into an issue trying to use enable_on_exec
> in per-thread mode with an event group.
> 
> My understanding is that enable_on_exec allows activation
> of an event on first exec. This is useful for tools monitoring
> other tasks and which you invoke as: tool my_program. In
> other words, the tool forks+execs my_program. This option
> allows developers to setup the events after the fork (to get
> the pid) but before the exec(). Only execution after the exec
> is monitored. This alleviates the need to use the
> ptrace(PTRACE_TRACEME) call.
> 
> My understanding is that an event group is scheduled only
> if all events in the group are active (disabled=0). Thus, one
> trick to activate a group  with a single ioctl(PERF_IOC_ENABLE)
> is to enable all events in the group except the leader. This works
> well. But once you add enable_on_exec on on the events,
> things go wrong. The non-leader events start counting before
> the exec. If the non-leader events are created in disabled state,
> then they never activate on exec.
> 
> The attached test program demonstrates the problem.
> simply invoke with a program that runs for a few seconds.

OK, lots of issues here

 1) your code is broken ;-)
 2) enable_on_exec on !leader counters is undefined
 3) there is something fishy non the less


1. you fork() then create a counter group in both the parent and the
child without sync, then read the parent group. This obviously doesn't
do what is expected. See attached proglet for a better version.

2. enable_on_exec only works on leaders, Paul, was that intended?

3. the scale stuff seems broken

# perf stat -e cycles -e instructions --repeat 10 true

 Performance counter stats for 'true' (10 runs):

        2612124  cycles                     ( +-   1.327% )
        1870479  instructions             #      0.716 IPC     ( +-   0.132% )

    0.003743155  seconds time elapsed   ( +-   1.203% )

# ./test-enable_on_exec true
             2651600 PERF_COUNT_HW_CPU_CYCLES 1111509 1111509 2651600.000000
             1832720 PERF_COUNT_HW_INSTRUCTIONS 839395242 1111509 1384043177.264637

Paul, would a counter's time start running when its 'enabled' but part
of a non-runnable group?


---
#include "perf.h"

#include <sys/types.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>
#include <syscall.h>
#include <err.h>
#include <fcntl.h>


int child(char **arg)
{
	int i;

	/* burn cycles to detect if monitoring start before exec */
	for(i=0; i < 5000000; i++) syscall(__NR_getpid);
	execvp(arg[0], arg);
	errx(1, "cannot exec: %s\n", arg[0]);
	/* not reached */
}

int parent(char **arg)
{
	struct perf_counter_attr hw[2];
	char *name[2];
	int fd[2];
	int status, ret, i;
	uint64_t values[3];
	pid_t pid;
	int child_ready_pipe[2], go_pipe[2];
	char buf;

	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
		perror("Failed to create pipes");
		exit(1);
	}

	if ((pid=fork()) == -1)
		err(1, "Cannot fork process");

	if (pid == 0) {
		close(child_ready_pipe[0]);
		close(go_pipe[1]);
		fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);

		execvp("", (char **)arg);

		/*
		 * let the parent know we exist
		 */
		close(child_ready_pipe[1]);

		/*
		 * wait for the parent to attach its counters
		 */
		if (read(go_pipe[0], &buf, 1) == -1)
			perror("unable to read go_pipe");

		exit(child(arg));
	}

	close(child_ready_pipe[1]);
	close(go_pipe[0]);
	/*
	 * wait for the child to appear
	 */
	if (read(child_ready_pipe[0], &buf, 1) == -1)
		perror("unable to read child_ready_pipe");
	close(child_ready_pipe[0]);

	memset(hw, 0, sizeof(hw));

	name[0] = "PERF_COUNT_HW_CPU_CYCLES";
	hw[0].type = PERF_TYPE_HARDWARE;
	hw[0].config = PERF_COUNT_HW_CPU_CYCLES;
	hw[0].read_format =
		PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING;
	hw[0].disabled = 1;
	hw[0].enable_on_exec = 1;

	name[1] = "PERF_COUNT_HW_INSTRUCTIONS";
	hw[1].type = PERF_TYPE_HARDWARE;
	hw[1].config = PERF_COUNT_HW_INSTRUCTIONS;
	hw[1].read_format =
		PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING;
	hw[1].disabled = 0;
	hw[1].enable_on_exec = 0;

	fd[0] = sys_perf_counter_open(&hw[0], pid, -1, -1, 0);
	if (fd[0] == -1)
		err(1, "cannot open event0");

	fd[1] = sys_perf_counter_open(&hw[1], pid, -1, fd[0], 0);
	if (fd[1] == -1)
		err(1, "cannot open event1");

	/*
	 * we're good to go, let the child rip
	 */
	close(go_pipe[1]);

	waitpid(pid, &status, 0);

	for(i=0; i < 2; i++) {
		ret = read(fd[i], values, sizeof(values));
		if (ret < sizeof(values))
			err(1, "cannot read values event %s", name[i]);

		printf("%20"PRIu64" %s %ld %ld %f\n",
				values[0],
				name[i],
				values[1], values[2],
			values[2] ? (double)values[0] * values[1]/values[2] : 0);

		close(fd[i]);
	}
	return 0;
}

int main(int argc, char **argv)
{
	if (!argv[1])
		errx(1, "you must specify a command to execute\n");

	return parent(argv+1);
}



