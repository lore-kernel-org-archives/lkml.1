Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbYGPGf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbYGPGf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 02:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYGPGfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 02:35:50 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58264 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682AbYGPGft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 02:35:49 -0400
Date: Wed, 16 Jul 2008 14:35:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, davem@davemloft.net, mingo@elte.hu,
       nhorman@tuxdriver.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 000000000000000e (reset_prng_context)
Message-ID: <20080716063510.GA13513@gondor.apana.org.au>
References: <20080715113304.GA30565@elte.hu> <20080715.134407.150543177.davem@davemloft.net> <20080715214929.GA18268@martell.zuzino.mipt.ru> <20080715151110.d7a17c89.akpm@linux-foundation.org> <20080716040701.GA12570@gondor.apana.org.au> <20080715212549.1c41c1d0.akpm@linux-foundation.org> <20080716043312.GA12765@gondor.apana.org.au> <20080715215153.16ba2594.akpm@linux-foundation.org> <20080716053459.GA13097@gondor.apana.org.au> <20080715231734.97eb9ac0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715231734.97eb9ac0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:17:34PM -0700, Andrew Morton wrote:
>
> On error the function will sometimes return -EFOO and other times will
> just return -1.  This is inconsistent and makes the error returns
> rather less useful than they could be.  I'd suggest that it be switched
> to -1 throughout or, better, to consistently use appropriate error codes.

Yes -1 should be replaced with a more meaningful error.
> 
> > +struct prng_context *alloc_prng_context(void)
> > +{
> > +	struct prng_context *ctx=kzalloc(sizeof(struct prng_context), GFP_KERNEL);
> > +
> > +	spin_lock_init(&ctx->prng_lock);
> > +
> > +	if (reset_prng_context(ctx, NULL, NULL, NULL, NULL)) {
> > +		kfree(ctx);
> > +		ctx = NULL;
> > +	}
> > +
> > +	dbgprint(KERN_CRIT "returning context %p\n",ctx);
> > +	return ctx;
> > +}
> > +
> > +EXPORT_SYMBOL_GPL(alloc_prng_context);
> > +
> > +void free_prng_context(struct prng_context *ctx)
> > +{
> > +	crypto_free_blkcipher(ctx->tfm);
> > +	kfree(ctx);
> > +}
> > +EXPORT_SYMBOL_GPL(free_prng_context);
> > +
> > +int reset_prng_context(struct prng_context *ctx,
> > +		       unsigned char *key, unsigned char *iv,
> > +		       unsigned char *V, unsigned char *DT)
> > +{
> > +	int ret;
> > +	int iv_len;
> > +	int rc = -EFAULT;
> > +
> > +	spin_lock(&ctx->prng_lock);
> > +	ctx->flags |= PRNG_NEED_RESET;
> > +
> > +	if (key)
> > +		memcpy(ctx->prng_key,key,strlen(ctx->prng_key));
> > +	else
> > +		ctx->prng_key = DEFAULT_PRNG_KEY;
> 
> This is very strange.  In one case we'll copy a string onto existing
> storage at ctx->prng_key.  In the other case we'll *modify*
> ctx->prng_key directly.

Indeed this is bogus.  We shouldn't store either the key or the
IV in the context since the tfm already holds a copy.

Neil, please remove prng_key and prng_iv completely.
 
> We don't support \0's in the key or the IV.  I assume that's OK?

No the caller should supply the length instead.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
