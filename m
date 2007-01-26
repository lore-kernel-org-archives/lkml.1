Return-Path: <linux-kernel-owner+w=401wt.eu-S1030875AbXAZQyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030875AbXAZQyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030892AbXAZQyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:54:12 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:59426 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030891AbXAZQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:53:44 -0500
Date: Fri, 26 Jan 2007 17:53:40 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: jan.glauber@de.ibm.com
Subject: [S390] move crypto options and some cleanup.
Message-ID: <20070126165340.GU11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jan.glauber@de.ibm.com>

[S390] move crypto options and some cleanup.

This patch moves the config options for the s390 crypto instructions
to the standard "Hardware crypto devices" menu. In addition some
cleanup has been done: use a flag for supported keylengths, add a
warning about machien limitation, return ENOTSUPP in case the
hardware has no support, remove superfluous printks and update
email addresses.

Signed-off-by: Jan Glauber <jan.glauber@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/crypto/Kconfig            |   60 +++++++
 arch/s390/crypto/aes_s390.c         |   47 ++----
 arch/s390/crypto/crypt_s390.h       |  280 +++++++++++++++++-------------------
 arch/s390/crypto/crypt_s390_query.c |    3 
 arch/s390/crypto/des_check_key.c    |    3 
 arch/s390/crypto/des_s390.c         |    8 -
 arch/s390/crypto/sha1_s390.c        |   81 ++++------
 arch/s390/crypto/sha256_s390.c      |    9 -
 arch/s390/defconfig                 |    8 -
 crypto/Kconfig                      |   49 ------
 10 files changed, 271 insertions(+), 277 deletions(-)

diff -urpN linux-2.6/arch/s390/crypto/aes_s390.c linux-2.6-patched/arch/s390/crypto/aes_s390.c
--- linux-2.6/arch/s390/crypto/aes_s390.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/aes_s390.c	2007-01-26 17:29:28.000000000 +0100
@@ -4,7 +4,7 @@
  * s390 implementation of the AES Cipher Algorithm.
  *
  * s390 Version:
- *   Copyright (C) 2005 IBM Deutschland GmbH, IBM Corporation
+ *   Copyright (C) 2005-2007 IBM Deutschland GmbH, IBM Corporation
  *   Author(s): Jan Glauber (jang@de.ibm.com)
  *
  * Derived from "crypto/aes.c"
@@ -27,9 +27,11 @@
 /* data block size for all key lengths */
 #define AES_BLOCK_SIZE		16
 
-static int has_aes_128 = 0;
-static int has_aes_192 = 0;
-static int has_aes_256 = 0;
+#define AES_KEYLEN_128		1
+#define AES_KEYLEN_192		2
+#define AES_KEYLEN_256		4
+
+static char keylen_flag = 0;
 
 struct s390_aes_ctx {
 	u8 iv[AES_BLOCK_SIZE];
@@ -47,20 +49,19 @@ static int aes_set_key(struct crypto_tfm
 
 	switch (key_len) {
 	case 16:
-		if (!has_aes_128)
+		if (!(keylen_flag & AES_KEYLEN_128))
 			goto fail;
 		break;
 	case 24:
-		if (!has_aes_192)
+		if (!(keylen_flag & AES_KEYLEN_192))
 			goto fail;
 
 		break;
 	case 32:
-		if (!has_aes_256)
+		if (!(keylen_flag & AES_KEYLEN_256))
 			goto fail;
 		break;
 	default:
-		/* invalid key length */
 		goto fail;
 		break;
 	}
@@ -322,34 +323,32 @@ static int __init aes_init(void)
 	int ret;
 
 	if (crypt_s390_func_available(KM_AES_128_ENCRYPT))
-		has_aes_128 = 1;
+		keylen_flag |= AES_KEYLEN_128;
 	if (crypt_s390_func_available(KM_AES_192_ENCRYPT))
-		has_aes_192 = 1;
+		keylen_flag |= AES_KEYLEN_192;
 	if (crypt_s390_func_available(KM_AES_256_ENCRYPT))
-		has_aes_256 = 1;
+		keylen_flag |= AES_KEYLEN_256;
+
+	if (!keylen_flag)
+		return -ENOTSUPP;
 
-	if (!has_aes_128 && !has_aes_192 && !has_aes_256)
-		return -ENOSYS;
+	/* z9 109 and z9 BC/EC only support 128 bit key length */
+	if (keylen_flag == AES_KEYLEN_128)
+		printk(KERN_INFO
+		       "aes_s390: hardware acceleration only available for"
+		       "128 bit keys\n");
 
 	ret = crypto_register_alg(&aes_alg);
-	if (ret != 0) {
-		printk(KERN_INFO "crypt_s390: aes-s390 couldn't be loaded.\n");
+	if (ret)
 		goto aes_err;
-	}
 
 	ret = crypto_register_alg(&ecb_aes_alg);
-	if (ret != 0) {
-		printk(KERN_INFO
-		       "crypt_s390: ecb-aes-s390 couldn't be loaded.\n");
+	if (ret)
 		goto ecb_aes_err;
-	}
 
 	ret = crypto_register_alg(&cbc_aes_alg);
-	if (ret != 0) {
-		printk(KERN_INFO
-		       "crypt_s390: cbc-aes-s390 couldn't be loaded.\n");
+	if (ret)
 		goto cbc_aes_err;
-	}
 
 out:
 	return ret;
diff -urpN linux-2.6/arch/s390/crypto/crypt_s390.h linux-2.6-patched/arch/s390/crypto/crypt_s390.h
--- linux-2.6/arch/s390/crypto/crypt_s390.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/crypt_s390.h	2007-01-26 17:29:28.000000000 +0100
@@ -3,8 +3,9 @@
  *
  * Support for s390 cryptographic instructions.
  *
- *   Copyright (C) 2003 IBM Deutschland GmbH, IBM Corporation
- *   Author(s): Thomas Spatzier (tspat@de.ibm.com)
+ *   Copyright (C) 2003-2007 IBM Deutschland GmbH, IBM Corporation
+ *   Author(s): Thomas Spatzier
+ *		Jan Glauber (jan.glauber@de.ibm.com)
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -32,7 +33,8 @@ enum crypt_s390_operations {
 	CRYPT_S390_KMAC = 0x0500
 };
 
-/* function codes for KM (CIPHER MESSAGE) instruction
+/*
+ * function codes for KM (CIPHER MESSAGE) instruction
  * 0x80 is the decipher modifier bit
  */
 enum crypt_s390_km_func {
@@ -51,7 +53,8 @@ enum crypt_s390_km_func {
 	KM_AES_256_DECRYPT  = CRYPT_S390_KM | 0x14 | 0x80,
 };
 
-/* function codes for KMC (CIPHER MESSAGE WITH CHAINING)
+/*
+ * function codes for KMC (CIPHER MESSAGE WITH CHAINING)
  * instruction
  */
 enum crypt_s390_kmc_func {
@@ -70,7 +73,8 @@ enum crypt_s390_kmc_func {
 	KMC_AES_256_DECRYPT  = CRYPT_S390_KMC | 0x14 | 0x80,
 };
 
-/* function codes for KIMD (COMPUTE INTERMEDIATE MESSAGE DIGEST)
+/*
+ * function codes for KIMD (COMPUTE INTERMEDIATE MESSAGE DIGEST)
  * instruction
  */
 enum crypt_s390_kimd_func {
@@ -79,7 +83,8 @@ enum crypt_s390_kimd_func {
 	KIMD_SHA_256 = CRYPT_S390_KIMD | 2,
 };
 
-/* function codes for KLMD (COMPUTE LAST MESSAGE DIGEST)
+/*
+ * function codes for KLMD (COMPUTE LAST MESSAGE DIGEST)
  * instruction
  */
 enum crypt_s390_klmd_func {
@@ -88,7 +93,8 @@ enum crypt_s390_klmd_func {
 	KLMD_SHA_256 = CRYPT_S390_KLMD | 2,
 };
 
-/* function codes for KMAC (COMPUTE MESSAGE AUTHENTICATION CODE)
+/*
+ * function codes for KMAC (COMPUTE MESSAGE AUTHENTICATION CODE)
  * instruction
  */
 enum crypt_s390_kmac_func {
@@ -98,229 +104,219 @@ enum crypt_s390_kmac_func {
 	KMAC_TDEA_192 = CRYPT_S390_KMAC | 3
 };
 
-/* status word for s390 crypto instructions' QUERY functions */
-struct crypt_s390_query_status {
-	u64 high;
-	u64 low;
-};
-
-/*
+/**
+ * crypt_s390_km:
+ * @func: the function code passed to KM; see crypt_s390_km_func
+ * @param: address of parameter block; see POP for details on each func
+ * @dest: address of destination memory area
+ * @src: address of source memory area
+ * @src_len: length of src operand in bytes
+ *
  * Executes the KM (CIPHER MESSAGE) operation of the CPU.
- * @param func: the function code passed to KM; see crypt_s390_km_func
- * @param param: address of parameter block; see POP for details on each func
- * @param dest: address of destination memory area
- * @param src: address of source memory area
- * @param src_len: length of src operand in bytes
- * @returns < zero for failure, 0 for the query func, number of processed bytes
- * 	for encryption/decryption funcs
+ *
+ * Returns -1 for failure, 0 for the query func, number of processed
+ * bytes for encryption/decryption funcs
  */
-static inline int
-crypt_s390_km(long func, void* param, u8* dest, const u8* src, long src_len)
+static inline int crypt_s390_km(long func, void *param,
+				u8 *dest, const u8 *src, long src_len)
 {
 	register long __func asm("0") = func & CRYPT_S390_FUNC_MASK;
-	register void* __param asm("1") = param;
-	register const u8* __src asm("2") = src;
+	register void *__param asm("1") = param;
+	register const u8 *__src asm("2") = src;
 	register long __src_len asm("3") = src_len;
-	register u8* __dest asm("4") = dest;
+	register u8 *__dest asm("4") = dest;
 	int ret;
 
 	asm volatile(
 		"0:	.insn	rre,0xb92e0000,%3,%1 \n" /* KM opcode */
 		"1:	brc	1,0b \n" /* handle partial completion */
-		"	ahi	%0,%h7\n"
-		"2:	ahi	%0,%h8\n"
-		"3:\n"
-		EX_TABLE(0b,3b) EX_TABLE(1b,2b)
+		"	la	%0,0\n"
+		"2:\n"
+		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		: "=d" (ret), "+a" (__src), "+d" (__src_len), "+a" (__dest)
-		: "d" (__func), "a" (__param), "0" (-EFAULT),
-		  "K" (ENOSYS), "K" (-ENOSYS + EFAULT) : "cc", "memory");
+		: "d" (__func), "a" (__param), "0" (-1) : "cc", "memory");
 	if (ret < 0)
 		return ret;
 	return (func & CRYPT_S390_FUNC_MASK) ? src_len - __src_len : __src_len;
 }
 
-/*
+/**
+ * crypt_s390_kmc:
+ * @func: the function code passed to KM; see crypt_s390_kmc_func
+ * @param: address of parameter block; see POP for details on each func
+ * @dest: address of destination memory area
+ * @src: address of source memory area
+ * @src_len: length of src operand in bytes
+ *
  * Executes the KMC (CIPHER MESSAGE WITH CHAINING) operation of the CPU.
- * @param func: the function code passed to KM; see crypt_s390_kmc_func
- * @param param: address of parameter block; see POP for details on each func
- * @param dest: address of destination memory area
- * @param src: address of source memory area
- * @param src_len: length of src operand in bytes
- * @returns < zero for failure, 0 for the query func, number of processed bytes
- * 	for encryption/decryption funcs
+ *
+ * Returns -1 for failure, 0 for the query func, number of processed
+ * bytes for encryption/decryption funcs
  */
-static inline int
-crypt_s390_kmc(long func, void* param, u8* dest, const u8* src, long src_len)
+static inline int crypt_s390_kmc(long func, void *param,
+				 u8 *dest, const u8 *src, long src_len)
 {
 	register long __func asm("0") = func & CRYPT_S390_FUNC_MASK;
-	register void* __param asm("1") = param;
-	register const u8* __src asm("2") = src;
+	register void *__param asm("1") = param;
+	register const u8 *__src asm("2") = src;
 	register long __src_len asm("3") = src_len;
-	register u8* __dest asm("4") = dest;
+	register u8 *__dest asm("4") = dest;
 	int ret;
 
 	asm volatile(
 		"0:	.insn	rre,0xb92f0000,%3,%1 \n" /* KMC opcode */
 		"1:	brc	1,0b \n" /* handle partial completion */
-		"	ahi	%0,%h7\n"
-		"2:	ahi	%0,%h8\n"
-		"3:\n"
-		EX_TABLE(0b,3b) EX_TABLE(1b,2b)
+		"	la	%0,0\n"
+		"2:\n"
+		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		: "=d" (ret), "+a" (__src), "+d" (__src_len), "+a" (__dest)
-		: "d" (__func), "a" (__param), "0" (-EFAULT),
-		  "K" (ENOSYS), "K" (-ENOSYS + EFAULT) : "cc", "memory");
+		: "d" (__func), "a" (__param), "0" (-1) : "cc", "memory");
 	if (ret < 0)
 		return ret;
 	return (func & CRYPT_S390_FUNC_MASK) ? src_len - __src_len : __src_len;
 }
 
-/*
+/**
+ * crypt_s390_kimd:
+ * @func: the function code passed to KM; see crypt_s390_kimd_func
+ * @param: address of parameter block; see POP for details on each func
+ * @src: address of source memory area
+ * @src_len: length of src operand in bytes
+ *
  * Executes the KIMD (COMPUTE INTERMEDIATE MESSAGE DIGEST) operation
  * of the CPU.
- * @param func: the function code passed to KM; see crypt_s390_kimd_func
- * @param param: address of parameter block; see POP for details on each func
- * @param src: address of source memory area
- * @param src_len: length of src operand in bytes
- * @returns < zero for failure, 0 for the query func, number of processed bytes
- * 	for digest funcs
+ *
+ * Returns -1 for failure, 0 for the query func, number of processed
+ * bytes for digest funcs
  */
-static inline int
-crypt_s390_kimd(long func, void* param, const u8* src, long src_len)
+static inline int crypt_s390_kimd(long func, void *param,
+				  const u8 *src, long src_len)
 {
 	register long __func asm("0") = func & CRYPT_S390_FUNC_MASK;
-	register void* __param asm("1") = param;
-	register const u8* __src asm("2") = src;
+	register void *__param asm("1") = param;
+	register const u8 *__src asm("2") = src;
 	register long __src_len asm("3") = src_len;
 	int ret;
 
 	asm volatile(
 		"0:	.insn	rre,0xb93e0000,%1,%1 \n" /* KIMD opcode */
 		"1:	brc	1,0b \n" /* handle partial completion */
-		"	ahi	%0,%h6\n"
-		"2:	ahi	%0,%h7\n"
-		"3:\n"
-		EX_TABLE(0b,3b) EX_TABLE(1b,2b)
+		"	la	%0,0\n"
+		"2:\n"
+		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		: "=d" (ret), "+a" (__src), "+d" (__src_len)
-		: "d" (__func), "a" (__param), "0" (-EFAULT),
-		  "K" (ENOSYS), "K" (-ENOSYS + EFAULT) : "cc", "memory");
+		: "d" (__func), "a" (__param), "0" (-1) : "cc", "memory");
 	if (ret < 0)
 		return ret;
 	return (func & CRYPT_S390_FUNC_MASK) ? src_len - __src_len : __src_len;
 }
 
-/*
+/**
+ * crypt_s390_klmd:
+ * @func: the function code passed to KM; see crypt_s390_klmd_func
+ * @param: address of parameter block; see POP for details on each func
+ * @src: address of source memory area
+ * @src_len: length of src operand in bytes
+ *
  * Executes the KLMD (COMPUTE LAST MESSAGE DIGEST) operation of the CPU.
- * @param func: the function code passed to KM; see crypt_s390_klmd_func
- * @param param: address of parameter block; see POP for details on each func
- * @param src: address of source memory area
- * @param src_len: length of src operand in bytes
- * @returns < zero for failure, 0 for the query func, number of processed bytes
- * 	for digest funcs
+ *
+ * Returns -1 for failure, 0 for the query func, number of processed
+ * bytes for digest funcs
  */
-static inline int
-crypt_s390_klmd(long func, void* param, const u8* src, long src_len)
+static inline int crypt_s390_klmd(long func, void *param,
+				  const u8 *src, long src_len)
 {
 	register long __func asm("0") = func & CRYPT_S390_FUNC_MASK;
-	register void* __param asm("1") = param;
-	register const u8* __src asm("2") = src;
+	register void *__param asm("1") = param;
+	register const u8 *__src asm("2") = src;
 	register long __src_len asm("3") = src_len;
 	int ret;
 
 	asm volatile(
 		"0:	.insn	rre,0xb93f0000,%1,%1 \n" /* KLMD opcode */
 		"1:	brc	1,0b \n" /* handle partial completion */
-		"	ahi	%0,%h6\n"
-		"2:	ahi	%0,%h7\n"
-		"3:\n"
-		EX_TABLE(0b,3b) EX_TABLE(1b,2b)
+		"	la	%0,0\n"
+		"2:\n"
+		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		: "=d" (ret), "+a" (__src), "+d" (__src_len)
-		: "d" (__func), "a" (__param), "0" (-EFAULT),
-		  "K" (ENOSYS), "K" (-ENOSYS + EFAULT) : "cc", "memory");
+		: "d" (__func), "a" (__param), "0" (-1) : "cc", "memory");
 	if (ret < 0)
 		return ret;
 	return (func & CRYPT_S390_FUNC_MASK) ? src_len - __src_len : __src_len;
 }
 
-/*
+/**
+ * crypt_s390_kmac:
+ * @func: the function code passed to KM; see crypt_s390_klmd_func
+ * @param: address of parameter block; see POP for details on each func
+ * @src: address of source memory area
+ * @src_len: length of src operand in bytes
+ *
  * Executes the KMAC (COMPUTE MESSAGE AUTHENTICATION CODE) operation
  * of the CPU.
- * @param func: the function code passed to KM; see crypt_s390_klmd_func
- * @param param: address of parameter block; see POP for details on each func
- * @param src: address of source memory area
- * @param src_len: length of src operand in bytes
- * @returns < zero for failure, 0 for the query func, number of processed bytes
- * 	for digest funcs
+ *
+ * Returns -1 for failure, 0 for the query func, number of processed
+ * bytes for digest funcs
  */
-static inline int
-crypt_s390_kmac(long func, void* param, const u8* src, long src_len)
+static inline int crypt_s390_kmac(long func, void *param,
+				  const u8 *src, long src_len)
 {
 	register long __func asm("0") = func & CRYPT_S390_FUNC_MASK;
-	register void* __param asm("1") = param;
-	register const u8* __src asm("2") = src;
+	register void *__param asm("1") = param;
+	register const u8 *__src asm("2") = src;
 	register long __src_len asm("3") = src_len;
 	int ret;
 
 	asm volatile(
 		"0:	.insn	rre,0xb91e0000,%1,%1 \n" /* KLAC opcode */
 		"1:	brc	1,0b \n" /* handle partial completion */
-		"	ahi	%0,%h6\n"
-		"2:	ahi	%0,%h7\n"
-		"3:\n"
-		EX_TABLE(0b,3b) EX_TABLE(1b,2b)
+		"	la	%0,0\n"
+		"2:\n"
+		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		: "=d" (ret), "+a" (__src), "+d" (__src_len)
-		: "d" (__func), "a" (__param), "0" (-EFAULT),
-		  "K" (ENOSYS), "K" (-ENOSYS + EFAULT) : "cc", "memory");
+		: "d" (__func), "a" (__param), "0" (-1) : "cc", "memory");
 	if (ret < 0)
 		return ret;
 	return (func & CRYPT_S390_FUNC_MASK) ? src_len - __src_len : __src_len;
 }
 
 /**
+ * crypt_s390_func_available:
+ * @func: the function code of the specific function; 0 if op in general
+ *
  * Tests if a specific crypto function is implemented on the machine.
- * @param func:	the function code of the specific function; 0 if op in general
- * @return	1 if func available; 0 if func or op in general not available
+ *
+ * Returns 1 if func available; 0 if func or op in general not available
  */
-static inline int
-crypt_s390_func_available(int func)
+static inline int crypt_s390_func_available(int func)
 {
+	unsigned char status[16];
 	int ret;
 
-	struct crypt_s390_query_status status = {
-		.high = 0,
-		.low = 0
-	};
-	switch (func & CRYPT_S390_OP_MASK){
-		case CRYPT_S390_KM:
-			ret = crypt_s390_km(KM_QUERY, &status, NULL, NULL, 0);
-			break;
-		case CRYPT_S390_KMC:
-			ret = crypt_s390_kmc(KMC_QUERY, &status, NULL, NULL, 0);
-			break;
-		case CRYPT_S390_KIMD:
-			ret = crypt_s390_kimd(KIMD_QUERY, &status, NULL, 0);
-			break;
-		case CRYPT_S390_KLMD:
-			ret = crypt_s390_klmd(KLMD_QUERY, &status, NULL, 0);
-			break;
-		case CRYPT_S390_KMAC:
-			ret = crypt_s390_kmac(KMAC_QUERY, &status, NULL, 0);
-			break;
-		default:
-			ret = 0;
-			return ret;
-	}
-	if (ret >= 0){
-		func &= CRYPT_S390_FUNC_MASK;
-		func &= 0x7f; //mask modifier bit
-		if (func < 64){
-			ret = (status.high >> (64 - func - 1)) & 0x1;
-		} else {
-			ret = (status.low >> (128 - func - 1)) & 0x1;
-		}
-	} else {
-		ret = 0;
+	switch (func & CRYPT_S390_OP_MASK) {
+	case CRYPT_S390_KM:
+		ret = crypt_s390_km(KM_QUERY, &status, NULL, NULL, 0);
+		break;
+	case CRYPT_S390_KMC:
+		ret = crypt_s390_kmc(KMC_QUERY, &status, NULL, NULL, 0);
+		break;
+	case CRYPT_S390_KIMD:
+		ret = crypt_s390_kimd(KIMD_QUERY, &status, NULL, 0);
+		break;
+	case CRYPT_S390_KLMD:
+		ret = crypt_s390_klmd(KLMD_QUERY, &status, NULL, 0);
+		break;
+	case CRYPT_S390_KMAC:
+		ret = crypt_s390_kmac(KMAC_QUERY, &status, NULL, 0);
+		break;
+	default:
+		return 0;
 	}
-	return ret;
+	if (ret < 0)
+		return 0;
+	func &= CRYPT_S390_FUNC_MASK;
+	func &= 0x7f;		/* mask modifier bit */
+	return (status[func >> 3] & (0x80 >> (func & 7))) != 0;
 }
 
-#endif // _CRYPTO_ARCH_S390_CRYPT_S390_H
+#endif	/* _CRYPTO_ARCH_S390_CRYPT_S390_H */
diff -urpN linux-2.6/arch/s390/crypto/crypt_s390_query.c linux-2.6-patched/arch/s390/crypto/crypt_s390_query.c
--- linux-2.6/arch/s390/crypto/crypt_s390_query.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/crypt_s390_query.c	2007-01-26 17:29:28.000000000 +0100
@@ -5,7 +5,8 @@
  * Testing module for querying processor crypto capabilities.
  *
  * Copyright (c) 2003 IBM Deutschland Entwicklung GmbH, IBM Corporation
- * Author(s): Thomas Spatzier (tspat@de.ibm.com)
+ * Author(s): Thomas Spatzier
+ *	      Jan Glauber (jan.glauber@de.ibm.com)
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff -urpN linux-2.6/arch/s390/crypto/des_check_key.c linux-2.6-patched/arch/s390/crypto/des_check_key.c
--- linux-2.6/arch/s390/crypto/des_check_key.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/des_check_key.c	2007-01-26 17:29:28.000000000 +0100
@@ -11,7 +11,8 @@
  *
  * s390 Version:
  *   Copyright (C) 2003 IBM Deutschland GmbH, IBM Corporation
- *   Author(s): Thomas Spatzier (tspat@de.ibm.com)
+ *   Author(s): Thomas Spatzier
+ *		Jan Glauber (jan.glauber@de.ibm.com)
  *
  * Derived from "crypto/des.c"
  *   Copyright (c) 1992 Dana L. How.
diff -urpN linux-2.6/arch/s390/crypto/des_s390.c linux-2.6-patched/arch/s390/crypto/des_s390.c
--- linux-2.6/arch/s390/crypto/des_s390.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/des_s390.c	2007-01-26 17:29:28.000000000 +0100
@@ -3,9 +3,9 @@
  *
  * s390 implementation of the DES Cipher Algorithm.
  *
- * Copyright (c) 2003 IBM Deutschland Entwicklung GmbH, IBM Corporation
- * Author(s): Thomas Spatzier (tspat@de.ibm.com)
- *
+ * Copyright (c) 2003,2007 IBM Deutschland Entwicklung GmbH, IBM Corporation
+ * Author(s): Thomas Spatzier
+ *	      Jan Glauber (jan.glauber@de.ibm.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -557,7 +557,7 @@ static int init(void)
 	if (!crypt_s390_func_available(KM_DEA_ENCRYPT) ||
 	    !crypt_s390_func_available(KM_TDEA_128_ENCRYPT) ||
 	    !crypt_s390_func_available(KM_TDEA_192_ENCRYPT))
-		return -ENOSYS;
+		return -ENOTSUPP;
 
 	ret = crypto_register_alg(&des_alg);
 	if (ret)
diff -urpN linux-2.6/arch/s390/crypto/Kconfig linux-2.6-patched/arch/s390/crypto/Kconfig
--- linux-2.6/arch/s390/crypto/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/Kconfig	2007-01-26 17:29:28.000000000 +0100
@@ -0,0 +1,60 @@
+config CRYPTO_SHA1_S390
+	tristate "SHA1 digest algorithm"
+	depends on S390
+	select CRYPTO_ALGAPI
+	help
+	  This is the s390 hardware accelerated implementation of the
+	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
+
+config CRYPTO_SHA256_S390
+	tristate "SHA256 digest algorithm"
+	depends on S390
+	select CRYPTO_ALGAPI
+	help
+	  This is the s390 hardware accelerated implementation of the
+	  SHA256 secure hash standard (DFIPS 180-2).
+
+	  This version of SHA implements a 256 bit hash with 128 bits of
+	  security against collision attacks.
+
+config CRYPTO_DES_S390
+	tristate "DES and Triple DES cipher algorithms"
+	depends on S390
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	help
+	  This us the s390 hardware accelerated implementation of the
+	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
+
+config CRYPTO_AES_S390
+	tristate "AES cipher algorithms"
+	depends on S390
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	help
+	  This is the s390 hardware accelerated implementation of the
+	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
+	  algorithm.
+
+	  Rijndael appears to be consistently a very good performer in
+	  both hardware and software across a wide range of computing
+	  environments regardless of its use in feedback or non-feedback
+	  modes. Its key setup time is excellent, and its key agility is
+	  good. Rijndael's very low memory requirements make it very well
+	  suited for restricted-space environments, in which it also
+	  demonstrates excellent performance. Rijndael's operations are
+	  among the easiest to defend against power and timing attacks.
+
+	  On s390 the System z9-109 currently only supports the key size
+	  of 128 bit.
+
+config S390_PRNG
+	tristate "Pseudo random number generator device driver"
+	depends on S390
+	default "m"
+	help
+	  Select this option if you want to use the s390 pseudo random number
+	  generator. The PRNG is part of the cryptograhic processor functions
+	  and uses triple-DES to generate secure random numbers like the
+	  ANSI X9.17 standard. The PRNG is usable via the char device
+	  /dev/prandom.
diff -urpN linux-2.6/arch/s390/crypto/sha1_s390.c linux-2.6-patched/arch/s390/crypto/sha1_s390.c
--- linux-2.6/arch/s390/crypto/sha1_s390.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/sha1_s390.c	2007-01-26 17:29:28.000000000 +0100
@@ -9,7 +9,8 @@
  *
  * s390 Version:
  *   Copyright (C) 2003 IBM Deutschland GmbH, IBM Corporation
- *   Author(s): Thomas Spatzier (tspat@de.ibm.com)
+ *   Author(s): Thomas Spatzier
+ *		Jan Glauber (jan.glauber@de.ibm.com)
  *
  * Derived from "crypto/sha1.c"
  *   Copyright (c) Alan Smithee.
@@ -43,16 +44,14 @@ struct crypt_s390_sha1_ctx {
 static void sha1_init(struct crypto_tfm *tfm)
 {
 	struct crypt_s390_sha1_ctx *ctx = crypto_tfm_ctx(tfm);
-	static const u32 initstate[5] = {
-		0x67452301,
-		0xEFCDAB89,
-		0x98BADCFE,
-		0x10325476,
-		0xC3D2E1F0
-	};
+
+	ctx->state[0] = 0x67452301;
+	ctx->state[1] =	0xEFCDAB89;
+	ctx->state[2] =	0x98BADCFE;
+	ctx->state[3] = 0x10325476;
+	ctx->state[4] =	0xC3D2E1F0;
 
 	ctx->count = 0;
-	memcpy(ctx->state, &initstate, sizeof(initstate));
 	ctx->buf_len = 0;
 }
 
@@ -63,13 +62,13 @@ static void sha1_update(struct crypto_tf
 	long imd_len;
 
 	sctx = crypto_tfm_ctx(tfm);
-	sctx->count += len * 8; //message bit length
+	sctx->count += len * 8; /* message bit length */
 
-	//anything in buffer yet? -> must be completed
+	/* anything in buffer yet? -> must be completed */
 	if (sctx->buf_len && (sctx->buf_len + len) >= SHA1_BLOCK_SIZE) {
-		//complete full block and hash
+		/* complete full block and hash */
 		memcpy(sctx->buffer + sctx->buf_len, data,
-				SHA1_BLOCK_SIZE - sctx->buf_len);
+		       SHA1_BLOCK_SIZE - sctx->buf_len);
 		crypt_s390_kimd(KIMD_SHA_1, sctx->state, sctx->buffer,
 				SHA1_BLOCK_SIZE);
 		data += SHA1_BLOCK_SIZE - sctx->buf_len;
@@ -77,37 +76,36 @@ static void sha1_update(struct crypto_tf
 		sctx->buf_len = 0;
 	}
 
-	//rest of data contains full blocks?
+	/* rest of data contains full blocks? */
 	imd_len = len & ~0x3ful;
-	if (imd_len){
+	if (imd_len) {
 		crypt_s390_kimd(KIMD_SHA_1, sctx->state, data, imd_len);
 		data += imd_len;
 		len -= imd_len;
 	}
-	//anything left? store in buffer
-	if (len){
+	/* anything left? store in buffer */
+	if (len) {
 		memcpy(sctx->buffer + sctx->buf_len , data, len);
 		sctx->buf_len += len;
 	}
 }
 
 
-static void
-pad_message(struct crypt_s390_sha1_ctx* sctx)
+static void pad_message(struct crypt_s390_sha1_ctx* sctx)
 {
 	int index;
 
 	index = sctx->buf_len;
-	sctx->buf_len = (sctx->buf_len < 56)?
-		SHA1_BLOCK_SIZE:2 * SHA1_BLOCK_SIZE;
-	//start pad with 1
+	sctx->buf_len = (sctx->buf_len < 56) ?
+			 SHA1_BLOCK_SIZE:2 * SHA1_BLOCK_SIZE;
+	/* start pad with 1 */
 	sctx->buffer[index] = 0x80;
-	//pad with zeros
+	/* pad with zeros */
 	index++;
 	memset(sctx->buffer + index, 0x00, sctx->buf_len - index);
-	//append length
+	/* append length */
 	memcpy(sctx->buffer + sctx->buf_len - 8, &sctx->count,
-			sizeof sctx->count);
+	       sizeof sctx->count);
 }
 
 /* Add padding and return the message digest. */
@@ -115,47 +113,40 @@ static void sha1_final(struct crypto_tfm
 {
 	struct crypt_s390_sha1_ctx *sctx = crypto_tfm_ctx(tfm);
 
-	//must perform manual padding
+	/* must perform manual padding */
 	pad_message(sctx);
 	crypt_s390_kimd(KIMD_SHA_1, sctx->state, sctx->buffer, sctx->buf_len);
-	//copy digest to out
+	/* copy digest to out */
 	memcpy(out, sctx->state, SHA1_DIGEST_SIZE);
-	/* Wipe context */
+	/* wipe context */
 	memset(sctx, 0, sizeof *sctx);
 }
 
 static struct crypto_alg alg = {
 	.cra_name	=	"sha1",
-	.cra_driver_name =	"sha1-s390",
+	.cra_driver_name=	"sha1-s390",
 	.cra_priority	=	CRYPT_S390_PRIORITY,
 	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
 	.cra_blocksize	=	SHA1_BLOCK_SIZE,
 	.cra_ctxsize	=	sizeof(struct crypt_s390_sha1_ctx),
 	.cra_module	=	THIS_MODULE,
-	.cra_list       =       LIST_HEAD_INIT(alg.cra_list),
+	.cra_list	=	LIST_HEAD_INIT(alg.cra_list),
 	.cra_u		=	{ .digest = {
 	.dia_digestsize	=	SHA1_DIGEST_SIZE,
-	.dia_init   	= 	sha1_init,
-	.dia_update 	=	sha1_update,
-	.dia_final  	=	sha1_final } }
+	.dia_init	=	sha1_init,
+	.dia_update	=	sha1_update,
+	.dia_final	=	sha1_final } }
 };
 
-static int
-init(void)
+static int __init init(void)
 {
-	int ret = -ENOSYS;
+	if (!crypt_s390_func_available(KIMD_SHA_1))
+		return -ENOTSUPP;
 
-	if (crypt_s390_func_available(KIMD_SHA_1)){
-		ret = crypto_register_alg(&alg);
-		if (ret == 0){
-			printk(KERN_INFO "crypt_s390: sha1_s390 loaded.\n");
-		}
-	}
-	return ret;
+	return crypto_register_alg(&alg);
 }
 
-static void __exit
-fini(void)
+static void __exit fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
diff -urpN linux-2.6/arch/s390/crypto/sha256_s390.c linux-2.6-patched/arch/s390/crypto/sha256_s390.c
--- linux-2.6/arch/s390/crypto/sha256_s390.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/sha256_s390.c	2007-01-26 17:29:28.000000000 +0100
@@ -143,15 +143,10 @@ static struct crypto_alg alg = {
 
 static int init(void)
 {
-	int ret;
-
 	if (!crypt_s390_func_available(KIMD_SHA_256))
-		return -ENOSYS;
+		return -ENOTSUPP;
 
-	ret = crypto_register_alg(&alg);
-	if (ret != 0)
-		printk(KERN_INFO "crypt_s390: sha256_s390 couldn't be loaded.");
-	return ret;
+	return crypto_register_alg(&alg);
 }
 
 static void __exit fini(void)
diff -urpN linux-2.6/arch/s390/defconfig linux-2.6-patched/arch/s390/defconfig
--- linux-2.6/arch/s390/defconfig	2007-01-26 17:27:45.000000000 +0100
+++ linux-2.6-patched/arch/s390/defconfig	2007-01-26 17:29:28.000000000 +0100
@@ -723,9 +723,7 @@ CONFIG_CRYPTO_MANAGER=y
 # CONFIG_CRYPTO_MD4 is not set
 # CONFIG_CRYPTO_MD5 is not set
 # CONFIG_CRYPTO_SHA1 is not set
-# CONFIG_CRYPTO_SHA1_S390 is not set
 # CONFIG_CRYPTO_SHA256 is not set
-# CONFIG_CRYPTO_SHA256_S390 is not set
 # CONFIG_CRYPTO_SHA512 is not set
 # CONFIG_CRYPTO_WP512 is not set
 # CONFIG_CRYPTO_TGR192 is not set
@@ -734,12 +732,10 @@ CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_CBC=y
 # CONFIG_CRYPTO_LRW is not set
 # CONFIG_CRYPTO_DES is not set
-# CONFIG_CRYPTO_DES_S390 is not set
 # CONFIG_CRYPTO_BLOWFISH is not set
 # CONFIG_CRYPTO_TWOFISH is not set
 # CONFIG_CRYPTO_SERPENT is not set
 # CONFIG_CRYPTO_AES is not set
-# CONFIG_CRYPTO_AES_S390 is not set
 # CONFIG_CRYPTO_CAST5 is not set
 # CONFIG_CRYPTO_CAST6 is not set
 # CONFIG_CRYPTO_TEA is not set
@@ -754,6 +750,10 @@ CONFIG_CRYPTO_CBC=y
 #
 # Hardware crypto devices
 #
+# CONFIG_CRYPTO_SHA1_S390 is not set
+# CONFIG_CRYPTO_SHA256_S390 is not set
+# CONFIG_CRYPTO_DES_S390 is not set
+# CONFIG_CRYPTO_AES_S390 is not set
 
 #
 # Library routines
diff -urpN linux-2.6/crypto/Kconfig linux-2.6-patched/crypto/Kconfig
--- linux-2.6/crypto/Kconfig	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/crypto/Kconfig	2007-01-26 17:29:28.000000000 +0100
@@ -74,14 +74,6 @@ config CRYPTO_SHA1
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
-config CRYPTO_SHA1_S390
-	tristate "SHA1 digest algorithm (s390)"
-	depends on S390
-	select CRYPTO_ALGAPI
-	help
-	  This is the s390 hardware accelerated implementation of the
-	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
-
 config CRYPTO_SHA256
 	tristate "SHA256 digest algorithm"
 	select CRYPTO_ALGAPI
@@ -91,17 +83,6 @@ config CRYPTO_SHA256
 	  This version of SHA implements a 256 bit hash with 128 bits of
 	  security against collision attacks.
 
-config CRYPTO_SHA256_S390
-	tristate "SHA256 digest algorithm (s390)"
-	depends on S390
-	select CRYPTO_ALGAPI
-	help
-	  This is the s390 hardware accelerated implementation of the
-	  SHA256 secure hash standard (DFIPS 180-2).
-
-	  This version of SHA implements a 256 bit hash with 128 bits of
-	  security against collision attacks.
-
 config CRYPTO_SHA512
 	tristate "SHA384 and SHA512 digest algorithms"
 	select CRYPTO_ALGAPI
@@ -187,14 +168,6 @@ config CRYPTO_DES
 	help
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
 
-config CRYPTO_DES_S390
-	tristate "DES and Triple DES cipher algorithms (s390)"
-	depends on S390
-	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
-	help
-	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
-
 config CRYPTO_BLOWFISH
 	tristate "Blowfish cipher algorithm"
 	select CRYPTO_ALGAPI
@@ -336,28 +309,6 @@ config CRYPTO_AES_X86_64
 
 	  See <http://csrc.nist.gov/encryption/aes/> for more information.
 
-config CRYPTO_AES_S390
-	tristate "AES cipher algorithms (s390)"
-	depends on S390
-	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
-	help
-	  This is the s390 hardware accelerated implementation of the
-	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
-	  algorithm.
-
-	  Rijndael appears to be consistently a very good performer in
-	  both hardware and software across a wide range of computing
-	  environments regardless of its use in feedback or non-feedback
-	  modes. Its key setup time is excellent, and its key agility is
-	  good. Rijndael's very low memory requirements make it very well
-	  suited for restricted-space environments, in which it also
-	  demonstrates excellent performance. Rijndael's operations are
-	  among the easiest to defend against power and timing attacks.
-
-	  On s390 the System z9-109 currently only supports the key size
-	  of 128 bit.
-
 config CRYPTO_CAST5
 	tristate "CAST5 (CAST-128) cipher algorithm"
 	select CRYPTO_ALGAPI
