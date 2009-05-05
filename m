Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZEEWJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZEEWJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZEEWJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:09:30 -0400
Received: from [212.69.161.110] ([212.69.161.110]:42897 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbZEEWJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:09:29 -0400
Date: Wed, 6 May 2009 00:08:32 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Neil Brown <neilb@suse.de>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Message-ID: <20090505220832.GA8700@soda.linbit>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <18941.12645.590037.589600@notabene.brown> <20090503082931.GD31340@racke> <18941.31069.695554.862567@notabene.brown> <20090503213231.GA6243@racke>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090503213231.GA6243@racke>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> > > but to answer the question:
> > > why bother to implement our own encoding?
> > > because we know a lot about the data to be encoded.
> > > 
> > > the compression of the bitmap transfer we just added very recently.
> > > for a bitmap, with large chunks of bits set or unset, it is efficient
> > > to just code the runlength.
> > > to use gzip in kernel would add yet an other huge overhead for code
> > > tables and so on.
> > > during testing of this encoding, applying it to an already gzip'ed file
> > > was able to compress it even further, btw.
> > > though on english plain text, gzip compression is _much_ more effective.
> > 
> > I just tried a little experiment.
> > I created a 128meg file and randomly set 1000 bits in it.
> > I compressed it with "gzip --best" and the result was 4Meg.  Not
> > particularly impressive.
> > I then tried to compress it wit bzip2 and got 3452 bytes.
> > Now *that* is impressive.  I suspect your encoding might do a little
> > better, but I wonder if it is worth the effort.
> 
> The effort is minimal.
> The cpu overhead is negligible (compared with bzip2, or any other
> generic compression scheme), and the memory overhead is next to none
> (just a small scratch buffer, to assemble the network packet).
> No tables or anything involved.
> Especially the _decoding_ part has this nice property:
>   chunk = 0;
>   while (!eof) {
> 	vli_decode_bits(&rl, input); /* number of unset bits */
> 	chunk += rl;
> 	vli_decode_bits(&rl, input); /* number of set bits */
> 	bitmap_dirty_bits(bitmap, chunk, chunk + rl);
> 	chunk += rl;
>  }
> 
> The source code is there.
> 
> For your example, on average you'd have (128 << 23) / 1000 "clear" bits,
> then one set bit. The encoding transfers
> "first bit unset -- ca. (1<<20), 1, ca. (1<<20), 1, ca. (1<<20), 1, ...",
> using 2 bits for the "1", and up to 29 bit for the "ca. 1<<20".
> should be in the very same ballpark as your bzip2 result.
> 
> > I'm not certain that my test file is entirely realistic, but it is
> > still an interesting experiment.
> 
> It is not ;) but still...
> If you are interessted, I can dig up my throw away user land code,
> that has been used to evaluate various such schemes.
> But it is so ugly that I won't post it to lkml.

I found round about ten different versions of that throw away code.
Oh well.  So I just hacked up an other one.

For your entertainment, prepare some example bitmaps.  From all my
real-world example bitmaps I can see that (at least with 4KiB bitmap
granularity), areas with alternating single-bit (which is the only run
length that does not compress) are rare.

Comments wellcome.  Have fun.

	Lars

--dDRMvlgZJXvWKvBx
Content-Type: text/x-csrc; charset=iso-8859-1
Content-Description: vli_bitstream_demo.c
Content-Disposition: attachment; filename="vli_bitstream_demo.c"
Content-Transfer-Encoding: 8bit

/* vim: set foldmethod=marker foldlevel=1 foldenable :
 *
 * Copyright 2009 Lars Ellenberg <lars@linbit.com>
 * Licence: GPL
 *
 * Purpose: demonstrate the simple, but efficient (for bitmaps, anyways),
 * encoding (usually: compression) used to exchange the DRBD bitmap.
 * Note: DRBD transmits incompressible chunks as plain text.
 * This demo does not, to better show the properties of the encoding method.
 * See also the comments just above the "struct code_chunk"
 *
 * More than half of this file is (almost) verbatim copy
 * from other .c and .h files, so you won't need the extra files,
 * like the generic find_next_bit.c or the drbd_vli.h.
 *
 * Tested on i686 and x86_64 Debian.
 * Might have issues on other archs, though I think it should not.
 *
 * For USAGE,
 * see show_usage_and_die() below. */

#include <sys/mman.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <linux/types.h>
#include <errno.h>
#include <endian.h>
#include <byteswap.h>

/* gcc -g -O3 -Wall -o vli_bitstream_demo vli_bitstream_demo.c */
/* for easy debugging with gdb, do
 *  gdb --args ./x 3< IN 4> OUT
 *  then set in_fd and out_fd to 3 and 4,
 *  and "run".
 */
static int in_fd = 0;  /* 0: stdin */
static int out_fd = 1; /* 1: stdout */

/* (almost) verbatim copied files from elsewhere {{{2 */

/* find bit helpers from linux kernel tree {{{3 */

/* taken from arch/x86/include/asm/bitops.h {{{4 */
static inline unsigned long __ffs(unsigned long word)
{
	asm("bsf %1,%0"
		: "=r" (word)
		: "rm" (word));
	return word;
}

static inline unsigned long ffz(unsigned long word)
{
	asm("bsf %1,%0"
		: "=r" (word)
		: "r" (~word));
	return word;
}

/* taken from lib/find_next_bit.c {{{4 */

/* find_next_bit.c: fallback find next bit implementation
 *
 * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
 * Written by David Howells (dhowells@redhat.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version
 * 2 of the License, or (at your option) any later version.
 */

#define BITS_PER_LONG		(sizeof(long)*8)
#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)

/*
 * Find the next set bit in a memory region.
 */
unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
			    unsigned long offset)
{
	const unsigned long *p = addr + BITOP_WORD(offset);
	unsigned long result = offset & ~(BITS_PER_LONG-1);
	unsigned long tmp;

	if (offset >= size)
		return size;
	size -= result;
	offset %= BITS_PER_LONG;
	if (offset) {
		tmp = *(p++);
		tmp &= (~0UL << offset);
		if (size < BITS_PER_LONG)
			goto found_first;
		if (tmp)
			goto found_middle;
		size -= BITS_PER_LONG;
		result += BITS_PER_LONG;
	}
	while (size & ~(BITS_PER_LONG-1)) {
		if ((tmp = *(p++)))
			goto found_middle;
		result += BITS_PER_LONG;
		size -= BITS_PER_LONG;
	}
	if (!size)
		return result;
	tmp = *p;

found_first:
	tmp &= (~0UL >> (BITS_PER_LONG - size));
	if (tmp == 0UL)		/* Are any bits set? */
		return result + size;	/* Nope. */
found_middle:
	return result + __ffs(tmp);
}

/*
 * This implementation of find_{first,next}_zero_bit was stolen from
 * Linus' asm-alpha/bitops.h.
 */
unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
				 unsigned long offset)
{
	const unsigned long *p = addr + BITOP_WORD(offset);
	unsigned long result = offset & ~(BITS_PER_LONG-1);
	unsigned long tmp;

	if (offset >= size)
		return size;
	size -= result;
	offset %= BITS_PER_LONG;
	if (offset) {
		tmp = *(p++);
		tmp |= ~0UL >> (BITS_PER_LONG - offset);
		if (size < BITS_PER_LONG)
			goto found_first;
		if (~tmp)
			goto found_middle;
		size -= BITS_PER_LONG;
		result += BITS_PER_LONG;
	}
	while (size & ~(BITS_PER_LONG-1)) {
		if (~(tmp = *(p++)))
			goto found_middle;
		result += BITS_PER_LONG;
		size -= BITS_PER_LONG;
	}
	if (!size)
		return result;
	tmp = *p;

found_first:
	tmp |= ~0UL << size;
	if (tmp == ~0UL)	/* Are any bits zero? */
		return result + size;	/* Nope. */
found_middle:
	return result + ffz(tmp);
}

/*
 * Find the first set bit in a memory region.
 */
unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
{
	const unsigned long *p = addr;
	unsigned long result = 0;
	unsigned long tmp;

	while (size & ~(BITS_PER_LONG-1)) {
		if ((tmp = *(p++)))
			goto found;
		result += BITS_PER_LONG;
		size -= BITS_PER_LONG;
	}
	if (!size)
		return result;

	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
	if (tmp == 0UL)		/* Are any bits set? */
		return result + size;	/* Nope. */
found:
	return result + __ffs(tmp);
}

/*
 * Find the first cleared bit in a memory region.
 */
unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
{
	const unsigned long *p = addr;
	unsigned long result = 0;
	unsigned long tmp;

	while (size & ~(BITS_PER_LONG-1)) {
		if (~(tmp = *(p++)))
			goto found;
		result += BITS_PER_LONG;
		size -= BITS_PER_LONG;
	}
	if (!size)
		return result;

	tmp = (*p) | (~0UL << size);
	if (tmp == ~0UL)	/* Are any bits zero? */
		return result + size;	/* Nope. */
found:
	return result + ffz(tmp);
}

/* end of find_next_bit.c }}}1 */

/* the VLI code implementation from drbd_vli.h {{{3 */

#define u64 __u64
#define u8 __u8
#define BUG() abort()

#if __BYTE_ORDER == __LITTLE_ENDIAN
#define le64_to_cpu(x)	(x)
#elif __BYTE_ORDER == __BIG_ENDIAN
#define le64_to_cpu(x)	bswap_64(x)
#else
#error "endian?"
#endif

/*
 * At a granularity of 4KiB storage represented per bit,
 * and stroage sizes of several TiB,
 * and possibly small-bandwidth replication,
 * the bitmap transfer time can take much too long,
 * if transmitted in plain text.
 *
 * We try to reduce the transfered bitmap information
 * by encoding runlengths of bit polarity.
 *
 * We never actually need to encode a "zero" (runlengths are positive).
 * But then we have to store the value of the first bit.
 * The first bit of information thus shall encode if the first runlength
 * gives the number of set or unset bits.
 *
 * We assume that large areas are either completely set or unset,
 * which gives good compression with any runlength method,
 * even when encoding the runlength as fixed size 32bit/64bit integers.
 *
 * Still, there may be areas where the polarity flips every few bits,
 * and encoding the runlength sequence of those areas with fix size
 * integers would be much worse than plaintext.
 *
 * We want to encode small runlength values with minimum code length,
 * while still being able to encode a Huge run of all zeros efficiently.
 *
 * Thus we need a Variable Length Integer encoding, VLI.
 *
 * For some cases, we produce more code bits than plaintext input.
 * We need to send incompressible chunks as plaintext, skip over them
 * and then see if the next chunk compresses better.
 *
 * We don't care too much about "excellent" compression ratio for large
 * runlengths (all set/all clear): whether we achieve a factor of 100
 * or 1000 is not that much of an issue.
 * We do not want to waste too much on short runlengths in the "noisy"
 * parts of the bitmap, though.
 *
 * There are endless variants of VLI, we experimented with:
 *  * simple byte-based
 *  * various bit based with different code word length.
 *
 * To avoid yet an other configuration parameter (choice of bitmap compression
 * algorithm) which was difficult to explain and tune, we just chose the one
 * variant that turned out best in all test cases.
 * Based on real world usage patterns, with device sizes ranging from a few GiB
 * to several TiB, file server/mailserver/webserver/mysql/postgress,
 * mostly idle to really busy, the all time winner (though sometimes only
 * marginally better) is:
 */

/*
 * encoding is "visualised" as
 * __little endian__ bitstream, least significant bit first (left most)
 *
 * this particular encoding is chosen so that the prefix code
 * starts as unary encoding the level, then modified so that
 * 10 levels can be described in 8bit, with minimal overhead
 * for the smaller levels.
 *
 * Number of data bits follow fibonacci sequence, with the exception of the
 * last level (+1 data bit, so it makes 64bit total).  The only worse code when
 * encoding bit polarity runlength is 1 plain bits => 2 code bits.
prefix    data bits                                    max val  Nº data bits
0 x                                                         0x2            1
10 x                                                        0x4            1
110 xx                                                      0x8            2
1110 xxx                                                   0x10            3
11110 xxx xx                                               0x30            5
111110 xx xxxxxx                                          0x130            8
11111100  xxxxxxxx xxxxx                                 0x2130           13
11111110  xxxxxxxx xxxxxxxx xxxxx                      0x202130           21
11111101  xxxxxxxx xxxxxxxx xxxxxxxx  xxxxxxxx xx   0x400202130           34
11111111  xxxxxxxx xxxxxxxx xxxxxxxx  xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx 56
 * maximum encodable value: 0x100000400202130 == 2**56 + some */

/* compression "table":
 transmitted   x                                0.29
 as plaintext x                                  ........................
             x                                   ........................
            x                                    ........................
           x    0.59                         0.21........................
          x      ........................................................
         x       .. c ...................................................
        x    0.44.. o ...................................................
       x .......... d ...................................................
      x  .......... e ...................................................
     X.............   ...................................................
    x.............. b ...................................................
2.0x............... i ...................................................
 #X................ t ...................................................
 #................. s ...........................  plain bits  ..........
-+-----------------------------------------------------------------------
 1             16              32                              64
*/

/* LEVEL: (total bits, prefix bits, prefix value),
 * sorted ascending by number of total bits.
 * The rest of the code table is calculated at compiletime from this. */

/* fibonacci data 1, 1, ... */
#define VLI_L_1_1() do { \
	LEVEL( 2, 1, 0x00); \
	LEVEL( 3, 2, 0x01); \
	LEVEL( 5, 3, 0x03); \
	LEVEL( 7, 4, 0x07); \
	LEVEL(10, 5, 0x0f); \
	LEVEL(14, 6, 0x1f); \
	LEVEL(21, 8, 0x3f); \
	LEVEL(29, 8, 0x7f); \
	LEVEL(42, 8, 0xbf); \
	LEVEL(64, 8, 0xff); \
	} while (0)

/* finds a suitable level to decode the least significant part of in.
 * returns number of bits consumed.
 *
 * BUG() for bad input, as that would mean a buggy code table. */
static inline int vli_decode_bits(u64 *out, const u64 in)
{
	u64 adj = 1;

#define LEVEL(t,b,v)					\
	do {						\
		if ((in & ((1 << b) -1)) == v) {	\
			*out = ((in & ((~0ULL) >> (64-t))) >> b) + adj;	\
			return t;			\
		}					\
		adj += 1ULL << (t - b);			\
	} while (0)

	VLI_L_1_1();

	/* NOT REACHED, if VLI_LEVELS code table is defined properly */
	BUG();
#undef LEVEL
}

/* return number of code bits needed,
 * or negative error number */
static inline int __vli_encode_bits(u64 *out, const u64 in)
{
	u64 max = 0;
	u64 adj = 1;

	if (in == 0)
		return -EINVAL;

#define LEVEL(t,b,v) do {		\
		max += 1ULL << (t - b);	\
		if (in <= max) {	\
			if (out)	\
				*out = ((in - adj) << b) | v;	\
			return t;	\
		}			\
		adj = max + 1;		\
	} while (0)

	VLI_L_1_1();

	return -EOVERFLOW;
#undef LEVEL
}

#undef VLI_L_1_1

/* code from here down is independend of actually used bit code */

/*
 * Code length is determined by some unique (e.g. unary) prefix.
 * This encodes arbitrary bit length, not whole bytes: we have a bit-stream,
 * not a byte stream.
 */

/* for the bitstream, we need a cursor */
struct bitstream_cursor {
	/* the current byte */
	u8 *b;
	/* the current bit within *b, nomalized: 0..7 */
	unsigned int bit;
};

/* initialize cursor to point to first bit of stream */
static inline void bitstream_cursor_reset(struct bitstream_cursor *cur, void *s)
{
	cur->b = s;
	cur->bit = 0;
}

/* advance cursor by that many bits; maximum expected input value: 64,
 * but depending on VLI implementation, it may be more. */
static inline void bitstream_cursor_advance(struct bitstream_cursor *cur, unsigned int bits)
{
	bits += cur->bit;
	cur->b = cur->b + (bits >> 3);
	cur->bit = bits & 7;
}

/* the bitstream itself knows its length */
struct bitstream {
	struct bitstream_cursor cur;
	unsigned char *buf;
	size_t buf_len;		/* in bytes */

	/* for input stream:
	 * number of trailing 0 bits for padding
	 * total number of valid bits in stream: buf_len * 8 - pad_bits */
	unsigned int pad_bits;
};

static inline void bitstream_init(struct bitstream *bs, void *s, size_t len, unsigned int pad_bits)
{
	bs->buf = s;
	bs->buf_len = len;
	bs->pad_bits = pad_bits;
	bitstream_cursor_reset(&bs->cur, bs->buf);
}

static inline void bitstream_rewind(struct bitstream *bs)
{
	bitstream_cursor_reset(&bs->cur, bs->buf);
	memset(bs->buf, 0, bs->buf_len);
}

/* Put (at most 64) least significant bits of val into bitstream, and advance cursor.
 * Ignores "pad_bits".
 * Returns zero if bits == 0 (nothing to do).
 * Returns number of bits used if successful.
 *
 * If there is not enough room left in bitstream,
 * leaves bitstream unchanged and returns -ENOBUFS.
 */
static inline int bitstream_put_bits(struct bitstream *bs, u64 val, const unsigned int bits)
{
	unsigned char *b = bs->cur.b;
	unsigned int tmp;

	if (bits == 0)
		return 0;

	if ((bs->cur.b + ((bs->cur.bit + bits -1) >> 3)) - bs->buf >= bs->buf_len)
		return -ENOBUFS;

	/* paranoia: strip off hi bits; they should not be set anyways. */
	if (bits < 64)
		val &= ~0ULL >> (64 - bits);

	*b++ |= (val & 0xff) << bs->cur.bit;

	for (tmp = 8 - bs->cur.bit; tmp < bits; tmp += 8)
		*b++ |= (val >> tmp) & 0xff;

	bitstream_cursor_advance(&bs->cur, bits);
	return bits;
}

/* Fetch (at most 64) bits from bitstream into *out, and advance cursor.
 *
 * If more than 64 bits are requested, returns -EINVAL and leave *out unchanged.
 *
 * If there are less than the requested number of valid bits left in the
 * bitstream, still fetches all available bits.
 *
 * Returns number of actually fetched bits.
 */
static inline int bitstream_get_bits(struct bitstream *bs, u64 *out, int bits)
{
	u64 val;
	unsigned int n;

	if (bits > 64)
		return -EINVAL;

	if (bs->cur.b + ((bs->cur.bit + bs->pad_bits + bits -1) >> 3) - bs->buf >= bs->buf_len)
		bits = ((bs->buf_len - (bs->cur.b - bs->buf)) << 3)
			- bs->cur.bit - bs->pad_bits;

	if (bits == 0) {
		*out = 0;
		return 0;
	}

	/* get the high bits */
	val = 0;
	n = (bs->cur.bit + bits + 7) >> 3;
	/* n may be at most 9, if cur.bit + bits > 64 */
	/* which means this copies at most 8 byte */
	if (n) {
		memcpy(&val, bs->cur.b+1, n - 1);
		val = le64_to_cpu(val) << (8 - bs->cur.bit);
	}

	/* we still need the low bits */
	val |= bs->cur.b[0] >> bs->cur.bit;

	/* and mask out bits we don't want */
	val &= ~0ULL >> (64 - bits);

	bitstream_cursor_advance(&bs->cur, bits);
	*out = val;

	return bits;
}

/* encodes @in as vli into @bs;

 * return values
 *  > 0: number of bits successfully stored in bitstream
 * -ENOBUFS @bs is full
 * -EINVAL input zero (invalid)
 * -EOVERFLOW input too large for this vli code (invalid)
 */
static inline int vli_encode_bits(struct bitstream *bs, u64 in)
{
	u64 code = code;
	int bits = __vli_encode_bits(&code, in);

	if (bits <= 0)
		return bits;

	return bitstream_put_bits(bs, code, bits);
}

/* end of drbd_vli.h }}}1 */

static char *progname;

void show_usage_and_die(void)
{
	fprintf(stderr,
"Usage: %s subcommand subcommand-options ...\n"
"  Subcommands:\n"
"  plain-to-rl <in_file>:\n"
"    mmap()s in_file,\n"
"    Writes a stream of 32bit native unsigned int to stdout,\n"
"    representing the runlengths of set and unset bits.\n"
"    First runlength is _unset_ bits,\n"
"    and is the only runlength that may be zero.\n\n"

"  rl-to-vli\n"
"    Takes the output of 'plain-to-rl' from stdin,\n"
"    and encodes those runlengths into variable length integer (VLI)\n"
"    bitstream chunks (to stdout).\n"
"    export RL_TO_VLI_STATS=any-value gives extra stats on this one.\n\n"

"  vli-to-rl\n"
"    Takes the output of 'rl-to-vli' from stdin,\n"
"    and decodes those VLI chunks back into a stream of\n"
"    32bit native unsigned int (to stdout).\n\n"

"  rl-to-plain\n"
"    Takes a stream of 32bit native unsigned int runlengths from stdin\n"
"    and writes the corresponding plaintext to stdout.\n\n"

"Note that in the proper implementation, incompressible chunks\n"
"are stored as plain. This is not done here, to better demonstrate\n"
"the properties of this method\n\n"

"shell examples:\n"
"  do_try() { ( set -vxeC\n"
"    local f=${1:? missing input file};\n"
"    export RL_TO_VLI_STATS=whatever\n"
"    time %s plain-to-rl \"$f\" > RL;\n"
"    time %s rl-to-vli < RL > BS;\n"
"    time %s vli-to-rl < BS > DE;\n"
"    time %s rl-to-plain < DE > R;\n"
"    ls -l \"$f\" R BS RL DE;\n"
"    time cmp RL DE;\n"
"    time cmp \"$f\" R )\n"
"  }\n"
"  # rm -f RL BS DE R # for cleanup, because of set -C\n"
"  do_try example_bitmap\n"
"The bit stream in BS is the compressed representation of infile\n\n"

"Stupid comparison for the fun of it. Prepare some example_bitmap, then:\n"
"f=example_bitmap\n"
"time { gzip --best < $f | tee C | gunzip > /dev/null; ls -l C; }\n"
"time { bzip2 < $f | tee C | bunzip2 > /dev/null; ls -l C; }\n"
"time { %s plain-to-rl $f | %s rl-to-vli |\n"
"       tee C | %s vli-to-rl |\n"
"       %s rl-to-plain > /dev/null; ls -l C; }\n",
		progname,
		progname, progname, progname, progname,
		progname, progname, progname, progname);
	exit(1);
}

static char *subcmd;
#define eprintf(fmt, args...) fprintf(stderr, "%s: " fmt, subcmd , ## args)

#define RING_SIZE 1024
static unsigned RL[RING_SIZE];

/* plain-to-rl {{{2 */

/* also used in vli-to-rl */
void write_RL(int i)
{
	ssize_t s = i * sizeof(RL[0]);
	ssize_t c = write(out_fd, RL, s);
	if (c < 0) {
		eprintf("error writing runlength blob to stdout: %m\n");
		exit(6);
	}
	if (c != s) {
		eprintf("short write: %lu != %lu\n",
				(unsigned long)c, (unsigned long)s);
		exit(7);
	}
}

/* don't risk bit number wrap around.
 * could be coded around, of course. */
#define MAX_BYTES ((off_t)((unsigned int)(~0) >> 3))

int plain_to_rl(int argc, char **argv)
{
	struct stat sb;
	unsigned long current_bit = 0;
	unsigned long n_bits;
	unsigned long tmp;
	unsigned long *bm;
	char *in_file;
	int toggle = 0;
	int i = 0;
	int fd;

	if (argc != 1) {
		eprintf("missing input file argument\n");
		return 1;
	}

	in_file = argv[0];
	fd = open(in_file, O_RDONLY);
	if (fd < 0) {
		eprintf("open('%s'): %m\n", in_file);
		return 2;
	}

	if (fstat(fd, &sb)) {
		eprintf("fstat(%s): %m\n", in_file);
		return 3;
	}

	if ((sb.st_mode & S_IFMT) != S_IFREG) {
		eprintf("%s: not a regular file\n", in_file);
		return 4;
	}

	if (sb.st_size > MAX_BYTES) {
		eprintf("%s too big, only scanning first %lu bytes\n",
				in_file, MAX_BYTES);
		sb.st_size = MAX_BYTES;
	}

	/* maybe TODO: allow start offset and size to be specified,
	 * possibly use mmap2 */
	bm = mmap(NULL, sb.st_size, PROT_READ, MAP_SHARED | MAP_POPULATE, fd, 0);
	if (bm == MAP_FAILED) {
		eprintf("mmap(%s): %m\n", in_file);
		return 5;
	}

	n_bits = sb.st_size << 3;
	for (;;) {
		toggle = !toggle;

		tmp = toggle ? find_next_bit(bm, n_bits, current_bit)
		             : find_next_zero_bit(bm, n_bits, current_bit);

		if (tmp >= n_bits)
			RL[i++] = n_bits - current_bit;
		else
			RL[i++] = tmp - current_bit;
		if (i == RING_SIZE || tmp >= n_bits) {
			write_RL(i);
			if (tmp >= n_bits)
				break;
			i = 0;
		}
		current_bit = tmp;
	}
	close(1);
	return 0;
}

/* plain-to-rl }}}1 */

/* rl-to-vli {{{2 */

/* drbd on-network packet is preceeded by an 8 byte header, btw.
 * also, we transmit an incompressible chunk as plain, obviously.
 * left out here for demonstation of the encoding properties only. */

/* also used from vli_to_rl */
/* CAUTION: do not increase OUTPUT_BUFF_SIZE without also changing
 * the chunk.head format, see head_to_bytes() below.
 * in a proper implementation, you would add some magic or checksum,
 * plus a flag for interleaved plaintext (for incompressible chunks). */
#define OUTPUT_BUFF_SIZE 4096
static struct code_chunk {
	unsigned short head;
#define head_to_bytes(head)		((head & 0x0fff) +1)
#define head_to_pad_bits(head)		((head & 0x7000) >> 12)
#define head_is_first_bit_set(head)	((head & 0x8000) != 0)

	unsigned char code[OUTPUT_BUFF_SIZE];
} chunk;

ssize_t pipe_read(int fd, void *buf, ssize_t l)
{
	ssize_t c, count = 0;
	int loop = 0;
	do {
		c = read(in_fd, buf + count, l);
		if (c < 0) {
			eprintf("error reading from stdin: %m\n");
			exit(2);
		}
		if (c == 0 && ++loop > 3)
			break;
		count += c;
		l -= c;
	} while (l);
	return count;
}

int read_RL()
{
	int count = pipe_read(in_fd, RL, sizeof(RL));
	if (count % sizeof(RL[0])) {
		eprintf("short read, not modulo native unsingned int!\n"
				" %u %% %u == %u\n", count, (unsigned)sizeof(RL[0]),
				count % (unsigned)sizeof(RL[0]));
		exit(2);
	}
	return count / sizeof(RL[0]);
}

/* one could save (8*sizeof(head) + up to 7) bits every chunk, by just
 * streaming the code bits one after the other.
 * but then you have no easy way to detect truncated code during decode */
void write_code_chunk_rewind_bs(struct bitstream *bs, int first_bit_set)
{
	ssize_t c;
	ssize_t s = bs->cur.b - bs->buf + !!bs->cur.bit;

	chunk.head = first_bit_set ? 0x8000 : 0;
	/* pad bits */
	chunk.head |= (0x7 & (8 - bs->cur.bit)) << 12;
	/* code bytes */
	chunk.head |= 0x0fff & (s - 1);

	/* should not happen? */
	if (!s)
		return;

	s += sizeof(chunk.head);
	c = write(out_fd, &chunk, s);
	if (c < 0) {
		eprintf("error writing code blob to stdout: %m\n");
		exit(6);
	}
	if (c != s) {
		eprintf("short write: %lu != %lu\n",
				(unsigned long)c, (unsigned long)s);
		exit(7);
	}
	bitstream_rewind(bs);
}

static struct {
       unsigned n;
       unsigned plain;
       unsigned code;
} stats[2]; /* compressible, incompressible */

void do_stats(struct bitstream *bs, int n_chunks, unsigned long plain)
{
	unsigned long code = ((bs->cur.b - bs->buf) + !!bs->cur.bit + 2) * 8;
	/* eprintf("chunk:%u plain_bits:%lu code_bits:%u\n",
		n_chunks, plain, code); */
	++stats[code > plain].n;
	stats[code > plain].plain += plain;
	stats[code > plain].code += code;
}

void print_stat_summary(void)
{
	unsigned total_n = stats[0].n + stats[1].n;
	unsigned long total_plain_bits = stats[0].plain + stats[1].plain;
	unsigned long total_code_bits = stats[0].code + stats[1].code;

	eprintf("stats: %u chunks, %u compressed, %u uncompressed\n"
		"\tonly compressible: %u plain bits -> %u code bits\n",
		total_n, stats[0].n, stats[1].n,
		stats[0].plain, stats[0].code);
	eprintf("total saved: %.2f%%\n",
			100.0 * (total_plain_bits - total_code_bits)
			    / total_plain_bits);
}

int rl_to_vli(int argc, char **argv)
{
	struct bitstream bs;
	unsigned long plain_bits = 0;
	int l = read_RL();
	int first_is_set;
	int odd_is_set = 1;
	int i;
	int bits;
	int stats = NULL != getenv("RL_TO_VLI_STATS");
	int n_chunks = 0;

	if (l == 0) {
		eprintf("empty input!\n");
		return 3;
	}

	bitstream_init(&bs, chunk.code, OUTPUT_BUFF_SIZE, 0);
	i = !RL[0];
	first_is_set = i;
	do {
		while (i < l) {
			/* paranoia: catch zero runlength.
			 * can only happen if bitmap was modified while it was scanned. */
			if (RL[i] == 0) {
				eprintf("unexpected zero runlength i=%d\n", i);
				return 4;
			}
redo:
			bits = vli_encode_bits(&bs, RL[i]);
			if (bits == -ENOBUFS) { /* buffer full */
				if (stats) {
					do_stats(&bs, n_chunks++, plain_bits);
					plain_bits = 0;
				}
				write_code_chunk_rewind_bs(&bs, first_is_set);
				/* current will be first of next packet */
				first_is_set = (i & 1) == odd_is_set;
				goto redo;
			}
			if (bits <= 0) {
				eprintf("error while encoding runlength: %d\n", bits);
				return 5;
			}
			if (stats)
				plain_bits += RL[i];
			i++;
		}
		if (l & 1)
			odd_is_set = !odd_is_set;
		l = read_RL();
		i = 0;
	} while (l);
	if (bs.cur.b != bs.buf || bs.cur.bit)
		write_code_chunk_rewind_bs(&bs, first_is_set);
	if (stats)
		print_stat_summary();
	return 0;
}

/* rl-to-vli }}}1 */

/* vli-to-rl {{{2 */

ssize_t read_one_code_chunk(struct bitstream *bs)
{
	static unsigned long total_read_bytes;
	ssize_t len;
	int bytes;

	len = pipe_read(in_fd, &chunk.head, sizeof(chunk.head));
	if (len == 0)
		return 0;
	if (len != 2) {
		eprintf("short read reading chunk.head\n");
		exit(2);
	}
	total_read_bytes += len;
	bytes = head_to_bytes(chunk.head);
	len = pipe_read(in_fd, &chunk.code, bytes);
	if (len != bytes) {
		eprintf("short read reading chunk.code: %d %d (%lu)\n",
			(unsigned)len, bytes, total_read_bytes);
		exit(2);
	}
	total_read_bytes += len;
	bitstream_init(bs, chunk.code, bytes, head_to_pad_bits(chunk.head));
	return len + 2;
}

int vli_to_rl(int argc, char **argv)
{
	struct bitstream bs;
	__u64 look_ahead;
	__u64 tmp;
	__u64 rl;
	int toggle;
	int have;
	int bits;
	int first = 1;
	int i = 0;

	while (read_one_code_chunk(&bs)) {
		look_ahead = 0;
		tmp = 0;
		have = 0;
		toggle = !head_is_first_bit_set(chunk.head);
		if (first) {
			first = 0;
			if (!toggle)
				RL[i++] = 0;
		}
		for (;;) {
			toggle = !toggle;
			/* get fresh bits */
			bits = bitstream_get_bits(&bs, &tmp, 64 - have);
			if (bits < 0)
				return 3;
			look_ahead |= tmp << have;
			have += bits;
			if (have == 0)
				break;

			/* consume one code number */
			bits = vli_decode_bits(&rl, look_ahead);
			if (bits <= 0)
				return 4;
			/* cannot possibly decode more bits than I had */
			if (have < bits)
				return 5;
			look_ahead >>= bits;
			have -= bits;

			RL[i++] = rl;
			if (i == RING_SIZE) {
				write_RL(i);
				i = 0;
			}
		}
	}
	write_RL(i);
	return 0;
}

/* vli-to-rl }}}1 */

/* rl-to-plain {{{2 */

int rl_to_plain(int argc, char **argv)
{
	/* yep, this is excessive, and only used here to quick'n'dirty
	 * code something that is streamable. */
	static unsigned char zeros[4096];
	static unsigned char FFFFs[4096];

	unsigned char *out;
	unsigned int rl;
	int l;
	int i;
	int set = 0;
	int minibuf_bits = 0;
	unsigned char minibuf = 0;

	/* no need to initialize zeros, static did that for us */
	memset(FFFFs, 0xff, sizeof(FFFFs));

	while ((l = read_RL())) {
		for (i = 0; i < l; i++, set = !set) {
			rl = RL[i];
			if (minibuf_bits || rl < 8) {
				if (set) /* set bits */
					minibuf |= ((1 << (rl < 7 ? rl : 7)) -1)
						<< minibuf_bits;
				if (rl < 8 - minibuf_bits) {
					minibuf_bits += rl;
					continue;
				}
				if (write(out_fd, &minibuf, 1) != 1) {
					eprintf("FIXME 1\n");
					exit(2);
				}
				rl -= 8 - minibuf_bits;
				minibuf = 0;
				minibuf_bits = 0;
			}

			out = set ? FFFFs : zeros;
			while (rl > 8) {
				size_t c = rl/8; /* 8 bits per byte */
				if (sizeof(FFFFs) < c)
					c = sizeof(FFFFs);
				if (write(out_fd, out, c) != c) {
					eprintf("FIXME 2\n");
					exit(2);
				}
				rl -= c * 8;
			}
			if (rl) {
				if (set)
					minibuf = (1 << rl) -1;
				minibuf_bits = rl;
			}
		}
	}
	if (minibuf_bits)
		if (write(out_fd, &minibuf, 1) != 1) {
			eprintf("FIXME 3\n");
			exit(2);
		}

	return 0;
}

/* rl_to_plain }}}1 */

int main(int argc, char **argv)
{
	progname = strrchr(argv[0], '/');
	if (!progname)
		progname = argv[0];
	else
		progname++;

	if (argc < 2)
		show_usage_and_die();
	subcmd = argv[1];
	if (!strcmp(subcmd, "plain-to-rl"))
		return plain_to_rl(argc-2, argv+2);
	if (!strcmp(subcmd, "rl-to-vli"))
		return rl_to_vli(argc-2, argv+2);
	if (!strcmp(subcmd, "vli-to-rl"))
		return vli_to_rl(argc-2, argv+2);
	if (!strcmp(subcmd, "rl-to-plain"))
		return rl_to_plain(argc-2, argv+2);

	fprintf(stderr, "%s %s: unimplemented subcommand\n", progname, subcmd);
	return 1;
}

--dDRMvlgZJXvWKvBx--
