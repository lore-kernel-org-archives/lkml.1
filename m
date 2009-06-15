Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbZFOJFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbZFOJFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758009AbZFOJE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:04:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:37942 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZFOJE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:04:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,221,1243839600"; 
   d="scan'208";a="421862342"
Subject: [BUGFIX 2/3] crypto: Remove CRYPTO_TFM_REQ_MAY_SLEEP flag in
 AES-NI accelerated ecb/cbc mode
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain
Date: Mon, 15 Jun 2009 17:04:57 +0800
Message-Id: <1245056697.5320.350.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because AES-NI instructions will touch XMM state, corresponding code
must be enclosed within kernel_fpu_begin/end, which used
preempt_disable/enable. So sleep should be prevented between
kernel_fpu_begin/end.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/aesni-intel_glue.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -198,6 +198,7 @@ static int ecb_encrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
@@ -221,6 +222,7 @@ static int ecb_decrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
@@ -266,6 +268,7 @@ static int cbc_encrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
@@ -289,6 +292,7 @@ static int cbc_decrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {


