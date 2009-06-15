Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbZFOJEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbZFOJEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZFOJEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:04:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:27133 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbZFOJEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:04:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,221,1243839600"; 
   d="scan'208";a="466378061"
Subject: [BUGFIX 1/3] crypto: Fix AES-NI cbc mode IV saving
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain
Date: Mon, 15 Jun 2009 17:04:44 +0800
Message-Id: <1245056684.5320.347.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original implementation of aesni_cbc_dec do not save IV if input
length % 4 == 0. This will make decryption of next block failed.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/aesni-intel_asm.S |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -845,7 +845,7 @@ ENTRY(aesni_cbc_enc)
  */
 ENTRY(aesni_cbc_dec)
 	cmp $16, LEN
-	jb .Lcbc_dec_ret
+	jb .Lcbc_dec_just_ret
 	mov 480(KEYP), KLEN
 	add $240, KEYP
 	movups (IVP), IV
@@ -891,6 +891,7 @@ ENTRY(aesni_cbc_dec)
 	add $16, OUTP
 	cmp $16, LEN
 	jge .Lcbc_dec_loop1
-	movups IV, (IVP)
 .Lcbc_dec_ret:
+	movups IV, (IVP)
+.Lcbc_dec_just_ret:
 	ret


