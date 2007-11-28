Return-Path: <linux-kernel-owner+w=401wt.eu-S1761213AbXK1MsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761213AbXK1MsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760656AbXK1Mrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:47:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59478 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbXK1Mrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:47:51 -0500
Date: Wed, 28 Nov 2007 13:47:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Vlad Yasevich <vladislav.yasevich@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [build bug] SCTP, net/sctp/auth.c, ./net/rxrpc/ar-key.c fails
	to build
Message-ID: <20071128124730.GA19498@elte.hu>
References: <20071122153359.GA7268@elte.hu> <20071128124433.GA18378@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128124433.GA18378@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> a similar build bug happens with latest -git as well, with SCTP:
> 
>  net/built-in.o: In function `rxrpc_destroy_s':
>  ar-key.c:(.text+0xc5a2b): undefined reference to `crypto_free_tfm'
>  net/built-in.o: In function `rxrpc_instantiate_s':
>  ar-key.c:(.text+0xc5ed9): undefined reference to `crypto_alloc_base'
>  net/built-in.o: In function `sctp_endpoint_put':
>  : undefined reference to `crypto_free_tfm'
>  net/built-in.o: In function `sctp_inet_listen':
>  : undefined reference to `crypto_free_tfm'
>  net/built-in.o: In function `sctp_auth_destroy_hmacs':
>  : undefined reference to `crypto_free_tfm'
>  net/built-in.o: In function `sctp_auth_init_hmacs':
>  : undefined reference to `crypto_alloc_base'
> 
> this is a build regression over v2.6.23. config attached.

the patch below fix it (or rather, works it around).

	Ingo

------------->
Subject: SCTP: fix build bug
From: Ingo Molnar <mingo@elte.hu>

fix build bug:

 net/built-in.o: In function `rxrpc_destroy_s':
 ar-key.c:(.text+0xc5a2b): undefined reference to `crypto_free_tfm'
 net/built-in.o: In function `rxrpc_instantiate_s':
 ar-key.c:(.text+0xc5ed9): undefined reference to `crypto_alloc_base'
 net/built-in.o: In function `sctp_endpoint_put':
 : undefined reference to `crypto_free_tfm'
 net/built-in.o: In function `sctp_inet_listen':
 : undefined reference to `crypto_free_tfm'
 net/built-in.o: In function `sctp_auth_destroy_hmacs':
 : undefined reference to `crypto_free_tfm'
 net/built-in.o: In function `sctp_auth_init_hmacs':
 : undefined reference to `crypto_alloc_base'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 net/sctp/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/net/sctp/Kconfig
===================================================================
--- linux.orig/net/sctp/Kconfig
+++ linux/net/sctp/Kconfig
@@ -6,7 +6,7 @@ menuconfig IP_SCTP
 	tristate "The SCTP Protocol (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
 	depends on IPV6 || IPV6=n
-	select CRYPTO if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
+	select CRYPTO
 	select CRYPTO_HMAC if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
 	select CRYPTO_SHA1 if SCTP_HMAC_SHA1
 	select CRYPTO_MD5 if SCTP_HMAC_MD5
