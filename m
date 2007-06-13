Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbXFMGqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbXFMGqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbXFMGqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:46:34 -0400
Received: from science.horizon.com ([192.35.100.1]:17803 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752009AbXFMGqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:46:33 -0400
Date: 13 Jun 2007 02:46:24 -0400
Message-ID: <20070613064624.31336.qmail@science.horizon.com>
From: linux@horizon.com
To: linux@horizon.com, mpm@selenic.com
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Cc: bgilbert@cs.cmu.edu, linux-kernel@vger.kernel.org
In-Reply-To: <20070613055030.GJ11166@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> The names are the order they were written in.  "One" is the lib/sha1.c
>> code (547 bytes with -Os).  "Four" is a 5x unrolled C version (1106 bytes).
>
> I'd like to see your version four.

Here's the test driver wrapped around the earlier assembly code.
It's an ugly mess of copy & paste code, of course.

I suspect it could be shrunk by allocating the W[] array locally,
thereby freeing up a register.  Size is -Os -fomit-frame-pointer.


/*
 * SHA transform algorithm, originally taken from code written by
 * Peter Gutmann, and placed in the public domain.
 */
#include <stdint.h>
#include <stdio.h>

#define rol32(x, s) ((x)<<(s) | (x)>>(32-(s)))
static inline uint32_t __attribute__((const))
be32_to_cpu(unsigned x)
{
	asm("bswap	%0" : "+r"(x));
	return x;
}


/* The SHA f()-functions.  */

#define f1(x,y,z)   (z ^ (x & (y ^ z)))		/* x ? y : z */
#define f2(x,y,z)   (x ^ y ^ z)			/* XOR */
#define f3(x,y,z)   ((x & y) + (z & (x ^ y)))	/* majority */

/* The SHA Mysterious Constants */

#define K1  0x5A827999L			/* Rounds  0-19: sqrt(2) * 2^30 */
#define K2  0x6ED9EBA1L			/* Rounds 20-39: sqrt(3) * 2^30 */
#define K3  0x8F1BBCDCL			/* Rounds 40-59: sqrt(5) * 2^30 */
#define K4  0xCA62C1D6L			/* Rounds 60-79: sqrt(10) * 2^30 */

/**
 * sha_transform - single block SHA1 transform
 *
 * @digest: 160 bit digest to update
 * @data:   512 bits of data to hash
 * @W:      80 words of workspace (see note)
 *
 * This function generates a SHA1 digest for a single 512-bit block.
 * Be warned, it does not handle padding and message digest, do not
 * confuse it with the full FIPS 180-1 digest algorithm for variable
 * length messages.
 *
 * Note: If the hash is security sensitive, the caller should be sure
 * to clear the workspace. This is left to the caller to avoid
 * unnecessary clears between chained hashing operations.
 */
void sha_transform(uint32_t digest[5], const char in[64], uint32_t W[80])
{
	register uint32_t a, b, c, d, e, t, i;

	for (i = 0; i < 16; i++)
		W[i] = be32_to_cpu(((const uint32_t *)in)[i]);

	for (i = 0; i < 64; i++)
		W[i+16] = rol32(W[i+13] ^ W[i+8] ^ W[i+2] ^ W[i], 1);

	a = digest[0];
	b = digest[1];
	c = digest[2];
	d = digest[3];
	e = digest[4];

	for (i = 0; i < 20; i++) {
		t = f1(b, c, d) + K1 + rol32(a, 5) + e + W[i];
		e = d; d = c; c = rol32(b, 30); b = a; a = t;
	}

	for (; i < 40; i ++) {
		t = f2(b, c, d) + K2 + rol32(a, 5) + e + W[i];
		e = d; d = c; c = rol32(b, 30); b = a; a = t;
	}

	for (; i < 60; i ++) {
		t = f3(b, c, d) + K3 + rol32(a, 5) + e + W[i];
		e = d; d = c; c = rol32(b, 30); b = a; a = t;
	}

	for (; i < 80; i ++) {
		t = f2(b, c, d) + K4 + rol32(a, 5) + e + W[i];
		e = d; d = c; c = rol32(b, 30); b = a; a = t;
	}

	digest[0] += a;
	digest[1] += b;
	digest[2] += c;
	digest[3] += d;
	digest[4] += e;
}

#define ROUND(a,b,c,d,e,f,add)	\
	( e += add + f(b,c,d),	\
	  b = rol32(b, 30),	\
	  e += rol32(a, 5) )

void sha_transform4(uint32_t digest[5], const char in[64], uint32_t W[80])
{
	register uint32_t a, b, c, d, e, i;

	for (i = 0; i < 16; i++)
		W[i] = be32_to_cpu(((const uint32_t *)in)[i]);

	for (i = 0; i < 64; i++) {
		a = W[i+13] ^ W[i+8] ^ W[i+2] ^ W[i];
		W[i+16] = rol32(a, 1);
	}

	a = digest[0];
	b = digest[1];
	c = digest[2];
	d = digest[3];
	e = digest[4];

	for (i = 0; i < 20; i += 5) {
		ROUND(a,b,c,d,e,f1,W[i  ]+K1);
		ROUND(e,a,b,c,d,f1,W[i+1]+K1);
		ROUND(d,e,a,b,c,f1,W[i+2]+K1);
		ROUND(c,d,e,a,b,f1,W[i+3]+K1);
		ROUND(b,c,d,e,a,f1,W[i+4]+K1);
	}

	for (; i < 40; i += 5) {
		ROUND(a,b,c,d,e,f2,W[i  ]+K2);
		ROUND(e,a,b,c,d,f2,W[i+1]+K2);
		ROUND(d,e,a,b,c,f2,W[i+2]+K2);
		ROUND(c,d,e,a,b,f2,W[i+3]+K2);
		ROUND(b,c,d,e,a,f2,W[i+4]+K2);
	}
	for (; i < 60; i += 5) {
		ROUND(a,b,c,d,e,f3,W[i  ]+K3);
		ROUND(e,a,b,c,d,f3,W[i+1]+K3);
		ROUND(d,e,a,b,c,f3,W[i+2]+K3);
		ROUND(c,d,e,a,b,f3,W[i+3]+K3);
		ROUND(b,c,d,e,a,f3,W[i+4]+K3);
	}
	for (; i < 80; i += 5) {
		ROUND(a,b,c,d,e,f2,W[i  ]+K4);
		ROUND(e,a,b,c,d,f2,W[i+1]+K4);
		ROUND(d,e,a,b,c,f2,W[i+2]+K4);
		ROUND(c,d,e,a,b,f2,W[i+3]+K4);
		ROUND(b,c,d,e,a,f2,W[i+4]+K4);
	}

	digest[0] += a;
	digest[1] += b;
	digest[2] += c;
	digest[3] += d;
	digest[4] += e;
}

extern void sha_transform2(uint32_t digest[5], const char in[64]);
extern void sha_transform3(uint32_t digest[5], const char in[64]);
extern void sha_transform5(uint32_t digest[5], const char in[64]);
extern void sha_stackwipe(void);

void sha_init(uint32_t buf[5])
{
	buf[0] = 0x67452301;
	buf[1] = 0xefcdab89;
	buf[2] = 0x98badcfe;
	buf[3] = 0x10325476;
	buf[4] = 0xc3d2e1f0;
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

#if 1
void sha_stackwipe2(void)
{
	uint32_t buf[90];
	memset(buf, 0, sizeof buf);
	asm("" : : "r" (&buf));	/* Force the compiler to do the memset */
}
#endif


#define TEST_SIZE (10*1024*1024)

int main(void)
{
	uint32_t W[80];
	uint32_t out[5];
	char const text[64] = "Hello, world!\n";
	char *buf;
	uint32_t *p;
	unsigned i;
	struct timeval start, stop;

	sha_init(out);
	sha_transform(out, text, W);
	printf("  One: %08x %08x %08x %08x %08x\n",
		out[0], out[1], out[2], out[3], out[4]);

	sha_init(out);
	sha_transform4(out, text, W);
	printf(" Four: %08x %08x %08x %08x %08x\n",
		out[0], out[1], out[2], out[3], out[4]);

	sha_init(out);
	sha_transform2(out, text);
	printf("  Two: %08x %08x %08x %08x %08x\n",
		out[0], out[1], out[2], out[3], out[4]);

	sha_init(out);
	sha_transform3(out, text);
	printf("Three: %08x %08x %08x %08x %08x\n",
		out[0], out[1], out[2], out[3], out[4]);

	sha_init(out);
	sha_transform5(out, text);
	printf(" Five: %08x %08x %08x %08x %08x\n",
		out[0], out[1], out[2], out[3], out[4]);

	sha_stackwipe();
#if 1

	/* Set up a large buffer full of stuff */
	buf = malloc(TEST_SIZE);
	p = (uint32_t *)buf;
	memcpy(p, W+80-16, 16*sizeof *p);
	for (i = 0; i < TEST_SIZE/sizeof *p - 16; i++) {
		uint32_t a = p[i+13] ^ p[i+8] ^ p[i+2] ^ p[i];
		p[i+16] = rol32(a, 1);
	}

	sha_init(out);
	gettimeofday(&start, 0);
	for (i = 0; i < TEST_SIZE; i += 64)
		sha_transform(out, buf+i, W);
	gettimeofday(&stop, 0);
	printf("  One: %08x %08x %08x %08x %08x -- %lu us\n",
		out[0], out[1], out[2], out[3], out[4],
		1000000*(stop.tv_sec-start.tv_sec)+stop.tv_usec-start.tv_usec);

	sha_init(out);
	gettimeofday(&start, 0);
	for (i = 0; i < TEST_SIZE; i += 64)
		sha_transform4(out, buf+i, W);
	gettimeofday(&stop, 0);
	printf(" Four: %08x %08x %08x %08x %08x -- %lu us\n",
		out[0], out[1], out[2], out[3], out[4],
		1000000*(stop.tv_sec-start.tv_sec)+stop.tv_usec-start.tv_usec);

	sha_init(out);
	gettimeofday(&start, 0);
	for (i = 0; i < TEST_SIZE; i += 64)
		sha_transform2(out, buf+i);
	gettimeofday(&stop, 0);
	printf("  Two: %08x %08x %08x %08x %08x -- %lu us\n",
		out[0], out[1], out[2], out[3], out[4],
		1000000*(stop.tv_sec-start.tv_sec)+stop.tv_usec-start.tv_usec);

	sha_init(out);
	gettimeofday(&start, 0);
	for (i = 0; i < TEST_SIZE; i += 64)
		sha_transform3(out, buf+i);
	gettimeofday(&stop, 0);
	printf("Three: %08x %08x %08x %08x %08x -- %lu us\n",
		out[0], out[1], out[2], out[3], out[4],
		1000000*(stop.tv_sec-start.tv_sec)+stop.tv_usec-start.tv_usec);

	sha_init(out);
	gettimeofday(&start, 0);
	for (i = 0; i < TEST_SIZE; i += 64)
		sha_transform5(out, buf+i);
	gettimeofday(&stop, 0);
	printf(" Five: %08x %08x %08x %08x %08x -- %lu us\n",
		out[0], out[1], out[2], out[3], out[4],
		1000000*(stop.tv_sec-start.tv_sec)+stop.tv_usec-start.tv_usec);
	
	sha_stackwipe();
#endif	
	
	return 0;
}
