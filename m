Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYHSFhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYHSFhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 01:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYHSFhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 01:37:32 -0400
Received: from gw.goop.org ([64.81.55.164]:32862 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbYHSFhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 01:37:31 -0400
Message-ID: <48AA5C19.3010204@goop.org>
Date: Mon, 18 Aug 2008 22:37:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
 to use function calls [POST 2]
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu>
In-Reply-To: <20080819004531.GI9914@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------010307070601020307040202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010307070601020307040202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> nice stuff!
>
> I suspect the extra cost might be worth it for two reasons: 1) we could 
> optimize the cross-call implementation further

Unfortunately, I think the kmalloc fix for the RCU issue is going to
hurt quite a lot.

>  2) on systems where TLB 
> flushes actually matter, the ability to overlap multiple TLB flushes to 
> the same single CPU might improve workloads.
>   

...perhaps.

> FYI, i've created a new -tip topic for your patches, tip/x86/tlbflush. 
> It's based on tip/irq/sparseirq (there are a good deal of dependencies 
> with that topic).
>   

Really?  I didn't see much conflict when rebasing onto current tip.git. 
Just an incidental context conflict in entry_arch.h.

> It would be nice to see some numbers on sufficiently SMP systems, using 
> some mmap/munmap intense workload.

I've attached my test program: tlb-mash.c.  Compile with "gcc -o
tlb-mash tlb-mash.c -lpthread" and run with ./tlb-mash X, where X is the
number of threads to run (2x cpus works well).  It keeps running until
killed, with each thread repeatedly mprotecting a page within a shared
mapping.

    J

--------------010307070601020307040202
Content-Type: text/x-csrc;
 name="tlb-mash.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tlb-mash.c"

#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>

#define MAX_THREADS	256

static char *mapping;

static void *masher(void *v)
{
	int id = (int)v;
	unsigned offset = id * getpagesize();

	printf("started thread %d\n", id);

	for(;;) {
		mprotect(mapping+offset, getpagesize(), PROT_READ);
		mprotect(mapping+offset, getpagesize(), PROT_READ | PROT_WRITE);
	}

	return NULL;
}

int main(int argc, char **argv)
{
	int i;
	int nthreads = 4;
	pthread_t threads[MAX_THREADS];

	if (argc == 2) {
		int t = atoi(argv[1]);
		if (t != 0)
			nthreads = t;
	}
	if (nthreads > MAX_THREADS)
		nthreads = MAX_THREADS;

	printf("creating %d threads...\n", nthreads);

	mapping = mmap(0, getpagesize() * nthreads, PROT_NONE,
		       MAP_POPULATE|MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
	if (mapping == (char *)-1) {
		perror("mmap failed");
		return 1;
	}

	for(i = 0; i < nthreads; i++) {
		int ret;
		ret = pthread_create(&threads[i], NULL, masher, (void *)i);
		if (ret) {
			printf("pthread create %d failed: %s\n", i, strerror(ret));
			return 1;
		}
	}

	for(i = 0; i < nthreads; i++) {
		void *ret;
		pthread_join(threads[i], &ret);
	}

	return 0;
}

--------------010307070601020307040202--
