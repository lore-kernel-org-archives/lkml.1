Return-Path: <linux-kernel-owner+w=401wt.eu-S965369AbXDBKS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbXDBKS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965373AbXDBKS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:18:26 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:27082 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965369AbXDBKSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:18:24 -0400
X-Greylist: delayed 1566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 06:18:23 EDT
Message-ID: <4610D25F.7080005@ceid.upatras.gr>
Date: Mon, 02 Apr 2007 12:52:31 +0300
From: Tasos Parisinos <parisino@ceid.upatras.gr>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, indan@nul.nu
Subject: [PATCH resend][CRYPTO]: RSA algorithm patch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tasos Parisinos <t.parisinos@sciensis.com>

This patch adds module rsa.ko in the kernel (built-in or as a kernel module) 
and offers an API to do fast modular exponentiation, using the Montgomery 
algorithm, thus the exponentiation is not generic but can be used only when
the modulus is odd, such as RSA public/private key pairs. This module is the
computational core (using multiple precision integer arithmetics) and does not
provide any means to do key management, implement padding schemas e.t.c. so the
calling code should implement all those as needed. 

Signed-off-by: Tasos Parisinos <t.parisinos@sciensis.com>

---
This module exports some symbols, through its header file include/crypto/rsa.h 
and does not use the glue code of include/crypto.h. This decision was taken 
because this glue code is not really suitable for asymmetric cryptography in my
opinion. First of all RSA is not a block cipher but a stream cipher. It does not
only have a key but also an exponent that are two different entities. And the most
important is that the key size can be of any length. So it is not practical -yet- 
to register the algorithm with the crypto api using a struct such as crypto_alg. 
So another module can include the file include/crypto/rsa.h and call its interface 
functions to create the operands for the modular exponentiation, execute the 
exponentiation and use the results. All these functions and structures are 
well documented kernel-doc style. Also in this way the calling in-kernel code can
implement key management, padding schemas, hashing e.t.c as needed. 

diff -uprN -X linux/Documentation/dontdiff \
linux.orig/crypto/Kconfig linux/crypto/Kconfig
--- linux.orig/crypto/Kconfig 2007-03-26 01:56:23.000000000 +0300
+++ linux/crypto/Kconfig 2007-04-02 11:17:24.000000000 +0300
@@ -440,6 +440,31 @@ config CRYPTO_CAMELLIA
 	  See also:
 	  <https://info.isl.ntt.co.jp/crypt/eng/camellia/index_s.html>

+config CRYPTO_RSA
+	tristate "RSA asymmetric cipher algorithm"
+	help
+	  RSA asymmetric cipher algorithm.
+
+	  This module uses the montgomery algorithm to compute fast modular
+	  exponentiation. All operands of the modular exponentiation can be
+	  of any bit length, thus you can use any public and/or private key
+	  lengths.
+
+	  If it is selected it will add approximately 8K to the kernel size.
+	  Select M to build this as a module. The module will be called rsa.
+
+config RSA_AUX_OPERAND_SIZE
+	int "Size of the preallocated auxilliary operands"
+	default "128"
+	depends on CRYPTO_RSA
+	help
+	  The rsa module needs some preallocated space to avoid computation-time
+	  allocations. The 'rsa_op' is the struct used by the rsa module to hold
+	  a multi-precision integer operand. This struct maps such an integer on
+	  multiple 32bit limbs. Here you select the size (in 32bit limbs) of the
+	  preallocated auxilliary operands. This size should be close to the key
+	  sizes that are usually used.
+
 config CRYPTO_TEST
 	tristate "Testing module"
 	depends on m
diff -uprN -X linux/Documentation/dontdiff \
linux.orig/crypto/Makefile linux/crypto/Makefile
--- linux.orig/crypto/Makefile 2007-03-26 01:56:23.000000000 +0300
+++ linux/crypto/Makefile 2007-04-02 11:17:24.000000000 +0300
@@ -46,5 +46,6 @@ obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
+obj-$(CONFIG_CRYPTO_RSA) += rsa.o

 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
diff -uprN -X linux/Documentation/dontdiff \
linux.orig/crypto/rsa.c linux/crypto/rsa.c
--- linux.orig/crypto/rsa.c 1970-01-01 02:00:00.000000000 +0200
+++ linux/crypto/rsa.c 2007-04-02 11:52:28.000000000 +0300
@@ -0,0 +1,770 @@
+/*
+ * Cryptographic API
+ *
+ * RSA cipher algorithm implementation
+ *
+ * Copyright (c) 2007 Tasos Parisinos <t.parisinos@sciensis.com>
+ * Copyright (c) 2007 Sciensis Advanced Technology Systems
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
+#include <crypto/rsa.h>
+
+#define AUX_OPERAND_COUNT	4
+#define U32_MAX		0xFFFFFFFF
+#define U32_MSB_SET		0x80000000
+#define LEFTOP			aux[0]
+#define RIGHTOP		aux[1]
+
+static int rsa_op_resize(struct rsa_op **n, int size)
+{
+	int retval = 0;
+	struct rsa_op *handle = *n;
+
+	/* If there is no allocated rsa_op passed in, allocate one */
+	if (!handle)
+		return rsa_op_alloc(n, size);
+
+	/* If the rsa_op passed in has the available limbs */
+	if (handle->limbs >= size) {
+		/* Zero the xtra limbs */
+		if (size < handle->size)
+			memset(handle->data + size, 0,
+			       (handle->size - size) * sizeof(u32));
+		handle->size = size;
+	}
+	else {
+		struct rsa_op *tmp = NULL;
+
+		retval = rsa_op_alloc(&tmp, size);
+		if (retval < 0)
+			return retval;
+
+		/* Copy the original data */
+		memcpy(tmp->data, handle->data, handle->size * sizeof(u32));
+		tmp->sign = handle->sign;
+		rsa_op_free(*n);
+		*n = tmp;
+	}
+
+	return retval;
+}
+
+/* Count the leading zeroes of an operand */
+static u32 rsa_op_clz(struct rsa_op *n)
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
+		while (!(limb & U32_MSB_SET)) {
+			retval++;
+			limb = limb << 1;
+		}
+		break;
+	}
+
+	return retval;
+}
+
+static char rsa_op_compare(struct rsa_op *l, struct rsa_op *r)
+{
+	int i;
+	u32 *lbuf, *rbuf;
+
+	/* Compare the two operands based on sign */
+	if (l->sign != r->sign)
+		return (l->sign)? -1 : 1;
+
+	/* Compare the two operands based on their size */
+	if (l->size > r->size && rsa_op_clz(l) < (l->size - r->size) * 32)
+		return 1;
+	else if (r->size > l->size && rsa_op_clz(r) < (r->size - l->size) * 32)
+		return -1;
+
+	/* Compare the two operands based on their hex values */
+	lbuf = l->data;
+	rbuf = r->data;
+	for (i = min(l->size, r->size) - 1; i >= 0; i--)
+		if (lbuf[i] > rbuf[i])
+			return 1;
+		else if (lbuf[i] < rbuf[i])
+			return -1;
+	return 0;
+}
+
+static void rsa_op_complement(struct rsa_op *n)
+{
+	int i, s;
+	u32 *buf;
+
+	s = n->size;
+	buf = n->data;
+	for (i = 0; i < s; i++)
+		buf[i] = ~buf[i];
+
+	/* Add 1 using the addition carry */
+	for (i = 0; i < s; i++) {
+		buf[i] += 1;
+		if (buf[i])
+			break;
+	}
+}
+
+static void rsa_op_canonicalize(struct rsa_op *n)
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
+static int rsa_op_shift(struct rsa_op **n, int bits)
+{
+	int i, distance, size, lz, retval;
+	u32 *buf;
+	struct rsa_op *handle;
+
+	if (!bits)
+		return 0;
+	handle = *n;
+
+	/* Shifting to the right, no resize needed */
+	if (bits > 0) {
+		/* Drop off one limb for each 32 bit shift */
+		distance = bits / 32;
+		size = handle->size;
+		buf = handle->data;
+		for (i = 0; i < size; i++)
+			buf[i] = (i + distance >= size)? 0 : buf[i + distance];
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
+		rsa_op_canonicalize(handle);
+		return 0;
+	}
+
+	bits = -bits;
+	lz = rsa_op_clz(handle) + (handle->limbs - handle->size) * 32;
+
+	/*
+	 * Shifting to the left.
+	 * Reallocation is needed when the leading zeroes are less than
+	 * the shift distance
+	 */
+	if (lz < bits) {
+		/* Compute the size of the reallocation */
+		size = (bits - lz + 31) / 32;
+		retval = rsa_op_resize(n, handle->limbs + size);
+		if (retval < 0)
+			return retval;
+		handle = *n;
+	}
+	else
+		handle->size += ((bits - rsa_op_clz(handle) + 31) / 32);
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
+		memset(handle->data, 0, distance * sizeof(u32));
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
+/*
+ * Compute the modular inverse of an operand using only its 32 least
+ * significant bits (single presicion modular inverse)
+ */
+static u32 rsa_op_modinv32(struct rsa_op *n)
+{
+	u32 i, x, y, tmp, pow1;
+
+	pow1 = y = 1;
+	x = n->data[0];
+
+	for (i = 2; i <= 32; i++) {
+		pow1 = pow1 << 1;
+
+		/*
+		 * This is the computation of x * y mod r, only r is a power
+		 * of 2, specifically 2^i so the modulo is computed by
+		 * keeping the least i bits of x * y.
+		 */
+		tmp = ((u64)x * y) & (U32_MAX >> (32 - i));
+		if (pow1 < tmp)
+			y += pow1;
+	}
+
+	y = ~y + 1;
+	return y;
+}
+
+static int rsa_product(struct rsa_op **res, struct rsa_op *l, struct rsa_op *r,
+		       struct rsa_op **aux)
+{
+	int i, j, ls, rs, retval;
+	u32 *buf, *lbuf, *rbuf;
+	u64 tmp;
+	struct rsa_op *handle;
+
+	retval = rsa_op_copy(&LEFTOP, l);
+	if (retval < 0)
+		return retval;
+
+	retval = rsa_op_copy(&RIGHTOP, r);
+	if (retval < 0)
+		return retval;
+
+	ls = l->size;
+	rs = r->size;
+	retval = rsa_op_resize(res, ls + rs);
+	if (retval < 0)
+		return retval;
+
+	handle = *res;
+	memset(handle->data, 0, handle->size * sizeof(u32));
+	handle->sign = LEFTOP->sign ^ RIGHTOP->sign;
+
+	buf = handle->data;
+	lbuf = LEFTOP->data;
+	rbuf = RIGHTOP->data;
+
+	/* Make the multiplication, using the standard algorithm */
+	for (i = 0; i < rs; i++) {
+		tmp = 0;
+		for (j = 0; j < ls; j++) {
+			tmp = buf[i + j] + (lbuf[j] * (u64)rbuf[i]) +
+			      (tmp >> 32);
+			buf[i + j] = (u32)tmp;
+		}
+
+		buf[i + ls] = tmp >> 32;
+	}
+
+	rsa_op_canonicalize(handle);
+	return 0;
+}
+
+static int rsa_difference(struct rsa_op **res, struct rsa_op *l,
+			  struct rsa_op *r, struct rsa_op **aux)
+{
+	int i, size, retval;
+	u32 *buf, *lbuf, *rbuf;
+	struct rsa_op *handle;
+
+	retval = rsa_op_copy(&LEFTOP, l);
+	if (retval < 0)
+		return retval;
+
+	retval = rsa_op_copy(&RIGHTOP, r);
+	if (retval < 0)
+		return retval;
+
+	size = max(l->size, r->size) + (l->sign != r->sign);
+	retval = rsa_op_resize(res, size);
+	if (retval < 0)
+		return retval;
+
+	retval = rsa_op_resize(&LEFTOP, size);
+	if (retval < 0)
+		return retval;
+
+	retval = rsa_op_resize(&RIGHTOP, size);
+	if (retval < 0)
+		return retval;
+
+	handle = *res;
+	buf = handle->data;
+	lbuf = LEFTOP->data;
+	rbuf = RIGHTOP->data;
+
+	/* If the operands are both negative or positive perform subtraction */
+	if (LEFTOP->sign == RIGHTOP->sign) {
+		bool borrow = false;
+		u32 limb;
+
+		for (i = 0; i < size; i++) {
+			limb = borrow + rbuf[i];
+			buf[i] = lbuf[i] - limb;
+			borrow = (lbuf[i] < limb);
+		}
+
+		if (borrow) {
+			rsa_op_complement(handle);
+			handle->sign = !RIGHTOP->sign;
+		}
+		else
+			handle->sign = RIGHTOP->sign;
+	}
+	/* If the operands are not signed in the same way perform addition */
+	else {
+		bool carry = false;
+		u64 sum;
+
+		for (i = 0; i < size; i++) {
+			sum = lbuf[i] + rbuf[i] + carry;
+			carry = (sum > U32_MAX);
+			buf[i] = (u32)sum;
+		}
+
+		handle->sign = LEFTOP->sign;
+	}
+
+	rsa_op_canonicalize(handle);
+	return 0;
+}
+
+static int rsa_remainder(struct rsa_op **res, struct rsa_op *l,
+			 struct rsa_op *r, struct rsa_op **aux)
+{
+	int i, k, retval;
+
+	retval = rsa_op_copy(&LEFTOP, l);
+	if (retval < 0)
+		return retval;
+
+	retval = rsa_op_copy(&RIGHTOP, r);
+	if (retval < 0)
+		return retval;
+
+	k = (LEFTOP->size - RIGHTOP->size) * 32;
+	k -= (rsa_op_clz(LEFTOP) - rsa_op_clz(RIGHTOP));
+
+	/* Align the divisor to the dividend */
+	retval = rsa_op_shift(&RIGHTOP, -k);
+	if (retval < 0)
+		return retval;
+
+	for (i = 0; i <= k; i++) {
+		retval = rsa_difference(res, LEFTOP, RIGHTOP, aux + 2);
+		if (retval < 0)
+			return retval;
+
+		if (!(*res)->sign) {
+			retval = rsa_op_copy(&LEFTOP, *res);
+			if (retval < 0)
+				return retval;
+		}
+
+		retval = rsa_op_shift(&RIGHTOP, 1);
+		if (retval < 0)
+			return retval;
+	}
+
+	rsa_op_canonicalize(LEFTOP);
+	return rsa_op_copy(res, LEFTOP);
+}
+
+/* Compute the montgomery product of two numbers */
+static int rsa_mproduct(struct rsa_op **res, struct rsa_op *l, struct rsa_op *r,
+			struct rsa_op *n, u32 modinv, struct rsa_op **aux)
+{
+	int nsize, i, j, k, retval;
+	u32 *buf, *nbuf, *tmp, m;
+	u64 product = 0;
+
+	nsize = n->size;
+	k = nsize << 1;
+	retval = rsa_product(res, l, r, aux);
+	if (retval < 0)
+		return retval;
+
+	retval = rsa_op_resize(res, max((*res)->size, k));
+	if (retval < 0)
+		return retval;
+
+	tmp = buf = (*res)->data;
+	nbuf = n->data;
+
+	for (i = 0; i < nsize; i++, tmp++) {
+		m = buf[i] * modinv;
+		product = 0;
+
+		for (j = 0; j < nsize; j++) {
+			product = tmp[j] + (m * (u64)nbuf[j]) + (product >> 32);
+			tmp[j] = (u32)product;
+		}
+
+		for (j = nsize + i; j < k; j++) {
+			product = buf[j] + (product >> 32);
+			buf[j] = (u32)product;
+		}
+	}
+
+	retval = rsa_op_resize(res, (*res)->size + 1);
+	if (retval < 0)
+		return retval;
+
+	(*res)->data[(*res)->size - 1] = product >> 32;
+	retval = rsa_op_shift(res, nsize * 32);
+	if (retval < 0)
+		return retval;
+
+	if (rsa_op_compare(*res, n) >= 0) {
+		retval = rsa_difference(res, *res, n, aux);
+		if (retval < 0)
+			return retval;
+	}
+	return 0;
+}
+
+/**
+ * rsa_op_alloc - allocate an rsa_op
+ * @n: pointer pointer to the allocated rsa_op
+ * @limbs: number of allocated limbs (32 bit digits)
+ *
+ * The allocated rsa_op will be zeroed and not canonicalized
+ */
+int rsa_op_alloc(struct rsa_op **n, int limbs)
+{
+	struct rsa_op *handle;
+
+	*n = NULL;
+	if (!limbs)
+		return -EINVAL;
+
+	/* Allocate space for the rsa_op */
+	handle = kmalloc(sizeof(struct rsa_op), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	/* Allocate space for its data */
+	handle->data = kzalloc(limbs * sizeof(u32), GFP_KERNEL);
+	if (!handle->data) {
+		kfree(handle);
+		return -ENOMEM;
+	}
+
+	handle->sign = 0;
+	handle->size = handle->limbs = limbs;
+	*n = handle;
+	return 0;
+}
+
+/**
+ * rsa_op_free - free the resources held by an rsa_op
+ * @n: pointer to the rsa_op to be freed
+ */
+void rsa_op_free(struct rsa_op *n)
+{
+	if (!n)
+		return;
+	kfree(n->data);
+	kfree(n);
+}
+
+/**
+ * rsa_op_init - initialize an rsa_op given its absolute value
+ * @n: pointer pointer to the allocated rsa_op
+ * @data: the value as a byte array
+ * @size: sizeof(data)
+ * @xtra: how many extra limbs to preallocate to avoid reallocations
+ *
+ * The optional leading zeroes will be taken into account, so that the
+ * rsa_op created will not be canonicalized
+ */
+int rsa_op_init(struct rsa_op **n, u8 *data, u32 size, u32 xtra)
+{
+	int i, j, s, retval;
+	u32 *buf;
+
+	*n = NULL;
+	if (!size && !xtra)
+		return -EINVAL;
+
+	/* Allocate space for the rsa_op and its data */
+	s = (size + 3) / 4;
+	retval = rsa_op_alloc(n, s + xtra);
+	if (retval < 0)
+		return retval;
+
+	(*n)->size = s;
+	buf = (*n)->data;
+
+	/* Copy the data */
+	for (i = size - 1, j = 0; i >= 0; i--, j++)
+		buf[j / 4] |= ((u32)data[i] << ((j % 4) * 8));
+	return 0;
+}
+
+/**
+ * rsa_op_set - set the value of an rsa_op given its absolute value
+ * @n: pointer pointer to the allocated rsa_op
+ * @data: the value as a byte array
+ * @size: sizeof(data)
+ *
+ * The optional leading zeroes will be taken into account, so that the rsa_op
+ * created will not be canonicalized. The rsa_op passed in will be reallocated
+ * (and relocated) if needed
+ */
+int rsa_op_set(struct rsa_op **n, u8 *data, u32 size)
+{
+	int s, i, j, retval;
+	u32 *buf;
+
+	if (!size)
+		return -EINVAL;
+
+	/* Size of the new rsa_op value (in limbs) */
+	s = (size + 3) / 4;
+	retval = rsa_op_resize(n, s);
+	if (retval < 0)
+		return retval;
+	memset((*n)->data, 0, (*n)->size * sizeof(u32));
+
+	/* Copy the data */
+	buf = (*n)->data;
+	for (i = size - 1, j = 0; i >= 0; i--, j++)
+		buf[j / 4] |= ((u32)data[i] << ((j % 4) * 8));
+	return 0;
+}
+
+/**
+ * rsa_op_copy - rsa_op to rsa_op copy
+ * @dest: destination rsa_op
+ * @src: source rsa_op
+ */
+int rsa_op_copy(struct rsa_op **dest, struct rsa_op *src)
+{
+	int retval;
+
+	retval = rsa_op_resize(dest, src->size);
+	if (retval < 0)
+		return retval;
+	memcpy((*dest)->data, src->data, src->size * sizeof(u32));
+	return 0;
+}
+
+/**
+ * rsa_op_print - print the value of an rsa_op
+ * @n: pointer to the rsa_op to be printed
+ * @how: true to print canonicalized
+ */
+void rsa_op_print(struct rsa_op *n, bool how)
+{
+	int i, j;
+	u32 limb;
+	u8 byte;
+	bool started = false;
+
+	printk("Operand @ 0x%x, %d limbs in size, %d limbs allocated, value = ",
+	       (u32)n, n->size, n->limbs);
+
+	/* Print the sign */
+	printk("%s", (n->sign)? "-" : " ");
+
+	/* Print the hex value */
+	for (i = n->size - 1; i >= 0; i--) {
+		limb = n->data[i];
+
+		/* Ignore leading zero limbs if canonicalization is selected */
+		if (!limb && !started && how)
+			continue;
+
+		/*
+		 * Print each limb as though each of its nibbles was a character
+		 * from the set '0' to '9' and 'a' to 'f'
+		 */
+		for (j = 28; j >= 0; j -= 4) {
+			byte = (u8)((limb >> j) & 0x0F);
+
+			/*
+			 * Ignore leading zero bytes if canonicalization
+			 * is selected
+			 */
+			if (!byte && !started && how)
+				continue;
+
+			started = true;
+			byte += (byte <= 0x09)? '0' : 'a' - 0x0A;
+			printk("%c", byte);
+		}
+	}
+
+	if (!started)
+		printk("0");
+	printk("\n");
+}
+
+/**
+ * rsa_cipher - compute montgomery modular exponentiation, m^e mod n
+ * @res: pointer pointer to the allocated result
+ * @m: data to be ciphered, also base of the exponentiation
+ * @e: exponent
+ * @n: modulus
+ *
+ * The montgomery modular exponentiation is not generic. It can be used only
+ * in cases where the modulus is odd as it is with RSA public and private key
+ * pairs, and this is because the algorithm depends in such number properties
+ * to speed things up. The calculation results will be invalid if the modulus
+ * is even. Furthermore the base must be in the residue class of the modulus
+ * (m < n). The calculation result if m > n will be mathematically valid but
+ * will be useless for the RSA cryptosystem, because it will be the result of
+ * (m mod n)^e mod n and not m^e mod n. Also the bit width of the base must
+ * be equal to the modulus bit width.
+ */
+int rsa_cipher(struct rsa_op **res, struct rsa_op *m, struct rsa_op *e,
+	       struct rsa_op *n)
+{
+	int i, j, retval;
+	u32 limb, modinv;
+	bool started = false;
+	struct rsa_op *aux[AUX_OPERAND_COUNT], *M, *x, *tmp;
+
+	/*
+	 * Check for bit width equality
+	 * Check if the base is in the residue class of the modulus
+	 * Check if the modulus is odd
+	 */
+	if (m->size != n->size || rsa_op_compare(m, n) > 0 || !(n->data[0] & 1))
+		return -EINVAL;
+
+	modinv = rsa_op_modinv32(n);
+	memset(&aux, 0, sizeof(aux));
+	M = x = NULL;
+
+	for (i = 0; i < AUX_OPERAND_COUNT; i++) {
+		retval = rsa_op_alloc(&aux[i],
+				      CONFIG_RSA_AUX_OPERAND_SIZE);
+		if (retval < 0)
+			goto rollback;
+	}
+
+	/* Compute M = m*r mod n where r is 2^k and k is the bit length of n */
+	retval = rsa_op_copy(&M, m);
+	if (retval < 0)
+		goto rollback;
+
+	retval = rsa_op_shift(&M, -(n->size * 32));
+	if (retval < 0)
+		goto rollback;
+
+	retval = rsa_remainder(&M, M, n, aux);
+	if (retval < 0)
+		goto rollback;
+
+	/* Compute x = r mod n where r is 2^k and k is the bit length of n */
+	retval = rsa_op_init(&x, "\x01", 1, 32);
+	if (retval < 0)
+		goto rollback;
+
+	retval = rsa_op_shift(&x, -(n->size * 32));
+	if (retval < 0)
+		goto rollback;
+
+	retval = rsa_remainder(&x, x, n, aux);
+	if (retval < 0)
+		goto rollback;
+
+	/*
+	 * Canonicalize the exponent and compute the modular exponentiation.
+	 * For each limb of the exponent perform left to right binary
+	 * exponentiation
+	 */
+	rsa_op_canonicalize(e);
+	for (i = e->size - 1; i >= 0; i--) {
+		/* Take a limb of the exponent */
+		limb = e->data[i];
+
+		/* For each of its bits */
+		for (j = 0; j < 32; j++) {
+			/*
+			 * While the exponent has non significant zeroes shift
+			 * it to the left
+			 */
+			if (!(limb & U32_MSB_SET) && !started) {
+				limb = limb << 1;
+				continue;
+			}
+			started = true;
+
+			/* Compute x = x*x mod n */
+			retval = rsa_mproduct(&x, x, x, n, modinv, aux);
+			if (retval < 0)
+				goto rollback;
+
+			if (limb & U32_MSB_SET) {
+				/* Compute x = M*x mod n */
+				retval = rsa_mproduct(&x, x, M, n, modinv, aux);
+				if (retval < 0)
+					goto rollback;
+			}
+
+			limb = limb << 1;
+		}
+	}
+
+	/* Compute res = x mod n */
+	retval = rsa_op_init(&tmp, "\x01", 1, 32);
+	if (retval < 0)
+		goto rollback;
+	retval = rsa_mproduct(res, x, tmp, n, modinv, aux);
+
+/* Free all allocated resources */
+rollback:
+	for (i = 0; i < AUX_OPERAND_COUNT; i++)
+		rsa_op_free(aux[i]);
+	rsa_op_free(M);
+	rsa_op_free(x);
+	rsa_op_free(tmp);
+	return retval;
+}
+
+EXPORT_SYMBOL(rsa_op_alloc);
+EXPORT_SYMBOL(rsa_op_free);
+EXPORT_SYMBOL(rsa_op_init);
+EXPORT_SYMBOL(rsa_op_set);
+EXPORT_SYMBOL(rsa_op_copy);
+EXPORT_SYMBOL(rsa_op_print);
+EXPORT_SYMBOL(rsa_cipher);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tasos Parisinos @ Sciensis Advanced Technology Systems");
+MODULE_DESCRIPTION("RSA cipher algorithm implementation");
+MODULE_ALIAS("rsa");
+
diff -uprN -X linux/Documentation/dontdiff \
linux.orig/include/crypto/rsa.h linux/include/crypto/rsa.h
--- linux.orig/include/crypto/rsa.h 1970-01-01 02:00:00.000000000 +0200
+++ linux/include/crypto/rsa.h 2007-04-02 11:49:03.000000000 +0300
@@ -0,0 +1,33 @@
+#ifndef _CRYPTO_RSA_H
+#define _CRYPTO_RSA_H
+
+/*
+ * struct rsa_op: multi-precision integer operand
+ * @data: array that holds the number absolute value
+ * @sign: 1 for negative, 0 for positive
+ * @size: significant number limbs
+ * @limbs: allocated limbs (sizeof data)
+ */
+struct rsa_op {
+	u32 *data;
+	int sign;
+	int size;
+	int limbs;
+};
+
+int	rsa_op_alloc(struct rsa_op **, int);
+
+void	rsa_op_free(struct rsa_op *);
+
+int 	rsa_op_init(struct rsa_op **, u8 *, u32, u32);
+
+int 	rsa_op_set(struct rsa_op **, u8 *, u32);
+
+int	rsa_op_copy(struct rsa_op **, struct rsa_op *);
+
+void	rsa_op_print(struct rsa_op *, bool);
+
+int 	rsa_cipher(struct rsa_op **, struct rsa_op *, struct rsa_op *,
+		   struct rsa_op *);
+
+#endif

