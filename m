Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZHTNtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZHTNtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZHTNtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:49:07 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44438 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbZHTNtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=Y7wgH/LVOnKUiMZ2qgGlCxsEh0n1/S9eFmf4zFTRFZ1iI0K+QGjgQHoW4/jvnQL0la
         oHqXtymDIkyp1Lky1VFsC0xPEw2PcVj737tGlXx6S/WOrhW7Hr5KijypHtJBdJJTbeo4
         gsNjFjU0NDluUxh0VbjQSiZw5Nh41Xcckc84w=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
Date: Thu, 20 Aug 2009 15:49:05 +0200
Message-ID: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
Subject: perf_counters issue with enable_on_exec
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running into an issue trying to use enable_on_exec
in per-thread mode with an event group.

My understanding is that enable_on_exec allows activation
of an event on first exec. This is useful for tools monitoring
other tasks and which you invoke as: tool my_program. In
other words, the tool forks+execs my_program. This option
allows developers to setup the events after the fork (to get
the pid) but before the exec(). Only execution after the exec
is monitored. This alleviates the need to use the
ptrace(PTRACE_TRACEME) call.

My understanding is that an event group is scheduled only
if all events in the group are active (disabled=0). Thus, one
trick to activate a group  with a single ioctl(PERF_IOC_ENABLE)
is to enable all events in the group except the leader. This works
well. But once you add enable_on_exec on on the events,
things go wrong. The non-leader events start counting before
the exec. If the non-leader events are created in disabled state,
then they never activate on exec.

The attached test program demonstrates the problem.
simply invoke with a program that runs for a few seconds.


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

#include <perf_counter.h>

int
child(char **arg)
{
	int i;

	/* burn cycles to detect if monitoring start before exec */
	for(i=0; i < 5000000; i++) syscall(__NR_getpid);
	execvp(arg[0], arg);
	errx(1, "cannot exec: %s\n", arg[0]);
	/* not reached */
}

int
parent(char **arg)
{
	struct perf_counter_attr hw[2];
	char *name[2];
	int fd[2];
	int status, ret, i;
	uint64_t values[3];
	pid_t pid;

	if ((pid=fork()) == -1)
		err(1, "Cannot fork process");


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
	hw[1].enable_on_exec = 1;

	fd[0] = perf_counter_open(&hw[0], pid, -1, -1, 0);
	if (fd[0] == -1)
		err(1, "cannot open event0");

	fd[1] = perf_counter_open(&hw[1], pid, -1, fd[0], 0);
	if (fd[1] == -1)
		err(1, "cannot open event1");

	if (pid == 0)
		exit(child(arg));

	waitpid(pid, &status, 0);

	for(i=0; i < 2; i++) {
		ret = read(fd[i], values, sizeof(values));
		if (ret < sizeof(values))
			err(1, "cannot read values event %s", name[i]);
		if (values[2])
			values[0] = (uint64_t)((double)values[0] * values[1]/values[2]);

		printf("%20"PRIu64" %s %s\n",
			values[0],
			name[i],
			values[1] != values[2] ? "(scaled)" : "");

		close(fd[i]);
	}
	return 0;
}

int
main(int argc, char **argv)
{
	if (!argv[1])
		errx(1, "you must specify a command to execute\n");
	
	return parent(argv+1);
}
