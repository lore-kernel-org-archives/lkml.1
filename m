Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbZLMKhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbZLMKhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 05:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZLMKhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 05:37:39 -0500
Received: from www84.your-server.de ([213.133.104.84]:54163 "HELO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752059AbZLMKhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 05:37:37 -0500
Subject: [PATCH 0/1] RFC: new kqueue API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 13 Dec 2009 11:37:13 +0100
Message-ID: <1260700633.17424.18.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As i figured out during the port the old kfifo API users, most of them
did not need a streamed fifo, because there work only with fixed size
entries. The kfifo is oversized for this kind of users, so i decided to
write a new kqueue API which is optimized for fixed size entries. 

There are a some benefits:

- Performance (a put or get of an integer does only generate 4 assembly
instructions on a x86) 
- Type save
- Cleaner interface
- Easier to use
- Less error prone
- Smaller footprint

The API is similar to the new kfifo API, but there is no need for a
length paramter, because the size of the entry is know by the queue
structure.

Here is a small user land example how to use it:

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stddef.h>

#ifndef __KERNEL__
#define	EXPORT_SYMBOL(x)
#define	unlikely(x)	x
#define	likely(x)	x
#define __must_check
#define __user
#define	spinlock_t		void
#define	gfp_t			unsigned long
#define	spin_lock_irqsave(a,b)
#define	spin_unlock_irqsave(a,b)
#define	BUG_ON(x)
#define	is_power_of_2(x)	1
#define	roundup_pow_of_two(x)	(x)
#define	kmalloc(a,b)		malloc(a)
#define	kfree(a)		free(a)
#define	BUG()

#define barrier() __asm__ __volatile__("": : :"memory")


#define mb() 	asm volatile("mfence":::"memory")
#define rmb()	asm volatile("lfence":::"memory")
#define wmb()	asm volatile("sfence" ::: "memory")

#define smp_mb()	mb()
#define smp_rmb()	rmb()
#define smp_wmb() 	wmb()

#define min(X,Y) (((X) < (Y)) ? (X) : (Y))
#define ARRAY_SIZE(x)	(sizeof(x)/sizeof(*x))

struct scatterlist {
	unsigned long	page_link;
	unsigned int	offset;
	unsigned int	length;
};

static inline void sg_mark_end(struct scatterlist *sg)
{
	sg->page_link |= 0x02;
	sg->page_link &= ~0x01;
}

static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
			      unsigned int buflen)
{
}

static unsigned long copy_to_user(void * to, const void * from, unsigned long n)
{
	memcpy(to, from, n);
	return 0;
}

static unsigned long copy_from_user(void * to, const void * from, unsigned long n)
{
	memcpy(to, from, n);
	return 0;
}
#endif

/* --------------------------> test program */

#include "kqueue.h"
#include "kqueue.c"

//#define	DYNAMIC

#ifdef DYNAMIC
static DECLARE_KQUEUE(*test, int, 32);
#else
typedef STRUCT_KQUEUE(int, 32) mytest;

static mytest testx;
static mytest *test = &testx;
#endif

int main(void)
{
	unsigned int	i;
	char	buf[6];
	int	ret;

#ifdef DYNAMIC
	if (kqueue_alloc(&test, 64, 0)) {
		fprintf(stderr,"error kqueue_alloc\n");
		return 1;
	}
#else
	INIT_KQUEUE(testx);
#endif

	for(i=0; i != 10; i++) {
		kqueue_in(test, i);
	}

	while(!kqueue_is_empty(test)) {
		i = kqueue_out(test);
		printf("%d:\n", i);
	}

	for(i=0; i!=9; i++) {
		kqueue_in(test, i);
	}

	ret = kqueue_to_user(test, buf, sizeof(buf));
	printf("-ret: %d \n", ret);
	ret = kqueue_from_user(test, buf, sizeof(buf));
	printf("-ret: %d \n", ret);
	ret = kqueue_to_user(test, buf, sizeof(buf));
	printf("-ret: %d \n", ret);
	ret = kqueue_from_user(test, buf, sizeof(buf));
	printf("-ret: %d \n", ret);

	while(!kqueue_is_empty(test)) {
		i = kqueue_out(test);
		printf("%d:\n", i);
	}

	i=0;


	while(!kqueue_is_full(test)) {
		++i;

		kqueue_in(test, i);
		printf("%u ", kqueue_len(test));
	}
	printf("\n");

	while(!kqueue_is_empty(test))
		printf("%d ", kqueue_out(test));

	printf("\n");

	return 0;
}

I hope you like it. If yes, i will start to port the kfifo fixed size
users to the new API.

Stefani


