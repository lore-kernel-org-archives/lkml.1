Return-Path: <linux-kernel-owner+w=401wt.eu-S1161178AbXCVWhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161178AbXCVWhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161180AbXCVWhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:37:08 -0400
Received: from neon.samage.net ([83.149.67.130]:41031 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161178AbXCVWhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:37:03 -0400
Message-ID: <1599.81.207.0.53.1174603016.squirrel@secure.samage.net>
In-Reply-To: <Pine.LNX.4.64.0703211701260.27640@zenon.ceid.upatras.gr>
References: <Pine.LNX.4.64.0703211701260.27640@zenon.ceid.upatras.gr>
Date: Thu, 22 Mar 2007 23:36:56 +0100 (CET)
Subject: Re: [PATCH 1/1][NEW] crypto API: rsa algorithm module patch 
     (kernel version 2.6.20.3)
From: "Indan Zupancic" <indan@nul.nu>
To: "Tasos Parisinos" <t.parisinos@sciensis.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.7
X-Scan-Signature: 45119e1cd5aec207eff639f24da8befd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tasos,

Comments below.

On Wed, March 21, 2007 16:13, Tasos Parisinos wrote:
> This patch changes the crypto/Kconfig crypto/Makefile and adds
> crypto/rsa.c. These files add module named rsa.o (rsa.ko) built-in or as
> a kernel module and offer an API to do fast modular exponentiation
> and other multi-precision arithmetics.
> Signed-off-by: Tasos Parisinos <t.parisinos@sciensis.com>
>
> ---
>
> diff -uprN -X linux-2.6.20.3-vanilla/Documentation/dontdiff \
> linux-2.6.20.3/crypto/Kconfig linux-2.6.20.3-vanilla/crypto/Kconfig
> --- linux-2.6.20.3/crypto/Kconfig 2007-03-13 20:27:08.000000000 +0200
> +++ linux-2.6.20.3-vanilla/crypto/Kconfig 2007-03-21 15:15:04.000000000 +0200
> @@ -458,6 +458,41 @@ config CRYPTO_CRC32C
>   	  See Castagnoli93.  This implementation uses lib/libcrc32c.
>             Module will be crc32c.
>
> +config CRYPTO_RSA
> +	tristate "RSA cipher algorithm"
> +	help
> +	  The famous RSA asymmetric cipher algorithm. This may be used
> +	  in-kernel (no userland interface yet) to compute modular
> +	  exponentiation. It can be also used to do some multi-precision
> +	  arithmetics.
> +
> +	  If it is selected it will add approximately 8K to the kernel size.
> +	  Select M to build this driver as a module.
> +	  If unsure say N.
> +
> +
> +config RSA_AUXCOUNT
> +	int "Initial preallocated mpi pool size"
> +	default "8"
> +	depends on CRYPTO_RSA
> +	help
> +	  The rsa module needs some preallocated space to avoid
> +	  computation-time allocations. The 'mpi' is the struct used
> +	  by the rsa module to hold a multi-precision integer, so this
> +	  setting is the number of mpi's allocated at module load time.

Why not call it RSA_MPI_COUNT then?

> +
> +config RSA_AUXSIZE
> +	int "Initial preallocated mpi limb size"
> +	default "128"
> +	depends on CRYPTO_RSA
> +	help
> +	  The rsa module needs some preallocated space to avoid
> +	  computation-time allocations. The 'mpi' is the struct used
> +	  by the rsa module to hold a multi-precision integer. This
> +	  struct maps a number on multiple 32 bit limbs (it is actually
> +	  a 32 bit array). Here you select the default size (in limbs)
> +	  of the preallocated mpis.
> +

RSA_MPI_SIZE?

>   config CRYPTO_TEST
>   	tristate "Testing module"
>   	depends on m
> diff -uprN -X linux-2.6.20.3-vanilla/Documentation/dontdiff \
> linux-2.6.20.3/crypto/Makefile linux-2.6.20.3-vanilla/crypto/Makefile
> --- linux-2.6.20.3/crypto/Makefile 2007-03-13 20:27:08.000000000 +0200
> +++ linux-2.6.20.3-vanilla/crypto/Makefile 2007-03-21 15:15:04.000000000 +0200
> @@ -43,5 +43,6 @@ obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
>   obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
>   obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
>   obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
> +obj-$(CONFIG_CRYPTO_RSA) += rsa.o
>
>   obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
> diff -uprN -X linux-2.6.20.3-vanilla/Documentation/dontdiff \
> linux-2.6.20.3/crypto/rsa.c linux-2.6.20.3-vanilla/crypto/rsa.c
> --- linux-2.6.20.3/crypto/rsa.c	1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.20.3-vanilla/crypto/rsa.c	2007-03-21 15:15:04.000000000 +0200
> @@ -0,0 +1,809 @@
> +/*
> + * Cryptographic API
> + *
> + * RSA cipher algorithm implementation
> + *
> + * Copyright (c) Tasos Parisinos <t.parisinos@sciensis.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/time.h>
> +
> +#if CONFIG_RSA_AUXCOUNT < 8
> +	#error "Rsa module needs at least 8 auxilliary mpis"
> +#endif

Would be nicer if this was enforced by Kconfig. Maybe use ranges or something?
I don't know what's possible with the current build system.

> +
> +#define RADIX_BITS		0x20

What's wrong with just using 32?


> +#define UINT32_T_MAX		0xFFFFFFFF
> +
> +/* Multi-precision integer */
> +typedef struct mpi {
> +	u32	*data;	/* u32 array holding the number absolute value */
> +	u8	sign;	/* 1 for negative, 0 for positive */
> +	int	size;	/* Significant number limbs */
> +	int	limbs;	/* Allocated limbs (sizeof data) */
> +} mpi;

Better to use an int for 'sign', saves type conversions and thus code size.
The structure is padded anyway, so the structure size stays the same.


> +
> +static mpi 	*aux[CONFIG_RSA_AUXCOUNT];
> +static u32 	modinv;
> +
> +/*
> + * mpi_alloc - allocate an mpi
> + * @n: pointer pointer to the allocated mpi
> + * @limbs: number of allocated limbs (32 bit digits)
> + *
> + * The allocated mpi will be zeroed and not canonicalized
> + */
> +int mpi_alloc(mpi **n, int limbs)
> +{
> +	mpi *handle;
> +
> +	*n = NULL;
> +	if (!limbs)
> +		return -EINVAL;
> +
> +	/* Allocate space for the mpi */
> +	handle = *n = kmalloc(sizeof(mpi), GFP_KERNEL);
> +	if (!handle)
> +		return -ENOMEM;
> +
> +	handle->data = kzalloc(limbs * sizeof(u32), GFP_KERNEL);
> +	if (!handle->data) {
> +		kfree(handle);
> +		*n = NULL;
> +		return -ENOMEM;
> +	}
> +
> +	handle->sign = 0;
> +	handle->size = handle->limbs = limbs;
> +	return 0;
> +}

If you add *n = handle to the end you can get rid of the handle = *n = ...
and also of the *n = NULL;


> +
> +void mpi_free(mpi *n)
> +{
> +	if (!n)
> +		return;
> +	kfree(n->data);
> +	kfree(n);
> +}
> +
> +/*
> + * mpi_init - initialize an mpi given its hex (absolute) value
> + * @n: pointer pointer to the allocated mpi
> + * @str: hex data
> + * @size: sizeof(str)
> + * @xtra: how many extra limbs to preallocate to avoid reallocations
> + *
> + * The optional leading zeroes will be taken into account, so that the
> + * mpi created will not be canonicalized
> + */
> +int mpi_init(mpi **n, u8 *str, u32 size, u32 xtra)
> +{
> +	int i, j, s, retval;
> +	u32 *buf;
> +
> +	*n = NULL;
> +	if (!size && !xtra)
> +		return -EINVAL;
> +
> +	/* Allocate space for the mpi and its data */
> +	s = (size + 3) / 4;
> +	retval = mpi_alloc(n, s + xtra);
> +	if (retval < 0)
> +		return retval;
> +
> +	(*n)->size = s;
> +	buf = (*n)->data;
> +
> +	/* Copy the data */
> +	for (i = size - 1, j = 0; i >= 0; i--, j++)
> +		buf[j / 4] |= ((u32)str[i] << ((j % 4) * 8));
> +	return 0;
> +}

mpi_init is never called: Get rid of it?


> +
> +/*
> + * mpi-resize - resize an mpi, doing all the needed re-allocations
> + * @n: pointer pointer to the allocated mpi
> + * @size: the new size
> + * @hold: true to keep the current data
> + */
> +int mpi_resize(mpi **n, int size, u8 hold)

Making 'hold' u8 won't save anything. But to simplify code I would just
get rid of the hold option altogether, and always copy the data over.
When mpi_resize is called with old = false the data is copied over anyway,
so at least the current zeroing isn't very useful (which is also already
done by mpi_alloc).

> +{
> +	int retval;
> +	mpi *handle = *n;
> +
> +	/* If there is an mpi passed in, that has the available limbs */
> +	if (handle && handle->limbs >= size) {
> +		int i, s;
> +		u32 *buf;
> +
> +		s = handle->size;
> +		buf = handle->data;
> +
> +		/* If the original data are not needed they are zeroed */
> +		if (!hold) {
> +			for (i = 0; i < s; i++)
> +				buf[i] = 0;
> +			handle->sign = 0;
> +		}
> +		/* zero the xtra limbs */
> +		else if (size < handle->size)
> +			for (i = size; i < s; i++)
> +				buf[i] = 0;
> +
> +		handle->size = size;
> +	}
> +	/* If there is an mpi passed in, that doesn't have the available
> +	 * limbs already allocated
> +	 */
> +	else if (handle) {
> +		mpi *tmp = NULL;
> +
> +		retval = mpi_alloc(&tmp, size);
> +		if (retval < 0)
> +			return retval;
> +
> +		/* Copy the original data if they are needed */
> +		if (hold) {
> +			memcpy(tmp->data, handle->data,
> +			       handle->size * sizeof(u32));
> +			tmp->sign = handle->sign;
> +		}
> +
> +		mpi_free(*n);
> +		*n = tmp;
> +		return retval;
> +	}
> +	/* If there is no allocated mpi passed in, allocate one */
> +	else if (!handle) {
> +		retval = mpi_alloc(n, size);
> +		if (retval < 0)
> +			return retval;
> +	}

If you move this check to the front you can get rid of the other handle
checks.


> +
> +	return 0;
> +}
> +
> +/*
> + * mpi_set - set the value of an mpi given its hex (absolute) value
> + * @n: pointer pointer to the allocated mpi
> + * @str: hex data
> + * @size: sizeof(str)
> + *
> + * The optional leading zeroes will be taken into account, so that the mpi
> + * created will not be canonicalized. The mpi passed in will be re-allocated
> + * (and relocated) if needeed

Typo: 'needed'.


> + */
> +static int mpi_set(mpi **n, u8 *str, u32 size)
> +{
> +	int s, i, j, retval;
> +	u32 *buf;
> +
> +	if (!size)
> +		return -EINVAL;
> +
> +	/* Size of the new mpi value (in limbs) */
> +	s = (size + 3) / 4;
> +	retval = mpi_resize(n, s, false);
> +	if (retval < 0)
> +		return retval;
> +
> +	/* Copy the data */
> +	buf = (*n)->data;
> +	for (i = size - 1, j = 0; i >= 0; i--, j++)
> +		buf[j / 4] |= ((u32)str[i] << ((j % 4) * 8));
> +	return 0;
> +}

mpi_set() is only called twice with as options:

mpi_set(&aux[5 or 6], "\x01", 1);

So it looks a bit overkill for what it's apparently used
(setting an mpi to 1).

I'm sure it's a useful function to have in a general mpi implementation,
but for now it's contained in the RSA module. If there is demand for a
mpi library, then this can be added an all code moved to lib/mpi.c or
something. But until then, I'd concentrate on things needed for RSA.


> +
> +inline int mpi_copy(mpi **dest, mpi *src)
> +{
> +	int i, s, retval;
> +	u32 *destbuf, *srcbuf;
> +
> +	retval = mpi_resize(dest, src->size, false);
> +	if (retval < 0)
> +		return retval;
> +
> +	(*dest)->sign = src->sign;
> +	destbuf = (*dest)->data;
> +	srcbuf = src->data;
> +	for (i = 0, s = src->size; i < s; i++)
> +		destbuf[i] = srcbuf[i];

Why didn't you use memcpy()? Not that this is wrong,
just wondering.


> +	return 0;
> +}
> +
> +inline u8 mpi_iszero(mpi *n)
> +{
> +	int i, s;
> +	u32 *buf;
> +
> +	s = n->size;
> +	buf = n->data;
> +	for (i = 0; i < s; i++)
> +		if (buf[i])
> +			return false;
> +	return true;
> +}

Why is this returning u8? Just use int. Or maybe better,
just get rid of this function. It's used in two places:

mpi_print: Hardly a need to special case an all zeroes mpi.

mpi_shift: Small chance the mpi is zero, isn't it? Is it really
worth optimising for that case?

> +
> +/*
> + * mpi_print - print the value of an mpi
> + * @n: pointer to the mpi
> + * @how: true to print canonicalized
> + */
> +void mpi_print(mpi *n, u8 how)
> +{
> +	int i, j;
> +	u32 limb;
> +	u8 byte, started = false;
> +
> +	printk("Mpi at 0x%x, %d limbs in size, %d limbs allocated, value = ",
> +	       (u32)n, n->size, n->limbs);
> +
> +	/* If the mpi is merely zero */
> +	if (mpi_iszero(n) && how) {
> +		printk("0\n");
> +		return;
> +	}
> +
> +	/* Print the sign */
> +	printk("%s", (n->sign)? "-": " ");
> +
> +	/* Print the hex value */
> +	for (i = n->size - 1; i >= 0; i--) {
> +		limb = n->data[i];
> +
> +		/* Ignore leading zero limbs if canonicalized printing
> +		 * is selected
> +		 */
> +		if (!limb && !started && how)
> +			continue;
> +
> +		/* Print each limb as though each of its nibbles was a
> +		 * character from the set '0' to '9' and 'a' to 'f'
> +		 */
> +		for (j = 28; j >= 0; j -= 4) {
> +			byte = (u8)((limb >> j) & 0x0F);
> +
> +			/* Ignore leading zero bytes if canonicalized printing
> +			 * is selected
> +			 */
> +			if (!byte && !started && how)
> +				continue;
> +
> +			started = true;
> +			byte += (byte <= 0x09)? '0': 'a' - 0x0A;
> +			printk("%c", byte);
> +		}
> +	}
> +
> +	printk("\n");
> +}

mpi_print() isn't called anywhere. Same comments as for mpi_init and mpi_set.

Oh wait, although this is in crypto, it are only mpi helper function required
to implement RSA, but RSA as a crypto module is missing?

I think you should add the glue code to really get a RSA crypto implementation
in the linux/crypto.h sense. If you also want a mpi helper module then don't call
anything in this part RSA and export the functions that are useful on their own.

> +
> +/*
> + * mpi_clz - count leading zeroes
> + * @n: the mpi
> + */
> +u32 mpi_clz(mpi *n)
> +{
> +	int i;
> +	u32 limb, retval = 0;
> +
> +	for (i = n->size - 1; i >= 0; i--) {
> +		limb = n->data[i];
> +
> +		if (!limb) {
> +			retval += 32;
> +			continue;
> +		}
> +
> +		while (!(limb & 0x80000000)) {
> +			retval++;
> +			limb = limb << 1;
> +		}
> +
> +		break;
> +	}
> +
> +	return retval;
> +}

Can use find_first_bit() instead (And return an int).

> +
> +/*
> + * mpi_compare - compare two mpis
> + * @a: the left operand
> + * @b: the right operand
> + *
> + * Returns -1 if a < b, 1 if b < a, 0 otherwise
> + */
> +char mpi_compare(mpi *a, mpi *b)
> +{
> +	int i, j;
> +	u32 *abuf, *bbuf;
> +
> +	/* Compare the two mpis based on sign */
> +	if (a->sign != b->sign)
> +		return (a->sign)? -1: 1;
> +
> +	/* Compare the two mpis based on their size */
> +	if (a->size > b->size && mpi_clz(a) < (a->size - b->size) * 32)
> +		return 1;
> +	else if (a->size > b->size)
> +		j = b->size;
> +	else if (b->size > a->size && mpi_clz(b) < (b->size - a->size) * 32)
> +		return -1;
> +	else
> +		j = a->size;

Why not just get rid of the complex checks and just always go through the loop?
The loop isn't really less expensive than a mpi_clz() call, and now you do both
most of the time. So just replace the whole size comparison with a simple:

j = min(a->size, b->size);


> +
> +	/* Compare the two mpis based on their hex values */
> +	abuf = a->data;
> +	bbuf = b->data;
> +	for (i = j - 1; i >= 0; i--)
> +		if (abuf[i] > bbuf[i])
> +			return 1;
> +		else if (abuf[i] < bbuf[i])
> +			return -1;
> +
> +	return 0;
> +}

This looks like it can be done better. What about replacing it with
a memcmp() call?


> +
> +/*
> + * mpi_complement - complement an mpi
> + * @n: the mpi
> + * @which: true to compute 2's complement
> + */
> +inline void mpi_complement(mpi *n, u8 which)

Ugh, I'd rather replace 'which' with 'twos' or something giving at
least a hint what it means, and the 'u8' with an int.

It's only called with true anyway, so why not get rid of the option?
(And maybe rename the function to mpi_twoscomplement).

Also make all internal functions static. I wouldn't make them inlines though,
the compiler already does that for static functions if it makes sense.


> +{
> +	int i, s;
> +	u32 *buf;
> +
> +	s = n->size;
> +	buf = n->data;
> +	for (i = 0; i < s; i++)
> +		buf[i] ^= UINT32_T_MAX;

Anything wrong with buf[i] = ~buf[i];?


> +	if (!which)
> +		return;
> +
> +	/* Add 1 using the addition carry */
> +	for (i = 0; i < s; i++) {
> +		buf[i] += 1;
> +		if (buf[i])
> +			break;
> +	}
> +}
> +
> +inline void mpi_canonicalize(mpi *n)
> +{
> +	int i;
> +	u32 *buf = n->data;
> +
> +	for (i = n->size - 1; i >= 0; i--)
> +		if (!buf[i] && n->size > 1)
> +			n->size--;
> +		else
> +			break;
> +}
> +
> +/*
> + * mpi_shift - shift a number either directions
> + * @n: pointer pointer to the allocated mpi
> + * @bits: shift to the right if positive, otherwise shift to the left
> + */
> +int mpi_shift(mpi **n, int bits)
> +{
> +	int i, distance, size, lz, retval;
> +	u32 *buf;
> +	mpi *handle;
> +
> +	handle = *n;
> +	if (!bits || mpi_iszero(handle))
> +		return 0;
> +
> +	/* Shifting to the right, no resize needed */
> +	if (bits > 0) {
> +		/* Drop off one limb for each 32 bit shift */
> +		distance = bits / 32;
> +		size = handle->size;
> +		buf = handle->data;
> +		for (i = 0; i < size; i++)
> +			buf[i] = (i + distance >= size)? 0: buf[i + distance];
> +
> +		/* Shift the remaining 'bits' mod 32 */
> +		bits = bits % 32;
> +		if (bits) {
> +			size -= distance;
> +			distance = 32 - bits;
> +			for (i = 0; i < size; i++) {
> +				buf[i] = buf[i] >> bits;
> +				if (i < size - 1)
> +					buf[i] |=  buf[i + 1] << distance;
> +			}
> +		}
> +
> +		mpi_canonicalize(handle);
> +		return 0;
> +	}
> +
> +	bits = -bits;
> +	lz = mpi_clz(handle) + (handle->limbs - handle->size) * 32;
> +
> +	/* Shifting to the left.
> +	 * Reallocation is needed when the leading zeroes are less than
> +	 * the shift distance
> +	 */
> +	if (lz < bits) {
> +		/* Compute the size of the reallocation */
> +		size = (bits - lz + 31) / 32;
> +		retval = mpi_resize(n, handle->limbs + size, true);
> +		if (retval < 0)
> +			return retval;
> +		handle = *n;
> +	}
> +	else
> +		handle->size += ((bits - mpi_clz(handle) + 31) / 32);
> +
> +	buf = handle->data;
> +	distance = bits / 32;
> +	/* Shift data 1 byte to the left for each 32 bit shift */
> +	if (distance) {
> +		/* Shift bytes */
> +		for (i = handle->size - distance - 1; i >= 0; i--)
> +			buf[i + distance] = buf[i];
> +
> +		/* Zero the shifted in bytes */
> +		for (i = 0; i < distance; i++)
> +			buf[i] = 0;
> +	}
> +
> +	/* Shift the remaining 'bits' mod 32 */
> +	bits = bits % 32;
> +	distance = 32 - bits;
> +	if (bits)
> +		for (i = handle->size - 1; i >= 0; i--) {
> +			buf[i] = buf[i] << bits;
> +			if (i > 0)
> +				buf[i] |= (buf[i - 1] >> distance);
> +		}
> +
> +	return 0;
> +}

If you change your code to use unsigned longs instead of u32, you can use
all the existing nice bitmap functions, like bitmap_complement, bitmap_empty,
bitmap_shift_right and so on, greatly reducing the amount of code.


> +
> +int mpi_multiply(mpi **res, mpi *a, mpi *b)
> +{
> +	int i, j, size, asize, bsize, retval;
> +	u32 *buf, *abuf, *bbuf;
> +	u64 tmp;
> +	mpi *handle;
> +
> +	asize = a->size;
> +	bsize = b->size;
> +	size = asize + bsize;
> +	retval = mpi_resize(res, size, false);
> +	if (retval < 0)
> +		return retval;
> +
> +	handle = *res;
> +	handle->sign = a->sign ^ b->sign;
> +
> +	buf = handle->data;
> +	abuf = a->data;
> +	bbuf = b->data;
> +	/* Make the multiplication, using the standard algorithm */
> +	for (i = 0; i < bsize; i++) {
> +		tmp = 0;
> +		for (j = 0; j < asize; j++)
> +			buf[i + j] = tmp = buf[i + j] + (abuf[j] * (u64)bbuf[i]) + (tmp >> 32);
> +		buf[i + asize] = tmp >> 32;
> +	}
> +
> +	mpi_canonicalize(handle);
> +	return 0;
> +}

Much room for speed improvement here. Interesting to optimise
if it takes a big chunk of CPU time.


> +
> +int mpi_subtract(mpi **res, mpi *a, mpi *b)
> +{
> +	int i, size, retval;
> +	u32 *buf, *abuf, *bbuf;
> +	mpi *handle;
> +
> +	size = max(a->size, b->size) + (a->sign != b->sign);
> +	if ((retval = mpi_resize(res, size, true)) < 0 ||
> +	    (retval = mpi_resize(&a, size, true)) < 0  ||
> +	    (retval = mpi_resize(&b, size, true)) < 0)
> +		return retval;

Why are you modifying a and b here? Why not leave them alone?


> +
> +	handle = *res;
> +	buf = handle->data;
> +	abuf = a->data;
> +	bbuf = b->data;
> +
> +	/* If the operands are both negative or positive perform subtraction */
> +	if (a->sign == b->sign) {
> +		 u8 borrow = false;
> +		 u32 limb;

Get rid of the superfluous spaces. And why is borrow u8? make it the same as bbuf[0].

> +
> +		for (i = 0; i < size; i++) {
> +			limb = borrow + bbuf[i];
> +			buf[i] = abuf[i] - limb;
> +			borrow = (abuf[i] < limb);
> +		}
> +
> +		handle->sign = (borrow)? !b->sign: b->sign;

Why not write it out with if/else, combining it with the below check:


> +		if (borrow)
> +			mpi_complement(handle, true);
> +	}
> +	/* If the operands are not signed in the same way perform addition */
> +	else {
> +		 u8 carry = false;
> +		 u64 sum;
> +
> +		for (i = 0; i < size; i++) {
> +			buf[i] = sum = abuf[i] + bbuf[i] + carry;
> +			carry = (sum > UINT32_T_MAX);
> +		}

Just get rid of 'sum' and use buf[i] directly?


> +
> +		handle->sign = a->sign;
> +	}
> +
> +	mpi_canonicalize(handle);
> +	mpi_canonicalize(a);
> +	mpi_canonicalize(b);

Why modify a and b here?


> +	return 0;
> +}
> +
> +int mpi_remainder(mpi **res, mpi *a, mpi *b)
> +{
> +	int i, k, retval;
> +
> +	/* Because b operand will be shifted we need to have a copy of it
> +	 * in order not to mess with the prototype
> +	 */
> +	if ((retval = mpi_copy(&aux[0], a)) < 0 ||
> +	    (retval = mpi_copy(&aux[1], b)) < 0)
> +		return retval;

Fine, then make a copy. But why do you also make a copy of 'a'? (Either
expand the comment or don't do it.)

And why oh why do you need to use the ugly global aux[] for that?
I think you can and should get rid of the global aux array, you don't
even have any locking protecting simultaneous use! Same for modinv.


> +
> +	k = (aux[0]->size - aux[1]->size) * 32;
> +	k += (mpi_clz(aux[1]) - mpi_clz(aux[0]));

What is this trying to do? It looks like it's calculating the distance
between the highest set bits of aux[0] and aux[1]. For me it's clearer
when doing:

	/* Calculate the distance between the highest set bits */
	k = (aux[0]->size - aux[1]->size) * 32;
	/* Compensate for leading zeroes */
	k -= mpi_clz(aux[0]) - mpi_clz(aux[1]);


> +
> +	/* Align the divisor to the dividend */
> +	retval = mpi_shift(&aux[1], -k);
> +	if (retval < 0)
> +		return retval;
> +
> +	for (i = 0; i <= k; i++) {
> +		retval = mpi_subtract(res, aux[0], aux[1]);
> +		if (retval < 0)
> +			return retval;
> +
> +		if (!(*res)->sign) {
> +			retval = mpi_copy(&aux[0], (*res));
> +			if (retval < 0)
> +				return retval;
> +		}

No need for the parentheses around *res.


> +
> +		retval = mpi_shift(&aux[1], 1);
> +		if (retval < 0)
> +			return retval;
> +	}
> +
> +	mpi_canonicalize(aux[0]);
> +	return mpi_copy(res, aux[0]);
> +}

Can avoid the copy by returning the aux[0] pointer and setting aux[0] itself to NULL.


> +
> +/*
> + * rsa_modinv - compute the first 32 bits of the modular inverse of a number
> + * @n: the mpi
> + */
> +u32 rsa_modinv(mpi *n)
> +{
> +	u32 i, x, y, tmp, pow1;
> +
> +	pow1 = y = 1;
> +	x = n->data[0];
> +
> +	for (i = 2; i <= RADIX_BITS; i++) {
> +		pow1 = pow1 << 1;

pow1 <<= 1;

> +		tmp = ((u64)x * y) & (UINT32_T_MAX >> (32 - i));

Urgh, I'm sure this can be done in a cleaner way, please do so!


> +		if (pow1 < tmp)
> +			y += pow1;
> +	}
> +
> +	y = (y ^ UINT32_T_MAX) + 1;

y = ~y + 1;?


> +	return y;
> +}
> +
> +/*
> + * rsa_monpro - compute the montgomery product (res = a * b mod n)
> + * @res: pointer pointer to the result
> + * @a: left operand
> + * @b: right operand
> + * @n: divisor
> + */
> +int rsa_monpro(mpi **res, mpi *a, mpi *b, mpi *n)
> +{
> +	int nsize, i, j, k, retval;
> +	u32 *buf, *nbuf, *tmp, m;
> +	u64 product = 0;
> +
> +	nsize = n->size;
> +	k = nsize << 1;
> +	retval = mpi_multiply(&aux[2], a, b);
> +	if (retval < 0)
> +		return retval;
> +
> +	retval = mpi_resize(&aux[2], max(aux[2]->size, k), true);
> +	if (retval < 0)
> +		return retval;
> +
> +	tmp = buf = aux[2]->data;
> +	nbuf = n->data;
> +
> +	for (i = 0; i < nsize; i++, tmp++) {
> +		m = buf[i] * modinv;

It shouldn't use the global 'modinv', but get it via a parameter or something.


> +		product = 0;
> +
> +		for (j = 0; j < nsize; j++)
> +			tmp[j] = product = tmp[j] + (m * (u64)nbuf[j]) + (product >> 32);

Fun.

> +
> +		for (j = nsize + i; j < k; j++)
> +			buf[j] = product = buf[j] + (product >> 32);
> +	}
> +
> +	retval = mpi_resize(&aux[2], aux[2]->size + 1, true);
> +	if (retval < 0)
> +		return retval;
> +
> +	aux[2]->data[aux[2]->size - 1] = product >> 32;

More fun.

> +	retval = mpi_shift(&aux[2], nsize * 32);
> +	if (retval < 0)
> +		return retval;
> +
> +	if (mpi_compare(aux[2], n) >= 0) {
> +		if ((retval = mpi_subtract(&aux[3], aux[2], n)) < 0 ||
> +		    (retval = mpi_copy(res, aux[3])) < 0)
> +			return retval;

I wonder if breaking this up in separate retval = mpi_* calls and retval checks
makes it cleaner. I suspect it will.


> +	}
> +	else if ((retval = mpi_copy(res, aux[2])) < 0)
> +		return retval;
> +	return 0;
> +}
> +
> +/*
> + * rsa_modexp - computes the RSA of m, a.k.a res = m ^ e mod n
> + * @res: pointer pointer to the result
> + * @m: base
> + * @e: exponent
> + * @n: divisor
> + */
> +int rsa_modexp(mpi **res, mpi *m, mpi *e, mpi *n)
> +{
> +	int i, j, retval;
> +	u32 limb;
> +	u8 started = false;

Please just use an int.

I'm no fan of 'true' and 'false' instead of 1 and 0 either, but tastes differ.


> +
> +	if (m->size != n->size || mpi_compare(m, n) > 0)
> +		return -EINVAL;

What's wrong with doing m^e mod n, with m > n?
Maybe for RSA that can't happen, but in general it should be fine.

And why should the sizes of m and n be the same? If it's because of
a shortcoming of the implementation it's worth mentioning it in the
function comment above.


> +
> +	modinv = rsa_modinv(n);

This should be a local variable passed to rsa_monpro.


> +
> +	/* Compute m * r mod n where r is 2 ^ k and n is the k-bit modulus.
> +	 * The resulting m' is stored in aux[4]
> +	 */
> +	retval = mpi_copy(&aux[5], m);
> +	if (retval < 0)
> +		return retval;
> +
> +	retval = mpi_shift(&aux[5], -(n->size * 32));
> +	if (retval < 0)
> +		return retval;
> +
> +	retval = mpi_remainder(&aux[4], aux[5], n);
> +	if (retval < 0)
> +		return retval;
> +
> +	/* Compute r mod n where r is 2 ^ k and n is the k-bit modulus.
> +	 * The resulting x' is stored in aux[7]
> +	 */
> +	retval = mpi_set(&aux[5], "\x01", 1);
> +	if (retval < 0)
> +		return retval;
> +
> +	retval = mpi_shift(&aux[5], -(n->size * 32));
> +	if (retval < 0)
> +		return retval;
> +
> +	retval = mpi_remainder(&aux[7], aux[5], n);
> +	if (retval < 0)
> +		return retval;
> +
> +	/* Canonicalize the exponent and compute the modular exponentiation.
> +	 * For each limb of the exponent perform left to right binary
> +	 * exponentiation
> +	 */
> +	mpi_canonicalize(e);
> +	for (i = e->size - 1; i >= 0; i--) {
> +		/* Take a limb of the exponent */
> +		limb = e->data[i];
> +
> +		/* For each of its bits */
> +		for (j = 0; j < 32; j++) {
> +			/* While the exponent has non significant zeroes shift
> +			 * it to the left
> +			 */
> +			if (!(limb & 0x80000000) && !started) {
> +				limb = limb << 1;
> +				continue;
> +			}

Replace with find_first_bit() and one shift?

As you're doing it only once, why not do it before going into this loop?
Can get rid of 'started' then. Need to adjust the starting value of j, but
with how much is told by find_first_bit().


> +
> +			started = true;
> +			/* Compute x' * x' mod n */
> +			retval = rsa_monpro(&aux[5], aux[7], aux[7], n);
> +			if (retval < 0)
> +				return retval;
> +
> +			if (limb & 0x80000000) {
> +				/* Compute x' = m' * x' mod n */
> +				retval = rsa_monpro(&aux[7], aux[4], aux[5], n);
> +				if (retval < 0)
> +					return retval;
> +			}
> +			else if ((retval = mpi_copy(&aux[7], aux[5])) < 0)
> +				return retval;
> +
> +			limb = limb << 1;
> +		}
> +	}
> +
> +	/* Compute res = x' mod n */
> +	retval = mpi_set(&aux[6], "\x01", 1);
> +	if (retval < 0)
> +		return retval;
> +	return rsa_monpro(res, aux[7], aux[6], n);
> +}

The use of aux[] is really appalling, for earlier mentioned reasons. Just don't
do that caching and use local values on the stack, if they aren't too big, or
allocate them when needed, or if that's really too slow, allocate it once for each
rsa_modexp call and pass it along.

This way you get rid of those config options too, which make no sense anyway, as at least
setting RSA_AUXCOUNT to more than 8 makes no difference as it won't be used anyway.


> +
> +static int __init rsa_load(void)
> +{
> +	int retval = 0;
> +	u32 i;
> +
> +	/* Pre-allocate some auxilliary mpis */
> +	printk(KERN_DEBUG "Allocating %d bytes for auxilliary operands\n",
> +	       CONFIG_RSA_AUXSIZE * CONFIG_RSA_AUXCOUNT * sizeof(u32));
> +
> +	memset(&aux, 0, sizeof(aux));
> +	for (i = 0; i < CONFIG_RSA_AUXCOUNT; i++) {
> +		retval = mpi_alloc(&aux[i], CONFIG_RSA_AUXSIZE);
> +		if (retval < 0)
> +			goto rollback;
> +	}
> +
> +	printk(KERN_DEBUG "RSA cipher algorithm module initialized\n");
> +	return 0;
> +
> +/* Free all allocated resources if any errors occur */
> +rollback:
> +	for (i = 0; i < CONFIG_RSA_AUXCOUNT; i++)
> +		mpi_free(aux[i]);
> +	return retval;
> +}
> +
> +static void __exit rsa_unload(void)
> +{
> +	u32 i;
> +
> +	/* Free all the pre-allocated auxilliary mpis */
> +	for (i = 0; i < CONFIG_RSA_AUXCOUNT; i++)
> +		mpi_free(aux[i]);
> +	printk(KERN_DEBUG "RSA cipher algorithm module unloaded\n");
> +}

The above two functions will become basically empty too then.


> +
> +module_init(rsa_load);
> +module_exit(rsa_unload);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Tasos Parisinos @ Sciensis Advanced Technology Systems");
> +MODULE_DESCRIPTION("RSA cipher algorithm implementation");
>

Greetings,

Indan


