Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZJUUp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZJUUp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZJUUpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:45:24 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39437 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbZJUUpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Rmqm6eH+stcKQ711sf4nyBcMRh6huSBIO51FDTUbmQhK1zrBCZcwlcV7hY4+77tLOf
         vlqrJ02FAzdD2qxAX/+hQzlWNBVM18fDeJYSZJFTL+NCgigY2kF8fFv68UiBviJSiyhi
         b9NCbmyASlSzlp94OlqKkSf18Rlol1f8P0ziY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:45:02 +0200
Message-Id: <20091021204502.4593.32197.sendpatchset@localhost.localdomain>
In-Reply-To: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
References: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/12] Staging: rt28x0: remove unused SHA256 code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: remove unused SHA256 code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/crypt_hmac.c |   85 ---------
 drivers/staging/rt2860/common/crypt_sha2.c |  257 -----------------------------
 drivers/staging/rt2860/crypt_hmac.h        |   11 -
 drivers/staging/rt2860/crypt_sha2.h        |   28 ---
 4 files changed, 381 deletions(-)

Index: b/drivers/staging/rt2860/common/crypt_hmac.c
===================================================================
--- a/drivers/staging/rt2860/common/crypt_hmac.c
+++ b/drivers/staging/rt2860/common/crypt_hmac.c
@@ -109,91 +109,6 @@ VOID HMAC_SHA1 (
 } /* End of HMAC_SHA1 */
 #endif /* HMAC_SHA1_SUPPORT */
 
-
-#ifdef HMAC_SHA256_SUPPORT
-/*
-========================================================================
-Routine Description:
-    HMAC using SHA256 hash function
-
-Arguments:
-    key             Secret key
-    key_len         The length of the key in bytes
-    message         Message context
-    message_len     The length of message in bytes
-    macLen          Request the length of message authentication code
-
-Return Value:
-    mac             Message authentication code
-
-Note:
-    None
-========================================================================
-*/
-VOID HMAC_SHA256 (
-    IN  const UINT8 Key[],
-    IN  UINT KeyLen,
-    IN  const UINT8 Message[],
-    IN  UINT MessageLen,
-    OUT UINT8 MAC[],
-    IN  UINT MACLen)
-{
-    SHA256_CTX_STRUC sha_ctx1;
-    SHA256_CTX_STRUC sha_ctx2;
-    UINT8 K0[SHA256_BLOCK_SIZE];
-    UINT8 Digest[SHA256_DIGEST_SIZE];
-    UINT index;
-
-    NdisZeroMemory(&sha_ctx1, sizeof(SHA256_CTX_STRUC));
-    NdisZeroMemory(&sha_ctx2, sizeof(SHA256_CTX_STRUC));
-    /*
-     * If the length of K = B(Block size): K0 = K.
-     * If the length of K > B: hash K to obtain an L byte string,
-     * then append (B-L) zeros to create a B-byte string K0 (i.e., K0 = H(K) || 00...00).
-     * If the length of K < B: append zeros to the end of K to create a B-byte string K0
-     */
-    NdisZeroMemory(K0, SHA256_BLOCK_SIZE);
-    if (KeyLen <= SHA256_BLOCK_SIZE) {
-        NdisMoveMemory(K0, Key, KeyLen);
-    } else {
-        RT_SHA256(Key, KeyLen, K0);
-    }
-
-    /* Exclusive-Or K0 with ipad */
-    /* ipad: Inner pad; the byte x・36・ repeated B times. */
-    for (index = 0; index < SHA256_BLOCK_SIZE; index++)
-        K0[index] ^= 0x36;
-        /* End of for */
-
-    SHA256_Init(&sha_ctx1);
-    /* H(K0^ipad) */
-    SHA256_Append(&sha_ctx1, K0, sizeof(K0));
-    /* H((K0^ipad)||text) */
-    SHA256_Append(&sha_ctx1, Message, MessageLen);
-    SHA256_End(&sha_ctx1, Digest);
-
-    /* Exclusive-Or K0 with opad and remove ipad */
-    /* opad: Outer pad; the byte x・5c・ repeated B times. */
-    for (index = 0; index < SHA256_BLOCK_SIZE; index++)
-        K0[index] ^= 0x36^0x5c;
-        /* End of for */
-
-    SHA256_Init(&sha_ctx2);
-    /* H(K0^opad) */
-    SHA256_Append(&sha_ctx2, K0, sizeof(K0));
-    /* H( (K0^opad) || H((K0^ipad)||text) ) */
-    SHA256_Append(&sha_ctx2, Digest, SHA256_DIGEST_SIZE);
-    SHA256_End(&sha_ctx2, Digest);
-
-    if (MACLen > SHA256_DIGEST_SIZE)
-        NdisMoveMemory(MAC, Digest,SHA256_DIGEST_SIZE);
-    else
-        NdisMoveMemory(MAC, Digest, MACLen);
-
-} /* End of HMAC_SHA256 */
-#endif /* HMAC_SHA256_SUPPORT */
-
-
 #ifdef HMAC_MD5_SUPPORT
 /*
 ========================================================================
Index: b/drivers/staging/rt2860/common/crypt_sha2.c
===================================================================
--- a/drivers/staging/rt2860/common/crypt_sha2.c
+++ b/drivers/staging/rt2860/common/crypt_sha2.c
@@ -47,42 +47,7 @@ static const UINT32 SHA1_K[4] = {
 static const UINT32 SHA1_DefaultHashValue[5] = {
     0x67452301UL, 0xefcdab89UL, 0x98badcfeUL, 0x10325476UL, 0xc3d2e1f0UL
 };
-#endif /* SHA1_SUPPORT */
-
-
-#ifdef SHA256_SUPPORT
-/* SHA256 functions */
-#define Zsigma_256_0(x) (ROTR32(x,2) ^ ROTR32(x,13) ^ ROTR32(x,22))
-#define Zsigma_256_1(x) (ROTR32(x,6) ^ ROTR32(x,11) ^ ROTR32(x,25))
-#define Sigma_256_0(x)  (ROTR32(x,7) ^ ROTR32(x,18) ^ SHR(x,3))
-#define Sigma_256_1(x)  (ROTR32(x,17) ^ ROTR32(x,19) ^ SHR(x,10))
-/* SHA256 constants */
-static const UINT32 SHA256_K[64] = {
-    0x428a2f98UL, 0x71374491UL, 0xb5c0fbcfUL, 0xe9b5dba5UL,
-    0x3956c25bUL, 0x59f111f1UL, 0x923f82a4UL, 0xab1c5ed5UL,
-    0xd807aa98UL, 0x12835b01UL, 0x243185beUL, 0x550c7dc3UL,
-    0x72be5d74UL, 0x80deb1feUL, 0x9bdc06a7UL, 0xc19bf174UL,
-    0xe49b69c1UL, 0xefbe4786UL, 0x0fc19dc6UL, 0x240ca1ccUL,
-    0x2de92c6fUL, 0x4a7484aaUL, 0x5cb0a9dcUL, 0x76f988daUL,
-    0x983e5152UL, 0xa831c66dUL, 0xb00327c8UL, 0xbf597fc7UL,
-    0xc6e00bf3UL, 0xd5a79147UL, 0x06ca6351UL, 0x14292967UL,
-    0x27b70a85UL, 0x2e1b2138UL, 0x4d2c6dfcUL, 0x53380d13UL,
-    0x650a7354UL, 0x766a0abbUL, 0x81c2c92eUL, 0x92722c85UL,
-    0xa2bfe8a1UL, 0xa81a664bUL, 0xc24b8b70UL, 0xc76c51a3UL,
-    0xd192e819UL, 0xd6990624UL, 0xf40e3585UL, 0x106aa070UL,
-    0x19a4c116UL, 0x1e376c08UL, 0x2748774cUL, 0x34b0bcb5UL,
-    0x391c0cb3UL, 0x4ed8aa4aUL, 0x5b9cca4fUL, 0x682e6ff3UL,
-    0x748f82eeUL, 0x78a5636fUL, 0x84c87814UL, 0x8cc70208UL,
-    0x90befffaUL, 0xa4506cebUL, 0xbef9a3f7UL, 0xc67178f2UL
-};
-static const UINT32 SHA256_DefaultHashValue[8] = {
-    0x6a09e667UL, 0xbb67ae85UL, 0x3c6ef372UL, 0xa54ff53aUL,
-    0x510e527fUL, 0x9b05688cUL, 0x1f83d9abUL, 0x5be0cd19UL
-};
-#endif /* SHA256_SUPPORT */
 
-
-#ifdef SHA1_SUPPORT
 /*
 ========================================================================
 Routine Description:
@@ -310,226 +275,4 @@ VOID RT_SHA1 (
 } /* End of RT_SHA1 */
 #endif /* SHA1_SUPPORT */
 
-
-#ifdef SHA256_SUPPORT
-/*
-========================================================================
-Routine Description:
-    Initial SHA256_CTX_STRUC
-
-Arguments:
-    pSHA_CTX    Pointer to SHA256_CTX_STRUC
-
-Return Value:
-    None
-
-Note:
-    None
-========================================================================
-*/
-VOID SHA256_Init (
-    IN  SHA256_CTX_STRUC *pSHA_CTX)
-{
-    NdisMoveMemory(pSHA_CTX->HashValue, SHA256_DefaultHashValue,
-        sizeof(SHA256_DefaultHashValue));
-    NdisZeroMemory(pSHA_CTX->Block, SHA256_BLOCK_SIZE);
-    pSHA_CTX->MessageLen = 0;
-    pSHA_CTX->BlockLen   = 0;
-} /* End of SHA256_Init */
-
-
-/*
-========================================================================
-Routine Description:
-    SHA256 computation for one block (512 bits)
-
-Arguments:
-    pSHA_CTX    Pointer to SHA256_CTX_STRUC
-
-Return Value:
-    None
-
-Note:
-    None
-========================================================================
-*/
-VOID SHA256_Hash (
-    IN  SHA256_CTX_STRUC *pSHA_CTX)
-{
-    UINT32 W_i,t;
-    UINT32 W[64];
-    UINT32 a,b,c,d,e,f,g,h,T1,T2;
-
-    /* Prepare the message schedule, {W_i}, 0 < t < 15 */
-    NdisMoveMemory(W, pSHA_CTX->Block, SHA256_BLOCK_SIZE);
-    for (W_i = 0; W_i < 16; W_i++)
-        W[W_i] = cpu2be32(W[W_i]); /* Endian Swap */
-        /* End of for */
-
-    /* SHA256 hash computation */
-    /* Initialize the working variables */
-    a = pSHA_CTX->HashValue[0];
-    b = pSHA_CTX->HashValue[1];
-    c = pSHA_CTX->HashValue[2];
-    d = pSHA_CTX->HashValue[3];
-    e = pSHA_CTX->HashValue[4];
-    f = pSHA_CTX->HashValue[5];
-    g = pSHA_CTX->HashValue[6];
-    h = pSHA_CTX->HashValue[7];
-
-    /* 64 rounds */
-    for (t = 0;t < 64;t++) {
-        if (t > 15) /* Prepare the message schedule, {W_i}, 16 < t < 63 */
-            W[t] = Sigma_256_1(W[t-2]) + W[t-7] + Sigma_256_0(W[t-15]) + W[t-16];
-            /* End of if */
-        T1 = h + Zsigma_256_1(e) + Ch(e,f,g) + SHA256_K[t] + W[t];
-        T2 = Zsigma_256_0(a) + Maj(a,b,c);
-        h = g;
-        g = f;
-        f = e;
-        e = d + T1;
-        d = c;
-        c = b;
-        b = a;
-        a = T1 + T2;
-     } /* End of for */
-
-     /* Compute the i^th intermediate hash value H^(i) */
-     pSHA_CTX->HashValue[0] += a;
-     pSHA_CTX->HashValue[1] += b;
-     pSHA_CTX->HashValue[2] += c;
-     pSHA_CTX->HashValue[3] += d;
-     pSHA_CTX->HashValue[4] += e;
-     pSHA_CTX->HashValue[5] += f;
-     pSHA_CTX->HashValue[6] += g;
-     pSHA_CTX->HashValue[7] += h;
-
-    NdisZeroMemory(pSHA_CTX->Block, SHA256_BLOCK_SIZE);
-    pSHA_CTX->BlockLen = 0;
-} /* End of SHA256_Hash */
-
-
-/*
-========================================================================
-Routine Description:
-    The message is appended to block. If block size > 64 bytes, the SHA256_Hash
-will be called.
-
-Arguments:
-    pSHA_CTX    Pointer to SHA256_CTX_STRUC
-    message     Message context
-    messageLen  The length of message in bytes
-
-Return Value:
-    None
-
-Note:
-    None
-========================================================================
-*/
-VOID SHA256_Append (
-    IN  SHA256_CTX_STRUC *pSHA_CTX,
-    IN  const UINT8 Message[],
-    IN  UINT MessageLen)
-{
-    UINT appendLen = 0;
-    UINT diffLen   = 0;
-
-    while (appendLen != MessageLen) {
-        diffLen = MessageLen - appendLen;
-        if ((pSHA_CTX->BlockLen + diffLen) <  SHA256_BLOCK_SIZE) {
-            NdisMoveMemory(pSHA_CTX->Block + pSHA_CTX->BlockLen,
-                Message + appendLen, diffLen);
-            pSHA_CTX->BlockLen += diffLen;
-            appendLen += diffLen;
-        }
-        else
-        {
-            NdisMoveMemory(pSHA_CTX->Block + pSHA_CTX->BlockLen,
-                Message + appendLen, SHA256_BLOCK_SIZE - pSHA_CTX->BlockLen);
-            appendLen += (SHA256_BLOCK_SIZE - pSHA_CTX->BlockLen);
-            pSHA_CTX->BlockLen = SHA256_BLOCK_SIZE;
-            SHA256_Hash(pSHA_CTX);
-        } /* End of if */
-    } /* End of while */
-    pSHA_CTX->MessageLen += MessageLen;
-} /* End of SHA256_Append */
-
-
-/*
-========================================================================
-Routine Description:
-    1. Append bit 1 to end of the message
-    2. Append the length of message in rightmost 64 bits
-    3. Transform the Hash Value to digest message
-
-Arguments:
-    pSHA_CTX        Pointer to SHA256_CTX_STRUC
-
-Return Value:
-    digestMessage   Digest message
-
-Note:
-    None
-========================================================================
-*/
-VOID SHA256_End (
-    IN  SHA256_CTX_STRUC *pSHA_CTX,
-    OUT UINT8 DigestMessage[])
-{
-    UINT index;
-    UINT64 message_length_bits;
-
-    /* Append bit 1 to end of the message */
-    NdisFillMemory(pSHA_CTX->Block + pSHA_CTX->BlockLen, 1, 0x80);
-
-    /* 55 = 64 - 8 - 1: append 1 bit(1 byte) and message length (8 bytes) */
-    if (pSHA_CTX->BlockLen > 55)
-        SHA256_Hash(pSHA_CTX);
-        /* End of if */
-
-    /* Append the length of message in rightmost 64 bits */
-    message_length_bits = pSHA_CTX->MessageLen*8;
-    message_length_bits = cpu2be64(message_length_bits);
-    NdisMoveMemory(&pSHA_CTX->Block[56], &message_length_bits, 8);
-    SHA256_Hash(pSHA_CTX);
-
-    /* Return message digest, transform the UINT32 hash value to bytes */
-    for (index = 0; index < 8;index++)
-        pSHA_CTX->HashValue[index] = cpu2be32(pSHA_CTX->HashValue[index]);
-        /* End of for */
-    NdisMoveMemory(DigestMessage, pSHA_CTX->HashValue, SHA256_DIGEST_SIZE);
-} /* End of SHA256_End */
-
-
-/*
-========================================================================
-Routine Description:
-    SHA256 algorithm
-
-Arguments:
-    message         Message context
-    messageLen      The length of message in bytes
-
-Return Value:
-    digestMessage   Digest message
-
-Note:
-    None
-========================================================================
-*/
-VOID RT_SHA256 (
-    IN  const UINT8 Message[],
-    IN  UINT MessageLen,
-    OUT UINT8 DigestMessage[])
-{
-    SHA256_CTX_STRUC sha_ctx;
-
-    NdisZeroMemory(&sha_ctx, sizeof(SHA256_CTX_STRUC));
-    SHA256_Init(&sha_ctx);
-    SHA256_Append(&sha_ctx, Message, MessageLen);
-    SHA256_End(&sha_ctx, DigestMessage);
-} /* End of RT_SHA256 */
-#endif /* SHA256_SUPPORT */
-
 /* End of crypt_sha2.c */
Index: b/drivers/staging/rt2860/crypt_hmac.h
===================================================================
--- a/drivers/staging/rt2860/crypt_hmac.h
+++ b/drivers/staging/rt2860/crypt_hmac.h
@@ -57,17 +57,6 @@ VOID HMAC_SHA1 (
     IN  UINT MACLen);
 #endif /* SHA1_SUPPORT */
 
-#ifdef SHA256_SUPPORT
-#define HMAC_SHA256_SUPPORT
-VOID HMAC_SHA256 (
-    IN  const UINT8 Key[],
-    IN  UINT KeyLen,
-    IN  const UINT8 Message[],
-    IN  UINT MessageLen,
-    OUT UINT8 MAC[],
-    IN  UINT MACLen);
-#endif /* SHA256_SUPPORT */
-
 #ifdef MD5_SUPPORT
 #define HMAC_MD5_SUPPORT
 VOID HMAC_MD5 (
Index: b/drivers/staging/rt2860/crypt_sha2.h
===================================================================
--- a/drivers/staging/rt2860/crypt_sha2.h
+++ b/drivers/staging/rt2860/crypt_sha2.h
@@ -50,7 +50,6 @@
 
 /* Algorithm options */
 #define SHA1_SUPPORT
-#define SHA256_SUPPORT
 
 #ifdef SHA1_SUPPORT
 #define SHA1_BLOCK_SIZE    64 /* 512 bits = 64 bytes */
@@ -79,31 +78,4 @@ VOID RT_SHA1 (
     OUT UINT8 DigestMessage[]);
 #endif /* SHA1_SUPPORT */
 
-#ifdef SHA256_SUPPORT
-#define SHA256_BLOCK_SIZE   64 /* 512 bits = 64 bytes */
-#define SHA256_DIGEST_SIZE  32 /* 256 bits = 32 bytes */
-typedef struct _SHA256_CTX_STRUC {
-    UINT32 HashValue[8];  /* 8 = (SHA256_DIGEST_SIZE / 32) */
-    UINT64 MessageLen;    /* total size */
-    UINT8  Block[SHA256_BLOCK_SIZE];
-    UINT   BlockLen;
-} SHA256_CTX_STRUC, *PSHA256_CTX_STRUC;
-
-VOID SHA256_Init (
-    IN  SHA256_CTX_STRUC *pSHA_CTX);
-VOID SHA256_Hash (
-    IN  SHA256_CTX_STRUC *pSHA_CTX);
-VOID SHA256_Append (
-    IN  SHA256_CTX_STRUC *pSHA_CTX,
-    IN  const UINT8 Message[],
-    IN  UINT MessageLen);
-VOID SHA256_End (
-    IN  SHA256_CTX_STRUC *pSHA_CTX,
-    OUT UINT8 DigestMessage[]);
-VOID RT_SHA256 (
-    IN  const UINT8 Message[],
-    IN  UINT MessageLen,
-    OUT UINT8 DigestMessage[]);
-#endif /* SHA256_SUPPORT */
-
 #endif /* __CRYPT_SHA2_H__ */
