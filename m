Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbXGITBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbXGITBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbXGITBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:01:15 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4372 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbXGITBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:01:14 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 9 Jul 2007 12:01:12 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nick Piggin <npiggin@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
In-Reply-To: <20070708043228.GB22397@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0707091140440.15898@alien.or.mcafeemobile.com>
References: <20070708043228.GB22397@wotan.suse.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Nick Piggin wrote:

> I made some tests of the queued spinlock code using userspace test code on
> 64-bit processors. I believe the xadd based code no longer has any theoretical
> memory ordering problems.
> 
> The tests were done on 3 different architectures of different speeds and
> vintages (so not really comparable between columns). I have attached the two
> programs I used to make the results. Times are total elapsed time divided by
> the number of locks (so effectively you get the time required for lock+unlock).
> 
> The threaded results also attempt to have an unfairness count, which is the
> max number of times in a row that a lock is acquired,  when all other threads
> are also executing in the loop -- the reason xadd for example is not always
> 0 there is because the other threads may not have reached the lock before
> the current thread was able to get it several times (eg. if an interrupt
> comes in, this could happen).

I was trying to look how costly is having a double-short counter, instead 
of a single byte.
The V-lock uses two short counters w/out the double-xadd optimization, 
while the Z-lock uses it.
This is a dual Opteron 252, but the test is done in single thread only 
(multi-thread really has no meaning for this test):

inc-lock in cache takes 7.28ns
xadd-lock in cache takes 8.93ns
vadd-lock in cache takes 10.35ns
zadd-lock in cache takes 8.43ns
inc-lock out of cache takes 87.85ns
xadd-lock out of cache takes 88.15ns
vadd-lock out of cache takes 89.38ns
zadd-lock out of cache takes 88.10ns

In this box, the always-lfence V-lock code pays for it. If I remove the 
lfence from the V-lock (but that's not possible), I get:

inc-lock in cache takes 7.28ns
xadd-lock in cache takes 8.93ns
vadd-lock in cache takes 7.67ns
zadd-lock in cache takes 8.44ns
inc-lock out of cache takes 87.87ns
xadd-lock out of cache takes 88.15ns
vadd-lock out of cache takes 88.24ns
zadd-lock out of cache takes 88.12ns

So in this box, and in this test, the double-short Z-lock seems faster 
than a double-byte. I've no idea why, since it uses two ops more and an 
extra register.




- Davide



#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

struct page {
	short lock[2];
	unsigned int next;
};
#define NR_PAGES (2*1024*1024)
static struct page pages[NR_PAGES];

#define LOCK_INIT(l) (l)[0] = 1
static inline void lock(short *lock)
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

static inline void unlock(short *lock)
{
	__asm__ __volatile__ ("movb $1,%0\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

#define XLOCK_INIT(l) (l)[0] = 0
static inline void xlock(short *lock)
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

static inline void xunlock(short *lock)
{
	__asm__ __volatile__ ("incb %0\n\t"
			    : "+m" (*lock)
			    : : "memory");
}

#define VLOCK_INIT(l) (l)[0] = 0, (l)[1] = 0
static inline void vlock(short *lock)
{
	__asm__ __volatile__ ("lock ; xaddw %%ax, %0\n\t"
			      "1:\n\t"
			      "cmpw %%ax, %1\n\t"
			      "je 2f\n\t"
			      "rep ; nop\n\t"
			      "jmp 1b\n\t"
			      "2:\n\t"
			      "lfence\n\t"
			    : "+m" (lock[1])
			    : "m" (lock[0]), "a" (1) : "memory");
}

static inline void vunlock(short *lock)
{
	__asm__ __volatile__ ("incw %0\n\t"
			    : "+m" (lock[0])
			    : : "memory");
}

#define ZLOCK_INIT(l) (l)[0] = 0, (l)[1] = 0
static inline void zlock(short *lock)
{
	__asm__ __volatile__ ("lock ; xaddl %%eax, %0\n\t"
			      "mov %%eax, %%ebx\n\t"
			      "shr $16, %%ebx\n\t"
			      "1:\n\t"
			      "cmpw %%ax, %%bx\n\t"
			      "je 2f\n\t"
			      "rep ; nop\n\t"
			      "movw %1, %%bx\n\t"
			      "lfence\n\t"
			      "jmp 1b\n\t"
			      "2:\n\t"
			    : "+m" (*(int *) lock)
			    : "m" (lock[0]), "a" (0x10000) : "ebx", "memory");
}

static inline void zunlock(short *lock)
{
	__asm__ __volatile__ ("incw %0\n\t"
			    : "+m" (lock[0])
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
		LOCK_INIT(pages[i].lock);
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < IN_ITERS; i++) {
		lock(&p->lock[0]);
		tmp = p->next;
		unlock(&p->lock[0]);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("inc-lock in cache takes %0.2lfns\n", (double)usec * 1000 / IN_ITERS);

	for (i = 0; i < NR_PAGES; i++)
		XLOCK_INIT(pages[i].lock);
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < IN_ITERS; i++) {
		xlock(&p->lock[0]);
		tmp = p->next;
		xunlock(&p->lock[0]);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("xadd-lock in cache takes %0.2lfns\n", (double)usec * 1000 / IN_ITERS);

	for (i = 0; i < NR_PAGES; i++)
		VLOCK_INIT(pages[i].lock);
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < IN_ITERS; i++) {
		vlock(&p->lock[0]);
		tmp = p->next;
		vunlock(&p->lock[0]);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("vadd-lock in cache takes %0.2lfns\n", (double)usec * 1000 / IN_ITERS);

	for (i = 0; i < NR_PAGES; i++)
		ZLOCK_INIT(pages[i].lock);
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < IN_ITERS; i++) {
		zlock(&p->lock[0]);
		tmp = p->next;
		zunlock(&p->lock[0]);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("zadd-lock in cache takes %0.2lfns\n", (double)usec * 1000 / IN_ITERS);
	
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
		LOCK_INIT(pages[i].lock);
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < ITERS; i++) {
		lock(&p->lock[0]);
		tmp = p->next;
		unlock(&p->lock[0]);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("inc-lock out of cache takes %0.2lfns\n", (double)usec * 1000 / ITERS);


	for (i = 0; i < NR_PAGES; i++)
		XLOCK_INIT(pages[i].lock);
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < ITERS; i++) {
		xlock(&p->lock[0]);
		tmp = p->next;
		xunlock(&p->lock[0]);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("xadd-lock out of cache takes %0.2lfns\n", (double)usec * 1000 / ITERS);

	for (i = 0; i < NR_PAGES; i++)
		VLOCK_INIT(pages[i].lock);
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < ITERS; i++) {
		vlock(&p->lock[0]);
		tmp = p->next;
		vunlock(&p->lock[0]);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("vadd-lock out of cache takes %0.2lfns\n", (double)usec * 1000 / ITERS);

	for (i = 0; i < NR_PAGES; i++)
		ZLOCK_INIT(pages[i].lock);
	gettimeofday(&start, NULL);
	p = &pages[0];
	for (i = 0; i < ITERS; i++) {
		zlock(&p->lock[0]);
		tmp = p->next;
		zunlock(&p->lock[0]);
		p = &pages[tmp];
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("zadd-lock out of cache takes %0.2lfns\n", (double)usec * 1000 / ITERS);

	return 0;
}

