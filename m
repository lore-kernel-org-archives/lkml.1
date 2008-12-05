Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYLEHEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYLEHEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYLEHEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:04:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYLEHD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:03:59 -0500
Date: Fri, 5 Dec 2008 08:03:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205070329.GA30874@elte.hu>
References: <20081204225345.654705757@linutronix.de> <18744.29747.728320.652642@cargo.ozlabs.ibm.com> <20081205063131.GB12785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205063131.GB12785@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> This can be done in a very natural way with our abstraction, and the 
> "hello.c" example happens to do exactly that:

multiple people pointed out that we have not posted hello.c :-/

Here's a simple standalone example (full working code attached below):

int main(void)
{
	unsigned long long count1, count2;
	int fd1, fd2, ret;

	fd1 = perf_counter_open(PERF_COUNT_INSTRUCTIONS, 0, 0, 0, -1);
	assert(fd1 >= 0);
	fd2 = perf_counter_open(PERF_COUNT_CACHE_MISSES, 0, 0, 0, -1);
	assert(fd1 >= 0);

	for (;;) {
		ret = read(fd1, &count1, sizeof(count1));
		assert(ret == 8);
		ret = read(fd2, &count2, sizeof(count2));
		assert(ret == 8);

		printf("counter1 value: %Ld instructions\n", count1);
		printf("counter2 value: %Ld cachemisses\n",  count2);
		sleep(1);
	}
	return 0;
}


which gives this output (one readout per second):

  titan:~/perf-counter-test> ./simple 
  counter1 value: 0 instructions
  counter2 value: 0 cachemisses
  counter1 value: 23 instructions
  counter2 value: 0 cachemisses
  counter1 value: 2853 instructions
  counter2 value: 6 cachemisses
  counter1 value: 5736 instructions
  counter2 value: 7 cachemisses
  counter1 value: 8619 instructions
  counter2 value: 8 cachemisses
  counter1 value: 11502 instructions
  counter2 value: 8 cachemisses
  ^C

You need our patchset but then the code below will work just fine. No 
libraries, no context setup, nothing - just what is more interesting: the 
counter and profiling data.

	Ingo

----------------->
/*
 * Very simple performance counter testcase.
 */
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/uio.h>

#include <linux/unistd.h>

#include <assert.h>
#include <unistd.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>

#ifdef __x86_64__
# define __NR_perf_counter_open	295
#endif

#ifdef __i386__
# define __NR_perf_counter_open 333
#endif

int
perf_counter_open(int		hw_event_type,
                  unsigned int	hw_event_period,
                  unsigned int	record_type,
                  pid_t		pid,
                  int		cpu)
{
	return syscall(__NR_perf_counter_open, hw_event_type, hw_event_period,
			record_type, pid, cpu);
}

enum hw_event_types {
	PERF_COUNT_CYCLES,
	PERF_COUNT_INSTRUCTIONS,
	PERF_COUNT_CACHE_REFERENCES,
	PERF_COUNT_CACHE_MISSES,
	PERF_COUNT_BRANCH_INSTRUCTIONS,
	PERF_COUNT_BRANCH_MISSES,
};

int main(void)
{
	unsigned long long count1, count2;
	int fd1, fd2, ret;

	fd1 = perf_counter_open(PERF_COUNT_INSTRUCTIONS, 0, 0, 0, -1);
	assert(fd1 >= 0);
	fd2 = perf_counter_open(PERF_COUNT_CACHE_MISSES, 0, 0, 0, -1);
	assert(fd1 >= 0);

	for (;;) {
		ret = read(fd1, &count1, sizeof(count1));
		assert(ret == 8);
		ret = read(fd2, &count2, sizeof(count2));
		assert(ret == 8);

		printf("counter1 value: %Ld instructions\n", count1);
		printf("counter2 value: %Ld cachemisses\n",  count2);
		sleep(1);
	}
	return 0;
}

