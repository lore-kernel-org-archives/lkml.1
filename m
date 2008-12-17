Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755318AbYLQQnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYLQQnd (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYLQQmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:42:07 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65194 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751411AbYLQQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:03 -0500
Message-Id: <20081217164036.660327919@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 17 Dec 2008 17:36:39 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 4/8] crypto: api - Add type init function to crypto_tfm
Content-Disposition: inline; filename=crypto-add-tfm-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Add a type init function to crypto_tfm, so transforms can override the default
action of calling the algorithm's cra_init() method.

This will be used by the "comp" compatibility layer for the "pcomp" type, which
needs to call the algorithm's coa_setup() method, in addition to the cra_init()
method.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/api.c           |   20 ++++++++++++++++----
 include/linux/crypto.h |    1 +
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/crypto/api.c
+++ b/crypto/api.c
@@ -390,8 +390,14 @@ struct crypto_tfm *__crypto_alloc_tfm(st
 	if (err)
 		goto out_free_tfm;
 
-	if (!tfm->exit && alg->cra_init && (err = alg->cra_init(tfm)))
-		goto cra_init_failed;
+	if (!tfm->exit) {
+		if (tfm->init)
+			err = tfm->init(tfm);
+		else if (alg->cra_init)
+			err = alg->cra_init(tfm);
+		if (err)
+			goto cra_init_failed;
+	}
 
 	goto out;
 
@@ -487,8 +493,14 @@ struct crypto_tfm *crypto_create_tfm(str
 	if (err)
 		goto out_free_tfm;
 
-	if (!tfm->exit && alg->cra_init && (err = alg->cra_init(tfm)))
-		goto cra_init_failed;
+	if (!tfm->exit) {
+		if (tfm->init)
+			err = tfm->init(tfm);
+		else if (alg->cra_init)
+			err = alg->cra_init(tfm);
+		if (err)
+			goto cra_init_failed;
+	}
 
 	goto out;
 
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -527,6 +527,7 @@ struct crypto_tfm {
 		struct rng_tfm rng;
 	} crt_u;
 
+	int (*init)(struct crypto_tfm *tfm);
 	void (*exit)(struct crypto_tfm *tfm);
 	
 	struct crypto_alg *__crt_alg;

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

