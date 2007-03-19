Return-Path: <linux-kernel-owner+w=401wt.eu-S966031AbXCSRWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966031AbXCSRWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030378AbXCSRWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:22:52 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:6628 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966040AbXCSRWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:22:50 -0400
Date: Mon, 19 Mar 2007 19:22:00 +0200 (EET)
From: Tasos Parisinos <t.parisinos@sciensis.com>
X-X-Sender: parisino@zenon.ceid.upatras.gr
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org,
       Parisinos Anastasios <parisino@ceid.upatras.gr>
Subject: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel version
 2.6.20.1) (and i hope pine does not break it either)
Message-ID: <Pine.LNX.4.64.0703191907200.4352@zenon.ceid.upatras.gr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tasos Parisinos <t.parisinos@sciensis.com>

This patch changes the crypto/Kconfig and crypto/Makefile and adds 
crypto/rsa.c and crypto/rsa.h in the source tree. These files add
module rsa.o (or rsa.ko) in the kernel (built-in or as a kernel module) 
and offer an API to do fast modular exponentiation. The modular expone
ntiation algorithm is in fact implementation of the Montgomery algorithm. 
The API can also be used to do some multi precision arithmetics as well 
(multiplication, addition, subtraction, remainder) and can serve as
a basis for future multi-precision arithmetics implementations. The module 
is totally written in C, thus being portable but less efficient than any 
assembly implementation, but the code architecture is such that one could 
replace C code with assembly easily in the future. The module does not have
a userland interface yet, so it can be only used by other in-kernel code. 
As mentioned in the subject this patch applies in kernel version 2.6.20.1.
Please apply.
Signed-off-by: Tasos Parisinos <t.parisinos@sciensis.com>

---

diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff linux-2.6.20.1/crypto/Kconfig linux-2.6.20.1-vanilla/crypto/Kconfig
--- linux-2.6.20.1/crypto/Kconfig	2007-02-20 08:34:32.000000000 +0200
+++ linux-2.6.20.1-vanilla/crypto/Kconfig	2007-03-11 14:12:24.000000000 +0200
@@ -458,6 +458,46 @@ config CRYPTO_CRC32C
  	  See Castagnoli93.  This implementation uses lib/libcrc32c.
            Module will be crc32c.

+config CRYPTO_RSA
+	tristate "RSA cipher algorithm"
+	depends on CRYPTO
+	help
+	  The famous RSA asymmetric cipher algorithm. This may be used in-kernel
+	  (no userland interface yet) to compute modular exponentiation.  It can
+	  be also used to do some multi-precision arithmetics.
+
+	  If it is selected it will add approximately 8K to the kernel size.
+	  Select M to build this driver as a module.
+	  If unsure say N.
+
+config CRYPTO_RSA_DEBUG
+	bool "Debugging capabilities"
+	depends on CRYPTO_RSA
+	help
+		This adds lots of debugging information and debugging capabilities in
+		the rsa module. It also adds approximately 1 more K to the kernel.
+
+config RSA_AUXCOUNT
+	int "Initial preallocated mpi pool size"
+	default "8"
+	depends on CRYPTO_RSA
+	help
+	  The rsa module needs some preallocated space to avoid computation-time
+	  allocations. The 'mpi' is the struct used by the rsa module to hold  a
+	  multi-precision integer, so this setting is the number of mpi's alloca
+	  ted at module load time.
+
+config RSA_AUXSIZE
+	int "Initial preallocated mpi limb size"
+	default "128"
+	depends on CRYPTO_RSA && RSA_AUXCOUNT!="0"
+	help
+	  The rsa module needs some preallocated space to avoid computation-time
+	  allocations. The 'mpi' is the struct used by the rsa module to hold  a
+	  multi-precision  integer. This struct maps a number on multiple 32 bit
+	  limbs (it is actually a 32 bit array).Here you select the default size
+	  (in limbs) of the preallocated mpis.
+
  config CRYPTO_TEST
  	tristate "Testing module"
  	depends on m
diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff linux-2.6.20.1/crypto/Makefile linux-2.6.20.1-vanilla/crypto/Makefile
--- linux-2.6.20.1/crypto/Makefile	2007-02-20 08:34:32.000000000 +0200
+++ linux-2.6.20.1-vanilla/crypto/Makefile	2007-03-11 14:17:22.000000000 +0200
@@ -2,6 +2,11 @@
  # Cryptographic API
  #

+ifeq ($(CRYPTO_RSA_DEBUG),y)
+	EXTRA_CFLAGS += -DRSA_DEBUG
+endif
+EXTRA_CFLAGS += -DRSA_HAVE_MPI_PRINT -Wno-unused-function
+
  obj-$(CONFIG_CRYPTO) += api.o scatterwalk.o cipher.o digest.o compress.o

  crypto_algapi-$(CONFIG_PROC_FS) += proc.o
@@ -43,5 +48,6 @@ obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
  obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
  obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
  obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
+obj-$(CONFIG_CRYPTO_RSA) += rsa.o

  obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff linux-2.6.20.1/crypto/rsa.c linux-2.6.20.1-vanilla/crypto/rsa.c
--- linux-2.6.20.1/crypto/rsa.c	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.20.1-vanilla/crypto/rsa.c	2007-03-19 16:45:21.000000000 +0200
@@ -0,0 +1,884 @@
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
+ * (at your option) any later version.
+ *
+ */
+
+#include "rsa.h"
+
+static mpi *	aux[RSA_AUX_COUNT];
+static _u32 	modinv = 0;
+
+static inline _i32 rsa_max(_i32 x, _i32 y)
+{
+	return (x > y)? x: y;
+}
+
+/*
+ * Module loading callback function
+ *
+ * Returns 0 on success or a negative value indicating error
+ */
+static _err __init rsa_load(void)
+{
+	_u32 i;
+	_err retval = RSA_NO_ERR;
+
+	/* Pre-allocate some auxilliary mpis */
+	rsa_echo("Preallocating %lu bytes for auxilliary operands\n",
+		 RSA_AUX_SIZE * RSA_AUX_COUNT * sizeof(_u32));
+
+	memset(&aux, 0, sizeof(aux));
+	for(i = 0; i < RSA_AUX_COUNT; i++) {
+		retval = rsa_mpi_alloc(&aux[i], RSA_AUX_SIZE);
+		if(retval < 0)
+			goto rollback;
+	}
+
+	rsa_echo("RSA cipher algorithm module initialized\n");
+	return RSA_NO_ERR;
+
+/* Free all allocated resources if any errors occur */
+rollback:
+	for(i = 0; i < RSA_AUX_COUNT; i++)
+		rsa_mpi_free(aux[i]);
+	return retval;
+}
+
+/*
+ * Module unloading callback function
+ */
+static void __exit rsa_unload(void)
+{
+	_u32 i;
+
+	/* Free all the pre-allocated auxilliary mpis */
+	for(i = 0; i < RSA_AUX_COUNT; i++)
+		rsa_mpi_free(aux[i]);
+	rsa_echo("RSA cipher algorithm module unloaded\n");
+}
+
+/*
+ * Preallocate an mpi. The allocated mpi will be all-zeroed and not
+ * canonicalized.
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @n: 	  pointer pointer to the allocated mpi
+ * @limbs: number of allocated limbs (32 bit digits)
+ */
+static _err rsa_mpi_alloc(mpi ** n, _i32 limbs)
+{
+	mpi * handle;
+
+	*n = NULL;
+	if(!limbs)
+		return RSA_ERR_INVARG;
+
+	/* Allocate space for the mpi */
+	handle = *n = kmalloc(sizeof(mpi), GFP_KERNEL);
+	if(!handle) {
+		rsa_debug("%s: kmalloc failed\n", __FUNCTION__);
+		return RSA_ERR_NOMEM;
+	}
+
+	handle->data = kzalloc(limbs * sizeof(_u32), GFP_KERNEL);
+	if(!handle->data) {
+		kfree(handle);
+		*n = NULL;
+		rsa_debug("%s: kzalloc failed\n", __FUNCTION__);
+		return RSA_ERR_NOMEM;
+	}
+
+	handle->sign = 0;
+	handle->size = handle->limbs = limbs;
+	return RSA_NO_ERR;
+}
+
+/*
+ * Free the resources held by an mpi
+ */
+static void rsa_mpi_free(mpi * n)
+{
+	if(!n)
+		return;
+	kfree(n->data);
+	kfree(n);
+}
+
+/*
+ * Initialize an mpi given its hex (absolute) value. The optional leading
+ * zeroes will be taken into account, so that the mpi created will not be
+ * canonicalized
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @n:	  pointer pointer to the allocated mpi
+ * @str:  hex data
+ * @size: sizeof(str)
+ * @xtra: how many extra limbs to preallocate to avoid reallocations
+ */
+static _err rsa_mpi_init(mpi ** n, _u8 * str, _u32 size, _u32 xtra)
+{
+	_i32 i, j;
+	_u32 * buf;
+	_i32 s;
+	_err retval;
+
+	*n = NULL;
+	if(!size && !xtra) {
+		rsa_debug("%s: invalid initialization string\n", __FUNCTION__);
+		return RSA_ERR_INVARG;
+	}
+
+	/* Allocate space for the mpi and its data */
+	s = (size / 4) + ((size % 4)? 1: 0);
+	retval = rsa_mpi_alloc(n, s + xtra);
+	if(retval < 0)
+		return retval;
+
+	(*n)->size = s;
+	buf = (*n)->data;
+
+	/* Copy the data */
+	for(i = size - 1, j = 0; i >= 0; i--, j++)
+		buf[j / 4] |= ((_u32)str[i] << ((j % 4) * 8));
+	return RSA_NO_ERR;
+}
+
+/*
+ * Resize an mpi, doing all the needed re-allocations
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @n:	 pointer pointer to the allocated mpi
+ * @size: the new size
+ * @hold: true to keep the current data
+ */
+static _err rsa_mpi_resize(mpi ** n, _i32 size, _u8 hold)
+{
+	_err retval;
+	mpi * handle = *n;
+
+	/* If there is an mpi passed in, that has the available limbs */
+	if(handle && handle->limbs >= size) {
+		 _i32 i, s;
+		 _u32 * buf;
+
+		s = handle->size;
+		buf = handle->data;
+
+		/* If the original data are not needed they are zeroed */
+		if(!hold) {
+			for(i = 0; i < s; i++)
+				buf[i] = 0;
+			handle->sign = 0;
+		}
+		/* Zero the xtra limbs */
+		else if(size < handle->size)
+			for(i = size; i < s; i++)
+				buf[i] = 0;
+
+		handle->size = size;
+	}
+	/* If there is an mpi passed in, that doesn't have the available
+	 * limbs already allocated
+	 */
+	else if(handle) {
+		mpi * tmp = NULL;
+
+		retval = rsa_mpi_alloc(&tmp, size);
+		if(retval < 0)
+			return retval;
+
+		/* Copy the original data if they are needed */
+		if(hold) {
+			memcpy(tmp->data, handle->data, handle->size * sizeof(_u32));
+			tmp->sign = handle->sign;
+		}
+
+		rsa_mpi_free(*n);
+		*n = tmp;
+		return retval;
+	}
+	/* If there is no allocated mpi passed in, allocate one */
+	else if(!handle) {
+		retval = rsa_mpi_alloc(n, size);
+		if(retval < 0)
+			return retval;
+	}
+
+	return RSA_NO_ERR;
+}
+
+/*
+ * Set the value of an mpi given its hex (absolute) value. The optional
+ * leading zeroes will be taken into account, so that the mpi created will
+ * not be canonicalized. The mpi passed in will be re-allocated (and relocated)
+ * if needeed
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @n:	 pointer pointer to the allocated mpi
+ * @str:  hex data
+ * @size: sizeof(str)
+ */
+static _err rsa_mpi_set(mpi ** n, _u8 * str, _u32 size)
+{
+	_i32 s, i, j;
+	_u32 * buf;
+	_err retval;
+
+	if(!size) {
+		rsa_debug("%s: invalid initialization string\n", __FUNCTION__);
+		return RSA_ERR_INVARG;
+	}
+
+	/* Size of the new mpi value (in limbs) */
+	s = (size / 4) + ((size % 4)? 1: 0);
+	retval = rsa_mpi_resize(n, s, false);
+	if(retval < 0)
+		return retval;
+
+	/* Copy the data */
+	buf = (*n)->data;
+	for(i = size - 1, j = 0; i >= 0; i--, j++)
+		buf[j / 4] |= ((_u32)str[i] << ((j % 4) * 8));
+	return RSA_NO_ERR;
+}
+
+/*
+ * Mpi to mpi copy
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @dest: destination mpi
+ * @src:  source mpi
+ */
+static inline _err rsa_mpi_copy(mpi **	dest, mpi * src)
+{
+	_i32 i, s;
+	_u32 * destbuf, * srcbuf;
+	_err retval;
+
+	retval = rsa_mpi_resize(dest, src->size, false);
+	if(retval < 0)
+		return retval;
+
+	(*dest)->sign = src->sign;
+	destbuf = (*dest)->data;
+	srcbuf = src->data;
+	for(i = 0, s = src->size; i < s; i++)
+		destbuf[i] = srcbuf[i];
+	return RSA_NO_ERR;
+}
+
+/*
+ * Print the value of an mpi
+ *
+ * @n:	 pointer to the mpi
+ * @how:  true to print canonicalized
+ */
+static void rsa_mpi_print(mpi * n, _u8 how)
+{
+#ifdef RSA_HAVE_MPI_PRINT
+	_i32 i, j;
+	_u32 limb;
+	_u8 byte, started = false;
+
+	rsa_echo("Mpi at 0x%x, %d limbs in size, %d limbs allocated, value = ",
+		 (_u32)n, n->size, n->limbs);
+
+	/* If the mpi is merely zero */
+	if(rsa_mpi_iszero(n) && how) {
+		printk("0\n");
+		return;
+	}
+
+	/* Print the sign */
+	printk("%s", (n->sign)? "-": " ");
+
+	/* Print the hex value */
+	for(i = n->size - 1; i >= 0; i--) {
+		limb = n->data[i];
+
+		/* Ignore leading zero limbs if canonicalized printing is selected */
+		if(!limb && !started && how)
+			continue;
+
+		/* Print each limb as though each of its nibbles was a character from
+		 * the set '0' to '9' and 'a' to 'f'
+		 */
+		for(j = 28; j >= 0; j -= 4) {
+			byte = (_u8)((limb >> j) & 0x0F);
+
+			/* Ignore leading zero bytes if canonicalized printing is selected */
+			if(!byte && !started && how)
+				continue;
+
+			started = true;
+			byte += (byte <= 0x09)? '0': 'a' - 0x0A;
+			printk("%c", byte);
+		}
+	}
+
+	printk("\n");
+#endif
+}
+
+/*
+ * Check if an mpi is zero
+ *
+ * Returns true if it is, false otherwise
+ *
+ * @n: the mpi
+ */
+static inline _u8 rsa_mpi_iszero(mpi * n)
+{
+	_i32 i, s;
+	_u32 * buf;
+
+	s = n->size;
+	buf = n->data;
+	for(i = 0; i < s; i++)
+		if(buf[i])
+			return false;
+	return true;
+}
+
+/*
+ * Compare two mpis
+ *
+ * Returns -1 if a < b, 1 if b < a, 0 otherwise
+ *
+ * @a: the left operand
+ * @b: the right operand
+ */
+static _i8 rsa_mpi_compare(mpi * a, mpi * b)
+{
+	_i32 i, j;
+	_u32 * abuf, * bbuf;
+
+	/* Compare the two mpis based on sign */
+	if(a->sign != b->sign)
+		return (a->sign)? -1: 1;
+
+	/* Compare the two mpis based on their size */
+	if(a->size > b->size && rsa_mpi_clz(a) < (a->size - b->size) * 32)
+		return 1;
+	else if(a->size > b->size)
+		j = b->size;
+	else if(b->size > a->size && rsa_mpi_clz(b) < (b->size - a->size) * 32)
+		return -1;
+	else
+		j = a->size;
+
+	/* Compare the two mpis based on their hex values */
+	abuf = a->data;
+	bbuf = b->data;
+	for(i = j - 1; i >= 0; i--)
+		if(abuf[i] > bbuf[i])
+			return 1;
+		else if(abuf[i] < bbuf[i])
+			return -1;
+
+	return 0;
+}
+
+/*
+ * Count leading zeroes
+ *
+ * Returns the number of leading zero bits
+ *
+ * @n: the mpi
+ */
+static _u64 rsa_mpi_clz( mpi * n)
+{
+	_u64 retval = 0;
+	_i32 i;
+	_u32 limb;
+
+	for(i = n->size - 1; i >= 0; i--) {
+		limb = n->data[i];
+
+		if(!limb) {
+			retval += 32;
+			continue;
+		}
+
+		while(!(limb & 0x80000000)) {
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
+ * Complement an mpi (either 1's or 2's complement) ignoring overflow
+ *
+ * @n: 	  the mpi
+ * @which: true to compute 2's complement
+ */
+static inline void rsa_mpi_complement(mpi * n, _u8 which)
+{
+	_i32 i, s;
+	_u32 * buf;
+
+	s = n->size;
+	buf = n->data;
+	for(i = 0; i < s; i++)
+		buf[i] ^= RSA_MAX_U32;
+	if(!which)
+		return;
+
+	/* Add 1 using the addition carry */
+	for(i = 0; i < s; i++) {
+		buf[i] += 1;
+		if(buf[i])
+			break;
+	}
+}
+
+/*
+ * Ignore any leading zero limbs of an mpi
+ *
+ * @n: the mpi
+ */
+static inline void rsa_mpi_canonicalize(mpi * n)
+{
+	_i32 i;
+	_u32 * buf = n->data;
+
+	for(i = n->size - 1; i >= 0; i--)
+		if(!buf[i] && n->size > 1)
+			n->size--;
+		else
+			break;
+}
+
+/*
+ * Shift a number both directions
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @n: 	  pointer pointer to the allocated mpi
+ * @bits: shift to the right if positive, otherwise shift to the left
+ */
+static _err rsa_mpi_shift(mpi ** n, _i64 bits)
+{
+	_i32 i, distance, size, lz;
+	_u32 * buf;
+	mpi * handle;
+	_err retval;
+
+	handle = *n;
+	if(!bits || rsa_mpi_iszero(handle))
+		return RSA_NO_ERR;
+
+	/* Shifting to the right, no resize needed */
+	if(bits > 0) {
+		/* Drop off one limb for each 32 bit shift */
+		distance = bits / 32;
+		size = handle->size;
+		buf = handle->data;
+		for(i = 0; i < size; i++)
+			buf[i] = (i + distance >= size)? 0x00: buf[i + distance];
+
+		/* Shift the remaining 'bits' mod 32 */
+		bits = bits % 32;
+		if(bits) {
+			size -= distance;
+			distance = 32 - bits;
+			for(i = 0; i < size; i++) {
+				buf[i] = buf[i] >> bits;
+				if(i < size - 1)
+					buf[i] |=  buf[i + 1] << distance;
+			}
+		}
+
+		rsa_mpi_canonicalize(handle);
+		return RSA_NO_ERR;
+	}
+
+	bits = -bits;
+	lz = rsa_mpi_clz(handle) + (handle->limbs - handle->size) * 32;
+
+	/* Shifting to the left
+	 * Reallocation is needed when the leading zeroes are less than the shift
+	 * distance
+	 */
+	if(lz < bits) {
+		/* Compute the size of the reallocation */
+		size = bits - lz;
+		size = (size / 32) + (size % 32 != 0);
+		retval = rsa_mpi_resize(n, handle->limbs + size, true);
+		if(retval < 0)
+			return retval;
+		handle = *n;
+	}
+	else {
+		size = bits - rsa_mpi_clz(handle);
+		handle->size += ((size / 32) + (size % 32 != 0));
+	}
+
+	buf = handle->data;
+	distance = bits / 32;
+	/* Shift data 1 byte to the left for each 32 bit shift */
+	if(distance) {
+		/* Shift bytes */
+		for(i = handle->size - distance - 1; i >= 0; i--)
+			buf[i + distance] = buf[i];
+		/* Zero the shifted in bytes */
+		for(i = 0; i < distance; i++)
+			buf[i] = 0;
+	}
+
+	/* Shift the remaining 'bits' mod 32 */
+	bits = bits % 32;
+	distance = 32 - bits;
+	if(bits)
+		for(i = handle->size - 1; i >= 0; i--) {
+			buf[i] = buf[i] << bits;
+			if(i > 0)
+				buf[i] |= (buf[i - 1] >> distance);
+		}
+
+	return RSA_NO_ERR;
+}
+
+/*
+ * Multiply two mpis
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @res: pointer pointer to the result
+ * @a:	 left operand
+ * @b:   right operand
+ */
+static _err rsa_mpi_multiply(mpi ** res, mpi *	a, mpi * b)
+{
+	_i32 i, j, size, asize, bsize;
+	_u32 * buf, * abuf, * bbuf;
+	_u64 tmp;
+	mpi * handle;
+	_err retval;
+
+	asize = a->size;
+	bsize = b->size;
+	size = asize + bsize;
+	retval = rsa_mpi_resize(res, size, false);
+	if(retval < 0)
+		return retval;
+
+	handle = *res;
+	handle->sign = a->sign ^ b->sign;
+
+	buf = handle->data;
+	abuf = a->data;
+	bbuf = b->data;
+	/* Make the multiplication, using the standard algorithm */
+	for(i = 0; i < bsize; i++) {
+		tmp = 0;
+		for(j = 0; j < asize; j++)
+			buf[i + j] = tmp = buf[i + j] + (abuf[j] * (_u64)bbuf[i]) + (tmp >> 32);
+		buf[i + asize] = tmp >> 32;
+	}
+
+	rsa_mpi_canonicalize(handle);
+	return RSA_NO_ERR;
+}
+
+/*
+ * Subtract two mpis
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @res: pointer pointer to the result
+ * @a:	 left operand
+ * @b:   right operand
+ */
+static _err rsa_mpi_subtract(mpi ** res, mpi * a, mpi * b)
+{
+	_u32 * buf, * abuf, * bbuf;
+	_i32 i, size;
+	mpi * handle;
+	_err retval;
+
+	size = rsa_max(a->size, b->size) + (a->sign != b->sign);
+	if((retval = rsa_mpi_resize(res, size, true)) < 0 ||
+	   (retval = rsa_mpi_resize(&a, size, true)) < 0  ||
+	   (retval = rsa_mpi_resize(&b, size, true)) < 0)
+		return retval;
+
+	handle = *res;
+	buf = handle->data;
+	abuf = a->data;
+	bbuf = b->data;
+
+	/* If the operands are both negative or positive we perform subtraction */
+	if(a->sign == b->sign) {
+		 _u8 borrow = false;
+		 _u32 limb;
+
+		for(i = 0; i < size; i++) {
+			limb = borrow + bbuf[i];
+			buf[i] = abuf[i] - limb;
+			borrow = (abuf[i] < limb);
+		}
+
+		handle->sign = (borrow)? !b->sign: b->sign;
+		if(borrow)
+			rsa_mpi_complement(handle, true);
+	}
+	/* If the operands are not signed in the same way we perform addition */
+	else {
+		 _u8 carry = false;
+		 _u64 sum;
+
+		for(i = 0; i < size; i++) {
+			buf[i] = sum = abuf[i] + bbuf[i] + carry;
+			carry = (sum > RSA_MAX_U32);
+		}
+
+		handle->sign = a->sign;
+	}
+
+	rsa_mpi_canonicalize(handle);
+	rsa_mpi_canonicalize(a);
+	rsa_mpi_canonicalize(b);
+	return RSA_NO_ERR;
+}
+
+/*
+ * Compute the remainder of a/b (aka a mod b)
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @res: pointer pointer to the result
+ * @a:	 left operand
+ * @b:   right operand
+ */
+static _err rsa_mpi_remainder(mpi ** res, mpi * a, mpi * b)
+{
+	_i32 i, k;
+	_err retval;
+
+	/* Because b operand will be shifted we need to have a copy of it in
+	 * order not to mess with the prototype b
+	 */
+	if((retval = rsa_mpi_copy(&aux[0], a)) < 0 ||
+	   (retval = rsa_mpi_copy(&aux[1], b)) < 0)
+		return retval;
+
+	k = (aux[0]->size - aux[1]->size) * 32;
+	k += (rsa_mpi_clz(aux[1]) - rsa_mpi_clz(aux[0]));
+
+	/* Align the divisor to the divident */
+	retval = rsa_mpi_shift(&aux[1], -k);
+	if(retval < 0)
+		return retval;
+
+	for(i = 0; i <= k; i++) {
+		retval = rsa_mpi_subtract(res, aux[0], aux[1]);
+		if(retval < 0)
+			return retval;
+
+		if(!(*res)->sign) {
+			retval = rsa_mpi_copy(&aux[0], (*res));
+			if(retval < 0)
+				return retval;
+		}
+
+		retval = rsa_mpi_shift(&aux[1], 1);
+		if(retval < 0)
+			return retval;
+	}
+
+	rsa_mpi_canonicalize(aux[0]);
+	return rsa_mpi_copy(res, aux[0]);
+}
+
+/*
+ * Compute the first 32 bits of the modular inverse of an mpi
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @n: the mpi
+ */
+static _u32 rsa_modinv(mpi * n)
+{
+	_u32 i, x, y, tmp, pow1;
+
+	pow1 = y = 1;
+	x = n->data[0];
+
+	for(i = 2; i <= RSA_RADIX_BITS; i++) {
+		pow1 = pow1 << 1;
+		tmp = ((_i64)x * y) & (RSA_MAX_U32 >> (32 - i));
+		if(pow1 < tmp)
+			y += pow1;
+	}
+
+	y = (y ^ RSA_MAX_U32) + 1;
+	return y;
+}
+
+/*
+ * Compute the montgomery product (res = a * b mod n) using single precision
+ * modulus modular inverse
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @res: pointer pointer to the result
+ * @a:	 left operand
+ * @b:   right operand
+ * @n:	 divisor
+ */
+static _err rsa_monpro(mpi ** res, mpi * a, mpi * b, mpi * n)
+{
+	_i32 nsize, i, j, k;
+	_u32 * buf, * nbuf, * tmp, m;
+	_u64 product = 0;
+	_err retval;
+
+	nsize = n->size;
+	k = nsize << 1;
+	retval = rsa_mpi_multiply(&aux[2], a, b);
+	if(retval < 0)
+		return retval;
+	retval = rsa_mpi_resize(&aux[2], rsa_max(aux[2]->size, k), true);
+	if(retval < 0)
+		return retval;
+
+	tmp = buf = aux[2]->data;
+	nbuf = n->data;
+
+	for(i = 0; i < nsize; i++, tmp++) {
+		m = buf[i] * modinv;
+		product = 0;
+
+		for(j = 0; j < nsize; j++)
+			tmp[j] = product = tmp[j] + (m * (_u64)nbuf[j]) + (product >> 32);
+
+		for(j = nsize + i; j < k; j++)
+			buf[j] = product = buf[j] + (product >> 32);
+	}
+
+	retval = rsa_mpi_resize(&aux[2], aux[2]->size + 1, true);
+	if(retval < 0)
+		return retval;
+	aux[2]->data[aux[2]->size - 1] = product >> 32;
+	retval = rsa_mpi_shift(&aux[2], nsize * 32);
+	if(retval < 0)
+		return retval;
+
+	if(rsa_mpi_compare(aux[2], n) >= 0) {
+		if((retval = rsa_mpi_subtract(&aux[3], aux[2], n)) < 0 ||
+		   (retval = rsa_mpi_copy(res, aux[3])) < 0)
+			return retval;
+	}
+	else if((retval = rsa_mpi_copy(res, aux[2])) < 0)
+		return retval;
+	return RSA_NO_ERR;
+}
+
+/*
+ * Computes the RSA of m, a.k.a res = m ^ e mod n
+ *
+ * Returns 0 on success or a negative value indicating error
+ *
+ * @res: pointer pointer to the result
+ * @m:	 base
+ * @e:   exponent
+ * @n:	 divisor
+ */
+static _err rsa_modexp(mpi ** res, mpi * m, mpi * e, mpi * n)
+{
+	_i32 i, j;
+	_u32 limb;
+	_u8 started = false;
+	_err retval;
+
+	if(m->size != n->size || rsa_mpi_compare(m, n) > 0)
+		return RSA_ERR_INVARG;
+
+	modinv = rsa_modinv(n);
+
+	/* Compute m * r mod n where r is 2 ^ k and n is the k-bit modulus
+	 * The resulting m' is stored in aux[4]
+	 */
+	if((retval = rsa_mpi_copy(&aux[5], m)) < 0)
+		return retval;
+	if((retval = rsa_mpi_shift(&aux[5], -(n->size * 32))) < 0)
+		return retval;
+	if((retval = rsa_mpi_remainder(&aux[4], aux[5], n)) < 0)
+		return retval;
+
+	/* Compute r mod n where r is 2 ^ k and n is the k-bit modulus
+	 * The resulting x' is stored in aux[7]
+	 */
+	if((retval = rsa_mpi_set(&aux[5], "\x01", 1)) < 0)
+		return retval;
+	if((retval = rsa_mpi_shift(&aux[5], -(n->size * 32))) < 0)
+		return retval;
+	if((retval = rsa_mpi_remainder(&aux[7], aux[5], n)) < 0)
+		return retval;
+
+	/* Canonicalize the exponent and compute the modular exponentiation.
+	 * For each limb of the exponent perform left to right binary exponentiation
+	 */
+	rsa_mpi_canonicalize(e);
+	for(i = e->size - 1; i >= 0; i--) {
+		/* Take a limb of the exponent */
+		limb = e->data[i];
+
+		/* For each of its bits */
+		for(j = 0; j < 32; j++) {
+			/* While the exponent has non significant zeroes,
+			 * shift it to the left
+			 */
+			if(!(limb & 0x80000000) && !started) {
+				limb = limb << 1;
+				continue;
+			}
+
+			started = true;
+			/* Compute x' * x' mod n */
+			retval = rsa_monpro(&aux[5], aux[7], aux[7], n);
+			if(retval < 0)
+				return retval;
+
+			if(limb & 0x80000000) {
+				/* Compute x' = m' * x' mod n */
+				retval = rsa_monpro(&aux[7], aux[4], aux[5], n);
+				if(retval < 0)
+					return retval;
+			}
+			else if((retval = rsa_mpi_copy(&aux[7], aux[5])) < 0)
+				return retval;
+
+			limb = limb << 1;
+		}
+	}
+
+	/* Compute res = x' mod n */
+	retval = rsa_mpi_set(&aux[6], "\x01", 1);
+	if(retval < 0)
+		return retval;
+	return rsa_monpro(res, aux[7], aux[6], n);
+}
+
+module_init(rsa_load);
+module_exit(rsa_unload);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tasos Parisinos @ Sciensis Advanced Technology Systems");
+MODULE_DESCRIPTION("RSA cipher algorithm implementation");
diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff linux-2.6.20.1/crypto/rsa.h linux-2.6.20.1-vanilla/crypto/rsa.h
--- linux-2.6.20.1/crypto/rsa.h	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.20.1-vanilla/crypto/rsa.h	2007-03-19 16:29:34.000000000 +0200
@@ -0,0 +1,86 @@
+#ifndef _KM_RSA_H_
+#define _KM_RSA_H_
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <config/rsa/auxcount.h>
+#include <config/rsa/auxsize.h>
+
+#define RSA_AUX_COUNT 		CONFIG_RSA_AUXCOUNT
+#define RSA_AUX_SIZE 		CONFIG_RSA_AUXSIZE
+#define RSA_MAX_U32		0xFFFFFFFF
+#define RSA_RADIX_BITS		0x20
+#define RSA_LOGLEVEL		KERN_ALERT
+#define RSA_NO_ERR		0
+#define RSA_ERR_INVARG		-1
+#define RSA_ERR_NOMEM		-2
+
+#define true			0x01
+#define false			0x00
+
+#ifdef RSA_DEBUG
+	#define rsa_debug(fmt, args...) 			   \
+	{ 							   \
+		if(printk_ratelimit()) 				   \
+			printk(RSA_LOGLEVEL "rsa: " fmt, ## args); \
+	}
+#else
+	#define rsa_debug(fmt, args...)
+#endif
+
+#define rsa_echo(fmt, args...) printk(RSA_LOGLEVEL "rsa: " fmt, ## args)
+
+#if RSA_AUX_COUNT < 8
+	#error "Rsa module needs at least 8 auxilliary mpis"
+#endif
+
+typedef signed char 		_i8;
+typedef signed short		_i16;
+typedef signed int 		_i32;
+typedef signed long long	_i64;
+typedef unsigned char 		_u8;
+typedef unsigned short		_u16;
+typedef unsigned int 		_u32;
+typedef unsigned long long	_u64;
+typedef signed int		_err;
+
+/* Multi-precision integer */
+typedef struct mpi {
+	_u32	* data;	/* _u32 array holding the number absolute value */
+	_u8	sign;	/* 1 for negative, 0 for positive */
+	_i32	size;	/* Significant number limbs */
+	_i32	limbs;	/* Allocated limbs (sizeof data) */
+} mpi;
+
+/* Module loading/unloading functions */
+static _err __init	rsa_load(void);
+static void __exit	rsa_unload(void);
+
+/* Mpi utility functions */
+static _err		rsa_mpi_alloc(mpi **, _i32);
+static void 		rsa_mpi_free(mpi *);
+static _err 		rsa_mpi_init(mpi **, _u8 *, _u32, _u32);
+static _err 		rsa_mpi_resize(mpi **, _i32, _u8);
+static _err 		rsa_mpi_set(mpi **, _u8 *, _u32);
+static inline _err 	rsa_mpi_copy(mpi **, mpi *);
+static void 		rsa_mpi_print(mpi *, _u8);
+
+/* Mpi comparing and misc functions */
+static inline _u8 	rsa_mpi_iszero(mpi *);
+static _i8 		rsa_mpi_compare(mpi *, mpi *);
+static _u64	 	rsa_mpi_clz(mpi *);
+static inline void 	rsa_mpi_complement(mpi *, _u8);
+static inline void 	rsa_mpi_canonicalize(mpi *);
+
+/* Mpi arithmetic functions */
+static _err		rsa_mpi_shift(mpi **, _i64);
+static _err 		rsa_mpi_multiply(mpi **, mpi *, mpi *);
+static _err 		rsa_mpi_subtract(mpi **, mpi *, mpi *);
+static _err 		rsa_mpi_remainder(mpi **, mpi *, mpi *);
+
+/* Rsa functions */
+static _u32		rsa_modinv(mpi *);
+static _err 		rsa_monpro(mpi **, mpi *, mpi *, mpi *);
+static _err 		rsa_modexp(mpi **, mpi *, mpi *, mpi *);
+
+#endif /* _KM_RSA_H_ */
