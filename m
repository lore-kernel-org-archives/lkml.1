Return-Path: <linux-kernel-owner+w=401wt.eu-S932483AbZKBW2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbZKBW2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932378AbZKBW2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:28:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277AbZKBW2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:28:18 -0500
Date: Mon, 2 Nov 2009 17:26:50 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: padlock-aes: Use the correct mask when checking
 whether copying is required
Message-ID: <20091102172650.6af2d177@katamari.usersys.redhat.com>
In-Reply-To: <20091028072559.GA15131@gondor.apana.org.au>
References: <200910272325.n9RNPYfr002918@int-mx08.intmail.prod.int.phx2.redhat.com>
	<20091028072559.GA15131@gondor.apana.org.au>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crypto: padlock-aes: Use the correct mask when checking whether copying is required

Masking with PAGE_SIZE is just wrong...

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- vanilla-2.6.31.orig/drivers/crypto/padlock-aes.c
+++ vanilla-2.6.31/drivers/crypto/padlock-aes.c
@@ -236,7 +236,7 @@ static inline void ecb_crypt(const u8 *i
 	/* Padlock in ECB mode fetches at least ecb_fetch_bytes of data.
 	 * We could avoid some copying here but it's probably not worth it.
 	 */
-	if (unlikely(((unsigned long)in & PAGE_SIZE) + ecb_fetch_bytes > PAGE_SIZE)) {
+	if (unlikely(((unsigned long)in & ~PAGE_MASK) + ecb_fetch_bytes > PAGE_SIZE)) {
 		ecb_crypt_copy(in, out, key, cword, count);
 		return;
 	}
@@ -248,7 +248,7 @@ static inline u8 *cbc_crypt(const u8 *in
 			    u8 *iv, struct cword *cword, int count)
 {
 	/* Padlock in CBC mode fetches at least cbc_fetch_bytes of data. */
-	if (unlikely(((unsigned long)in & PAGE_SIZE) + cbc_fetch_bytes > PAGE_SIZE))
+	if (unlikely(((unsigned long)in & ~PAGE_MASK) + cbc_fetch_bytes > PAGE_SIZE))
 		return cbc_crypt_copy(in, out, key, iv, cword, count);
 
 	return rep_xcrypt_cbc(in, out, key, iv, cword, count);
