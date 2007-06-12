Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbXFLFF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbXFLFF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbXFLFFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:05:46 -0400
Received: from science.horizon.com ([192.35.100.1]:15766 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751591AbXFLFFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:05:45 -0400
Date: 12 Jun 2007 01:05:44 -0400
Message-ID: <20070612050544.23957.qmail@science.horizon.com>
From: linux@horizon.com
To: bgilbert@cs.cmu.edu, linux@horizon.com
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <466D9FDB.2010305@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I got this code from Nettle, originally, and I never looked at the SHA-1 
> round structure very closely.  I'll give that approach a try.

Attached is some (tested, working, and public domain) assembly code for
three different sha_transform implementations.  Compared to C code, the
timings to hash 10 MiB on a 600 MHz PIII are:

  One: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 564819 us
 Four: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 391086 us
  Two: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 399134 us
Three: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 345986 us
 Five: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 301152 us

  One: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 558652 us
 Four: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 390980 us
  Two: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 407661 us
Three: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 412434 us
 Five: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 266809 us

  One: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 559053 us
 Four: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 396506 us
  Two: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 401661 us
Three: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 349668 us
 Five: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 265861 us

  One: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 556082 us
 Four: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 392967 us
  Two: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 406381 us
Three: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 338959 us
 Five: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 274712 us

Um.. some more runs, nice --19, that come out a bit more stable:
  One: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 552971 us
 Four: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 388167 us
  Two: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 398721 us
Three: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 337220 us
 Five: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 259790 us

  One: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 551240 us
 Four: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 387812 us
  Two: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 398519 us
Three: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 336903 us
 Five: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 260161 us

  One: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 551934 us
 Four: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 387639 us
  Two: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 398094 us
Three: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 335860 us
 Five: e02e77e3 bb7af36d bbf79d4a 46956044 2aaea172 -- 259805 us

This is hot-cache testing; I haven't got around to writing macro
tricks that exapnd to a megabyte of object code.  The challenge is to
purge not only the I- and D-caches, but also the branch predictor!


The names are the order they were written in.  "One" is the lib/sha1.c
code (547 bytes with -Os).  "Four" is a 5x unrolled C version (1106 bytes).

"Two" is a space-optimized ASM version, 266 bytes long.  "Three" is 5x
unrolled, 722 bytes long.  "Five" is a fully unrolled version, 3558
bytes long.

(Further space savings are possible, but it doesn't seem worth it.)

I have noticed that every caller of sha_transform in the kernel tree
allocates the W[] array on the stack, so we might as well do that inside
sha_transform.  The point of passing in the buffer is to amortize the
wiping afterwards, but see sha_stackwipe for ideas on how to do that.
(It can even be done mostly portably in C, given a good guess about the
C function's stack usage.)


I also noticed a glaring BUG in the folding at the end of extract_buf at
drivers/char/random.c:797.  That should be:

	/*
	 * In case the hash function has some recognizable
	 * output pattern, we fold it in half.
	 */

	buf[0] ^= buf[4];
	buf[1] ^= buf[3];
	buf[2] ^= rol32(buf[2], 16);	// <--- Bug was here
	memcpy(out, buf, EXTRACT_SIZE);
	memset(buf, 0, sizeof(buf));

if the code is to match the comment.



=== sha1asm.S ===
#define A %eax
#define B %ebx
#define C %ecx
#define D %edx
#define E %ebp
#define I %esi
#define T %edi

# f1(x,y,z) = bitwise x ? y : z = (z ^ (x & (y ^ z)))
#define F1(x,y,z,dest)	\
	movl	z,T;	\
	xorl	y,T;	\
	andl	x,T;	\
	xorl	z,T

# f2(x,y,z) = x ^ y ^ z
#define F2(x,y,z,dest)	\
	movl	z,T;	\
	xorl	x,T;	\
	xorl	y,T

# f3(x,y,z) = majority(x,y,z) = ((x & z) + (y & (x ^ z)))
#define F3(x,y,z,dest)	\
	movl	z,T;	\
	andl	x,T;	\
	addl	T,dest; \
	movl	z,T;	\
	xorl	x,T;	\
	andl	y,T

#define K1  0x5A827999			/* Rounds  0-19: sqrt(2) * 2^30 */
#define K2  0x6ED9EBA1			/* Rounds 20-39: sqrt(3) * 2^30 */
#define K3  0x8F1BBCDC			/* Rounds 40-59: sqrt(5) * 2^30 */
#define K4  0xCA62C1D6			/* Rounds 60-79: sqrt(10) * 2^30 */

# e += W[i] + K + f(b, c, d) + rol32(a, 5); b = rol32(b, 30); i++;
#define ROUND(a,b,c,d,e,f,k)	\
	addl (%esp,I,4),e;	\
	incl I;			\
	f(b,c,d,e);		\
	leal k(T,e),e;		\
	movl a,T;		\
	roll $5,T;		\
	rorl $2,b;		\
	addl T,e

	.text
.globl sha_transform3
	.type	sha_transform3, @function
# void sha_transform3(__u32 digest[5], const char in[64])
sha_transform3:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
# Args start at 20(%esp)
	xorl	I,I
	movl	24(%esp),B	# B = in
	movl	20(%esp),T	# T = digest
	subl	$320,%esp
1:
	movl	(B,I,4),A
	bswap	A
	movl	A,(%esp,I,4)
	incl	I
	cmpl	$16,I
	jne	1b

2:
	movl	-64(%esp,I,4),A
	xorl	-56(%esp,I,4),A
	xorl	-32(%esp,I,4),A
	xorl	-12(%esp,I,4),A
	roll	$1,A
	movl	A,(%esp,I,4)
	incl	I
	cmpl	$80,I
	jne	2b

	movl	(T),A
	movl	4(T),B
	movl	8(T),C
	movl	12(T),D
	movl	16(T),E

	xorl	I,I
3:
	ROUND(A,B,C,D,E,F1,K1)
	ROUND(E,A,B,C,D,F1,K1)
	ROUND(D,E,A,B,C,F1,K1)
	ROUND(C,D,E,A,B,F1,K1)
	ROUND(B,C,D,E,A,F1,K1)
	cmp	$20,I
	jne	3b
4:
	ROUND(A,B,C,D,E,F2,K2)
	ROUND(E,A,B,C,D,F2,K2)
	ROUND(D,E,A,B,C,F2,K2)
	ROUND(C,D,E,A,B,F2,K2)
	ROUND(B,C,D,E,A,F2,K2)
	cmp	$40,I
	jne	4b
5:
	ROUND(A,B,C,D,E,F3,K3)
	ROUND(E,A,B,C,D,F3,K3)
	ROUND(D,E,A,B,C,F3,K3)
	ROUND(C,D,E,A,B,F3,K3)
	ROUND(B,C,D,E,A,F3,K3)
	cmp	$60,I
	jne	5b
6:
	ROUND(A,B,C,D,E,F2,K4)
	ROUND(E,A,B,C,D,F2,K4)
	ROUND(D,E,A,B,C,F2,K4)
	ROUND(C,D,E,A,B,F2,K4)
	ROUND(B,C,D,E,A,F2,K4)
	cmp	$80,I
	jne	6b

	addl	$320,%esp
	movl	20(%esp),T

	addl	A,(T)
	addl	B,4(T)
	addl	C,8(T)
	addl	D,12(T)
	addl	E,16(T)

	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp

	ret
	.size	sha_transform3, .-sha_transform3
	# Size is 0x2D2 = 722 bytes

# A smaller variant
#define ROUND2(a,b,c,d,e,f,k)	\
	addl (%esp,I,4),e;	\
	incl I;			\
	f(b,c,d,e);		\
	leal k(T,e),T;		\
	movl d,e;		\
	movl c,d;		\
	movl b,c;		\
	rorl $2,c;		\
	movl a,b;		\
	roll $5,a;		\
	addl T,a

.globl sha_transform2
	.type	sha_transform2, @function
# void sha_transform2(__u32 digest[5], const char in[64])
sha_transform2:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
# Args start at 20(%esp)
	xorl	I,I
	movl	24(%esp),B	# B = in
	movl	20(%esp),T	# T = digest
	subl	$320,%esp
1:
	movl	(B,I,4),A
	bswap	A
	movl	A,(%esp,I,4)
	incl	I
	cmpl	$16,I
	jne	1b

2:
	movl	-64(%esp,I,4),A
	xorl	-56(%esp,I,4),A
	xorl	-32(%esp,I,4),A
	xorl	-12(%esp,I,4),A
	roll	$1,A
	movl	A,(%esp,I,4)
	incl	I
	cmpl	$80,I
	jne	2b

	movl	(T),A
	movl	4(T),B
	movl	8(T),C
	movl	12(T),D
	movl	16(T),E

	xorl	I,I
3:
	ROUND2(A,B,C,D,E,F1,K1)
	cmp	$20,I
	jne	3b
4:
	ROUND2(A,B,C,D,E,F2,K2)
	cmp	$40,I
	jne	4b
5:
	ROUND2(A,B,C,D,E,F3,K3)
	cmp	$60,I
	jne	5b
6:
	ROUND2(A,B,C,D,E,F2,K4)
	cmp	$80,I
	jne	6b

	addl	$320,%esp
	movl	20(%esp),T
	addl	A,(T)
	addl	B,4(T)
	addl	C,8(T)
	addl	D,12(T)
	addl	E,16(T)

	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp

	ret
	.size	sha_transform2, .-sha_transform2
	# Size is 0x10A = 266 bytes

# The three cases of the next input word...
# Fetch big-endian (first 16 rounds)
#define FETCH(i)		\
	movl	4*i(I),T;	\
	bswap	T;		\
	movl	T,4*i(%esp)

# Calculate but don't store (last 3 rounds)
#define CALCX(i)			\
	movl	4*(i&15)(%esp),T;	\
	xorl	4*((i+2)&15)(%esp),T;	\
	xorl	4*((i+8)&15)(%esp),T;	\
	xorl	4*((i+13)&15)(%esp),T;	\
	roll	$1,T

# Calculate and store on stack (middle 61 rounds)
#define CALC(i)			\
	CALCX(i);			\
	movl	T,4*(i&15)(%esp)

# e += W[i] + K + f(b, c, d) + rol32(a, 5); b = rol32(b, 30); i++;
#define ROUND5a(a,b,c,d,e,f,k)	\
	leal k(T,e),e;		\
	f(b,c,d,e);		\
	addl T,e;		\
	movl a,T;		\
	roll $5,T;		\
	rorl $2,b;		\
	addl T,e

# A variant that assumes that k is stored in I
#define ROUND5b(a,b,c,d,e,f)	\
	addl I,e;		\
	addl T,e;		\
	f(b,c,d,e);		\
	addl T,e;		\
	movl a,T;		\
	roll $5,T;		\
	rorl $2,b;		\
	addl T,e

.globl sha_transform5
	.type	sha_transform5, @function
# void sha_transform5(__u32 digest[5], const char in[64])
sha_transform5:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
# Args start at 20(%esp)
	movl	24(%esp),I	# I = in
	movl	20(%esp),T	# T = digest
	subl	$64,%esp

	movl	(T),A
	movl	4(T),B
	movl	8(T),C
	movl	12(T),D
	movl	16(T),E

	FETCH(0); ROUND5a(A,B,C,D,E,F1,K1)
	FETCH(1); ROUND5a(E,A,B,C,D,F1,K1)
	FETCH(2); ROUND5a(D,E,A,B,C,F1,K1)
	FETCH(3); ROUND5a(C,D,E,A,B,F1,K1)
	FETCH(4); ROUND5a(B,C,D,E,A,F1,K1)

	FETCH(5); ROUND5a(A,B,C,D,E,F1,K1)
	FETCH(6); ROUND5a(E,A,B,C,D,F1,K1)
	FETCH(7); ROUND5a(D,E,A,B,C,F1,K1)
	FETCH(8); ROUND5a(C,D,E,A,B,F1,K1)
	FETCH(9); ROUND5a(B,C,D,E,A,F1,K1)

	FETCH(10); ROUND5a(A,B,C,D,E,F1,K1)
	FETCH(11); ROUND5a(E,A,B,C,D,F1,K1)
	FETCH(12); ROUND5a(D,E,A,B,C,F1,K1)
	FETCH(13); ROUND5a(C,D,E,A,B,F1,K1)
	FETCH(14); ROUND5a(B,C,D,E,A,F1,K1)

	FETCH(15); movl $K1,I; ROUND5b(A,B,C,D,E,F1)
	CALC(16); ROUND5b(E,A,B,C,D,F1)
	CALC(17); ROUND5b(D,E,A,B,C,F1)
	CALC(18); ROUND5b(C,D,E,A,B,F1)
	CALC(19); ROUND5b(B,C,D,E,A,F1)

	movl $K2,I

	CALC(20); ROUND5b(A,B,C,D,E,F2)
	CALC(21); ROUND5b(E,A,B,C,D,F2)
	CALC(22); ROUND5b(D,E,A,B,C,F2)
	CALC(23); ROUND5b(C,D,E,A,B,F2)
	CALC(24); ROUND5b(B,C,D,E,A,F2)

	CALC(25); ROUND5b(A,B,C,D,E,F2)
	CALC(26); ROUND5b(E,A,B,C,D,F2)
	CALC(27); ROUND5b(D,E,A,B,C,F2)
	CALC(28); ROUND5b(C,D,E,A,B,F2)
	CALC(29); ROUND5b(B,C,D,E,A,F2)

	CALC(30); ROUND5b(A,B,C,D,E,F2)
	CALC(31); ROUND5b(E,A,B,C,D,F2)
	CALC(32); ROUND5b(D,E,A,B,C,F2)
	CALC(33); ROUND5b(C,D,E,A,B,F2)
	CALC(34); ROUND5b(B,C,D,E,A,F2)

	CALC(35); ROUND5b(A,B,C,D,E,F2)
	CALC(36); ROUND5b(E,A,B,C,D,F2)
	CALC(37); ROUND5b(D,E,A,B,C,F2)
	CALC(38); ROUND5b(C,D,E,A,B,F2)
	CALC(39); ROUND5b(B,C,D,E,A,F2)

	movl $K3,I

	CALC(40); ROUND5b(A,B,C,D,E,F3)
	CALC(41); ROUND5b(E,A,B,C,D,F3)
	CALC(42); ROUND5b(D,E,A,B,C,F3)
	CALC(43); ROUND5b(C,D,E,A,B,F3)
	CALC(44); ROUND5b(B,C,D,E,A,F3)

	CALC(45); ROUND5b(A,B,C,D,E,F3)
	CALC(46); ROUND5b(E,A,B,C,D,F3)
	CALC(47); ROUND5b(D,E,A,B,C,F3)
	CALC(48); ROUND5b(C,D,E,A,B,F3)
	CALC(49); ROUND5b(B,C,D,E,A,F3)

	CALC(50); ROUND5b(A,B,C,D,E,F3)
	CALC(51); ROUND5b(E,A,B,C,D,F3)
	CALC(52); ROUND5b(D,E,A,B,C,F3)
	CALC(53); ROUND5b(C,D,E,A,B,F3)
	CALC(54); ROUND5b(B,C,D,E,A,F3)

	CALC(55); ROUND5b(A,B,C,D,E,F3)
	CALC(56); ROUND5b(E,A,B,C,D,F3)
	CALC(57); ROUND5b(D,E,A,B,C,F3)
	CALC(58); ROUND5b(C,D,E,A,B,F3)
	CALC(59); ROUND5b(B,C,D,E,A,F3)

	movl $K4,I

	CALC(60); ROUND5b(A,B,C,D,E,F2)
	CALC(61); ROUND5b(E,A,B,C,D,F2)
	CALC(62); ROUND5b(D,E,A,B,C,F2)
	CALC(63); ROUND5b(C,D,E,A,B,F2)
	CALC(64); ROUND5b(B,C,D,E,A,F2)

	CALC(65); ROUND5b(A,B,C,D,E,F2)
	CALC(66); ROUND5b(E,A,B,C,D,F2)
	CALC(67); ROUND5b(D,E,A,B,C,F2)
	CALC(68); ROUND5b(C,D,E,A,B,F2)
	CALC(69); ROUND5b(B,C,D,E,A,F2)

	CALC(70); ROUND5b(A,B,C,D,E,F2)
	CALC(71); ROUND5b(E,A,B,C,D,F2)
	CALC(72); ROUND5b(D,E,A,B,C,F2)
	CALC(73); ROUND5b(C,D,E,A,B,F2)
	CALC(74); ROUND5b(B,C,D,E,A,F2)

	CALC(75); ROUND5b(A,B,C,D,E,F2)
	CALC(76); ROUND5b(E,A,B,C,D,F2)
	CALCX(77); ROUND5b(D,E,A,B,C,F2)
	CALCX(78); ROUND5b(C,D,E,A,B,F2)
	CALCX(79); ROUND5b(B,C,D,E,A,F2)

	addl	$64,%esp
	movl	20(%esp),I

#if 1
	addl	A,(I)
	addl	B,4(I)
	addl	C,8(I)
	addl	D,12(I)
	addl	E,16(I)
#else
	movl	A,(I)
	movl	B,4(I)
	movl	C,8(I)
	movl	D,12(I)
	movl	E,16(I)
#endif

	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp

	ret
	.size	sha_transform5, .-sha_transform5
	# Size is 0xDE6 = 3558 bytes


.globl sha_stackwipe
	.type	sha_stackwipe, @function
# void sha_stackwipe(void)
# After one or more sha_transform calls, we have left the contents of W[]
# on the stack, and from any 16 of those 80 words, the entire input
# can be reconstructed.  If the caller cares, this function obliterates
# the relevant portion of the stack.
# 2 words of argument + 4 woirds of saved registers + 80 words of W[]
sha_stackwipe:
	xorl	%eax,%eax
	movl	$86,%ecx
# Damn, I had hoped that loop; pushl %eax would work..
1:
	decl	%ecx
	pushl	%eax
	jne	1b

	addl	$4*86,%esp
	ret
	.size	sha_stackwipe, .-sha_stackwipe
