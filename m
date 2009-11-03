Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZKCCpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZKCCpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 21:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbZKCCpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 21:45:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:12746 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568AbZKCCpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 21:45:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,671,1249282800"; 
   d="scan'208";a="463794691"
Subject: [BUGFIX for crypto-dev] crypto, Fix irq_fpu_usable usage in
 clmulni-intel
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Nov 2009 10:45:46 +0800
Message-Id: <1257216346.30470.1188.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When renaming kernel_fpu_using to irq_fpu_usable, the semantics of the
function is changed too, from mesuring whether kernel is using FPU,
that is, the FPU is NOT available, to measuring whether FPU is usable,
that is, the FPU is available.

But the usage of irq_fpu_usable in ghash-clmulni-intel_glue.c is not
changed accordingly. This patch fixes this.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -159,7 +159,7 @@ static int ghash_async_init(struct ahash
 	struct ahash_request *cryptd_req = ahash_request_ctx(req);
 	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
 
-	if (irq_fpu_usable()) {
+	if (!irq_fpu_usable()) {
 		memcpy(cryptd_req, req, sizeof(*req));
 		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
 		return crypto_ahash_init(cryptd_req);
@@ -177,7 +177,7 @@ static int ghash_async_update(struct aha
 {
 	struct ahash_request *cryptd_req = ahash_request_ctx(req);
 
-	if (irq_fpu_usable()) {
+	if (!irq_fpu_usable()) {
 		struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 		struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
 		struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
@@ -195,7 +195,7 @@ static int ghash_async_final(struct ahas
 {
 	struct ahash_request *cryptd_req = ahash_request_ctx(req);
 
-	if (irq_fpu_usable()) {
+	if (!irq_fpu_usable()) {
 		struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 		struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
 		struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
@@ -216,7 +216,7 @@ static int ghash_async_digest(struct aha
 	struct ahash_request *cryptd_req = ahash_request_ctx(req);
 	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
 
-	if (irq_fpu_usable()) {
+	if (!irq_fpu_usable()) {
 		memcpy(cryptd_req, req, sizeof(*req));
 		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
 		return crypto_ahash_digest(cryptd_req);


