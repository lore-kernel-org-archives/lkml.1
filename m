Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZHCNjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZHCNjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbZHCNjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:39:31 -0400
Received: from www84.your-server.de ([213.133.104.84]:51247 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZHCNj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:39:29 -0400
Subject: [RFC 1/2] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 15:39:20 +0200
Message-Id: <1249306760.8358.9.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/*
 * A generic kernel FIFO implementation.
 *
 * Copyright (C) 2009 Stefani Seibold/Munich/Germany <stefani@seibold.net>
 *
 * base on work:
 * Copyright (C) 2004 Stelian Pop <stelian@popies.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */
#ifndef _LINUX_KFIFO_H
#define _LINUX_KFIFO_H

#include <linux/kernel.h>
 
#define KFIFO_F_NOTRIM 	1	/* do not cut of the record */

struct kfifo {
	unsigned long size;	/* the size of the allocated buffer */
	unsigned long in;	/* data is added at offset (in % size) */
	unsigned long out;	/* data is extracted from off. (out % size) */
	unsigned char buf[0];	/* the buffer holding the data */
};

#define	KFIFO_INIT(name, n) \
	(struct kfifo) { \
		.size	= n, \
		.in	= 0, \
		.out	= 0, \
	}


#define	DECLARE_KFIFO(name, size) \
union { \
	struct kfifo name; \
	unsigned char name##_alloc[size + sizeof(struct kfifo)]; \
} 

#define	DEFINE_KFIFO(name, size) \
	DECLARE_KFIFO(name, size) = KFIFO_INIT(name, size)

#define	INIT_KFIFO(name) \
	name = KFIFO_INIT(name, sizeof(name##_alloc) - sizeof(struct kfifo))

/**
 * kfifo_alloc - allocates a new FIFO and its internal buffer
 * @size: the size of the internal buffer to be allocated.
 * @gfp_mask: get_free_pages mask, passed to kmalloc()
 *
 * This function dynamically allocates a new fifo and returns the address
 */
extern struct kfifo *kfifo_alloc(unsigned long size, gfp_t gfp_mask);

/**
 * kfifo_free - frees a dynamic allocated FIFO
 * @fifo: the fifo to be freed.
 */
extern void kfifo_free(struct kfifo *fifo);

/**
 * kfifo_reset - removes the entire FIFO contents
 * @fifo: the fifo to be emptied.
 */
static inline void kfifo_reset(struct kfifo *fifo)
{
	fifo->out = fifo->in;
}

/**
 * kfifo_used - returns the number of bytes currently used in the FIFO
 * @fifo: the fifo to be used.
 */
static inline __must_check unsigned long kfifo_used(struct kfifo *fifo)
{
	return fifo->in - fifo->out;
}

/**
 * kfifo_size - returns the size of the fifo in bytes
 * @fifo: the fifo to be used.
 */
static inline __must_check unsigned long kfifo_size(struct kfifo *fifo)
{
	return fifo->size;
}

/**
 * kfifo_empty - returns true if the fifo is empty
 * @fifo: the fifo to be used.
 */
static inline __must_check int kfifo_empty(struct kfifo *fifo)
{
	return fifo->in == fifo->out;
}

/**
 * kfifo_is_full - returns true if the fifo is full
 * @fifo: the fifo to be used.
 */
static inline __must_check int kfifo_is_full(struct kfifo *fifo)
{
	return kfifo_used(fifo) == kfifo_size(fifo);
}

/**
 * kfifo_avail - returns the number of bytes available in the FIFO
 * @fifo: the fifo to be used.
 */
static inline __must_check unsigned long kfifo_avail(struct kfifo *fifo)
{
	return kfifo_size(fifo) - kfifo_used(fifo);
}

/**
 * __kfifo_add_out internal helper function for updating the out offset 
 */
static inline void __kfifo_add_out(struct kfifo *fifo,
				unsigned long off)
{
	smp_mb();
	fifo->out += off;
}

/**
 * __kfifo_add_in internal helper function for updating the in offset 
 */
static inline void __kfifo_add_in(struct kfifo *fifo,
				unsigned long off)
{
	smp_wmb();
	fifo->in += off;
}

/**
 * __kfifo_off internal helper function for calculating the index of a
 * given offeset
 */
static inline unsigned long __kfifo_off(struct kfifo *fifo, unsigned long off)
{
	return off % fifo->size;
}

/**
 * __kfifo_peek_n internal helper function for determinate the length of
 * the next record in the fifo
 */
static inline unsigned long __kfifo_peek_n(struct kfifo *fifo,
				unsigned long recsize)
{
#define	KFIFO_GET_MOD(fifo, off, shift) \
		((fifo)->buf[__kfifo_off((fifo), (fifo)->out+(off))] << (shift))

	unsigned long l;

	l = KFIFO_GET_MOD(fifo, 0, 0);

	if (unlikely(--recsize))
		l |= KFIFO_GET_MOD(fifo, 1, 8);
	
	return l;
}

/**
 * __kfifo_poke_n internal helper function for storing the length of
 * the next record into the fifo
 */
static inline void __kfifo_poke_n(struct kfifo *fifo,
			unsigned long recsize, unsigned long n)
{
#define	KFIFO_PUT(fifo, off, val, shift) \
		(fifo)->buf[__kfifo_off((fifo), (fifo)->in+(off))] = \
		(unsigned char)((val) >> (shift))

	KFIFO_PUT(fifo, 0, n, 0);

	if (unlikely(--recsize))
		KFIFO_PUT(fifo, 1, n, 8);
}

/**
 * __kfifo_put... internal functions for put date into the fifo
 * do not call it directly, use kfifo_put() instead
 */
extern unsigned long __kfifo_put_notrim(struct kfifo *fifo,
	const unsigned char *from, unsigned long n, unsigned long recsize,
	unsigned long *total);

extern unsigned long __kfifo_put_trim(struct kfifo *fifo,
	const unsigned char *from, unsigned long n, unsigned long recsize,
	unsigned long *total);

extern unsigned long __kfifo_put_generic(struct kfifo *fifo,
	const unsigned char *from, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total);

static inline unsigned long __kfifo_put(struct kfifo *fifo,
	const unsigned char *from, unsigned long n,
	unsigned long flags, unsigned long *total)
{
	unsigned long ret;
	unsigned long t;

	if (!total)
		total = &t;

	if (flags)
		ret = __kfifo_put_notrim(fifo, from, n, 0, total);
	else
		ret = __kfifo_put_trim(fifo, from, n, 0, total);

	if (likely(ret == 0))
		__kfifo_add_in(fifo, *total);

	return ret;
}

static inline unsigned long __kfifo_put_n(struct kfifo *fifo,
	const unsigned char *from, unsigned long n,
	unsigned long recsize, unsigned long flags, unsigned long *total)
{
	unsigned long ret;
	unsigned long t;

	if (!total)
		total = &t;

	if (flags)
		ret = __kfifo_put_notrim(fifo, from, n, recsize, total);
	else
		ret = __kfifo_put_trim(fifo, from, n, recsize, total);

	if (likely(ret == 0)) {
		__kfifo_poke_n(fifo, recsize, *total);
		__kfifo_add_in(fifo, recsize + *total);
	}
	return ret;
}

/**
 * kfifo_put - puts some data into the FIFO without locking
 * @fifo: the fifo to be used.
 * @from: the data to be added.
 * @n: the length of the data to be added.
 * @recsize: size of record field
 * @flags: KFIFO_F_NOTRIM = do not cut off if the record is to long
 * @total: pointer where the total number of copied bytes should stored
 *
 * This function copies at most @n bytes from the @from into
 * the FIFO depending @flags argument, and returns the number of
 * bytes which cannot be copied.
 *
 * Note that with only one concurrent reader and one concurrent
 * writer, you don't need extra locking to use these functions.
 */
static inline __must_check unsigned long kfifo_put(struct kfifo *fifo,
	unsigned char *from, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total)
{
	if (__builtin_constant_p(recsize) && __builtin_constant_p(flags)) {
		if (!recsize)
			return __kfifo_put(fifo, from, n, flags, total);
		return __kfifo_put_n(fifo, from, n, recsize, flags, total);
	}
	return __kfifo_put_generic(fifo, from, n, recsize, flags, total);
}

/**
 * __kfifo_get... internal functions for get date from the fifo
 * do not call it directly, use kfifo_get() instead
 */
extern unsigned long __kfifo_get_notrim(struct kfifo *fifo,
	unsigned char *to, unsigned long n, unsigned long reclen,
	unsigned long recsize, unsigned long *total);

extern unsigned long __kfifo_get_trim(struct kfifo *fifo,
	unsigned char *to, unsigned long n, unsigned long reclen,
	unsigned long recsize, unsigned long *total);

extern unsigned long __kfifo_get_generic(struct kfifo *fifo,
	unsigned char *to, unsigned long n, unsigned long reclen,
	unsigned long recsize, unsigned long *total);

static inline unsigned long __kfifo_get(struct kfifo *fifo,
	unsigned char *to, unsigned long n,
	unsigned long flags, unsigned long *total)
{
	unsigned long ret;
	unsigned long t;
	unsigned long l = kfifo_used(fifo);

	if (!total)
		total = &t;

	if (unlikely(flags))
		ret = __kfifo_get_notrim(fifo, to, n, l, 0, total);
	else
		ret = __kfifo_get_trim(fifo, to, n, l, 0, total);

	if (likely(ret == 0))
		__kfifo_add_out(fifo, *total);

	return ret;
}

static inline unsigned long __kfifo_get_n(struct kfifo *fifo,
	unsigned char *to, unsigned long n,
	unsigned long recsize, unsigned long flags, unsigned long *total)
{
	unsigned long ret;
	unsigned long t;
	unsigned long l;

	if (!total)
		total = &t;

	l = __kfifo_peek_n(fifo, recsize);

	if (flags)
		ret = __kfifo_get_notrim(fifo, to, n, l, recsize, total);
	else
		ret = __kfifo_get_trim(fifo, to, n, l, recsize, total);

	if (likely(ret == 0))
		__kfifo_add_out(fifo, recsize + l);

	return ret;
}

/**
 * kfifo_get - gets some data from the FIFO without locking
 * @fifo: the fifo to be used.
 * @to: where the data must be copied.
 * @n: the size of the destination buffer.
 * @recsize: size of record field
 * @flags: KFIFO_F_NOTRIM = do not cut off if the record is to long
 * @total: pointer where the total number of copied bytes should stored
 *
 * This function copies at most @n bytes from the @to into
 * the FIFO depending on @flags argument, and returns the number of
 * bytes which cannot be copied.
 *
 * Note that with only one concurrent reader and one concurrent
 * writer, you don't need extra locking to use these functions.
 */
static inline __must_check unsigned long kfifo_get(struct kfifo *fifo,
	unsigned char *to, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total)
{
	if (__builtin_constant_p(recsize) && __builtin_constant_p(flags)) {
		if (!recsize)
			return __kfifo_get(fifo, to, n, flags, total);
		return __kfifo_get_n(fifo, to, n, recsize, flags, total);
	}
	return __kfifo_get_generic(fifo, to, n, recsize, flags, total);
}


/**
 * __kfifo_from_user... internal functions for transfer from user space into the
 * fifo. do not call it directly, use kfifo_from_user() instead
 */
extern unsigned long __kfifo_from_user_notrim(struct kfifo *fifo,
	const void __user *from, unsigned long n, unsigned long recsize,
	unsigned long *total);

extern unsigned long __kfifo_from_user_trim(struct kfifo *fifo,
	const void __user *from, unsigned long n, unsigned long recsize,
	unsigned long *total);

extern unsigned long __kfifo_from_user_generic(struct kfifo *fifo,
	const void __user *from, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total);

static inline unsigned long __kfifo_from_user(struct kfifo *fifo,
	const void __user *from, unsigned long n,
	unsigned long flags, unsigned long *total)
{
	unsigned long ret;
	unsigned long t;

	if (!total)
		total = &t;

	if (flags)
		ret = __kfifo_from_user_notrim(fifo, from, n, 0, total);
	else
		ret = __kfifo_from_user_trim(fifo, from, n, 0, total);

	if (likely(ret == 0))
		__kfifo_add_in(fifo, *total);

	return ret;
}

static inline unsigned long __kfifo_from_user_n(struct kfifo *fifo,
	const void __user *from, unsigned long n,
	unsigned long recsize, unsigned long flags, unsigned long *total)
{
	unsigned long ret;
	unsigned long t;

	if (!total)
		total = &t;

	if (flags)
		ret = __kfifo_from_user_notrim(fifo, from, n, recsize, total);
	else
		ret = __kfifo_from_user_trim(fifo, from, n, recsize, total);

	if (likely(ret == 0)) {
		__kfifo_poke_n(fifo, recsize, *total);
		__kfifo_add_in(fifo, recsize + *total);
	}
	return ret;
}

/**
 * kfifo_from_user - puts some data from user space into the FIFO
 * @fifo: the fifo to be used.
 * @from: pointer to the data to be added.
 * @n: the length of the data to be added.
 * @recsize: size of record field
 * @flags: KFIFO_F_NOTRIM = do not cut off if the record is to long
 * @total: pointer where the total number of copied bytes should stored
 *
 * This function copies at most @n bytes from the @from into
 * the FIFO depending on @flags argument, and returns the number of
 * bytes which cannot be copied.
 *
 * Note that with only one concurrent reader and one concurrent
 * writer, you don't need extra locking to use these functions.
 */
static inline __must_check unsigned long kfifo_from_user(struct kfifo *fifo,
	const void __user *from, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total)
{
	if (__builtin_constant_p(recsize) && __builtin_constant_p(flags)) {
		if (!recsize)
			return __kfifo_from_user(fifo, from, n, flags, total);
		return __kfifo_from_user_n(fifo, from, n, recsize, flags, total);
	}
	return __kfifo_from_user_generic(fifo, from, n, recsize, flags, total);
}

/**
 * __kfifo_to_user... internal functions for transfer fifo data into user space
 * do not call it directly, use kfifo_to_user() instead
 */
extern unsigned long __kfifo_to_user_notrim(struct kfifo *fifo,
	void __user *to, unsigned long n, unsigned long reclen,
	unsigned long recsize, unsigned long *total);

extern unsigned long __kfifo_to_user_trim(struct kfifo *fifo,
	void __user *to, unsigned long n, unsigned long reclen,
	unsigned long recsize, unsigned long *total);

extern unsigned long __kfifo_to_user_generic(struct kfifo *fifo,
	void __user *to, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total);

static inline unsigned long __kfifo_to_user(struct kfifo *fifo,
	void __user *to, unsigned long n,
	unsigned long flags, unsigned long *total)
{
	unsigned long ret;
	unsigned long t;
	unsigned long l = kfifo_used(fifo);

	if (!total)
		total = &t;

	if (unlikely(flags))
		ret = __kfifo_to_user_notrim(fifo, to, n, l, 0, total);
	else
		ret = __kfifo_to_user_trim(fifo, to, n, l, 0, total);

	if (likely(ret == 0))
		__kfifo_add_out(fifo, *total);

	return ret;
}

static inline unsigned long __kfifo_to_user_n(struct kfifo *fifo,
	void __user *to, unsigned long n,
	unsigned long recsize, unsigned long flags, unsigned long *total)
{
	unsigned long ret;
	unsigned long t;
	unsigned long l;

	if (!total)
		total = &t;

	l = __kfifo_peek_n(fifo, recsize);

	if (flags)
		ret = __kfifo_to_user_notrim(fifo, to, n, l, recsize, total);
	else
		ret = __kfifo_to_user_trim(fifo, to, n, l, recsize, total);

	if (likely(ret == 0))
		__kfifo_add_out(fifo, recsize + l);
	
	return ret;
}

/**
 * kfifo_to_user - gets data from the FIFO and write it to user space
 * @fifo: the fifo to be used.
 * @to: where the data must be copied.
 * @n: the size of the destination buffer.
 * @recsize: size of record field
 * @flags: KFIFO_F_NOTRIM = do not cut off if the record is to long
 * @total: pointer where the total number of copied bytes should stored
 *
 * This function copies at most @n bytes from the FIFO into the
 * @to depending on @flags argument.
 * In case of an error, the function returns the number of bytes which cannot
 * be copied.
 * - If the flags KFIFO_F_NOTRIM is set and the returned value is greater than
 *   the n parameter this means that there is not enough space to copy the
 *   whole record
 * - Otherwise this means that the copy_to_user() functions has failed.
 *
 * Note that with only one concurrent reader and one concurrent
 * writer, you don't need extra locking to use these functions.
 */
static inline __must_check unsigned long kfifo_to_user(struct kfifo *fifo,
		void __user *to, unsigned long n, unsigned long recsize,
		unsigned long flags, unsigned long *total)
{
	if (__builtin_constant_p(recsize) && __builtin_constant_p(flags)) {
		if (!recsize)
			return __kfifo_to_user(fifo, to, n, flags, total);
		return __kfifo_to_user_n(fifo, to, n, recsize, flags, total);
	}
	return __kfifo_to_user_generic(fifo, to, n, recsize, flags, total);
}

/**
 * __kfifo_peek... internal functions for peek into the next fifo record
 * do not call it directly, use kfifo_peek() instead
 */
extern unsigned long __kfifo_peek_generic(struct kfifo *fifo,
				unsigned long recsize);

static inline unsigned long __kfifo_peek(struct kfifo *fifo)
{
	return kfifo_used(fifo);
}

/**
 * kfifo_peek - gets the size of the next FIFO record data
 * @fifo: the fifo to be used.
 * @recsize: size of record field
 *
 * This function returns the size of the next FIFO record in number of bytes
 */
static inline __must_check unsigned long kfifo_peek(struct kfifo *fifo,
	unsigned long recsize)
{
	if (__builtin_constant_p(recsize)) {
		if (!recsize)
			return __kfifo_peek(fifo);
		return __kfifo_peek_n(fifo, recsize);
	}
	return __kfifo_peek_generic(fifo, recsize);
}

#endif


