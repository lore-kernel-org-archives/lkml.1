Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZGXWvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZGXWvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbZGXWvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:51:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754999AbZGXWvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:51:54 -0400
Date: Fri, 24 Jul 2009 15:51:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: pierre@ossman.eu, jarkko.lavinen@nokia.com, ext-denis.2.karpov@nokia.com,
       adrian.hunter@nokia.com, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 20/32] omap_hsmmc: put MMC regulator to sleep
Message-Id: <20090724155144.4c621e6d.akpm@linux-foundation.org>
In-Reply-To: <20090710124227.1262.7056.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
	<20090710124227.1262.7056.sendpatchset@ahunter-tower>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 15:42:27 +0300
Adrian Hunter <adrian.hunter@nokia.com> wrote:

> +static int omap_mmc_regsleep_to_enabled(struct mmc_omap_host *host)
> +{
> +	unsigned long timeout;
> +
> +	dev_dbg(mmc_dev(host->mmc), "REGSLEEP -> ENABLED\n");
> +
> +	clk_enable(host->fclk);
> +	clk_enable(host->iclk);
> +
> +	if (clk_enable(host->dbclk))
> +		dev_dbg(mmc_dev(host->mmc),
> +			"Enabling debounce clk failed\n");
> +
> +	omap_mmc_restore_ctx(host);
> +
> +	/*
> +	 * We turned off interrupts and bus power.  Interrupts
> +	 * are turned on by 'mmc_omap_start_command()' so we
> +	 * just need to turn on the bus power here.
> +	 */
> +	OMAP_HSMMC_WRITE(host->base, HCTL,
> +			 OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
> +
> +	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
> +	while ((OMAP_HSMMC_READ(host->base, HCTL) & SDBP) != SDBP &&
> +	       time_before(jiffies, timeout))
> +		;
> +
> +	if (mmc_slot(host).set_sleep)
> +		mmc_slot(host).set_sleep(host->dev, host->slot_id,
> +					 0, host->vdd, 0);
> +
> +	host->dpm_state = ENABLED;
> +
> +	return 0;
> +}

We take no action if the wait for SDBP timed out?
