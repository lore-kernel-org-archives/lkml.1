Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbYCEQNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbYCEQNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbYCEQNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:13:14 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:49656 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757529AbYCEQNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:13:12 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Mark McLoughlin <markmc@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       xen-devel@lists.xensource.com, jeremy@goop.org
In-Reply-To: <1203697218-32064-1-git-send-email-markmc@redhat.com>
References: <1203697218-32064-1-git-send-email-markmc@redhat.com>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 16:12:48 +0000
Message-Id: <1204733568.6307.14.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] xen: Module autoprobing support for frontend drivers
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-22 at 16:20 +0000, Mark McLoughlin wrote: 
> Add module aliases to support autoprobing modules
> for xen frontend devices.
> 
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>

Slightly belated but this looks good to me...

Tested-by: Ian Campbell <ijc@hellion.org.uk>

> ---
>  drivers/block/xen-blkfront.c      |    1 +
>  drivers/net/xen-netfront.c        |    1 +
>  drivers/xen/xenbus/xenbus_probe.c |   27 +++++++++++++++++++++++++--
>  3 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 9c6f3f9..d0d5a02 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -998,3 +998,4 @@ module_exit(xlblk_exit);
>  MODULE_DESCRIPTION("Xen virtual block device frontend");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_BLOCKDEV_MAJOR(XENVBD_MAJOR);
> +MODULE_ALIAS("xen:vbd");
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 7483d45..b3fa27e 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -1809,3 +1809,4 @@ module_exit(netif_exit);
>  
>  MODULE_DESCRIPTION("Xen virtual network device frontend");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("xen:vif");
> diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
> index 4750de3..336363c 100644
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -88,6 +88,16 @@ int xenbus_match(struct device *_dev, struct device_driver *_drv)
>  	return match_device(drv->ids, to_xenbus_device(_dev)) != NULL;
>  }
>  
> +static int xenbus_uevent(struct device *_dev, struct kobj_uevent_env *env)
> +{
> +	struct xenbus_device *dev = to_xenbus_device(_dev);
> +
> +	if (add_uevent_var(env, "MODALIAS=xen:%s", dev->devicetype))
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
>  /* device/<type>/<id> => <type>-<id> */
>  static int frontend_bus_id(char bus_id[BUS_ID_SIZE], const char *nodename)
>  {
> @@ -166,6 +176,7 @@ static struct xen_bus_type xenbus_frontend = {
>  	.bus = {
>  		.name     = "xen",
>  		.match    = xenbus_match,
> +		.uevent   = xenbus_uevent,
>  		.probe    = xenbus_dev_probe,
>  		.remove   = xenbus_dev_remove,
>  		.shutdown = xenbus_dev_shutdown,
> @@ -438,6 +449,12 @@ static ssize_t xendev_show_devtype(struct device *dev,
>  }
>  DEVICE_ATTR(devtype, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_devtype, NULL);
>  
> +static ssize_t xendev_show_modalias(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "xen:%s\n", to_xenbus_device(dev)->devicetype);
> +}
> +DEVICE_ATTR(modalias, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_modalias, NULL);
>  
>  int xenbus_probe_node(struct xen_bus_type *bus,
>  		      const char *type,
> @@ -492,10 +509,16 @@ int xenbus_probe_node(struct xen_bus_type *bus,
>  
>  	err = device_create_file(&xendev->dev, &dev_attr_devtype);
>  	if (err)
> -		goto fail_remove_file;
> +		goto fail_remove_nodename;
> +
> +	err = device_create_file(&xendev->dev, &dev_attr_modalias);
> +	if (err)
> +		goto fail_remove_devtype;
>  
>  	return 0;
> -fail_remove_file:
> +fail_remove_devtype:
> +	device_remove_file(&xendev->dev, &dev_attr_devtype);
> +fail_remove_nodename:
>  	device_remove_file(&xendev->dev, &dev_attr_nodename);
>  fail_unregister:
>  	device_unregister(&xendev->dev);
-- 
Ian Campbell

"An entire fraternity of strapping Wall-Street-bound youth.  Hell - this
is going to be a blood bath!"
		-- Post Bros. Comics

