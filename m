Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbZLGAOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbZLGAOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934400AbZLGAOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:14:11 -0500
Received: from kroah.org ([198.145.64.141]:34759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758629AbZLGAOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:59 2009
Message-Id: <20091207000659.115840319@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [105/119] crypto: padlock-aes - Use the correct mask when checking whether copying is required
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=crypto-padlock-aes-use-the-correct-mask-when-checking-whether-copying-is-required.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chuck Ebbert <cebbert@redhat.com>

commit e8edb3cbd7dd8acf6c748a02d06ec1d82c4124ea upstream.

Masking with PAGE_SIZE is just wrong...

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/crypto/padlock-aes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
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


