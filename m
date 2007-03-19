Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbXCSS05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbXCSS05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932899AbXCSS04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:26:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:43500 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbXCSS0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:26:55 -0400
Date: Mon, 19 Mar 2007 11:25:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tasos Parisinos <t.parisinos@sciensis.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       Parisinos Anastasios <parisino@ceid.upatras.gr>
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel
 version 2.6.20.1) (and i hope pine does not break it either)
Message-Id: <20070319112558.c5371f73.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0703191907200.4352@zenon.ceid.upatras.gr>
References: <Pine.LNX.4.64.0703191907200.4352@zenon.ceid.upatras.gr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 19:22:00 +0200 (EET) Tasos Parisinos wrote:

> As mentioned in the subject this patch applies in kernel version 2.6.20.1.

It needs to apply to Linus's current tree (and it doesn't).

> diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff linux-2.6.20.1/crypto/Kconfig linux-2.6.20.1-vanilla/crypto/Kconfig
> --- linux-2.6.20.1/crypto/Kconfig	2007-02-20 08:34:32.000000000 +0200
> +++ linux-2.6.20.1-vanilla/crypto/Kconfig	2007-03-11 14:12:24.000000000 +0200
> @@ -458,6 +458,46 @@ config CRYPTO_CRC32C
>   	  See Castagnoli93.  This implementation uses lib/libcrc32c.
>             Module will be crc32c.
> 
> +config CRYPTO_RSA
> +	tristate "RSA cipher algorithm"
> +	depends on CRYPTO
> +	help
> +	  The famous RSA asymmetric cipher algorithm. This may be used in-kernel
> +	  (no userland interface yet) to compute modular exponentiation.  It can
> +	  be also used to do some multi-precision arithmetics.
> +
> +	  If it is selected it will add approximately 8K to the kernel size.
> +	  Select M to build this driver as a module.
> +	  If unsure say N.
> +
> +config CRYPTO_RSA_DEBUG
> +	bool "Debugging capabilities"
> +	depends on CRYPTO_RSA
> +	help
> +		This adds lots of debugging information and debugging capabilities in
> +		the rsa module. It also adds approximately 1 more K to the kernel.

Use <tab><space><space> to indent kconfig help text (as done up above
and below).

> +config RSA_AUXCOUNT
> +	int "Initial preallocated mpi pool size"
> +	default "8"
> +	depends on CRYPTO_RSA
> +	help
> +	  The rsa module needs some preallocated space to avoid computation-time
> +	  allocations. The 'mpi' is the struct used by the rsa module to hold  a
> +	  multi-precision integer, so this setting is the number of mpi's alloca
> +	  ted at module load time.
> +
> +config RSA_AUXSIZE
> +	int "Initial preallocated mpi limb size"
> +	default "128"
> +	depends on CRYPTO_RSA && RSA_AUXCOUNT!="0"
> +	help
> +	  The rsa module needs some preallocated space to avoid computation-time
> +	  allocations. The 'mpi' is the struct used by the rsa module to hold  a
                                                       extra space after ^^^^
> +	  multi-precision  integer. This struct maps a number on multiple 32 bit
> +	  limbs (it is actually a 32 bit array).Here you select the default size
                                                ^space (move one from above :)

> +	  (in limbs) of the preallocated mpis.
> +
>   config CRYPTO_TEST
>   	tristate "Testing module"
>   	depends on m

> diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff linux-2.6.20.1/crypto/rsa.c linux-2.6.20.1-vanilla/crypto/rsa.c
> --- linux-2.6.20.1/crypto/rsa.c	1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.20.1-vanilla/crypto/rsa.c	2007-03-19 16:45:21.000000000 +0200
> @@ -0,0 +1,884 @@
> +
> +#include "rsa.h"
> +
> +static mpi *	aux[RSA_AUX_COUNT];

Kernel style is:
static mpi *aux[RSA_AUX_COUNT];

> +static _u32 	modinv = 0;

No need to init to 0, plus it bloats the codefile.

> +static inline _i32 rsa_max(_i32 x, _i32 y)
> +{
> +	return (x > y)? x: y;
> +}

Use min_t() from kernel.h ?

> +
> +/*
> + * Module loading callback function
> + *
> + * Returns 0 on success or a negative value indicating error
> + */
> +static _err __init rsa_load(void)
> +{
> +	_u32 i;
> +	_err retval = RSA_NO_ERR;
> +
> +	/* Pre-allocate some auxilliary mpis */
> +	rsa_echo("Preallocating %lu bytes for auxilliary operands\n",
> +		 RSA_AUX_SIZE * RSA_AUX_COUNT * sizeof(_u32));
> +
> +	memset(&aux, 0, sizeof(aux));
> +	for(i = 0; i < RSA_AUX_COUNT; i++) {

style:  space after "for" and after "if" (many locations)

> +		retval = rsa_mpi_alloc(&aux[i], RSA_AUX_SIZE);
> +		if(retval < 0)
> +			goto rollback;
> +	}
> +
> +	rsa_echo("RSA cipher algorithm module initialized\n");
> +	return RSA_NO_ERR;
> +
> +/* Free all allocated resources if any errors occur */
> +rollback:
> +	for(i = 0; i < RSA_AUX_COUNT; i++)
> +		rsa_mpi_free(aux[i]);
> +	return retval;
> +}

> +/*
> + * Preallocate an mpi. The allocated mpi will be all-zeroed and not
> + * canonicalized.
> + *
> + * Returns 0 on success or a negative value indicating error
> + *
> + * @n: 	  pointer pointer to the allocated mpi
> + * @limbs: number of allocated limbs (32 bit digits)
> + */
> +static _err rsa_mpi_alloc(mpi ** n, _i32 limbs)
> +{
> +	mpi * handle;
> +
> +	*n = NULL;
> +	if(!limbs)
> +		return RSA_ERR_INVARG;
> +
> +	/* Allocate space for the mpi */
> +	handle = *n = kmalloc(sizeof(mpi), GFP_KERNEL);
> +	if(!handle) {
> +		rsa_debug("%s: kmalloc failed\n", __FUNCTION__);
> +		return RSA_ERR_NOMEM;
> +	}
> +
> +	handle->data = kzalloc(limbs * sizeof(_u32), GFP_KERNEL);
> +	if(!handle->data) {
> +		kfree(handle);
> +		*n = NULL;
> +		rsa_debug("%s: kzalloc failed\n", __FUNCTION__);
> +		return RSA_ERR_NOMEM;
> +	}
> +
> +	handle->sign = 0;
> +	handle->size = handle->limbs = limbs;
> +	return RSA_NO_ERR;
> +}

> +/*
> + * Initialize an mpi given its hex (absolute) value. The optional leading
> + * zeroes will be taken into account, so that the mpi created will not be
> + * canonicalized
> + *
> + * Returns 0 on success or a negative value indicating error
> + *
> + * @n:	  pointer pointer to the allocated mpi
> + * @str:  hex data
> + * @size: sizeof(str)
> + * @xtra: how many extra limbs to preallocate to avoid reallocations
> + */
> +static _err rsa_mpi_init(mpi ** n, _u8 * str, _u32 size, _u32 xtra)
> +{
> +	_i32 i, j;
> +	_u32 * buf;
> +	_i32 s;
> +	_err retval;
> +
> +	*n = NULL;
> +	if(!size && !xtra) {
> +		rsa_debug("%s: invalid initialization string\n", __FUNCTION__);
> +		return RSA_ERR_INVARG;
> +	}
> +
> +	/* Allocate space for the mpi and its data */
> +	s = (size / 4) + ((size % 4)? 1: 0);

That's usually done as:
	s = (size + 3) / 4;
which appears to be:
	s = DIV_ROUND_UP(size, 4);

> +	retval = rsa_mpi_alloc(n, s + xtra);
> +	if(retval < 0)
> +		return retval;
> +
> +	(*n)->size = s;
> +	buf = (*n)->data;
> +
> +	/* Copy the data */
> +	for(i = size - 1, j = 0; i >= 0; i--, j++)
> +		buf[j / 4] |= ((_u32)str[i] << ((j % 4) * 8));
> +	return RSA_NO_ERR;
> +}

> +/*
> + * Set the value of an mpi given its hex (absolute) value. The optional
> + * leading zeroes will be taken into account, so that the mpi created will
> + * not be canonicalized. The mpi passed in will be re-allocated (and relocated)
> + * if needeed
> + *
> + * Returns 0 on success or a negative value indicating error
> + *
> + * @n:	 pointer pointer to the allocated mpi
> + * @str:  hex data
> + * @size: sizeof(str)
> + */
> +static _err rsa_mpi_set(mpi ** n, _u8 * str, _u32 size)
> +{
> +	_i32 s, i, j;
> +	_u32 * buf;
> +	_err retval;
> +
> +	if(!size) {
> +		rsa_debug("%s: invalid initialization string\n", __FUNCTION__);
> +		return RSA_ERR_INVARG;
> +	}
> +
> +	/* Size of the new mpi value (in limbs) */
> +	s = (size / 4) + ((size % 4)? 1: 0);

Use canonical form.

> +	retval = rsa_mpi_resize(n, s, false);
> +	if(retval < 0)
> +		return retval;
> +
> +	/* Copy the data */
> +	buf = (*n)->data;
> +	for(i = size - 1, j = 0; i >= 0; i--, j++)
> +		buf[j / 4] |= ((_u32)str[i] << ((j % 4) * 8));
> +	return RSA_NO_ERR;
> +}
> +
> +/*
> + * Mpi to mpi copy
> + *
> + * Returns 0 on success or a negative value indicating error
> + *
> + * @dest: destination mpi
> + * @src:  source mpi
> + */
> +static inline _err rsa_mpi_copy(mpi **	dest, mpi * src)
> +{
> +	_i32 i, s;
> +	_u32 * destbuf, * srcbuf;

style:  *identifier  (in many places)

> +	_err retval;
> +
> +	retval = rsa_mpi_resize(dest, src->size, false);
> +	if(retval < 0)
> +		return retval;
> +
> +	(*dest)->sign = src->sign;
> +	destbuf = (*dest)->data;
> +	srcbuf = src->data;
> +	for(i = 0, s = src->size; i < s; i++)
> +		destbuf[i] = srcbuf[i];
> +	return RSA_NO_ERR;
> +}

> +/*
> + * Count leading zeroes
> + *
> + * Returns the number of leading zero bits
> + *
> + * @n: the mpi
> + */
> +static _u64 rsa_mpi_clz( mpi * n)

no space between ( and mpi

> +{
> +	_u64 retval = 0;
> +	_i32 i;
> +	_u32 limb;
> +
> +	for(i = n->size - 1; i >= 0; i--) {
> +		limb = n->data[i];
> +
> +		if(!limb) {
> +			retval += 32;
> +			continue;
> +		}
> +
> +		while(!(limb & 0x80000000)) {
> +			retval++;
> +			limb = limb << 1;
> +		}
> +
> +		break;
> +	}
> +
> +	return retval;
> +}

> +/*
> + * Shift a number both directions

I think that's "either direction".

> + *
> + * Returns 0 on success or a negative value indicating error
> + *
> + * @n: 	  pointer pointer to the allocated mpi
> + * @bits: shift to the right if positive, otherwise shift to the left
> + */
> +static _err rsa_mpi_shift(mpi ** n, _i64 bits)
> +{
> +	_i32 i, distance, size, lz;
> +	_u32 * buf;
> +	mpi * handle;
> +	_err retval;
> +
> +	handle = *n;
> +	if(!bits || rsa_mpi_iszero(handle))
> +		return RSA_NO_ERR;
> +
> +	/* Shifting to the right, no resize needed */
> +	if(bits > 0) {
> +		/* Drop off one limb for each 32 bit shift */
> +		distance = bits / 32;
> +		size = handle->size;
> +		buf = handle->data;
> +		for(i = 0; i < size; i++)
> +			buf[i] = (i + distance >= size)? 0x00: buf[i + distance];
> +
> +		/* Shift the remaining 'bits' mod 32 */
> +		bits = bits % 32;
> +		if(bits) {
> +			size -= distance;
> +			distance = 32 - bits;
> +			for(i = 0; i < size; i++) {
> +				buf[i] = buf[i] >> bits;
> +				if(i < size - 1)
> +					buf[i] |=  buf[i + 1] << distance;
> +			}
> +		}
> +
> +		rsa_mpi_canonicalize(handle);
> +		return RSA_NO_ERR;
> +	}
> +
> +	bits = -bits;
> +	lz = rsa_mpi_clz(handle) + (handle->limbs - handle->size) * 32;
> +
> +	/* Shifting to the left
> +	 * Reallocation is needed when the leading zeroes are less than the shift
> +	 * distance
> +	 */
> +	if(lz < bits) {
> +		/* Compute the size of the reallocation */
> +		size = bits - lz;
> +		size = (size / 32) + (size % 32 != 0);
> +		retval = rsa_mpi_resize(n, handle->limbs + size, true);
> +		if(retval < 0)
> +			return retval;
> +		handle = *n;
> +	}
> +	else {
> +		size = bits - rsa_mpi_clz(handle);
> +		handle->size += ((size / 32) + (size % 32 != 0));
> +	}
> +
> +	buf = handle->data;
> +	distance = bits / 32;
> +	/* Shift data 1 byte to the left for each 32 bit shift */
> +	if(distance) {
> +		/* Shift bytes */
> +		for(i = handle->size - distance - 1; i >= 0; i--)
> +			buf[i + distance] = buf[i];
> +		/* Zero the shifted in bytes */
> +		for(i = 0; i < distance; i++)
> +			buf[i] = 0;
> +	}
> +
> +	/* Shift the remaining 'bits' mod 32 */
> +	bits = bits % 32;
> +	distance = 32 - bits;
> +	if(bits)
> +		for(i = handle->size - 1; i >= 0; i--) {
> +			buf[i] = buf[i] << bits;
> +			if(i > 0)
> +				buf[i] |= (buf[i - 1] >> distance);
> +		}
> +
> +	return RSA_NO_ERR;
> +}
> +
> +/*
> + * Multiply two mpis
> + *
> + * Returns 0 on success or a negative value indicating error
> + *
> + * @res: pointer pointer to the result
> + * @a:	 left operand
> + * @b:   right operand
> + */
> +static _err rsa_mpi_multiply(mpi ** res, mpi *	a, mpi * b)

s/<tab>/<space>/  (in several places)

> +{
> +	_i32 i, j, size, asize, bsize;
> +	_u32 * buf, * abuf, * bbuf;
> +	_u64 tmp;
> +	mpi * handle;
> +	_err retval;
> +
> +	asize = a->size;
> +	bsize = b->size;
> +	size = asize + bsize;
> +	retval = rsa_mpi_resize(res, size, false);
> +	if(retval < 0)
> +		return retval;
> +
> +	handle = *res;
> +	handle->sign = a->sign ^ b->sign;
> +
> +	buf = handle->data;
> +	abuf = a->data;
> +	bbuf = b->data;
> +	/* Make the multiplication, using the standard algorithm */
> +	for(i = 0; i < bsize; i++) {
> +		tmp = 0;
> +		for(j = 0; j < asize; j++)
> +			buf[i + j] = tmp = buf[i + j] + (abuf[j] * (_u64)bbuf[i]) + (tmp >> 32);
> +		buf[i + asize] = tmp >> 32;
> +	}
> +
> +	rsa_mpi_canonicalize(handle);
> +	return RSA_NO_ERR;
> +}

> +/*
> + * Compute the remainder of a/b (aka a mod b)
> + *
> + * Returns 0 on success or a negative value indicating error
> + *
> + * @res: pointer pointer to the result
> + * @a:	 left operand
> + * @b:   right operand
> + */
> +static _err rsa_mpi_remainder(mpi ** res, mpi * a, mpi * b)
> +{
> +	_i32 i, k;
> +	_err retval;
> +
> +	/* Because b operand will be shifted we need to have a copy of it in
> +	 * order not to mess with the prototype b
> +	 */
> +	if((retval = rsa_mpi_copy(&aux[0], a)) < 0 ||
> +	   (retval = rsa_mpi_copy(&aux[1], b)) < 0)
> +		return retval;
> +
> +	k = (aux[0]->size - aux[1]->size) * 32;
> +	k += (rsa_mpi_clz(aux[1]) - rsa_mpi_clz(aux[0]));
> +
> +	/* Align the divisor to the divident */
                                    dividend

> +	retval = rsa_mpi_shift(&aux[1], -k);
> +	if(retval < 0)
> +		return retval;
> +
> +	for(i = 0; i <= k; i++) {
> +		retval = rsa_mpi_subtract(res, aux[0], aux[1]);
> +		if(retval < 0)
> +			return retval;
> +
> +		if(!(*res)->sign) {
> +			retval = rsa_mpi_copy(&aux[0], (*res));
> +			if(retval < 0)
> +				return retval;
> +		}
> +
> +		retval = rsa_mpi_shift(&aux[1], 1);
> +		if(retval < 0)
> +			return retval;
> +	}
> +
> +	rsa_mpi_canonicalize(aux[0]);
> +	return rsa_mpi_copy(res, aux[0]);
> +}

> diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff linux-2.6.20.1/crypto/rsa.h linux-2.6.20.1-vanilla/crypto/rsa.h
> --- linux-2.6.20.1/crypto/rsa.h	1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.20.1-vanilla/crypto/rsa.h	2007-03-19 16:29:34.000000000 +0200
> @@ -0,0 +1,86 @@
> +#ifndef _KM_RSA_H_
> +#define _KM_RSA_H_
> +
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <config/rsa/auxcount.h>
> +#include <config/rsa/auxsize.h>

Those 2 config files shouldn't be needed.  include/linux/autoconf.h
is automatically included in all source files/builds.

> +
> +#define RSA_AUX_COUNT 		CONFIG_RSA_AUXCOUNT
> +#define RSA_AUX_SIZE 		CONFIG_RSA_AUXSIZE
> +#define RSA_MAX_U32		0xFFFFFFFF
> +#define RSA_RADIX_BITS		0x20
> +#define RSA_LOGLEVEL		KERN_ALERT
> +#define RSA_NO_ERR		0
> +#define RSA_ERR_INVARG		-1
> +#define RSA_ERR_NOMEM		-2
> +
> +#define true			0x01
> +#define false			0x00

Aren't these already available in C?

> +
> +#ifdef RSA_DEBUG
> +	#define rsa_debug(fmt, args...) 			   \
> +	{ 							   \
> +		if(printk_ratelimit()) 				   \
> +			printk(RSA_LOGLEVEL "rsa: " fmt, ## args); \
> +	}
> +#else
> +	#define rsa_debug(fmt, args...)
> +#endif
> +
> +#define rsa_echo(fmt, args...) printk(RSA_LOGLEVEL "rsa: " fmt, ## args)
> +
> +#if RSA_AUX_COUNT < 8
> +	#error "Rsa module needs at least 8 auxilliary mpis"
> +#endif
> +
> +typedef signed char 		_i8;
> +typedef signed short		_i16;
> +typedef signed int 		_i32;
> +typedef signed long long	_i64;
> +typedef unsigned char 		_u8;
> +typedef unsigned short		_u16;
> +typedef unsigned int 		_u32;
> +typedef unsigned long long	_u64;
> +typedef signed int		_err;
> +
> +/* Multi-precision integer */
> +typedef struct mpi {
> +	_u32	* data;	/* _u32 array holding the number absolute value */
> +	_u8	sign;	/* 1 for negative, 0 for positive */
> +	_i32	size;	/* Significant number limbs */
> +	_i32	limbs;	/* Allocated limbs (sizeof data) */
> +} mpi;
> +
> +/* Module loading/unloading functions */
> +static _err __init	rsa_load(void);
> +static void __exit	rsa_unload(void);
> +
> +/* Mpi utility functions */
> +static _err		rsa_mpi_alloc(mpi **, _i32);
> +static void 		rsa_mpi_free(mpi *);
> +static _err 		rsa_mpi_init(mpi **, _u8 *, _u32, _u32);
> +static _err 		rsa_mpi_resize(mpi **, _i32, _u8);
> +static _err 		rsa_mpi_set(mpi **, _u8 *, _u32);
> +static inline _err 	rsa_mpi_copy(mpi **, mpi *);
> +static void 		rsa_mpi_print(mpi *, _u8);
> +
> +/* Mpi comparing and misc functions */
> +static inline _u8 	rsa_mpi_iszero(mpi *);
> +static _i8 		rsa_mpi_compare(mpi *, mpi *);
> +static _u64	 	rsa_mpi_clz(mpi *);
> +static inline void 	rsa_mpi_complement(mpi *, _u8);
> +static inline void 	rsa_mpi_canonicalize(mpi *);
> +
> +/* Mpi arithmetic functions */
> +static _err		rsa_mpi_shift(mpi **, _i64);
> +static _err 		rsa_mpi_multiply(mpi **, mpi *, mpi *);
> +static _err 		rsa_mpi_subtract(mpi **, mpi *, mpi *);
> +static _err 		rsa_mpi_remainder(mpi **, mpi *, mpi *);
> +
> +/* Rsa functions */
> +static _u32		rsa_modinv(mpi *);
> +static _err 		rsa_monpro(mpi **, mpi *, mpi *, mpi *);
> +static _err 		rsa_modexp(mpi **, mpi *, mpi *, mpi *);
> +
> +#endif /* _KM_RSA_H_ */


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
