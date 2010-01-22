Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289Ab0AVXtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0AVXtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669Ab0AVXtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:49:46 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:35882 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab0AVXtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:49:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=hLlwc1yVruMvC1regYWtzqNhKs3LfEWlNbELN2Xxqk0pMKZ0CadNanq6pUZAaYGVVN
         6Q6hsdmsKrxfQg40Po8Y5JwWLM3S6YvXWbnfUaXyDMxjRItuP6zY/PkVPGMMwiXDiV/N
         c5BEtYnZo562dD4YfV+J27ViBAJLs+3+ERWV0=
Date: Fri, 22 Jan 2010 15:49:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register: warn if probe is in .init.text
Message-ID: <20100122234936.GA14538@core.coreip.homeip.net>
References: <20100122173846.GA11057@suse.de>
 <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Fri, Jan 22, 2010 at 08:49:18PM +0100, Uwe Kleine-König wrote:
> +int platform_driver_register(struct platform_driver *drv)
> +{
> +	int ret = __platform_driver_register(drv);
> +
> +#if defined(CONFIG_HOTPLUG)
> +	/*
> +	 * drivers that are registered by platform_driver_register
> +	 * should not have their probe function in .init.text.  The
> +	 * reason is that a probe can happen after .init.text is
> +	 * discarded which then results in an oops.  The alternatives
> +	 * are using .devinit.text for the probe function or "register"
> +	 * with platform_driver_probe.
> +	 */


What about CONFIG_MODULE case (without hotplug)? The driver may be
compiled in (and thus probe will be discarded) but device might be
created by a loadable module which is loaded later.

> +	if (drv->probe && kernel_init_text_address((unsigned long)drv->probe))
> +		pr_warning("oops-warning: probe function of platform driver %s"
> +			       " lives in .init.text\n", drv->driver.name);
> +#else
> +	/*
> +	 * without HOTPLUG probe functions can be discarded after the driver is
> +	 * loaded.
> +	 * There is a little chance for false positives, namely if the driver is
> +	 * registered after the .init sections are discarded.
> +	 */
> +	if (drv->probe && !kernel_init_text_address((unsigned long)drv->probe))
> +		pr_info("probably the probe function of platform driver %s can"
> +				" be moved to .init.text\n", drv->driver.name);

It really depends on the user's (or rather builder's) local
configuration so how can we make this suggestion?

Thanks.

-- 
Dmitry
