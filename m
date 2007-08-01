Return-Path: <linux-kernel-owner+w=401wt.eu-S1763546AbXHANTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763546AbXHANTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbXHANTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:19:32 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3098 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837AbXHANTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:19:32 -0400
Date: Wed, 1 Aug 2007 15:19:08 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070801071230.GA16375@elte.hu>
Message-ID: <Pine.LNX.4.64.0708011511530.1817@scrub.home>
References: <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801071230.GA16375@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 1 Aug 2007, Ingo Molnar wrote:

> Please also send me the output of this script:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

Send privately.

> Could you also please send the source code for the "l.c" and "lt.c" apps
> you used for your testing so i can have a look. Thanks!

l.c is a simple busy loop (well, with the option to start many of them).
This is lt.c, what it does is to run a bit less than a jiffie, so it 
needs a low resolution clock to trigger the problem:

#include <stdio.h>
#include <signal.h>
#include <time.h>
#include <sys/time.h>

#define NSEC 1000000000
#define USEC 1000000

#define PERIOD	(NSEC/1000)

int i;

void worker(int sig)
{
	struct timeval tv;
	long long t0, t;

	gettimeofday(&tv, 0);
	//printf("%u,%lu\n", i, tv.tv_usec);
	t0 = (long long)tv.tv_sec * 1000000 + tv.tv_usec + PERIOD / 1000 - 50;
	do {
		gettimeofday(&tv, 0);
		t = (long long)tv.tv_sec * 1000000 + tv.tv_usec;
	} while (t < t0);
	
}

int main(int ac, char **av)
{
	int cnt;
	timer_t timer;
	struct itimerspec its;
	struct sigaction sa;

	cnt = i = atoi(av[1]);

	sa.sa_handler = worker;
	sa.sa_flags = 0;
	sigemptyset(&sa.sa_mask);

	sigaction(SIGALRM, &sa, 0);

	clock_gettime(CLOCK_MONOTONIC, &its.it_value);
	its.it_interval.tv_sec = 0;
	its.it_interval.tv_nsec = PERIOD * cnt;

	while (--i > 0 && fork() > 0)
		;

	its.it_value.tv_nsec += i * PERIOD;
	if (its.it_value.tv_nsec > NSEC) {
		its.it_value.tv_sec++;
		its.it_value.tv_nsec -= NSEC;
	}

	timer_create(CLOCK_MONOTONIC, 0, &timer);
	timer_settime(timer, TIMER_ABSTIME, &its, 0);

	printf("%u,%lu\n", i, its.it_interval.tv_nsec);

	while (1) 
		pause();
	return 0;
}

