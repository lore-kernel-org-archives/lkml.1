Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbZAPAFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbZAPAFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZAPAFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:05:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbZAPAFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:05:42 -0500
Date: Thu, 15 Jan 2009 16:05:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Add Extended CSD as a device attribute
Message-Id: <20090115160527.4cdbe94b.akpm@linux-foundation.org>
In-Reply-To: <496E1187.60305@nokia.com>
References: <496E1187.60305@nokia.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 18:23:35 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
>
> Subject: [PATCH] MMC: Add Extended CSD as a device attribute

Why?  There must be some *reason* for making this change.  Presumably
that reason is obvious to yourself and Pierre, but what about the rest
of us?

> 
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>

It would take only 30 seconds to write a changelog for this patch :(

>  drivers/mmc/core/mmc.c |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 3f5b089..29291de 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -259,6 +259,34 @@ MMC_DEV_ATTR(name, "%s\n", card->cid.prod_name);
>  MMC_DEV_ATTR(oemid, "0x%04x\n", card->cid.oemid);
>  MMC_DEV_ATTR(serial, "0x%08x\n", card->cid.serial);
>  
> +static ssize_t mmc_ext_csd_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct mmc_card *card = container_of(dev, struct mmc_card, dev);
> +	ssize_t n = 0;
> +	u8 *ext_csd;
> +	int err, i;
> +
> +	ext_csd = kmalloc(512, GFP_KERNEL);
> +	if (!ext_csd)
> +		return 0;
> +
> +	mmc_claim_host(card->host);
> +	err = mmc_send_ext_csd(card, ext_csd);
> +	mmc_release_host(card->host);
> +
> +	if (!err) {
> +		for (i = 511; i >= 0; i--)
> +			n += sprintf(buf + n, "%02x", (unsigned)ext_csd[i]);

The cast isn't actually needed.

> +		n += sprintf(buf + n, "\n");
> +	}
> +
> +	kfree(ext_csd);
> +
> +	return n;
> +}
> +
> +static DEVICE_ATTR(ext_csd, S_IRUGO, mmc_ext_csd_show, NULL);
> +
>  static struct attribute *mmc_std_attrs[] = {
>  	&dev_attr_cid.attr,
>  	&dev_attr_csd.attr,
> @@ -269,6 +297,7 @@ static struct attribute *mmc_std_attrs[] = {
>  	&dev_attr_name.attr,
>  	&dev_attr_oemid.attr,
>  	&dev_attr_serial.attr,
> +	&dev_attr_ext_csd.attr,
>  	NULL,
>  };

