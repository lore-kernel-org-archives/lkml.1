Return-Path: <linux-kernel-owner+w=401wt.eu-S1763747AbYB1UA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763747AbYB1UA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbYB1Ty6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:54:58 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764856AbYB1Ty4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:54:56 -0500
Date: Thu, 28 Feb 2008 11:40:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: tbm@cyrius.com, linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru,
       herbert@gondor.apana.org.au, ralf@linux-mips.org, kaber@trash.net
Subject: Re: 2.6.25-rc3: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
Message-Id: <20080228114041.2fc51217.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.00.0802261945370.22324@chino.kir.corp.google.com>
References: <20080226122100.GB22699@deprecation.cyrius.com>
	<alpine.DEB.1.00.0802261945370.22324@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 19:46:35 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Tue, 26 Feb 2008, Martin Michlmayr wrote:
> 
> > With 2.6.25-rc3 and a config file with
> > 
> > CONFIG_CRYPTO_DEV_HIFN_795X=m
> > CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
> > 
> > I get the following build error on at least ARM and MIPS:
> > 
> >   Building modules, stage 2.
> >   MODPOST 759 modules
> > ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
> > 
> 
> crypto: use do_div() when registering the rng
> 
> Use do_div() instead of the divide operator.
> 
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  Looks like this was triggered by f881d829, which causes this code to be
>  compiled for CONFIG_CRYPTO_DEV_HIFN_795X_RNG.
> 
>  drivers/crypto/hifn_795x.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -822,12 +822,14 @@ static int hifn_rng_data_read(struct hwrng *rng, u32 *data)
>  
>  static int hifn_register_rng(struct hifn_device *dev)
>  {
> +	unsigned int tmp;
> +
>  	/*
>  	 * We must wait at least 256 Pk_clk cycles between two reads of the rng.
>  	 */
> -	dev->rng_wait_time	= DIV_ROUND_UP(NSEC_PER_SEC, dev->pk_clk_freq) *
> -				  256;
> -
> +	tmp = NSEC_PER_SEC + dev->pk_clk_freq - 1;
> +	do_div(tmp, dev->pk_clk_freq);
> +	dev->rng_wait_time	= tmp * 256;
>  	dev->rng.name		= dev->name;
>  	dev->rng.data_present	= hifn_rng_data_present,
>  	dev->rng.data_read	= hifn_rng_data_read,

do_div takes a u64 as its first arg.  If we're going to make the above
change then we may as well use plain old "/".

