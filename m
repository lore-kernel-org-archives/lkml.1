Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811Ab0AaNiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0AaNiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 08:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588Ab0AaNh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 08:37:59 -0500
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:41535 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889Ab0AaNh5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 08:37:57 -0500
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.32: padlock_sha1 and hmac broken?
Date: Sun, 31 Jan 2010 14:37:55 +0100
User-Agent: KMail/1.9.9
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <201001300044.15769.wolfgang.walter@stwm.de> <201001310311.23116.wolfgang.walter@stwm.de> <20100131092222.GA22508@gondor.apana.org.au>
In-Reply-To: <20100131092222.GA22508@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001311437.55534.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 31. Januar 2010 schrieb Herbert Xu:
> On Sun, Jan 31, 2010 at 03:11:22AM +0100, Wolfgang Walter wrote:
> > Not sure.
> >
> > When I do
> >
> > modprobe tcrypt mode=101
> >
> > I get a kernel oops:
>
> Sorry, this one should have a better chance at working.
>
> diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
> index 0af8057..d3a27e0 100644
> --- a/drivers/crypto/padlock-sha.c
> +++ b/drivers/crypto/padlock-sha.c
> @@ -57,6 +57,23 @@ static int padlock_sha_update(struct shash_desc *desc,
>  	return crypto_shash_update(&dctx->fallback, data, length);
>  }
>
> +static int padlock_sha_export(struct shash_desc *desc, void *out)
> +{
> +	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
> +
> +	return crypto_shash_export(&dctx->fallback, out);
> +}
> +
> +static int padlock_sha_import(struct shash_desc *desc, const void *in)
> +{
> +	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
> +	struct padlock_sha_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +
> +	dctx->fallback.tfm = ctx->fallback;
> +	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
> +	return crypto_shash_import(&dctx->fallback, in);
> +}
> +
>  static inline void padlock_output_block(uint32_t *src,
>  		 	uint32_t *dst, size_t count)
>  {
> @@ -235,7 +252,10 @@ static struct shash_alg sha1_alg = {
>  	.update 	=	padlock_sha_update,
>  	.finup  	=	padlock_sha1_finup,
>  	.final  	=	padlock_sha1_final,
> +	.export		=	padlock_sha_export,
> +	.import		=	padlock_sha_import,
>  	.descsize	=	sizeof(struct padlock_sha_desc),
> +	.statesize	=	sizeof(struct sha1_state),
>  	.base		=	{
>  		.cra_name		=	"sha1",
>  		.cra_driver_name	=	"sha1-padlock",
> @@ -256,7 +276,10 @@ static struct shash_alg sha256_alg = {
>  	.update 	=	padlock_sha_update,
>  	.finup  	=	padlock_sha256_finup,
>  	.final  	=	padlock_sha256_final,
> +	.export		=	padlock_sha_export,
> +	.import		=	padlock_sha_import,
>  	.descsize	=	sizeof(struct padlock_sha_desc),
> +	.statesize	=	sizeof(struct sha256_state),
>  	.base		=	{
>  		.cra_name		=	"sha256",
>  		.cra_driver_name	=	"sha256-padlock",
>
> Thanks,

This patch works. /proc/crypto shows

name         : authenc(hmac(sha1),cbc(aes))
driver       : authenc(hmac(sha1-padlock),cbc-aes-padlock)
module       : kernel
priority     : 4300
refcnt       : 85
selftest     : passed
type         : aead
async        : yes
blocksize    : 16
ivsize       : 16
maxauthsize  : 20
geniv        : <built-in>

....
....

and

modprobe tcrypt mode=101

logs nothing.

Thanks a lot,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
