Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbXK3WuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbXK3WuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXK3WuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:50:05 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:27798 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbXK3WuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=axSjfYuZKgh0EXefK0asiOOCefw/9gC9rYEk/ktLaQ1V0eXC6q3dW0AFcuwm86A45MUac8Qo8+fSysLDvswqwAz09Z7ADKXFFVPTWrFdohU5ySB7W23aJyosu++Rxp0SOFUaEmSIINUHopp4B1/c797PQHT1wccWZWHk4ske488=
Message-ID: <47509393.8000703@gmail.com>
Date: Fri, 30 Nov 2007 23:49:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, matthew@wil.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, drzeus@drzeus.cx
Subject: Re: WARNING: at kernel/resource.c:189 __release_resource
References: <4745F77C.7040402@gmail.com> <200711291640.38158.bjorn.helgaas@hp.com> <20071129164207.fd7bcd30.akpm@linux-foundation.org> <200711301408.13422.bjorn.helgaas@hp.com>
In-Reply-To: <200711301408.13422.bjorn.helgaas@hp.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2007 10:08 PM, Bjorn Helgaas wrote:
> On Thursday 29 November 2007 05:42:07 pm Andrew Morton wrote:
>> On Thu, 29 Nov 2007 16:40:37 -0700
>>> Maybe we could either remove the pnp_{stop,start}_dev() calls
>>> from the suspend/resume path, or move the PNP resource management
>>> out of pnp_{start,stop}_dev().
>>>
>>> Bjorn
>>>
>>> [1] http://lkml.org/lkml/2005/11/30/39
>> So was this particular problem caused/exposed by
>> pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch, or is
>> it in mainline?
> 
> I'm pretty sure this problem is caused by that patch, so we
> we shouldn't see this in mainline.
> 
> Jiri, can you try the additional patch below, please?
> 
> Index: linux-mm/drivers/pnp/driver.c
> ===================================================================
> --- linux-mm.orig/drivers/pnp/driver.c	2007-11-30 13:58:25.000000000 -0700
> +++ linux-mm/drivers/pnp/driver.c	2007-11-30 13:59:37.000000000 -0700
> @@ -161,13 +161,6 @@
>  			return error;
>  	}
>  
> -	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE) &&
> -	    pnp_can_disable(pnp_dev)) {
> -		error = pnp_stop_dev(pnp_dev);
> -		if (error)
> -			return error;
> -	}
> -
>  	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
>  		pnp_dev->protocol->suspend(pnp_dev, state);
>  	return 0;
> @@ -185,12 +178,6 @@
>  	if (pnp_dev->protocol && pnp_dev->protocol->resume)
>  		pnp_dev->protocol->resume(pnp_dev);
>  
> -	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
> -		error = pnp_start_dev(pnp_dev);
> -		if (error)
> -			return error;
> -	}
> -
>  	if (pnp_drv->resume)
>  		return pnp_drv->resume(pnp_dev);
>  

No, it breaks suspend.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
