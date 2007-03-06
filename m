Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbXCFUUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbXCFUUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166AbXCFUUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:20:45 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:49665 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbXCFUUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:20:44 -0500
Message-ID: <45EDCD11.8070000@cosmosbay.com>
Date: Tue, 06 Mar 2007 21:20:33 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org> <200703061828.00253.dada1@cosmosbay.com> <200703061910.13431.dada1@cosmosbay.com>
In-Reply-To: <200703061910.13431.dada1@cosmosbay.com>
Content-Type: multipart/mixed;
 boundary="------------070102040109030906070503"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 06 Mar 2007 21:20:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070102040109030906070503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Eric Dumazet a écrit :
> On Tuesday 06 March 2007 18:28, Eric Dumazet wrote:
>> On Tuesday 06 March 2007 18:19, Linus Torvalds wrote:
>>
>>>> Using reciprocal divides permits to change each divide by two
>>>> multiplies, less expensive on current CPUS.
>>> Are you sure?
>> I am going to test this, but at least on Opterons, the reciprocal divide I
>> added into mm/slab.c gave me a nice speedup.
>>
> 

Linus,

I did a user space program, attached to this mail.

I rewrote the reciprocal_div() for i386 so that one multiply is used.

static inline u32 reciprocal_divide(u32 A, u32 R)
{
#if __i386
         unsigned int edx, eax;
         asm("mul %2":"=a" (eax), "=d" (edx):"rm" (R), "0" (A));
         return edx;
#else
         return (u32)(((u64)A * R) >> 32);
#endif
}


Results are really good on 32bit. On 64bit/Opteron they are impressive.

$ gcc -O2 -o divide_bench divide_bench.c

First result gives the number of cycles to perform old number() routine using 
plain do_div()
Second result gives the number of cycles using reciprocal_div trick


results on a Intel Pentium III 866 MHz

$ ./divide_bench
413.453 cycles per call, last res=99999901
132.746 cycles per call, last res=99999901
$ ./divide_bench
411.833 cycles per call, last res=99999901
129.652 cycles per call, last res=99999901
$ ./divide_bench
480.645 cycles per call, last res=99999901
158.642 cycles per call, last res=99999901
$ ./divide_bench
412.769 cycles per call, last res=99999901
129.643 cycles per call, last res=99999901
$ ./divide_bench
410.809 cycles per call, last res=99999901
129.609 cycles per call, last res=99999901


results on AMD 246 (2GHz)
Sorry this machine is quite loaded... I dont have a dev x86_64 machine.

$ gcc -O2 -m32 -o divide_bench32 divide_bench.c
$ ./divide_bench32
412.181 cycles per call, last res=99999901
112.314 cycles per call, last res=99999901
$ ./divide_bench32
444.008 cycles per call, last res=99999901
114.314 cycles per call, last res=99999901
$ ./divide_bench32
423.168 cycles per call, last res=99999901
112.318 cycles per call, last res=99999901
$ ./divide_bench32
427.73 cycles per call, last res=99999901
110.712 cycles per call, last res=99999901
$ ./divide_bench32
410.529 cycles per call, last res=99999901
114.068 cycles per call, last res=99999901
$ ./divide_bench32
489.856 cycles per call, last res=99999901
124.889 cycles per call, last res=99999901
$ ./divide_bench32
389.278 cycles per call, last res=99999901
104.697 cycles per call, last res=99999901

With a 64bit prog :
$ gcc -O2 -m64 -o divide_bench64 divide_bench.c
$ ./divide_bench64
826.136 cycles per call, last res=99999901
105.912 cycles per call, last res=99999901
$ ./divide_bench64
627.096 cycles per call, last res=99999901
76.2473 cycles per call, last res=99999901
$ ./divide_bench64
604.524 cycles per call, last res=99999901
76.1405 cycles per call, last res=99999901
$ ./divide_bench64
621.013 cycles per call, last res=99999901
76.0963 cycles per call, last res=99999901
$ ./divide_bench64
836.799 cycles per call, last res=99999901
103.967 cycles per call, last res=99999901
$ ./divide_bench64
982.718 cycles per call, last res=99999901
127.945 cycles per call, last res=99999901
$ ./divide_bench64
609.346 cycles per call, last res=99999901
76.0768 cycles per call, last res=99999901



--------------070102040109030906070503
Content-Type: text/plain;
 name="divide_bench.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="divide_bench.c"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

#ifdef __x86_64

#define rdtscll(val) do { \
     unsigned int __a,__d; \
     asm volatile("rdtsc" : "=a" (__a), "=d" (__d)); \
     (val) = ((unsigned long)__a) | (((unsigned long)__d)<<32); \
} while(0)

# define do_div(n,base) ({					\
	uint32_t __base = (base);				\
	uint32_t __rem;						\
	__rem = ((uint64_t)(n)) % __base;			\
	(n) = ((uint64_t)(n)) / __base;				\
	__rem;							\
 })
#elif  __i386

#define rdtscll(val) \
     __asm__ __volatile__("rdtsc" : "=A" (val))

#define do_div(n,base) ({ \
	unsigned long __upper, __low, __high, __mod, __base; \
	__base = (base); \
	asm("":"=a" (__low), "=d" (__high):"A" (n)); \
	__upper = __high; \
	if (__high) { \
		__upper = __high % (__base); \
		__high = __high / (__base); \
	} \
	asm("divl %2":"=a" (__low), "=d" (__mod):"rm" (__base), "0" (__low), "1" (__upper)); \
	asm("":"=A" (n):"a" (__low),"d" (__high)); \
	__mod; \
})

#endif

static const char digits[] = "0123456789abcdefghijklmnopqrstuvwxyz";

char *number_divides(unsigned long long num, int base, char *result)
{
if (num == 0)
	*result++ = '0';
else while (num) 
	*result++ = digits[do_div(num,base)];
*result = 0;
return result;
}
typedef unsigned int u32;
typedef unsigned long long u64;

#define CONSTANT_RECIPROCAL_VALUE(k) \
	(u32)(((1LL << 32) + (k - 1)) / k)

const u32 reciprocal_values[36 + 1] = {
	0,
	CONSTANT_RECIPROCAL_VALUE(1),	CONSTANT_RECIPROCAL_VALUE(2),
	CONSTANT_RECIPROCAL_VALUE(3),	CONSTANT_RECIPROCAL_VALUE(4),
	CONSTANT_RECIPROCAL_VALUE(5),	CONSTANT_RECIPROCAL_VALUE(6),
	CONSTANT_RECIPROCAL_VALUE(7),	CONSTANT_RECIPROCAL_VALUE(8),
	CONSTANT_RECIPROCAL_VALUE(9),	CONSTANT_RECIPROCAL_VALUE(10),
	CONSTANT_RECIPROCAL_VALUE(11),	CONSTANT_RECIPROCAL_VALUE(12),
	CONSTANT_RECIPROCAL_VALUE(13),	CONSTANT_RECIPROCAL_VALUE(14),
	CONSTANT_RECIPROCAL_VALUE(15),	CONSTANT_RECIPROCAL_VALUE(16),
	CONSTANT_RECIPROCAL_VALUE(17),	CONSTANT_RECIPROCAL_VALUE(18),
	CONSTANT_RECIPROCAL_VALUE(19),	CONSTANT_RECIPROCAL_VALUE(20),
	CONSTANT_RECIPROCAL_VALUE(21),	CONSTANT_RECIPROCAL_VALUE(22),
	CONSTANT_RECIPROCAL_VALUE(23),	CONSTANT_RECIPROCAL_VALUE(24),
	CONSTANT_RECIPROCAL_VALUE(25),	CONSTANT_RECIPROCAL_VALUE(26),
	CONSTANT_RECIPROCAL_VALUE(27),	CONSTANT_RECIPROCAL_VALUE(28),
	CONSTANT_RECIPROCAL_VALUE(29),	CONSTANT_RECIPROCAL_VALUE(30),
	CONSTANT_RECIPROCAL_VALUE(31),	CONSTANT_RECIPROCAL_VALUE(32),
	CONSTANT_RECIPROCAL_VALUE(33),	CONSTANT_RECIPROCAL_VALUE(34),
	CONSTANT_RECIPROCAL_VALUE(35),	CONSTANT_RECIPROCAL_VALUE(36)
};

static inline u32 reciprocal_divide(u32 A, u32 R)
{
#if __i386
	unsigned int edx, eax;
	asm("mul %2":"=a" (eax), "=d" (edx):"rm" (R), "0" (A));
	return edx;
#else
	return (u32)(((u64)A * R) >> 32);
#endif
}

char *number_reciprocal(unsigned long long num, int base, char *result)
{
if (num == 0)
	*result++ = '0';
else {
	while (num >>32)
		*result++ = digits[do_div(num,base)];
	while (num) {
		u32 next = reciprocal_divide((u32)num,
				reciprocal_values[base]);
			*result++ = digits[num - next*base];
			num = next;

		}
	}
*result = 0;
return result;
}

#define START 10000000
int base = 10;
main()
{
unsigned long long start, end;
char result[64];
unsigned long ul;
	rdtscll(start);
	for (ul = START; ul < START + 1000000;ul++)
		number_divides(ul, base, result);
	rdtscll(end);
printf("%g cycles per call, last res=%s\n", (double)(end - start)/1000000.0, result);
	rdtscll(start);
	for (ul = START; ul < START + 1000000;ul++)
		number_reciprocal(ul, base, result);
	rdtscll(end);
printf("%g cycles per call, last res=%s\n", (double)(end - start)/1000000.0, result);
}

--------------070102040109030906070503--
