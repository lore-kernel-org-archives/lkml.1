Return-Path: <linux-kernel-owner+w=401wt.eu-S934742AbYETW2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742AbYETW2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbYETW2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:28:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:59566 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbYETW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Hj+IExP5Tr6FH/B0ggaKFpuvPPwFLMtlfcy1RCy7JpgjwVs7e3nOV9NcIk2gYdLQXYr+iWxFWeYDdCK0eWZb404fdPDe0tUdq7x/oAP4tVzKKlZb4Da/PxnK38VJm4hOd+JKEQRywDkQlkfgyEqdxykEI53rNRm/AOMBHpFk0g0=
Message-ID: <48335046.4080303@gmail.com>
Date: Wed, 21 May 2008 00:27:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Anas Nashif <nashif@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
References: <4832174A.20905@linux.intel.com>
In-Reply-To: <4832174A.20905@linux.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2008 02:11 AM, Anas Nashif wrote:
> We have addressed more issues raised on lkml after initial submission,
> especially the legacy device support issue which was removed in this
> patch.
> 
> The Intel Management Engine Interface (aka HECI: Host Embedded
> Controller Interface ) enables communication between the host OS and
> the Management Engine firmware. MEI is bi-directional, and either the
> host or Intel AMT firmware can initiate transactions.
[...]
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index 5407b76..26c81a0 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -106,6 +106,7 @@ obj-$(CONFIG_IPMI_HANDLER)	+= ipmi/
> 
>  obj-$(CONFIG_HANGCHECK_TIMER)	+= hangcheck-timer.o
>  obj-$(CONFIG_TCG_TPM)		+= tpm/
> +obj-$(CONFIG_HECI)              += heci/

Who sets this config up?

> 
>  obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
> 
[...]
> diff --git a/drivers/char/heci/heci_init.c b/drivers/char/heci/heci_init.c
> new file mode 100644
> index 0000000..ffd4f7f
> --- /dev/null
> +++ b/drivers/char/heci/heci_init.c
> @@ -0,0 +1,1104 @@
[...]
> +static int heci_wait_event_int_timeout(struct iamt_heci_device *dev,
> +		long timeout)
> +{
> +	int err = 0;
> +
> +	err = wait_event_interruptible_timeout(dev->wait_recvd_msg,
> +			(dev->recvd_msg), timeout);
> +	return err;
> +}

return wait_event_interruptible_timeout();

[...]
> +static int host_start_message(struct iamt_heci_device *dev)
> +{
> +	long timeout = 60;	/* 60 second */
> +
> +	struct heci_msg_hdr *heci_hdr;
> +	struct hbm_host_version_request *host_start_req;
> +	struct hbm_host_stop_request *host_stop_req;
> +	int err = 0;
> +
> +	/* host start message */
> +	heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
> +	heci_hdr->host_addr = 0;
> +	heci_hdr->me_addr = 0;
> +	heci_hdr->length = sizeof(struct hbm_host_version_request);
> +	heci_hdr->msg_complete = 1;
> +	heci_hdr->reserved = 0;
> +
> +	host_start_req =
> +	    (struct hbm_host_version_request *) &dev->wr_msg_buf[1];
> +	memset(host_start_req, 0, sizeof(host_start_req));

wrong memset

> +	host_start_req->cmd.cmd = HOST_START_REQ_CMD;
> +	host_start_req->reserved = 0;
> +	host_start_req->host_version.major_version = HBM_MAJOR_VERSION;
> +	host_start_req->host_version.minor_version = HBM_MINOR_VERSION;
> +	dev->recvd_msg = 0;
> +	if (!heci_write_message(dev, heci_hdr,
> +				       (unsigned char *) (host_start_req),
> +				       heci_hdr->length)) {
> +		DBG("send version to fw fail.\n");
> +		return -ENODEV;
> +	}
> +	DBG("call wait_event_interruptible_timeout for response message.\n");
> +	/* wait for response */
> +	err = heci_wait_event_int_timeout(dev, timeout * HZ);
> +	if (!err && !dev->recvd_msg) {
> +		DBG("wait_timeout failed on host start response message.\n");
> +		return -ENODEV;
> +	}
> +	dev->recvd_msg = 0;
> +	DBG("wait_timeout successful on host start response message.\n");
> +	if ((dev->version.major_version != HBM_MAJOR_VERSION) ||
> +	    (dev->version.minor_version != HBM_MINOR_VERSION)) {
> +		/* send stop message */
> +		heci_hdr->host_addr = 0;
> +		heci_hdr->me_addr = 0;
> +		heci_hdr->length = sizeof(struct hbm_host_stop_request);
> +		heci_hdr->msg_complete = 1;
> +		heci_hdr->reserved = 0;
> +
> +		host_stop_req =
> +		    (struct hbm_host_stop_request *) &dev->wr_msg_buf[1];
> +
> +		memset(host_stop_req, 0, sizeof(host_stop_req));

same here

> +		host_stop_req->cmd.cmd = HOST_STOP_REQ_CMD;
> +		host_stop_req->reason = DRIVER_STOP_REQUEST;
> +		memset(host_stop_req->reserved, 0,
> +		       sizeof(host_stop_req->reserved));
> +		heci_write_message(dev, heci_hdr,
> +				   (unsigned char *) (host_stop_req),
> +				   heci_hdr->length);
> +		DBG("version mismatch.\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
[...]
> +static void host_init_wd(struct iamt_heci_device *dev)
> +{
> +
> +	spin_lock_bh(&dev->device_lock);
> +
> +	heci_init_file_private(&dev->wd_file_ext, NULL);
> +
> +	/* look for WD client and connect to it */
> +	dev->wd_file_ext.state = HECI_FILE_DISCONNECTED;
> +	dev->wd_timeout = 0;
> +
> +	heci_check_asf_mode(dev);
> +	if (dev->asf_mode) {
> +		memcpy(dev->wd_data, stop_wd_params, HECI_WD_PARAMS_SIZE);
> +	} else {
> +		/* AMT mode */
> +		dev->wd_timeout = AMT_WD_VALUE;
> +		DBG("dev->wd_timeout=%d.\n", dev->wd_timeout);
> +		memcpy(dev->wd_data, start_wd_params, HECI_WD_PARAMS_SIZE);
> +		memcpy(dev->wd_data + HECI_WD_PARAMS_SIZE,
> +		       &dev->wd_timeout, sizeof(__u16));
> +	}
> +
> +	/* find ME WD client */
> +	heci_find_me_client(dev, &dev->wd_file_ext,
> +			    &heci_wd_guid, HECI_WD_HOST_CLIENT_ID);
> +	spin_unlock_bh(&dev->device_lock);
> +
> +	DBG("check wd_file_ext\n");
> +	if (HECI_FILE_CONNECTING == dev->wd_file_ext.state) {
> +		if (heci_connect_me_client(dev, &dev->wd_file_ext, 15) == 1) {
> +			DBG("dev->wd_timeout=%d.\n", dev->wd_timeout);
> +			if (dev->wd_timeout != 0)
> +				dev->wd_due_counter = 1;
> +			else
> +				dev->wd_due_counter = 0;
> +			DBG("successfully connected to WD client.\n");
> +		}
> +	} else
> +		DBG("failed to find WD client.\n");
> +
> +
> +	spin_lock_bh(&dev->device_lock);
> +	dev->wd_timer.function = &heci_wd_timer;
> +	dev->wd_timer.data = (unsigned long) dev;

setup_timer?

> +	spin_unlock_bh(&dev->device_lock);
> +}
[...]
> +struct heci_file_private *alloc_priv(struct file *file)

not a good name.

> +{
[...]
> +int heci_disconnect_host_client(struct iamt_heci_device *dev,
> +		struct heci_file_private *file_ext)
> +{
> +	int rets = 0, err = 0;

no need to init them

> +	long timeout = 15;	/*15 second */
> +	struct heci_cb_private *priv_cb = NULL;
[...]
> diff --git a/drivers/char/heci/heci_interface.c b/drivers/char/heci/heci_interface.c
> new file mode 100644
> index 0000000..6369dd0
> --- /dev/null
> +++ b/drivers/char/heci/heci_interface.c
> @@ -0,0 +1,497 @@
[...]
> +int flow_ctrl_creds(struct iamt_heci_device *dev,
> +				   struct heci_file_private *file_ext)
> +{
> +	__u8 i;
> +
> +	if (!dev->num_heci_me_clients)
> +		return 0;
> +
> +	if (file_ext == NULL)
> +		return 0;
> +
> +	if (file_ext->flow_ctrl_creds > 0)
> +		return 1;
> +
> +	for (i = 0; i < dev->num_heci_me_clients; i++) {
> +		if (dev->me_clients[i].client_id == file_ext->me_client_id) {
> +			if (dev->me_clients[i].flow_ctrl_creds > 0) {
> +				BUG_ON(dev->me_clients[i].props.single_recv_buf
> +					 == 0);
> +				return 1;
> +			}
> +			return 0;
> +		}
> +	}
> +	BUG_ON(1);

So just BUG();

> +	return 0;
> +}
> +
> +/**
> + * flow_ctrl_reduce  - reduce flow_control .
> + *
> + * @dev -Device object for our driver
> + * @file_ext -extension of the file object
> + */
> +void flow_ctrl_reduce(struct iamt_heci_device *dev,
> +			 struct heci_file_private *file_ext)
> +{
> +	__u8 i;
> +
> +	if (!dev->num_heci_me_clients)
> +		return;
> +
> +	for (i = 0; i < dev->num_heci_me_clients; i++) {
> +		if (dev->me_clients[i].client_id == file_ext->me_client_id) {
> +			if (dev->me_clients[i].props.single_recv_buf != 0) {
> +				BUG_ON(dev->me_clients[i].flow_ctrl_creds <= 0);
> +				dev->me_clients[i].flow_ctrl_creds--;
> +			} else {
> +				BUG_ON(file_ext->flow_ctrl_creds <= 0);
> +				file_ext->flow_ctrl_creds--;
> +			}
> +			return;
> +		}
> +	}
> +	BUG_ON(1);

ditto

> +}
> +
> +/**
> + * heci_send_flow_control  - send flow control to fw.
> + *
> + * @dev -Device object for our driver
> + * @file_ext -extension of the file object
> + *
> + * @return :
> + * 1 if success
> + * 0 - otherwise.
> + */
> +int heci_send_flow_control(struct iamt_heci_device *dev,
> +				 struct heci_file_private *file_ext)
> +{
> +	struct heci_msg_hdr *heci_hdr;
> +	struct hbm_flow_control *heci_flow_control;
> +
> +	heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
> +	heci_hdr->host_addr = 0;
> +	heci_hdr->me_addr = 0;
> +	heci_hdr->length = sizeof(struct hbm_flow_control);
> +	heci_hdr->msg_complete = 1;
> +	heci_hdr->reserved = 0;
> +
> +	heci_flow_control = (struct hbm_flow_control *) &dev->wr_msg_buf[1];
> +	memset(heci_flow_control, 0, sizeof(heci_flow_control));

again?

> +	heci_flow_control->host_addr = file_ext->host_client_id;
> +	heci_flow_control->me_addr = file_ext->me_client_id;
> +	heci_flow_control->cmd.cmd = FLOW_CONTROL_CMD;
[...]
> diff --git a/drivers/char/heci/heci_interface.h b/drivers/char/heci/heci_interface.h
> new file mode 100644
> index 0000000..4081fd3
> --- /dev/null
> +++ b/drivers/char/heci/heci_interface.h
> @@ -0,0 +1,169 @@
[...]
> +/* IOCTL commands */
> +#define HECI_IOCTL_LETTER 'H'

'H'     all     linux/hiddev.h

add

> +#define IOCTL_HECI_GET_VERSION \
> +    _IOWR(HECI_IOCTL_LETTER , 0x800, struct heci_message_data)
> +#define IOCTL_HECI_CONNECT_CLIENT \
> +    _IOWR(HECI_IOCTL_LETTER , 0x801, struct heci_message_data)
> +#define IOCTL_HECI_WD \
> +    _IOWR(HECI_IOCTL_LETTER , 0x802, struct heci_message_data)
> +#define IOCTL_HECI_BYPASS_WD \
> +    _IOWR(HECI_IOCTL_LETTER , 0x810, struct heci_message_data)

struct heci_message_data is not 32/64-bit friendly
_IOC_NRBITS is 8, 0x800 is far higher than that

[...]
> diff --git a/drivers/char/heci/heci_main.c b/drivers/char/heci/heci_main.c
> new file mode 100644
> index 0000000..608e1c7
> --- /dev/null
> +++ b/drivers/char/heci/heci_main.c
> @@ -0,0 +1,1544 @@
[...]
> +#ifdef HECI_DEBUG
> +int heci_debug = 1;
> +#else
> +int heci_debug;  /* initialized to 0 automatically.*/

we know that, comment unneeded

> +#endif
> +MODULE_PARM_DESC(heci_debug,  "Debug enabled or not");

so why not bool?

> +module_param(heci_debug, int, 0644);
> +
> +
[...]
> +/* heci_pci_tbl - PCI Device ID Table */
> +static struct pci_device_id heci_pci_tbl[] = {
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID01)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID02)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID03)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID04)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID05)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID06)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID07)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID08)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID09)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID10)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID11)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID12)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID13)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID14)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID15)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID16)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID17)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID18)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID19)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID20)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID21)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID22)},
> +	/* required last entry */
> +	{0, }

PCI_VDEVICE?

[...]
> +static struct pci_driver heci_driver = {
> +	.name = heci_driver_name,
> +	.id_table = heci_pci_tbl,
> +	.probe = heci_probe,
> +	.remove = heci_remove,

__devexit_p()

> +	.shutdown = heci_remove,

you'll trigger remove twice, I think.

> +#ifdef CONFIG_PM
> +	.suspend = heci_suspend,
> +	.resume = heci_resume
> +#endif

define them as null on !PM to avoid these ifdefs.

> +};
[...]
> +static int heci_registration_cdev(struct cdev *dev, int hminor,
> +				  struct file_operations *fops)
> +{
> +	int ret = 0, devno = MKDEV(heci_major, hminor);

do not init ret

> +
> +	cdev_init(dev, fops);
> +	dev->owner = THIS_MODULE;
> +	dev->ops = fops;

no need to re-set

> +	ret = cdev_add(dev, devno, 1);
> +	/* Fail gracefully if need be */
> +	if (ret) {
> +		kobject_put(&dev->kobj);

why?

> +		printk(KERN_ERR "%s: Error %d registering heci device %d\n",
> +		       THIS_MODULE->name, ret, hminor);
> +	}
> +	return ret;
> +}
> +
> +/* Display the version of heci driver. */
> +static ssize_t version_show(struct class *dev, char *buf)
> +{
> +	return sprintf(buf, "%s %s.\n",
> +		       heci_driver_string, heci_driver_version);
> +}
> +
> +static CLASS_ATTR(version, S_IRUGO, version_show, NULL);
> +
> +/**
> + * heci_sysfs_create - creates a struct class to contain heci info
> + * @owner  - pointer to the module that is to "own" heci sysfs class
> + * @name   - pointer to a string for the name of this class

the format is:
(* @parameterx(space)*: (description of parameter x)?)*

> + *
> + * @return :
> + * valid pointer to a struct class on success
> + * false pointer on failure
> + */
> +static struct class *heci_sysfs_create(struct module *owner, char *name)
[...]
> +/**
> + * heci_sysfs_device_create - adds two devices to sysfs for chararcter devices
> + * @cs      - pointer to the struct class that the device to be registered on
> + *
> + * @return :
> + * 0 on success,
> + * negative on failure
> + */
> +static int heci_sysfs_device_create(struct class *cs)
> +{
> +	int err = 0;
> +
> +	if ((cs == NULL) || (IS_ERR(cs))) {
> +		err = -EINVAL;
> +		goto err_out;
> +	}
> +
> +	heci_class_dev = class_device_create(cs, NULL,
> +					     heci_cdev.dev,
> +					     NULL,
> +					     HECI_DEV_NAME);

device_create

> +	if (IS_ERR(heci_class_dev))
> +		err = PTR_ERR(heci_class_dev);
> +
> +err_out:
> +	return err;
> +}
[...]
> +static int __init heci_init_module(void)
> +{
> +	int ret = 0;
> +	dev_t dev;
> +
> +	printk(KERN_INFO "%s: %s - version %s\n",
> +	       THIS_MODULE->name, heci_driver_string, heci_driver_version);
> +	printk(KERN_INFO "%s: %s\n", THIS_MODULE->name, heci_copyright);
> +
> +	/* init pci module */
> +	ret = pci_register_driver(&heci_driver);
> +	if (ret < 0)
> +		goto end;
> +
> +	/* registration char devices */
> +	ret = alloc_chrdev_region(&dev, HECI_MINORS_BASE, HECI_MINORS_COUNT,
> +				  HECI_DRIVER_NAME);

just one minor? why not misc_register?

> +
> +	heci_major = MAJOR(dev);
[...]
> +static int __devinit heci_probe(struct pci_dev *pdev,
> +				const struct pci_device_id *ent)
> +{
> +	struct iamt_heci_device *dev = NULL;
> +	int i, err = 0;
> +
> +	if (heci_device) {
> +		err = -EEXIST;
> +		goto end;
> +	}
> +	/* enable pci dev */
> +	err = pci_enable_device(pdev);
> +	if (err) {
> +		printk(KERN_ERR "%s: Failed to enable pci device.\n",
> +		       THIS_MODULE->name);
> +		goto end;
> +	}
> +	/* set PCI host mastering  */
> +	pci_set_master(pdev);
> +	/* pci request regions for heci driver */
> +	err = pci_request_regions(pdev, heci_driver_name);
> +	if (err) {
> +		printk(KERN_ERR "%s: Failed to get pci regions.\n",
> +		       THIS_MODULE->name);
> +		goto disable_device;
> +	}
> +	/* allocates and initializes the heci dev structure */
> +	dev = init_heci_device(pdev);
> +	if (!dev) {
> +		err = -ENOMEM;
> +		goto release_regions;
> +	}
> +	/* mapping  IO device memory */
> +	for (i = BAR_0; i <= BAR_5; i++) {
> +		if (pci_resource_len(pdev, i) == 0)
> +			continue;
> +		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
> +			printk(KERN_ERR "%s: heci has an IO ports.\n",
> +			       THIS_MODULE->name);
> +			goto free_device;
> +		} else if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
> +			if (dev->mem_base) {
> +				printk(KERN_ERR "%s: Too many mem addresses.\n",
> +				       THIS_MODULE->name);
> +				goto free_device;
> +			}
> +			dev->mem_base = pci_resource_start(pdev, i);
> +			dev->mem_length = pci_resource_len(pdev, i);
> +		}
> +	}
> +	if (!dev->mem_base) {
> +		printk(KERN_ERR "%s: No address to use.\n", THIS_MODULE->name);
> +		err = -ENODEV;
> +		goto free_device;
> +	}
> +	dev->mem_addr = ioremap_nocache(dev->mem_base,
> +			dev->mem_length);
> +	if (!dev->mem_addr) {
> +		printk(KERN_ERR "%s: Remap IO device memory failure.\n",
> +		       THIS_MODULE->name);
> +		err = -ENOMEM;
> +		goto free_device;
> +	}
> +	/* request and enable interrupt   */
> +	dev->irq = pdev->irq;
> +	err = request_irq(dev->irq, heci_isr_interrupt, IRQF_SHARED,
> +			heci_driver_name, dev);
> +	if (err) {
> +		printk(KERN_ERR "%s: Request_irq failure. irq = %d \n",
> +		       THIS_MODULE->name, dev->irq);
> +		goto unmap_memory;
> +	}
> +
> +	if (heci_hw_init(dev)) {
> +		printk(KERN_ERR "%s: Init hw failure.\n", THIS_MODULE->name);

This can be built tristate, right? What if THIS_MODULE is 0.

Use dev_* prints anyway.

> +		err = -ENODEV;
> +		goto release_irq;
> +	}
> +	init_timer(&dev->wd_timer);

not needed, if heci_initialize_clients called setup_timer

> +	msleep(100); /* FW needs time to be ready to talk with us */
> +	heci_initialize_clients(dev);
> +	if (dev->heci_state != HECI_ENABLED) {
> +		err = -ENODEV;
> +		goto release_hw;
> +	}
[...]
> +static void __devexit heci_remove(struct pci_dev *pdev)
> +{
> +	struct iamt_heci_device *dev = pci_get_drvdata(pdev);
> +	int err = 0;
> +
> +	if (heci_device != pdev)
> +		return;
> +
> +	if (dev == NULL)
> +		return;
> +
> +	spin_lock_bh(&dev->device_lock);
> +	if (dev->reinit_tsk != NULL) {
> +		kthread_stop(dev->reinit_tsk);
> +		dev->reinit_tsk = NULL;
> +	}
> +	spin_unlock_bh(&dev->device_lock);
> +
> +	del_timer_sync(&dev->wd_timer);
> +	if (dev->wd_file_ext.state == HECI_FILE_CONNECTED
> +	    && dev->wd_timeout) {
> +		spin_lock_bh(&dev->device_lock);
> +		dev->wd_timeout = 0;
> +		dev->wd_due_counter = 0;
> +		memcpy(dev->wd_data, stop_wd_params, HECI_WD_PARAMS_SIZE);
> +		dev->stop = 1;
> +		if (dev->host_buffer_is_empty &&
> +		    flow_ctrl_creds(dev, &dev->wd_file_ext)) {
> +			dev->host_buffer_is_empty = 0;
> +
> +			if (!heci_send_wd(dev))
> +				DBG("send stop WD failed\n");
> +			else
> +				flow_ctrl_reduce(dev, &dev->wd_file_ext);
> +
> +			dev->wd_pending = 0;
> +		} else {
> +			dev->wd_pending = 1;
> +		}
> +		spin_unlock_bh(&dev->device_lock);
> +		dev->wd_stoped = 0;
> +
> +		err = wait_event_interruptible_timeout(dev->wait_stop_wd,
> +				(dev->wd_stoped), 10 * HZ);

What is the retval for?

> +		if (!dev->wd_stoped)
> +			DBG("stop wd failed to complete.\n");
> +		else
> +			DBG("stop wd complete.\n");
> +
> +	}
> +
> +	heci_device = NULL;
> +	if (dev->iamthif_file_ext.status == HECI_FILE_CONNECTED) {
> +		dev->iamthif_file_ext.status = HECI_FILE_DISCONNECTING;
> +		heci_disconnect_host_client(dev,
> +					    &dev->iamthif_file_ext);
> +	}
> +	if (dev->wd_file_ext.status == HECI_FILE_CONNECTED) {
> +		dev->wd_file_ext.status = HECI_FILE_DISCONNECTING;
> +		heci_disconnect_host_client(dev,
> +					    &dev->wd_file_ext);
> +	}
> +
> +	spin_lock_bh(&dev->device_lock);
> +
> +	/* remove entry if already in list */
> +	DBG("list del iamthif and wd file list.\n");
> +	heci_remove_client_from_file_list(dev, dev->wd_file_ext.
> +					  host_client_id);
> +	heci_remove_client_from_file_list(dev,
> +			dev->iamthif_file_ext.host_client_id);
> +
> +	dev->iamthif_current_cb = NULL;
> +	dev->iamthif_file_ext.file = NULL;
> +	dev->num_heci_me_clients = 0;
> +
> +	spin_unlock_bh(&dev->device_lock);
> +
> +	flush_scheduled_work();
> +	/* disable interrupts */
> +	dev->host_hw_state &= ~H_IE;
> +	/* acknowledge interrupt and stop interupts */
> +	write_heci_register(dev, H_CSR, dev->host_hw_state);

PCI posting?

> +	free_irq(pdev->irq, dev);
> +	pci_set_drvdata(pdev, NULL);
> +
> +	if (dev->mem_addr)
> +		iounmap(dev->mem_addr);
> +
> +	kfree(dev);
> +
> +	pci_release_regions(pdev);
> +	pci_disable_device(pdev);
> +}
[...]
> +static ssize_t heci_read(struct file *file, char __user *ubuf,
> +			 size_t length, loff_t *offset)
> +{
> +	int i;
> +	int rets = 0, err = 0;
> +	int if_num = MINOR((file->f_dentry->d_inode->i_rdev));

iminor?

> +	struct heci_file_private *file_ext = file->private_data;
> +	struct heci_cb_private *priv_cb_pos = NULL;
> +	struct heci_cb_private *priv_cb = NULL;
> +	struct iamt_heci_device *dev = NULL;
> +
> +	if (!heci_device)
> +		return -ENODEV;
> +
> +	dev = pci_get_drvdata(heci_device);
> +	if ((if_num != HECI_MINOR_NUMBER) || (!dev) || (!file_ext))
> +		return -ENODEV;
> +
> +	spin_lock_bh(&dev->device_lock);
> +	if (dev->heci_state != HECI_ENABLED) {
> +		spin_unlock_bh(&dev->device_lock);
> +		return -ENODEV;
> +	}
> +	spin_unlock_bh(&dev->device_lock);
> +
> +	spin_lock(&file_ext->file_lock);
> +	if ((file_ext->sm_state & HECI_WD_STATE_INDEPENDENCE_MSG_SENT) == 0) {
> +		spin_unlock(&file_ext->file_lock);
> +		/* Do not allow to read watchdog client */
> +		for (i = 0; i < dev->num_heci_me_clients; i++) {
> +			if (memcmp(&heci_wd_guid,
> +				   &dev->me_clients[i].props.protocol_name,
> +				   sizeof(struct guid)) == 0) {
> +				if (file_ext->me_client_id ==
> +				    dev->me_clients[i].client_id)
> +					return -EBADF;
> +			}
> +		}
> +	} else {
> +		file_ext->sm_state &= ~HECI_WD_STATE_INDEPENDENCE_MSG_SENT;
> +		spin_unlock(&file_ext->file_lock);
> +	}
> +
> +	if (file_ext == &dev->iamthif_file_ext) {
> +		rets = pthi_read(dev, if_num, file, ubuf, length, offset);
> +		goto out;
> +	}
> +
> +	if (file_ext->read_cb && file_ext->read_cb->information > *offset) {
> +		priv_cb = file_ext->read_cb;
> +		goto copy_buffer;
> +	} else if (file_ext->read_cb && file_ext->read_cb->information > 0 &&
> +		   file_ext->read_cb->information <= *offset) {
> +		priv_cb = file_ext->read_cb;
> +		rets = 0;
> +		goto free;
> +	} else if ((!file_ext->read_cb || file_ext->read_cb->information == 0)
> +		    && *offset > 0) {
> +		/*Offset needs to be cleaned for contingous reads*/
> +		*offset = 0;
> +		rets = 0;
> +		goto out;
> +	}
> +
> +	spin_lock(&file_ext->read_io_lock);
> +	err = heci_start_read(dev, if_num, file_ext);
> +	if (err != 0 && err != -EBUSY) {
> +		DBG("heci start read failure with status = %d\n", err);
> +		spin_unlock(&file_ext->read_io_lock);
> +		rets = err;
> +		goto out;
> +	}
> +	if (HECI_READ_COMPLETE != file_ext->reading_state
> +			&& !waitqueue_active(&file_ext->rx_wait)) {
> +		if (file->f_flags & O_NONBLOCK) {
> +			rets = -EAGAIN;
> +			spin_unlock(&file_ext->read_io_lock);
> +			goto out;
> +		}
> +		spin_unlock(&file_ext->read_io_lock);
> +
> +		if (wait_event_interruptible(file_ext->rx_wait,
> +			(HECI_READ_COMPLETE == file_ext->reading_state
> +			 || HECI_FILE_INITIALIZING == file_ext->state
> +			 || HECI_FILE_DISCONNECTED == file_ext->state
> +			 || HECI_FILE_DISCONNECTING == file_ext->state))) {
> +			if (signal_pending(current)) {
> +				rets = -EINTR;
> +				goto out;
> +			}
> +			return -ERESTARTSYS;
> +		}
> +
> +		if (HECI_FILE_INITIALIZING == file_ext->state ||
> +		    HECI_FILE_DISCONNECTED == file_ext->state ||
> +		    HECI_FILE_DISCONNECTING == file_ext->state) {
> +			rets = -EBUSY;
> +			goto out;
> +		}
> +		spin_lock(&file_ext->read_io_lock);
> +	}
> +
> +	priv_cb = file_ext->read_cb;
> +
> +	if (!priv_cb) {
> +		spin_unlock(&file_ext->read_io_lock);
> +		return -ENODEV;
> +	}
> +	if (file_ext->reading_state != HECI_READ_COMPLETE) {
> +		spin_unlock(&file_ext->read_io_lock);
> +		return 0;
> +	}
> +	spin_unlock(&file_ext->read_io_lock);
> +	/* now copy the data to user space */
> +copy_buffer:
> +	DBG("priv_cb->response_buffer size - %d\n",
> +	    priv_cb->response_buffer.size);
> +	DBG("priv_cb->information - %lu\n",
> +	    priv_cb->information);
> +	if (length == 0 || ubuf == NULL ||
> +	    *offset > priv_cb->information) {
> +		rets = -EMSGSIZE;
> +		goto free;
> +	}
> +
> +	/* length is being turncated to PAGE_SIZE, however, */
> +	/* information size may be longer */
> +	length = (length < (priv_cb->information - *offset) ?
> +			length : (priv_cb->information - *offset));
> +
> +	if (copy_to_user(ubuf,
> +			 priv_cb->response_buffer.data + *offset,
> +			 length)) {
> +		rets = -EFAULT;
> +		goto free;
> +	} else {

no need to 'else' here

> +		rets = length;
> +		*offset += length;
> +		if ((unsigned long)*offset < priv_cb->information)
> +			goto out;
> +	}
> +free:
> +	spin_lock_bh(&dev->device_lock);
> +	priv_cb_pos = find_read_list_entry(dev, file_ext);
> +	/* Remove entry from read list */
> +	if (priv_cb_pos != NULL)
> +		list_del(&priv_cb_pos->cb_list);
> +	spin_unlock_bh(&dev->device_lock);
> +	heci_free_cb_private(priv_cb);
> +	spin_lock(&file_ext->read_io_lock);
> +	file_ext->reading_state = HECI_IDLE;
> +	file_ext->read_cb = NULL;
> +	file_ext->read_pending = 0;
> +	spin_unlock(&file_ext->read_io_lock);
> +out:	DBG("end heci read rets= %d\n", rets);
> +	return rets;
> +}
> +
> +/**
> + * heci_write - the write function.
> + */
> +static ssize_t heci_write(struct file *file, const char __user *ubuf,
> +			  size_t length, loff_t *offset)
> +{
> +	int rets = 0;
> +	__u8 i;
> +	int if_num = MINOR((file->f_dentry->d_inode->i_rdev));

...

> +	struct heci_file_private *file_ext = file->private_data;
> +	struct heci_cb_private *priv_write_cb = NULL;
> +	struct heci_msg_hdr heci_hdr;
> +	struct iamt_heci_device *dev = NULL;
> +	unsigned long currtime = get_seconds();
[...]
> +static int heci_ioctl(struct inode *inode, struct file *file,
> +		      unsigned int cmd, unsigned long data)

->unlocked_ioctl

> +{
> +	int rets = 0;
> +	int if_num = MINOR(inode->i_rdev);
> +	struct heci_file_private *file_ext = file->private_data;
> +	/* in user space */
> +	struct heci_message_data *u_msg = (struct heci_message_data *) data;
> +	struct heci_message_data k_msg;	/* all in kernel on the stack */
> +	struct iamt_heci_device *dev = NULL;
[...]
> +#ifdef CONFIG_PM
> +static int heci_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct iamt_heci_device *device = pci_get_drvdata(pdev);
> +	int err = 0;
> +
> +	spin_lock_bh(&device->device_lock);
> +	if (device->reinit_tsk != NULL) {
> +		kthread_stop(device->reinit_tsk);
> +		device->reinit_tsk = NULL;
> +	}
> +	spin_unlock_bh(&device->device_lock);
> +
> +	/* Stop watchdog if exists */
> +	del_timer_sync(&device->wd_timer);
> +	if (device->wd_file_ext.state == HECI_FILE_CONNECTED
> +	    && device->wd_timeout) {
> +		spin_lock_bh(&device->device_lock);
> +		g_sus_wd_timeout = device->wd_timeout;
> +		device->wd_timeout = 0;
> +		device->wd_due_counter = 0;
> +		memcpy(device->wd_data, stop_wd_params, HECI_WD_PARAMS_SIZE);
> +		device->stop = 1;
> +		if (device->host_buffer_is_empty &&
> +		    flow_ctrl_creds(device, &device->wd_file_ext)) {
> +			device->host_buffer_is_empty = 0;
> +			if (!heci_send_wd(device))
> +				DBG("send stop WD failed\n");
> +			else
> +				flow_ctrl_reduce(device, &device->wd_file_ext);
> +
> +			device->wd_pending = 0;
> +		} else {
> +			device->wd_pending = 1;
> +		}
> +		spin_unlock_bh(&device->device_lock);
> +		device->wd_stoped = 0;
> +
> +		err = wait_event_interruptible_timeout(device->wait_stop_wd,
> +						       (device->wd_stoped),
> +						       10 * HZ);
> +		if (!device->wd_stoped)
> +			DBG("stop wd failed to complete.\n");
> +		else {
> +			DBG("stop wd complete %d.\n", err);
> +			err = 0;
> +		}
> +	}
> +	/* Set new heci state */
> +	spin_lock_bh(&device->device_lock);
> +	if (device->heci_state == HECI_ENABLED ||
> +	    device->heci_state == HECI_RECOVERING_FROM_RESET) {
> +		device->heci_state = HECI_POWER_DOWN;
> +		heci_reset(device, 0);
> +	}
> +	spin_unlock_bh(&device->device_lock);
> +
> +	pci_save_state(pdev);
> +
> +	pci_disable_device(pdev);
> +	free_irq(pdev->irq, device);

no device irq disabling?

> +
> +	pci_set_power_state(pdev, PCI_D3hot);
> +
> +	return err;
> +}
> +
> +static int heci_resume(struct pci_dev *pdev)
> +{
> +	struct iamt_heci_device *device = NULL;
> +	int err = 0;
> +
> +	pci_set_power_state(pdev, PCI_D0);
> +	pci_restore_state(pdev);
> +
> +	device = pci_get_drvdata(pdev);
> +	if (!device)
> +		return -ENODEV;
> +
> +	/* request and enable interrupt   */
> +	device->irq = pdev->irq;

so why do you need the copy of an irq?

> +	err = request_irq(device->irq, heci_isr_interrupt, IRQF_SHARED,
> +			heci_driver_name, device);
> +	if (err) {
> +		printk(KERN_ERR "%s: Request_irq failure. irq = %d \n",
> +		       THIS_MODULE->name, device->irq);
> +		return err;
> +	}
[...]
> diff --git a/drivers/char/heci/heci_version.h b/drivers/char/heci/heci_version.h
> new file mode 100644
> index 0000000..6cbb5e2
> --- /dev/null
> +++ b/drivers/char/heci/heci_version.h
> @@ -0,0 +1,56 @@
[...]
> +#ifndef HECI_VERSION_H
> +#define HECI_VERSION_H
> +
> +#define MAJOR_VERSION              5
> +#define MINOR_VERSION              0
> +#define QUICK_FIX_NUMBER        0
> +#define VER_BUILD               1
> +
> +#define str(s) name(s)
> +#define name(s) #s
> +#define DRIVER_V1		str(MAJOR_VERSION) "." str(MINOR_VERSION)
> +#define DRIVER_V2		str(QUICK_FIX_NUMBER) "." str(VER_BUILD)

hmm, __stringify()

> +
> +#define DRIVER_VERSION	DRIVER_V1 "." DRIVER_V2

not good macro names at all

> +
> +#endif
> diff --git a/drivers/char/heci/interrupt.c b/drivers/char/heci/interrupt.c
> new file mode 100644
> index 0000000..c2fc1d0
> --- /dev/null
> +++ b/drivers/char/heci/interrupt.c
> @@ -0,0 +1,1551 @@
[...]
> +irqreturn_t heci_isr_interrupt(int irq, void *dev_id)
> +{
> +	int err;
> +	struct iamt_heci_device *device = (struct iamt_heci_device *) dev_id;
> +	device->host_hw_state = read_heci_register(device, H_CSR);
> +
> +	if ((device->host_hw_state & H_IS) != H_IS)
> +		return IRQ_NONE;
> +
> +	/* disable interrupts */
> +	device->host_hw_state &= ~H_IE;
> +	/* acknowledge interrupt and stop interupts */
> +	write_heci_register(device, H_CSR, device->host_hw_state);
> +	/**
> +	 * Our device interrupted, schedule work the heci_bh_handler
> +	 * to handle the interrupt processing. This needs to be a
> +	 * workqueue item since the handler can sleep.
> +	 */
> +	PREPARE_WORK(&device->work, heci_bh_handler);

this is racy with bh?

> +	DBG("schedule work the heci_bh_handler.\n");
> +	err = schedule_work(&device->work);
> +	if (!err) {

some ratelimit?

> +		printk(KERN_ERR "%s: schedule the heci_bh_handler"
> +		       " failed error=%x\n", THIS_MODULE->name, err);
> +	}
> +	return IRQ_HANDLED;
> +}
[...]
> +static void heci_bh_handler(struct work_struct *work)
> +{
> +	struct iamt_heci_device *dev =
> +		container_of(work, struct iamt_heci_device, work);
> +	struct io_heci_list complete_list;
> +	__s32 slots;
> +	int rets;
> +	struct heci_cb_private *cb_pos = NULL, *cb_next = NULL;
> +	struct heci_file_private *file_ext = NULL;
> +	int bus_message_received = 0;
> +	struct task_struct *tsk;
> +
> +	DBG("function called after ISR to handle the interrupt processing.\n");
> +	/* initialize our complete list */
> +	spin_lock_bh(&dev->device_lock);
> +	heci_initialize_list(&complete_list, dev);
> +	dev->host_hw_state = read_heci_register(dev, H_CSR);
> +	dev->me_hw_state = read_heci_register(dev, ME_CSR_HA);
> +
> +	/* check if ME wants a reset */
> +	if (((dev->me_hw_state & ME_RDY_HRA) == 0)
> +	    && (dev->heci_state != HECI_RESETING)
> +	    && (dev->heci_state != HECI_INITIALIZING)) {
> +		DBG("FW not ready.\n");
> +		heci_reset(dev, 1);
> +		spin_unlock_bh(&dev->device_lock);
> +		return;
> +	}
> +
> +	/*  check if we need to start the dev */
> +	if ((dev->host_hw_state & H_RDY) == 0) {
> +		if ((dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA) {
> +			DBG("we need to start the dev.\n");
> +			dev->host_hw_state |= (H_IE | H_IG | H_RDY);
> +			write_heci_register(dev, H_CSR, dev->host_hw_state);
> +			if (dev->heci_state == HECI_INITIALIZING) {
> +				dev->recvd_msg = 1;
> +				spin_unlock_bh(&dev->device_lock);
> +				wake_up_interruptible(&dev->wait_recvd_msg);
> +				return;
> +
> +			} else {
> +				spin_unlock_bh(&dev->device_lock);
> +				tsk = kthread_run(heci_task_initialize_clients,
> +						  dev, "heci_reinit");
> +				if (IS_ERR(tsk)) {
> +					int rc = PTR_ERR(tsk);
> +					printk(KERN_WARNING "heci: Unable to"
> +					"start the heci thread: %d\n", rc);
> +				}
> +				return;
> +			}
> +		} else {
> +			DBG("enable interrupt FW not ready.\n");
> +			dev->host_hw_state |= (H_IE);
> +			write_heci_register(dev, H_CSR, dev->host_hw_state);
> +			spin_unlock_bh(&dev->device_lock);
> +			return;
> +		}
> +	}
> +	/* check slots avalable for reading */
> +	slots = count_full_read_slots(dev);
> +	DBG("slots =%08x  extra_write_index =%08x.\n",
> +		slots, dev->extra_write_index);
> +	while ((slots > 0) && (!dev->extra_write_index)) {
> +		DBG("slots =%08x  extra_write_index =%08x.\n", slots,
> +				dev->extra_write_index);
> +		DBG("call heci_bh_read_handler.\n");
> +		rets = heci_bh_read_handler(&complete_list, dev, &slots);
> +		if (rets != 0)
> +			goto end;
> +	}
> +	rets = heci_bh_write_handler(&complete_list, dev, &slots);
> +end:
> +	DBG("end of bottom half function.\n");
> +	dev->host_hw_state = read_heci_register(dev, H_CSR);
> +	dev->host_buffer_is_empty = host_buffer_is_empty(dev);
> +
> +	if ((dev->host_hw_state & H_IS) == H_IS) {
> +		PREPARE_WORK(&dev->work, heci_bh_handler);

racy with hardirq?

> +		DBG("schedule work the heci_bh_handler.\n");
> +		rets = schedule_work(&dev->work);
> +		if (!rets) {
> +			printk(KERN_ERR "%s: schedule the heci_bh_handler"
> +			       " failed error=%x\n", THIS_MODULE->name, rets);
> +		}
[...]
> +static int _heci_bh_ioctl(struct iamt_heci_device *dev,	__s32 *slots,
> +			struct heci_cb_private *priv_cb_pos,
> +			struct heci_file_private *file_ext,
> +			struct io_heci_list *cmpl_list)
> +{
> +	if ((*slots * sizeof(__u32)) >= (sizeof(struct heci_msg_hdr) +
> +			sizeof(struct hbm_client_connect_request))) {
> +		file_ext->state = HECI_FILE_CONNECTING;
> +		*slots -= (sizeof(struct heci_msg_hdr) +
> +			sizeof(struct hbm_client_connect_request) + 3) / 4;
> +		if (!heci_connect(dev, file_ext)) {
> +			file_ext->status = -ENODEV;
> +			priv_cb_pos->information = 0;
> +			list_del(&priv_cb_pos->cb_list);
> +			return -ENODEV;
> +		} else {
> +			list_del(&priv_cb_pos->cb_list);
> +			list_add_tail(&priv_cb_pos->cb_list,
> +			&dev->ctrl_rd_list.heci_cb.cb_list);
> +			file_ext->timer_count = CONNECT_TIMEOUT;
> +		}
> +	} else {
> +		/* return the cancel routine */
> +		list_del(&priv_cb_pos->cb_list);
> +		return -ECORRUPTED_MESSAGE_HEADER;

Sorry, what?

> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * _heci_bh_cmpl: process completed and no-iamthif operation.
> + * @dev: device object.
> + * @slots: free slotsl.
> + * @priv_cb_pos: callback block.
> + * @file_ext: file extension.
> + * @cmpl_list: complete list.
> + *
> + * @return :
> + * 0, OK; otherwise, error.
> + */
> +static int _heci_bh_cmpl(struct iamt_heci_device *dev,	__s32 *slots,
> +			struct heci_cb_private *priv_cb_pos,
> +			struct heci_file_private *file_ext,
> +			struct io_heci_list *cmpl_list)
> +{
> +	struct heci_msg_hdr *heci_hdr = NULL;
> +
> +	if ((*slots * sizeof(__u32)) >= (sizeof(struct heci_msg_hdr) +
> +			(priv_cb_pos->request_buffer.size -
> +			priv_cb_pos->information))) {
> +		heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
> +		heci_hdr->host_addr = file_ext->host_client_id;
> +		heci_hdr->me_addr = file_ext->me_client_id;
> +		heci_hdr->length = ((priv_cb_pos->request_buffer.size) -
> +				(priv_cb_pos->information));
> +		heci_hdr->msg_complete = 1;
> +		heci_hdr->reserved = 0;
> +		DBG("priv_cb_pos->request_buffer.size =%d"
> +			"heci_hdr->msg_complete= %d\n",
> +				priv_cb_pos->request_buffer.size,
> +				heci_hdr->msg_complete);
> +		DBG("priv_cb_pos->information  =%lu\n",
> +				priv_cb_pos->information);
> +		DBG("heci_hdr->length  =%d\n",
> +				heci_hdr->length);
> +		*slots -= (sizeof(struct heci_msg_hdr) +
> +				heci_hdr->length + 3) / 4;
> +		if (!heci_write_message(dev, heci_hdr,
> +				(unsigned char *)
> +				(priv_cb_pos->request_buffer.data +
> +				priv_cb_pos->information),
> +				heci_hdr->length)) {
> +			file_ext->status = -ENODEV;
> +			list_del(&priv_cb_pos->cb_list);
> +			list_add_tail(&priv_cb_pos->cb_list,
> +				&cmpl_list->heci_cb.cb_list);

list_move_tail?

> +			return -ENODEV;
> +		} else {
> +			flow_ctrl_reduce(dev, file_ext);
> +			file_ext->status = 0;
> +			priv_cb_pos->information += heci_hdr->length;
> +			list_del(&priv_cb_pos->cb_list);
> +			list_add_tail(&priv_cb_pos->cb_list,
> +				&dev->write_waiting_list.heci_cb.cb_list);

...

> +		}
> +	} else if (*slots == ((dev->host_hw_state & H_CBD) >> 24)) {
[...]
> +static int same_flow_addr(struct heci_file_private *file,
> +					struct hbm_flow_control *flow)
> +{
> +	if ((file->host_client_id == flow->host_addr)
> +	    && (file->me_client_id == flow->me_addr))
> +		return 1;
> +
> +	return 0;
> +}

just return <the_condition>;

> +static void add_single_flow_creds(struct iamt_heci_device *dev,
> +				  struct hbm_flow_control *flow)
> +{
> +	struct heci_me_client *client = NULL;
> +	int i;
> +
> +	for (i = 0; i < dev->num_heci_me_clients; i++) {
> +		client = &dev->me_clients[i];
> +		if (flow->me_addr == client->client_id) {
> +			if (client->props.single_recv_buf != 0) {
> +				client->flow_ctrl_creds++;
> +				DBG("recv flow ctrl msg ME %d (single).\n",
> +				    flow->me_addr);
> +				DBG("flow control credentials=%d.\n",
> +				    client->flow_ctrl_creds);
> +			} else {
> +				BUG_ON(1);	/* error in flow control */

BUG()

[...]
> +static int same_disconn_addr(struct heci_file_private *file,
> +			     struct hbm_client_disconnect_request *disconn)
> +{
> +	if ((file->host_client_id == disconn->host_addr)
> +	    && (file->me_client_id == disconn->me_addr))
> +		return 1;
> +
> +	return 0;
> +}

...
