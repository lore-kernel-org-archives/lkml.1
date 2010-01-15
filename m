Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab0AOXVB (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 18:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612Ab0AOXU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 18:20:59 -0500
Received: from www84.your-server.de ([213.133.104.84]:49735 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604Ab0AOXU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 18:20:59 -0500
Subject: [PATCH] enhanced reimplemention of the kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 16 Jan 2010 00:20:44 +0100
Message-ID: <1263597644.11690.24.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a complete reimplementation of the new kfifo API, which is now 
really generic, type save and type definable. 

The API is still stable, no code which use the current  kfifo API must 
be modified!

Here are the results of the text section usage:

Example 1:
			kfifo_put/_get	kfifo_in/out	current kfifo
dynamic allocated	0x000002a8	0x00000291	0x00000299
in place		0x00000291	0x0000026e	0x00000273

kfifo.c			new		old
text section size	0x00000535	0x000008b2

As you can see, kfifo_put/kfifo_get creates a little bit more memory than 
kfifo_in/kfifo_out, but i it much faster because it does all inline.

The code section needed by the kfifo library is the half as bevor.

ChangeLog:

16.01.2010 Kicked away dynamic record handling. If anybody want it please let me
           know.
           Add a esize field which represents the size of the element stored in
           the fifo. This will increase the size of the fifo stucture by 4 bytes 
           but obtain a smaller code.
           Generalized the kfifo.c funtions to handle byte and all other element 
           sizes in common functions.
           Shrink the code size of kfifo.c from 2k to 1k
           Code cleanup
15.01.2010 fix kfifo_dma_*() bugs
           add a DMA usage exmaple
           fix kfifo_free()
           prevent creation of fifo with less then 2 entries
           prevent a real in place fifo manipulation with kfifo_alloc(), 
           kfifo_init() or kfifo_free()
           make INIT_KFIFO save with a dynamic allocated fifo
14.01.2010 Change the size field of the fifo structure into a mask field, which
           is size - 1. This will save some instructions 
           Make the basic structure mode generic. Add a data pointer and mask
           field, also for real in place fifo, because the extra function parameter
           passing of the data pointer and and the fifo size was to costly
           Change all internal functions to work with the generic base structure
           Optimized the kfifo_put and kfifo_get macros to prevent an indirection
           Code cleanup
           Bug fixes in kfifo_dma_* macros
           Update examples
           Sync with kernel 2.6.33-rc4
06.01.2010 Add a note about locking: clarify when locking is needed
           Fix byte stream example
           Remove unnecessary typedefs
           Make checkpatch.pl clean: one error left, but there is no way to
           solve this...
28.12.2009 Sanitize kfifo_*_user() error handling (suggested by Andi Kleen)
           kfifo_from_user() and kfifo_to_user() will now return an error
           code and the number of copied bytes will be stored in a variable
           passed as pointer
           Make patch readable
           Update examples
           Fix a typo
27.12.2009 Sync with kernel 2.6.33-rc2
           Introduce new kfifo_initialized macro (suggested by Andi Kleen)
           Renamed kfifo_peek into kfifo_peek_len
           Introduce new kfifo_peek macro (suggest by Andi Kleen)
           Introduce new kfifo_out_peek macro (suggested by Andi Kleen)
           Fix broken kernel-doc notation
           Fix samples
21.12.2009 Fix checkpatch.pl, fix samples
20.12.2009 Bug fixing
           Fix samples
19.12.2009 First draft
13.12.2009 First implementation of a type safe fifo implementation, called kqueue

There are different types of a fifo which can not handled in C without a
lot of overhead. So i decided to write the API as a set of macros, which 
is the only way to do a kind of template meta programming without C++. 
This macros handles the different types of fifos in a transparent way.

There are a lot of benefits:

- Compile time handling of the different fifo types
- Better performance (a save put or get of an integer does only generate 
  9 assembly instructions on a x86) 
- Type save
- Cleaner interface, the additional kfifo_..._rec() functions are gone
- Easier to use
- Less error prone
- Different types of fifos: it is now possible to define a int fifo or
  any other type. See below for an example.
- Smaller footprint for none byte type fifos
- No need of creating a second hidden variable, like in the old DEFINE_KFIFO

The API was not changed.

There are now real in place fifos where the data space is a part of the 
structure. There is no need for an extra indirection to access the data.

The fifo needs now 20 byte plus the fifo space. Dynamic assigned or allocated 
does create a little bit more code.

Most of the macros code will be optimized away and simple generate a 
function call. Only the really small one generates inline code.

Additional you can now create fifos for any data type, not only the
"unsigned char" byte streamed fifos.

There is also a new kfifo_put and kfifo_get function, to handle a single
element in a fifo. This macros generates inline code, which is lit bit
larger but faster.

Here are the examples how to use it:

Example 1: an integer fifo

#include "kfifo.h"

#define FIFO_SIZE	32

#define	DYNAMIC
#ifdef DYNAMIC
static DECLARE_KFIFO_PTR(test, int);
#else
static DECLARE_KFIFO(test, int, FIFO_SIZE);
#endif

int testfunc(void)
{
	int		i;
	int		buf[6];
	unsigned int 	ret;
	unsigned int 	copied;

#ifdef DYNAMIC
	if (kfifo_alloc(&test, FIFO_SIZE, 0)) {
		printk("error kfifo_alloc\n");
		return 1;
	}
#else
	INIT_KFIFO(test);
#endif

	printk("int fifo test start\n");

	if (kfifo_initialized(&test))
		printk("fifo is initalized\n");

	for(i = 0; i != 10; i++)
		kfifo_put(&test, &i);

	printk("queue peek: %u\n", kfifo_peek_len(&test));

	ret = kfifo_to_user(&test, buf, kfifo_sizeof(&test) * 2, &copied);
	printk("ret: %d %u\n", ret, copied);
	ret = kfifo_from_user(&test, buf, copied, &copied);
	printk("ret: %d %u\n", ret, copied);
	ret = kfifo_out(&test, buf, 1);
	printk("ret: %d\n", ret);
	ret = kfifo_in(&test, buf, 1);
	printk("ret: %d\n", ret);

	for(i = 20; i != 30; i++)
		kfifo_put(&test, &i);

	printk("queue len: %u\n", kfifo_len(&test));

	if (kfifo_peek(&test, &i))
		printk("%d\n", i);

	while(kfifo_get(&test, &i))
		printk("%d ", i);
	printk("\n");

	return 0;
}


Example 2: DMA usage

#include "kfifo.h"

#define FIFO_SIZE	32

static struct kfifo fifo;

int testfunc(void)
{
	int 			i;
	unsigned int 		ret;
	/* kfifo_dma_* will never return more than two sgl entries */
	struct scatterlist	sg[2];

	printk("DMA fifo test start\n");

	if (kfifo_alloc(&fifo, FIFO_SIZE, 0)) {
		printk("error kfifo_alloc\n");
		return 1;
	}

	printk("queue size: %u\n", kfifo_size(&fifo));

	kfifo_in(&fifo, "test", 4);

	for(i = 0; i != 9; i++)
		kfifo_put(&fifo, &i);

	/* kick away first byte */
	kfifo_get(&fifo, &i);

	printk("queue len: %u\n", kfifo_len(&fifo));

	ret = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
	printk("DMA in byte count: %d\n", ret);

	/* if 0 was returned, fifo is full and no sgl was created */
	if (ret) {
		printk("scatterlist for receive:\n");
		for (i = 0; i < ARRAY_SIZE(sg); i++) {
			printk("sg[%d] -> page_link 0x%.8lx offset 0x%.8x len 0x%.8x\n",
					i, sg[i].page_link, sg[i].offset, sg[i].length);

			if (sg_is_last(&sg[i]))
				break;
		}

		/* but here your code to setup and exectute the dma operation */
		/* ... */

		/* example: zero bytes received */
		ret = 0;

		/* finish the dma operation and update the received data */
		kfifo_dma_in_finish(&fifo, ret);
	}

	ret = kfifo_dma_out_prepare(&fifo, sg, ARRAY_SIZE(sg), 8);
	printk("DMA out byte count: %d\n", ret);

	/* if 0 was returned, no data was available and no sgl was created */
	if (ret) {
		printk("scatterlist for transmit:\n");
		for (i = 0; i < ARRAY_SIZE(sg); i++) {
			printk("sg[%d] -> page_link 0x%.8lx offset 0x%.8x len 0x%.8x\n",
					i, sg[i].page_link, sg[i].offset, sg[i].length);

			if (sg_is_last(&sg[i]))
				break;
		}

		/* but here your code to setup and exectute the dma operation */
		/* ... */

		/* example: 5 bytes transmitted */
		ret = 5;

		/* finish the dma operation and update the transmitted data */
		kfifo_dma_out_finish(&fifo, ret);
	}

	printk("queue len: %u\n", kfifo_len(&fifo));

	return 0;
}


Example 3: a bytes stream fifo

#include "kfifo.h"

#define FIFO_SIZE	32

//#define	DYNAMIC
#ifdef DYNAMIC
static struct kfifo test[1];
#else
static DECLARE_KFIFO(test[1], unsigned char, FIFO_SIZE);
#endif

int testfunc(void)
{
	unsigned char	buf[6];
	unsigned char	i;
	unsigned int	ret;
	unsigned int 	copied;

	printk("byte stream fifo test start\n");

#ifdef DYNAMIC
	if (kfifo_alloc(test, FIFO_SIZE, 0)) {
		printk("error kfifo_alloc\n");
		return 1;
	}
#else
	INIT_KFIFO(test[0]);
#endif

	printk("queue size: %u\n", kfifo_size(test));

	kfifo_in(test, "hello", 5);

	for(i = 0; i != 9; i++)
		kfifo_put(test, &i);

	printk("queue peek: %u\n", kfifo_peek_len(test));

	i = kfifo_out(test, buf, 5);
	printk("buf: %.*s\n", i, buf);

	ret = kfifo_to_user(test, buf, sizeof(int), &copied);
	printk("ret: %d %u\n", ret, copied);
	ret = kfifo_from_user(test, buf, copied, &copied);
	printk("ret: %d %u\n", ret, copied);

	ret = kfifo_out(test, buf, 2);
	printk("ret: %d\n", ret);
	ret = kfifo_in(test, buf, ret);
	printk("ret: %d\n", ret);

	printk("queue len: %u\n", kfifo_len(test));

	for(i = 20; kfifo_put(test, &i); i++)
		;

	while(kfifo_get(test, &i))
		printk("%d ", i);
	printk("\n");

	return 0;
}


I know that this kind of macros are very sophisticated and not easy to
maintain. But i have all tested and it works as expected. I analyzed the
output of the compiler and for the x86 the code is as good as hand
written assembler code. For the byte stream fifo the generate code is exact 
the same as with the current kfifo implementation. For all other types of
fifos the code is smaller before, because the interface is easier to use. 

The main goal was to provide an API which is very intuitive, save and easy
to use. So linux will get now a powerful fifo API which provides all what 
a developer needs. This will save in the future a lot of kernel space, since
there is no need to write an own implementation. Most of the device driver 
developers need a fifo, and also deep kernel development will gain benefit 
from this API.

You can download the test code at www.seibold.net/kfifo.tgz

The patch-set is against linux 2.6.33-rc4. This code is ready to merge into 
the mm tree or linux next. Please review it and merge.

Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 linux-2.6.33-rc4.dummy/include/linux/kfifo.h |  610 -----------------------
 linux-2.6.33-rc4.dummy/kernel/kfifo.c        |  400 ---------------
 linux-2.6.33-rc4.new/include/linux/kfifo.h   |  687 +++++++++++++++++++++++++++
 linux-2.6.33-rc4.new/kernel/kfifo.c          |  377 ++++++++++++++
 4 files changed, 1064 insertions(+), 1010 deletions(-)

diff -u -N -r -p linux-2.6.33-rc4.orig/include/linux/kfifo.h linux-2.6.33-rc4.dummy/include/linux/kfifo.h
--- linux-2.6.33-rc4.orig/include/linux/kfifo.h	2010-01-14 17:08:28.275654594 +0100
+++ linux-2.6.33-rc4.dummy/include/linux/kfifo.h	1970-01-01 01:00:00.000000000 +0100
@@ -1,610 +0,0 @@
-/*
- * A generic kernel FIFO implementation.
- *
- * Copyright (C) 2009 Stefani Seibold <stefani@seibold.net>
- * Copyright (C) 2004 Stelian Pop <stelian@popies.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-
-/*
- * Howto porting drivers to the new generic fifo API:
- *
- * - Modify the declaration of the "struct kfifo *" object into a
- *   in-place "struct kfifo" object
- * - Init the in-place object with kfifo_alloc() or kfifo_init()
- *   Note: The address of the in-place "struct kfifo" object must be
- *   passed as the first argument to this functions
- * - Replace the use of __kfifo_put into kfifo_in and __kfifo_get
- *   into kfifo_out
- * - Replace the use of kfifo_put into kfifo_in_locked and kfifo_get
- *   into kfifo_out_locked
- *   Note: the spinlock pointer formerly passed to kfifo_init/kfifo_alloc
- *   must be passed now to the kfifo_in_locked and kfifo_out_locked
- *   as the last parameter.
- * - All formerly name __kfifo_* functions has been renamed into kfifo_*
- */
-
-#ifndef _LINUX_KFIFO_H
-#define _LINUX_KFIFO_H
-
-#include <linux/kernel.h>
-#include <linux/spinlock.h>
-
-struct kfifo {
-	unsigned char *buffer;	/* the buffer holding the data */
-	unsigned int size;	/* the size of the allocated buffer */
-	unsigned int in;	/* data is added at offset (in % size) */
-	unsigned int out;	/* data is extracted from off. (out % size) */
-};
-
-/*
- * Macros for declaration and initialization of the kfifo datatype
- */
-
-/* helper macro */
-#define __kfifo_initializer(s, b) \
-	(struct kfifo) { \
-		.size	= s, \
-		.in	= 0, \
-		.out	= 0, \
-		.buffer = b \
-	}
-
-/**
- * DECLARE_KFIFO - macro to declare a kfifo and the associated buffer
- * @name: name of the declared kfifo datatype
- * @size: size of the fifo buffer
- *
- * Note1: the macro can be used inside struct or union declaration
- * Note2: the macro creates two objects:
- *  A kfifo object with the given name and a buffer for the kfifo
- *  object named name##kfifo_buffer
- */
-#define DECLARE_KFIFO(name, size) \
-union { \
-	struct kfifo name; \
-	unsigned char name##kfifo_buffer[size + sizeof(struct kfifo)]; \
-}
-
-/**
- * INIT_KFIFO - Initialize a kfifo declared by DECLARE_KFIFO
- * @name: name of the declared kfifo datatype
- */
-#define INIT_KFIFO(name) \
-	name = __kfifo_initializer(sizeof(name##kfifo_buffer) - \
-				sizeof(struct kfifo), name##kfifo_buffer)
-
-/**
- * DEFINE_KFIFO - macro to define and initialize a kfifo
- * @name: name of the declared kfifo datatype
- * @size: size of the fifo buffer
- *
- * Note1: the macro can be used for global and local kfifo data type variables
- * Note2: the macro creates two objects:
- *  A kfifo object with the given name and a buffer for the kfifo
- *  object named name##kfifo_buffer
- */
-#define DEFINE_KFIFO(name, size) \
-	unsigned char name##kfifo_buffer[size]; \
-	struct kfifo name = __kfifo_initializer(size, name##kfifo_buffer)
-
-#undef __kfifo_initializer
-
-extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
-			unsigned int size);
-extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
-			gfp_t gfp_mask);
-extern void kfifo_free(struct kfifo *fifo);
-extern unsigned int kfifo_in(struct kfifo *fifo,
-				const unsigned char *from, unsigned int len);
-extern __must_check unsigned int kfifo_out(struct kfifo *fifo,
-				unsigned char *to, unsigned int len);
-
-/**
- * kfifo_reset - removes the entire FIFO contents
- * @fifo: the fifo to be emptied.
- */
-static inline void kfifo_reset(struct kfifo *fifo)
-{
-	fifo->in = fifo->out = 0;
-}
-
-/**
- * kfifo_reset_out - skip FIFO contents
- * @fifo: the fifo to be emptied.
- */
-static inline void kfifo_reset_out(struct kfifo *fifo)
-{
-	smp_mb();
-	fifo->out = fifo->in;
-}
-
-/**
- * kfifo_size - returns the size of the fifo in bytes
- * @fifo: the fifo to be used.
- */
-static inline __must_check unsigned int kfifo_size(struct kfifo *fifo)
-{
-	return fifo->size;
-}
-
-/**
- * kfifo_len - returns the number of used bytes in the FIFO
- * @fifo: the fifo to be used.
- */
-static inline unsigned int kfifo_len(struct kfifo *fifo)
-{
-	register unsigned int	out;
-
-	out = fifo->out;
-	smp_rmb();
-	return fifo->in - out;
-}
-
-/**
- * kfifo_is_empty - returns true if the fifo is empty
- * @fifo: the fifo to be used.
- */
-static inline __must_check int kfifo_is_empty(struct kfifo *fifo)
-{
-	return fifo->in == fifo->out;
-}
-
-/**
- * kfifo_is_full - returns true if the fifo is full
- * @fifo: the fifo to be used.
- */
-static inline __must_check int kfifo_is_full(struct kfifo *fifo)
-{
-	return kfifo_len(fifo) == kfifo_size(fifo);
-}
-
-/**
- * kfifo_avail - returns the number of bytes available in the FIFO
- * @fifo: the fifo to be used.
- */
-static inline __must_check unsigned int kfifo_avail(struct kfifo *fifo)
-{
-	return kfifo_size(fifo) - kfifo_len(fifo);
-}
-
-/**
- * kfifo_in_locked - puts some data into the FIFO using a spinlock for locking
- * @fifo: the fifo to be used.
- * @from: the data to be added.
- * @n: the length of the data to be added.
- * @lock: pointer to the spinlock to use for locking.
- *
- * This function copies at most @len bytes from the @from buffer into
- * the FIFO depending on the free space, and returns the number of
- * bytes copied.
- */
-static inline unsigned int kfifo_in_locked(struct kfifo *fifo,
-		const unsigned char *from, unsigned int n, spinlock_t *lock)
-{
-	unsigned long flags;
-	unsigned int ret;
-
-	spin_lock_irqsave(lock, flags);
-
-	ret = kfifo_in(fifo, from, n);
-
-	spin_unlock_irqrestore(lock, flags);
-
-	return ret;
-}
-
-/**
- * kfifo_out_locked - gets some data from the FIFO using a spinlock for locking
- * @fifo: the fifo to be used.
- * @to: where the data must be copied.
- * @n: the size of the destination buffer.
- * @lock: pointer to the spinlock to use for locking.
- *
- * This function copies at most @len bytes from the FIFO into the
- * @to buffer and returns the number of copied bytes.
- */
-static inline __must_check unsigned int kfifo_out_locked(struct kfifo *fifo,
-	unsigned char *to, unsigned int n, spinlock_t *lock)
-{
-	unsigned long flags;
-	unsigned int ret;
-
-	spin_lock_irqsave(lock, flags);
-
-	ret = kfifo_out(fifo, to, n);
-
-	/*
-	 * optimization: if the FIFO is empty, set the indices to 0
-	 * so we don't wrap the next time
-	 */
-	if (kfifo_is_empty(fifo))
-		kfifo_reset(fifo);
-
-	spin_unlock_irqrestore(lock, flags);
-
-	return ret;
-}
-
-extern void kfifo_skip(struct kfifo *fifo, unsigned int len);
-
-extern __must_check unsigned int kfifo_from_user(struct kfifo *fifo,
-	const void __user *from, unsigned int n);
-
-extern __must_check unsigned int kfifo_to_user(struct kfifo *fifo,
-	void __user *to, unsigned int n);
-
-/*
- * __kfifo_add_out internal helper function for updating the out offset
- */
-static inline void __kfifo_add_out(struct kfifo *fifo,
-				unsigned int off)
-{
-	smp_mb();
-	fifo->out += off;
-}
-
-/*
- * __kfifo_add_in internal helper function for updating the in offset
- */
-static inline void __kfifo_add_in(struct kfifo *fifo,
-				unsigned int off)
-{
-	smp_wmb();
-	fifo->in += off;
-}
-
-/*
- * __kfifo_off internal helper function for calculating the index of a
- * given offeset
- */
-static inline unsigned int __kfifo_off(struct kfifo *fifo, unsigned int off)
-{
-	return off & (fifo->size - 1);
-}
-
-/*
- * __kfifo_peek_n internal helper function for determinate the length of
- * the next record in the fifo
- */
-static inline unsigned int __kfifo_peek_n(struct kfifo *fifo,
-				unsigned int recsize)
-{
-#define __KFIFO_GET(fifo, off, shift) \
-	((fifo)->buffer[__kfifo_off((fifo), (fifo)->out+(off))] << (shift))
-
-	unsigned int l;
-
-	l = __KFIFO_GET(fifo, 0, 0);
-
-	if (--recsize)
-		l |= __KFIFO_GET(fifo, 1, 8);
-
-	return l;
-#undef	__KFIFO_GET
-}
-
-/*
- * __kfifo_poke_n internal helper function for storing the length of
- * the next record into the fifo
- */
-static inline void __kfifo_poke_n(struct kfifo *fifo,
-			unsigned int recsize, unsigned int n)
-{
-#define __KFIFO_PUT(fifo, off, val, shift) \
-		( \
-		(fifo)->buffer[__kfifo_off((fifo), (fifo)->in+(off))] = \
-		(unsigned char)((val) >> (shift)) \
-		)
-
-	__KFIFO_PUT(fifo, 0, n, 0);
-
-	if (--recsize)
-		__KFIFO_PUT(fifo, 1, n, 8);
-#undef	__KFIFO_PUT
-}
-
-/*
- * __kfifo_in_... internal functions for put date into the fifo
- * do not call it directly, use kfifo_in_rec() instead
- */
-extern unsigned int __kfifo_in_n(struct kfifo *fifo,
-	const void *from, unsigned int n, unsigned int recsize);
-
-extern unsigned int __kfifo_in_generic(struct kfifo *fifo,
-	const void *from, unsigned int n, unsigned int recsize);
-
-static inline unsigned int __kfifo_in_rec(struct kfifo *fifo,
-	const void *from, unsigned int n, unsigned int recsize)
-{
-	unsigned int ret;
-
-	ret = __kfifo_in_n(fifo, from, n, recsize);
-
-	if (likely(ret == 0)) {
-		if (recsize)
-			__kfifo_poke_n(fifo, recsize, n);
-		__kfifo_add_in(fifo, n + recsize);
-	}
-	return ret;
-}
-
-/**
- * kfifo_in_rec - puts some record data into the FIFO
- * @fifo: the fifo to be used.
- * @from: the data to be added.
- * @n: the length of the data to be added.
- * @recsize: size of record field
- *
- * This function copies @n bytes from the @from into the FIFO and returns
- * the number of bytes which cannot be copied.
- * A returned value greater than the @n value means that the record doesn't
- * fit into the buffer.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-static inline __must_check unsigned int kfifo_in_rec(struct kfifo *fifo,
-	void *from, unsigned int n, unsigned int recsize)
-{
-	if (!__builtin_constant_p(recsize))
-		return __kfifo_in_generic(fifo, from, n, recsize);
-	return __kfifo_in_rec(fifo, from, n, recsize);
-}
-
-/*
- * __kfifo_out_... internal functions for get date from the fifo
- * do not call it directly, use kfifo_out_rec() instead
- */
-extern unsigned int __kfifo_out_n(struct kfifo *fifo,
-	void *to, unsigned int reclen, unsigned int recsize);
-
-extern unsigned int __kfifo_out_generic(struct kfifo *fifo,
-	void *to, unsigned int n,
-	unsigned int recsize, unsigned int *total);
-
-static inline unsigned int __kfifo_out_rec(struct kfifo *fifo,
-	void *to, unsigned int n, unsigned int recsize,
-	unsigned int *total)
-{
-	unsigned int l;
-
-	if (!recsize) {
-		l = n;
-		if (total)
-			*total = l;
-	} else {
-		l = __kfifo_peek_n(fifo, recsize);
-		if (total)
-			*total = l;
-		if (n < l)
-			return l;
-	}
-
-	return __kfifo_out_n(fifo, to, l, recsize);
-}
-
-/**
- * kfifo_out_rec - gets some record data from the FIFO
- * @fifo: the fifo to be used.
- * @to: where the data must be copied.
- * @n: the size of the destination buffer.
- * @recsize: size of record field
- * @total: pointer where the total number of to copied bytes should stored
- *
- * This function copies at most @n bytes from the FIFO to @to and returns the
- * number of bytes which cannot be copied.
- * A returned value greater than the @n value means that the record doesn't
- * fit into the @to buffer.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-static inline __must_check unsigned int kfifo_out_rec(struct kfifo *fifo,
-	void *to, unsigned int n, unsigned int recsize,
-	unsigned int *total)
-
-{
-	if (!__builtin_constant_p(recsize))
-		return __kfifo_out_generic(fifo, to, n, recsize, total);
-	return __kfifo_out_rec(fifo, to, n, recsize, total);
-}
-
-/*
- * __kfifo_from_user_... internal functions for transfer from user space into
- * the fifo. do not call it directly, use kfifo_from_user_rec() instead
- */
-extern unsigned int __kfifo_from_user_n(struct kfifo *fifo,
-	const void __user *from, unsigned int n, unsigned int recsize);
-
-extern unsigned int __kfifo_from_user_generic(struct kfifo *fifo,
-	const void __user *from, unsigned int n, unsigned int recsize);
-
-static inline unsigned int __kfifo_from_user_rec(struct kfifo *fifo,
-	const void __user *from, unsigned int n, unsigned int recsize)
-{
-	unsigned int ret;
-
-	ret = __kfifo_from_user_n(fifo, from, n, recsize);
-
-	if (likely(ret == 0)) {
-		if (recsize)
-			__kfifo_poke_n(fifo, recsize, n);
-		__kfifo_add_in(fifo, n + recsize);
-	}
-	return ret;
-}
-
-/**
- * kfifo_from_user_rec - puts some data from user space into the FIFO
- * @fifo: the fifo to be used.
- * @from: pointer to the data to be added.
- * @n: the length of the data to be added.
- * @recsize: size of record field
- *
- * This function copies @n bytes from the @from into the
- * FIFO and returns the number of bytes which cannot be copied.
- *
- * If the returned value is equal or less the @n value, the copy_from_user()
- * functions has failed. Otherwise the record doesn't fit into the buffer.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-static inline __must_check unsigned int kfifo_from_user_rec(struct kfifo *fifo,
-	const void __user *from, unsigned int n, unsigned int recsize)
-{
-	if (!__builtin_constant_p(recsize))
-		return __kfifo_from_user_generic(fifo, from, n, recsize);
-	return __kfifo_from_user_rec(fifo, from, n, recsize);
-}
-
-/*
- * __kfifo_to_user_... internal functions for transfer fifo data into user space
- * do not call it directly, use kfifo_to_user_rec() instead
- */
-extern unsigned int __kfifo_to_user_n(struct kfifo *fifo,
-	void __user *to, unsigned int n, unsigned int reclen,
-	unsigned int recsize);
-
-extern unsigned int __kfifo_to_user_generic(struct kfifo *fifo,
-	void __user *to, unsigned int n, unsigned int recsize,
-	unsigned int *total);
-
-static inline unsigned int __kfifo_to_user_rec(struct kfifo *fifo,
-	void __user *to, unsigned int n,
-	unsigned int recsize, unsigned int *total)
-{
-	unsigned int l;
-
-	if (!recsize) {
-		l = n;
-		if (total)
-			*total = l;
-	} else {
-		l = __kfifo_peek_n(fifo, recsize);
-		if (total)
-			*total = l;
-		if (n < l)
-			return l;
-	}
-
-	return __kfifo_to_user_n(fifo, to, n, l, recsize);
-}
-
-/**
- * kfifo_to_user_rec - gets data from the FIFO and write it to user space
- * @fifo: the fifo to be used.
- * @to: where the data must be copied.
- * @n: the size of the destination buffer.
- * @recsize: size of record field
- * @total: pointer where the total number of to copied bytes should stored
- *
- * This function copies at most @n bytes from the FIFO to the @to.
- * In case of an error, the function returns the number of bytes which cannot
- * be copied.
- * If the returned value is equal or less the @n value, the copy_to_user()
- * functions has failed. Otherwise the record doesn't fit into the @to buffer.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-static inline __must_check unsigned int kfifo_to_user_rec(struct kfifo *fifo,
-		void __user *to, unsigned int n, unsigned int recsize,
-		unsigned int *total)
-{
-	if (!__builtin_constant_p(recsize))
-		return __kfifo_to_user_generic(fifo, to, n, recsize, total);
-	return __kfifo_to_user_rec(fifo, to, n, recsize, total);
-}
-
-/*
- * __kfifo_peek_... internal functions for peek into the next fifo record
- * do not call it directly, use kfifo_peek_rec() instead
- */
-extern unsigned int __kfifo_peek_generic(struct kfifo *fifo,
-				unsigned int recsize);
-
-/**
- * kfifo_peek_rec - gets the size of the next FIFO record data
- * @fifo: the fifo to be used.
- * @recsize: size of record field
- *
- * This function returns the size of the next FIFO record in number of bytes
- */
-static inline __must_check unsigned int kfifo_peek_rec(struct kfifo *fifo,
-	unsigned int recsize)
-{
-	if (!__builtin_constant_p(recsize))
-		return __kfifo_peek_generic(fifo, recsize);
-	if (!recsize)
-		return kfifo_len(fifo);
-	return __kfifo_peek_n(fifo, recsize);
-}
-
-/*
- * __kfifo_skip_... internal functions for skip the next fifo record
- * do not call it directly, use kfifo_skip_rec() instead
- */
-extern void __kfifo_skip_generic(struct kfifo *fifo, unsigned int recsize);
-
-static inline void __kfifo_skip_rec(struct kfifo *fifo,
-	unsigned int recsize)
-{
-	unsigned int l;
-
-	if (recsize) {
-		l = __kfifo_peek_n(fifo, recsize);
-
-		if (l + recsize <= kfifo_len(fifo)) {
-			__kfifo_add_out(fifo, l + recsize);
-			return;
-		}
-	}
-	kfifo_reset_out(fifo);
-}
-
-/**
- * kfifo_skip_rec - skip the next fifo out record
- * @fifo: the fifo to be used.
- * @recsize: size of record field
- *
- * This function skips the next FIFO record
- */
-static inline void kfifo_skip_rec(struct kfifo *fifo,
-	unsigned int recsize)
-{
-	if (!__builtin_constant_p(recsize))
-		__kfifo_skip_generic(fifo, recsize);
-	else
-		__kfifo_skip_rec(fifo, recsize);
-}
-
-/**
- * kfifo_avail_rec - returns the number of bytes available in a record FIFO
- * @fifo: the fifo to be used.
- * @recsize: size of record field
- */
-static inline __must_check unsigned int kfifo_avail_rec(struct kfifo *fifo,
-	unsigned int recsize)
-{
-	unsigned int l = kfifo_size(fifo) - kfifo_len(fifo);
-
-	return (l > recsize) ? l - recsize : 0;
-}
-
-#endif
diff -u -N -r -p linux-2.6.33-rc4.orig/kernel/kfifo.c linux-2.6.33-rc4.dummy/kernel/kfifo.c
--- linux-2.6.33-rc4.orig/kernel/kfifo.c	2010-01-14 17:08:28.851544315 +0100
+++ linux-2.6.33-rc4.dummy/kernel/kfifo.c	1970-01-01 01:00:00.000000000 +0100
@@ -1,400 +0,0 @@
-/*
- * A generic kernel FIFO implementation.
- *
- * Copyright (C) 2009 Stefani Seibold <stefani@seibold.net>
- * Copyright (C) 2004 Stelian Pop <stelian@popies.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/err.h>
-#include <linux/kfifo.h>
-#include <linux/log2.h>
-#include <linux/uaccess.h>
-
-static void _kfifo_init(struct kfifo *fifo, unsigned char *buffer,
-		unsigned int size)
-{
-	fifo->buffer = buffer;
-	fifo->size = size;
-
-	kfifo_reset(fifo);
-}
-
-/**
- * kfifo_init - initialize a FIFO using a preallocated buffer
- * @fifo: the fifo to assign the buffer
- * @buffer: the preallocated buffer to be used.
- * @size: the size of the internal buffer, this have to be a power of 2.
- *
- */
-void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size)
-{
-	/* size must be a power of 2 */
-	BUG_ON(!is_power_of_2(size));
-
-	_kfifo_init(fifo, buffer, size);
-}
-EXPORT_SYMBOL(kfifo_init);
-
-/**
- * kfifo_alloc - allocates a new FIFO internal buffer
- * @fifo: the fifo to assign then new buffer
- * @size: the size of the buffer to be allocated, this have to be a power of 2.
- * @gfp_mask: get_free_pages mask, passed to kmalloc()
- *
- * This function dynamically allocates a new fifo internal buffer
- *
- * The size will be rounded-up to a power of 2.
- * The buffer will be release with kfifo_free().
- * Return 0 if no error, otherwise the an error code
- */
-int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask)
-{
-	unsigned char *buffer;
-
-	/*
-	 * round up to the next power of 2, since our 'let the indices
-	 * wrap' technique works only in this case.
-	 */
-	if (!is_power_of_2(size)) {
-		BUG_ON(size > 0x80000000);
-		size = roundup_pow_of_two(size);
-	}
-
-	buffer = kmalloc(size, gfp_mask);
-	if (!buffer) {
-		_kfifo_init(fifo, 0, 0);
-		return -ENOMEM;
-	}
-
-	_kfifo_init(fifo, buffer, size);
-
-	return 0;
-}
-EXPORT_SYMBOL(kfifo_alloc);
-
-/**
- * kfifo_free - frees the FIFO internal buffer
- * @fifo: the fifo to be freed.
- */
-void kfifo_free(struct kfifo *fifo)
-{
-	kfree(fifo->buffer);
-}
-EXPORT_SYMBOL(kfifo_free);
-
-/**
- * kfifo_skip - skip output data
- * @fifo: the fifo to be used.
- * @len: number of bytes to skip
- */
-void kfifo_skip(struct kfifo *fifo, unsigned int len)
-{
-	if (len < kfifo_len(fifo)) {
-		__kfifo_add_out(fifo, len);
-		return;
-	}
-	kfifo_reset_out(fifo);
-}
-EXPORT_SYMBOL(kfifo_skip);
-
-static inline void __kfifo_in_data(struct kfifo *fifo,
-		const void *from, unsigned int len, unsigned int off)
-{
-	unsigned int l;
-
-	/*
-	 * Ensure that we sample the fifo->out index -before- we
-	 * start putting bytes into the kfifo.
-	 */
-
-	smp_mb();
-
-	off = __kfifo_off(fifo, fifo->in + off);
-
-	/* first put the data starting from fifo->in to buffer end */
-	l = min(len, fifo->size - off);
-	memcpy(fifo->buffer + off, from, l);
-
-	/* then put the rest (if any) at the beginning of the buffer */
-	memcpy(fifo->buffer, from + l, len - l);
-}
-
-static inline void __kfifo_out_data(struct kfifo *fifo,
-		void *to, unsigned int len, unsigned int off)
-{
-	unsigned int l;
-
-	/*
-	 * Ensure that we sample the fifo->in index -before- we
-	 * start removing bytes from the kfifo.
-	 */
-
-	smp_rmb();
-
-	off = __kfifo_off(fifo, fifo->out + off);
-
-	/* first get the data from fifo->out until the end of the buffer */
-	l = min(len, fifo->size - off);
-	memcpy(to, fifo->buffer + off, l);
-
-	/* then get the rest (if any) from the beginning of the buffer */
-	memcpy(to + l, fifo->buffer, len - l);
-}
-
-static inline unsigned int __kfifo_from_user_data(struct kfifo *fifo,
-	 const void __user *from, unsigned int len, unsigned int off)
-{
-	unsigned int l;
-	int ret;
-
-	/*
-	 * Ensure that we sample the fifo->out index -before- we
-	 * start putting bytes into the kfifo.
-	 */
-
-	smp_mb();
-
-	off = __kfifo_off(fifo, fifo->in + off);
-
-	/* first put the data starting from fifo->in to buffer end */
-	l = min(len, fifo->size - off);
-	ret = copy_from_user(fifo->buffer + off, from, l);
-
-	if (unlikely(ret))
-		return ret + len - l;
-
-	/* then put the rest (if any) at the beginning of the buffer */
-	return copy_from_user(fifo->buffer, from + l, len - l);
-}
-
-static inline unsigned int __kfifo_to_user_data(struct kfifo *fifo,
-		void __user *to, unsigned int len, unsigned int off)
-{
-	unsigned int l;
-	int ret;
-
-	/*
-	 * Ensure that we sample the fifo->in index -before- we
-	 * start removing bytes from the kfifo.
-	 */
-
-	smp_rmb();
-
-	off = __kfifo_off(fifo, fifo->out + off);
-
-	/* first get the data from fifo->out until the end of the buffer */
-	l = min(len, fifo->size - off);
-	ret = copy_to_user(to, fifo->buffer + off, l);
-
-	if (unlikely(ret))
-		return ret + len - l;
-
-	/* then get the rest (if any) from the beginning of the buffer */
-	return copy_to_user(to + l, fifo->buffer, len - l);
-}
-
-unsigned int __kfifo_in_n(struct kfifo *fifo,
-	const void *from, unsigned int len, unsigned int recsize)
-{
-	if (kfifo_avail(fifo) < len + recsize)
-		return len + 1;
-
-	__kfifo_in_data(fifo, from, len, recsize);
-	return 0;
-}
-EXPORT_SYMBOL(__kfifo_in_n);
-
-/**
- * kfifo_in - puts some data into the FIFO
- * @fifo: the fifo to be used.
- * @from: the data to be added.
- * @len: the length of the data to be added.
- *
- * This function copies at most @len bytes from the @from buffer into
- * the FIFO depending on the free space, and returns the number of
- * bytes copied.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-unsigned int kfifo_in(struct kfifo *fifo, const unsigned char *from,
-				unsigned int len)
-{
-	len = min(kfifo_avail(fifo), len);
-
-	__kfifo_in_data(fifo, from, len, 0);
-	__kfifo_add_in(fifo, len);
-	return len;
-}
-EXPORT_SYMBOL(kfifo_in);
-
-unsigned int __kfifo_in_generic(struct kfifo *fifo,
-	const void *from, unsigned int len, unsigned int recsize)
-{
-	return __kfifo_in_rec(fifo, from, len, recsize);
-}
-EXPORT_SYMBOL(__kfifo_in_generic);
-
-unsigned int __kfifo_out_n(struct kfifo *fifo,
-	void *to, unsigned int len, unsigned int recsize)
-{
-	if (kfifo_len(fifo) < len + recsize)
-		return len;
-
-	__kfifo_out_data(fifo, to, len, recsize);
-	__kfifo_add_out(fifo, len + recsize);
-	return 0;
-}
-EXPORT_SYMBOL(__kfifo_out_n);
-
-/**
- * kfifo_out - gets some data from the FIFO
- * @fifo: the fifo to be used.
- * @to: where the data must be copied.
- * @len: the size of the destination buffer.
- *
- * This function copies at most @len bytes from the FIFO into the
- * @to buffer and returns the number of copied bytes.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-unsigned int kfifo_out(struct kfifo *fifo, unsigned char *to, unsigned int len)
-{
-	len = min(kfifo_len(fifo), len);
-
-	__kfifo_out_data(fifo, to, len, 0);
-	__kfifo_add_out(fifo, len);
-
-	return len;
-}
-EXPORT_SYMBOL(kfifo_out);
-
-unsigned int __kfifo_out_generic(struct kfifo *fifo,
-	void *to, unsigned int len, unsigned int recsize,
-	unsigned int *total)
-{
-	return __kfifo_out_rec(fifo, to, len, recsize, total);
-}
-EXPORT_SYMBOL(__kfifo_out_generic);
-
-unsigned int __kfifo_from_user_n(struct kfifo *fifo,
-	const void __user *from, unsigned int len, unsigned int recsize)
-{
-	if (kfifo_avail(fifo) < len + recsize)
-		return len + 1;
-
-	return __kfifo_from_user_data(fifo, from, len, recsize);
-}
-EXPORT_SYMBOL(__kfifo_from_user_n);
-
-/**
- * kfifo_from_user - puts some data from user space into the FIFO
- * @fifo: the fifo to be used.
- * @from: pointer to the data to be added.
- * @len: the length of the data to be added.
- *
- * This function copies at most @len bytes from the @from into the
- * FIFO depending and returns the number of copied bytes.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-unsigned int kfifo_from_user(struct kfifo *fifo,
-	const void __user *from, unsigned int len)
-{
-	len = min(kfifo_avail(fifo), len);
-	len -= __kfifo_from_user_data(fifo, from, len, 0);
-	__kfifo_add_in(fifo, len);
-	return len;
-}
-EXPORT_SYMBOL(kfifo_from_user);
-
-unsigned int __kfifo_from_user_generic(struct kfifo *fifo,
-	const void __user *from, unsigned int len, unsigned int recsize)
-{
-	return __kfifo_from_user_rec(fifo, from, len, recsize);
-}
-EXPORT_SYMBOL(__kfifo_from_user_generic);
-
-unsigned int __kfifo_to_user_n(struct kfifo *fifo,
-	void __user *to, unsigned int len, unsigned int reclen,
-	unsigned int recsize)
-{
-	unsigned int ret;
-
-	if (kfifo_len(fifo) < reclen + recsize)
-		return len;
-
-	ret = __kfifo_to_user_data(fifo, to, reclen, recsize);
-
-	if (likely(ret == 0))
-		__kfifo_add_out(fifo, reclen + recsize);
-
-	return ret;
-}
-EXPORT_SYMBOL(__kfifo_to_user_n);
-
-/**
- * kfifo_to_user - gets data from the FIFO and write it to user space
- * @fifo: the fifo to be used.
- * @to: where the data must be copied.
- * @len: the size of the destination buffer.
- *
- * This function copies at most @len bytes from the FIFO into the
- * @to buffer and returns the number of copied bytes.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-unsigned int kfifo_to_user(struct kfifo *fifo,
-	void __user *to, unsigned int len)
-{
-	len = min(kfifo_len(fifo), len);
-	len -= __kfifo_to_user_data(fifo, to, len, 0);
-	__kfifo_add_out(fifo, len);
-	return len;
-}
-EXPORT_SYMBOL(kfifo_to_user);
-
-unsigned int __kfifo_to_user_generic(struct kfifo *fifo,
-	void __user *to, unsigned int len, unsigned int recsize,
-	unsigned int *total)
-{
-	return __kfifo_to_user_rec(fifo, to, len, recsize, total);
-}
-EXPORT_SYMBOL(__kfifo_to_user_generic);
-
-unsigned int __kfifo_peek_generic(struct kfifo *fifo, unsigned int recsize)
-{
-	if (recsize == 0)
-		return kfifo_avail(fifo);
-
-	return __kfifo_peek_n(fifo, recsize);
-}
-EXPORT_SYMBOL(__kfifo_peek_generic);
-
-void __kfifo_skip_generic(struct kfifo *fifo, unsigned int recsize)
-{
-	__kfifo_skip_rec(fifo, recsize);
-}
-EXPORT_SYMBOL(__kfifo_skip_generic);
-
diff -u -N -r -p linux-2.6.33-rc4.dummy/include/linux/kfifo.h linux-2.6.33-rc4.new/include/linux/kfifo.h
--- linux-2.6.33-rc4.dummy/include/linux/kfifo.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.33-rc4.new/include/linux/kfifo.h	2010-01-15 23:55:18.341315241 +0100
@@ -0,0 +1,687 @@
+/*
+ * A generic kernel FIFO implementation
+ *
+ * Copyright (C) 2009/2010 Stefani Seibold <stefani@seibold.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef _LINUX_KFIFO_H
+#define _LINUX_KFIFO_H
+
+/*
+ * How to porting drivers to the new generic FIFO API:
+ *
+ * - Modify the declaration of the "struct kfifo *" object into a
+ *   in-place "struct kfifo" object
+ * - Init the in-place object with kfifo_alloc() or kfifo_init()
+ *   Note: The address of the in-place "struct kfifo" object must be
+ *   passed as the first argument to this functions
+ * - Replace the use of __kfifo_put into kfifo_in and __kfifo_get
+ *   into kfifo_out
+ * - Replace the use of kfifo_put into kfifo_in_locked and kfifo_get
+ *   into kfifo_out_locked
+ *   Note: the spinlock pointer formerly passed to kfifo_init/kfifo_alloc
+ *   must be passed now to the kfifo_in_locked and kfifo_out_locked
+ *   as the last parameter.
+ * - The formerly __kfifo_* functions are renamed into kfifo_*
+ */
+
+/*
+ * Note about locking : There is no locking required until only * one reader
+ * and one writer is using the fifo and no kfifo_reset() will be * called.
+ *  kfifo_reset_out() can be safely used, until it will be only called
+ * in the reader thread.
+ *  For multiple writer and one reader there is only a need to lock the writer.
+ * And vice versa for only one writer and multiple reader there is only a need
+ * to lock the reader.
+ */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/stddef.h>
+#include <linux/scatterlist.h>
+
+struct __kfifo {
+	unsigned int	in;
+	unsigned int	out;
+	unsigned int	mask;
+	unsigned int	esize;
+	void		*data;
+};
+
+#define __STRUCT_KFIFO_COMMON(datatype, recsize, ptrtype) \
+	union { \
+		struct __kfifo	kfifo; \
+		datatype	*type; \
+		ptrtype		*ptr; \
+		const ptrtype	*ptr_const; \
+	}
+
+#define __STRUCT_KFIFO(type, size, recsize, ptrtype) \
+{ \
+	__STRUCT_KFIFO_COMMON(type, recsize, ptrtype); \
+	type		buf[((size < 2) || (size & (size - 1))) ? -1 : size]; \
+}
+
+#define STRUCT_KFIFO(type, size) \
+	struct __STRUCT_KFIFO(type, size, 0, type)
+
+#define __STRUCT_KFIFO_PTR(type, recsize, ptrtype) \
+{ \
+	__STRUCT_KFIFO_COMMON(type, recsize, ptrtype); \
+	type		buf[0]; \
+}
+
+#define STRUCT_KFIFO_PTR(type) \
+	struct __STRUCT_KFIFO_PTR(type, 0, type)
+
+/*
+ * define compatibility "struct kfifo" for dynamic allocated fifos
+ */
+struct kfifo __STRUCT_KFIFO_PTR(unsigned char, 0, void);
+
+/*
+ * DECLARE_KFIFO_PTR - macro to declare a fifo pointer object
+ * @fifo: name of the declared fifo
+ * @type: type of the fifo elements
+ * @size: the number of elements in the fifo, this must be a power of 2.
+ */
+#define DECLARE_KFIFO_PTR(fifo, type)	STRUCT_KFIFO_PTR(type) fifo
+
+/* helper macro */
+#define	__is_kfifo_ptr(fifo)	(sizeof(*fifo) == sizeof(struct __kfifo))
+
+#define __kfifo_initializer(fifo) \
+	(typeof(fifo)) { \
+		{ \
+			{ \
+			.in	= 0, \
+			.out	= 0, \
+			.mask	= __is_kfifo_ptr(&fifo) ? \
+				  0 : \
+				  sizeof((fifo).buf)/sizeof(*(fifo).buf) - 1, \
+			.esize	= sizeof(*(fifo).buf), \
+			.data	= __is_kfifo_ptr(&fifo) ? \
+				0 : \
+				(fifo).buf, \
+			} \
+		} \
+	}
+
+/*
+ * INIT_KFIFO - Initialize a fifo declared by DECLARE_KFIFO
+ * @fifo: name of the declared fifo datatype
+ */
+#define INIT_KFIFO(fifo)	fifo = __kfifo_initializer(fifo)
+
+/*
+ * DECLARE_KFIFO - macro to declare a fifo object
+ * @fifo: name of the declared fifo
+ * @type: type of the fifo elements
+ * @size: the number of elements in the fifo, this must be a power of 2.
+ */
+#define DECLARE_KFIFO(fifo, type, size)	STRUCT_KFIFO(type, size) fifo
+
+/*
+ * DEFINE_KFIFO - macro to define and initialize a fifo
+ * @fifo: name of the declared fifo datatype
+ * @type: type of the fifo elements
+ * @size: the number of elements in the fifo, this must be a power of 2.
+ *
+ * Note: the macro can be used for global and local fifo data type variables
+ */
+#define DEFINE_KFIFO(fifo, type, size) \
+	DECLARE_KFIFO(fifo, type, size) = __kfifo_initializer(fifo)
+
+static inline unsigned int __must_check __kfifo_check(unsigned int val)
+{
+	return val;
+}
+
+/*
+ * kfifo_initialized - Check if kfifo is initialized.
+ * @fifo: fifo to check
+ * Return %true if FIFO is initialized, otherwise %false.
+ * Assumes the fifo was 0 before.
+ *
+ * Note: for in place fifo's this macro returns alway true
+ */
+#define kfifo_initialized(fifo) ((fifo)->kfifo.data != 0)
+
+/*
+ * kfifo_sizeof - returns the size of a fifo element
+ * @fifo: the fifo to be used.
+ */
+#define kfifo_sizeof(fifo)	((fifo)->kfifo.esize)
+
+/*
+ * kfifo_size - returns the size of the fifo in elements
+ * @fifo: the fifo to be used.
+ */
+#define kfifo_size(fifo)	((fifo)->kfifo.mask + 1)
+
+/*
+ * kfifo_reset - removes the entire fifo content
+ * @fifo: the fifo to be used.
+ *
+ * Note: usage of kfifo_reset() is dangerous. It should be only called when the
+ * fifo is exclusived locked or when it is secured that no other thread is
+ * accessing the fifo.
+ */
+#define kfifo_reset(fifo) \
+(void)({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	__tmp->kfifo.in = __tmp->kfifo.out = 0; \
+})
+
+/*
+ * kfifo_reset_out - skip fifo content
+ * @fifo: the fifo to be used.
+ *
+ * Note: The usage of kfifo_reset_out() is safe until it will be only called
+ * from the reader thread and there is only one concurrent reader. Otherwise
+ * it is dangerous and must be handled in the same way as kfifo_reset().
+ */
+#define kfifo_reset_out(fifo)	\
+(void)({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	__tmp->kfifo.out = __tmp->kfifo.in; \
+})
+
+/*
+ * kfifo_len - returns the number of used elements in the fifo
+ * @fifo: the fifo to be used.
+ */
+#define kfifo_len(fifo) \
+({ \
+	typeof(fifo + 1) __tmpl = (fifo); \
+	__tmpl->kfifo.in - __tmpl->kfifo.out; \
+})
+#define	kfifo_peek_len(fifo)	kfifo_len(fifo)
+
+/*
+ * kfifo_is_empty - returns true if the fifo is empty
+ * @fifo: the fifo to be used.
+ */
+#define	kfifo_is_empty(fifo) \
+({ \
+	typeof(fifo + 1) __tmpq = (fifo); \
+	__tmpq->kfifo.in == __tmpq->kfifo.out; \
+})
+
+/*
+ * kfifo_is_full - returns true if the fifo is full
+ * @fifo: the fifo to be used.
+ */
+#define	kfifo_is_full(fifo) \
+({ \
+	typeof(fifo + 1) __tmpq = (fifo); \
+	kfifo_len(__tmpq) > __tmpq->kfifo.mask; \
+})
+
+/*
+ * kfifo_avail - returns the number of elements available in the fifo
+ * @fifo: the fifo to be used.
+ */
+#define	kfifo_avail(fifo) \
+__kfifo_check( \
+({ \
+	typeof(fifo + 1) __tmpq = (fifo); \
+	kfifo_size(__tmpq) - kfifo_len(__tmpq); \
+}) \
+)
+
+/*
+ * kfifo_skip - skip output data
+ * @fifo: the fifo to be used.
+ */
+#define	kfifo_skip(fifo)	(fifo)->kfifo.out++
+
+/*
+ * kfifo_alloc - dynamically allocates a new fifo
+ * @fifo: pointer to the fifo
+ * @size: the number of elements in the fifo, this must be a power of 2.
+ * @gfp_mask: get_free_pages mask, passed to kmalloc()
+ *
+ * This macro dynamically allocates a new fifo.
+ *
+ * The numer of elements will be rounded-up to a power of 2.
+ * The fifo will be release with kfifo_free().
+ * Return 0 if no error, otherwise an error code
+ */
+#define kfifo_alloc(fifo, size, gfp_mask) \
+__kfifo_check( \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__is_kfifo_ptr(__tmp) ? \
+	__kfifo_alloc(__kfifo, size, sizeof(*__tmp->type), gfp_mask) : \
+ 	-EINVAL; \
+}) \
+)
+
+/*
+ * kfifo_free - frees the fifo
+ * @fifo: the fifo to be freed.
+ */
+#define kfifo_free(fifo)	\
+({\ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	if (__is_kfifo_ptr(__tmp)) \
+		__kfifo_free(__kfifo); \
+})
+
+/*
+ * kfifo_init - initialize a FIFO using a preallocated buffer
+ * @fifo: the fifo to assign the buffer
+ * @buffer: the preallocated buffer to be used.
+ * @size: the size of the internal buffer, this have to be a power of 2.
+ */
+#define kfifo_init(fifo, buffer, size) \
+__kfifo_check( \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__is_kfifo_ptr(__tmp) ? \
+	__kfifo_init(__kfifo, buffer, size, sizeof(*__tmp->type)) : \
+ 	-EINVAL; \
+}) \
+)
+
+/*
+ * kfifo_put - put data into the fifo
+ * @fifo: the fifo to be used.
+ * @val: the data to be added.
+ *
+ * This macro copies the given value into the fifo.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kfifo_put(fifo, val) \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	typeof(val + 1) __val = (val); \
+	unsigned int __ret; \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	if (0) { \
+		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
+		__dummy = (typeof(__val))NULL; \
+	} \
+	__ret = !kfifo_is_full(__tmp); \
+	if (__ret) { \
+		(__is_kfifo_ptr(__tmp) ? \
+		((typeof(__tmp->type))__kfifo->data) : \
+		(__tmp->buf) \
+		)[__kfifo->in & __tmp->kfifo.mask] = \
+			*(typeof(__tmp->type))__val; \
+		smp_wmb(); \
+		__kfifo->in++; \
+	} \
+	__ret; \
+})
+
+/*
+ * kfifo_get - get data from the fifo
+ * @fifo: the fifo to be used.
+ * @val: the var where to store the data to be added.
+ *
+ * This macro returns the data from the fifo
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kfifo_get(fifo, val) \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	typeof(val + 1) __val = (val); \
+	unsigned int __ret; \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	if (0) \
+		__val = (typeof(__tmp->ptr))0; \
+	__ret = !kfifo_is_empty(__tmp); \
+	if (__ret) { \
+		*(typeof(__tmp->type))__val = \
+			(__is_kfifo_ptr(__tmp) ? \
+			((typeof(__tmp->type))__kfifo->data) : \
+			(__tmp->buf) \
+			)[__kfifo->out & __tmp->kfifo.mask]; \
+		smp_wmb(); \
+		__kfifo->out++; \
+	} \
+	__ret; \
+})
+
+/*
+ * kfifo_peek - get data from the fifo without removing
+ * @fifo: the fifo to be used.
+ * @val: the var where to store the data to be added.
+ *
+ * This macro returns the data from the fifo without removing it from the fifo
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kfifo_peek(fifo, val) \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	typeof(val + 1) __val = (val); \
+	unsigned int __ret; \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	if (0) \
+		__val = (typeof(__tmp->ptr))0; \
+	__ret = !kfifo_is_empty(__tmp); \
+	if (__ret) { \
+		*(typeof(__tmp->type))__val = \
+			(__is_kfifo_ptr(__tmp) ? \
+			((typeof(__tmp->type))__kfifo->data) : \
+			(__tmp->buf) \
+			)[__kfifo->out & __tmp->kfifo.mask]; \
+		smp_wmb(); \
+	} \
+	__ret; \
+})
+
+/*
+ * kfifo_in - puts some data into the fifo
+ * @fifo: the fifo to be used.
+ * @buf: the data to be added.
+ * @n: number of elements to be added
+ *
+ * This macro copies the given values buffer into the fifo and returns the
+ * number of copied elements.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kfifo_in(fifo, buf, n) \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	typeof(buf + 1) __buf = (buf); \
+	unsigned long __n = (n); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	if (0) { \
+		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
+		__dummy = (typeof(__buf))NULL; \
+	} \
+	__kfifo_in(__kfifo, __buf, __n); \
+})
+
+/*
+ * kfifo_in_locked - puts some data into the fifo using a spinlock for locking
+ * @fifo: the fifo to be used.
+ * @buf: the data to be added.
+ * @n: number of elements to be added
+ * @lock: pointer to the spinlock to use for locking.
+ *
+ * This macro copies the given values buffer into the fifo and returns the
+ * number of copied elements.
+ */
+#define	kfifo_in_locked(fifo, buf, n, lock) \
+({ \
+	unsigned long __flags; \
+	unsigned int __ret; \
+	spin_lock_irqsave(lock, __flags); \
+	__ret = kfifo_in(fifo, buf, n); \
+	spin_unlock_irqrestore(lock, __flags); \
+	__ret; \
+})
+
+/*
+ * kfifo_out - gets some data from the fifo
+ * @fifo: the fifo to be used.
+ * @buf: pointer to the storage buffer
+ * @n: max. number of elements to get
+ *
+ * This macro get the data from the fifo and return the numbers of elements
+ * copied.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kfifo_out(fifo, buf, n) \
+__kfifo_check( \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	typeof(buf + 1) __buf = (buf); \
+	unsigned long __n = (n); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	if (0) { \
+		typeof(__tmp->ptr) __dummy = 0; \
+		__buf = __dummy; \
+	} \
+	__kfifo_out(__kfifo, __buf, __n); \
+}) \
+)
+
+/*
+ * kfifo_out_locked - gets some data from the fifo using a spinlock for locking
+ * @fifo: the fifo to be used.
+ * @buf: pointer to the storage buffer
+ * @n: max. number of elements to get
+ * @lock: pointer to the spinlock to use for locking.
+ *
+ * This macro get the data from the fifo and return the numbers of elements
+ * copied.
+ */
+#define	kfifo_out_locked(fifo, buf, n, lock) \
+__kfifo_check( \
+({ \
+	unsigned long __flags; \
+	unsigned int __ret; \
+	spin_lock_irqsave(lock, __flags); \
+	__ret = kfifo_out(fifo, buf, n); \
+	spin_unlock_irqrestore(lock, __flags); \
+	__ret; \
+}) \
+)
+
+/*
+ * kfifo_from_user - puts some data from user space into the fifo
+ * @fifo: the fifo to be used.
+ * @from: pointer to the data to be added.
+ * @len: the length of the data to be added.
+ * @copied: pointer to output variable to store the number of copied bytes.
+ *
+ * This macro copies at most @len bytes from the @from into the
+ * fifo, depending of the available space and returns -EFAULT/0
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kfifo_from_user(fifo, from, len, copied) \
+__kfifo_check( \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	const void __user *__from = (from); \
+	unsigned int __len = (len); \
+	unsigned int *__copied = (copied); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__kfifo_from_user(__kfifo, __from, __len, __copied); \
+}) \
+)
+
+/*
+ * kfifo_to_user - copies data from the fifo into user space
+ * @fifo: the fifo to be used.
+ * @to: where the data must be copied.
+ * @len: the size of the destination buffer.
+ * @copied: pointer to output variable to store the number of copied bytes.
+ *
+ * This macro copies at most @len bytes from the fifo into the
+ * @to buffer and returns -EFAULT/0.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kfifo_to_user(fifo, to, len, copied) \
+__kfifo_check( \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	void __user *__to = (to); \
+	unsigned int __len = (len); \
+	unsigned int *__copied = (copied); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__kfifo_to_user(__kfifo, __to, __len, __copied); \
+}) \
+)
+
+/*
+ * kfifo_dma_in_prepare - setup a scatterlist for DMA input
+ * @fifo: the fifo to be used.
+ * @sgl: pointer to the scatterlist array.
+ * @nents: number of entries in the scatterlist array (should be 1 or 2).
+ * @len: number of elements to transfer.
+ *
+ * This macro fills a scatterlist for DMA input.
+ * It returns the number of bytes which are available for the transfer.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macros.
+ */
+#define	kfifo_dma_in_prepare(fifo, sgl, nents, len) \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	struct scatterlist *__sgl = (sgl); \
+	int __nents = (nents); \
+	unsigned int __len = (len); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__kfifo_dma_in_prepare(__kfifo,__sgl, __nents, __len); \
+})
+
+/*
+ * kfifo_dma_in_finish - finish a DMA IN operation
+ * @fifo: the fifo to be used.
+ * @len: number of bytes to received.
+ *
+ * This macro finish a DMA IN operation. The in counter will be updated by
+ * the len parameter. No error checking will be done.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macros.
+ */
+#define kfifo_dma_in_finish(fifo, len) \
+(void)({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	unsigned int __len = (len); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__kfifo->in += __len / sizeof(*__tmp->type); \
+})
+
+/*
+ * kfifo_dma_out_prepare - setup a scatterlist for DMA output
+ * @fifo: the fifo to be used.
+ * @sgl: pointer to the scatterlist array.
+ * @nents: number of entries in the scatterlist array (should be 1 or 2).
+ * @len: number of elements to transfer.
+ *
+ * This macro fills a scatterlist for DMA output which at most @len bytes
+ * to transfer.
+ * It returns the number of bytes which are available for the transfer.
+ * A zero means there is no space available and the scatterlist is not filled
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macros.
+ */
+#define	kfifo_dma_out_prepare(fifo, sgl, nents, len) \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	struct scatterlist *__sgl = (sgl); \
+	int __nents = (nents); \
+	unsigned int __len = (len); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__kfifo_dma_out_prepare(__kfifo, __sgl, __nents, __len); \
+})
+
+/*
+ * kfifo_dma_out_finish - finish a DMA OUT operation
+ * @fifo: the fifo to be used.
+ * @len: number of bytes transferd.
+ *
+ * This macro finish a DMA OUT operation. The out counter will be updated by
+ * the len parameter. No error checking will be done.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macros.
+ */
+#define kfifo_dma_out_finish(fifo, len) \
+(void)({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	unsigned int __len = (len); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__kfifo->out += __len / sizeof(*__tmp->type); \
+})
+
+/*
+ * kfifo_out_peek - gets some data from the fifo
+ * @fifo: the fifo to be used.
+ * @buf: pointer to the storage buffer
+ * @n: max. number of elements to get
+ *
+ * This macro get the data from the fifo and return the numbers of elements
+ * copied. The data is not removed from the FIFO.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kfifo_out_peek(fifo, buf, n) \
+__kfifo_check( \
+({ \
+	typeof(fifo + 1) __tmp = (fifo); \
+	typeof(buf + 1) __buf = (buf); \
+	unsigned long __n = (n); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	if (0) { \
+		typeof(__tmp->ptr) __dummy __attribute__ ((unused)) = 0; \
+		__buf = __dummy; \
+	} \
+	__kfifo_out_peek(__kfifo, __buf, __n); \
+}) \
+)
+
+extern int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
+	size_t esize, gfp_t gfp_mask);
+
+extern void __kfifo_free(struct __kfifo *fifo);
+
+extern int __kfifo_init(struct __kfifo *fifo, void *buffer,
+	unsigned int size, size_t esize);
+
+extern unsigned int __kfifo_in(struct __kfifo *fifo,
+	const void *buf, unsigned int len);
+
+extern unsigned int __kfifo_out(struct __kfifo *fifo,
+	void *buf, unsigned int len);
+
+extern int __kfifo_from_user(struct __kfifo *fifo,
+	const void __user *from, unsigned long len, unsigned int *copied);
+
+extern int __kfifo_to_user(struct __kfifo *fifo,
+	void __user *to, unsigned long len, unsigned int *copied);
+
+extern unsigned int __kfifo_dma_in_prepare(struct __kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int len);
+
+extern unsigned int __kfifo_dma_out_prepare(struct __kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int len);
+
+extern unsigned int __kfifo_out_peek(struct __kfifo *fifo,
+	void *buf, unsigned int len);
+
+#endif
+
diff -u -N -r -p linux-2.6.33-rc4.dummy/kernel/kfifo.c linux-2.6.33-rc4.new/kernel/kfifo.c
--- linux-2.6.33-rc4.dummy/kernel/kfifo.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.33-rc4.new/kernel/kfifo.c	2010-01-15 23:55:25.864306738 +0100
@@ -0,0 +1,377 @@
+/*
+ * A generic kernel FIFO implementation
+ *
+ * Copyright (C) 2009/2010 Stefani Seibold <stefani@seibold.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/kfifo.h>
+#include <linux/log2.h>
+#include <linux/uaccess.h>
+
+#define	roundup_diff(val, size)	(((val) + (size - 1)) / size)
+
+int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
+		size_t esize, gfp_t gfp_mask)
+{
+	/*
+	 * round up to the next power of 2, since our 'let the indices
+	 * wrap' technique works only in this case.
+	 */
+	if (!is_power_of_2(size))
+		size = rounddown_pow_of_two(size);
+
+	if (size < 2)
+		return -EINVAL;
+
+	fifo->in = fifo->out = 0;
+	fifo->data = kmalloc(size * esize, gfp_mask);
+
+	if (!fifo->data) {
+		fifo->mask = 0;
+		return -ENOMEM;
+	}
+
+	fifo->mask = size - 1;
+	fifo->esize = esize;
+
+	return 0;
+}
+EXPORT_SYMBOL(__kfifo_alloc);
+
+void __kfifo_free(struct __kfifo *fifo)
+{
+	kfree(fifo);
+	fifo->data = 0;
+	fifo->mask = 0; 
+	fifo->in = fifo->out = 0;
+}
+EXPORT_SYMBOL(__kfifo_free);
+
+int __kfifo_init(struct __kfifo *fifo, void *buffer,
+		unsigned int size, size_t esize)
+{
+	size /= esize;
+
+	if (size)
+		size = rounddown_pow_of_two(size);
+
+	if (size < 2)
+		return -EINVAL;
+
+	fifo->data = buffer;
+	fifo->in = fifo->out = 0;
+	fifo->mask = size - 1;
+	fifo->esize = esize;
+	return 0;
+}
+EXPORT_SYMBOL(__kfifo_init);
+
+static inline void kfifo_copy_in(void *dst, const void *src,
+		unsigned int len, unsigned int off, unsigned int size)
+{
+	unsigned int l;
+
+	l = min(len, size - off);
+	memcpy(dst + off, src, l);
+	memcpy(dst, src + l, len - l);
+	smp_wmb();
+}
+
+unsigned int __kfifo_in(struct __kfifo *fifo, 
+		const void *buf, unsigned int len)
+{
+	unsigned int l;
+	unsigned int off;
+	unsigned int size = fifo->mask + 1;
+	unsigned int esize = fifo->esize;
+
+	l = size - (fifo->in - fifo->out);
+	if (len > l)
+		len = l;
+
+	off = fifo->in & fifo->mask;
+
+	if (esize != 1) {
+		off *= esize;
+		size *= esize;
+		l = len * esize;
+	}
+	else
+		l = len;
+
+	kfifo_copy_in(fifo->data, buf, l, off, size);
+	fifo->in += len;
+	return len;
+}
+EXPORT_SYMBOL(__kfifo_in);
+
+static inline void kfifo_copy_out(void *dst, const void *src,
+		unsigned int len, unsigned int off, unsigned int size)
+{
+	unsigned int l;
+
+	l = min(len, size - off);
+	memcpy(dst, src + off, l);
+	memcpy(dst + l, src, len - l);
+	smp_wmb();
+}
+
+unsigned int __kfifo_out_peek(struct __kfifo *fifo,
+		void *buf, unsigned int len)
+{
+	unsigned int l;
+	unsigned int off;
+	unsigned int size = fifo->mask + 1;
+	unsigned int esize = fifo->esize;
+
+	l = fifo->in - fifo->out;
+	if (len > l)
+		len = l;
+
+	off = fifo->out & fifo->mask;
+
+	if (esize != 1) {
+		off *= esize;
+		size *= esize;
+		l = len * esize;
+	}
+	else
+		l = len;
+
+	kfifo_copy_out(buf, fifo->data, l, off, size); 
+	return len;
+}
+EXPORT_SYMBOL(__kfifo_out_peek);
+
+unsigned int __kfifo_out(struct __kfifo *fifo,
+		void *buf, unsigned int len)
+{
+	len = __kfifo_out_peek(fifo, buf, len);
+	fifo->out += len;
+	return len;
+}
+EXPORT_SYMBOL(__kfifo_out);
+
+static inline unsigned long kfifo_copy_from_user(void *dst, const void *src,
+		unsigned int len, unsigned int off, unsigned int size)
+{
+	unsigned int l;
+	unsigned long ret;
+
+	l = min(len, size - off);
+	ret = copy_from_user(dst + off, src, l);
+
+	if (unlikely(ret))
+		ret += len - l;
+	else
+		ret = copy_from_user(dst, src + l, len - l);
+	smp_wmb();
+	return ret;
+}
+
+int __kfifo_from_user(struct __kfifo *fifo, const void __user *from,
+		unsigned long len, unsigned int *copied)
+{
+	unsigned int l;
+	unsigned long ret;
+	unsigned long off;
+	unsigned int size = fifo->mask + 1;
+	unsigned int esize = fifo->esize;
+	int err;
+
+	if (esize != 1)
+		len /= esize;
+
+	l = size - (fifo->in - fifo->out);
+	if (len > l)
+		len = l;
+
+	off = fifo->in & fifo->mask;
+
+	if (esize != 1) {
+		off *= esize;
+		size *= esize;
+		l = len * esize;
+	}
+	else
+		l = len;
+
+	ret = kfifo_copy_from_user(fifo->data, from, l, off, size);
+	if (unlikely(ret)) {
+		if (esize != 1) {
+			len -= roundup_diff(ret, esize);
+			l = len * esize;
+		}
+		else
+			l = len -= ret;
+		err = -EFAULT;
+	}
+	else
+		err = 0;
+	fifo->in += len;
+	if (copied)
+		*copied = l;
+	return err;
+}
+EXPORT_SYMBOL(__kfifo_from_user);
+
+static inline unsigned long kfifo_copy_to_user(void *dst, const void *src,
+		unsigned int len, unsigned int off, unsigned int size)
+{
+	unsigned int l;
+	unsigned long ret;
+
+	l = min(len, size - off);
+	ret = copy_to_user(dst, src + off, l);
+
+	if (unlikely(ret))
+		ret += len - l;
+	else
+		ret = copy_to_user(dst + l, src, len - l);
+	smp_wmb();
+	return ret;
+}
+
+int __kfifo_to_user(struct __kfifo *fifo, void __user *to,
+		unsigned long len, unsigned int *copied)
+{
+	unsigned int l;
+	unsigned long ret;
+	unsigned long off;
+	unsigned int size = fifo->mask + 1;
+	unsigned int esize = fifo->esize;
+	int err;
+
+	if (esize != 1)
+		len /= esize;
+
+	l = fifo->in - fifo->out;
+	if (len > l)
+		len = l;
+
+	off = fifo->out & fifo->mask;
+
+	if (esize != 1) {
+		off *= esize;
+		size *= esize;
+		l = len * esize;
+	}
+	else
+		l = len;
+
+	ret = kfifo_copy_to_user(to, fifo->data, l, off, size);
+	if (unlikely(ret)) {
+		if (esize != 1) {
+			len -= roundup_diff(ret, esize);
+			l = len * esize;
+		}
+		else
+			l = len -= ret;
+		err = -EFAULT;
+	}
+	else
+		err = 0;
+	fifo->out += len;
+	if (copied)
+		*copied = l;
+	return err;
+}
+EXPORT_SYMBOL(__kfifo_to_user);
+
+static unsigned int setup_sgl(void *data, unsigned int size,
+	struct scatterlist *sgl, int nents, unsigned int len, unsigned int off)
+{
+	unsigned int	l;
+
+	l = min(len, size - off);
+	if (l != len) {
+		if (nents > 1) {
+			sg_set_buf(sgl, data + off, l);
+			sgl++;
+
+			off = 0;
+			l = len - l;
+		} else
+			len = l;
+	}
+	sg_set_buf(sgl, data + off, l);
+	sg_mark_end(sgl);
+
+	return len;
+}
+
+unsigned int __kfifo_dma_in_prepare(struct __kfifo *fifo,
+		struct scatterlist *sgl, int nents, unsigned int len)
+{
+	unsigned int l;
+	unsigned int off;
+	unsigned int size = fifo->mask + 1;
+	unsigned int esize = fifo->esize;
+
+	if (!nents)
+		BUG();
+
+	l = size - (fifo->in - fifo->out);
+	if (len > l)
+		len = l;
+	if (!len)
+		return 0;
+
+	off = fifo->in & fifo->mask;
+
+	if (esize != 1) {
+		off *= esize;
+		size *= esize;
+		len *= esize;
+	}
+	return setup_sgl(fifo->data, size, sgl, nents, len, off);
+}
+EXPORT_SYMBOL(__kfifo_dma_in_prepare);
+
+unsigned int __kfifo_dma_out_prepare(struct __kfifo *fifo, 
+		struct scatterlist *sgl, int nents, unsigned int len)
+{
+	unsigned int l;
+	unsigned int off;
+	unsigned int size = fifo->mask + 1;
+	unsigned int esize = fifo->esize;
+
+	if (!nents)
+		BUG();
+
+	l = fifo->in - fifo->out;
+	if (len > l)
+		len = l;
+	if (!len)
+		return 0;
+
+	off = fifo->out & fifo->mask;
+
+	if (esize != 1) {
+		off *= esize;
+		size *= esize;
+		len *= esize;
+	}
+	return setup_sgl(fifo->data, size, sgl, nents, len, off);
+}
+EXPORT_SYMBOL(__kfifo_dma_out_prepare);
+


