Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYLEPAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYLEPAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYLEPAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:00:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52010 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbYLEPAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:00:33 -0500
Message-ID: <493942D9.6030807@redhat.com>
Date: Fri, 05 Dec 2008 10:03:53 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-crypto@vger.kernel.org
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: des3_ede: permit weak keys unless REQ_WEAK_KEY
 set
References: <200812041557.49601.jarod@redhat.com>
In-Reply-To: <200812041557.49601.jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> While its a slightly insane to bypass the key1 == key2 ||
> key2 == key3 check in triple-des, since it reduces it to the
> same strength as des, some folks do need to do this from time
> to time for backwards compatibility with des.
> 
> My own case is FIPS CAVS test vectors. Many triple-des test
> vectors use a single key, replicated 3x. In order to get the
> expected results, des3_ede_setkey() needs to honor the weak
> key flag.
> 
> Also adds a warning when a weak key is rejected, otherwise,
> you silently get back a bogus result.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

v2: make CRYPTO_TFM_REQ_WEAK_KEY flag usage consistent w/rest of crypto 
subsystem, per comments from Herbert in Red Hat bugzilla #474394.

---
  crypto/des_generic.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 5d0e458..9002073 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -868,7 +868,8 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, 
const u8 *key,
  	u32 *flags = &tfm->crt_flags;

  	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))))
+		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
+		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY))
  	{
  		*flags |= CRYPTO_TFM_RES_BAD_KEY_SCHED;
  		return -EINVAL;


-- 
Jarod Wilson
jarod@redhat.com
