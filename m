Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbXIAIzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbXIAIzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 04:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbXIAIy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 04:54:58 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1721 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751871AbXIAIy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 04:54:57 -0400
Date: Sat, 1 Sep 2007 16:54:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: 2.6.23-rc4-mm1
Message-ID: <20070901085429.GA7213@gondor.apana.org.au>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070901155353.8a09db69.kamezawa.hiroyu@jp.fujitsu.com> <20070831235815.a09c7865.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070831235815.a09c7865.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 11:58:15PM -0700, Andrew Morton wrote:
> 
> > crypto/built-in.o: In function `update2':
> > digest.c:(.text+0x94a): undefined reference to `crypto_km_types'
> > digest.c:(.text+0x9bf): undefined reference to `crypto_km_types'
> > 
> > digest.c (CONFIG_CRYPTO) uses crypto/scatterwalk.c's object (CONFIG_CRYPTO_ALGAPI)
> > I meet this when CONFIG_CRYPTO_ALGAPI=m. I need to make CONFIG_CRYPTO_ALGAPI=y.
> 
> cc herbert..

Sorry, only tested on x86-64 which doesn't have HIGHMEM.

I've just pushed the following fix into cryptodev-2.6.

commit 25531e010a2a1d0099b62d473244d09e72402ce5
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sat Sep 1 16:52:13 2007 +0800

    [CRYPTO] api: Kill crypto_km_types

    When scatterwalk is built as a module digest.c was broken because it
    requires the crypto_km_types structure which is in scatterwalk.  This
    patch removes the crypto_km_types structure by encoding the logic into
    crypto_kmap_type directly.

    In fact, this even saves a few bytes of code (not to mention the data
    structure itself) on i386 which is about the only place where it's
    needed.

    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/internal.h b/crypto/internal.h
index 60acad9..abb01f7 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -50,11 +50,16 @@ extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
-extern enum km_type crypto_km_types[];
-
 static inline enum km_type crypto_kmap_type(int out)
 {
-	return crypto_km_types[(in_softirq() ? 2 : 0) + out];
+	enum km_type type;
+
+	if (in_softirq())
+		type = out * (KM_SOFTIRQ1 - KM_SOFTIRQ0) + KM_SOFTIRQ0;
+	else
+		type = out * (KM_USER1 - KM_USER0) + KM_USER0;
+
+	return type;
 }
 
 static inline void *crypto_kmap(struct page *page, int out)
