Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab0BYPKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:10:36 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36136 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204Ab0BYPKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:10:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ezhnMl2CQeJWGXywulLaKbYbWak9tKVTRxr4iCj+XktyCl2C3mgR/H3lbcdwIG1N1S
         f7DGFpcVz/N2ieDIas1vlXZIMDnS7CrkaTFJbPrP3g61s9DRXWzdd2ceuHNPYJPPMvRa
         AZBEaO+jwILODKqxVD6zPch4e2/HUVJWsdW64=
Message-ID: <4B8692E3.9030509@gmail.com>
Date: Thu, 25 Feb 2010 16:10:27 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>,
       Mikael Pettersson <mikpe@it.uu.se>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sha: prevent removal of memset as dead store in sha1_update()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to optimization A call to memset() may be removed as a dead store when
the buffer is not used after its value is overwritten.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
see http://cwe.mitre.org/data/slices/2000.html#14

checkpatch.pl, compile and sparse tested. Comments?

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 0416091..86de0da 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -49,8 +49,8 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 	src = data;
 
 	if ((partial + len) > 63) {
-		u32 temp[SHA_WORKSPACE_WORDS];
-
+		u32 *temp = kzalloc(SHA_WORKSPACE_WORDS * sizeof(u32),
+				GFP_KERNEL);
 		if (partial) {
 			done = -partial;
 			memcpy(sctx->buffer + partial, data, done + 64);
@@ -64,6 +64,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 		} while (done + 63 < len);
 
 		memset(temp, 0, sizeof(temp));
+		kfree(temp);
 		partial = 0;
 	}
 	memcpy(sctx->buffer + partial, src, len - done);
