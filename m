Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0CDBQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:16:39 -0500
Received: from mail-qy0-f198.google.com ([209.85.221.198]:65214 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab0CDBQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:16:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=oez15u2VH3+ceekezHsXUOLpxNUVMfQKZmmC3Rha8PMNTMC6c9vWNN2MkAMI1fD/3m
         q3kETgzDSdMM/mXOJh1uzkyH1P4nw84hj2yTy/En3qTpZBBisAF8DbnspoMMiV2GN/wM
         mpdKzF42PkUPxA1e7AzlS6zzEHrlTjZUPyP+Q=
MIME-Version: 1.0
In-Reply-To: <20100304104958.8f9b1513.sfr@canb.auug.org.au>
References: <20100304104958.8f9b1513.sfr@canb.auug.org.au>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 4 Mar 2010 09:16:12 +0800
Message-ID: <f17812d71003031716x45b12301j519d3464e1b8012d@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 7:49 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Russell,
>
> Today's linux-next merge of the arm tree got a conflict in
> sound/soc/pxa/pxa-ssp.c between commit
> 026384d614b827f368834860c9b623ce08439b7e ("ASoC: fix PXA SSP port
> resume") from Linus' tree and commit
> f9efc9df94fd126f7d585339e64edec0c03e904b ("ASoC: Remove legacy SSP API
> usage from pxa-ssp.c") from the arm tree.
>
> I fixed it up (see below - it should be checked) and can carry the fix as
> necessary.

Hi Stephen,

I've yet made another fix and have a test build, please use this
one if possible:

diff --cc sound/soc/pxa/pxa-ssp.c
index e69397f,cf00df9..9e95e51
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@@ -133,28 -152,39 +152,40 @@@ static void pxa_ssp_shutdown(struct snd
  static int pxa_ssp_suspend(struct snd_soc_dai *cpu_dai)
  {
  	struct ssp_priv *priv = cpu_dai->private_data;
+ 	struct ssp_device *ssp = priv->ssp;

  	if (!cpu_dai->active)
- 		clk_enable(priv->dev.ssp->clk);
 -		return 0;
++		clk_enable(ssp->clk);

- 	ssp_save_state(&priv->dev, &priv->state);
- 	clk_disable(priv->dev.ssp->clk);
+ 	priv->cr0 = __raw_readl(ssp->mmio_base + SSCR0);
+ 	priv->cr1 = __raw_readl(ssp->mmio_base + SSCR1);
+ 	priv->to  = __raw_readl(ssp->mmio_base + SSTO);
+ 	priv->psp = __raw_readl(ssp->mmio_base + SSPSP);

+ 	ssp_disable(ssp);
+ 	clk_disable(ssp->clk);
  	return 0;
  }

  static int pxa_ssp_resume(struct snd_soc_dai *cpu_dai)
  {
  	struct ssp_priv *priv = cpu_dai->private_data;
+ 	struct ssp_device *ssp = priv->ssp;
+ 	uint32_t sssr = SSSR_ROR | SSSR_TUR | SSSR_BCE;
+
 -	if (!cpu_dai->active)
 -		return 0;
 -
+ 	clk_enable(ssp->clk);

- 	clk_enable(priv->dev.ssp->clk);
- 	ssp_restore_state(&priv->dev, &priv->state);
+ 	__raw_writel(sssr, ssp->mmio_base + SSSR);
 -
+ 	__raw_writel(priv->cr0 & ~SSCR0_SSE, ssp->mmio_base + SSCR0);
+ 	__raw_writel(priv->cr1, ssp->mmio_base + SSCR1);
+ 	__raw_writel(priv->to,  ssp->mmio_base + SSTO);
+ 	__raw_writel(priv->psp, ssp->mmio_base + SSPSP);
 -	__raw_writel(priv->cr0 | SSCR0_SSE, ssp->mmio_base + SSCR0);
 +
 +	if (cpu_dai->active)
- 		ssp_enable(&priv->dev);
++		ssp_enable(ssp);
 +	else
- 		clk_disable(priv->dev.ssp->clk);
++		clk_disable(ssp->clk);
 +
  	return 0;
  }
