Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZDTUcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZDTUcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDTUcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:32:43 -0400
Received: from cmpxchg.org ([85.214.51.133]:58007 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbZDTUcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:32:43 -0400
Date: Mon, 20 Apr 2009 22:31:19 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 3/3][rfc] vmscan: batched swap slot allocation
Message-ID: <20090420203119.GA26066@cmpxchg.org>
References: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org> <1240259085-25872-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <1240259085-25872-3-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A test program creates an anonymous memory mapping the size of the
system's RAM (2G).  It faults all pages of it linearly, then kicks off
128 reclaimers (on 4 cores) that map, fault and unmap 2G in sum and
parallel, thereby evicting the first mapping onto swap.

The time is then taken for the initial mapping to get faulted in from
swap linearly again, thus measuring how bad the 128 reclaimers
distributed the pages on the swap space.

  Average over 5 runs, standard deviation in parens:

      swap-in          user            system            total

old:  74.97s (0.38s)   0.52s (0.02s)   291.07s (3.28s)   2m52.66s (0m1.32s)
new:  45.26s (0.68s)   0.53s (0.01s)   250.47s (5.17s)   2m45.93s (0m2.63s)

where old is current mmotm snapshot 2009-04-17-15-19 and new is these
three patches applied to it.

Test program attached.  Kernbench didn't show any differences on my
single core x86 laptop with 256mb ram (poor thing).

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="contswap2.c"

/*
 * contswap benchmark
 */

#include <sys/mman.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <assert.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

#define MEMORY		(1650 << 20)
#define RECLAIMERS	128

#define PAGE_SIZE	4096

#define PART		(MEMORY / RECLAIMERS)

static void *anonmap(unsigned long size)
{
	void *map = mmap(NULL, size, PROT_READ, MAP_PRIVATE | MAP_ANON, -1, 0);
	assert(map != MAP_FAILED);
	return map;
}

static void touch_linear(char *map, unsigned long size)
{
	unsigned long off;

	for (off = 0; off < size; off += PAGE_SIZE)
		if (map[off])
			puts("huh?");
}

static void __claim(unsigned long size)
{
	char *map = anonmap(size);
	touch_linear(map, size);
	sleep(5);
	munmap(map, size);
}

static pid_t claim(unsigned long size)
{
	pid_t pid;

	switch (pid = fork()) {
	case -1:
		puts("fork failed");
		exit(1);
	case 0:
		kill(getpid(), SIGSTOP);
		__claim(size);
		exit(0);
	default:
		return pid;
	}
}

int main(void)
{
	struct timeval start, stop, diff;
	pid_t pids[RECLAIMERS];
	int nr, crap;
	char *one;

	one = anonmap(MEMORY);
	touch_linear(one, MEMORY);

	for (nr = 0; nr < RECLAIMERS; nr++)
		pids[nr] = claim(PART);
	for (nr = 0; nr < RECLAIMERS; nr++)
		kill(pids[nr], SIGCONT);
	for (nr = 0; nr < RECLAIMERS; nr++)
		waitpid(pids[nr], &crap, 0);

	gettimeofday(&start, NULL);
	touch_linear(one, MEMORY);
	gettimeofday(&stop, NULL);
	munmap(one, MEMORY);

	timersub(&stop, &start, &diff);
	printf("%lu.%lu\n", diff.tv_sec, diff.tv_usec);

	return 0;
}

--liOOAslEiF7prFVr--
