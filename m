Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbXGMNWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbXGMNWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758890AbXGMNVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:21:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:51966 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181AbXGMNVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Bd0vqWs2iJRWfYMjl+lptNFhpLXNHIeZ3edjLMT77Poo0MKbqt66k4ZT7KCXaIoTzsng7Qb8iKYUKHlo4CgHufQTDyD722qpzY8PCAbf6euArwuPMhU7fioqTatSRNkOj7j+VqXXfGoDdZYtR1f5zEUH3wpyvwX+qQIAtxJ8nSc=
Message-ID: <84144f020707130621g1d3618e0r85545f3aa26c7466@mail.gmail.com>
Date: Fri, 13 Jul 2007 16:21:30 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Kirill Korotaev" <dev@sw.ru>
Subject: Re: [PATCH] replace kmem_cache_alloc with kmem_cache_zalloc to remove some following zero initializations.
Cc: "rae l" <crquan@gmail.com>, trivial@kernel.org, Denis <cr_quan@163.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46974193.2020302@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184290905.5475.5.camel@tux.homenetwork> <4697357A.10605@sw.ru>
	 <91b13c310707130138p6cffd0b4va34eec320d66ab44@mail.gmail.com>
	 <46974193.2020302@sw.ru>
X-Google-Sender-Auth: e66ddfd5373c32d7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On 7/13/07, Kirill Korotaev <dev@sw.ru> wrote:
> Look, until you have any numbers in hands it's impossible to say
> which one is faster.

Well, it's not too hard to guess: struct dentry is 124 bytes on i386
so kmem_cache_zalloc over it is bound to be slower tha
kmem_cache_alloc as most members are initialized to non-NULL. And if
you're into micro-benchmarks, here's one:

d_alloc takes 182.75ns
d_alloc_zalloc takes 315.89ns

So definitely NAK for Denis' patch.

                                               Pekka

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <time.h>

struct dentry {
	void *a;
	void *b;
	void *c;
	void *d;
	void *e;
	void *f;
	void *g;
	void *h;
	unsigned char d_iname[36];
};

#define NR_ITERS 1000000

#define MAX_DENTRIES (NR_ITERS*2)

static unsigned long offset;
static struct dentry dentries[MAX_DENTRIES];

static inline void *__kmalloc(void)
{
	void *p = &dentries[offset++];
	if (offset == MAX_DENTRIES)
		offset = 0;
	return p;
}

void *kmalloc(size_t sz)
{
	return __kmalloc();
}

struct dentry *d_alloc(const char *name)
{
	struct dentry *ret = kmalloc(sizeof *ret);
	if (ret) {
		ret->a = NULL;
		ret->b = NULL;
		ret->c = NULL;
		ret->d = NULL;
		ret->e = (void *) 0xdeadbeef;
		ret->f = (void *) 0xdeadbeef;
		ret->g = (void *) 0xdeadbeef;
		ret->h = (void *) 0xdeadbeef;
		strcpy(ret->d_iname, name);
	}
	return ret;
}

static inline void * __memset_generic(void * s, char c,size_t count)
{
	int d0, d1;
	__asm__ __volatile__(
	        "rep\n\t"
	        "stosb"
	        : "=&c" (d0), "=&D" (d1)
	        :"a" (c),"1" (s),"0" (count)
	        :"memory");
	return s;
}

void *kzalloc(size_t sz)
{
	void *p = __kmalloc();
	if (p)
		__memset_generic(p, 0, sz);
	return p;
}

struct dentry *d_alloc_zalloc(const char *name)
{
	struct dentry *ret = kzalloc(sizeof *ret);
	if (ret) {
		ret->e = (void *) 0xdeadbeef;
		ret->f = (void *) 0xdeadbeef;
		ret->g = (void *) 0xdeadbeef;
		ret->h = (void *) 0xdeadbeef;
		strcpy(ret->d_iname, name);
	}
	return ret;
}

int main(int argc, char *argv[])
{
	struct timeval start, end;
	unsigned long long usec;
	int i;

	gettimeofday(&start, NULL);
	for (i = 0; i < NR_ITERS; i++) {
		struct dentry *dentry = d_alloc("root");

		if (!dentry || dentry->a != NULL)
			abort();
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("d_alloc takes %0.2lfns\n", (double)usec * 1000 / NR_ITERS);

	gettimeofday(&start, NULL);
	for (i = 0; i < NR_ITERS; i++) {
		struct dentry *dentry = d_alloc_zalloc("root");

		if (!dentry || dentry->a != NULL)
			abort();
	}
	gettimeofday(&end, NULL);
	usec = end.tv_usec + 1000000*(end.tv_sec - start.tv_sec) - start.tv_usec;
	printf("d_alloc_zalloc takes %0.2lfns\n", (double)usec * 1000 / NR_ITERS);

	return 0;
}
