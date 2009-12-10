Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbZLJIGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbZLJIGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760727AbZLJIG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:06:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45615 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760712AbZLJIG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:06:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Dec 2009 17:03:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: Re: [RFC mm][PATCH 0/5] per mm counter updates
Message-Id: <20091210170339.072b24a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is test program I used. This is tuned for 4core/socket.

==
/*
 * multi-fault.c :: causes 60secs of parallel page fault in multi-thread.
 * % gcc -O2 -o multi-fault multi-fault.c -lpthread
 * % multi-fault # of cpus.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <pthread.h>
#include <sched.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>

#define CORE_PER_SOCK	4
#define NR_THREADS	8
pthread_t threads[NR_THREADS];
/*
 * For avoiding contention in page table lock, FAULT area is
 * sparse. If FAULT_LENGTH is too large for your cpus, decrease it.
 */
#define MMAP_LENGTH	(8 * 1024 * 1024)
#define FAULT_LENGTH	(2 * 1024 * 1024)
void *mmap_area[NR_THREADS];
#define PAGE_SIZE	4096

pthread_barrier_t barrier;
int name[NR_THREADS];

void segv_handler(int sig)
{
	sleep(100);
}
void *worker(void *data)
{
	cpu_set_t set;
	int cpu;

	cpu = *(int *)data;

	CPU_ZERO(&set);
	CPU_SET(cpu, &set);
	sched_setaffinity(0, sizeof(set), &set);

	cpu /= CORE_PER_SOCK;

	while (1) {
		char *c;
		char *start = mmap_area[cpu];
		char *end = mmap_area[cpu] + FAULT_LENGTH;
		pthread_barrier_wait(&barrier);
		//printf("fault into %p-%p\n",start, end);

		for (c = start; c < end; c += PAGE_SIZE)
			*c = 0;
		pthread_barrier_wait(&barrier);

		madvise(start, FAULT_LENGTH, MADV_DONTNEED);
	}
	return NULL;
}

int main(int argc, char *argv[])
{
	int i, ret;
	unsigned int num;

	if (argc < 2)
		return 0;

	num = atoi(argv[1]);	
	pthread_barrier_init(&barrier, NULL, num);

	mmap_area[0] = mmap(NULL, MMAP_LENGTH * num, PROT_WRITE|PROT_READ,
				MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
	for (i = 1; i < num; i++) {
		mmap_area[i] = mmap_area[i - 1]+ MMAP_LENGTH;
	}

	for (i = 0; i < num; ++i) {
		name[i] = i * CORE_PER_SOCK;
		ret = pthread_create(&threads[i], NULL, worker, &name[i]);
		if (ret < 0) {
			perror("pthread create");
			return 0;
		}
	}
	sleep(60);
	return 0;
}

