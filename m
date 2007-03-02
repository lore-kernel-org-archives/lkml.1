Return-Path: <linux-kernel-owner+w=401wt.eu-S1422662AbXCBAnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422662AbXCBAnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422661AbXCBAng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:43:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60033 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422659AbXCBAnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:43:35 -0500
Date: Thu, 1 Mar 2007 16:42:14 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 26/26] Xen-paravirt_ops: Add the Xen virtual network
 device driver.
Message-ID: <20070301164214.4a40bc59@freekitty>
In-Reply-To: <20070301232529.648076372@goop.org>
References: <20070301232443.195603797@goop.org>
	<20070301232529.648076372@goop.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 15:25:09 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The network device frontend driver allows the kernel to access network
> devices exported exported by a virtual machine containing a physical
> network device driver.
> 
> Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
> Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: netdev@vger.kernel.org
> Cc: Jeff Garzik <jeff@garzik.org>
> 
> ---
>  drivers/net/Kconfig        |   12 
>  drivers/net/Makefile       |    2 
>  drivers/net/xen-netfront.c | 2066 ++++++++++++++++++++++++++++++++++++++++++++
>  include/xen/events.h       |    2 
>  4 files changed, 2082 insertions(+)
> 
> ===================================================================
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2525,6 +2525,18 @@ source "drivers/atm/Kconfig"
>  
>  source "drivers/s390/net/Kconfig"
>  
> +config XEN_NETDEV_FRONTEND
> +	tristate "Xen network device frontend driver"
> +	depends on XEN
> +	default y
> +	help
> +	  The network device frontend driver allows the kernel to
> +	  access network devices exported exported by a virtual
> +	  machine containing a physical network device driver. The
> +	  frontend driver is intended for unprivileged guest domains;
> +	  if you are compiling a kernel for a Xen guest, you almost
> +	  certainly want to enable this.
> +
>  config ISERIES_VETH
>  	tristate "iSeries Virtual Ethernet driver support"
>  	depends on PPC_ISERIES

Might make more sense earlier in list (near other virtual devices).
===================================================================
>
> +/*
> + * Mutually-exclusive module options to select receive data path:
> + *  rx_copy : Packets are copied by network backend into local memory
> + *  rx_flip : Page containing packet data is transferred to our ownership
> + * For fully-virtualised guests there is no option - copying must be used.
> + * For paravirtualised guests, flipping is the default.
> + */
> +#ifdef CONFIG_XEN


Hey I thought this driver depended on CONFIG_XEN already?

> +static int MODPARM_rx_copy = 0;
> +module_param_named(rx_copy, MODPARM_rx_copy, bool, 0);
> +MODULE_PARM_DESC(rx_copy, "Copy packets from network card (rather than flip)");
> +static int MODPARM_rx_flip = 0;
> +module_param_named(rx_flip, MODPARM_rx_flip, bool, 0);
> +MODULE_PARM_DESC(rx_flip, "Flip packets from network card (rather than copy)");
> +#else
> +static const int MODPARM_rx_copy = 1;
> +static const int MODPARM_rx_flip = 0;
> +#endif


No MIXED case variable names please.


Why have two mutually exclusive values instead of just one value
with three states: 0 = normal, 1 = copy, 2 = flip?


> +#define DPRINTK(fmt, args...)				\
> +	pr_debug("netfront (%s:%d) " fmt,		\
> +		 __FUNCTION__, __LINE__, ##args)
> +#define IPRINTK(fmt, args...)				\
> +	printk(KERN_INFO "netfront: " fmt, ##args)
> +#define WPRINTK(fmt, args...)				\
> +	printk(KERN_WARNING "netfront: " fmt, ##args)


Could you use dev_dbg, dev_info, dev_warn instead of these macros?

> +
> +/** Send a packet on a net device to encourage switches to learn the
> + * MAC. We send a fake ARP request.
> + *
> + * @param dev device
> + * @return 0 on success, error code otherwise
> + */
Why the sudden urge to use docbook format on one internal function.


> +static int send_fake_arp(struct net_device *dev)
> +{
> +	struct sk_buff *skb;
> +	u32             src_ip, dst_ip;
> +
> +	dst_ip = INADDR_BROADCAST;
> +	src_ip = inet_select_addr(dev, dst_ip, RT_SCOPE_LINK);
> +
> +	/* No IP? Then nothing to do. */
> +	if (src_ip == 0)
> +		return 0;
> +
> +	skb = arp_create(ARPOP_REPLY, ETH_P_ARP,
> +			 dst_ip, dev, src_ip,
> +			 /*dst_hw*/ NULL, /*src_hw*/ NULL,
> +			 /*target_hw*/ dev->dev_addr);
> +	if (skb == NULL)
> +		return -ENOMEM;
> +
> +	return dev_queue_xmit(skb);
> +}

This should probably be done in generic (non driver code).
It creates lots of dependencies here.

> +/*
> + * We use this notifier to send out a fake ARP reply to reset switches and
> + * router ARP caches when an IP interface is brought up on a VIF.
> + */
> +static int
> +inetdev_notify(struct notifier_block *this, unsigned long event, void *ptr)
> +{
> +	struct in_ifaddr  *ifa = (struct in_ifaddr *)ptr;
> +	struct net_device *dev = ifa->ifa_dev->dev;
> +
> +	/* UP event and is it one of our devices? */
> +	if (event == NETDEV_UP && dev->open == network_open)
> +		(void)send_fake_arp(dev);
> +
> +	return NOTIFY_DONE;
> +}

Shouldn't just be a global kernel option for gratuitous ARP.
Doesn't seem to be unique to this driver.
With sysctl to enable it.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
