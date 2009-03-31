Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbZCaUkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbZCaUkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZCaUkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:40:11 -0400
Received: from mail.vyatta.com ([76.74.103.46]:56588 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZCaUkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:40:09 -0400
Date: Tue, 31 Mar 2009 13:39:52 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 09/17] net: Add vbus_enet driver
Message-ID: <20090331133952.280373e9@nehalam>
In-Reply-To: <20090331184334.28333.8415.stgit@dev.haskins.net>
References: <20090331184057.28333.77287.stgit@dev.haskins.net>
	<20090331184334.28333.8415.stgit@dev.haskins.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 14:43:34 -0400
Gregory Haskins <ghaskins@novell.com> wrote:

> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  drivers/net/Kconfig     |   13 +
>  drivers/net/Makefile    |    1 
>  drivers/net/vbus-enet.c |  706 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 720 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/vbus-enet.c
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 62d732a..ac9dabd 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -3099,4 +3099,17 @@ config VIRTIO_NET
>  	  This is the virtual network driver for virtio.  It can be used with
>            lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
>  
> +config VBUS_ENET
> +	tristate "Virtual Ethernet Driver"
> +	depends on VBUS_DRIVERS
> +	help
> +	   A virtualized 802.x network device based on the VBUS interface.
> +	   It can be used with any hypervisor/kernel that supports the
> +	   vbus protocol.
> +
> +config VBUS_ENET_DEBUG
> +        bool "Enable Debugging"
> +	depends on VBUS_ENET
> +	default n
> +
>  endif # NETDEVICES
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index 471baaf..61db928 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -264,6 +264,7 @@ obj-$(CONFIG_FS_ENET) += fs_enet/
>  obj-$(CONFIG_NETXEN_NIC) += netxen/
>  obj-$(CONFIG_NIU) += niu.o
>  obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
> +obj-$(CONFIG_VBUS_ENET) += vbus-enet.o
>  obj-$(CONFIG_SFC) += sfc/
>  
>  obj-$(CONFIG_WIMAX) += wimax/
> diff --git a/drivers/net/vbus-enet.c b/drivers/net/vbus-enet.c
> new file mode 100644
> index 0000000..e698b3f
> --- /dev/null
> +++ b/drivers/net/vbus-enet.c
> @@ -0,0 +1,706 @@
> +/*
> + * vbus_enet - A virtualized 802.x network device based on the VBUS interface
> + *
> + * Copyright (C) 2009 Novell, Gregory Haskins <ghaskins@novell.com>
> + *
> + * Derived from the SNULL example from the book "Linux Device Drivers" by
> + * Alessandro Rubini, Jonathan Corbet, and Greg Kroah-Hartman, published
> + * by O'Reilly & Associates.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/moduleparam.h>
> +
> +#include <linux/sched.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +#include <linux/interrupt.h>
> +
> +#include <linux/in.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ip.h>
> +#include <linux/tcp.h>
> +#include <linux/skbuff.h>
> +#include <linux/ioq.h>
> +#include <linux/vbus_driver.h>
> +
> +#include <linux/in6.h>
> +#include <asm/checksum.h>
> +
> +#include <linux/venet.h>
> +
> +MODULE_AUTHOR("Gregory Haskins");
> +MODULE_LICENSE("GPL");
> +
> +static int napi_weight = 128;
> +module_param(napi_weight, int, 0444);
> +static int rx_ringlen = 256;
> +module_param(rx_ringlen, int, 0444);
> +static int tx_ringlen = 256;
> +module_param(tx_ringlen, int, 0444);
> +
> +#undef PDEBUG             /* undef it, just in case */
> +#ifdef VBUS_ENET_DEBUG
> +#  define PDEBUG(fmt, args...) printk(KERN_DEBUG "vbus_enet: " fmt, ## args)
> +#else
> +#  define PDEBUG(fmt, args...) /* not debugging: nothing */
> +#endif
> +
> +struct vbus_enet_queue {
> +	struct ioq              *queue;
> +	struct ioq_notifier      notifier;
> +};
> +
> +struct vbus_enet_priv {
> +	spinlock_t                 lock;
> +	struct net_device         *dev;
> +	struct vbus_device_proxy  *vdev;
> +	struct napi_struct         napi;
> +	struct net_device_stats    stats;

Not needed any more, stats are available in net_device

> +	struct vbus_enet_queue     rxq;
> +	struct vbus_enet_queue     txq;
> +	struct tasklet_struct      txtask;
> +};
> +

> + * Ioctl commands
> + */
> +static int
> +vbus_enet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> +{
> +	PDEBUG("ioctl\n");
> +	return 0;
> +}

If it doesn't do ioctl, just leave pointer as NULL

> +/*
> + * Return statistics to the caller
> + */
> +static struct net_device_stats *
> +vbus_enet_stats(struct net_device *dev)
> +{
> +	struct vbus_enet_priv *priv = netdev_priv(dev);
> +	return &priv->stats;
> +}

Not needed if you use internal net_device stats

> +static void
> +rx_isr(struct ioq_notifier *notifier)
> +{
> +	struct vbus_enet_priv *priv;
> +	struct net_device  *dev;
> +
> +	priv = container_of(notifier, struct vbus_enet_priv, rxq.notifier);
> +	dev = priv->dev;
> +
> +	if (!ioq_empty(priv->rxq.queue, ioq_idxtype_inuse))
> +		vbus_enet_schedule_rx(priv);
> +}
> +
> +static void
> +deferred_tx_isr(unsigned long data)
> +{
> +	struct vbus_enet_priv *priv = (struct vbus_enet_priv *)data;
> +	unsigned long flags;
> +
> +	PDEBUG("deferred_tx_isr for %lld\n", priv->vdev->id);
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +	vbus_enet_tx_reap(priv, 0);
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	ioq_notify_enable(priv->txq.queue, 0);
> +}
> +
> +static void
> +tx_isr(struct ioq_notifier *notifier)
> +{
> +       struct vbus_enet_priv *priv;
> +       unsigned long flags;
> +
> +       priv = container_of(notifier, struct vbus_enet_priv, txq.notifier);
> +
> +       PDEBUG("tx_isr for %lld\n", priv->vdev->id);
> +
> +       ioq_notify_disable(priv->txq.queue, 0);
> +       tasklet_schedule(&priv->txtask);
> +}
> +
> +static struct net_device_ops vbus_enet_netdev_ops = {

Should be const.

> +	.ndo_open          = vbus_enet_open,
> +	.ndo_stop          = vbus_enet_stop,
> +	.ndo_set_config    = vbus_enet_config,
> +	.ndo_start_xmit    = vbus_enet_tx_start,
> +	.ndo_change_mtu	   = vbus_enet_change_mtu,
> +	.ndo_do_ioctl      = vbus_enet_ioctl,
> +	.ndo_get_stats     = vbus_enet_stats,
> +	.ndo_tx_timeout    = vbus_enet_timeout,
> +};
> +
> +/*
> + * This is called whenever a new vbus_device_proxy is added to the vbus
> + * with the matching VENET_ID
> + */
> +static int
> +vbus_enet_probe(struct vbus_device_proxy *vdev)
> +{
> +	struct net_device  *dev;
> +	struct vbus_enet_priv *priv;
> +	int ret;
> +
> +	printk(KERN_INFO "VBUS_ENET: Found new device at %lld\n", vdev->id);
> +
> +	ret = vdev->ops->open(vdev, VENET_VERSION, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev = alloc_etherdev(sizeof(struct vbus_enet_priv));
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	priv = netdev_priv(dev);
> +	memset(priv, 0, sizeof(*priv));

Useless already done by alloc_etherdev

> +
> +	spin_lock_init(&priv->lock);
> +	priv->dev  = dev;
> +	priv->vdev = vdev;
> +
> +	tasklet_init(&priv->txtask, deferred_tx_isr, (unsigned long)priv);
> +
> +	queue_init(priv, &priv->rxq, VENET_QUEUE_RX, rx_ringlen, rx_isr);
> +	queue_init(priv, &priv->txq, VENET_QUEUE_TX, tx_ringlen, tx_isr);
> +
> +	rx_setup(priv);
> +
> +	ioq_notify_enable(priv->rxq.queue, 0);  /* enable interrupts */
> +	ioq_notify_enable(priv->txq.queue, 0);
> +
> +	ether_setup(dev); /* assign some of the fields */

Useless already done by alloc_etherdiv

> +
> +	dev->netdev_ops     = &vbus_enet_netdev_ops;
> +	dev->watchdog_timeo = 5 * HZ;
> +


Please consider adding basic set of ethtool_ops to allow controlling
offload, etc.
