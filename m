Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYLEIMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYLEIMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYLEIMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:12:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39111 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYLEIME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:12:04 -0500
Date: Fri, 5 Dec 2008 09:11:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205081137.GB2030@elte.hu>
References: <1228461385.18899.13.camel@twins> <18744.57057.243817.407691@cargo.ozlabs.ibm.com> <1228464216.18899.18.camel@twins> <20081205.000716.40104924.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205.000716.40104924.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri, 05 Dec 2008 09:03:36 +0100
> 
> > On Fri, 2008-12-05 at 18:57 +1100, Paul Mackerras wrote:
> > > Peter Zijlstra writes:
> > > 
> > > > So, while most people would not consider two consecutive read() ops to
> > > > be close or near the same time, due to preemption and such, that is
> > > > taken away by the fact that the counters are task local time based - so
> > > > preemption doesn't affect thing. Right?
> > > 
> > > I'm sorry, I don't follow the argument here.  What do you mean by
> > > "task local time based"?
> > 
> > time only flows when the task is running.
> 
> These things aren't measuring time, or even just cycles, they are 
> measuring things like L2 cache misses, cpu cycles, and other similar 
> kinds of events.
> 
> So these counters are going to measure all of the damn crap assosciated 
> with doing the read() call as well as the real work the task does.

that's wrong, look at the example we posted - see it pasted below.

When monitoring another task it does _not_ count the read() done in the 
monitoring task, it does _not_ include it in the event count. It is a 
fundamental property of our code to be as unintrusive as possible. It 
only measures the work done by that task.

( You _can_ measure your own overhead of course too, if you want to. It's 
  a natural special-case of our performance counter abstraction. )

	Ingo

---

/*
 * Performance counters monitoring test case
 */
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>

#define __user

#include "sys.h"

static int count = 10000;
static int eventid;
static int tid;
static char *debuginfo;

static void display_help(void)
{
	printf("monitor\n");
	printf("Usage:\n"
	       "monitor options threadid\n\n"
	       "-e EID   --eventid=EID  eventid\n"
	       "-c CNT   --count=CNT    event count on which IP is sampled\n"
	       "-d FILE  --debug=FILE   path to binary file with debug info\n");
	exit(0);
}

static void process_options (int argc, char *argv[])
{
	int error = 0;

	for (;;) {
		int option_index = 0;
		/** Options for getopt */
		static struct option long_options[] = {
			{"count", required_argument, NULL, 'c'},
			{"debug", required_argument, NULL, 'd'},
			{"eventid", required_argument, NULL, 'e'},
			{"help", no_argument, NULL, 'h'},
			{NULL, 0, NULL, 0}
		};
		int c = getopt_long(argc, argv, "c:d:e:",
				    long_options, &option_index);
		if (c == -1)
			break;
		switch (c) {
		case 'c': count = atoi(optarg); break;
		case 'd': debuginfo = strdup(optarg); break;
		case 'e': eventid = atoi(optarg); break;
		default: error = 1; break;
		}
	}
	if (error || optind == argc)
		display_help ();

	tid = atoi(argv[optind]);
}

int main(int argc, char *argv[])
{
	char str[256];
	uint64_t ip;
	ssize_t res;
	int fd;

	process_options(argc, argv);

	fd = perf_counter_open(eventid, count, 1, tid, -1);
	if (fd < 0) {
		perror("Create counter");
		exit(-1);
	}

	while (1) {
		res = read(fd, (char *) &ip, sizeof(ip));
		if (res != sizeof(ip)) {
			perror("Read counter");
			break;
		}

		if (!debuginfo) {
			printf("IP: 0x%016llx\n", (unsigned long long)ip);
		} else {
			sprintf(str, "addr2line -e %s 0x%llx\n", debuginfo,
				(unsigned long long)ip);
			system(str);
		}
	}

	close(fd);
	exit(0);
}


