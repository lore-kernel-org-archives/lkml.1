Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbZJ0X0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbZJ0X0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 19:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZJ0X0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 19:26:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621AbZJ0X0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 19:26:11 -0400
Message-Id: <200910272325.n9RNPYfr002918@int-mx08.intmail.prod.int.phx2.redhat.com>
Date: Tue, 27 Oct 2009 19:25:33 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: padlock-aes: Use the correct mask when checking
 whether copying is required
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crypto: padlock-aes: Use the correct mask when checking whether copying is required

Masking with PAGE_SIZE is just wrong... and there's no need for the braces and return
statement either.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

---
Can we get this in 2.6.32 and -stable? It fixes a fatal oops in the driver.

--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -236,19 +236,17 @@ static inline void ecb_crypt(const u8 *i
 	/* Padlock in ECB mode fetches at least ecb_fetch_bytes of data.
 	 * We could avoid some copying here but it's probably not worth it.
 	 */
-	if (unlikely(((unsigned long)in & PAGE_SIZE) + ecb_fetch_bytes > PAGE_SIZE)) {
+	if (unlikely(((unsigned long)in & ~PAGE_MASK) + ecb_fetch_bytes > PAGE_SIZE))
 		ecb_crypt_copy(in, out, key, cword, count);
-		return;
-	}
-
-	rep_xcrypt_ecb(in, out, key, cword, count);
+	else
+		rep_xcrypt_ecb(in, out, key, cword, count);
 }
 
 static inline u8 *cbc_crypt(const u8 *in, u8 *out, u32 *key,
 			    u8 *iv, struct cword *cword, int count)
 {
 	/* Padlock in CBC mode fetches at least cbc_fetch_bytes of data. */
-	if (unlikely(((unsigned long)in & PAGE_SIZE) + cbc_fetch_bytes > PAGE_SIZE))
+	if (unlikely(((unsigned long)in & ~PAGE_MASK) + cbc_fetch_bytes > PAGE_SIZE))
 		return cbc_crypt_copy(in, out, key, iv, cword, count);
 
 	return rep_xcrypt_cbc(in, out, key, iv, cword, count);
