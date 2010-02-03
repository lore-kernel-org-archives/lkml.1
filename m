Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0BCWJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:09:53 -0500
Received: from www84.your-server.de ([213.133.104.84]:58333 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab0BCWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:09:50 -0500
Subject: Re: [PATCH] enhanced reimplemention of the kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>
In-Reply-To: <20100203120504.6da9b000.akpm@linux-foundation.org>
References: <1264597243.3607.24.camel@wall-e>
	 <20100203120504.6da9b000.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 03 Feb 2010 23:09:51 +0100
Message-ID: <1265234991.24040.46.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 03.02.2010, 12:05 -0800 schrieb Andrew Morton:
> On Wed, 27 Jan 2010 14:00:43 +0100
> Stefani Seibold <stefani@seibold.net> wrote:
> 
> > This is a complete reimplementation of the new kfifo API, which is now 
> > really generic, type save and type definable. 
> > 
> > 
> > ...
> >
> > diff -u -N -r -p linux-2.6.33-rc5.dummy/include/linux/kfifo.h linux-2.6.33-rc5.new/include/linux/kfifo.h
> > --- linux-2.6.33-rc5.dummy/include/linux/kfifo.h	1970-01-01 01:00:00.000000000 +0100
> > +++ linux-2.6.33-rc5.new/include/linux/kfifo.h	2010-01-27 13:34:06.324991898 +0100
> >
> > ...
> >
> > +/*
> > + * DECLARE_KFIFO_PTR - macro to declare a fifo pointer object
> > + * @fifo: name of the declared fifo
> > + * @type: type of the fifo elements
> > + * @size: the number of elements in the fifo, this must be a power of 2.
> > + */
> 
> Throughout this patch the comments are in kerneldoc form, but they
> don't use the /** opening token, so the kerneldoc tools will ignore them.
> 
> Please fix that up and test it.
> 
> > +#define DECLARE_KFIFO_PTR(fifo, type)	STRUCT_KFIFO_PTR(type) fifo
> > +
> > +/* helper macro */
> > +#define	__is_kfifo_ptr(fifo)	(sizeof(*fifo) == sizeof(struct __kfifo))
> 
> This is weird.  It's a compile-time constant.  What's it here for?

I need it to distinguish between real in place fifo, where the fifo
array is a part of the structure, and the fifo type where the array is
outside of the fifo structure.
 
> 
> > +
> > +#define __kfifo_initializer(fifo) \
> > +	(typeof(fifo)) { \
> > +		{ \
> > +			{ \
> > +			.in	= 0, \
> > +			.out	= 0, \
> > +			.mask	= __is_kfifo_ptr(&fifo) ? \
> > +				  0 : \
> > +				  sizeof((fifo).buf)/sizeof(*(fifo).buf) - 1, \
> > +			.esize	= sizeof(*(fifo).buf), \
> > +			.data	= __is_kfifo_ptr(&fifo) ? \
> > +				NULL : \
> > +				(fifo).buf, \
> > +			} \
> > +		} \
> > +	}
> > +

As you see it is used here for distinguish the initialization.

> > +/*
> > + * INIT_KFIFO - Initialize a fifo declared by DECLARE_KFIFO
> > + * @fifo: name of the declared fifo datatype
> > + */
> > +#define INIT_KFIFO(fifo)	fifo = __kfifo_initializer(fifo)
> 
> Some versions of gcc generate quite poor code for
> 
> 	struct foo f = { ... };
> 
> It would generate an instance of the struct into the stack and then
> would memcpy it over, iirc.  Please take a look, see if that's
> happening with this construct (might need to use an old gcc version)
> and if so, see if there's a fix?
> 

The current version of the kfifo implementation did it in the same way.
Why is it now wrong? Which gcc version do you mean?
 
> > +/*
> > + * DECLARE_KFIFO - macro to declare a fifo object
> > + * @fifo: name of the declared fifo
> > + * @type: type of the fifo elements
> > + * @size: the number of elements in the fifo, this must be a power of 2.
> > + */
> > +#define DECLARE_KFIFO(fifo, type, size)	STRUCT_KFIFO(type, size) fifo
> > +
> > +/*
> > + * DEFINE_KFIFO - macro to define and initialize a fifo
> > + * @fifo: name of the declared fifo datatype
> > + * @type: type of the fifo elements
> > + * @size: the number of elements in the fifo, this must be a power of 2.
> > + *
> > + * Note: the macro can be used for global and local fifo data type variables
> > + */
> > +#define DEFINE_KFIFO(fifo, type, size) \
> > +	DECLARE_KFIFO(fifo, type, size) = __kfifo_initializer(fifo)
> > +
> > +static inline unsigned int __must_check __kfifo_check(unsigned int val)
> > +{
> > +	return val;
> > +}
> 
> "check" is a poor term.  Check what?   For what?  Unclear.
> 
> If I knew what this was supposed to check, I could suggest a better
> name.  But it's called "check", so I don't know :(
> 

I will it rename to __kfifo_must_check_helper.

> > +/*
> > + * kfifo_initialized - Check if kfifo is initialized.
> > + * @fifo: fifo to check
> > + * Return %true if FIFO is initialized, otherwise %false.
> > + * Assumes the fifo was 0 before.
> > + *
> > + * Note: for in place fifo's this macro returns alway true
> > + */
> > +#define kfifo_initialized(fifo) ((fifo)->kfifo.data != NULL)
> 
> kfifo_initialized() is suspicious.  Any code which doesn't know whether
> its kfifo was initialised is probably confused, lame and broken. 
> Fortunately kfifo_initialized() is not used anywhere.  Please prepare a
> separate patch to kill it sometime.
> 

This function was introduced as a patch by andi kleen and you have it
already applied.

> > +/*
> > + * kfifo_esize - returns the size of the element managed by the fifo
> > + * @fifo: the fifo to be used.
> > + */
> > +#define kfifo_esize(fifo)	((fifo)->kfifo.esize)
> 
> This doesn't seem to be used anywhere either.
> 

It is a part of the API. It returns the the size of the handled element,
If a driver developer need it, it is there.
 
> > +/*
> > + * kfifo_recsize - returns the size of the record length field
> > + * @fifo: the fifo to be used.
> > + */
> > +#define kfifo_recsize(fifo)	(sizeof(*(fifo)->rectype))
> 
> Neither is this.  What's going on?
> 

Dito... This returns the size of the record length field. 0 means this
is not a variable record fifo.

> > +/*
> > + * kfifo_size - returns the size of the fifo in elements
> > + * @fifo: the fifo to be used.
> > + */
> > +#define kfifo_size(fifo)	((fifo)->kfifo.mask + 1)
> > +
> > +/*
> > + * kfifo_reset - removes the entire fifo content
> > + * @fifo: the fifo to be used.
> > + *
> > + * Note: usage of kfifo_reset() is dangerous. It should be only called when the
> > + * fifo is exclusived locked or when it is secured that no other thread is
> > + * accessing the fifo.
> > + */
> > +#define kfifo_reset(fifo) \
> > +(void)({ \
> > +	typeof(fifo + 1) __tmp = (fifo); \
> 
> What does the "+ 1" trick do?
> 

This is really a trick. Without this trick passing an array to the macro
will result in a compile error, because you can not copy an error in C.
But a typeof(array + 1) will result in a pointer and it is valid to
assign a pointer to address of an array.
 
> > +	__tmp->kfifo.in = __tmp->kfifo.out = 0; \
> > +})
> > +
> >
> > ...
> >
> > +/*
> > + * kfifo_put - put data into the fifo
> > + * @fifo: the fifo to be used.
> > + * @val: the data to be added.
> > + *
> > + * This macro copies the given value into the fifo.
> > + *
> > + * Note that with only one concurrent reader and one concurrent
> > + * writer, you don't need extra locking to use these macro.
> 
> There are quite a few typos in the comments in this patch.
> 

Sorry, but my english far from perfect. Maybe someone could support
me ;-)

> >
> > ...
> >
> > +/*
> > + * kfifo_out_locked - gets some data from the fifo using a spinlock for locking
> > + * @fifo: the fifo to be used.
> > + * @buf: pointer to the storage buffer
> > + * @n: max. number of elements to get
> > + * @lock: pointer to the spinlock to use for locking.
> > + *
> > + * This macro get the data from the fifo and return the numbers of elements
> > + * copied.
> > + */
> > +#define	kfifo_out_locked(fifo, buf, n, lock) \
> > +__kfifo_check( \
> > +({ \
> > +	unsigned long __flags; \
> > +	unsigned int __ret; \
> > +	spin_lock_irqsave(lock, __flags); \
> > +	__ret = kfifo_out(fifo, buf, n); \
> > +	spin_unlock_irqrestore(lock, __flags); \
> > +	__ret; \
> > +}) \
> > +)
> 
> This is poorly named.  Generally "foo_locked" is to be called when the
> caller has already taken the lock.  This identifier inverts that
> convention.
> 

This is the same name as the current kfifo API. Renaming it would break
a lot of drivers. But if there is no complain and you insist i will
rename it and fix the current users.
 
> > +/*
> > + * kfifo_from_user - puts some data from user space into the fifo
> > + * @fifo: the fifo to be used.
> > + * @from: pointer to the data to be added.
> > + * @len: the length of the data to be added.
> > + * @copied: pointer to output variable to store the number of copied bytes.
> > + *
> > + * This macro copies at most @len bytes from the @from into the
> > + * fifo, depending of the available space and returns -EFAULT/0
> > + *
> > + * Note that with only one concurrent reader and one concurrent
> > + * writer, you don't need extra locking to use these macro.
> > + */
> > +#define	kfifo_from_user(fifo, from, len, copied) \
> > +__kfifo_check( \
> > +({ \
> > +	typeof(fifo + 1) __tmp = (fifo); \
> > +	const void __user *__from = (from); \
> > +	unsigned int __len = (len); \
> > +	unsigned int *__copied = (copied); \
> > +	const size_t __recsize = sizeof(*__tmp->rectype); \
> > +	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > +	(__recsize) ? \
> > +	__kfifo_from_user_r(__kfifo, __from, __len,  __copied, __recsize) : \
> > +	__kfifo_from_user(__kfifo, __from, __len, __copied); \
> > +}) \
> > +)
> > +
> > +/*
> > + * kfifo_to_user - copies data from the fifo into user space
> > + * @fifo: the fifo to be used.
> > + * @to: where the data must be copied.
> > + * @len: the size of the destination buffer.
> > + * @copied: pointer to output variable to store the number of copied bytes.
> > + *
> > + * This macro copies at most @len bytes from the fifo into the
> > + * @to buffer and returns -EFAULT/0.
> > + *
> > + * Note that with only one concurrent reader and one concurrent
> > + * writer, you don't need extra locking to use these macro.
> > + */
> > +#define	kfifo_to_user(fifo, to, len, copied) \
> > +__kfifo_check( \
> > +({ \
> > +	typeof(fifo + 1) __tmp = (fifo); \
> > +	void __user *__to = (to); \
> > +	unsigned int __len = (len); \
> > +	unsigned int *__copied = (copied); \
> > +	const size_t __recsize = sizeof(*__tmp->rectype); \
> > +	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > +	(__recsize) ? \
> > +	__kfifo_to_user_r(__kfifo, __to, __len, __copied, __recsize) : \
> > +	__kfifo_to_user(__kfifo, __to, __len, __copied); \
> > +}) \
> > +)
> 
> Do these have any callers?
> 

Currently not, but this is a part of the current kfifo implementation. A
lot of developer like this idea and it will be used in the near future.
 
> > +/*
> > + * kfifo_dma_in_prepare - setup a scatterlist for DMA input
> > + * @fifo: the fifo to be used.
> > + * @sgl: pointer to the scatterlist array.
> > + * @nents: number of entries in the scatterlist array
> > + * @len: number of elements to transfer.
> > + *
> > + * This macro fills a scatterlist for DMA input.
> > + * It returns the number entries in the scatterlist array
> > + *
> > + * Note that with only one concurrent reader and one concurrent
> > + * writer, you don't need extra locking to use these macros.
> > + */
> > +#define	kfifo_dma_in_prepare(fifo, sgl, nents, len) \
> > +({ \
> > +	typeof(fifo + 1) __tmp = (fifo); \
> > +	struct scatterlist *__sgl = (sgl); \
> > +	int __nents = (nents); \
> > +	unsigned int __len = (len); \
> > +	const size_t __recsize = sizeof(*__tmp->rectype); \
> > +	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > +	(__recsize) ? \
> > +	__kfifo_dma_in_prepare_r(__kfifo, __sgl, __nents, __len, __recsize) : \
> > +	__kfifo_dma_in_prepare(__kfifo,__sgl, __nents, __len); \
> > +})
> 
> Do the DMA functions have any callers?  If not, why was all this stuff
> added?
> 

It is the chicken and egg problem. Alan Cox, Ira W. Snyder and
Shargorodsky Ata wrote me that they like the idea, because they needed
this kind of functionality. 

> >
> > ...
> >
> > --- linux-2.6.33-rc5.dummy/kernel/kfifo.c	1970-01-01 01:00:00.000000000 +0100
> > +++ linux-2.6.33-rc5.new/kernel/kfifo.c	2010-01-27 13:33:56.456825816 +0100
> > @@ -0,0 +1,583 @@
> > +/*
> > + * A generic kernel FIFO implementation
> > + *
> > + * Copyright (C) 2009/2010 Stefani Seibold <stefani@seibold.net>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + *
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/err.h>
> > +#include <linux/kfifo.h>
> > +#include <linux/log2.h>
> > +#include <linux/uaccess.h>
> > +
> > +static unsigned int roundup_diff(unsigned int val, unsigned int size)
> > +{
> > +	if (size <= 1) 
> > +		return size;
> > +	return (val + size - 1) / size;
> > +}
> 
> Would be useful to add a comment explaining why this exists.
> 
> Can we not use existing general facilities?
> 
> Should this be added to the existing general facilities?
> 

I will have a look on this.

> > +static inline unsigned int kfifo_unused(struct __kfifo *fifo)
> > +{
> > +	return (fifo->mask + 1) - (fifo->in - fifo->out);
> > +}
> 
> hm, how does this differ from kfifo_avail()?
> 

This is similar to kfifo_avail, but due the nature of macro and type
conversation i have not longer the original type information available.
So i can't call the macros in kfifo.h from the functions defined in
kfifo.c.
  
> Should this use existing helpers such as kfifo_avail(), kfifo_len(),
> etc?
> 

It wouldn't possible in most cases. See above.
 
> > +int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
> > +		size_t esize, gfp_t gfp_mask)
> > +{
> > +	/*
> > +	 * round up to the next power of 2, since our 'let the indices
> > +	 * wrap' technique works only in this case.
> > +	 */
> > +	if (!is_power_of_2(size))
> > +		size = rounddown_pow_of_two(size);
> > +
> > +	if (size < 2)
> > +		return -EINVAL;
> > +
> > +	fifo->in = fifo->out = 0;
> 
> 	fifo->in = 0;
> 	fifo->out = 0;
> 
> is usually preferred.
> 
> > +	fifo->data = kmalloc(size * esize, gfp_mask);
> > +
> > +	if (!fifo->data) {
> > +		fifo->mask = 0;
> > +		return -ENOMEM;
> > +	}
> > +
> > +	fifo->mask = size - 1;
> > +	fifo->esize = esize;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(__kfifo_alloc);
> > +
> > +void __kfifo_free(struct __kfifo *fifo)
> > +{
> > +	kfree(fifo);
> > +	fifo->data = 0;
> > +	fifo->mask = 0; 
> > +	fifo->in = fifo->out = 0;
> > +}
> > +EXPORT_SYMBOL(__kfifo_free);
> 
> err, no.  This scribbles on memory after having returned it to slab!
> 

You found an bug. This should be kfree(fifo->data);

> Which implies that this code wasn't tested with suitable kernel
> debugging options enabled.  Please absorb
> Documentation/SubmitChecklist.
> 
> Initialising memory to zero just prior to freeing it is lame anyway. 
> And it can hide bugs.  Just remove this and return the fifo to slab
> as-is.
> 
> > +
> > +int __kfifo_init(struct __kfifo *fifo, void *buffer,
> > +		unsigned int size, size_t esize)
> > +{
> > +	size /= esize;
> > +
> > +	if (size)
> > +		size = rounddown_pow_of_two(size);
> > +
> > +	if (size < 2)
> > +		return -EINVAL;
> > +
> > +	fifo->data = buffer;
> > +	fifo->in = fifo->out = 0;
> > +	fifo->mask = size - 1;
> > +	fifo->esize = esize;
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(__kfifo_init);
> > +
> > +static void kfifo_copy_in(struct __kfifo *fifo, const void *src,
> > +		unsigned int len, unsigned int off)
> > +{
> > +	unsigned int size = fifo->mask + 1;
> > +	unsigned int esize = fifo->esize;
> > +	unsigned int l;
> > +
> > +	off &= fifo->mask;
> > +	if (esize != 1) {
> > +		off *= esize;
> > +		size *= esize;
> > +		len *= esize;
> > +	}
> > +	l = min(len, size - off);
> > +
> > +	memcpy(fifo->data + off, src, l);
> > +	memcpy(fifo->data, src + l, len - l);
> > +	smp_wmb();
> 
> It would be better if all the barriers in this code had comments
> explaining why they're there.  Looking at the above code it's quite
> hard to determine which other code the barrier is protecting the data
> against.
> 

It should prevent to update the fifo counters, before the data in the
fifo are up to date.

> > +}
> > +
> >
> > ...
> >
> > +static unsigned long kfifo_copy_from_user(struct __kfifo *fifo,
> > +	const void *src, unsigned int len, unsigned int off,
> > +	unsigned int *copied)
> > +{
> > +	unsigned int size = fifo->mask + 1;
> > +	unsigned int esize = fifo->esize;
> > +	unsigned int l;
> > +	unsigned long ret;
> > +
> > +	off &= fifo->mask;
> > +	if (esize != 1) {
> > +		off *= esize;
> > +		size *= esize;
> > +		len *= esize;
> > +	}
> > +	l = min(len, size - off);
> > +
> > +	ret = copy_from_user(fifo->data + off, src, l);
> > +	if (unlikely(ret))
> > +		ret = roundup_diff(ret + len - l, esize);
> > +	else {
> > +		ret = copy_from_user(fifo->data, src + l, len - l);
> > +		if (unlikely(ret))
> > +			ret = roundup_diff(ret, esize);
> > +	}
> > +	smp_wmb();
> > +	if (copied)
> 
> Can `copied' ever be NULL?  If not, remove this test.

It was only a feature. If you don't like i will remove it.

> 
> > +		*copied = len - ret;
> > +	return ret;
> > +}
> 
> All pointers which refer to userspace should have the __user tag.  And
> the code should be checked with sparse, please.
> 
> It's rather hard to work out the meaning of this function's return value.
> 

I will add a comment.

> > +int __kfifo_from_user(struct __kfifo *fifo, const void __user *from,
> > +		unsigned long len, unsigned int *copied)
> > +{
> > +	unsigned int l;
> > +	unsigned long ret;
> > +	unsigned int esize = fifo->esize;
> > +	int err;
> > +
> > +	if (esize != 1)
> > +		len /= esize;
> > +
> > +	l = kfifo_unused(fifo);
> > +	if (len > l)
> > +		len = l;
> > +
> > +	ret = kfifo_copy_from_user(fifo, from, len, fifo->in, copied);
> > +	if (unlikely(ret)) {
> > +		len -= ret;
> > +		err = -EFAULT;
> > +	}
> > +	else
> > +		err = 0;
> > +	fifo->in += len;
> > +	return err;
> > +}
> > +EXPORT_SYMBOL(__kfifo_from_user);
> > +
> >
> > ...
> >
> > +static int setup_sgl_buf(struct scatterlist *sgl, void *buf, 
> > +		int nents, unsigned int len)
> > +{
> > +	int n;
> > +	unsigned int l;
> > +	unsigned int off;
> > +	struct page *page;
> > +
> > +	if (!nents)
> > +		return 0;
> > +
> > +	if (!len)
> > +		return 0;
> > +
> > +	n = 0;
> > +	page = virt_to_page(buf);
> > +	off = offset_in_page(buf);
> > +	l = 0;
> > +	
> > +	while(len >= l + PAGE_SIZE - off) {
> > +		struct page *npage;
> > +
> > +		l += PAGE_SIZE;
> > +		buf += PAGE_SIZE;
> > +		npage = virt_to_page(buf);
> > +		if (page_to_phys(page) != page_to_phys(npage) - l) {
> > +			sgl->page_link = 0;
> > +			sg_set_page(sgl++, page, l - off, off); 
> > +			if (++n == nents)
> > +				return n;
> > +			page = npage;
> > +			len -= l - off;
> > +			l = off = 0;
> > +		}
> > +	}
> > +	sgl->page_link = 0;
> > +	sg_set_page(sgl++, page, len, off); 
> > +	return n + 1;
> > +}
> 
> Again, I just don't see why all this sg and dma stuff is here.  Has it
> been tested?
> 

See above. I had it tested. But maybe i do some things in a wrong way.
For me it works.
  
> >
> > ...
> >
> > +/**
> > + * __kfifo_peek_n internal helper function for determinate the length of
> > + * the next record in the fifo
> > + */
> 
> This comment purports to be kerneldoc ("/**") but it isn't.
> 

Will be fixed.

> > +static unsigned int __kfifo_peek_n(struct __kfifo *fifo, size_t recsize)
> > +{
> > +	unsigned int l;
> > +	unsigned int mask = fifo->mask;
> > +	unsigned char *data = fifo->data;
> > +
> > +	l = __KFIFO_PEEK(data, fifo->out, mask);
> > +
> > +	if (--recsize)
> > +		l |= __KFIFO_PEEK(data, fifo->out + 1, mask) << 8;
> > +
> > +	return l;
> > +}
> > +
> > +#define	__KFIFO_POKE(data, in, mask, val) \
> > +	( \
> > +	(data)[(in) & (mask)] = (unsigned char)(val) \
> > +	)
> > +
> > +/**
> > + * __kfifo_poke_n internal helper function for storeing the length of
> > + * the record into the fifo
> > + */
> 
> Please check all kerneldoc stuff.
> 

Ok.


