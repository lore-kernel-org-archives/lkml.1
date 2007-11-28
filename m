Return-Path: <linux-kernel-owner+w=401wt.eu-S1760361AbXK1PGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361AbXK1PGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbXK1PGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:06:01 -0500
Received: from ccerelrim04.cce.hp.com ([161.114.21.25]:10140 "EHLO
	ccerelrim04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbXK1PGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:06:00 -0500
Message-ID: <474D91DD.7000908@hp.com>
Date: Wed, 28 Nov 2007 11:05:49 -0500
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
References: <20071122153359.GA7268@elte.hu> <20071128124433.GA18378@elte.hu> <20071128124730.GA19498@elte.hu> <474D8820.5000000@hp.com> <20071128145804.GA23823@elte.hu>
In-Reply-To: <20071128145804.GA23823@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------070308090007000609040102"
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.11.28.65125
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070308090007000609040102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * Vlad Yasevich <vladislav.yasevich@hp.com> wrote:
> 
>>>> this is a build regression over v2.6.23. config attached.
>>> the patch below fix it (or rather, works it around).
>>>
>> The patch is an OK workaround, but may not yield a working SCTP.
>>
>> Let me see if I can do better..
> 
> i'd be glad to test any patch. Note, the config was generated via 'make 
> randconfig', for automated build and boot QA, and "working SCTP" is not 
> something that is necessary for such a kernel to boot. So the workaround 
> might be fine as well - not all config space combinations that are 
> reachable via 'make randconfig' make "sense", but they should still 
> build and boot fine.
> 
> 	Ingo
> 

I am testing with this patch right now...

-vlad

--------------070308090007000609040102
Content-Type: text/plain;
 name="foo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="foo"

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index da8354e..e71b5f1 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -438,11 +438,14 @@ enum {
 	SCTP_AUTH_HMAC_ID_RESERVED_0,
 	SCTP_AUTH_HMAC_ID_SHA1,
 	SCTP_AUTH_HMAC_ID_RESERVED_2,
-	SCTP_AUTH_HMAC_ID_SHA256
+#if defined (CONFIG_CRYPTO_SHA256) || defined (CONFIG_CRYPTO_SHA256_MODULE)
+	SCTP_AUTH_HMAC_ID_SHA256,
+#endif
+	__SCTP_AUTH_HMAC_MAX
 };
 
-#define SCTP_AUTH_HMAC_ID_MAX	SCTP_AUTH_HMAC_ID_SHA256
-#define SCTP_AUTH_NUM_HMACS (SCTP_AUTH_HMAC_ID_SHA256 + 1)
+#define SCTP_AUTH_HMAC_ID_MAX	__SCTP_AUTH_HMAC_MAX - 1
+#define SCTP_AUTH_NUM_HMACS 	__SCTP_AUTH_HMAC_MAX
 #define SCTP_SHA1_SIG_SIZE 20
 #define SCTP_SHA256_SIG_SIZE 32
 
diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 8210f54..5390bc7 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -6,9 +6,9 @@ menuconfig IP_SCTP
 	tristate "The SCTP Protocol (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
 	depends on IPV6 || IPV6=n
-	select CRYPTO if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
-	select CRYPTO_HMAC if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
-	select CRYPTO_SHA1 if SCTP_HMAC_SHA1
+	select CRYPTO
+	select CRYPTO_HMAC
+	select CRYPTO_SHA1
 	select CRYPTO_MD5 if SCTP_HMAC_MD5
 	---help---
 	  Stream Control Transmission Protocol
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 6d5fa6b..64b5c7a 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -54,11 +54,13 @@ static struct sctp_hmac sctp_hmac_list[SCTP_AUTH_NUM_HMACS] = {
 		/* id 2 is reserved as well */
 		.hmac_id = SCTP_AUTH_HMAC_ID_RESERVED_2,
 	},
+#if defined (CONFIG_CRYPTO_SHA256) || defined (CONFIG_CRYPTO_SHA256_MODULE)
 	{
 		.hmac_id = SCTP_AUTH_HMAC_ID_SHA256,
 		.hmac_name="hmac(sha256)",
 		.hmac_len = SCTP_SHA256_SIG_SIZE,
 	}
+#endif
 };
 
 

--------------070308090007000609040102--
