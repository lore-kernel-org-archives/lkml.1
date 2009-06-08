Return-Path: <linux-kernel-owner+w=401wt.eu-S1751264AbZFHRdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbZFHRdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbZFHRdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:33:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59324 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZFHRdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:33:05 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: s390 des3 - permit weak keys unless REQ_WEAK_KEY set
Date: Mon, 8 Jun 2009 13:32:09 -0400
User-Agent: KMail/1.11.3 (Linux/2.6.29.3-140.fc11.x86_64; KDE/4.2.3; x86_64; ; )
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081332.10608.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just started running fips cavs test vectors through an s390x system
for giggles, and discovered that I missed patching s390's arch-specific
des3 implementation w/an earlier des3 patch to permit weak keys.

This change adds the same flag tweaks as ad79cdd77fc1466e45cf923890f66bcfe7c43f12
for s390's des3 implementation, yields expected test results now.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 arch/s390/crypto/des_s390.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 4aba83b..2bc479a 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -250,8 +250,9 @@ static int des3_128_setkey(struct crypto_tfm *tfm, const u8 *key,
 	const u8 *temp_key = key;
 	u32 *flags = &tfm->crt_flags;
 
-	if (!(memcmp(key, &key[DES_KEY_SIZE], DES_KEY_SIZE))) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_SCHED;
+	if (!(memcmp(key, &key[DES_KEY_SIZE], DES_KEY_SIZE)) &&
+	    (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
 	for (i = 0; i < 2; i++, temp_key += DES_KEY_SIZE) {
@@ -411,9 +412,9 @@ static int des3_192_setkey(struct crypto_tfm *tfm, const u8 *key,
 
 	if (!(memcmp(key, &key[DES_KEY_SIZE], DES_KEY_SIZE) &&
 	    memcmp(&key[DES_KEY_SIZE], &key[DES_KEY_SIZE * 2],
-		   DES_KEY_SIZE))) {
-
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_SCHED;
+		   DES_KEY_SIZE)) &&
+	    (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
 	for (i = 0; i < 3; i++, temp_key += DES_KEY_SIZE) {

-- 
Jarod Wilson
jarod@redhat.com
