Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbXCUQFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbXCUQFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbXCUQFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:05:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39621 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697AbXCUQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:05:54 -0400
Date: Wed, 21 Mar 2007 09:04:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tasos Parisinos <t.parisinos@sciensis.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][NEW] crypto API: rsa algorithm module patch (kernel
 version 2.6.20.3)
Message-Id: <20070321090420.f46cef4f.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0703211701260.27640@zenon.ceid.upatras.gr>
References: <Pine.LNX.4.64.0703211701260.27640@zenon.ceid.upatras.gr>
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

On Wed, 21 Mar 2007 17:13:31 +0200 (EET) Tasos Parisinos wrote:

> This patch changes the crypto/Kconfig crypto/Makefile and adds 
> crypto/rsa.c. These files add module named rsa.o (rsa.ko) built-in or as
> a kernel module and offer an API to do fast modular exponentiation
> and other multi-precision arithmetics.
> Signed-off-by: Tasos Parisinos <t.parisinos@sciensis.com>
> 
> ---

Hi,
Lots of good progress here, but still a few comments below.

Needs to apply to current mainline.


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
> +
> +#define RADIX_BITS		0x20
> +#define UINT32_T_MAX		0xFFFFFFFF
> +
> +/* Multi-precision integer */
> +typedef struct mpi {
> +	u32	*data;	/* u32 array holding the number absolute value */
> +	u8	sign;	/* 1 for negative, 0 for positive */
> +	int	size;	/* Significant number limbs */
> +	int	limbs;	/* Allocated limbs (sizeof data) */
> +} mpi;
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

Most (probably all) of these functions should also be "static"
unless they are meant for use outside of this module.

Which leads to the question:  which functions are meant for
external/exported use?

And it would be really Good if those function headers were
documented in kernel-doc notation (not much of a change from
what you already have here; see Documentation/kernel-doc-nano-HOWTO.txt).


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
> +
> +void mpi_free(mpi *n)
> +{
> +	if (!n)
> +		return;
> +	kfree(n->data);
> +	kfree(n);
> +}

We usually even designate inlines as static...

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
> +	return 0;
> +}

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

Break that line to < 80 columns, please.

> +		buf[i + asize] = tmp >> 32;
> +	}
> +
> +	mpi_canonicalize(handle);
> +	return 0;
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
> +		product = 0;
> +
> +		for (j = 0; j < nsize; j++)
> +			tmp[j] = product = tmp[j] + (m * (u64)nbuf[j]) + (product >> 32);

Line too long.

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
> +	retval = mpi_shift(&aux[2], nsize * 32);
> +	if (retval < 0)
> +		return retval;
> +
> +	if (mpi_compare(aux[2], n) >= 0) {
> +		if ((retval = mpi_subtract(&aux[3], aux[2], n)) < 0 ||
> +		    (retval = mpi_copy(res, aux[3])) < 0)
> +			return retval;
> +	}
> +	else if ((retval = mpi_copy(res, aux[2])) < 0)
> +		return retval;
> +	return 0;
> +}

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
