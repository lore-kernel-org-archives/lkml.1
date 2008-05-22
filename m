Return-Path: <linux-kernel-owner+w=401wt.eu-S934258AbYEVAYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbYEVAYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937559AbYEVAXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:23:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56547
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935945AbYEVAXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:23:46 -0400
Date: Wed, 21 May 2008 17:23:41 -0700 (PDT)
Message-Id: <20080521.172341.95895019.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: martin@strongswan.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26-rc3] xfrm: Installing NULL encryption IPSec SAs
 fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080521235922.GB27138@gondor.apana.org.au>
References: <1211388907.26331.10.camel@martin>
	<20080521.133756.240329422.davem@davemloft.net>
	<20080521235922.GB27138@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 22 May 2008 07:59:22 +0800

> I think we should get rid of the zero check altogether as a
> zero-length key will fail on setkey of a real algorithm anyway
> because of the min_keysize/max_keysize checks in the crypto API.

Ok, how does this look?

xfrm_user: Remove zero length key checks.

The crypto layer will determine whether that is valid
or not.

Suggested by Herbert Xu, based upon a report and patch
by Martin Willi.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index a1b0fbe..b976d9e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -50,19 +50,8 @@ static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type)
 
 	switch (type) {
 	case XFRMA_ALG_AUTH:
-		if (!algp->alg_key_len &&
-		    strcmp(algp->alg_name, "digest_null") != 0)
-			return -EINVAL;
-		break;
-
 	case XFRMA_ALG_CRYPT:
-		if (!algp->alg_key_len &&
-		    strcmp(algp->alg_name, "cipher_null") != 0)
-			return -EINVAL;
-		break;
-
 	case XFRMA_ALG_COMP:
-		/* Zero length keys are legal.  */
 		break;
 
 	default:
