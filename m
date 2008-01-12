Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbYALUID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbYALUID (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbYALUHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:07:54 -0500
Received: from hu-out-0506.google.com ([72.14.214.227]:61744 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbYALUHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EIo7yANrhm2iNgVnbLY/jUuX3Gm9rHmYYztAzjk+swP9NXlzeA9/YazfoLqBKFr7tBwcGDS9RXphFKhosjal8RiJzmfjS1/SX96k1343V0G+AdMyPV0HoSjo+X9SrfubdZ98J6n+/Ws3CQ4tNMXXQeD2/IYoVCA9P2y/Pe56t30=
Date: Sat, 12 Jan 2008 21:11:11 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, krh@redhat.com,
       stern@rowland.harvard.edu, dwmw2@infradead.org, davem@davemloft.net
Subject: Re: [PATCH 1/7] driver-core : add class iteration api
Message-ID: <20080112201111.GA8129@ami.dom.local>
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 05:47:54PM +0800, Dave Young wrote:
> Add the following class iteration functions for driver use:
> class_for_each_device
> class_find_device
> class_for_each_child
> class_find_child
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> 
> ---
>  drivers/base/class.c   |  159 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/device.h |    8 ++
>  2 files changed, 167 insertions(+)
> 
> diff -upr linux/drivers/base/class.c linux.new/drivers/base/class.c
> --- linux/drivers/base/class.c	2008-01-12 14:42:24.000000000 +0800
> +++ linux.new/drivers/base/class.c	2008-01-12 14:42:24.000000000 +0800
> @@ -798,6 +798,165 @@ void class_device_put(struct class_devic
>  		kobject_put(&class_dev->kobj);
>  }
>  
> +/**
> + *	class_for_each_device - device iterator
> + *	@class:	the class we're iterating
> + *	@data: data for the callback
> + *	@fn: function to be called for each device
> + *
> + *	Iterate over @class's list of devices, and call @fn for each,
> + *	passing it @data.
> + *
> + *	We check the return of @fn each time. If it returns anything
> + *	other than 0, we break out and return that value.
> + */
> +int class_for_each_device(struct class *class, void *data,
> +			   int (*fn)(struct device *, void *))
> +{
> +	struct device *dev;
> +	int error = 0;
> +
> +	if (!class)
> +		return -EINVAL;
> +	down(&class->sem);
> +	list_for_each_entry(dev, &class->devices, node) {

Probably some tiny oversight, but I see this comment to struct class
doesn't mention devices list, so maybe this needs to be updated BTW?:

(from include/linux/device.h)
"        struct semaphore        sem;    /* locks both the children and interfaces lists */"

Regards,
Jarek P.
