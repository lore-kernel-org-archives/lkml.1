Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbXFKHxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbXFKHxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 03:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXFKHxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 03:53:24 -0400
Received: from science.horizon.com ([192.35.100.1]:19759 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752184AbXFKHxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 03:53:23 -0400
Date: 11 Jun 2007 03:53:21 -0400
Message-ID: <20070611075321.8887.qmail@science.horizon.com>
From: linux@horizon.com
To: bgilbert@cs.cmu.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

+#define F3(x,y,z)						\
+	movl	x, TMP2;					\
+	andl	y, TMP2;					\
+	movl	x, TMP;						\
+	orl	y, TMP;						\
+	andl	z, TMP;						\
+       orl	TMP2, TMP

*Sigh*.  You don't need TMP2 to compute the majority function.

You're implementing it as (x & y) | ((x | y) & z).
Look at the rephrasing in lib/sha1.c:
#define f3(x,y,z)	((x & y) + (z & (x ^ y)))	/* majority */

By changing the second OR to x^y, you ensure that the two halves
of the first disjunciton are distinct, so you can replace the OR
with XOR, or better yet, +.

Then you can just do two adds to e.  That is, write:

/* Bitwise select: x ? y : z, which is (z ^ (x & (y ^ z))) */
#define F1(x,y,z,dest)		\
	movl	z, TMP;		\
	xorl	y, TMP;		\
	andl	x, TMP;		\
	xorl	z, TMP;		\
	addl	TMP, dest

/* Three-way XOR (x ^ y ^ z) */
#define F2(x,y,z,dest)		\
	movl	z, TMP;		\
	xorl	x, TMP;		\
	xorl	y, TMP;		\
	addl	TMP, dest

/* Majority: (x^y)|(y&z)|(z&x) = (x & z) + ((x ^ z) & y)
#define F3(x,y,z,dest)		\
	movl	z, TMP;		\
	andl	x, TMP;		\
	addl	TMP, dest;	\
	movl	z, TMP;		\
	xorl	x, TMP;		\
	andl	y, TMP;		\
	addl	TMP, dest

Since y is the most recently computed result (it's rotated in the
previous round), I arranged the code to delay its use as late as
possible.


Now you have one more register to play with.


I thought I had some good sha1 asm code lying around, but I
can't seem to find it.  (I have some excellent PowerPC asm if anyone
wants it.)  Here's a basic implementation question:

SHA-1 is made up of 80 rounds, 20 of each of 4 types.
There are 5 working variables, a through e.

The basic round is:
	t = F(b, c, d) + K + rol32(a, 5) + e + W[i];
	e = d; d = c; c = rol32(b, 30); b = a; a = t;
where W[] is the input array.  W[0..15] are the input words, and
W[16..79] are computed by a sort of LFSR from W[0..15].

Each group of 20 rounds has a different F() and K.
This is the smallest way to write the function, but all the
register shuffling makes for a bit of a speed penalty.

A faster way is to unroll 5 iterations and do:
	e += F(b, c, d) + K + rol32(a, 5) + W[i  ]; b = rol32(b, 30);
	d += F(a, b, c) + K + rol32(e, 5) + W[i+1]; a = rol32(a, 30);
	c += F(e, a, b) + K + rol32(d, 5) + W[i+2]; e = rol32(e, 30);
	b += F(d, e, a) + K + rol32(c, 5) + W[i+3]; d = rol32(d, 30);
	a += F(c, d, e) + K + rol32(b, 5) + W[i+4]; c = rol32(c, 30);
then loop over that 4 times each.  This is somewhat larger, but
still reasonably compact; only 20 of the 80 rounds are written out
long-hand.

Faster yet is to unroll all 80 rounds directly.  But it also takes the
most code space, and as we have learned, when your code is not the
execution time hot spot, less cache is faster code.

Is there a preferred implementation?


Another implementation choice has to do with the computation of W[].
W[i] is a function of W[i-3], W[i-8], W[i-14] and W[i-16].
It is possible to keep a 16-word circular buffer with only the most
recent 16 values of W[i%16] and compute each new word as it is needed.
However, the offsets i%16 repeat every 16 rounds, which is an awkward
fit with the 5-round repeating pattern of the main computation.

One option is to compute all the W[] values in a pre-pass beforehand.
Simple and small, but uses 320 bytes of data on the stack or wherever.
An intermediate one is to keep a 20-word buffer, and compute 20 words
at a time just before each of the 20 round groups.
