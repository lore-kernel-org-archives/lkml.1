Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbXCUPNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbXCUPNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXCUPNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:13:40 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:8595 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbXCUPNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:13:38 -0400
Date: Wed, 21 Mar 2007 17:13:31 +0200 (EET)
From: Tasos Parisinos <t.parisinos@sciensis.com>
X-X-Sender: parisino@zenon.ceid.upatras.gr
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1][NEW] crypto API: rsa algorithm module patch (kernel
 version 2.6.20.3)
Message-ID: <Pine.LNX.4.64.0703211701260.27640@zenon.ceid.upatras.gr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the crypto/Kconfig crypto/Makefile and adds 
crypto/rsa.c. These files add module named rsa.o (rsa.ko) built-in or as
a kernel module and offer an API to do fast modular exponentiation
and other multi-precision arithmetics.
Signed-off-by: Tasos Parisinos <t.parisinos@sciensis.com>

---

diff -uprN -X linux-2.6.20.3-vanilla/Documentation/dontdiff \
linux-2.6.20.3/crypto/Kconfig linux-2.6.20.3-vanilla/crypto/Kconfig
--- linux-2.6.20.3/crypto/Kconfig 2007-03-13 20:27:08.000000000 +0200
+++ linux-2.6.20.3-vanilla/crypto/Kconfig 2007-03-21 15:15:04.000000000 +0200
@@ -458,6 +458,41 @@ config CRYPTO_CRC32C
  	  See Castagnoli93.  This implementation uses lib/libcrc32c.
            Module will be crc32c.

+config CRYPTO_RSA
+	tristate "RSA cipher algorithm"
+	help
+	  The famous RSA asymmetric cipher algorithm. This may be used
+	  in-kernel (no userland interface yet) to compute modular
+	  exponentiation. It can be also used to do some multi-precision
+	  arithmetics.
+
+	  If it is selected it will add approximately 8K to the kernel size.
+	  Select M to build this driver as a module.
+	  If unsure say N.
+
+
+config RSA_AUXCOUNT
+	int "Initial preallocated mpi pool size"
+	default "8"
+	depends on CRYPTO_RSA
+	help
+	  The rsa module needs some preallocated space to avoid
+	  computation-time allocations. The 'mpi' is the struct used
+	  by the rsa module to hold a multi-precision integer, so this 
+	  setting is the number of mpi's allocated at module load time.
+
+config RSA_AUXSIZE
+	int "Initial preallocated mpi limb size"
+	default "128"
+	depends on CRYPTO_RSA
+	help
+	  The rsa module needs some preallocated space to avoid
+	  computation-time allocations. The 'mpi' is the struct used
+	  by the rsa module to hold a multi-precision integer. This
+	  struct maps a number on multiple 32 bit limbs (it is actually
+	  a 32 bit array). Here you select the default size (in limbs)
+	  of the preallocated mpis.
+
  config CRYPTO_TEST
  	tristate "Testing module"
  	depends on m
diff -uprN -X linux-2.6.20.3-vanilla/Documentation/dontdiff \
linux-2.6.20.3/crypto/Makefile linux-2.6.20.3-vanilla/crypto/Makefile
--- linux-2.6.20.3/crypto/Makefile 2007-03-13 20:27:08.000000000 +0200
+++ linux-2.6.20.3-vanilla/crypto/Makefile 2007-03-21 15:15:04.000000000 +0200
@@ -43,5 +43,6 @@ obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
  obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
  obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
  obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
+obj-$(CONFIG_CRYPTO_RSA) += rsa.o

  obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
diff -uprN -X linux-2.6.20.3-vanilla/Documentation/dontdiff \
linux-2.6.20.3/crypto/rsa.c linux-2.6.20.3-vanilla/crypto/rsa.c
--- linux-2.6.20.3/crypto/rsa.c	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.20.3-vanilla/crypto/rsa.c	2007-03-21 15:15:04.000000000 +0200
@@ -0,0 +1,809 @@
+/*
+ * Cryptographic API
+ *
+ * RSA cipher algorithm implementation
+ *
+ * Copyright (c) Tasos Parisinos <t.parisinos@sciensis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/time.h>
+
+#if CONFIG_RSA_AUXCOUNT < 8
+	#error "Rsa module needs at least 8 auxilliary mpis"
+#endif
+
+#define RADIX_BITS		0x20
+#define UINT32_T_MAX		0xFFFFFFFF
+
+/* Multi-precision integer */
+typedef struct mpi {
+	u32	*data;	/* u32 array holding the number absolute value */
+	u8	sign;	/* 1 for negative, 0 for positive */
+	int	size;	/* Significant number limbs */
+	int	limbs;	/* Allocated limbs (sizeof data) */
+} mpi;
+
+static mpi 	*aux[CONFIG_RSA_AUXCOUNT];
+static u32 	modinv;
+
+/*
+ * mpi_alloc - allocate an mpi
+ * @n: pointer pointer to the allocated mpi
+ * @limbs: number of allocated limbs (32 bit digits)
+ *
+ * The allocated mpi will be zeroed and not canonicalized
+ */
+int mpi_alloc(mpi **n, int limbs)
+{
+	mpi *handle;
+
+	*n = NULL;
+	if (!limbs)
+		return -EINVAL;
+
+	/* Allocate space for the mpi */
+	handle = *n = kmalloc(sizeof(mpi), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->data = kzalloc(limbs * sizeof(u32), GFP_KERNEL);
+	if (!handle->data) {
+		kfree(handle);
+		*n = NULL;
+		return -ENOMEM;
+	}
+
+	handle->sign = 0;
+	handle->size = handle->limbs = limbs;
+	return 0;
+}
+
+void mpi_free(mpi *n)
+{
+	if (!n)
+		return;
+	kfree(n->data);
+	kfree(n);
+}
+
+/*
+ * mpi_init - initialize an mpi given its hex (absolute) value
+ * @n: pointer pointer to the allocated mpi
+ * @str: hex data
+ * @size: sizeof(str)
+ * @xtra: how many extra limbs to preallocate to avoid reallocations
+ *
+ * The optional leading zeroes will be taken into account, so that the
+ * mpi created will not be canonicalized
+ */
+int mpi_init(mpi **n, u8 *str, u32 size, u32 xtra)
+{
+	int i, j, s, retval;
+	u32 *buf;
+
+	*n = NULL;
+	if (!size && !xtra)
+		return -EINVAL;
+
+	/* Allocate space for the mpi and its data */
+	s = (size + 3) / 4;
+	retval = mpi_alloc(n, s + xtra);
+	if (retval < 0)
+		return retval;
+
+	(*n)->size = s;
+	buf = (*n)->data;
+
+	/* Copy the data */
+	for (i = size - 1, j = 0; i >= 0; i--, j++)
+		buf[j / 4] |= ((u32)str[i] << ((j % 4) * 8));
+	return 0;
+}
+
+/*
+ * mpi-resize - resize an mpi, doing all the needed re-allocations
+ * @n: pointer pointer to the allocated mpi
+ * @size: the new size
+ * @hold: true to keep the current data
+ */
+int mpi_resize(mpi **n, int size, u8 hold)
+{
+	int retval;
+	mpi *handle = *n;
+
+	/* If there is an mpi passed in, that has the available limbs */
+	if (handle && handle->limbs >= size) {
+		int i, s;
+		u32 *buf;
+
+		s = handle->size;
+		buf = handle->data;
+
+		/* If the original data are not needed they are zeroed */
+		if (!hold) {
+			for (i = 0; i < s; i++)
+				buf[i] = 0;
+			handle->sign = 0;
+		}
+		/* zero the xtra limbs */
+		else if (size < handle->size)
+			for (i = size; i < s; i++)
+				buf[i] = 0;
+
+		handle->size = size;
+	}
+	/* If there is an mpi passed in, that doesn't have the available
+	 * limbs already allocated
+	 */
+	else if (handle) {
+		mpi *tmp = NULL;
+
+		retval = mpi_alloc(&tmp, size);
+		if (retval < 0)
+			return retval;
+
+		/* Copy the original data if they are needed */
+		if (hold) {
+			memcpy(tmp->data, handle->data, 
+			       handle->size * sizeof(u32));
+			tmp->sign = handle->sign;
+		}
+
+		mpi_free(*n);
+		*n = tmp;
+		return retval;
+	}
+	/* If there is no allocated mpi passed in, allocate one */
+	else if (!handle) {
+		retval = mpi_alloc(n, size);
+		if (retval < 0)
+			return retval;
+	}
+
+	return 0;
+}
+
+/*
+ * mpi_set - set the value of an mpi given its hex (absolute) value
+ * @n: pointer pointer to the allocated mpi
+ * @str: hex data
+ * @size: sizeof(str)
+ *
+ * The optional leading zeroes will be taken into account, so that the mpi
+ * created will not be canonicalized. The mpi passed in will be re-allocated
+ * (and relocated) if needeed
+ */
+static int mpi_set(mpi **n, u8 *str, u32 size)
+{
+	int s, i, j, retval;
+	u32 *buf;
+
+	if (!size)
+		return -EINVAL;
+
+	/* Size of the new mpi value (in limbs) */
+	s = (size + 3) / 4;
+	retval = mpi_resize(n, s, false);
+	if (retval < 0)
+		return retval;
+
+	/* Copy the data */
+	buf = (*n)->data;
+	for (i = size - 1, j = 0; i >= 0; i--, j++)
+		buf[j / 4] |= ((u32)str[i] << ((j % 4) * 8));
+	return 0;
+}
+
+inline int mpi_copy(mpi **dest, mpi *src)
+{
+	int i, s, retval;
+	u32 *destbuf, *srcbuf;
+
+	retval = mpi_resize(dest, src->size, false);
+	if (retval < 0)
+		return retval;
+
+	(*dest)->sign = src->sign;
+	destbuf = (*dest)->data;
+	srcbuf = src->data;
+	for (i = 0, s = src->size; i < s; i++)
+		destbuf[i] = srcbuf[i];
+	return 0;
+}
+
+inline u8 mpi_iszero(mpi *n)
+{
+	int i, s;
+	u32 *buf;
+
+	s = n->size;
+	buf = n->data;
+	for (i = 0; i < s; i++)
+		if (buf[i])
+			return false;
+	return true;
+}
+
+/*
+ * mpi_print - print the value of an mpi
+ * @n: pointer to the mpi
+ * @how: true to print canonicalized
+ */
+void mpi_print(mpi *n, u8 how)
+{
+	int i, j;
+	u32 limb;
+	u8 byte, started = false;
+
+	printk("Mpi at 0x%x, %d limbs in size, %d limbs allocated, value = ",
+	       (u32)n, n->size, n->limbs);
+
+	/* If the mpi is merely zero */
+	if (mpi_iszero(n) && how) {
+		printk("0\n");
+		return;
+	}
+
+	/* Print the sign */
+	printk("%s", (n->sign)? "-": " ");
+
+	/* Print the hex value */
+	for (i = n->size - 1; i >= 0; i--) {
+		limb = n->data[i];
+
+		/* Ignore leading zero limbs if canonicalized printing
+		 * is selected
+		 */
+		if (!limb && !started && how)
+			continue;
+
+		/* Print each limb as though each of its nibbles was a 
+		 * character from the set '0' to '9' and 'a' to 'f'
+		 */
+		for (j = 28; j >= 0; j -= 4) {
+			byte = (u8)((limb >> j) & 0x0F);
+
+			/* Ignore leading zero bytes if canonicalized printing
+			 * is selected
+			 */
+			if (!byte && !started && how)
+				continue;
+
+			started = true;
+			byte += (byte <= 0x09)? '0': 'a' - 0x0A;
+			printk("%c", byte);
+		}
+	}
+
+	printk("\n");
+}
+
+/*
+ * mpi_clz - count leading zeroes
+ * @n: the mpi
+ */
+u32 mpi_clz(mpi *n)
+{
+	int i;
+	u32 limb, retval = 0;
+
+	for (i = n->size - 1; i >= 0; i--) {
+		limb = n->data[i];
+
+		if (!limb) {
+			retval += 32;
+			continue;
+		}
+
+		while (!(limb & 0x80000000)) {
+			retval++;
+			limb = limb << 1;
+		}
+
+		break;
+	}
+
+	return retval;
+}
+
+/*
+ * mpi_compare - compare two mpis
+ * @a: the left operand
+ * @b: the right operand
+ *
+ * Returns -1 if a < b, 1 if b < a, 0 otherwise
+ */
+char mpi_compare(mpi *a, mpi *b)
+{
+	int i, j;
+	u32 *abuf, *bbuf;
+
+	/* Compare the two mpis based on sign */
+	if (a->sign != b->sign)
+		return (a->sign)? -1: 1;
+
+	/* Compare the two mpis based on their size */
+	if (a->size > b->size && mpi_clz(a) < (a->size - b->size) * 32)
+		return 1;
+	else if (a->size > b->size)
+		j = b->size;
+	else if (b->size > a->size && mpi_clz(b) < (b->size - a->size) * 32)
+		return -1;
+	else
+		j = a->size;
+
+	/* Compare the two mpis based on their hex values */
+	abuf = a->data;
+	bbuf = b->data;
+	for (i = j - 1; i >= 0; i--)
+		if (abuf[i] > bbuf[i])
+			return 1;
+		else if (abuf[i] < bbuf[i])
+			return -1;
+
+	return 0;
+}
+
+/*
+ * mpi_complement - complement an mpi
+ * @n: the mpi
+ * @which: true to compute 2's complement
+ */
+inline void mpi_complement(mpi *n, u8 which)
+{
+	int i, s;
+	u32 *buf;
+
+	s = n->size;
+	buf = n->data;
+	for (i = 0; i < s; i++)
+		buf[i] ^= UINT32_T_MAX;
+	if (!which)
+		return;
+
+	/* Add 1 using the addition carry */
+	for (i = 0; i < s; i++) {
+		buf[i] += 1;
+		if (buf[i])
+			break;
+	}
+}
+
+inline void mpi_canonicalize(mpi *n)
+{
+	int i;
+	u32 *buf = n->data;
+
+	for (i = n->size - 1; i >= 0; i--)
+		if (!buf[i] && n->size > 1)
+			n->size--;
+		else
+			break;
+}
+
+/*
+ * mpi_shift - shift a number either directions
+ * @n: pointer pointer to the allocated mpi
+ * @bits: shift to the right if positive, otherwise shift to the left
+ */
+int mpi_shift(mpi **n, int bits)
+{
+	int i, distance, size, lz, retval;
+	u32 *buf;
+	mpi *handle;
+
+	handle = *n;
+	if (!bits || mpi_iszero(handle))
+		return 0;
+
+	/* Shifting to the right, no resize needed */
+	if (bits > 0) {
+		/* Drop off one limb for each 32 bit shift */
+		distance = bits / 32;
+		size = handle->size;
+		buf = handle->data;
+		for (i = 0; i < size; i++)
+			buf[i] = (i + distance >= size)? 0: buf[i + distance];
+
+		/* Shift the remaining 'bits' mod 32 */
+		bits = bits % 32;
+		if (bits) {
+			size -= distance;
+			distance = 32 - bits;
+			for (i = 0; i < size; i++) {
+				buf[i] = buf[i] >> bits;
+				if (i < size - 1)
+					buf[i] |=  buf[i + 1] << distance;
+			}
+		}
+
+		mpi_canonicalize(handle);
+		return 0;
+	}
+
+	bits = -bits;
+	lz = mpi_clz(handle) + (handle->limbs - handle->size) * 32;
+
+	/* Shifting to the left.
+	 * Reallocation is needed when the leading zeroes are less than
+	 * the shift distance
+	 */
+	if (lz < bits) {
+		/* Compute the size of the reallocation */
+		size = (bits - lz + 31) / 32;
+		retval = mpi_resize(n, handle->limbs + size, true);
+		if (retval < 0)
+			return retval;
+		handle = *n;
+	}
+	else
+		handle->size += ((bits - mpi_clz(handle) + 31) / 32);
+
+	buf = handle->data;
+	distance = bits / 32;
+	/* Shift data 1 byte to the left for each 32 bit shift */
+	if (distance) {
+		/* Shift bytes */
+		for (i = handle->size - distance - 1; i >= 0; i--)
+			buf[i + distance] = buf[i];
+
+		/* Zero the shifted in bytes */
+		for (i = 0; i < distance; i++)
+			buf[i] = 0;
+	}
+
+	/* Shift the remaining 'bits' mod 32 */
+	bits = bits % 32;
+	distance = 32 - bits;
+	if (bits)
+		for (i = handle->size - 1; i >= 0; i--) {
+			buf[i] = buf[i] << bits;
+			if (i > 0)
+				buf[i] |= (buf[i - 1] >> distance);
+		}
+
+	return 0;
+}
+
+int mpi_multiply(mpi **res, mpi *a, mpi *b)
+{
+	int i, j, size, asize, bsize, retval;
+	u32 *buf, *abuf, *bbuf;
+	u64 tmp;
+	mpi *handle;
+
+	asize = a->size;
+	bsize = b->size;
+	size = asize + bsize;
+	retval = mpi_resize(res, size, false);
+	if (retval < 0)
+		return retval;
+
+	handle = *res;
+	handle->sign = a->sign ^ b->sign;
+
+	buf = handle->data;
+	abuf = a->data;
+	bbuf = b->data;
+	/* Make the multiplication, using the standard algorithm */
+	for (i = 0; i < bsize; i++) {
+		tmp = 0;
+		for (j = 0; j < asize; j++)
+			buf[i + j] = tmp = buf[i + j] + (abuf[j] * (u64)bbuf[i]) + (tmp >> 32);
+		buf[i + asize] = tmp >> 32;
+	}
+
+	mpi_canonicalize(handle);
+	return 0;
+}
+
+int mpi_subtract(mpi **res, mpi *a, mpi *b)
+{
+	int i, size, retval;
+	u32 *buf, *abuf, *bbuf;
+	mpi *handle;
+
+	size = max(a->size, b->size) + (a->sign != b->sign);
+	if ((retval = mpi_resize(res, size, true)) < 0 ||
+	    (retval = mpi_resize(&a, size, true)) < 0  ||
+	    (retval = mpi_resize(&b, size, true)) < 0)
+		return retval;
+
+	handle = *res;
+	buf = handle->data;
+	abuf = a->data;
+	bbuf = b->data;
+
+	/* If the operands are both negative or positive perform subtraction */
+	if (a->sign == b->sign) {
+		 u8 borrow = false;
+		 u32 limb;
+
+		for (i = 0; i < size; i++) {
+			limb = borrow + bbuf[i];
+			buf[i] = abuf[i] - limb;
+			borrow = (abuf[i] < limb);
+		}
+
+		handle->sign = (borrow)? !b->sign: b->sign;
+		if (borrow)
+			mpi_complement(handle, true);
+	}
+	/* If the operands are not signed in the same way perform addition */
+	else {
+		 u8 carry = false;
+		 u64 sum;
+
+		for (i = 0; i < size; i++) {
+			buf[i] = sum = abuf[i] + bbuf[i] + carry;
+			carry = (sum > UINT32_T_MAX);
+		}
+
+		handle->sign = a->sign;
+	}
+
+	mpi_canonicalize(handle);
+	mpi_canonicalize(a);
+	mpi_canonicalize(b);
+	return 0;
+}
+
+int mpi_remainder(mpi **res, mpi *a, mpi *b)
+{
+	int i, k, retval;
+
+	/* Because b operand will be shifted we need to have a copy of it
+	 * in order not to mess with the prototype
+	 */
+	if ((retval = mpi_copy(&aux[0], a)) < 0 ||
+	    (retval = mpi_copy(&aux[1], b)) < 0)
+		return retval;
+
+	k = (aux[0]->size - aux[1]->size) * 32;
+	k += (mpi_clz(aux[1]) - mpi_clz(aux[0]));
+
+	/* Align the divisor to the dividend */
+	retval = mpi_shift(&aux[1], -k);
+	if (retval < 0)
+		return retval;
+
+	for (i = 0; i <= k; i++) {
+		retval = mpi_subtract(res, aux[0], aux[1]);
+		if (retval < 0)
+			return retval;
+
+		if (!(*res)->sign) {
+			retval = mpi_copy(&aux[0], (*res));
+			if (retval < 0)
+				return retval;
+		}
+
+		retval = mpi_shift(&aux[1], 1);
+		if (retval < 0)
+			return retval;
+	}
+
+	mpi_canonicalize(aux[0]);
+	return mpi_copy(res, aux[0]);
+}
+
+/*
+ * rsa_modinv - compute the first 32 bits of the modular inverse of a number
+ * @n: the mpi
+ */
+u32 rsa_modinv(mpi *n)
+{
+	u32 i, x, y, tmp, pow1;
+
+	pow1 = y = 1;
+	x = n->data[0];
+
+	for (i = 2; i <= RADIX_BITS; i++) {
+		pow1 = pow1 << 1;
+		tmp = ((u64)x * y) & (UINT32_T_MAX >> (32 - i));
+		if (pow1 < tmp)
+			y += pow1;
+	}
+
+	y = (y ^ UINT32_T_MAX) + 1;
+	return y;
+}
+
+/*
+ * rsa_monpro - compute the montgomery product (res = a * b mod n)
+ * @res: pointer pointer to the result
+ * @a: left operand
+ * @b: right operand
+ * @n: divisor
+ */
+int rsa_monpro(mpi **res, mpi *a, mpi *b, mpi *n)
+{
+	int nsize, i, j, k, retval;
+	u32 *buf, *nbuf, *tmp, m;
+	u64 product = 0;
+
+	nsize = n->size;
+	k = nsize << 1;
+	retval = mpi_multiply(&aux[2], a, b);
+	if (retval < 0)
+		return retval;
+
+	retval = mpi_resize(&aux[2], max(aux[2]->size, k), true);
+	if (retval < 0)
+		return retval;
+
+	tmp = buf = aux[2]->data;
+	nbuf = n->data;
+
+	for (i = 0; i < nsize; i++, tmp++) {
+		m = buf[i] * modinv;
+		product = 0;
+
+		for (j = 0; j < nsize; j++)
+			tmp[j] = product = tmp[j] + (m * (u64)nbuf[j]) + (product >> 32);
+
+		for (j = nsize + i; j < k; j++)
+			buf[j] = product = buf[j] + (product >> 32);
+	}
+
+	retval = mpi_resize(&aux[2], aux[2]->size + 1, true);
+	if (retval < 0)
+		return retval;
+
+	aux[2]->data[aux[2]->size - 1] = product >> 32;
+	retval = mpi_shift(&aux[2], nsize * 32);
+	if (retval < 0)
+		return retval;
+
+	if (mpi_compare(aux[2], n) >= 0) {
+		if ((retval = mpi_subtract(&aux[3], aux[2], n)) < 0 ||
+		    (retval = mpi_copy(res, aux[3])) < 0)
+			return retval;
+	}
+	else if ((retval = mpi_copy(res, aux[2])) < 0)
+		return retval;
+	return 0;
+}
+
+/*
+ * rsa_modexp - computes the RSA of m, a.k.a res = m ^ e mod n
+ * @res: pointer pointer to the result
+ * @m: base
+ * @e: exponent
+ * @n: divisor
+ */
+int rsa_modexp(mpi **res, mpi *m, mpi *e, mpi *n)
+{
+	int i, j, retval;
+	u32 limb;
+	u8 started = false;
+
+	if (m->size != n->size || mpi_compare(m, n) > 0)
+		return -EINVAL;
+
+	modinv = rsa_modinv(n);
+
+	/* Compute m * r mod n where r is 2 ^ k and n is the k-bit modulus.
+	 * The resulting m' is stored in aux[4]
+	 */
+	retval = mpi_copy(&aux[5], m);
+	if (retval < 0)
+		return retval;
+
+	retval = mpi_shift(&aux[5], -(n->size * 32));
+	if (retval < 0)
+		return retval;
+
+	retval = mpi_remainder(&aux[4], aux[5], n);
+	if (retval < 0)
+		return retval;
+
+	/* Compute r mod n where r is 2 ^ k and n is the k-bit modulus.
+	 * The resulting x' is stored in aux[7]
+	 */
+	retval = mpi_set(&aux[5], "\x01", 1);
+	if (retval < 0)
+		return retval;
+
+	retval = mpi_shift(&aux[5], -(n->size * 32));
+	if (retval < 0)
+		return retval;
+
+	retval = mpi_remainder(&aux[7], aux[5], n);
+	if (retval < 0)
+		return retval;
+
+	/* Canonicalize the exponent and compute the modular exponentiation.
+	 * For each limb of the exponent perform left to right binary
+	 * exponentiation
+	 */
+	mpi_canonicalize(e);
+	for (i = e->size - 1; i >= 0; i--) {
+		/* Take a limb of the exponent */
+		limb = e->data[i];
+
+		/* For each of its bits */
+		for (j = 0; j < 32; j++) {
+			/* While the exponent has non significant zeroes shift 
+			 * it to the left 
+			 */
+			if (!(limb & 0x80000000) && !started) {
+				limb = limb << 1;
+				continue;
+			}
+
+			started = true;
+			/* Compute x' * x' mod n */
+			retval = rsa_monpro(&aux[5], aux[7], aux[7], n);
+			if (retval < 0)
+				return retval;
+
+			if (limb & 0x80000000) {
+				/* Compute x' = m' * x' mod n */
+				retval = rsa_monpro(&aux[7], aux[4], aux[5], n);
+				if (retval < 0)
+					return retval;
+			}
+			else if ((retval = mpi_copy(&aux[7], aux[5])) < 0)
+				return retval;
+
+			limb = limb << 1;
+		}
+	}
+
+	/* Compute res = x' mod n */
+	retval = mpi_set(&aux[6], "\x01", 1);
+	if (retval < 0)
+		return retval;
+	return rsa_monpro(res, aux[7], aux[6], n);
+}
+
+static int __init rsa_load(void)
+{
+	int retval = 0;
+	u32 i;
+
+	/* Pre-allocate some auxilliary mpis */
+	printk(KERN_DEBUG "Allocating %d bytes for auxilliary operands\n",
+	       CONFIG_RSA_AUXSIZE * CONFIG_RSA_AUXCOUNT * sizeof(u32));
+
+	memset(&aux, 0, sizeof(aux));
+	for (i = 0; i < CONFIG_RSA_AUXCOUNT; i++) {
+		retval = mpi_alloc(&aux[i], CONFIG_RSA_AUXSIZE);
+		if (retval < 0)
+			goto rollback;
+	}
+
+	printk(KERN_DEBUG "RSA cipher algorithm module initialized\n");
+	return 0;
+
+/* Free all allocated resources if any errors occur */
+rollback:
+	for (i = 0; i < CONFIG_RSA_AUXCOUNT; i++)
+		mpi_free(aux[i]);
+	return retval;
+}
+
+static void __exit rsa_unload(void)
+{
+	u32 i;
+
+	/* Free all the pre-allocated auxilliary mpis */
+	for (i = 0; i < CONFIG_RSA_AUXCOUNT; i++)
+		mpi_free(aux[i]);
+	printk(KERN_DEBUG "RSA cipher algorithm module unloaded\n");
+}
+
+module_init(rsa_load);
+module_exit(rsa_unload);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tasos Parisinos @ Sciensis Advanced Technology Systems");
+MODULE_DESCRIPTION("RSA cipher algorithm implementation");

