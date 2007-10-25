Return-Path: <linux-kernel-owner+w=401wt.eu-S1761771AbXJYHdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761771AbXJYHdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761364AbXJYHcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:32:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58960 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761274AbXJYHcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:32:04 -0400
Message-ID: <47204670.9000303@pobox.com>
Date: Thu, 25 Oct 2007 03:32:00 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Nelless <andrew@nelless.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] natsemi: fix oops, link back netdevice from private-struct
References: <32892.86.7.220.119.1193222572.squirrel@wmbeta.mxes.net> <20071024115857.GA21030@elte.hu>
In-Reply-To: <20071024115857.GA21030@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Nelless <andrew@nelless.net> wrote:
> 
>> Hi,
>>
>> I booted up 2.6.24-rc1 this morning [Real early over a brew ;-)] and 
>> was having a problems with multiple ~5 second hangs on SATA/drive init 
>> (Something to do with "EH" something-or-other and resets but I'll 
>> email in separately about it later unless its fixed by the time I get 
>> the chance).
>>
>> Anyway, I went to fire up netconsole to get a decent log dump and hit 
>> across the following nasty. Netconsole works fine in 2.6.23.1 with a 
>> similar config and the same kernel parameters.
>>
>> A shot of the screen is the only method I could come up with to 
>> capture the log, I hope that is OK, it is pretty readable.
>>
>>
>> The nasty: 
>> http://andotnet.nfshost.com/linux/2.6.24-rc1-netconsole-nullderef.jpg
> 
> 
> the NULL dereference is here:
> 
>  (gdb) list *0xffffffff804a9504
>  0xffffffff804a9504 is in natsemi_poll (drivers/net/natsemi.c:717).
>  712             return count;
>  713     }
>  714
>  715     static inline void __iomem *ns_ioaddr(struct net_device *dev)
>  716     {
>  717             return (void __iomem *) dev->base_addr;
>  718     }
>  719
> 
> which is this code from natsemi.c:
> 
>  2227            struct net_device *dev = np->dev;
>  2228            void __iomem * ioaddr = ns_ioaddr(dev);
>  2229            int work_done = 0;
> 
> seems like the NAPI changes in -rc1 added an np->dev field but forgot to 
> initialize it ...
> 
> does the patch below fix the oops for you?
> 
> 	Ingo
> 
> -------------------->
> Subject: natsemi: fix oops, link back netdevice from private-struct
> From: Ingo Molnar <mingo@elte.hu>
> 
> this commit:
> 
>   commit bea3348eef27e6044b6161fd04c3152215f96411
>   Author: Stephen Hemminger <shemminger@linux-foundation.org>
>   Date:   Wed Oct 3 16:41:36 2007 -0700
> 
>       [NET]: Make NAPI polling independent of struct net_device objects.
> 
> added np->dev to drivers/net/natsemi.c's struct netdev_private, but
> forgot to initialize that new field upon driver init. The result was
> a predictable NULL dereference oops the first time the hardware
> generated an interrupt.
> 
> Reported-by: Andrew Nelless <andrew@nelless.net>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/net/natsemi.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/drivers/net/natsemi.c
> ===================================================================
> --- linux.orig/drivers/net/natsemi.c
> +++ linux/drivers/net/natsemi.c
> @@ -864,6 +864,7 @@ static int __devinit natsemi_probe1 (str
>  
>  	np = netdev_priv(dev);
>  	netif_napi_add(dev, &np->napi, natsemi_poll, 64);
> +	np->dev = dev;
>  
>  	np->pci_dev = pdev;
>  	pci_set_drvdata(pdev, dev);

applied


