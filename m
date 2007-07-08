Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbXGHEcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbXGHEcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 00:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXGHEcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 00:32:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXGHEce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 00:32:34 -0400
Date: Sun, 8 Jul 2007 06:32:28 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: queued spinlock code and results
Message-ID: <20070708043228.GB22397@wotan.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I made some tests of the queued spinlock code using userspace test code on
64-bit processors. I believe the xadd based code no longer has any theoretical
memory ordering problems.

The tests were done on 3 different architectures of different speeds and
vintages (so not really comparable between columns). I have attached the two
programs I used to make the results. Times are total elapsed time divided by
the number of locks (so effectively you get the time required for lock+unlock).

The threaded results also attempt to have an unfairness count, which is the
max number of times in a row that a lock is acquired,  when all other threads
are also executing in the loop -- the reason xadd for example is not always
0 there is because the other threads may not have reached the lock before
the current thread was able to get it several times (eg. if an interrupt
comes in, this could happen).

The threaded results are actually not too interesting because firstly they
don't really simulate the right mixture and timing of locks and critical
section time vs parallel time, and secondly the times are pretty heavily
skewed toward the unfair locks which tend to be _really_ unfair (eg. on the
last test, some threads were taking a full 2x longer to finish than others)
and so each thread gets to run for a long time without cache misses and thus
the overall throughput goes up. The dual-core core2 for another example did
regularly starve each thread for up to about 7*ms* (13 million cycles) while
the other was taking and releasing the lock.

However the non-threaded numbers (first 4 rows) are reasonably good. I found
on Core2 that if the inner loop was simply a lock+unlock and nothing else,
the inc-lock gained a bit more over the xadd-lock, but I don't think this is
representative of real code and it may just have been some alignment or
scheduling easter egg.

The results show that the xadd lock is definitely slower in single thread,
however the Core2 does really well, and also the cache cold case is pretty
insignificant.

It suggests to me that it *may* be worth trying a wholesale replacement of
spinlock with queued spinlock on x86 (starting as a config option which we
could perhaps default to ON in -mm / early -rcs). I think the main risk is
if there is some code that is really relying on the unfair batching nature
of the locks for good performance. I would argue that would usually be
poor code (eg. taking and dropping the spinlock too often, too much
contention on the lock, or using the wrong type of lock in the first place)  --
I think cacheline batching is great for regular lines, but not quite so nice
for locks. It would be interesting to see how something like the dcache lock
goes in dcache heavy workloads...


                         | Core2           Pentium 4 (Nocona)  Opteron
inc in cache             |  21.4ns           38.7ns              11.8ns
xadd in cache            |  22.5ns           44.4ns              14.5ns
                         |
inc no cache             | 122.2ns          153.5ns             172.7ns
xadd no cache            | 123.9ns          154.7ns             174.0ns
                         |
inc 2 thread (unfair)    | 230.9ns (69211)  376.5ns (3104)      174.0ns (2068) 
xadd 2 thread (unfair)   | 273.2ns (0)      307.1ns (59)        743.8ns (220)
                         |
inc 2 thread, other skt  |                  144.8ns (20444)     145.7ns (39739)
xadd 2 thread, other skt |                  306.8ns (147)       748.0ns (488)
                         |
inc 4 thread             |                 1248.9ns (172)      1158.5ns (139410)
xadd 4 thread            |                 1014.0ns (0)        2843.5ns (0)
                         |
inc 4 thread, diff skts  |                                     1598.0ns (65727)
xadd 4 thread, diff skts |                                     2848.1ns (0)
                         |
inc 16 thread            |                                     19017ns (55698)
xadd 16 thread           |                                     42723ns (0)



#define LOCK_INIT 1
static void lock(short *lock)
{
	__asm__ __volatile__ ("1:\n\t"
			      "lock ; decb %0\n\t"
			      "jns 2f\n\t"
			      "3:\n\t"
			      "rep ; nop\n\t"
			      "cmpb $0,%0\n\t"
			      "jle 3b\n\t"
			      "jmp 1b\n\t"
			      "2:\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

static void unlock(short *lock)
{
	__asm__ __volatile__ ("movb $1,%0\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

#define XLOCK_INIT 0
static void xlock(short *lock)
{
	short i = 0x0100;
	__asm__ __volatile__ ("lock ; xaddw %%ax, %1\n\t"
			      "1:\n\t"
			      "cmpb %%ah, %%al\n\t"
			      "je 2f\n\t"
			      "rep ; nop\n\t"
			      "movb %1, %%al\n\t"
			      "lfence\n\t"
			      "jmp 1b\n\t"
			      "2:\n\t"
			    : "+a" (i), "+m" (*lock)
			    : : "memory");
}

static void xunlock(short *lock)
{
	__asm__ __volatile__ ("incb %0\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

---


--4Ckj6UjgE2iN1+kY
Content-Type: text/x-c++src; charset=us-ascii
Content-Disposition: attachment; filename="lock.c"

#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

struct page {
	short lock;
	unsigned int next;
};
#define NR_PAGES (2*1024*1024)
static struct page pages[NR_PAGES];

#define LOCK_INIT 1
static void lock(short *lock)
{
	__asm__ __volatile__ ("1:\n\t"
			      "lock ; decb %0\n\t"
			      "jns 2f\n\t"
			      "3:\n\t"
			      "rep ; nop\n\t"
			      "cmpb $0,%0\n\t"
			      "jle 3b\n\t"
			      "jmp 1b\n\t"
			      "2:\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

static void unlock(short *lock)
{
	__asm__ __volatile__ ("movb $1,%0\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

#define XLOCK_INIT 0
static void xlock(short *lock)
{
	short i = 0x0100;
	__asm__ __volatile__ ("lock ; xaddw %%ax, %1\n\t"
			      "1:\n\t"
			      "cmpb %%ah, %%al\n\t"
			      "je 2f\n\t"
			      "rep ; nop\n\t"
			      "movb %1, %%al\n\t"
			      "lfence\n\t"
			      "jmp 1b\n\t"
			      "2:\n\t"
			    : "+a" (i), "+m" (*lock)
			    : : "memory");
}

static void xunlock(short *lock)
{
	__asm__ __volatile__ ("incb %0\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

static int xlock_is_locked(short *lock)
{
	short tmp = *lock;
	char *x = (char *)&tmp;

	return (*x != *(x+1));
}

#define ITERS (16*1024*1024)
#define IN_ITERS (ITERS*5)

int main(void)
{
	int nr_pages;
	int nr;
	int i;
	struct page *p;
	struct timeval start, end;
	unsigned long long usec;
	unsigned int tmp;

	nr_pages = 10;
	srandom(10);
	p = &pages[0];
	i = 0;
	nr = 0;
	while (nr < nr_pages-1) {
		unsigned int n;

		n = random() % NR_PAGES;
		while (p == &pages[n] || pages[n].next)
			n = (n+1) % NR_PAGES;
		p->next = n;
		p = &pages[n];
		nr++;
	}
	p->next = 0;

	for (i = 0; i < NR_PAGES; i++)
		pages[i].lock = LOCK_INIT;
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < IN_ITERS; i++) {
		lock(&p->lock);
		tmp = p->next;
		unlock(&p->lock);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("inc-lock in cache takes %0.2lfns\n", (double)usec * 1000 / IN_ITERS);

	for (i = 0; i < NR_PAGES; i++)
		pages[i].lock = XLOCK_INIT;
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < IN_ITERS; i++) {
		xlock(&p->lock);
		tmp = p->next;
		xunlock(&p->lock);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("xadd-lock in cache takes %0.2lfns\n", (double)usec * 1000 / IN_ITERS);

	for (i = 0; i < NR_PAGES; i++)
		pages[i].next = 0;

	nr_pages = NR_PAGES;
	srandom(10);
	p = &pages[0];
	i = 0;
	nr = 0;
	while (nr < nr_pages-1) {
		unsigned int n;

		n = random() % NR_PAGES;
		while (p == &pages[n] || pages[n].next)
			n = (n+1) % NR_PAGES;
		p->next = n;
		p = &pages[n];
		nr++;
	}
	p->next = 0;

	for (i = 0; i < NR_PAGES; i++)
		pages[i].lock = LOCK_INIT;
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < ITERS; i++) {
		lock(&p->lock);
		tmp = p->next;
		unlock(&p->lock);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("inc-lock out of cache takes %0.2lfns\n", (double)usec * 1000 / ITERS);


	for (i = 0; i < NR_PAGES; i++)
		pages[i].lock = XLOCK_INIT;
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < ITERS; i++) {
		xlock(&p->lock);
		tmp = p->next;
		xunlock(&p->lock);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("xadd-lock out of cache takes %0.2lfns\n", (double)usec * 1000 / ITERS);


	return 0;
}

--4Ckj6UjgE2iN1+kY
Content-Type: text/x-c++src; charset=us-ascii
Content-Disposition: attachment; filename="lock-threads.c"

#define _GNU_SOURCE
#include <sched.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>

static short glock;

#define LOCK_INIT 1
static void lock(short *lock)
{
	__asm__ __volatile__ ("1:\n\t"
			      "lock ; decb %0\n\t"
			      "jns 2f\n\t"
			      "3:\n\t"
			      "rep ; nop\n\t"
			      "cmpb $0,%0\n\t"
			      "jle 3b\n\t"
			      "jmp 1b\n\t"
			      "2:\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

static void unlock(short *lock)
{
	__asm__ __volatile__ ("movb $1,%0\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

#define XLOCK_INIT 0
static void xlock(short *lock)
{
	short i = 0x0100;
	__asm__ __volatile__ ("lock ; xaddw %%ax, %1\n\t"
			      "1:\n\t"
			      "cmpb %%ah, %%al\n\t"
			      "je 2f\n\t"
			      "rep ; nop\n\t"
			      "movb %1, %%al\n\t"
			      "lfence\n\t"
			      "jmp 1b\n\t"
			      "2:\n\t"
			    : "+a" (i), "+m" (*lock)
			    : : "memory");
}

static void xunlock(short *lock)
{
	__asm__ __volatile__ ("incb %0\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

#define NR_THREADS 16
#define ITERS (1024*1024)

static int seq;
static int started, finished;

static void *thread(void *arg)
{
	unsigned long nr = (unsigned long)arg;
	int i;
	int oldseq = -1;
	int max_row = 0;
	int row = 0;
	cpu_set_t cpuset;

	CPU_ZERO(&cpuset);
	CPU_SET(nr, &cpuset);
	if (sched_setaffinity(0, sizeof(cpuset), &cpuset) == -1)
		perror("sched_setaffinity"), exit(1);

	lock(&glock);
	started++;
	unlock(&glock);

	for (i = 0; i < ITERS; i++) {
		int tmp;

		lock(&glock);	
		tmp = seq;
		seq++;		
		unlock(&glock);	

		if (started == NR_THREADS && !finished && tmp == oldseq) {
			row++;
			if (row > max_row)
				max_row = row;
		} else
			row = 0;
		oldseq = tmp+1;
	}

	lock(&glock);
	finished++;
	unlock(&glock);

	printf("inc-lock maximum unfair locks = %d\n", max_row);

	return NULL;
}

static void *xthread(void *arg)
{
	unsigned long nr = (unsigned long)arg;
	int i;
	int oldseq = -1;
	int max_row = 0;
	int row = 0;
	cpu_set_t cpuset;

	CPU_ZERO(&cpuset);
	CPU_SET(nr, &cpuset);
	if (sched_setaffinity(0, sizeof(cpuset), &cpuset) == -1)
		perror("sched_setaffinity"), exit(1);

	xlock(&glock);
	started++;
	xunlock(&glock);

	for (i = 0; i < ITERS; i++) {
		int tmp;

		xlock(&glock);	
		tmp = seq;
		seq++;		
		xunlock(&glock);	

		if (started == NR_THREADS && !finished && tmp == oldseq) {
			row++;
			if (row > max_row)
				max_row = row;
		} else {
			row = 0;
		}
		oldseq = tmp+1;
	}

	xlock(&glock);
	finished++;
	xunlock(&glock);

	printf("xadd-lock maximum unfair locks = %d\n", max_row);

	return NULL;
}


int main(void)
{
	struct timeval start, end;
	unsigned long long usec;
	pthread_t t[NR_THREADS];
	int i;

	seq = started = finished = 0;
	glock = LOCK_INIT;
	lock(&glock);
	for (i = 0; i < NR_THREADS; i++) {
		if (pthread_create(&t[i], NULL, thread, (void *)(unsigned long)i) == -1)
			perror("pthread_create"), exit(1);
	}
	usleep(1000000);
	gettimeofday(&start, NULL);
	unlock(&glock);

	for (i = 0; i < NR_THREADS; i++) {
		if (pthread_join(t[i], NULL) == -1)
			perror("pthread_join"), exit(1);
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("inc-lock contended takes %0.2lfns\n", (double)usec * 1000 / ITERS);

	seq = started = finished = 0;
	glock = XLOCK_INIT;
	xlock(&glock);
	for (i = 0; i < NR_THREADS; i++) {
		if (pthread_create(&t[i], NULL, xthread, (void *)(unsigned long)i) == -1)
			perror("pthread_create"), exit(1);
	}
	usleep(1000000);
	gettimeofday(&start, NULL);
	xunlock(&glock);

	for (i = 0; i < NR_THREADS; i++) {
		if (pthread_join(t[i], NULL) == -1)
			perror("pthread_join"), exit(1);
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("xadd-lock contended takes %0.2lfns\n", (double)usec * 1000 / ITERS);

	return 0;
}

--4Ckj6UjgE2iN1+kY--
