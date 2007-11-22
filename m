Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbXKVAwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbXKVAwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 19:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbXKVAwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 19:52:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54872 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXKVAwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 19:52:44 -0500
Date: Thu, 22 Nov 2007 00:52:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: ian <spyro@f2s.com>
Cc: eric miao <eric.y.miao@gmail.com>, Dmitry Baryshkov <dbaryshkov@gmail.com>,
       ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [UPDATED PATCH] Support for Toshiba TMIO multifunction devices
Message-ID: <20071122005230.GA6170@flint.arm.linux.org.uk>
References: <1195591234.2329.52.camel@wirenth> <474359E3.2020603@gmail.com> <1195597252.2329.70.camel@wirenth> <f17812d70711201823w6201bf88uf6268aaee3a32312@mail.gmail.com> <1195617255.2329.78.camel@wirenth> <f17812d70711202005m110ae880m5ba195988e57a638@mail.gmail.com> <1195691649.2329.105.camel@wirenth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195691649.2329.105.camel@wirenth>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 12:34:09AM +0000, ian wrote:
> +void mfd_free_devices(struct platform_device *devices, int nr_devs)
> +{
> +	struct platform_device *dev = devices;
> +	int i;
> +
> +	for (i = 0; i < nr_devs; i++) {
> +		struct resource *res = dev->resource;
> +		platform_device_unregister(dev++);
> +		kfree(res);
> +	}
> +	kfree(devices);
> +}
> +EXPORT_SYMBOL_GPL(mfd_free_devices);

Unfortunately, this is broken as designed (in fact this whole file is.)
I'm not sure why people just don't get it.  sysfs.  devices.  device tree.
It has object lifetime rules.  You can _not_ go around unregistering things
and then immediately freeing them - something else might _still_ be using
stuff even after the call to unregister returns.

It's a potential OOPS just waiting to happen.

That's why we have a proper management API for platform devices.  Please
use it, I didn't add the code for just for fun.

See platform_device_alloc() + platform_device_add_resources() +
platform_device_add_data() + platform_device_add() to create, and
platform_device_unregister() to destroy.

(Not looked at the rest because you really really need to get this
right first.)
