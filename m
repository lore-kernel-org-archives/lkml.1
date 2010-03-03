Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0CCXuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:50:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33274 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab0CCXuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:50:01 -0500
Date: Thu, 4 Mar 2010 10:49:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Eric Miao <eric.y.miao@gmail.com>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20100304104958.8f9b1513.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
sound/soc/pxa/pxa-ssp.c between commit
026384d614b827f368834860c9b623ce08439b7e ("ASoC: fix PXA SSP port
resume") from Linus' tree and commit
f9efc9df94fd126f7d585339e64edec0c03e904b ("ASoC: Remove legacy SSP API
usage from pxa-ssp.c") from the arm tree.

I fixed it up (see below - it should be checked) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/pxa/pxa-ssp.c
index e69397f,cf00df9..0000000
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@@ -133,28 -152,39 +152,41 @@@ static void pxa_ssp_shutdown(struct snd
  static int pxa_ssp_suspend(struct snd_soc_dai *cpu_dai)
  {
  	struct ssp_priv *priv = cpu_dai->private_data;
+ 	struct ssp_device *ssp = priv->ssp;
  
  	if (!cpu_dai->active)
 -		return 0;
 +		clk_enable(priv->dev.ssp->clk);
  
- 	ssp_save_state(&priv->dev, &priv->state);
- 	clk_disable(priv->dev.ssp->clk);
+ 	priv->cr0 = __raw_readl(ssp->mmio_base + SSCR0);
+ 	priv->cr1 = __raw_readl(ssp->mmio_base + SSCR1);
+ 	priv->to  = __raw_readl(ssp->mmio_base + SSTO);
+ 	priv->psp = __raw_readl(ssp->mmio_base + SSPSP);
+ 
+ 	ssp_disable(ssp);
+ 	clk_disable(ssp->clk);
 +
  	return 0;
  }
  
  static int pxa_ssp_resume(struct snd_soc_dai *cpu_dai)
  {
  	struct ssp_priv *priv = cpu_dai->private_data;
+ 	struct ssp_device *ssp = priv->ssp;
+ 	uint32_t sssr = SSSR_ROR | SSSR_TUR | SSSR_BCE;
  
- 	clk_enable(priv->dev.ssp->clk);
- 	ssp_restore_state(&priv->dev, &priv->state);
 -	if (!cpu_dai->active)
 -		return 0;
 -
+ 	clk_enable(ssp->clk);
  
- 	if (cpu_dai->active)
- 		ssp_enable(&priv->dev);
- 	else
- 		clk_disable(priv->dev.ssp->clk);
 -	__raw_writel(sssr, ssp->mmio_base + SSSR);
++	if (cpu_dai->active) {
++		__raw_writel(sssr, ssp->mmio_base + SSSR);
++
++		__raw_writel(priv->cr0 & ~SSCR0_SSE, ssp->mmio_base + SSCR0);
++		__raw_writel(priv->cr1, ssp->mmio_base + SSCR1);
++		__raw_writel(priv->to,  ssp->mmio_base + SSTO);
++		__raw_writel(priv->psp, ssp->mmio_base + SSPSP);
++		__raw_writel(priv->cr0 | SSCR0_SSE, ssp->mmio_base + SSCR0);
++	} else
++		clk_disable(ssp->clk);
  
 -	__raw_writel(priv->cr0 & ~SSCR0_SSE, ssp->mmio_base + SSCR0);
 -	__raw_writel(priv->cr1, ssp->mmio_base + SSCR1);
 -	__raw_writel(priv->to,  ssp->mmio_base + SSTO);
 -	__raw_writel(priv->psp, ssp->mmio_base + SSPSP);
 -	__raw_writel(priv->cr0 | SSCR0_SSE, ssp->mmio_base + SSCR0);
  	return 0;
  }
  
