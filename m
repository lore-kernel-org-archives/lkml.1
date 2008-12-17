Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756625AbYLQQow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYLQQow (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYLQQmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:42:14 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65211 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751968AbYLQQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:03 -0500
Message-Id: <20081217164036.848760163@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 17 Dec 2008 17:36:42 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 7/8] crypto: testmgr - swith deflate test to pcomp
Content-Disposition: inline; filename=crypto-convert-deflate-test-to-pcomp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Change the tests for the "deflate" crypto module from the "comp" to the "pcomp"
test framework.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.c |    4 ++--
 crypto/testmgr.h |   25 +++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 4 deletions(-)

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1389,9 +1389,9 @@ static const struct alg_test_desc alg_te
 		}
 	}, {
 		.alg = "deflate",
-		.test = alg_test_comp,
+		.test = alg_test_pcomp,
 		.suite = {
-			.comp = {
+			.pcomp = {
 				.comp = {
 					.vecs = deflate_comp_tv_template,
 					.count = DEFLATE_COMP_TEST_VECTORS
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15,6 +15,8 @@
 #ifndef _CRYPTO_TESTMGR_H
 #define _CRYPTO_TESTMGR_H
 
+#include <linux/zlib.h>
+
 #define MAX_DIGEST_SIZE		64
 #define MAX_TAP			8
 
@@ -8358,11 +8360,27 @@ struct pcomp_testvec {
  * Deflate test vectors (null-terminated strings).
  * Params: winbits=-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
  */
+
+static const struct deflate_comp_params deflate_comp_params = {
+	.enable_comp		= 1,
+	.windowBits		= -11,
+	.level			= Z_DEFAULT_COMPRESSION,
+	.method			= Z_DEFLATED,
+	.memLevel		= MAX_MEM_LEVEL,
+	.strategy		= Z_DEFAULT_STRATEGY
+};
+
+static const struct deflate_comp_params deflate_decomp_params = {
+	.enable_decomp		= 1,
+	.windowBits		= -11,
+};
+
 #define DEFLATE_COMP_TEST_VECTORS 2
 #define DEFLATE_DECOMP_TEST_VECTORS 2
 
-static struct comp_testvec deflate_comp_tv_template[] = {
+static struct pcomp_testvec deflate_comp_tv_template[] = {
 	{
+		.params = &deflate_comp_params,
 		.inlen	= 70,
 		.outlen	= 38,
 		.input	= "Join us now and share the software "
@@ -8373,6 +8391,7 @@ static struct comp_testvec deflate_comp_
 			  "\x48\x55\x28\xce\x4f\x2b\x29\x07"
 			  "\x71\xbc\x08\x2b\x01\x00",
 	}, {
+		.params = &deflate_comp_params,
 		.inlen	= 191,
 		.outlen	= 122,
 		.input	= "This document describes a compression method based on the DEFLATE"
@@ -8397,8 +8416,9 @@ static struct comp_testvec deflate_comp_
 	},
 };
 
-static struct comp_testvec deflate_decomp_tv_template[] = {
+static struct pcomp_testvec deflate_decomp_tv_template[] = {
 	{
+		.params = &deflate_decomp_params,
 		.inlen	= 122,
 		.outlen	= 191,
 		.input	= "\x5d\x8d\x31\x0e\xc2\x30\x10\x04"
@@ -8421,6 +8441,7 @@ static struct comp_testvec deflate_decom
 			"compression algorithm.  This document defines the application of "
 			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
 	}, {
+		.params = &deflate_decomp_params,
 		.inlen	= 38,
 		.outlen	= 70,
 		.input	= "\xf3\xca\xcf\xcc\x53\x28\x2d\x56"

-- 
With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010

