Return-Path: <linux-kernel-owner+w=401wt.eu-S1760508AbXK1OwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508AbXK1OwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbXK1Ovx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:51:53 -0500
Received: from smtp.cce.hp.com ([161.114.21.23]:4924 "EHLO
	ccerelrim02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbXK1Ovw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:51:52 -0500
X-Greylist: delayed 1620 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2007 09:51:52 EST
Message-ID: <474D8820.5000000@hp.com>
Date: Wed, 28 Nov 2007 10:24:16 -0500
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [build bug] SCTP, net/sctp/auth.c, ./net/rxrpc/ar-key.c fails
 to build
References: <20071122153359.GA7268@elte.hu> <20071128124433.GA18378@elte.hu> <20071128124730.GA19498@elte.hu>
In-Reply-To: <20071128124730.GA19498@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.11.28.60442
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> a similar build bug happens with latest -git as well, with SCTP:
>>
>>  net/built-in.o: In function `rxrpc_destroy_s':
>>  ar-key.c:(.text+0xc5a2b): undefined reference to `crypto_free_tfm'
>>  net/built-in.o: In function `rxrpc_instantiate_s':
>>  ar-key.c:(.text+0xc5ed9): undefined reference to `crypto_alloc_base'

looks like rx-rpc should select CRYPTO as well..

>>  net/built-in.o: In function `sctp_endpoint_put':
>>  : undefined reference to `crypto_free_tfm'
>>  net/built-in.o: In function `sctp_inet_listen':
>>  : undefined reference to `crypto_free_tfm'
>>  net/built-in.o: In function `sctp_auth_destroy_hmacs':
>>  : undefined reference to `crypto_free_tfm'
>>  net/built-in.o: In function `sctp_auth_init_hmacs':
>>  : undefined reference to `crypto_alloc_base'
>>
>> this is a build regression over v2.6.23. config attached.
> 
> the patch below fix it (or rather, works it around).
>

The patch is an OK workaround, but may not yield a working SCTP.

Let me see if I can do better..

-vlad
 
> 	Ingo
> 
> ------------->
> Subject: SCTP: fix build bug
> From: Ingo Molnar <mingo@elte.hu>
> 
> fix build bug:
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
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  net/sctp/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/net/sctp/Kconfig
> ===================================================================
> --- linux.orig/net/sctp/Kconfig
> +++ linux/net/sctp/Kconfig
> @@ -6,7 +6,7 @@ menuconfig IP_SCTP
>  	tristate "The SCTP Protocol (EXPERIMENTAL)"
>  	depends on INET && EXPERIMENTAL
>  	depends on IPV6 || IPV6=n
> -	select CRYPTO if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
> +	select CRYPTO
>  	select CRYPTO_HMAC if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
>  	select CRYPTO_SHA1 if SCTP_HMAC_SHA1
>  	select CRYPTO_MD5 if SCTP_HMAC_MD5
> 

