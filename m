Return-Path: <linux-kernel-owner+w=401wt.eu-S1764944AbZGABIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764944AbZGABIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063AbZGAAfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:25 -0400
Received: from kroah.org ([198.145.64.141]:60558 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761528AbZGAAfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:37 2009
Message-Id: <20090701002436.682141659@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Huang Ying <ying.huang@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 075/108] crypto: aes-ni - Fix cbc mode IV saving
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=crypto-aes-ni-fix-cbc-mode-iv-saving.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Huang Ying <ying.huang@intel.com>

commit e6efaa025384f86a18814a6b9f4e5d54484ab9ff upstream.

Original implementation of aesni_cbc_dec do not save IV if input
length % 4 == 0. This will make decryption of next block failed.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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


