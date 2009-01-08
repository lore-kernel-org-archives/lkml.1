Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZAHMUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZAHMUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZAHMT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:19:56 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:52267 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750780AbZAHMT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:19:56 -0500
Date: Thu, 8 Jan 2009 12:19:44 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       ben-linux@fluff.org
Subject: Re: [PATCH 2/3] Driver for user access to internal clocks
Message-ID: <20090108121944.GN12431@fluff.org.uk>
References: <8447d6730901080150p217f5d71kd2512b124ed0ed4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730901080150p217f5d71kd2512b124ed0ed4c@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 10:50:03AM +0100, Davide Rizzo wrote:
> Specific for Samsung S3C24xx platforms
> Allows any driver to get a device specific clock.
> It recognizes also the form clkname.X
> 
> Signed-off-by: Davide Rizzo <elpa-rizzo@gmail.com>
> ---
> diff -urNp linux-2.6.28/arch/arm/plat-s3c24xx/clock.c
> linux-2.6.28.elpa/arch/arm/plat-s3c24xx/clock.c
> --- linux-2.6.28/arch/arm/plat-s3c24xx/clock.c	2008-12-25
> 00:26:37.000000000 +0100
> +++ linux-2.6.28.elpa/arch/arm/plat-s3c24xx/clock.c	2009-01-07
> 19:25:07.000000000 +0100
> @@ -67,11 +67,19 @@ static int clk_null_enable(struct clk *c
> 
>  struct clk *clk_get(struct device *dev, const char *id)
>  {
> +	long idno;
> +	char *name = (char *)id;
> +	char *dotpos = strrchr(id, '.');

you've borken the const of the clk_get() call. I think that
this is either something that the caller needs to deal with
as all the drivers will be passing a 'dev' structure in to
help identify common clocks. 

>  	struct clk *p;
>  	struct clk *clk = ERR_PTR(-ENOENT);
> -	int idno;
> 
> -	if (dev == NULL || dev->bus != &platform_bus_type)
> +	if (dotpos) {
> +		int err = strict_strtol(dotpos + 1, 10, &idno);
> +		if (err)
> +			return ERR_PTR(err);
> +		name = kstrdup(id, GFP_KERNEL);
> +		name[dotpos - id] = '\0';
> +	} else if (dev == NULL || dev->bus != &platform_bus_type)
>  		idno = -1;
>  	else
>  		idno = to_platform_device(dev)->id;
> @@ -80,7 +88,7 @@ struct clk *clk_get(struct device *dev,
> 
>  	list_for_each_entry(p, &clocks, list) {
>  		if (p->id == idno &&
> -		    strcmp(id, p->name) == 0 &&
> +		    strcmp(name, p->name) == 0 &&
>  		    try_module_get(p->owner)) {
>  			clk = p;
>  			break;
> @@ -92,7 +100,7 @@ struct clk *clk_get(struct device *dev,
> 
>  	if (IS_ERR(clk)) {
>  		list_for_each_entry(p, &clocks, list) {
> -			if (p->id == -1 && strcmp(id, p->name) == 0 &&
> +			if (p->id == -1 && strcmp(name, p->name) == 0 &&
>  			    try_module_get(p->owner)) {
>  				clk = p;
>  				break;
> @@ -101,6 +109,9 @@ struct clk *clk_get(struct device *dev,
>  	}
> 
>  	mutex_unlock(&clocks_mutex);
> +
> +	if (dotpos)
> +		kfree(name);
>  	return clk;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
