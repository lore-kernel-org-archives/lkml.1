Return-Path: <linux-kernel-owner+w=401wt.eu-S1761218AbYDRUUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761218AbYDRUUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYDRUTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:19:53 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:27852 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYDRUTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:19:52 -0400
Date: Fri, 18 Apr 2008 22:18:09 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: dean gaudet <dean@arctic.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Alternative implementation of the generic __ffs
Message-ID: <20080418201809.GA5036@mailshack.com>
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com> <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org> <1207507897.18129.1246358115@webmail.messagingengine.com> <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org> <1207563950.7880.1246457209@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207563950.7880.1246457209@webmail.messagingengine.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Fri, 18 Apr 2008 22:19:31 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.8; VDF: 7.0.3.188; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 12:25:50PM +0200, Alexander van Heukelum wrote:
> On Sun, 6 Apr 2008 13:22:58 -0700 (PDT), "dean gaudet" <dean@arctic.org> said:
> > On Sun, 6 Apr 2008, Alexander van Heukelum wrote:
> > > The current generic implementation of ffz is O(lg(n)) already
> > 
> > it's O(lg(n)) time... the operations all depend on each other.
> > 
> > the implementation i pointed to is O(lg(n)) code space... and the time 
> > depends on how parallel the machine is, they're not dependent on each 
> > other.
> 
> Indeed. The worst dependencies are in the sum of all the partial
> results in this implementation. And addition is associative, so
> partial results can be written as ((a+b)+(c+d))+(e+f). Assuming
> perfect parallel execution this would lead to O(ln(ln(n))). Good.

Hello all,

I've implemented ffs (find first set bit) like it is shown
in http://www.hackersdelight.org/ (see revisions, page 21).
I would be interested to see how it compares with the generic
implementation of __ffs in the linux kernel, in particular
on architectures that do not have an obvious fast way of
determining the first set bit of a word.

I have included a simple benchmark program that should give
a reasonable estimate of the performance ratio of the two
implementations. Please test and report :).

Is this implementation suitable to replace the current one?

Greetings,
	Alexander

P.S. Some results for some machines I could test on:

-----------

On a 2.1 GHz Athlon XP:
$ gcc -m32 -Os -fomit-frame-pointer ffs.c && time ./a.out
Original:        396 tics,   756 tics
New:             378 tics,   851 tics
Assembly:        262 tics,   383 tics
Empty loop:      128 tics,   203 tics

real    0m33.862s
user    0m33.026s
sys     0m0.344s

-----------

On a 2.33 GHz Xeon:
$ gcc -m64 -Os ffs.c && time ./a.out 
Original:        277 tics,   324 tics
New:             230 tics,   236 tics
Assembly:         90 tics,    84 tics
Empty loop:       90 tics,    82 tics

real    0m14.490s
user    0m14.270s
sys     0m0.220s
$ gcc -m32 -Os -fomit-frame-pointer ffs.c && time ./a.out
Original:        303 tics,   449 tics
New:             231 tics,   394 tics
Assembly:         90 tics,   144 tics
Empty loop:      102 tics,   116 tics

real    0m18.521s
user    0m18.380s
sys     0m0.140s

-----------

On an alpha EV6.7 (21264A) operating at 667 MHz:
$ gcc -Os ffs.c && time ./a.out
Original:        622 tics,   633 tics
New:             431 tics,   465 tics
Assembly:        235 tics,   210 tics
Empty loop:      199 tics,   218 tics
50.358u 0.259s 1:14.28 68.1%    0+1k 2+0io 2pf+0w

-----------

#include <stdio.h>
#include <sys/times.h>

#define LOOPS32 (1<<(30-5-1))
#define LOOPS64 (1<<(30-6-1))
#define ATTR __attribute__((noinline))

static ATTR int __ffs32_orig(unsigned int word)
{
	int num = 0;

	if ((word & 0xffff) == 0) {
		num += 16;
		word >>= 16;
	}
	if ((word & 0xff) == 0) {
		num += 8;
		word >>= 8;
	}
	if ((word & 0xf) == 0) {
		num += 4;
		word >>= 4;
	}
	if ((word & 0x3) == 0) {
		num += 2;
		word >>= 2;
	}
	if ((word & 0x1) == 0)
		num += 1;

	return num;
}

static ATTR int __ffs64_orig(unsigned long long word)
{
	int num = 0;

	if ((word & 0xffffffff) == 0) {
		num += 32;
		word >>= 32;
	}
	if ((word & 0xffff) == 0) {
		num += 16;
		word >>= 16;
	}
	if ((word & 0xff) == 0) {
		num += 8;
		word >>= 8;
	}
	if ((word & 0xf) == 0) {
		num += 4;
		word >>= 4;
	}
	if ((word & 0x3) == 0) {
		num += 2;
		word >>= 2;
	}
	if ((word & 0x1) == 0)
		num += 1;

	return num;
}

static ATTR int __ffs32_new(unsigned int value)
{
	int x0, x1, x2, x3, x4;

	value &= -value;
	x0 = (value & 0x55555555) ? 0 : 1;
	x1 = (value & 0x33333333) ? 0 : 2;
	x2 = (value & 0x0f0f0f0f) ? 0 : 4;
	x3 = (value & 0x00ff00ff) ? 0 : 8;
	x4 = (value & 0x0000ffff) ? 0 : 16;

	return x0 | x1 | x2 | x3 | x4;
}

static ATTR int __ffs64_new(unsigned long long value)
{
	int x0, x1, x2, x3, x4, x5;

	value &= -value;
	x0 = (value & 0x5555555555555555ull) ? 0 : 1;
	x1 = (value & 0x3333333333333333ull) ? 0 : 2;
	x2 = (value & 0x0f0f0f0f0f0f0f0full) ? 0 : 4;
	x3 = (value & 0x00ff00ff00ff00ffull) ? 0 : 8;
	x4 = (value & 0x0000ffff0000ffffull) ? 0 : 16;
	x5 = (value & 0x00000000ffffffffull) ? 0 : 32;

	return x0 | x1 | x2 | x3 | x4 | x5;
}

#ifdef __x86_64__
#define ASSEMBLYVERSION
static ATTR int __ffs32_asm(unsigned int value)
{
	int res;

	asm volatile("bsf %[value], %[res]"
		: [res] "=r" (res)
		: [value] "r" (value)
	);	

	return res;
}

static ATTR int __ffs64_asm(unsigned long long value)
{
	long res;

	asm volatile("bsf %[value], %[res]"
		: [res] "=r" (res)
		: [value] "r" (value)
	);	

	return res;
}
#endif

#ifdef __i386__
#define ASSEMBLYVERSION
static ATTR int __ffs32_asm(unsigned int value)
{
	int res;

	asm volatile("bsf %[value], %[res]"
		: [res] "=r" (res)
		: [value] "r" (value)
	);	

	return res;
}

static ATTR int __ffs64_asm(unsigned long long value)
{
	unsigned int low, high;
	int res;

	low = value;
	if (low) {
		asm volatile("bsf %[value], %[res]"
			: [res] "=r" (res)
			: [value] "r" (low)
		);
		return res;
	}

	high = value >> 32;
	asm volatile("bsf %[value], %[res]"
		: [res] "=r" (res)
		: [value] "r" (high)
	);

	return res | 32;
}
#endif

#ifdef __alpha__
#define ASSEMBLYVERSION
static ATTR int __ffs32_asm(unsigned int value)
{
	int res;

	asm volatile("cttz %[value], %[res]"
		: [res] "=r" (res)
		: [value] "r" (value)
	);	

	return res;
}

static ATTR int __ffs64_asm(unsigned long long value)
{
	long res;

	asm volatile("cttz %[value], %[res]"
		: [res] "=r" (res)
		: [value] "r" (value)
	);	

	return res;
}
#endif

static ATTR int __nothing32(unsigned int value)
{
	return value;
}

static ATTR int __nothing64(unsigned long long value)
{
	return (int)value;
}

/* Random numbers: modified version of libc mrand48 */
static unsigned long long myrand_next = 0x330eull;
static const unsigned long long myrand_a = 0x5deece66dull;
static const unsigned long long myrand_b = 0xbull;
unsigned int myrand(void)
{
	myrand_next = myrand_a * myrand_next + myrand_b;
	return (unsigned int)(myrand_next >> 16);
}

unsigned long long myrand64(void)
{
	return ((unsigned long long)myrand() << 32) | myrand();
}

void myrand_seed(unsigned int seed)
{
	int n;
	myrand_next = ((unsigned long long)seed << 16) + 0x330eull;
	for (n=0; n<100; n++) myrand(); /* warm it up a bit */
}

/* tic: wait for next clock tick and save current tick */
clock_t tictime;
void tic(void)
{
	struct tms t;
	times(&t);
	tictime = t.tms_utime;
	do {
		times(&t);
	} while (tictime == t.tms_utime);
	tictime = t.tms_utime;
}

/* toc: report number of ticks since tic() */
long toc(void)
{
	struct tms t;
	times(&t);
	return (long)(t.tms_utime - tictime);
}

__attribute__((noinline))
int bench_orig32(void)
{
	unsigned int i;
	int n, res = 0;

	myrand_seed(0);
	for (n=0; n<LOOPS32; n++) {
		i = myrand();
		while (i) {
			res ^= __ffs32_orig(i);
			i &= i - 1;	
		}	
	}
	return res;
}

__attribute__((noinline))
int bench_orig64(void)
{
	unsigned long long i;
	int n, res = 0;

	myrand_seed(0);
	for (n=0; n<LOOPS64; n++) {
		i = myrand64();
		while (i) {
			res ^= __ffs64_orig(i);
			i &= i - 1;	
		}	
	}
	return res;
}

__attribute__((noinline))
int bench_new32(void)
{
	unsigned int i;
	int n, res = 0;

	myrand_seed(0);
	for (n=0; n<LOOPS32; n++) {
		i = myrand();
		while (i) {
			res ^= __ffs32_new(i);
			i &= i - 1;	
		}	
	}
	return res;
}

__attribute__((noinline))
int bench_new64(void)
{
	unsigned long long i;
	int n, res = 0;

	myrand_seed(0);
	for (n=0; n<LOOPS64; n++) {
		i = myrand64();
		while (i) {
			res ^= __ffs64_new(i);
			i &= i - 1;	
		}	
	}
	return res;
}

#ifdef ASSEMBLYVERSION
__attribute__((noinline))
int bench_asm32(void)
{
	unsigned int i;
	int n, res = 0;

	myrand_seed(0);
	for (n=0; n<LOOPS32; n++) {
		i = myrand();
		while (i) {
			res ^= __ffs32_asm(i);
			i &= i - 1;	
		}	
	}
	return res;
}

__attribute__((noinline))
int bench_asm64(void)
{
	unsigned long long i;
	int n, res = 0;

	myrand_seed(0);
	for (n=0; n<LOOPS64; n++) {
		i = myrand64();
		while (i) {
			res ^= __ffs64_asm(i);
			i &= i - 1;	
		}	
	}
	return res;
}
#endif

__attribute__((noinline))
int bench_none32(void)
{
	unsigned int i;
	int n, res = 0;

	myrand_seed(0);
	for (n=0; n<LOOPS32; n++) {
		i = myrand();
		while (i) {
			res ^= __nothing32(i);
			i &= i - 1;	
		}	
	}
	return res;
}

__attribute__((noinline))
int bench_none64(void)
{
	unsigned long long i;
	int n, res = 0;

	myrand_seed(0);
	for (n=0; n<LOOPS64; n++) {
		i = myrand64();
		while (i) {
			res ^= __nothing64(i);
			i &= i - 1;
		}	
	}
	return res;
}

void test(void)
{
	unsigned long long int i;
	int n, res1, res2;

	myrand_seed(0);

	for (n=0; n<1000; n++) {
		i = myrand64();
		while (i) {
			res1 = __ffs64_orig(i);
			res2 = __ffs64_new(i);
			if (res1 != res2) {
				printf("%llu %i %i\n", i,
						res1, res2);
			}
			i &= i - 1;
		}
	}
}

int main(void)
{
	long tics;

	setvbuf(stdout, NULL, _IONBF, 0);
	test();

	printf("%-14s", "Original:");
	tic(); bench_orig32(); tics = toc();
	printf("%6lu tics,", tics);
	tic(); bench_orig64(); tics = toc();
	printf("%6lu tics\n", tics);

	printf("%-14s", "New:");
	tic(); bench_new32(); tics = toc();
	printf("%6lu tics,", tics);
	tic(); bench_new64(); tics = toc();
	printf("%6lu tics\n", tics);

#ifdef ASSEMBLYVERSION
	printf("%-14s", "Assembly:");
	tic(); bench_asm32(); tics = toc();
	printf("%6lu tics,", tics);
	tic(); bench_asm64(); tics = toc();
	printf("%6lu tics\n", tics);
#endif

	printf("%-14s", "Empty loop:");
	tic(); bench_none32(); tics = toc();
	printf("%6lu tics,", tics);
	tic(); bench_none64(); tics = toc();
	printf("%6lu tics\n", tics);

	return 0;
}
