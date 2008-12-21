Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYLUQRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYLUQRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 11:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYLUQRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 11:17:13 -0500
Received: from server.drzeus.cx ([85.8.24.28]:59487 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752594AbYLUQRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 11:17:12 -0500
Date: Sun, 21 Dec 2008 17:17:00 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: Re: [PATCH 5/5] omap mmc: Add new omap hsmmc controller for 2430
 and 34xx
Message-ID: <20081221171700.3efc0c3a@mjolnir.drzeus.cx>
In-Reply-To: <20081207215139.10456.46405.stgit@localhost>
References: <20081207213617.10456.43951.stgit@localhost>
	<20081207215139.10456.46405.stgit@localhost>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Dec 2008 13:51:39 -0800
Tony Lindgren <tony@atomide.com> wrote:

> +	/*
> +	 * Unlike OMAP1 controller, the cmdtype does not seem to be based on
> +	 * ac, bc, adtc, bcr. Only CMD12 needs a val of 0x3, rest 0x0.
> +	 */
> +	if (cmd->opcode == 12)
> +		cmdtype = 0x3;

Isn't it more likely that it needs 0x3 for any commands that ends an
open ended transfer? I.e. every time cmd == mrq.stop.

> +	host->dbclk = clk_get(&pdev->dev, "mmchsdb_fck");
> +	/*
> +	 * MMC can still work without debounce clock.
> +	 */
> +	if (IS_ERR(host->dbclk))
> +		dev_dbg(mmc_dev(host->mmc), "Failed to get debounce clock\n");

Perhaps a warning should be printed though, as there could be some
problems caused by trying to init a card that is still bouncing.

> +static int omap_mmc_remove(struct platform_device *pdev)
> +{
> +	struct mmc_omap_host *host = platform_get_drvdata(pdev);
> +	struct resource *res;
> +	u16 vdd = 0;
> +
> +	if (!(OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET)) {
> +	/*
> +	 * Set the vdd back to 3V,
> +	 * applicable for dual volt support.
> +	 */
> +		vdd = fls(host->mmc->ocr_avail) - 1;
> +		if (omap_mmc_switch_opcond(host, vdd) != 0)
> +			host->mmc->ios.vdd = vdd;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res)
> +		release_mem_region(res->start, res->end - res->start + 1);
> +
> +	platform_set_drvdata(pdev, NULL);
> +	if (host) {
> +		mmc_remove_host(host->mmc);

You can't go fiddling with the voltage and removing the MMIO until
you've made sure that there is no more activity on the slot.


Fix the above issues and you can let it go via Russell with a:

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
