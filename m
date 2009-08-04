Return-Path: <linux-kernel-owner+w=401wt.eu-S932552AbZHDHuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbZHDHuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 03:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbZHDHuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 03:50:16 -0400
Received: from www84.your-server.de ([213.133.104.84]:53801 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbZHDHuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:50:15 -0400
Subject: [RFC 2/2] extended kfifo API V0.2
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Mike Christie <michaelc@cs.wisc.edu>, open-iscsi@googlegroups.com,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 09:50:00 +0200
Message-Id: <1249372200.17115.35.camel@wall-e>
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

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/err.h>
#include <linux/uaccess.h>
#include <linux/kfifo.h>
#include <linux/log2.h>

static void _kfifo_init(struct kfifo *fifo, unsigned char *buffer,
		unsigned int size)
{
	fifo->buffer = buffer;
	fifo->size = size;
	fifo->in = fifo->out = 0;
}

void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size)
{
	
	/* size must be a power of 2 */
	BUG_ON(!is_power_of_2(size));
	
	_kfifo_init(fifo, buffer, size);
}
EXPORT_SYMBOL(kfifo_init);

int kfifo_alloc(struct kfifo *fifo, unsigned long size,
			gfp_t gfp_mask)
{
	unsigned char *buffer;

	if (size & (size - 1)) {
		BUG_ON(size > 0x80000000);
		size = roundup_pow_of_two(size);
	}

	buffer = kmalloc(size, gfp_mask);
	if (!buffer)
		return -ENOMEM;

	_kfifo_init(fifo, buffer, size);

	return 0;
}
EXPORT_SYMBOL(kfifo_alloc);

void kfifo_free(struct kfifo *fifo)
{
	kfree(fifo->buffer);
}
EXPORT_SYMBOL(kfifo_free);

static inline unsigned long __kfifo_put_data(struct kfifo *fifo,
		const unsigned char *from, unsigned long n, unsigned long off)
{
	unsigned long	l;

	/*
	 * Ensure that we sample the fifo->out index -before- we
	 * start putting bytes into the kfifo.
	 */

	smp_mb();

	off += fifo->in;

	/* first put the data starting from fifo->in to buffer end */
	l = min(n, fifo->size - __kfifo_off(fifo, off));
	memcpy(fifo->buffer + __kfifo_off(fifo, off), from, l);

	/* then put the rest (if any) at the beginning of the buffer */
	memcpy(fifo->buffer, from + l, n - l);

	return 0;
}

/**
 * kfifo_put_notrim - puts data into the FIFO without cut off a record
 * @fifo: the fifo to be used.
 * @from: the data to be added.
 * @n: the size of the destination buffer.
 * @recsize: size of record field
 * @total: pointer where the total number of copied bytes should stored
 *
 * This function copies @n bytes from the @from into the FIFO
 * 
 * In case of an error, the function returns the number of bytes which cannot
 * be copied.
 */
unsigned long __kfifo_put_notrim(struct kfifo *fifo,
	const unsigned char *from, unsigned long n, unsigned long recsize,
	unsigned long *total)
{
	if (kfifo_avail(fifo) < n + recsize) {
		*total = n + 1;
		return *total;
	}

	*total = n;

	return __kfifo_put_data(fifo, from, n, recsize);
}
EXPORT_SYMBOL(__kfifo_put_notrim);

unsigned long __kfifo_put_trim(struct kfifo *fifo,
	const unsigned char *from, unsigned long n, unsigned long recsize,
	unsigned long *total)
{
	unsigned long	l;

	l = min(kfifo_avail(fifo), n + recsize);

	if (l < recsize) {
		*total = n + 1;
		return *total;
	}

	*total = l - recsize;

	return __kfifo_put_data(fifo, from, l - recsize, recsize);
}
EXPORT_SYMBOL(__kfifo_put_trim);

unsigned long __kfifo_put_generic(struct kfifo *fifo,
	const unsigned char *from, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total)
{
	if (!recsize)
		return __kfifo_put(fifo, from, n, flags, total);
	return __kfifo_put_n(fifo, from, n, recsize, flags, total);
}
EXPORT_SYMBOL(__kfifo_put_generic);

unsigned long kfifo_put(struct kfifo *fifo, unsigned char *from,
				unsigned long n)
{
	n = min(kfifo_avail(fifo), n);

	__kfifo_put_data(fifo, from, n, 0);
	__kfifo_add_in(fifo, n);

	return n;
}
EXPORT_SYMBOL(kfifo_put);

static inline unsigned long __kfifo_get_data(struct kfifo *fifo,
		unsigned char *to, unsigned long n, unsigned long off)
{
	unsigned long l;

	/*
	 * Ensure that we sample the fifo->in index -before- we
	 * start removing bytes from the kfifo.
	 */

	smp_rmb();

	off += fifo->out;

	/* first get the data from fifo->out until the end of the buffer */
	l = min(n, fifo->size - __kfifo_off(fifo, off));
	memcpy(to, fifo->buffer + __kfifo_off(fifo, off), l);

	/* then get the rest (if any) from the beginning of the buffer */
	memcpy(to + l, fifo->buffer, n - l);

	return 0;
}

unsigned long __kfifo_get_notrim(struct kfifo *fifo,
	unsigned char *to, unsigned long n, unsigned long reclen,
	unsigned long recsize, unsigned long *total)
{
	if (kfifo_used(fifo) < recsize) {
		*total = 0;
		return 0;
	}

	*total = n;

	if (n < reclen)
		return reclen;

	return __kfifo_get_data(fifo, to, n, recsize);
}
EXPORT_SYMBOL(__kfifo_get_notrim);

unsigned long __kfifo_get_trim(struct kfifo *fifo,
	unsigned char *to, unsigned long n, unsigned long reclen,
	unsigned long recsize, unsigned long *total)
{
	if (kfifo_used(fifo) < recsize) {
		*total = 0;
		return 0;
	}

	n = min(n, reclen);

	*total = n;

	return __kfifo_get_data(fifo, to, n, recsize);
}
EXPORT_SYMBOL(__kfifo_get_trim);

unsigned long __kfifo_get_generic(struct kfifo *fifo,
	unsigned char *to, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total)
{
	if (!recsize)
		return __kfifo_get(fifo, to, n, flags, total);
	return __kfifo_get_n(fifo, to, n, recsize, flags, total);
}
EXPORT_SYMBOL(__kfifo_get_generic);

unsigned long kfifo_get(struct kfifo *fifo, unsigned char *to, unsigned long n)
{
	n = min(kfifo_used(fifo), n);

	__kfifo_get_data(fifo, to, n, 0);
	__kfifo_add_out(fifo, n);

	return n;
}
EXPORT_SYMBOL(kfifo_get);

static inline unsigned long __kfifo_from_user_data(struct kfifo *fifo,
	 const void __user *from, unsigned long n, unsigned long off)
{
	unsigned long l;
	int ret;

	/*
	 * Ensure that we sample the fifo->out index -before- we
	 * start putting bytes into the kfifo.
	 */

	smp_mb();

	off += fifo->in;

	/* first put the data starting from fifo->in to buffer end */
	l = min(n, fifo->size - __kfifo_off(fifo, off));
	ret = copy_from_user(fifo->buffer + __kfifo_off(fifo, off), from, l);

	if (unlikely(n))
		return ret + n - l;

	/* then put the rest (if any) at the beginning of the buffer */
	ret = copy_from_user(fifo->buffer, from + l, n - l);

	if (unlikely(ret))
		return ret;

	return 0;
}

unsigned long __kfifo_from_user_notrim(struct kfifo *fifo,
	const void __user *from, unsigned long n, unsigned long recsize,
	unsigned long *total)
{
	if (kfifo_avail(fifo) < n + recsize) {
		*total = n + 1;
		return *total;
	}

	*total = n;

	return __kfifo_from_user_data(fifo, from, n, recsize);
}
EXPORT_SYMBOL(__kfifo_from_user_notrim);

unsigned long __kfifo_from_user_trim(struct kfifo *fifo,
	const void __user *from, unsigned long n, unsigned long recsize,
	unsigned long *total)
{
	unsigned long	l;

	l = min(kfifo_avail(fifo), n + recsize);

	if (l < recsize) {
		*total = n + 1;
		return *total;
	}

	*total = l - recsize;

	return __kfifo_from_user_data(fifo, from, l - recsize, recsize);
}
EXPORT_SYMBOL(__kfifo_from_user_trim);

unsigned long __kfifo_from_user_generic(struct kfifo *fifo,
	const void __user *from, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total)
{
	if (!recsize)
		return __kfifo_from_user(fifo, from, n, flags, total);
	return __kfifo_from_user_n(fifo, from, n, recsize, flags, total);
}
EXPORT_SYMBOL(__kfifo_from_user_generic);

static inline unsigned long __kfifo_to_user_data(struct kfifo *fifo,
		void __user *to, unsigned long n, unsigned long off)
{
	unsigned long l;
	int ret;

	/*
	 * Ensure that we sample the fifo->in index -before- we
	 * start removing bytes from the kfifo.
	 */

	smp_rmb();

	off += fifo->out;

	/* first get the data from fifo->out until the end of the buffer */
	l = min(n, fifo->size - __kfifo_off(fifo, off));
	ret = copy_to_user(to, fifo->buffer + __kfifo_off(fifo, off), l);

	if (unlikely(ret))
		return ret + n - l;

	/* then get the rest (if any) from the beginning of the buffer */
	ret = copy_to_user(to + l, fifo->buffer, n - l);

	if (unlikely(ret))
		return ret;

	return 0;
}

unsigned long __kfifo_to_user_notrim(struct kfifo *fifo,
	void __user *to, unsigned long n, unsigned long reclen,
	unsigned long recsize, unsigned long *total)
{
	if (kfifo_used(fifo) < recsize) {
		*total = 0;
		return 0;
	}

	*total = n;

	if (n < reclen)
		return reclen;

	return __kfifo_to_user_data(fifo, to, n, recsize);
}
EXPORT_SYMBOL(__kfifo_to_user_notrim);

unsigned long __kfifo_to_user_trim(struct kfifo *fifo,
	void __user *to, unsigned long n, unsigned long reclen,
	unsigned long recsize, unsigned long *total)
{
	if (kfifo_used(fifo) < recsize) {
		*total = 0;
		return 0;
	}

	n = min(n, reclen);

	*total = n;

	return __kfifo_to_user_data(fifo, to, n, recsize);
}
EXPORT_SYMBOL(__kfifo_to_user_trim);

unsigned long __kfifo_to_user_generic(struct kfifo *fifo,
	void __user *to, unsigned long n, unsigned long recsize,
	unsigned long flags, unsigned long *total)
{
	if (!recsize)
		return __kfifo_to_user(fifo, to, n, flags, total);
	return __kfifo_to_user_n(fifo, to, n, recsize, flags, total);
}
EXPORT_SYMBOL(__kfifo_to_user_generic);

unsigned long __kfifo_peek_generic(struct kfifo *fifo, unsigned long recsize)
{
	if (recsize == 0)
		return kfifo_avail(fifo);

	return __kfifo_peek_n(fifo, recsize);
}
EXPORT_SYMBOL(__kfifo_peek_generic);



