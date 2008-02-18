Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbYBRRD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbYBRRD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYBRRDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:03:50 -0500
Received: from www.balabit.hu ([212.92.18.33]:54354 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYBRRDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:03:50 -0500
Message-ID: <47B9BA73.7020909@balabit.hu>
Date: Mon, 18 Feb 2008 18:03:47 +0100
From: Laszlo Attila Toth <panther@balabit.hu>
Organization: BalaBit IT Ltd.
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiri Kosina <jkosina@suse.cz>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: My system stops during startup with curretn git tree of 2.6.25-rc2
References: <c4e36d110802170255x19755c03s33502ddf7410f324@mail.gmail.com> <Pine.LNX.4.64.0802181441300.30955@jikos.suse.cz> <47B9928A.60202@balabit.hu> <200802181741.09046.rjw@sisk.pl>
In-Reply-To: <200802181741.09046.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Rafael J. Wysocki wrote:
> On Monday, 18 of February 2008, Laszlo Attila Toth wrote:
>
> 
> All in all, I gather you wanted me to test the patch below. :-)
> 
> Yes, that helps.

Thanks for the testing. Dave already reverted the patch, also I don't 
know I should resend it or leave it as is.

Regards,
Attila

> Thanks,
> Rafael
> 
> ---
> Fix net/core/rtnetlink.c breakage caused by commit
> 45b503548210fe6f23e92b856421c2a3f05fd034
> "[RTNETLINK]: Send a single notification on device state changes."
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  net/core/rtnetlink.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/net/core/rtnetlink.c
> ===================================================================
> --- linux-2.6.orig/net/core/rtnetlink.c
> +++ linux-2.6/net/core/rtnetlink.c
> @@ -853,7 +853,7 @@ static int do_setlink(struct net_device 
>  		if (dev->link_mode != nla_get_u8(tb[IFLA_LINKMODE])) {
>  			write_lock_bh(&dev_base_lock);
>  			dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
> -			write_lock_bh(&dev_base_lock);
> +			write_unlock_bh(&dev_base_lock);
>  			modified = 1;
>  		}
>  	}
> @@ -870,8 +870,8 @@ errout:
>  	if (send_addr_notify)
>  		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
>  
> -	if (modified)
> -		netdev_state_change(dev);
> +	if (modified && dev->flags & IFF_UP)
> +		call_netdevice_notifiers(NETDEV_CHANGE, dev);
>  
>  	return err;
>  }
> 
