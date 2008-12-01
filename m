Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYLAWxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYLAWxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYLAWxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:53:25 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2647 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYLAWxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:53:24 -0500
Date: Mon, 1 Dec 2008 22:53:13 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20081201225312.GA6699@sirena.org.uk>
References: <200812011335.43551.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812011335.43551.david-b@pacbell.net>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.28-rc6+] regulator: bugfixes and messaging cleanup
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 01:35:43PM -0800, David Brownell wrote:

> Regulator core bugfixes:

...

> And messaging updates;

This could usefuly be split into a patch series, there's rather a lot
of different changes in here...  On the whole it looks good, a few
things, though:

> @@ -894,7 +915,7 @@ struct regulator *regulator_get(struct d
>  	struct regulator *regulator = ERR_PTR(-ENODEV);
>  
>  	if (id == NULL) {
> -		printk(KERN_ERR "regulator: get() with no identifier\n");
> +		dev_dbg(dev, "regulator_get with no identifier\n");
>  		return regulator;
>  	}

dev may legally be NULL here which is going to cause upset if the
dev_dbg() is hit.  Things like cpufreq which can use regulators don't
use a struct device (currently!) so it's supported.

> @@ -971,19 +991,16 @@ static int _regulator_enable(struct regu
>  	int ret = -EINVAL;
>  
>  	if (!rdev->constraints) {
> -		printk(KERN_ERR "%s: %s has no constraints\n",
> -		       __func__, rdev->desc->name);
> +		dev_err(&rdev->dev, "%s has no constraints\n",
> +		       rdev->desc->name);

Hrm.  You've downgraded most of the diagnostics to dev_dbg() but left
this as KERN_ERR.  It'd be nice to be a bit more consistent.  My
personal preference is to make things in the constraints and machine
definitions display at dev_err() since they should never happen and a
plain text error is often helpful for new users but it's not a very
strong one either way.

>  		ret = rdev->desc->ops->enable(rdev);
> -		if (ret < 0) {
> -			printk(KERN_ERR "%s: failed to enable %s: %d\n",
> -			       __func__, rdev->desc->name, ret);
> -			return ret;
> +		if (ret >= 0) {
> +			dev_dbg(&rdev->dev, "enabled %s\n", rdev->desc->name);
> +			rdev->use_count++;

I have to say I'd be happier keeping the logic as it was here.  The
behaviour does stay the same due to fall through but it's not quite so
clear since it's not consistent with the error handling style for the
rest of the function.
