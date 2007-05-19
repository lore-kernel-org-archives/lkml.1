Return-Path: <linux-kernel-owner+w=401wt.eu-S1764808AbXESWK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764808AbXESWK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbXESWKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:10:53 -0400
Received: from neon.samage.net ([85.17.153.66]:46149 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931AbXESWKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:10:52 -0400
Message-ID: <1447.81.207.0.53.1179612647.squirrel@secure.samage.net>
In-Reply-To: <20070519193307.GA26156@kroah.com>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
    <3642.81.207.0.53.1179584891.squirrel@secure.samage.net>
    <Pine.LNX.4.64.0705191119460.17008@schroedinger.engr.sgi.com>
    <20070519193307.GA26156@kroah.com>
Date: Sun, 20 May 2007 00:10:47 +0200 (CEST)
Subject: Re: [BUG: 2.6.22-rc2] SLAB doesn't like usb_get_configuration()
From: "Indan Zupancic" <indan@nul.nu>
To: "Greg KH" <greg@kroah.com>
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 9b84bad32751a42de3aa9e7877f1ca86
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 21:33, Greg KH wrote:
> On Sat, May 19, 2007 at 11:20:44AM -0700, Christoph Lameter wrote:
>> On Sat, 19 May 2007, Indan Zupancic wrote:
>>
>> > I had two SLAb related bugs, both with usb_get_configuration()
>> > near the end of the backtrace. First one was with git between
>> > rc1 and rc2, but very close to rc2, second one was with rc2,
>> > both at bootup.
>>
>> Well usb_get_configuration seems to do a kmalloc(0) which is a bit
>> strange and this is why we flagged the allocation in the slab allocators.
>> Is there some way to avoid allocating an object of zero length?
>
> Can you try the patch below and let me know if it fixes the issue for
> you or not?
>
> thanks,
>
> greg k-h
>
>
> From: Alan Stern <stern@rowland.harvard.edu>
> Subject: [PATCH] USB: don't try to kzalloc 0 bytes
>
> This patch (as907) prevents us from trying to allocate 0 bytes
> when an interface has no endpoint descriptors.
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>
> --- usb-2.6.orig/drivers/usb/core/config.c
> +++ usb-2.6/drivers/usb/core/config.c
> @@ -185,10 +185,12 @@ static int usb_parse_interface(struct de
>  		num_ep = USB_MAXENDPOINTS;
>  	}
>
> -	len = sizeof(struct usb_host_endpoint) * num_ep;
> -	alt->endpoint = kzalloc(len, GFP_KERNEL);
> -	if (!alt->endpoint)
> -		return -ENOMEM;
> +	if (num_ep > 0) {	/* Can't allocate 0 bytes */
> +		len = sizeof(struct usb_host_endpoint) * num_ep;
> +		alt->endpoint = kzalloc(len, GFP_KERNEL);
> +		if (!alt->endpoint)
> +			return -ENOMEM;
> +	}
>
>  	/* Parse all the endpoint descriptors */
>  	n = 0;
>

Thanks, this one seems to fix it, I don't get the BUG anymore.

Greetings,

Indan


