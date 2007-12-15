Return-Path: <linux-kernel-owner+w=401wt.eu-S1762140AbXLOHNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762140AbXLOHNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXLOHNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:13:34 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3084 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752469AbXLOHNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:13:33 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jreiser@BitWagon.com (John Reiser), akpm@linux-foundation.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Cc: tytso@mit.edu, mpm@selenic.com, linux-kernel@vger.kernel.org,
       security@kernel.org
Organization: Core
In-Reply-To: <47632010.6030709@BitWagon.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J3RD5-0006yU-00@gondolin.me.apana.org.au>
Date: Sat, 15 Dec 2007 15:13:19 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Reiser <jreiser@bitwagon.com> wrote:
>
> If speed matters that much, then please recoup 33 cycles on x86
> by using shifts instead of three divides, such as (gcc 4.1.2):
> 
>                add_entropy_words(r, tmp, (bytes + 3) / 4);
> 
> 0x8140689 <xfer_secondary_pool+206>:    lea    0x3(%esi),%eax
> 0x814068c <xfer_secondary_pool+209>:    mov    $0x4,%dl
> 0x814068e <xfer_secondary_pool+211>:    mov    %edx,%edi
> 0x8140690 <xfer_secondary_pool+213>:    cltd
> 0x8140691 <xfer_secondary_pool+214>:    idiv   %edi

There ought to be a warning about this sort of thing.

[CHAR] random: Avoid signed integer division

Joihn Reiser pointed out that we use signed integer divisions
unnecessarily in random.c.  This is bad because the C compiler
is obliged to consider the case of a negative dividend.

This patch changes all the relevant divisions and modulus operations
to use unsigned arithmetic.

Signed-off: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5fee056..6c70bfb 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -694,11 +694,11 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 	if (r->pull && r->entropy_count < nbytes * 8 &&
 	    r->entropy_count < r->poolinfo->POOLBITS) {
 		/* If we're limited, always leave two wakeup worth's BITS */
-		int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
+		int rsvd = r->limit ? 0 : random_read_wakeup_thresh / 4u;
 		int bytes = nbytes;
 
 		/* pull at least as many as BYTES as wakeup BITS */
-		bytes = max_t(int, bytes, random_read_wakeup_thresh / 8);
+		bytes = max_t(int, bytes, random_read_wakeup_thresh / 8u);
 		/* but never more than the buffer size */
 		bytes = min_t(int, bytes, sizeof(tmp));
 
@@ -707,8 +707,8 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
 		bytes=extract_entropy(r->pull, tmp, bytes,
-				      random_read_wakeup_thresh / 8, rsvd);
-		add_entropy_words(r, tmp, (bytes + 3) / 4);
+				      random_read_wakeup_thresh / 8u, rsvd);
+		add_entropy_words(r, tmp, (bytes + 3) / 4u);
 		credit_entropy_store(r, bytes*8);
 	}
 }
@@ -739,14 +739,14 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		  nbytes * 8, r->name);
 
 	/* Can we pull enough? */
-	if (r->entropy_count / 8 < min + reserved) {
+	if (r->entropy_count / 8u < min + reserved) {
 		nbytes = 0;
 	} else {
 		/* If limited, never pull more than available */
-		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
-			nbytes = r->entropy_count/8 - reserved;
+		if (r->limit && nbytes + reserved >= r->entropy_count / 8u)
+			nbytes = r->entropy_count / 8u - reserved;
 
-		if(r->entropy_count / 8 >= nbytes + reserved)
+		if(r->entropy_count / 8u >= nbytes + reserved)
 			r->entropy_count -= nbytes*8;
 		else
 			r->entropy_count = reserved;
@@ -781,7 +781,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 		/* hash blocks of 16 words = 512 bits */
 		sha_transform(buf, (__u8 *)(r->pool + i), buf + 5);
 		/* feed back portion of the resulting hash */
-		add_entropy_words(r, &buf[i % 5], 1);
+		add_entropy_words(r, &buf[i % 5u], 1);
 	}
 
 	/*
@@ -789,7 +789,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * portion of the pool while mixing, and hash one
 	 * final time.
 	 */
-	__add_entropy_words(r, &buf[i % 5], 1, data);
+	__add_entropy_words(r, &buf[i % 5u], 1, data);
 	sha_transform(buf, (__u8 *)data, buf + 5);
 
 	/*
@@ -1040,7 +1040,7 @@ write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
 		count -= bytes;
 		p += bytes;
 
-		add_entropy_words(r, buf, (bytes + 3) / 4);
+		add_entropy_words(r, buf, (bytes + 3) / 4u);
 	}
 
 	return 0;
