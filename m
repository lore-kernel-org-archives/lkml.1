Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbYBGRis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbYBGRis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbYBGRik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:38:40 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:40756 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbYBGRij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:38:39 -0500
Date: Thu, 7 Feb 2008 18:37:44 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Carlos Aguiar <carlos.aguiar@indt.org.br>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] MMC: OMAP: Introduce new multislot structure and
 change driver to use it
Message-ID: <20080207183744.1491c995@poseidon.drzeus.cx>
In-Reply-To: <479E27EB.3040502@indt.org.br>
References: <479E27EB.3040502@indt.org.br>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 15:07:23 -0400
Carlos Aguiar <carlos.aguiar@indt.org.br> wrote:

> From: Juha Yrjola <juha.yrjola@solidboot.com>
> 
> Introduce new MMC multislot structure and change driver to use it.
> 
> Note that MMC clocking is now enabled in mmc_omap_select_slot()
> and disabled in mmc_omap_release_slot().
> 
> Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
> Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---

I still think this muxed mmc host thing is a bad idea, but it's your nightmare...

> +
> +/* Access to the R/O switch is required for production testing
> + * purposes. */
> +static ssize_t
> +mmc_omap_show_ro(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
> +	struct mmc_omap_slot *slot = mmc_priv(mmc);
> +
> +	return sprintf(buf, "%d\n", slot->pdata->get_ro(mmc_dev(mmc),
> +							slot->id));
> +}
> +
> +static DEVICE_ATTR(ro, S_IRUGO, mmc_omap_show_ro, NULL);
> +

This is unrelated to the slot stuff and should be in its own patch. Also, it should probably be in the core, not a driver.

> +
> +	mmc->caps = MMC_CAP_MULTIWRITE | MMC_CAP_MMC_HIGHSPEED |
> +		    MMC_CAP_SD_HIGHSPEED;

This is also unrelated. From what I've seen, the OMAP is a SD controller and does not support high speed MMC. The fact that you also conditionally set the max frequency later also suggests that this code is entirely incorrect.

> +
> +	r = mmc_add_host(mmc);
> +	if (r < 0)
> +		return r;
> +
> +	if (slot->pdata->name != NULL) {
> +		r = device_create_file(&mmc->class_dev,
> +					&dev_attr_slot_name);
> +		if (r < 0)
> +			goto err_remove_host;
> +	}
> +
> +	if (slot->pdata->get_ro != NULL) {
> +		r = device_create_file(&mmc->class_dev,
> +					&dev_attr_ro);
> +	}
> +

You have a bit of a race here with userspace in case you use the uevent to trigger things.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
