Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbYJNATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbYJNATi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbYJNATA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:19:00 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:52894 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbYJNAS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:18:56 -0400
Date: Tue, 14 Oct 2008 02:18:47 +0200
From: Alain Knaff <alain@knaff.lu>
Message-Id: <200810140018.m9E0IldQ002408@hitchhiker.org.lu>
Subject: [PATCH 1/5] init: bzip2 or lzma -compressed kernels and initrds
To: <hpa@zytor.com>, <linux-kernel@vger.kernel.org>, <alain@knaff.lu>
X-Mailer: mail (GNU Mailutils 1.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first part of the bzip2/lzma patch

The bzip patch is based on an idea by Christian Ludwig, includes support for
compressing the kernel with bzip2 or lzma rather than gzip. Both
compressors give smaller sizes than gzip.  Lzma's decompresses faster
than bzip2.

It also supports ramdisks and initramfs' compressed using these two
compressors.

The functionality has been successfully used for a couple of years by
the udpcast project

This version applies to "tip" kernel 2.6.27

This part contains:
- cleanup, such as removal of gzip compression of compiled-in
initramfs
- changed inflate.c to accomodate rest of patch
- implementation of bzip2 compression (not used at this stage yet)
- implementation of lzma compression (not used at this stage yet)
- Makefile routines to support bzip2 and lzma kernel compression

Signed-off-by: Alain Knaff <alain@knaff.lu>

---

diff -urNp base/include/linux/decompress/bunzip2.h library/include/linux/decompress/bunzip2.h
--- base/include/linux/decompress/bunzip2.h	1970-01-01 01:00:00.000000000 +0100
+++ library/include/linux/decompress/bunzip2.h	2008-10-13 22:24:00.000000000 +0200
@@ -0,0 +1,10 @@
+#ifndef DECOMPRESS_BUNZIP2_H
+#define DECOMPRESS_BUNZIP2_H
+
+int bunzip2(unsigned char *inbuf, int len,
+	    int(*fill)(void*, unsigned int),
+	    int(*flush)(void*, unsigned int),
+	    unsigned char *output,
+	    int *pos,
+	    void(*error)(char *x));
+#endif
diff -urNp base/include/linux/decompress/generic.h library/include/linux/decompress/generic.h
--- base/include/linux/decompress/generic.h	1970-01-01 01:00:00.000000000 +0100
+++ library/include/linux/decompress/generic.h	2008-10-13 22:24:00.000000000 +0200
@@ -0,0 +1,30 @@
+#ifndef DECOMPRESS_GENERIC_H
+#define DECOMPRESS_GENERIC_H
+
+/* Minimal chunksize to be read.
+ *Bzip2 prefers at least 4096
+ *Lzma prefers 0x10000 */
+#define COMPR_IOBUF_SIZE	4096
+
+typedef int (*decompress_fn) (unsigned char *inbuf, int len,
+			      int(*fill)(void*, unsigned int),
+			      int(*writebb)(void*, unsigned int),
+			      unsigned char *output,
+			      int *posp,
+			      void(*error)(char *x));
+
+/* inbuf   - input buffer
+ *len     - len of pre-read data in inbuf
+ *fill    - function to fill inbuf if empty
+ *writebb - function to write out outbug
+ *posp    - if non-null, input position (number of bytes read) will be
+ *	  returned here
+ *
+ *If len != 0, the inbuf is initialized (with as much data), and fill
+ *should not be called
+ *If len = 0, the inbuf is allocated, but empty. Its size is IOBUF_SIZE
+ *fill should be called (repeatedly...) to read data, at most IOBUF_SIZE
+ */
+
+
+#endif
diff -urNp base/include/linux/decompress/inflate.h library/include/linux/decompress/inflate.h
--- base/include/linux/decompress/inflate.h	1970-01-01 01:00:00.000000000 +0100
+++ library/include/linux/decompress/inflate.h	2008-10-13 22:24:00.000000000 +0200
@@ -0,0 +1,13 @@
+#ifndef INFLATE_H
+#define INFLATE_H
+
+/* Other housekeeping constants */
+#define INBUFSIZ 4096
+
+int gunzip(unsigned char *inbuf, int len,
+	   int(*fill)(void*, unsigned int),
+	   int(*flush)(void*, unsigned int),
+	   unsigned char *output,
+	   int *pos,
+	   void(*error_fn)(char *x));
+#endif
diff -urNp base/include/linux/decompress/mm.h library/include/linux/decompress/mm.h
--- base/include/linux/decompress/mm.h	1970-01-01 01:00:00.000000000 +0100
+++ library/include/linux/decompress/mm.h	2008-10-14 00:59:56.000000000 +0200
@@ -0,0 +1,90 @@
+/*
+ * linux/compr_mm.h
+ *
+ * Memory management for pre-boot and ramdisk uncompressors
+ *
+ * Authors: Alain Knaff <alain@knaff.lu>
+ *
+ */
+
+#ifndef DECOMPR_MM_H
+#define DECOMPR_MM_H
+
+#ifndef NO_INFLATE_MALLOC
+
+/* Code active when included from pre-boot environment: */
+
+/* A trivial malloc implementation, adapted from
+ *  malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
+ */
+static unsigned long malloc_ptr;
+static int malloc_count;
+
+static void *malloc(int size)
+{
+	void *p;
+
+	if (size < 0)
+		error("Malloc error");
+	if (!malloc_ptr)
+		malloc_ptr = free_mem_ptr;
+
+	malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
+
+	p = (void *)malloc_ptr;
+	malloc_ptr += size;
+
+	if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
+		error("Out of memory");
+
+	malloc_count++;
+	return p;
+}
+
+static void free(void *where)
+{
+	malloc_count--;
+	if (!malloc_count)
+		malloc_ptr = free_mem_ptr;
+}
+
+#define large_malloc(a) malloc(a)
+#define large_free(a) free(a)
+
+#define set_error_fn(x)
+#define panic error
+
+#define INIT
+
+#else /* NO_INFLATE_MALLOC */
+
+/* Code active when compiled standalone for use when loading ramdisk: */
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/vmalloc.h>
+
+/* Use defines rather than static inline in order to avoid spurious
+ * warnings when not needed (indeed large_malloc / large_free are not
+ * needed by inflate */
+
+#define malloc(a) kmalloc(a, GFP_KERNEL)
+#define free(a) kfree(a)
+
+#define large_malloc(a) vmalloc(a)
+#define large_free(a) vfree(a)
+
+#if 0 /* temporarily disable this section until generic is patched */
+static void(*error)(char *m);
+#define set_error_fn(x) error = x;
+
+#define INIT __init
+#define STATIC
+#endif /* 0 */
+
+#include <linux/init.h>
+
+#endif /* NO_INFLATE_MALLOC */
+
+#endif /* DECOMPR_MM_H */
diff -urNp base/include/linux/decompress/unlzma.h library/include/linux/decompress/unlzma.h
--- base/include/linux/decompress/unlzma.h	1970-01-01 01:00:00.000000000 +0100
+++ library/include/linux/decompress/unlzma.h	2008-10-13 22:24:00.000000000 +0200
@@ -0,0 +1,12 @@
+#ifndef DECOMPRESS_UNLZMA_H
+#define DECOMPRESS_UNLZMA_H
+
+int unlzma(unsigned char *, int,
+	   int(*fill)(void*, unsigned int),
+	   int(*flush)(void*, unsigned int),
+	   unsigned char *output,
+	   int *posp,
+	   void(*error)(char *x)
+	);
+
+#endif
diff -urNp base/lib/decompress_bunzip2.c library/lib/decompress_bunzip2.c
--- base/lib/decompress_bunzip2.c	1970-01-01 01:00:00.000000000 +0100
+++ library/lib/decompress_bunzip2.c	2008-10-13 22:24:00.000000000 +0200
@@ -0,0 +1,735 @@
+/* vi: set sw = 4 ts = 4: */
+/*	Small bzip2 deflate implementation, by Rob Landley (rob@landley.net).
+
+	Based on bzip2 decompression code by Julian R Seward (jseward@acm.org),
+	which also acknowledges contributions by Mike Burrows, David Wheeler,
+	Peter Fenwick, Alistair Moffat, Radford Neal, Ian H. Witten,
+	Robert Sedgewick, and Jon L. Bentley.
+
+	This code is licensed under the LGPLv2:
+		LGPL (http://www.gnu.org/copyleft/lgpl.html
+*/
+
+/*
+	Size and speed optimizations by Manuel Novoa III  (mjn3@codepoet.org).
+
+	More efficient reading of Huffman codes, a streamlined read_bunzip()
+	function, and various other tweaks.  In (limited) tests, approximately
+	20% faster than bzcat on x86 and about 10% faster on arm.
+
+	Note that about 2/3 of the time is spent in read_unzip() reversing
+	the Burrows-Wheeler transformation.  Much of that time is delay
+	resulting from cache misses.
+
+	I would ask that anyone benefiting from this work, especially those
+	using it in commercial products, consider making a donation to my local
+	non-profit hospice organization in the name of the woman I loved, who
+	passed away Feb. 12, 2003.
+
+		In memory of Toni W. Hagan
+
+		Hospice of Acadiana, Inc.
+		2600 Johnston St., Suite 200
+		Lafayette, LA 70503-3240
+
+		Phone (337) 232-1234 or 1-800-738-2226
+		Fax   (337) 232-1297
+
+		http://www.hospiceacadiana.com/
+
+	Manuel
+ */
+
+/*
+	Made it fit for running in Linux Kernel by Alain Knaff (alain@knaff.lu)
+*/
+
+
+#ifndef STATIC
+#include <linux/decompress/bunzip2.h>
+#endif /* !STATIC */
+
+#include <linux/decompress/mm.h>
+
+#ifndef INT_MAX
+#define INT_MAX 0x7fffffff
+#endif
+
+/* Constants for Huffman coding */
+#define MAX_GROUPS		6
+#define GROUP_SIZE   		50	/* 64 would have been more efficient */
+#define MAX_HUFCODE_BITS 	20	/* Longest Huffman code allowed */
+#define MAX_SYMBOLS 		258	/* 256 literals + RUNA + RUNB */
+#define SYMBOL_RUNA		0
+#define SYMBOL_RUNB		1
+
+/* Status return values */
+#define RETVAL_OK			0
+#define RETVAL_LAST_BLOCK		(-1)
+#define RETVAL_NOT_BZIP_DATA		(-2)
+#define RETVAL_UNEXPECTED_INPUT_EOF	(-3)
+#define RETVAL_UNEXPECTED_OUTPUT_EOF	(-4)
+#define RETVAL_DATA_ERROR		(-5)
+#define RETVAL_OUT_OF_MEMORY		(-6)
+#define RETVAL_OBSOLETE_INPUT		(-7)
+
+/* Other housekeeping constants */
+#define BZIP2_IOBUF_SIZE		4096
+
+/* This is what we know about each Huffman coding group */
+struct group_data {
+	/* We have an extra slot at the end of limit[] for a sentinal value. */
+	int limit[MAX_HUFCODE_BITS+1];
+	int base[MAX_HUFCODE_BITS];
+	int permute[MAX_SYMBOLS];
+	int minLen, maxLen;
+};
+
+/* Structure holding all the housekeeping data, including IO buffers and
+   memory that persists between calls to bunzip */
+struct bunzip_data {
+	/* State for interrupting output loop */
+	int writeCopies, writePos, writeRunCountdown, writeCount, writeCurrent;
+	/* I/O tracking data (file handles, buffers, positions, etc.) */
+	int (*fill)(void*, unsigned int);
+	int inbufCount, inbufPos /*, outbufPos*/;
+	unsigned char *inbuf /*,*outbuf*/;
+	unsigned int inbufBitCount, inbufBits;
+	/* The CRC values stored in the block header and calculated from the
+	data */
+	unsigned int crc32Table[256], headerCRC, totalCRC, writeCRC;
+	/* Intermediate buffer and its size (in bytes) */
+	unsigned int *dbuf, dbufSize;
+	/* These things are a bit too big to go on the stack */
+	unsigned char selectors[32768];		/* nSelectors = 15 bits */
+	struct group_data groups[MAX_GROUPS];	/* Huffman coding tables */
+	int io_error;			/* non-zero if we have IO error */
+};
+
+
+/* Return the next nnn bits of input.  All reads from the compressed input
+   are done through this function.  All reads are big endian */
+static unsigned int INIT get_bits(struct bunzip_data *bd, char bits_wanted)
+{
+	unsigned int bits = 0;
+
+	/* If we need to get more data from the byte buffer, do so.
+	   (Loop getting one byte at a time to enforce endianness and avoid
+	   unaligned access.) */
+	while (bd->inbufBitCount < bits_wanted) {
+		/* If we need to read more data from file into byte buffer, do
+		   so */
+		if (bd->inbufPos == bd->inbufCount) {
+			if (bd->io_error)
+				return 0;
+			bd->inbufCount = bd->fill(bd->inbuf, BZIP2_IOBUF_SIZE);
+			if (bd->inbufCount <= 0) {
+				bd->io_error = RETVAL_UNEXPECTED_INPUT_EOF;
+				return 0;
+			}
+			bd->inbufPos = 0;
+		}
+		/* Avoid 32-bit overflow (dump bit buffer to top of output) */
+		if (bd->inbufBitCount >= 24) {
+			bits = bd->inbufBits&((1 << bd->inbufBitCount)-1);
+			bits_wanted -= bd->inbufBitCount;
+			bits <<= bits_wanted;
+			bd->inbufBitCount = 0;
+		}
+		/* Grab next 8 bits of input from buffer. */
+		bd->inbufBits = (bd->inbufBits << 8)|bd->inbuf[bd->inbufPos++];
+		bd->inbufBitCount += 8;
+	}
+	/* Calculate result */
+	bd->inbufBitCount -= bits_wanted;
+	bits |= (bd->inbufBits >> bd->inbufBitCount)&((1 << bits_wanted)-1);
+
+	return bits;
+}
+
+/* Unpacks the next block and sets up for the inverse burrows-wheeler step. */
+
+static int INIT get_next_block(struct bunzip_data *bd)
+{
+	struct group_data *hufGroup = NULL;
+	int *base = NULL;
+	int *limit = NULL;
+	int dbufCount, nextSym, dbufSize, groupCount, selector,
+		i, j, k, t, runPos, symCount, symTotal, nSelectors,
+		byteCount[256];
+	unsigned char uc, symToByte[256], mtfSymbol[256], *selectors;
+	unsigned int *dbuf, origPtr;
+
+	dbuf = bd->dbuf;
+	dbufSize = bd->dbufSize;
+	selectors = bd->selectors;
+
+	/* Read in header signature and CRC, then validate signature.
+	   (last block signature means CRC is for whole file, return now) */
+	i = get_bits(bd, 24);
+	j = get_bits(bd, 24);
+	bd->headerCRC = get_bits(bd, 32);
+	if ((i == 0x177245) && (j == 0x385090))
+		return RETVAL_LAST_BLOCK;
+	if ((i != 0x314159) || (j != 0x265359))
+		return RETVAL_NOT_BZIP_DATA;
+	/* We can add support for blockRandomised if anybody complains.
+	   There was some code for this in busybox 1.0.0-pre3, but nobody ever
+	   noticed that it didn't actually work. */
+	if (get_bits(bd, 1))
+		return RETVAL_OBSOLETE_INPUT;
+	origPtr = get_bits(bd, 24);
+	if (origPtr > dbufSize)
+		return RETVAL_DATA_ERROR;
+	/* mapping table: if some byte values are never used (encoding things
+	   like ascii text), the compression code removes the gaps to have fewer
+	   symbols to deal with, and writes a sparse bitfield indicating which
+	   values were present.  We make a translation table to convert the
+	   symbols back to the corresponding bytes. */
+	t = get_bits(bd, 16);
+	symTotal = 0;
+	for (i = 0; i < 16; i++) {
+		if (t&(1 << (15-i))) {
+			k = get_bits(bd, 16);
+			for (j = 0; j < 16; j++)
+				if (k&(1 << (15-j)))
+					symToByte[symTotal++] = (16*i)+j;
+		}
+	}
+	/* How many different Huffman coding groups does this block use? */
+	groupCount = get_bits(bd, 3);
+	if (groupCount < 2 || groupCount > MAX_GROUPS)
+		return RETVAL_DATA_ERROR;
+	/* nSelectors: Every GROUP_SIZE many symbols we select a new
+	   Huffman coding group.  Read in the group selector list,
+	   which is stored as MTF encoded bit runs.  (MTF = Move To
+	   Front, as each value is used it's moved to the start of the
+	   list.) */
+	nSelectors = get_bits(bd, 15);
+	if (!nSelectors)
+		return RETVAL_DATA_ERROR;
+	for (i = 0; i < groupCount; i++)
+		mtfSymbol[i] = i;
+	for (i = 0; i < nSelectors; i++) {
+		/* Get next value */
+		for (j = 0; get_bits(bd, 1); j++)
+			if (j >= groupCount)
+				return RETVAL_DATA_ERROR;
+		/* Decode MTF to get the next selector */
+		uc = mtfSymbol[j];
+		for (; j; j--)
+			mtfSymbol[j] = mtfSymbol[j-1];
+		mtfSymbol[0] = selectors[i] = uc;
+	}
+	/* Read the Huffman coding tables for each group, which code
+	   for symTotal literal symbols, plus two run symbols (RUNA,
+	   RUNB) */
+	symCount = symTotal+2;
+	for (j = 0; j < groupCount; j++) {
+		unsigned char length[MAX_SYMBOLS], temp[MAX_HUFCODE_BITS+1];
+		int	minLen,	maxLen, pp;
+		/* Read Huffman code lengths for each symbol.  They're
+		   stored in a way similar to mtf; record a starting
+		   value for the first symbol, and an offset from the
+		   previous value for everys symbol after that.
+		   (Subtracting 1 before the loop and then adding it
+		   back at the end is an optimization that makes the
+		   test inside the loop simpler: symbol length 0
+		   becomes negative, so an unsigned inequality catches
+		   it.) */
+		t = get_bits(bd, 5)-1;
+		for (i = 0; i < symCount; i++) {
+			for (;;) {
+				if (((unsigned)t) > (MAX_HUFCODE_BITS-1))
+					return RETVAL_DATA_ERROR;
+
+				/* If first bit is 0, stop.  Else
+				   second bit indicates whether to
+				   increment or decrement the value.
+				   Optimization: grab 2 bits and unget
+				   the second if the first was 0. */
+
+				k = get_bits(bd, 2);
+				if (k < 2) {
+					bd->inbufBitCount++;
+					break;
+				}
+				/* Add one if second bit 1, else
+				 * subtract 1.  Avoids if/else */
+				t += (((k+1)&2)-1);
+			}
+			/* Correct for the initial -1, to get the
+			 * final symbol length */
+			length[i] = t+1;
+		}
+		/* Find largest and smallest lengths in this group */
+		minLen = maxLen = length[0];
+
+		for (i = 1; i < symCount; i++) {
+			if (length[i] > maxLen)
+				maxLen = length[i];
+			else if (length[i] < minLen)
+				minLen = length[i];
+		}
+
+		/* Calculate permute[], base[], and limit[] tables from
+		 * length[].
+		 *
+		 * permute[] is the lookup table for converting
+		 * Huffman coded symbols into decoded symbols.  base[]
+		 * is the amount to subtract from the value of a
+		 * Huffman symbol of a given length when using
+		 * permute[].
+		 *
+		 * limit[] indicates the largest numerical value a
+		 * symbol with a given number of bits can have.  This
+		 * is how the Huffman codes can vary in length: each
+		 * code with a value > limit[length] needs another
+		 * bit.
+		 */
+		hufGroup = bd->groups+j;
+		hufGroup->minLen = minLen;
+		hufGroup->maxLen = maxLen;
+		/* Note that minLen can't be smaller than 1, so we
+		   adjust the base and limit array pointers so we're
+		   not always wasting the first entry.  We do this
+		   again when using them (during symbol decoding).*/
+		base = hufGroup->base-1;
+		limit = hufGroup->limit-1;
+		/* Calculate permute[].  Concurently, initialize
+		 * temp[] and limit[]. */
+		pp = 0;
+		for (i = minLen; i <= maxLen; i++) {
+			temp[i] = limit[i] = 0;
+			for (t = 0; t < symCount; t++)
+				if (length[t] == i)
+					hufGroup->permute[pp++] = t;
+		}
+		/* Count symbols coded for at each bit length */
+		for (i = 0; i < symCount; i++)
+			temp[length[i]]++;
+		/* Calculate limit[] (the largest symbol-coding value
+		 *at each bit length, which is (previous limit <<
+		 *1)+symbols at this level), and base[] (number of
+		 *symbols to ignore at each bit length, which is limit
+		 *minus the cumulative count of symbols coded for
+		 *already). */
+		pp = t = 0;
+		for (i = minLen; i < maxLen; i++) {
+			pp += temp[i];
+			/* We read the largest possible symbol size
+			   and then unget bits after determining how
+			   many we need, and those extra bits could be
+			   set to anything.  (They're noise from
+			   future symbols.)  At each level we're
+			   really only interested in the first few
+			   bits, so here we set all the trailing
+			   to-be-ignored bits to 1 so they don't
+			   affect the value > limit[length]
+			   comparison. */
+			limit[i] = (pp << (maxLen - i)) - 1;
+			pp <<= 1;
+			base[i+1] = pp-(t += temp[i]);
+		}
+		limit[maxLen+1] = INT_MAX; /* Sentinal value for
+					    * reading next sym. */
+		limit[maxLen] = pp+temp[maxLen]-1;
+		base[minLen] = 0;
+	}
+	/* We've finished reading and digesting the block header.  Now
+	   read this block's Huffman coded symbols from the file and
+	   undo the Huffman coding and run length encoding, saving the
+	   result into dbuf[dbufCount++] = uc */
+
+	/* Initialize symbol occurrence counters and symbol Move To
+	 * Front table */
+	for (i = 0; i < 256; i++) {
+		byteCount[i] = 0;
+		mtfSymbol[i] = (unsigned char)i;
+	}
+	/* Loop through compressed symbols. */
+	runPos = dbufCount = symCount = selector = 0;
+	for (;;) {
+		/* Determine which Huffman coding group to use. */
+		if (!(symCount--)) {
+			symCount = GROUP_SIZE-1;
+			if (selector >= nSelectors)
+				return RETVAL_DATA_ERROR;
+			hufGroup = bd->groups+selectors[selector++];
+			base = hufGroup->base-1;
+			limit = hufGroup->limit-1;
+		}
+		/* Read next Huffman-coded symbol. */
+		/* Note: It is far cheaper to read maxLen bits and
+		   back up than it is to read minLen bits and then an
+		   additional bit at a time, testing as we go.
+		   Because there is a trailing last block (with file
+		   CRC), there is no danger of the overread causing an
+		   unexpected EOF for a valid compressed file.  As a
+		   further optimization, we do the read inline
+		   (falling back to a call to get_bits if the buffer
+		   runs dry).  The following (up to got_huff_bits:) is
+		   equivalent to j = get_bits(bd, hufGroup->maxLen);
+		 */
+		while (bd->inbufBitCount < hufGroup->maxLen) {
+			if (bd->inbufPos == bd->inbufCount) {
+				j = get_bits(bd, hufGroup->maxLen);
+				goto got_huff_bits;
+			}
+			bd->inbufBits =
+				(bd->inbufBits << 8)|bd->inbuf[bd->inbufPos++];
+			bd->inbufBitCount += 8;
+		};
+		bd->inbufBitCount -= hufGroup->maxLen;
+		j = (bd->inbufBits >> bd->inbufBitCount)&
+			((1 << hufGroup->maxLen)-1);
+got_huff_bits:
+		/* Figure how how many bits are in next symbol and
+		 * unget extras */
+		i = hufGroup->minLen;
+		while (j > limit[i])
+			++i;
+		bd->inbufBitCount += (hufGroup->maxLen - i);
+		/* Huffman decode value to get nextSym (with bounds checking) */
+		if ((i > hufGroup->maxLen)
+			|| (((unsigned)(j = (j>>(hufGroup->maxLen-i))-base[i]))
+				>= MAX_SYMBOLS))
+			return RETVAL_DATA_ERROR;
+		nextSym = hufGroup->permute[j];
+		/* We have now decoded the symbol, which indicates
+		   either a new literal byte, or a repeated run of the
+		   most recent literal byte.  First, check if nextSym
+		   indicates a repeated run, and if so loop collecting
+		   how many times to repeat the last literal. */
+		if (((unsigned)nextSym) <= SYMBOL_RUNB) { /* RUNA or RUNB */
+			/* If this is the start of a new run, zero out
+			 * counter */
+			if (!runPos) {
+				runPos = 1;
+				t = 0;
+			}
+			/* Neat trick that saves 1 symbol: instead of
+			   or-ing 0 or 1 at each bit position, add 1
+			   or 2 instead.  For example, 1011 is 1 << 0
+			   + 1 << 1 + 2 << 2.  1010 is 2 << 0 + 2 << 1
+			   + 1 << 2.  You can make any bit pattern
+			   that way using 1 less symbol than the basic
+			   or 0/1 method (except all bits 0, which
+			   would use no symbols, but a run of length 0
+			   doesn't mean anything in this context).
+			   Thus space is saved. */
+			t += (runPos << nextSym);
+			/* +runPos if RUNA; +2*runPos if RUNB */
+
+			runPos <<= 1;
+			continue;
+		}
+		/* When we hit the first non-run symbol after a run,
+		   we now know how many times to repeat the last
+		   literal, so append that many copies to our buffer
+		   of decoded symbols (dbuf) now.  (The last literal
+		   used is the one at the head of the mtfSymbol
+		   array.) */
+		if (runPos) {
+			runPos = 0;
+			if (dbufCount+t >= dbufSize)
+				return RETVAL_DATA_ERROR;
+
+			uc = symToByte[mtfSymbol[0]];
+			byteCount[uc] += t;
+			while (t--)
+				dbuf[dbufCount++] = uc;
+		}
+		/* Is this the terminating symbol? */
+		if (nextSym > symTotal)
+			break;
+		/* At this point, nextSym indicates a new literal
+		   character.  Subtract one to get the position in the
+		   MTF array at which this literal is currently to be
+		   found.  (Note that the result can't be -1 or 0,
+		   because 0 and 1 are RUNA and RUNB.  But another
+		   instance of the first symbol in the mtf array,
+		   position 0, would have been handled as part of a
+		   run above.  Therefore 1 unused mtf position minus 2
+		   non-literal nextSym values equals -1.) */
+		if (dbufCount >= dbufSize)
+			return RETVAL_DATA_ERROR;
+		i = nextSym - 1;
+		uc = mtfSymbol[i];
+		/* Adjust the MTF array.  Since we typically expect to
+		 *move only a small number of symbols, and are bound
+		 *by 256 in any case, using memmove here would
+		 *typically be bigger and slower due to function call
+		 *overhead and other assorted setup costs. */
+		do {
+			mtfSymbol[i] = mtfSymbol[i-1];
+		} while (--i);
+		mtfSymbol[0] = uc;
+		uc = symToByte[uc];
+		/* We have our literal byte.  Save it into dbuf. */
+		byteCount[uc]++;
+		dbuf[dbufCount++] = (unsigned int)uc;
+	}
+	/* At this point, we've read all the Huffman-coded symbols
+	   (and repeated runs) for this block from the input stream,
+	   and decoded them into the intermediate buffer.  There are
+	   dbufCount many decoded bytes in dbuf[].  Now undo the
+	   Burrows-Wheeler transform on dbuf.  See
+	   http://dogma.net/markn/articles/bwt/bwt.htm
+	 */
+	/* Turn byteCount into cumulative occurrence counts of 0 to n-1. */
+	j = 0;
+	for (i = 0; i < 256; i++) {
+		k = j+byteCount[i];
+		byteCount[i] = j;
+		j = k;
+	}
+	/* Figure out what order dbuf would be in if we sorted it. */
+	for (i = 0; i < dbufCount; i++) {
+		uc = (unsigned char)(dbuf[i] & 0xff);
+		dbuf[byteCount[uc]] |= (i << 8);
+		byteCount[uc]++;
+	}
+	/* Decode first byte by hand to initialize "previous" byte.
+	   Note that it doesn't get output, and if the first three
+	   characters are identical it doesn't qualify as a run (hence
+	   writeRunCountdown = 5). */
+	if (dbufCount) {
+		if (origPtr >= dbufCount)
+			return RETVAL_DATA_ERROR;
+		bd->writePos = dbuf[origPtr];
+		bd->writeCurrent = (unsigned char)(bd->writePos&0xff);
+		bd->writePos >>= 8;
+		bd->writeRunCountdown = 5;
+	}
+	bd->writeCount = dbufCount;
+
+	return RETVAL_OK;
+}
+
+/* Undo burrows-wheeler transform on intermediate buffer to produce output.
+   If start_bunzip was initialized with out_fd =-1, then up to len bytes of
+   data are written to outbuf.  Return value is number of bytes written or
+   error (all errors are negative numbers).  If out_fd!=-1, outbuf and len
+   are ignored, data is written to out_fd and return is RETVAL_OK or error.
+*/
+
+static int INIT read_bunzip(struct bunzip_data *bd, char *outbuf, int len)
+{
+	const unsigned int *dbuf;
+	int pos, xcurrent, previous, gotcount;
+
+	/* If last read was short due to end of file, return last block now */
+	if (bd->writeCount < 0)
+		return bd->writeCount;
+
+	gotcount = 0;
+	dbuf = bd->dbuf;
+	pos = bd->writePos;
+	xcurrent = bd->writeCurrent;
+
+	/* We will always have pending decoded data to write into the output
+	   buffer unless this is the very first call (in which case we haven't
+	   Huffman-decoded a block into the intermediate buffer yet). */
+
+	if (bd->writeCopies) {
+		/* Inside the loop, writeCopies means extra copies (beyond 1) */
+		--bd->writeCopies;
+		/* Loop outputting bytes */
+		for (;;) {
+			/* If the output buffer is full, snapshot
+			 * state and return */
+			if (gotcount >= len) {
+				bd->writePos = pos;
+				bd->writeCurrent = xcurrent;
+				bd->writeCopies++;
+				return len;
+			}
+			/* Write next byte into output buffer, updating CRC */
+			outbuf[gotcount++] = xcurrent;
+			bd->writeCRC = (((bd->writeCRC) << 8)
+				^bd->crc32Table[((bd->writeCRC) >> 24)
+				^xcurrent]);
+			/* Loop now if we're outputting multiple
+			 * copies of this byte */
+			if (bd->writeCopies) {
+				--bd->writeCopies;
+				continue;
+			}
+decode_next_byte:
+			if (!bd->writeCount--)
+				break;
+			/* Follow sequence vector to undo
+			 * Burrows-Wheeler transform */
+			previous = xcurrent;
+			pos = dbuf[pos];
+			xcurrent = pos&0xff;
+			pos >>= 8;
+			/* After 3 consecutive copies of the same
+			   byte, the 4th is a repeat count.  We count
+			   down from 4 instead *of counting up because
+			   testing for non-zero is faster */
+			if (--bd->writeRunCountdown) {
+				if (xcurrent != previous)
+					bd->writeRunCountdown = 4;
+			} else {
+				/* We have a repeated run, this byte
+				 * indicates the count */
+				bd->writeCopies = xcurrent;
+				xcurrent = previous;
+				bd->writeRunCountdown = 5;
+				/* Sometimes there are just 3 bytes
+				 * (run length 0) */
+				if (!bd->writeCopies)
+					goto decode_next_byte;
+				/* Subtract the 1 copy we'd output
+				 * anyway to get extras */
+				--bd->writeCopies;
+			}
+		}
+		/* Decompression of this block completed successfully */
+		bd->writeCRC = ~bd->writeCRC;
+		bd->totalCRC = ((bd->totalCRC << 1) |
+				(bd->totalCRC >> 31)) ^ bd->writeCRC;
+		/* If this block had a CRC error, force file level CRC error. */
+		if (bd->writeCRC != bd->headerCRC) {
+			bd->totalCRC = bd->headerCRC+1;
+			return RETVAL_LAST_BLOCK;
+		}
+	}
+
+	/* Refill the intermediate buffer by Huffman-decoding next
+	 * block of input */
+	/* (previous is just a convenient unused temp variable here) */
+	previous = get_next_block(bd);
+	if (previous) {
+		bd->writeCount = previous;
+		return (previous != RETVAL_LAST_BLOCK) ? previous : gotcount;
+	}
+	bd->writeCRC = 0xffffffffUL;
+	pos = bd->writePos;
+	xcurrent = bd->writeCurrent;
+	goto decode_next_byte;
+}
+
+static int INIT nofill(void *buf, unsigned int len)
+{
+	return -1;
+}
+
+/* Allocate the structure, read file header.  If in_fd ==-1, inbuf must contain
+   a complete bunzip file (len bytes long).  If in_fd!=-1, inbuf and len are
+   ignored, and data is read from file handle into temporary buffer. */
+static int INIT start_bunzip(struct bunzip_data **bdp, void *inbuf, int len,
+			     int (*fill)(void*, unsigned int))
+{
+	struct bunzip_data *bd;
+	unsigned int i, j, c;
+	const unsigned int BZh0 =
+		(((unsigned int)'B') << 24)+(((unsigned int)'Z') << 16)
+		+(((unsigned int)'h') << 8)+(unsigned int)'0';
+
+	/* Figure out how much data to allocate */
+	i = sizeof(struct bunzip_data);
+
+	/* Allocate bunzip_data.  Most fields initialize to zero. */
+	bd = *bdp = malloc(i);
+	memset(bd, 0, sizeof(struct bunzip_data));
+	/* Setup input buffer */
+	bd->inbuf = inbuf;
+	bd->inbufCount = len;
+	if (fill != NULL)
+		bd->fill = fill;
+	else
+		bd->fill = nofill;
+
+	/* Init the CRC32 table (big endian) */
+	for (i = 0; i < 256; i++) {
+		c = i << 24;
+		for (j = 8; j; j--)
+			c = c&0x80000000 ? (c << 1)^0x04c11db7 : (c << 1);
+		bd->crc32Table[i] = c;
+	}
+
+	/* Ensure that file starts with "BZh['1'-'9']." */
+	i = get_bits(bd, 32);
+	if (((unsigned int)(i-BZh0-1)) >= 9)
+		return RETVAL_NOT_BZIP_DATA;
+
+	/* Fourth byte (ascii '1'-'9'), indicates block size in units of 100k of
+	   uncompressed data.  Allocate intermediate buffer for block. */
+	bd->dbufSize = 100000*(i-BZh0);
+
+	bd->dbuf = large_malloc(bd->dbufSize * sizeof(int));
+	return RETVAL_OK;
+}
+
+/* Example usage: decompress src_fd to dst_fd.  (Stops at end of bzip2 data,
+   not end of file.) */
+STATIC int INIT bunzip2(unsigned char *buf, int len,
+			int(*fill)(void*, unsigned int),
+			int(*flush)(void*, unsigned int),
+			unsigned char *outbuf,
+			int *pos,
+			void(*error_fn)(char *x))
+{
+	struct bunzip_data *bd;
+	int i = -1;
+	unsigned char *inbuf;
+
+	set_error_fn(error_fn);
+	if (flush)
+		outbuf = malloc(BZIP2_IOBUF_SIZE);
+	else
+		len -= 4; /* Uncompressed size hack active in pre-boot
+			     environment */
+	if (!outbuf) {
+		error("Could not allocate output bufer");
+		return -1;
+	}
+	if (buf)
+		inbuf = buf;
+	else
+		inbuf = malloc(BZIP2_IOBUF_SIZE);
+	if (!inbuf) {
+		error("Could not allocate input bufer");
+		goto exit_0;
+	}
+	i = start_bunzip(&bd, inbuf, len, fill);
+	if (!i) {
+		for (;;) {
+			i = read_bunzip(bd, outbuf, BZIP2_IOBUF_SIZE);
+			if (i <= 0)
+				break;
+			if (!flush)
+				outbuf += i;
+			else
+				if (i != flush(outbuf, i)) {
+					i = RETVAL_UNEXPECTED_OUTPUT_EOF;
+					break;
+				}
+		}
+	}
+	/* Check CRC and release memory */
+	if (i == RETVAL_LAST_BLOCK) {
+		if (bd->headerCRC != bd->totalCRC)
+			error("Data integrity error when decompressing.");
+		else
+			i = RETVAL_OK;
+	} else if (i == RETVAL_UNEXPECTED_OUTPUT_EOF) {
+		error("Compressed file ends unexpectedly");
+	}
+	if (bd->dbuf)
+		large_free(bd->dbuf);
+	if (pos)
+		*pos = bd->inbufPos;
+	free(bd);
+	if (!buf)
+		free(inbuf);
+exit_0:
+	if (flush)
+		free(outbuf);
+	return i;
+}
+
+#define decompress bunzip2
diff -urNp base/lib/decompress_unlzma.c library/lib/decompress_unlzma.c
--- base/lib/decompress_unlzma.c	1970-01-01 01:00:00.000000000 +0100
+++ library/lib/decompress_unlzma.c	2008-10-13 22:24:00.000000000 +0200
@@ -0,0 +1,647 @@
+/* Lzma decompressor for Linux kernel. Shamelessly snarfed
+ *from busybox 1.1.1
+ *
+ *Linux kernel adaptation
+ *Copyright (C) 2006  Alain < alain@knaff.lu >
+ *
+ *Based on small lzma deflate implementation/Small range coder
+ *implementation for lzma.
+ *Copyright (C) 2006  Aurelien Jacobs < aurel@gnuage.org >
+ *
+ *Based on LzmaDecode.c from the LZMA SDK 4.22 (http://www.7-zip.org/)
+ *Copyright (C) 1999-2005  Igor Pavlov
+ *
+ *Copyrights of the parts, see headers below.
+ *
+ *
+ *This program is free software; you can redistribute it and/or
+ *modify it under the terms of the GNU Lesser General Public
+ *License as published by the Free Software Foundation; either
+ *version 2.1 of the License, or (at your option) any later version.
+ *
+ *This program is distributed in the hope that it will be useful,
+ *but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *Lesser General Public License for more details.
+ *
+ *You should have received a copy of the GNU Lesser General Public
+ *License along with this library; if not, write to the Free Software
+ *Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef STATIC
+#include <linux/decompress/unlzma.h>
+#endif /* STATIC */
+
+#include <linux/decompress/mm.h>
+
+#define	MIN(a, b) (((a) < (b)) ? (a) : (b))
+
+static long long INIT read_int(unsigned char *ptr, int size)
+{
+	int i;
+	long long ret = 0;
+
+	for (i = 0; i < size; i++)
+		ret = (ret << 8) | ptr[size-i-1];
+	return ret;
+}
+
+#define ENDIAN_CONVERT(x) \
+  x = (typeof(x))read_int((unsigned char *)&x, sizeof(x))
+
+
+/* Small range coder implementation for lzma.
+ *Copyright (C) 2006  Aurelien Jacobs < aurel@gnuage.org >
+ *
+ *Based on LzmaDecode.c from the LZMA SDK 4.22 (http://www.7-zip.org/)
+ *Copyright (c) 1999-2005  Igor Pavlov
+ */
+
+#include <linux/compiler.h>
+
+#define LZMA_IOBUF_SIZE	0x10000
+
+struct rc {
+	int (*fill)(void*, unsigned int);
+	uint8_t *ptr;
+	uint8_t *buffer;
+	uint8_t *buffer_end;
+	int buffer_size;
+	uint32_t code;
+	uint32_t range;
+	uint32_t bound;
+};
+
+
+#define RC_TOP_BITS 24
+#define RC_MOVE_BITS 5
+#define RC_MODEL_TOTAL_BITS 11
+
+
+/* Called twice: once at startup and once in rc_normalize() */
+static void INIT rc_read(struct rc *rc)
+{
+	rc->buffer_size = rc->fill((char *)rc->buffer, LZMA_IOBUF_SIZE);
+	if (rc->buffer_size <= 0)
+		error("unexpected EOF");
+	rc->ptr = rc->buffer;
+	rc->buffer_end = rc->buffer + rc->buffer_size;
+}
+
+/* Called once */
+static inline void INIT rc_init(struct rc *rc,
+				       int (*fill)(void*, unsigned int),
+				       char *buffer, int buffer_size)
+{
+	rc->fill = fill;
+	rc->buffer = (uint8_t *)buffer;
+	rc->buffer_size = buffer_size;
+	rc->buffer_end = rc->buffer + rc->buffer_size;
+	rc->ptr = rc->buffer;
+
+	rc->code = 0;
+	rc->range = 0xFFFFFFFF;
+}
+
+static inline void INIT rc_init_code(struct rc *rc)
+{
+	int i;
+
+	for (i = 0; i < 5; i++) {
+		if (rc->ptr >= rc->buffer_end)
+			rc_read(rc);
+		rc->code = (rc->code << 8) | *rc->ptr++;
+	}
+}
+
+
+/* Called once. TODO: bb_maybe_free() */
+static inline void INIT rc_free(struct rc *rc)
+{
+	free(rc->buffer);
+}
+
+/* Called twice, but one callsite is in inline'd rc_is_bit_0_helper() */
+static void INIT rc_do_normalize(struct rc *rc)
+{
+	if (rc->ptr >= rc->buffer_end)
+		rc_read(rc);
+	rc->range <<= 8;
+	rc->code = (rc->code << 8) | *rc->ptr++;
+}
+static inline void INIT rc_normalize(struct rc *rc)
+{
+	if (rc->range < (1 << RC_TOP_BITS))
+		rc_do_normalize(rc);
+}
+
+/* Called 9 times */
+/* Why rc_is_bit_0_helper exists?
+ *Because we want to always expose (rc->code < rc->bound) to optimizer
+ */
+static inline uint32_t INIT rc_is_bit_0_helper(struct rc *rc, uint16_t *p)
+{
+	rc_normalize(rc);
+	rc->bound = *p * (rc->range >> RC_MODEL_TOTAL_BITS);
+	return rc->bound;
+}
+static inline int INIT rc_is_bit_0(struct rc *rc, uint16_t *p)
+{
+	uint32_t t = rc_is_bit_0_helper(rc, p);
+	return rc->code < t;
+}
+
+/* Called ~10 times, but very small, thus inlined */
+static inline void INIT rc_update_bit_0(struct rc *rc, uint16_t *p)
+{
+	rc->range = rc->bound;
+	*p += ((1 << RC_MODEL_TOTAL_BITS) - *p) >> RC_MOVE_BITS;
+}
+static inline void rc_update_bit_1(struct rc *rc, uint16_t *p)
+{
+	rc->range -= rc->bound;
+	rc->code -= rc->bound;
+	*p -= *p >> RC_MOVE_BITS;
+}
+
+/* Called 4 times in unlzma loop */
+static int INIT rc_get_bit(struct rc *rc, uint16_t *p, int *symbol)
+{
+	if (rc_is_bit_0(rc, p)) {
+		rc_update_bit_0(rc, p);
+		*symbol *= 2;
+		return 0;
+	} else {
+		rc_update_bit_1(rc, p);
+		*symbol = *symbol * 2 + 1;
+		return 1;
+	}
+}
+
+/* Called once */
+static inline int INIT rc_direct_bit(struct rc *rc)
+{
+	rc_normalize(rc);
+	rc->range >>= 1;
+	if (rc->code >= rc->range) {
+		rc->code -= rc->range;
+		return 1;
+	}
+	return 0;
+}
+
+/* Called twice */
+static inline void INIT
+rc_bit_tree_decode(struct rc *rc, uint16_t *p, int num_levels, int *symbol)
+{
+	int i = num_levels;
+
+	*symbol = 1;
+	while (i--)
+		rc_get_bit(rc, p + *symbol, symbol);
+	*symbol -= 1 << num_levels;
+}
+
+
+/*
+ * Small lzma deflate implementation.
+ * Copyright (C) 2006  Aurelien Jacobs < aurel@gnuage.org >
+ *
+ * Based on LzmaDecode.c from the LZMA SDK 4.22 (http://www.7-zip.org/)
+ * Copyright (C) 1999-2005  Igor Pavlov
+ */
+
+
+struct lzma_header {
+	uint8_t pos;
+	uint32_t dict_size;
+	uint64_t dst_size;
+} __attribute__ ((packed)) ;
+
+
+#define LZMA_BASE_SIZE 1846
+#define LZMA_LIT_SIZE 768
+
+#define LZMA_NUM_POS_BITS_MAX 4
+
+#define LZMA_LEN_NUM_LOW_BITS 3
+#define LZMA_LEN_NUM_MID_BITS 3
+#define LZMA_LEN_NUM_HIGH_BITS 8
+
+#define LZMA_LEN_CHOICE 0
+#define LZMA_LEN_CHOICE_2 (LZMA_LEN_CHOICE + 1)
+#define LZMA_LEN_LOW (LZMA_LEN_CHOICE_2 + 1)
+#define LZMA_LEN_MID (LZMA_LEN_LOW \
+		      + (1 << (LZMA_NUM_POS_BITS_MAX + LZMA_LEN_NUM_LOW_BITS)))
+#define LZMA_LEN_HIGH (LZMA_LEN_MID \
+		       +(1 << (LZMA_NUM_POS_BITS_MAX + LZMA_LEN_NUM_MID_BITS)))
+#define LZMA_NUM_LEN_PROBS (LZMA_LEN_HIGH + (1 << LZMA_LEN_NUM_HIGH_BITS))
+
+#define LZMA_NUM_STATES 12
+#define LZMA_NUM_LIT_STATES 7
+
+#define LZMA_START_POS_MODEL_INDEX 4
+#define LZMA_END_POS_MODEL_INDEX 14
+#define LZMA_NUM_FULL_DISTANCES (1 << (LZMA_END_POS_MODEL_INDEX >> 1))
+
+#define LZMA_NUM_POS_SLOT_BITS 6
+#define LZMA_NUM_LEN_TO_POS_STATES 4
+
+#define LZMA_NUM_ALIGN_BITS 4
+
+#define LZMA_MATCH_MIN_LEN 2
+
+#define LZMA_IS_MATCH 0
+#define LZMA_IS_REP (LZMA_IS_MATCH + (LZMA_NUM_STATES << LZMA_NUM_POS_BITS_MAX))
+#define LZMA_IS_REP_G0 (LZMA_IS_REP + LZMA_NUM_STATES)
+#define LZMA_IS_REP_G1 (LZMA_IS_REP_G0 + LZMA_NUM_STATES)
+#define LZMA_IS_REP_G2 (LZMA_IS_REP_G1 + LZMA_NUM_STATES)
+#define LZMA_IS_REP_0_LONG (LZMA_IS_REP_G2 + LZMA_NUM_STATES)
+#define LZMA_POS_SLOT (LZMA_IS_REP_0_LONG \
+		       + (LZMA_NUM_STATES << LZMA_NUM_POS_BITS_MAX))
+#define LZMA_SPEC_POS (LZMA_POS_SLOT \
+		       +(LZMA_NUM_LEN_TO_POS_STATES << LZMA_NUM_POS_SLOT_BITS))
+#define LZMA_ALIGN (LZMA_SPEC_POS \
+		    + LZMA_NUM_FULL_DISTANCES - LZMA_END_POS_MODEL_INDEX)
+#define LZMA_LEN_CODER (LZMA_ALIGN + (1 << LZMA_NUM_ALIGN_BITS))
+#define LZMA_REP_LEN_CODER (LZMA_LEN_CODER + LZMA_NUM_LEN_PROBS)
+#define LZMA_LITERAL (LZMA_REP_LEN_CODER + LZMA_NUM_LEN_PROBS)
+
+
+struct writer {
+	uint8_t *buffer;
+	uint8_t previous_byte;
+	size_t buffer_pos;
+	int bufsize;
+	size_t global_pos;
+	int(*flush)(void*, unsigned int);
+	struct lzma_header *header;
+};
+
+struct cstate {
+	int state;
+	uint32_t rep0, rep1, rep2, rep3;
+};
+
+static inline size_t INIT get_pos(struct writer *wr)
+{
+	return
+		wr->global_pos + wr->buffer_pos;
+}
+
+static inline uint8_t INIT peek_old_byte(struct writer *wr,
+						uint32_t offs)
+{
+	if (!wr->flush) {
+		int32_t pos;
+		while (offs > wr->header->dict_size)
+			offs -= wr->header->dict_size;
+		pos = wr->buffer_pos - offs;
+		return wr->buffer[pos];
+	} else {
+		uint32_t pos = wr->buffer_pos - offs;
+		while (pos >= wr->header->dict_size)
+			pos += wr->header->dict_size;
+		return wr->buffer[pos];
+	}
+
+}
+
+static inline void INIT write_byte(struct writer *wr, uint8_t byte)
+{
+	wr->buffer[wr->buffer_pos++] = wr->previous_byte = byte;
+	if (wr->flush && wr->buffer_pos == wr->header->dict_size) {
+		wr->buffer_pos = 0;
+		wr->global_pos += wr->header->dict_size;
+		wr->flush((char *)wr->buffer, wr->header->dict_size);
+	}
+}
+
+
+static inline void INIT copy_byte(struct writer *wr, uint32_t offs)
+{
+	write_byte(wr, peek_old_byte(wr, offs));
+}
+
+static inline void INIT copy_bytes(struct writer *wr,
+					 uint32_t rep0, int len)
+{
+	do {
+		copy_byte(wr, rep0);
+		len--;
+	} while (len != 0 && wr->buffer_pos < wr->header->dst_size);
+}
+
+static inline void INIT process_bit0(struct writer *wr, struct rc *rc,
+				     struct cstate *cst, uint16_t *p,
+				     int pos_state, uint16_t *prob,
+				     int lc, uint32_t literal_pos_mask) {
+	int mi = 1;
+	rc_update_bit_0(rc, prob);
+	prob = (p + LZMA_LITERAL +
+		(LZMA_LIT_SIZE
+		 * (((get_pos(wr) & literal_pos_mask) << lc)
+		    + (wr->previous_byte >> (8 - lc))))
+		);
+
+	if (cst->state >= LZMA_NUM_LIT_STATES) {
+		int match_byte = peek_old_byte(wr, cst->rep0);
+		do {
+			int bit;
+			uint16_t *prob_lit;
+
+			match_byte <<= 1;
+			bit = match_byte & 0x100;
+			prob_lit = prob + 0x100 + bit + mi;
+			if (rc_get_bit(rc, prob_lit, &mi)) {
+				if (!bit)
+					break;
+			} else {
+				if (bit)
+					break;
+			}
+		} while (mi < 0x100);
+	}
+	while (mi < 0x100) {
+		uint16_t *prob_lit = prob + mi;
+		rc_get_bit(rc, prob_lit, &mi);
+	}
+	write_byte(wr, mi);
+	if (cst->state < 4)
+		cst->state = 0;
+	else if (cst->state < 10)
+		cst->state -= 3;
+	else
+		cst->state -= 6;
+}
+
+static inline void INIT process_bit1(struct writer *wr, struct rc *rc,
+					    struct cstate *cst, uint16_t *p,
+					    int pos_state, uint16_t *prob) {
+  int offset;
+	uint16_t *prob_len;
+	int num_bits;
+	int len;
+
+	rc_update_bit_1(rc, prob);
+	prob = p + LZMA_IS_REP + cst->state;
+	if (rc_is_bit_0(rc, prob)) {
+		rc_update_bit_0(rc, prob);
+		cst->rep3 = cst->rep2;
+		cst->rep2 = cst->rep1;
+		cst->rep1 = cst->rep0;
+		cst->state = cst->state < LZMA_NUM_LIT_STATES ? 0 : 3;
+		prob = p + LZMA_LEN_CODER;
+	} else {
+		rc_update_bit_1(rc, prob);
+		prob = p + LZMA_IS_REP_G0 + cst->state;
+		if (rc_is_bit_0(rc, prob)) {
+			rc_update_bit_0(rc, prob);
+			prob = (p + LZMA_IS_REP_0_LONG
+				+ (cst->state <<
+				   LZMA_NUM_POS_BITS_MAX) +
+				pos_state);
+			if (rc_is_bit_0(rc, prob)) {
+				rc_update_bit_0(rc, prob);
+
+				cst->state = cst->state < LZMA_NUM_LIT_STATES ?
+					9 : 11;
+				copy_byte(wr, cst->rep0);
+				return;
+			} else {
+				rc_update_bit_1(rc, prob);
+			}
+		} else {
+			uint32_t distance;
+
+			rc_update_bit_1(rc, prob);
+			prob = p + LZMA_IS_REP_G1 + cst->state;
+			if (rc_is_bit_0(rc, prob)) {
+				rc_update_bit_0(rc, prob);
+				distance = cst->rep1;
+			} else {
+				rc_update_bit_1(rc, prob);
+				prob = p + LZMA_IS_REP_G2 + cst->state;
+				if (rc_is_bit_0(rc, prob)) {
+					rc_update_bit_0(rc, prob);
+					distance = cst->rep2;
+				} else {
+					rc_update_bit_1(rc, prob);
+					distance = cst->rep3;
+					cst->rep3 = cst->rep2;
+				}
+				cst->rep2 = cst->rep1;
+			}
+			cst->rep1 = cst->rep0;
+			cst->rep0 = distance;
+		}
+		cst->state = cst->state < LZMA_NUM_LIT_STATES ? 8 : 11;
+		prob = p + LZMA_REP_LEN_CODER;
+	}
+
+	prob_len = prob + LZMA_LEN_CHOICE;
+	if (rc_is_bit_0(rc, prob_len)) {
+		rc_update_bit_0(rc, prob_len);
+		prob_len = (prob + LZMA_LEN_LOW
+			    + (pos_state <<
+			       LZMA_LEN_NUM_LOW_BITS));
+		offset = 0;
+		num_bits = LZMA_LEN_NUM_LOW_BITS;
+	} else {
+		rc_update_bit_1(rc, prob_len);
+		prob_len = prob + LZMA_LEN_CHOICE_2;
+		if (rc_is_bit_0(rc, prob_len)) {
+			rc_update_bit_0(rc, prob_len);
+			prob_len = (prob + LZMA_LEN_MID
+				    + (pos_state <<
+				       LZMA_LEN_NUM_MID_BITS));
+			offset = 1 << LZMA_LEN_NUM_LOW_BITS;
+			num_bits = LZMA_LEN_NUM_MID_BITS;
+		} else {
+			rc_update_bit_1(rc, prob_len);
+			prob_len = prob + LZMA_LEN_HIGH;
+			offset = ((1 << LZMA_LEN_NUM_LOW_BITS)
+				  + (1 << LZMA_LEN_NUM_MID_BITS));
+			num_bits = LZMA_LEN_NUM_HIGH_BITS;
+		}
+	}
+
+	rc_bit_tree_decode(rc, prob_len, num_bits, &len);
+	len += offset;
+
+	if (cst->state < 4) {
+		int pos_slot;
+
+		cst->state += LZMA_NUM_LIT_STATES;
+		prob =
+			p + LZMA_POS_SLOT +
+			((len <
+			  LZMA_NUM_LEN_TO_POS_STATES ? len :
+			  LZMA_NUM_LEN_TO_POS_STATES - 1)
+			 << LZMA_NUM_POS_SLOT_BITS);
+		rc_bit_tree_decode(rc, prob,
+				   LZMA_NUM_POS_SLOT_BITS,
+				   &pos_slot);
+		if (pos_slot >= LZMA_START_POS_MODEL_INDEX) {
+			int i, mi;
+			num_bits = (pos_slot >> 1) - 1;
+			cst->rep0 = 2 | (pos_slot & 1);
+			if (pos_slot < LZMA_END_POS_MODEL_INDEX) {
+				cst->rep0 <<= num_bits;
+				prob = p + LZMA_SPEC_POS +
+					cst->rep0 - pos_slot - 1;
+			} else {
+				num_bits -= LZMA_NUM_ALIGN_BITS;
+				while (num_bits--)
+					cst->rep0 = (cst->rep0 << 1) |
+						rc_direct_bit(rc);
+				prob = p + LZMA_ALIGN;
+				cst->rep0 <<= LZMA_NUM_ALIGN_BITS;
+				num_bits = LZMA_NUM_ALIGN_BITS;
+			}
+			i = 1;
+			mi = 1;
+			while (num_bits--) {
+				if (rc_get_bit(rc, prob + mi, &mi))
+					cst->rep0 |= i;
+				i <<= 1;
+			}
+		} else
+			cst->rep0 = pos_slot;
+		if (++(cst->rep0) == 0)
+			return;
+	}
+
+	len += LZMA_MATCH_MIN_LEN;
+
+	copy_bytes(wr, cst->rep0, len);
+}
+
+
+
+STATIC inline int INIT unlzma(unsigned char *buf, int in_len,
+			      int(*fill)(void*, unsigned int),
+			      int(*flush)(void*, unsigned int),
+			      unsigned char *output,
+			      int *posp,
+			      void(*error_fn)(char *x)
+	)
+{
+	struct lzma_header header;
+	int lc, pb, lp;
+	uint32_t pos_state_mask;
+	uint32_t literal_pos_mask;
+	uint16_t *p;
+	int num_probs;
+	struct rc rc;
+	int i, mi;
+	struct writer wr;
+	struct cstate cst;
+	unsigned char *inbuf;
+	int ret = -1;
+
+	set_error_fn(error_fn);
+	if (!flush)
+		in_len -= 4; /* Uncompressed size hack active in pre-boot
+				environment */
+	if (buf)
+		inbuf = buf;
+	else
+		inbuf = malloc(LZMA_IOBUF_SIZE);
+	if (!inbuf) {
+		error("Could not allocate input bufer");
+		goto exit_0;
+	}
+
+	cst.state = 0;
+	cst.rep0 = cst.rep1 = cst.rep2 = cst.rep3 = 1;
+
+	wr.header = &header;
+	wr.flush = flush;
+	wr.global_pos = 0;
+	wr.previous_byte = 0;
+	wr.buffer_pos = 0;
+
+	rc_init(&rc, fill, inbuf, in_len);
+
+	for (i = 0; i < sizeof(header); i++) {
+		if (rc.ptr >= rc.buffer_end)
+			rc_read(&rc);
+		((unsigned char *)&header)[i] = *rc.ptr++;
+	}
+
+	if (header.pos >= (9 * 5 * 5))
+		error("bad header");
+
+	mi = 0;
+	lc = header.pos;
+	while (lc >= 9) {
+		mi++;
+		lc -= 9;
+	}
+	pb = 0;
+	lp = mi;
+	while (lp >= 5) {
+		pb++;
+		lp -= 5;
+	}
+	pos_state_mask = (1 << pb) - 1;
+	literal_pos_mask = (1 << lp) - 1;
+
+	ENDIAN_CONVERT(header.dict_size);
+	ENDIAN_CONVERT(header.dst_size);
+
+	if (header.dict_size == 0)
+		header.dict_size = 1;
+
+	if (output)
+		wr.buffer = output;
+	else {
+		wr.bufsize = MIN(header.dst_size, header.dict_size);
+		wr.buffer = large_malloc(wr.bufsize);
+	}
+	if (wr.buffer == NULL)
+		goto exit_1;
+
+	num_probs = LZMA_BASE_SIZE + (LZMA_LIT_SIZE << (lc + lp));
+	p = (uint16_t *) large_malloc(num_probs * sizeof(*p));
+	if (p == 0)
+		goto exit_2;
+	num_probs = LZMA_LITERAL + (LZMA_LIT_SIZE << (lc + lp));
+	for (i = 0; i < num_probs; i++)
+		p[i] = (1 << RC_MODEL_TOTAL_BITS) >> 1;
+
+	rc_init_code(&rc);
+
+	while (get_pos(&wr) < header.dst_size) {
+		int pos_state =	get_pos(&wr) & pos_state_mask;
+		uint16_t *prob = p + LZMA_IS_MATCH +
+			(cst.state << LZMA_NUM_POS_BITS_MAX) + pos_state;
+		if (rc_is_bit_0(&rc, prob))
+			process_bit0(&wr, &rc, &cst, p, pos_state, prob,
+				     lc, literal_pos_mask);
+		else {
+			process_bit1(&wr, &rc, &cst, p, pos_state, prob);
+			if (cst.rep0 == 0)
+				break;
+		}
+	}
+
+	if (posp)
+		*posp = rc.ptr-rc.buffer;
+	if (wr.flush)
+		wr.flush(wr.buffer, wr.buffer_pos);
+	ret = 0;
+	large_free(p);
+exit_2:
+	if (!output)
+		large_free(wr.buffer);
+exit_1:
+	if (!buf)
+		free(inbuf);
+exit_0:
+	return ret;
+}
+
+#define decompress unlzma
diff -urNp base/lib/inflate.c library/lib/inflate.c
--- base/lib/inflate.c	2008-10-11 14:12:10.000000000 +0200
+++ library/lib/inflate.c	2008-10-14 01:19:20.000000000 +0200
@@ -109,20 +109,78 @@ static char rcsid[] = "#Id: inflate.c,v 
 #endif
 
 #ifndef STATIC
+#include <linux/decompress/inflate.h>
+#endif /* ! STATIC */
 
-#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
-#  include <sys/types.h>
-#  include <stdlib.h>
+#include <linux/decompress/mm.h>
+
+#include <linux/string.h>
+
+#ifdef NEW_CODE
+static int(*flush_cb)(void*, unsigned int);
+static int(*fill_cb)(void*, unsigned int);
+
+/* Begin stuff copied from initramfs */
+/*
+ * gzip declarations
+ */
+
+#define OF(args)  args
+
+#ifndef memzero
+#define memzero(s, n)     memset((s), 0, (n))
 #endif
 
-#include "gzip.h"
-#define STATIC
-#endif /* !STATIC */
+#define INBUFSIZ 4096
+
+#define WSIZE 0x8000    /* window size--must be a power of two, and */
+			/*  at least 32K for zip's deflate method */
+
+static uint8_t *inbuf;
+static uint8_t *window;
+
+static unsigned insize;  /* valid bytes in inbuf */
+static unsigned outcnt;  /* bytes in output buffer */
+static long bytes_out;
+
+/* --- */
+
+static unsigned inptr;   /* index of next byte to be processed in inbuf */
+
+/* --- */
+
+/* ===========================================================================
+ * Fill the input buffer. This is called only when the buffer is empty
+ * and at least one byte is really needed.
+ * Returning -1 does not guarantee that gunzip() will ever return.
+ */
+static int INIT fill_inbuf(void)
+{
+	insize = fill_cb(inbuf, INBUFSIZ);
+	if (insize <= 0) {
+		error("RAMDISK: ran out of compressed data");
+		return -1;
+	}
+
+	inptr = 1;
+
+	return inbuf[0];
+}
+
+#define get_byte()  (inptr < insize ? inbuf[inptr++] : fill_inbuf())
+
+/* Diagnostic functions (stubbed out) */
+#define Assert(cond, msg)
+#define Trace(x)
+#define Tracev(x)
+#define Tracevv(x)
+#define Tracec(c, x)
+#define Tracecv(c, x)
 
-#ifndef INIT
-#define INIT
+static void flush_window(void);
+/* End stuff copied from initramfs */
 #endif
-	
+
 #define slide window
 
 /* Huffman code lookup table entry--this entry is four bytes for machines
@@ -133,10 +191,10 @@ static char rcsid[] = "#Id: inflate.c,v 
    an unused code.  If a code with e == 99 is looked up, this implies an
    error in the data. */
 struct huft {
-  uch e;                /* number of extra bits or operation */
-  uch b;                /* number of bits in this code or subcode */
+  uint8_t e;                /* number of extra bits or operation */
+  uint8_t b;                /* number of bits in this code or subcode */
   union {
-    ush n;              /* literal, length base, or distance base */
+    uint16_t n;              /* literal, length base, or distance base */
     struct huft *t;     /* pointer to next level of table */
   } v;
 };
@@ -144,7 +202,7 @@ struct huft {
 
 /* Function prototypes */
 STATIC int INIT huft_build OF((unsigned *, unsigned, unsigned, 
-		const ush *, const ush *, struct huft **, int *));
+		const uint16_t *, const uint16_t *, struct huft **, int *));
 STATIC int INIT huft_free OF((struct huft *));
 STATIC int INIT inflate_codes OF((struct huft *, struct huft *, int, int));
 STATIC int INIT inflate_stored OF((void));
@@ -159,28 +217,28 @@ STATIC int INIT inflate OF((void));
    circular buffer.  The index is updated simply by incrementing and then
    ANDing with 0x7fff (32K-1). */
 /* It is left to other modules to supply the 32 K area.  It is assumed
-   to be usable as if it were declared "uch slide[32768];" or as just
-   "uch *slide;" and then malloc'ed in the latter case.  The definition
+   to be usable as if it were declared "uint8_t slide[32768];" or as just
+   "uint8_t *slide;" and then malloc'ed in the latter case.  The definition
    must be in unzip.h, included above. */
 /* unsigned wp;             current position in slide */
 #define wp outcnt
 #define flush_output(w) (wp=(w),flush_window())
 
 /* Tables for deflate from PKZIP's appnote.txt. */
-static const unsigned border[] = {    /* Order of the bit length code lengths */
+static const unsigned border[] = {   /* Order of the bit length code lengths */
         16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15};
-static const ush cplens[] = {         /* Copy lengths for literal codes 257..285 */
+static const uint16_t cplens[] = { /* Copy lengths for literal codes 257..285 */
         3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31,
         35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258, 0, 0};
         /* note: see note #13 above about the 258 in this list. */
-static const ush cplext[] = {         /* Extra bits for literal codes 257..285 */
+static const uint16_t cplext[] = {   /* Extra bits for literal codes 257..285 */
         0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
         3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0, 99, 99}; /* 99==invalid */
-static const ush cpdist[] = {         /* Copy offsets for distance codes 0..29 */
+static const uint16_t cpdist[] = {   /* Copy offsets for distance codes 0..29 */
         1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193,
         257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145,
         8193, 12289, 16385, 24577};
-static const ush cpdext[] = {         /* Extra bits for distance codes */
+static const uint16_t cpdext[] = {   /* Extra bits for distance codes */
         0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
         7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
         12, 12, 13, 13};
@@ -217,59 +275,21 @@ static const ush cpdext[] = {         /*
    the stream.
  */
 
-STATIC ulg bb;                         /* bit buffer */
+STATIC uint32_t bb;                         /* bit buffer */
 STATIC unsigned bk;                    /* bits in bit buffer */
 
-STATIC const ush mask_bits[] = {
+STATIC const uint16_t mask_bits[] = {
     0x0000,
     0x0001, 0x0003, 0x0007, 0x000f, 0x001f, 0x003f, 0x007f, 0x00ff,
     0x01ff, 0x03ff, 0x07ff, 0x0fff, 0x1fff, 0x3fff, 0x7fff, 0xffff
 };
 
-#define NEXTBYTE()  ({ int v = get_byte(); if (v < 0) goto underrun; (uch)v; })
-#define NEEDBITS(n) {while(k<(n)){b|=((ulg)NEXTBYTE())<<k;k+=8;}}
+#define NEXTBYTE()  ({ int v = get_byte(); if (v < 0) goto underrun; \
+			(uint8_t)v; })
+#define NEEDBITS(n) {while (k < (n)) \
+			{b |= ((uint32_t)NEXTBYTE())<<k; k += 8; } }
 #define DUMPBITS(n) {b>>=(n);k-=(n);}
 
-#ifndef NO_INFLATE_MALLOC
-/* A trivial malloc implementation, adapted from
- *  malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
- */
-
-static unsigned long malloc_ptr;
-static int malloc_count;
-
-static void *malloc(int size)
-{
-       void *p;
-
-       if (size < 0)
-		error("Malloc error");
-       if (!malloc_ptr)
-		malloc_ptr = free_mem_ptr;
-
-       malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
-
-       p = (void *)malloc_ptr;
-       malloc_ptr += size;
-
-       if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
-		error("Out of memory");
-
-       malloc_count++;
-       return p;
-}
-
-static void free(void *where)
-{
-       malloc_count--;
-       if (!malloc_count)
-		malloc_ptr = free_mem_ptr;
-}
-#else
-#define malloc(a) kmalloc(a, GFP_KERNEL)
-#define free(a) kfree(a)
-#endif
-
 /*
    Huffman code decoding is performed using a multi-level table lookup.
    The fastest way to decode is to simply build a lookup table whose
@@ -307,7 +327,7 @@ STATIC const int lbits = 9;          /* 
 STATIC const int dbits = 6;          /* bits in base distance lookup table */
 
 
-/* If BMAX needs to be larger than 16, then h and x[] should be ulg. */
+/* If BMAX needs to be larger than 16, then h and x[] should be uint32_t. */
 #define BMAX 16         /* maximum bit length of any code (16 for explode) */
 #define N_MAX 288       /* maximum number of codes in any set */
 
@@ -319,8 +339,8 @@ STATIC int INIT huft_build(
 	unsigned *b,            /* code lengths in bits (all assumed <= BMAX) */
 	unsigned n,             /* number of codes (assumed <= N_MAX) */
 	unsigned s,             /* number of simple-valued codes (0..s-1) */
-	const ush *d,           /* list of base values for non-simple codes */
-	const ush *e,           /* list of extra bits for non-simple codes */
+	const uint16_t *d,      /* list of base values for non-simple codes */
+	const uint16_t *e,      /* list of extra bits for non-simple codes */
 	struct huft **t,        /* result: starting table */
 	int *m                  /* maximum lookup bits, returns actual */
 	)
@@ -500,8 +520,8 @@ DEBG1("5 ");
         if (h)
         {
           x[h] = i;             /* save pattern for backing up */
-          r.b = (uch)l;         /* bits to dump before this table */
-          r.e = (uch)(16 + j);  /* bits in this table */
+	  r.b = (uint8_t)l;         /* bits to dump before this table */
+	  r.e = (uint8_t)(16 + j);  /* bits in this table */
           r.v.t = q;            /* pointer to this table */
           j = i >> (w - l);     /* (get around Turbo C bug) */
           u[h-1][j] = r;        /* connect to last table */
@@ -511,18 +531,18 @@ DEBG1("6 ");
 DEBG("h6c ");
 
       /* set up table entry in r */
-      r.b = (uch)(k - w);
+      r.b = (uint8_t)(k - w);
       if (p >= v + n)
         r.e = 99;               /* out of values--invalid code */
       else if (*p < s)
       {
-        r.e = (uch)(*p < 256 ? 16 : 15);    /* 256 is end-of-block code */
-        r.v.n = (ush)(*p);             /* simple code is just the value */
+	r.e = (uint8_t)(*p < 256 ? 16 : 15);    /* 256 is end-of-block code */
+	r.v.n = (uint16_t)(*p);             /* simple code is just the value */
 	p++;                           /* one compiler does not like *p++ */
       }
       else
       {
-        r.e = (uch)e[*p - s];   /* non-simple--look up in lists */
+	r.e = (uint8_t)e[*p - s];   /* non-simple--look up in lists */
         r.v.n = d[*p++ - s];
       }
 DEBG("h6d ");
@@ -592,11 +612,12 @@ STATIC int INIT inflate_codes(
    Return an error code or zero if it all goes ok. */
 {
   register unsigned e;  /* table entry flag/number of extra bits */
-  unsigned n, d;        /* length and index for copy */
+  unsigned n;
+  int d;              /* source index for copy */
   unsigned w;           /* current window position */
   struct huft *t;       /* pointer to table entry */
   unsigned ml, md;      /* masks for bl and bd bits */
-  register ulg b;       /* bit buffer */
+  register uint32_t b;       /* bit buffer */
   register unsigned k;  /* number of bits in bit buffer */
 
 
@@ -622,7 +643,7 @@ STATIC int INIT inflate_codes(
     DUMPBITS(t->b)
     if (e == 16)                /* then it's a literal */
     {
-      slide[w++] = (uch)t->v.n;
+      slide[w++] = (uint8_t)t->v.n;
       Tracevv((stderr, "%c", slide[w-1]));
       if (w == WSIZE)
       {
@@ -659,11 +680,25 @@ STATIC int INIT inflate_codes(
 
       /* do the copy */
       do {
-        n -= (e = (e = WSIZE - ((d &= WSIZE-1) > w ? d : w)) > n ? n : e);
+#ifdef NEW_CODE
+	if (flush_cb) {
+#endif
+		/* Sliding window emulated using circular buffer:
+		 * manage wrap-around */
+		e = WSIZE - ((d &= WSIZE-1) > w ? d : w);
+		if (e > n)
+			e = n;
+#ifdef NEW_CODE
+	} else {
+		e = n;
+	}
+#endif
+	n -= e;
+
 #if !defined(NOMEMCPY) && !defined(DEBUG)
         if (w - d >= e)         /* (this test assumes unsigned comparison) */
         {
-          memcpy(slide + w, slide + d, e);
+		memcpy(slide + w, slide + d, e);
           w += e;
           d += e;
         }
@@ -673,9 +708,8 @@ STATIC int INIT inflate_codes(
             slide[w++] = slide[d++];
 	    Tracevv((stderr, "%c", slide[w-1]));
           } while (--e);
-        if (w == WSIZE)
-        {
-          flush_output(w);
+	if (w == WSIZE) {
+	  flush_output(w);
           w = 0;
         }
       } while (n);
@@ -702,7 +736,7 @@ STATIC int INIT inflate_stored(void)
 {
   unsigned n;           /* number of bytes in block */
   unsigned w;           /* current window position */
-  register ulg b;       /* bit buffer */
+  register uint32_t b;       /* bit buffer */
   register unsigned k;  /* number of bits in bit buffer */
 
 DEBG("<stor");
@@ -732,7 +766,7 @@ DEBG("<stor");
   while (n--)
   {
     NEEDBITS(8)
-    slide[w++] = (uch)b;
+    slide[w++] = (uint8_t)b;
     if (w == WSIZE)
     {
       flush_output(w);
@@ -838,7 +872,7 @@ STATIC int noinline INIT inflate_dynamic
   unsigned nl;          /* number of literal/length codes */
   unsigned nd;          /* number of distance codes */
   unsigned *ll;         /* literal/length and distance code lengths */
-  register ulg b;       /* bit buffer */
+  register uint32_t b;       /* bit buffer */
   register unsigned k;  /* number of bits in bit buffer */
   int ret;
 
@@ -1033,7 +1067,7 @@ STATIC int INIT inflate_block(
 /* decompress an inflated block */
 {
   unsigned t;           /* block type */
-  register ulg b;       /* bit buffer */
+  register uint32_t b;       /* bit buffer */
   register unsigned k;  /* number of bits in bit buffer */
 
   DEBG("<blk");
@@ -1130,8 +1164,8 @@ STATIC int INIT inflate(void)
  *
  **********************************************************************/
 
-static ulg crc_32_tab[256];
-static ulg crc;		/* initialized in makecrc() so it'll reside in bss */
+static uint32_t crc_32_tab[256];
+static uint32_t crc;	/* initialized in makecrc() so it'll reside in bss */
 #define CRC_VALUE (crc ^ 0xffffffffUL)
 
 /*
@@ -1172,7 +1206,7 @@ makecrc(void)
   }
 
   /* this is initialized here so this code could reside in ROM */
-  crc = (ulg)0xffffffffUL; /* shift register contents */
+  crc = (uint32_t)0xffffffffUL; /* shift register contents */
 }
 
 /* gzip flag byte */
@@ -1184,18 +1218,89 @@ makecrc(void)
 #define ENCRYPTED    0x20 /* bit 5 set: file is encrypted */
 #define RESERVED     0xC0 /* bit 6,7:   reserved */
 
+#ifdef NEW_CODE
+/* ===========================================================================
+ * Write the output window window[0..outcnt-1] and update crc and bytes_out.
+ * (Used for the decompressed data only.)
+ */
+static void INIT flush_window(void)
+{
+	uint32_t c = crc;         /* temporary variable */
+	unsigned n;
+	uint8_t *in, ch;
+
+	in = window;
+	for (n = 0; n < outcnt; n++) {
+		ch = *in++;
+		c = crc_32_tab[((int)c ^ ch) & 0xff] ^ (c >> 8);
+	}
+	crc = c;
+	bytes_out += (uint32_t)outcnt;
+	if (flush_cb != NULL)
+		flush_cb(window, outcnt); /* TODO: handle unzip_error */
+	else
+		window += outcnt;
+	outcnt = 0;
+}
+
+static int empty_fill(void *buf, unsigned int len)
+{
+	return 0;
+}
+#endif
+
+
 /*
  * Do the uncompression!
  */
-static int INIT gunzip(void)
+STATIC int INIT gunzip(
+#ifdef NEW_CODE
+		       unsigned char *buf, int len,
+		       int(*fill)(void*, unsigned int),
+		       int(*flush)(void*, unsigned int),
+		       unsigned char *output,
+		       int *posp,
+		       void(*error_fn)(char *x)
+#else
+		       void
+#endif
+  )
 {
-    uch flags;
+    uint8_t flags;
     unsigned char magic[2]; /* magic header */
     char method;
-    ulg orig_crc = 0;       /* original crc */
-    ulg orig_len = 0;       /* original uncompressed length */
+    uint32_t orig_crc = 0;       /* original crc */
+    uint32_t orig_len = 0;       /* original uncompressed length */
     int res;
 
+#ifdef NEW_CODE
+    set_error_fn(error_fn);
+    if (fill == NULL)
+	    fill_cb = empty_fill;
+    else
+	    fill_cb = fill;
+    if (output)
+	    window = output;
+    else {
+	    window = malloc(0x8000);
+	    if (!window)
+		    panic("can't allocate buffers");
+	    flush_cb = flush;
+    }
+
+    insize = len;
+    if (buf)
+	    inbuf = buf;
+    else
+	    inbuf = malloc(INBUFSIZ);
+#endif
+
+    inptr = 0;
+    outcnt = 0;		/* bytes in output buffer */
+    bytes_out = 0;
+    crc = (uint32_t)0xffffffffL; /* shift register contents */
+    makecrc();
+
     magic[0] = NEXTBYTE();
     magic[1] = NEXTBYTE();
     method   = NEXTBYTE();
@@ -1212,7 +1317,7 @@ static int INIT gunzip(void)
 	    return -1;
     }
 
-    flags  = (uch)get_byte();
+    flags  = (uint8_t)get_byte();
     if ((flags & ENCRYPTED) != 0) {
 	    error("Input is encrypted");
 	    return -1;
@@ -1277,15 +1382,15 @@ static int INIT gunzip(void)
     /* crc32  (see algorithm.doc)
      * uncompressed input size modulo 2^32
      */
-    orig_crc = (ulg) NEXTBYTE();
-    orig_crc |= (ulg) NEXTBYTE() << 8;
-    orig_crc |= (ulg) NEXTBYTE() << 16;
-    orig_crc |= (ulg) NEXTBYTE() << 24;
+    orig_crc = (uint32_t) NEXTBYTE();
+    orig_crc |= (uint32_t) NEXTBYTE() << 8;
+    orig_crc |= (uint32_t) NEXTBYTE() << 16;
+    orig_crc |= (uint32_t) NEXTBYTE() << 24;
     
-    orig_len = (ulg) NEXTBYTE();
-    orig_len |= (ulg) NEXTBYTE() << 8;
-    orig_len |= (ulg) NEXTBYTE() << 16;
-    orig_len |= (ulg) NEXTBYTE() << 24;
+    orig_len = (uint32_t) NEXTBYTE();
+    orig_len |= (uint32_t) NEXTBYTE() << 8;
+    orig_len |= (uint32_t) NEXTBYTE() << 16;
+    orig_len |= (uint32_t) NEXTBYTE() << 24;
     
     /* Validate decompression */
     if (orig_crc != CRC_VALUE) {
@@ -1296,11 +1401,22 @@ static int INIT gunzip(void)
 	    error("length error");
 	    return -1;
     }
+#ifdef NEW_CODE
+    if (!output)
+	    free(window);
+    if (posp)
+	    *posp = inptr;
+#endif
     return 0;
 
  underrun:			/* NEXTBYTE() goto's here if needed */
+    free(window);
+#ifdef NEW_CODE
+    if (!buf)
+	    free(inbuf);
+#endif
     error("out of input data");
     return -1;
 }
 
-
+#define decompress gunzip
diff -urNp base/lib/Makefile library/lib/Makefile
--- base/lib/Makefile	2008-10-11 14:12:10.000000000 +0200
+++ library/lib/Makefile	2008-10-13 22:24:00.000000000 +0200
@@ -58,6 +58,10 @@ obj-$(CONFIG_CRC7)	+= crc7.o
 obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 
+obj-$(CONFIG_RD_GZIP)	+= inflate.o
+obj-$(CONFIG_RD_BZIP2)	+= decompress_bunzip2.o
+obj-$(CONFIG_RD_LZMA)	+= decompress_unlzma.o
+
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
 obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
 obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
diff -urNp base/scripts/bin_size library/scripts/bin_size
--- base/scripts/bin_size	1970-01-01 01:00:00.000000000 +0100
+++ library/scripts/bin_size	2008-10-13 22:24:00.000000000 +0200
@@ -0,0 +1,10 @@
+#!/bin/sh
+
+if [ $# = 0 ] ; then
+   echo Usage: $0 file
+fi
+
+size_dec=`stat -c "%s" $1`
+size_hex_echo_string=`printf "%08x" $size_dec |
+     sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'`
+/bin/echo -ne $size_hex_echo_string
diff -urNp base/scripts/Makefile.lib library/scripts/Makefile.lib
--- base/scripts/Makefile.lib	2008-10-11 14:12:15.000000000 +0200
+++ library/scripts/Makefile.lib	2008-10-13 23:58:11.000000000 +0200
@@ -174,3 +174,17 @@ quiet_cmd_gzip = GZIP    $@
 cmd_gzip = gzip -f -9 < $< > $@
 
 
+# Bzip2
+# ---------------------------------------------------------------------------
+
+# Bzip2 does not include size in file... so we have to fake that
+size_append=$(SHELL) $(srctree)/scripts/bin_size
+
+quiet_cmd_bzip2 = BZIP2    $@
+cmd_bzip2 = (bzip2 -9 < $< ; $(size_append) $<) > $@
+
+# Lzma
+# ---------------------------------------------------------------------------
+
+quiet_cmd_lzma = LZMA    $@
+cmd_lzma = (lzma -9 -c $< ; $(size_append) $<) >$@
diff -urNp base/usr/initramfs_data.S library/usr/initramfs_data.S
--- base/usr/initramfs_data.S	2008-10-11 14:12:20.000000000 +0200
+++ library/usr/initramfs_data.S	2008-10-13 22:24:00.000000000 +0200
@@ -8,7 +8,7 @@
 
 
   ld -m elf_i386  --format binary --oformat elf32-i386 -r \
-  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+  -T initramfs_data.scr initramfs_data.cpio -o initramfs_data.o
    ld -m elf_i386  -r -o built-in.o initramfs_data.o
 
   initramfs_data.scr looks like this:
@@ -26,5 +26,5 @@ SECTIONS
 */
 
 .section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio.gz"
+.incbin "usr/initramfs_data.cpio"
 
diff -urNp base/usr/Makefile library/usr/Makefile
--- base/usr/Makefile	2008-10-11 14:12:20.000000000 +0200
+++ library/usr/Makefile	2008-10-13 22:24:00.000000000 +0200
@@ -12,7 +12,7 @@ obj-$(CONFIG_BLK_DEV_INITRD) := initramf
 # initramfs_data.o contains the initramfs_data.cpio.gz image.
 # The image is included using .incbin, a dependency which is not
 # tracked automatically.
-$(obj)/initramfs_data.o: $(obj)/initramfs_data.cpio.gz FORCE
+$(obj)/initramfs_data.o: $(obj)/initramfs_data.cpio FORCE
 
 #####
 # Generate the initramfs cpio archive
@@ -29,24 +29,24 @@ ramfs-args  := \
 # in initramfs and to detect if any files are added/removed.
 # Removed files are identified by directory timestamp being updated
 # The dependency list is generated by gen_initramfs.sh -l
-ifneq ($(wildcard $(obj)/.initramfs_data.cpio.gz.d),)
-	include $(obj)/.initramfs_data.cpio.gz.d
+ifneq ($(wildcard $(obj)/.initramfs_data.cpio.d),)
+	include $(obj)/.initramfs_data.cpio.d
 endif
 
 quiet_cmd_initfs = GEN     $@
       cmd_initfs = $(initramfs) -o $@ $(ramfs-args) $(ramfs-input)
 
-targets := initramfs_data.cpio.gz
+targets := initramfs_data.cpio
 # do not try to update files included in initramfs
 $(deps_initramfs): ;
 
 $(deps_initramfs): klibcdirs
-# We rebuild initramfs_data.cpio.gz if:
+# We rebuild initramfs_data.cpio if:
 # 1) Any included file is newer then initramfs_data.cpio.gz
 # 2) There are changes in which files are included (added or deleted)
 # 3) If gen_init_cpio are newer than initramfs_data.cpio.gz
 # 4) arguments to gen_initramfs.sh changes
-$(obj)/initramfs_data.cpio.gz: $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
-	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/.initramfs_data.cpio.gz.d
+$(obj)/initramfs_data.cpio: $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
+	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/.initramfs_data.cpio.d
 	$(call if_changed,initfs)
 
