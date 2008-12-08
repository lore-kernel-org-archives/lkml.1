Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYLHOnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYLHOnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYLHOnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:43:09 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37411 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbYLHOnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:43:07 -0500
Message-ID: <493D3276.5040506@us.ibm.com>
Date: Mon, 08 Dec 2008 08:43:02 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] virtio: do not statically allocate root device
References: <20081205184603.GC13133@suse.de> <1228736980-19539-1-git-send-email-markmc@redhat.com> <1228736980-19539-2-git-send-email-markmc@redhat.com>
In-Reply-To: <1228736980-19539-2-git-send-email-markmc@redhat.com>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> Apparently we shouldn't be statically allocating the root device
> object, so dynamically allocate it instead.
>
> Also add a release() function to avoid this warning:
>
>   Device 'virtio-pci' does not have a release() function, it is broken and must be fixed
>   

Is it really better to dynamically allocate the root device than 
statically allocate it?  Is the advice that we shouldn't statically 
allocate a device really a suggestion that if you're doing that, you're 
using struct device wrong?

If so, this conversion should be equally wrong.  Have you chosen to keep 
this device so that your initrd work-around continues to work as-is?  
What exactly is the work around and is there a less hackish way we could 
support it?

Regards,

Anthony Liguori

> Signed-off-by: Mark McLoughlin <markmc@redhat.com>
> Cc: Anthony Liguori <aliguori@us.ibm.com>
> ---
>  drivers/virtio/virtio_pci.c |   48 +++++++++++++++++++++++++++++++++++-------
>  1 files changed, 40 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index 265fdf2..939e0b4 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -73,10 +73,42 @@ MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
>  /* A PCI device has it's own struct device and so does a virtio device so
>   * we create a place for the virtio devices to show up in sysfs.  I think it
>   * would make more sense for virtio to not insist on having it's own device. */
> -static struct device virtio_pci_root = {
> -	.parent		= NULL,
> -	.init_name	= "virtio-pci",
> -};
> +static struct device *virtio_pci_root;
> +
> +static void virtio_pci_release_root(struct device *root)
> +{
> +	kfree(root);
> +}
> +
> +static int virtio_pci_init_root(void)
> +{
> +	struct device *root;
> +	int err = -ENOMEM;
> +
> +	root = kzalloc(sizeof(struct device), GFP_KERNEL);
> +	if (root == NULL)
> +		goto out;
> +
> +	err = dev_set_name(root, "virtio-pci");
> +	if (err)
> +		goto free_root;
> +
> +	err = device_register(root);
> +	if (err)
> +		goto free_root;
> +
> +	root->parent  = NULL;
> +	root->release = virtio_pci_release_root;
> +
> +	virtio_pci_root = root;
> +
> +	return 0;
> +
> +free_root:
> +	kfree(root);
> +out:
> +	return err;
> +}
>
>  /* Convert a generic virtio device to our structure */
>  static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
> @@ -343,7 +375,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
>  	if (vp_dev == NULL)
>  		return -ENOMEM;
>
> -	vp_dev->vdev.dev.parent = &virtio_pci_root;
> +	vp_dev->vdev.dev.parent = virtio_pci_root;
>  	vp_dev->vdev.dev.release = virtio_pci_release_dev;
>  	vp_dev->vdev.config = &virtio_pci_config_ops;
>  	vp_dev->pci_dev = pci_dev;
> @@ -437,13 +469,13 @@ static int __init virtio_pci_init(void)
>  {
>  	int err;
>
> -	err = device_register(&virtio_pci_root);
> +	err = virtio_pci_init_root();
>  	if (err)
>  		return err;
>
>  	err = pci_register_driver(&virtio_pci_driver);
>  	if (err)
> -		device_unregister(&virtio_pci_root);
> +		device_unregister(virtio_pci_root);
>
>  	return err;
>  }
> @@ -452,8 +484,8 @@ module_init(virtio_pci_init);
>
>  static void __exit virtio_pci_exit(void)
>  {
> -	device_unregister(&virtio_pci_root);
>  	pci_unregister_driver(&virtio_pci_driver);
> +	device_unregister(virtio_pci_root);
>  }
>
>  module_exit(virtio_pci_exit);
>   

