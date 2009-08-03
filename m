Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZHCNjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZHCNjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZHCNjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:39:40 -0400
Received: from www84.your-server.de ([213.133.104.84]:51248 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbZHCNjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:39:32 -0400
Subject: [RFC 2/2] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 15:39:23 +0200
Message-Id: <1249306763.8358.11.camel@wall-e>
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

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/err.h>
#include <linux/uaccess.h>
#include <linux/kfifo.h>

struct kfifo *kfifo_alloc(unsigned long size, gfp_t gfp_mask)
{
	struct kfifo *fifo;

	BUG_ON(size > 0x80000000);

	fifo = kmalloc(sizeof(struct kfifo) + size, gfp_mask);
	if (!fifo)
		return ERR_PTR(-ENOMEM);

	fifo->size = size;
	fifo->in = fifo->out = 0;

	return fifo;
}
EXPORT_SYMBOL(kfifo_alloc);

void kfifo_free(struct kfifo *fifo)
{
	kfree(fifo);
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
	memcpy(fifo->buf + __kfifo_off(fifo, off), from, l);

	/* then put the rest (if any) at the beginning of the buffer */
	memcpy(fifo->buf, from + l, n - l);

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
	memcpy(to, fifo->buf + __kfifo_off(fifo, off), l);

	/* then get the rest (if any) from the beginning of the buffer */
	memcpy(to + l, fifo->buf, n - l);

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
	ret = copy_from_user(fifo->buf + __kfifo_off(fifo, off), from, l);

	if (unlikely(n))
		return ret + n - l;

	/* then put the rest (if any) at the beginning of the buffer */
	ret = copy_from_user(fifo->buf, from + l, n - l);

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
	ret = copy_to_user(to, fifo->buf + __kfifo_off(fifo, off), l);

	if (unlikely(ret))
		return ret + n - l;

	/* then get the rest (if any) from the beginning of the buffer */
	ret = copy_to_user(to + l, fifo->buf, n - l);

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



