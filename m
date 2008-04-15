Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbYDOTQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbYDOTQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYDOTQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:16:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:29878 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbYDOTQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=shZEZxJCV67HZm5qkmKJpSFqKJS/E0mVOxndwDxsjWj64b8Q14kEaIRFPh2+8CteBEaaLvAxXmrkFuse7p+NPX5KUrPTis+65iyr9XsImTPGBz+htbOddH6hKp0bh5hka0gj94X4hVKtIKOE05Zv0++3Kp2U6OMEvpjRF67vGOM=
Subject: [PATCH] crypto: padlock-aes.c replace private copy of bit rotation
	routines
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 12:16:03 -0700
Message-Id: <1208286963.11920.90.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic kernel implementation of the bit-rotation routines.
The generic routines to not shift by mod 32, but all callers in the
file pass constant values less than 32 making this a non-issue.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/crypto/padlock-aes.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 2f3ad3f..84adbc0 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -45,6 +45,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -86,22 +87,8 @@ struct aes_ctx {
 
 /* ====== Key management routines ====== */
 
-static inline uint32_t
-generic_rotr32 (const uint32_t x, const unsigned bits)
-{
-	const unsigned n = bits % 32;
-	return (x >> n) | (x << (32 - n));
-}
-
-static inline uint32_t
-generic_rotl32 (const uint32_t x, const unsigned bits)
-{
-	const unsigned n = bits % 32;
-	return (x << n) | (x >> (32 - n));
-}
-
-#define rotl generic_rotl32
-#define rotr generic_rotr32
+#define rotl rol32
+#define rotr ror32
 
 /*
  * #define byte(x, nr) ((unsigned char)((x) >> (nr*8))) 
-- 
1.5.5.144.g3e42



