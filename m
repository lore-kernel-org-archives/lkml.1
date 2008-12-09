Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYLIQ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYLIQ50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYLIQ5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:57:17 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:2938 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYLIQ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:57:16 -0500
Message-ID: <493EA365.9070408@codemonkey.ws>
Date: Tue, 09 Dec 2008 10:57:09 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
References: <1228394671.3732.77.camel@blaa>	 <200812051043.51417.rusty@rustcorp.com.au> <1228489626.3858.37.camel@blaa>	 <200812071852.08962.rusty@rustcorp.com.au> <1228741409.3609.32.camel@blaa>	 <493D334D.6050004@us.ibm.com> <1228840890.26198.25.camel@blaa>
In-Reply-To: <1228840890.26198.25.camel@blaa>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> On Mon, 2008-12-08 at 08:46 -0600, Anthony Liguori wrote:
>   
> It feels a bit like busy work to generalise this since only virtio_pci
> can be built as a module, but here's a patch.
>
> The mkinitrd hack turns into:
>
>         # Handle finding virtio bus implementations
>         if [ -L ./virtio_module ] ; then
>             findmodule $(basename $(readlink ./virtio_module))
>         else if echo $PWD | grep -q /virtio-pci/ ; then
>             findmodule virtio_pci
>         fi; fi
>
> Cheers,
> Mark.
>
> [PATCH] virtio: add a 'virtio_module' sysfs symlink
>
> Add a way for userspace to determine which virtio bus transport a
> given device is associated with.
>
> This will be used by Fedora mkinitrd to generically determine e.g.
> that virtio_pci is needed to mount a given root filesystem.
>
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>
>   

Acked-by: Anthony Liguori <aliguori@us.ibm.com>

> ---
>  drivers/virtio/virtio.c       |   21 ++++++++++++++++++++-
>  drivers/virtio/virtio_pci.c   |    1 +
>  include/linux/virtio_config.h |    2 ++
>  3 files changed, 23 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 018c070..640ede8 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -189,13 +189,32 @@ int register_virtio_device(struct virtio_device *dev)
>  	 * matching driver. */
>  	err = device_register(&dev->dev);
>  	if (err)
> -		add_status(dev, VIRTIO_CONFIG_S_FAILED);
> +		goto out;
> +
> +	/* Create a virtio_module symlink */
> +	if (dev->config->owner) {
> +		struct module_kobject *mk = &dev->config->owner->mkobj;
> +
> +		err = sysfs_create_link(&dev->dev.kobj, &mk->kobj,
> +					"virtio_module");
> +		if (err)
> +			goto unreg;
> +	}
> +
> +	return 0;
> +
> +unreg:
> +	device_unregister(&dev->dev);
> +out:
> +	add_status(dev, VIRTIO_CONFIG_S_FAILED);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(register_virtio_device);
>  
>  void unregister_virtio_device(struct virtio_device *dev)
>  {
> +	if (dev->config->owner)
> +		sysfs_remove_link(&dev->dev.kobj, "virtio_module");
>  	device_unregister(&dev->dev);
>  }
>  EXPORT_SYMBOL_GPL(unregister_virtio_device);
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index 939e0b4..59e928d 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -328,6 +328,7 @@ static void vp_del_vq(struct virtqueue *vq)
>  }
>  
>  static struct virtio_config_ops virtio_pci_config_ops = {
> +	.owner		= THIS_MODULE,
>  	.get		= vp_get,
>  	.set		= vp_set,
>  	.get_status	= vp_get_status,
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index bf8ec28..0a01cda 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -33,6 +33,7 @@
>  
>  /**
>   * virtio_config_ops - operations for configuring a virtio device
> + * @owner: the module implementing these ops, usually THIS_MODULE
>   * @get: read the value of a configuration field
>   *	vdev: the virtio_device
>   *	offset: the offset of the configuration field
> @@ -68,6 +69,7 @@
>   */
>  struct virtio_config_ops
>  {
> +	struct module *owner;
>  	void (*get)(struct virtio_device *vdev, unsigned offset,
>  		    void *buf, unsigned len);
>  	void (*set)(struct virtio_device *vdev, unsigned offset,
>   

