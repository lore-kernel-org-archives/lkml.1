Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYEPWEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYEPWEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760567AbYEPWDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:03:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:6033 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243AbYEPWDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=d5R8fGYbnfGI61r8nLXUYL5MWe/G8UTE2BoGCM+eJld8fEC4az1T2fGfIW4BAdA5ThA1FONfDIZavlM6IcK0d5K7l/iIGy+XfGm8mUpW6dKRAR8CeIFjTBy3Fm0ZY3Tf6ABzV7Sx9FcGQWsq+9Lg8lmmd+TjEkpORe/GofFmCJE=
Date: Sat, 17 May 2008 02:03:38 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Message-ID: <20080516220338.GA3255@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 01:36:13PM -0600, Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> This patch adds support for populating an SPI bus based on data in the
> OF device tree.  This is useful for powerpc platforms which use the
> device tree instead of discrete code for describing platform layout.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
[...]
> +void spi_of_register_devices(struct spi_master *master, struct device_node *np)
> +{
> +	struct spi_device *spi;
> +	struct device_node *nc;
> +	const u32 *prop;
> +	const char *sprop;
> +	int rc;
> +	int len;
> +
> +	for_each_child_of_node(np, nc) {
> +		/* Alloc an spi_device */
> +		spi = spi_alloc_device(master);
> +		if (!spi) {
> +			dev_err(&master->dev, "spi_device alloc error for %s\n",
> +				np->full_name);
> +			continue;
> +		}
> +
> +		/* Device address */
> +		prop = of_get_property(nc, "reg", &len);
> +		if (!prop || len < sizeof(*prop)) {
> +			dev_err(&master->dev, "%s has no 'reg' property\n",
> +				np->full_name);
> +			continue;
> +		}
> +		spi->chip_select = *prop;
> +
> +		/* Mode (clock phase/polarity/etc. */
> +		if (of_find_property(nc, "spi,cpha", NULL))
> +			spi->mode |= SPI_CPHA;
> +		if (of_find_property(nc, "spi,cpol", NULL))
> +			spi->mode |= SPI_CPOL;
> +
> +		/* Device speed */
> +		prop = of_get_property(nc, "max-speed", &len);
> +		if (prop && len >= sizeof(*prop))
> +			spi->max_speed_hz = *prop;
> +		else
> +			spi->max_speed_hz = 100000;
> +
> +		/* IRQ */
> +		spi->irq = irq_of_parse_and_map(nc, 0);
> +
> +		/* Select device driver */
> +		sprop = of_get_property(nc, "linux,modalias", &len);
> +		if (sprop && len > 0)
> +			strncpy(spi->modalias, sprop, KOBJ_NAME_LEN);
> +		else
> +			strncpy(spi->modalias, "spidev", KOBJ_NAME_LEN);
> +
> +		/* Store a pointer to the node in the device structure */
> +		of_node_get(nc);
> +		spi->dev.archdata.of_node = nc;
> +
> +		/* Register the new device */
> +		rc = spi_register_device(spi);
> +		if (rc) {
> +			dev_err(&master->dev, "spi_device register error %s\n",
> +				np->full_name);
> +			spi_device_release(spi);
> +		}

No way to pass platform data... can you suggest any idea to use
this for things like
"[POWERPC] 86xx: mpc8610_hpcd: add support for SPI and MMC-over-SPI"
I've sent just recently...?

Maybe this code could do something like
spi->dev.platform_data = nc->data;
and board code would fill nc->data at early stages? This needs to be a
convention, not just random use though.. Maybe we can expand the struct
device_node to explicitly include .platform_data for such cases?

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
