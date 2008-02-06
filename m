Return-Path: <linux-kernel-owner+w=401wt.eu-S1765523AbYBGAMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765523AbYBGAMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932079AbYBFX54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:57:56 -0500
Received: from ns2.suse.de ([195.135.220.15]:60843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764147AbYBFX5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:57:54 -0500
Date: Wed, 6 Feb 2008 15:53:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 38/73] CRYPTO: padlock: Fix spurious ECB page fault
Message-ID: <20080206235306.GM13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-padlock-fix-spurious-ecb-page-fault.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[CRYPTO] padlock: Fix spurious ECB page fault

[ Upstream commit: d4a7dd8e637b322faaa934ffcd6dd07711af831f ]
[ Upstream commit: 490fe3f05be3f7c87d7932bcb6e6e53e3db2cd9c ]

The xcryptecb instruction always processes an even number of blocks so
we need to ensure th existence of an extra block if we have to process
an odd number of blocks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/crypto/padlock-aes.c |   53 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 4 deletions(-)

--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -419,13 +419,58 @@ static int aes_set_key(struct crypto_tfm
 /* ====== Encryption/decryption routines ====== */
 
 /* These are the real call to PadLock. */
+static inline void padlock_xcrypt(const u8 *input, u8 *output, void *key,
+				  void *control_word)
+{
+	asm volatile (".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
+		      : "+S"(input), "+D"(output)
+		      : "d"(control_word), "b"(key), "c"(1));
+}
+
+static void aes_crypt_copy(const u8 *in, u8 *out, u32 *key, struct cword *cword)
+{
+	u8 buf[AES_BLOCK_SIZE * 2 + PADLOCK_ALIGNMENT - 1];
+	u8 *tmp = PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+
+	memcpy(tmp, in, AES_BLOCK_SIZE);
+	padlock_xcrypt(tmp, out, key, cword);
+}
+
+static inline void aes_crypt(const u8 *in, u8 *out, u32 *key,
+			     struct cword *cword)
+{
+	asm volatile ("pushfl; popfl");
+
+	/* padlock_xcrypt requires at least two blocks of data. */
+	if (unlikely(!(((unsigned long)in ^ (PAGE_SIZE - AES_BLOCK_SIZE)) &
+		       (PAGE_SIZE - 1)))) {
+		aes_crypt_copy(in, out, key, cword);
+		return;
+	}
+
+	padlock_xcrypt(in, out, key, cword);
+}
+
 static inline void padlock_xcrypt_ecb(const u8 *input, u8 *output, void *key,
 				      void *control_word, u32 count)
 {
+	if (count == 1) {
+		aes_crypt(input, output, key, control_word);
+		return;
+	}
+
 	asm volatile ("pushfl; popfl");		/* enforce key reload. */
-	asm volatile (".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
+	asm volatile ("test $1, %%cl;"
+		      "je 1f;"
+		      "lea -1(%%ecx), %%eax;"
+		      "mov $1, %%ecx;"
+		      ".byte 0xf3,0x0f,0xa7,0xc8;"	/* rep xcryptecb */
+		      "mov %%eax, %%ecx;"
+		      "1:"
+		      ".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
 		      : "+S"(input), "+D"(output)
-		      : "d"(control_word), "b"(key), "c"(count));
+		      : "d"(control_word), "b"(key), "c"(count)
+		      : "ax");
 }
 
 static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
@@ -443,13 +488,13 @@ static inline u8 *padlock_xcrypt_cbc(con
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
-	padlock_xcrypt_ecb(in, out, ctx->E, &ctx->cword.encrypt, 1);
+	aes_crypt(in, out, ctx->E, &ctx->cword.encrypt);
 }
 
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
-	padlock_xcrypt_ecb(in, out, ctx->D, &ctx->cword.decrypt, 1);
+	aes_crypt(in, out, ctx->D, &ctx->cword.decrypt);
 }
 
 static struct crypto_alg aes_alg = {

-- 
