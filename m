Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbZAIU7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbZAIU7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbZAIU5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:57:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508AbZAIU5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:57:41 -0500
Date: Fri, 9 Jan 2009 12:56:33 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: post 2.6.28 regression: device_initialize() now sleeps, and
	may fail without recovery strategy
Message-ID: <20090109205633.GB19904@suse.de>
References: <496798FE.8030900@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496798FE.8030900@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 07:35:42PM +0100, Stefan Richter wrote:
> >From commit 2831fe6f9cc4e16c103504ee09a47a084297c0f3, "driver core:
> create a private portion of struct device":
> 
>  void device_initialize(struct device *dev)
>  {
> +	dev->p = kzalloc(sizeof(*dev->p), GFP_KERNEL);
> +	if (!dev->p) {
> +		WARN_ON(1);
> +		return;
> +	}
> +	dev->p->device = dev;
>  	dev->kobj.kset = devices_kset;
>  	kobject_init(&dev->kobj, &device_ktype);
> 
> 
> First of all, this prevents initialization of struct device in atomic
> contexts, such as drivers/firewire/fw-device.c::fw_node_event.

Ick, sorry, I didn't think that any callers ever did this.

> This is a bug in current mainline.
> 
> We can fix the bug by changing firewire-core, but
>   a) it'd be more than a one-liner,
>   b) who knows which other subsystems are affected.

I agree.

I originally looked at changing this to be at device_add time, but I
think there are some code paths that do device_initialize and then do
some operations on the device before calling device_add.  But I could be
wrong, let me do some testing first before forcing you to make that big
change to the firewire core.

> Next, the above code is bogus.  In 2.6.28, device_initialize() could
> never fail and was thus safe to use as a void-valued function.
> 
> How does driver core handle dev->p == NULL in subsequent usages of dev now?

It dies a flaming horrible death, pretty much like the whole rest of the
system if allocating such a small ammount of memory is causing failures
:)

Give me a few hours to test here, your change might not be necessary...

thanks,

greg k-h
