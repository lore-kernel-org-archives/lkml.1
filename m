Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYIIED7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYIIED7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYIIEDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:03:51 -0400
Received: from 1wt.eu ([62.212.114.60]:3599 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYIIEDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:03:50 -0400
Date: Tue, 9 Sep 2008 06:03:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alain Knaff <alain@knaff.lu>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, hpa@zytor.com
Subject: Re: [update2] [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Message-ID: <20080909040311.GA10137@1wt.eu>
References: <200809082250.m88MoM4n030279@hitchhiker.org.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809082250.m88MoM4n030279@hitchhiker.org.lu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 12:50:22AM +0200, Alain Knaff wrote:
> Changes since last version:
> 
> - Removed #ifdef's in head_32.S and head_64.S at the cost of a 4-byte
>   increase of LZMA-compressed kernels

4 bytes aren't that much, the code looks a lot cleaner and touches less
areas.

I may be wrong, but I think that some #ifdef NEW_CODE and #ifdef IN_MEMORY
can go too. Note that I have *not* analysed the dependency chain, it's just
that I believe they're always defined so they may go :

> --- linux.trees.git/arch/x86/boot/compressed/misc.c	2008-09-07 11:29:12.000000000 +0200
> +++ linux.trees.git.udpcast/arch/x86/boot/compressed/misc.c	2008-09-09 00:41:40.000000000 +0200
> @@ -116,71 +116,18 @@
>  /*
>   * gzip declarations
>   */
> -
> -#define OF(args)	args
>  #define STATIC		static
> +#define NEW_CODE

(...)

> +/* Decompressor should decompress in memory */
> +#define IN_MEMORY

(...)

> --- linux.trees.git/include/linux/decompress_unlzma.h	1970-01-01 01:00:00.000000000 +0100
> +++ linux.trees.git.udpcast/include/linux/decompress_unlzma.h	2008-09-08 19:56:37.000000000 +0200
> @@ -0,0 +1,15 @@
> +#ifndef DECOMPRESS_UNLZMA_H
> +#define DECOMPRESS_UNLZMA_H
> +
> +
> +int unlzma(char *, int,
> +	   int(*fill)(void*, unsigned int),
> +#ifdef IN_MEMORY
> +	   unsigned char *output,
> +#else
> +	   int(*flush)(void*, unsigned int),
> +#endif
> +	   int *
> +	);
> +
> +#endif

(...)

> +struct writer {
> +	uint8_t *buffer;
> +	uint8_t previous_byte;
> +	size_t buffer_pos;
> +#ifndef IN_MEMORY
> +	int bufsize;
> +	size_t global_pos;
> +	int(*flush)(void*, unsigned int);
> +#endif
> +	struct lzma_header *header;
> +};

(...)

> +static always_inline size_t INIT get_pos(struct writer *wr)
> +{
> +	return
> +#ifndef IN_MEMORY
> +		wr->global_pos +
> +#endif
> +		wr->buffer_pos;
> +}

(...)

> +static always_inline uint8_t INIT peek_old_byte(struct writer *wr,
> +						uint32_t offs)
> +{
> +#ifdef IN_MEMORY
> +	int32_t pos;
> +	while (offs > wr->header->dict_size)
> +		offs -= wr->header->dict_size;
> +	pos = wr->buffer_pos - offs;
> +#else
> +	uint32_t pos = wr->buffer_pos - offs;
> +	while (pos >= wr->header->dict_size)
> +		pos += wr->header->dict_size;
> +#endif
> +	return wr->buffer[pos];
> +
> +}
> +
> +static always_inline void INIT write_byte(struct writer *wr, uint8_t byte)
> +{
> +	wr->buffer[wr->buffer_pos++] = wr->previous_byte = byte;
> +#ifndef IN_MEMORY
> +	if (wr->buffer_pos == wr->header->dict_size) {
> +		wr->buffer_pos = 0;
> +		wr->global_pos += wr->header->dict_size;
> +		wr->flush((char *)wr->buffer, wr->header->dict_size);
> +	}
> +#endif
> +}

(...)

> +STATIC always_inline int INIT unlzma(char *buf, int in_len,
> +				     int(*fill)(void*, unsigned int),
> +#ifdef IN_MEMORY
> +				     unsigned char *output,
> +#else
> +				     int(*flush)(void*, unsigned int),
> +#endif
> +				     int *posp
> +)
> +{
> +	struct lzma_header header;
> +	int lc, pb, lp;
> +	uint32_t pos_state_mask;
> +	uint32_t literal_pos_mask;
> +	uint16_t *p;
> +	int num_probs;
> +	struct rc rc;
> +	int i, mi;
> +	struct writer wr;
> +	struct cstate cst;
> +	char *inbuf;
> +	int ret = -1;
> +
> +	if (buf)
> +		inbuf = buf;
> +	else
> +		inbuf = malloc(LZMA_IOBUF_SIZE);
> +	if (!inbuf) {
> +		error("Could not allocate input bufer");
> +		goto exit_0;
> +	}
> +
> +	cst.state = 0;
> +	cst.rep0 = cst.rep1 = cst.rep2 = cst.rep3 = 1;
> +
> +	wr.header = &header;
> +#ifndef IN_MEMORY
> +	wr.flush = flush;
> +	wr.global_pos = 0;
> +#endif
> +	wr.previous_byte = 0;
> +	wr.buffer_pos = 0;
> +
> +	rc_init(&rc, fill, inbuf, in_len);
> +
> +	for (i = 0; i < sizeof(header); i++) {
> +		if (rc.ptr >= rc.buffer_end)
> +			rc_read(&rc);
> +		((unsigned char *)&header)[i] = *rc.ptr++;
> +	}
> +
> +	if (header.pos >= (9 * 5 * 5))
> +		error("bad header");
> +
> +	mi = header.pos / 9;
> +	lc = header.pos % 9;
> +	pb = mi / 5;
> +	lp = mi % 5;
> +	pos_state_mask = (1 << pb) - 1;
> +	literal_pos_mask = (1 << lp) - 1;
> +
> +	ENDIAN_CONVERT(header.dict_size);
> +	ENDIAN_CONVERT(header.dst_size);
> +
> +	if (header.dict_size == 0)
> +		header.dict_size = 1;
> +
> +#ifdef IN_MEMORY
> +	wr.buffer = output;
> +#else
> +	wr.bufsize = MIN(header.dst_size, header.dict_size);
> +	wr.buffer = large_malloc(wr.bufsize);
> +#endif
> +	if (wr.buffer == NULL)
> +		goto exit_1;
> +
> +	num_probs = LZMA_BASE_SIZE + (LZMA_LIT_SIZE << (lc + lp));
> +	p = (uint16_t *) large_malloc(num_probs * sizeof(*p));
> +	if (p == 0)
> +		goto exit_2;
> +	num_probs = LZMA_LITERAL + (LZMA_LIT_SIZE << (lc + lp));
> +	for (i = 0; i < num_probs; i++)
> +		p[i] = (1 << RC_MODEL_TOTAL_BITS) >> 1;
> +
> +	rc_init_code(&rc);
> +
> +	while (get_pos(&wr) < header.dst_size) {
> +		int pos_state =	get_pos(&wr) & pos_state_mask;
> +		uint16_t *prob = p + LZMA_IS_MATCH +
> +			(cst.state << LZMA_NUM_POS_BITS_MAX) + pos_state;
> +		if (rc_is_bit_0(&rc, prob))
> +			process_bit0(&wr, &rc, &cst, p, pos_state, prob,
> +				     lc, literal_pos_mask);
> +		else {
> +			process_bit1(&wr, &rc, &cst, p, pos_state, prob);
> +			if (cst.rep0 == 0)
> +				break;
> +		}
> +	}
> +
> +	if (posp)
> +		*posp = rc.ptr-rc.buffer;
> +#ifndef IN_MEMORY
> +	wr.flush(wr.buffer, wr.buffer_pos);
> +#endif
> +	ret = 0;
> +	large_free(p);
> +exit_2:
> +#ifndef IN_MEMORY
> +	large_free(wr.buffer);
> +#endif
> +exit_1:
> +	if (!buf)
> +		free(inbuf);
> +exit_0:
> +	return ret;
> +}
> +
> +#define decompress unlzma
> diff -uNrp -X linux.trees.git.udpcast/Documentation/dontdiff linux.trees.git/lib/inflate.c linux.trees.git.udpcast/lib/inflate.c
> --- linux.trees.git/lib/inflate.c	2008-09-07 11:29:23.000000000 +0200
> +++ linux.trees.git.udpcast/lib/inflate.c	2008-09-08 22:23:36.000000000 +0200
> @@ -110,19 +110,112 @@ static char rcsid[] = "#Id: inflate.c,v 
>  
>  #ifndef STATIC
>  
> +#define NEW_CODE
> +#define NO_INFLATE_MALLOC
> +#include <linux/fs.h>
> +
>  #if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
>  #  include <sys/types.h>
>  #  include <stdlib.h>
>  #endif
>  
> -#include "gzip.h"
> +static void __init error(char *m)
> +{
> +	printk(KERN_ERR "%s", m);
> +}
> +
> +#define INIT __init
> +#include <linux/init.h>
>  #define STATIC
> +#include <linux/inflate.h>
>  #endif /* !STATIC */
>  
>  #ifndef INIT
>  #define INIT
>  #endif
> -	
> +
> +#ifdef NEW_CODE
> +#include <linux/string.h>
> +
> +#ifndef IN_MEMORY
> +static int(*flush_cb)(void*, unsigned int);
> +#endif
(...)
etc...

Regards,
Willy

