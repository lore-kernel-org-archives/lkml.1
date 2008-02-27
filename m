Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbYB0Dsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbYB0Dsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 22:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYB0Dsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 22:48:31 -0500
Received: from smtp-out.google.com ([216.239.33.17]:49945 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYB0Dsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 22:48:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=B5mq1/KGrxkFDl5WJT8LQxXqhk2mlY0v4e+XpGPUA1wjm5EgUhxEZhbaMJRBtv1e3
	uViVd1MVmaUNGhw5aL/mQ==
Date: Tue, 26 Feb 2008 19:46:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Martin Michlmayr <tbm@cyrius.com>
cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ralf Baechle <ralf@linux-mips.org>, Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.25-rc3: "__divdi3" [drivers/crypto/hifn_795x.ko]
 undefined!
In-Reply-To: <20080226122100.GB22699@deprecation.cyrius.com>
Message-ID: <alpine.DEB.1.00.0802261945370.22324@chino.kir.corp.google.com>
References: <20080226122100.GB22699@deprecation.cyrius.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Martin Michlmayr wrote:

> With 2.6.25-rc3 and a config file with
> 
> CONFIG_CRYPTO_DEV_HIFN_795X=m
> CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
> 
> I get the following build error on at least ARM and MIPS:
> 
>   Building modules, stage 2.
>   MODPOST 759 modules
> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
> 

crypto: use do_div() when registering the rng

Use do_div() instead of the divide operator.

Cc: Patrick McHardy <kaber@trash.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Looks like this was triggered by f881d829, which causes this code to be
 compiled for CONFIG_CRYPTO_DEV_HIFN_795X_RNG.

 drivers/crypto/hifn_795x.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -822,12 +822,14 @@ static int hifn_rng_data_read(struct hwrng *rng, u32 *data)
 
 static int hifn_register_rng(struct hifn_device *dev)
 {
+	unsigned int tmp;
+
 	/*
 	 * We must wait at least 256 Pk_clk cycles between two reads of the rng.
 	 */
-	dev->rng_wait_time	= DIV_ROUND_UP(NSEC_PER_SEC, dev->pk_clk_freq) *
-				  256;
-
+	tmp = NSEC_PER_SEC + dev->pk_clk_freq - 1;
+	do_div(tmp, dev->pk_clk_freq);
+	dev->rng_wait_time	= tmp * 256;
 	dev->rng.name		= dev->name;
 	dev->rng.data_present	= hifn_rng_data_present,
 	dev->rng.data_read	= hifn_rng_data_read,
