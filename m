Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYBSMMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYBSMMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 07:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYBSMMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 07:12:12 -0500
Received: from www.tglx.de ([62.245.132.106]:59071 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbYBSMML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:12:11 -0500
Date: Tue, 19 Feb 2008 13:12:01 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Brandon Philips <brandon@ifup.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: introduce sysfs_ops for map_attr_ktype
Message-ID: <20080219131201.6cb32052@dilbert.local>
In-Reply-To: <20080219095505.GA875@plankton.ifup.org>
References: <20080213180304.4ffa81e9@dilbert.local>
	<20080213173322.GD10733@kroah.com>
	<20080219095505.GA875@plankton.ifup.org>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tue, 19 Feb 2008 01:55:05 -0800
schrieb Brandon Philips <brandon@ifup.org>:

> This fixes two bugs with UIO that cropped up recently in -rc1
> 
> 1) WARNING: at fs/sysfs/file.c:334 sysfs_open_file when trying to open
>    a map addr/size file - complaining about missing sysfs_ops for
> ktype 
> 2) Permission denied when reading uio/uio0/maps/map0/{addr,size} when
>    files are mode S_IRUGO
> 
> Also fix a typo: attr_attribute -> addr_attribute

Hi Brandon,
thanks a lot for that one! I've tested with 2.6.25-rc2 with a Hilscher
NetX PCI card, works without problems. All attributes are accessible.
Makes 2.6.25-rc usable again :-)

Thanks,
Hans

> 
> Signed-off-by: Brandon Philips <bphilips@suse.de>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>


> 
> ---
>  drivers/uio/uio.c          |   54
> ++++++++++++++++++++++++++++++--------------- 1 file changed, 37
> insertions(+), 17 deletions(-)
> 
> Index: linux-2.6/drivers/uio/uio.c
> ===================================================================
> --- linux-2.6.orig/drivers/uio/uio.c
> +++ linux-2.6/drivers/uio/uio.c
> @@ -57,29 +57,29 @@ struct uio_map {
>  };
>  #define to_map(map) container_of(map, struct uio_map, kobj)
>  
> -
> -static ssize_t map_attr_show(struct kobject *kobj, struct
> kobj_attribute *attr,
> -			     char *buf)
> +static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
>  {
> -	struct uio_map *map = to_map(kobj);
> -	struct uio_mem *mem = map->mem;
> -
> -	if (strncmp(attr->attr.name, "addr", 4) == 0)
> -		return sprintf(buf, "0x%lx\n", mem->addr);
> -
> -	if (strncmp(attr->attr.name, "size", 4) == 0)
> -		return sprintf(buf, "0x%lx\n", mem->size);
> +	return sprintf(buf, "0x%lx\n", mem->addr);
> +}
>  
> -	return -ENODEV;
> +static ssize_t map_size_show(struct uio_mem *mem, char *buf)
> +{
> +	return sprintf(buf, "0x%lx\n", mem->size);
>  }
>  
> -static struct kobj_attribute attr_attribute =
> -	__ATTR(addr, S_IRUGO, map_attr_show, NULL);
> -static struct kobj_attribute size_attribute =
> -	__ATTR(size, S_IRUGO, map_attr_show, NULL);
> +struct uio_sysfs_entry {
> +	struct attribute attr;
> +	ssize_t (*show)(struct uio_mem *, char *);
> +	ssize_t (*store)(struct uio_mem *, const char *, size_t);
> +};
> +
> +static struct uio_sysfs_entry addr_attribute =
> +	__ATTR(addr, S_IRUGO, map_addr_show, NULL);
> +static struct uio_sysfs_entry size_attribute =
> +	__ATTR(size, S_IRUGO, map_size_show, NULL);
>  
>  static struct attribute *attrs[] = {
> -	&attr_attribute.attr,
> +	&addr_attribute.attr,
>  	&size_attribute.attr,
>  	NULL,	/* need to NULL terminate the list of
> attributes */ };
> @@ -90,8 +90,28 @@ static void map_release(struct kobject *
>  	kfree(map);
>  }
>  
> +static ssize_t map_type_show(struct kobject *kobj, struct attribute
> *attr,
> +			     char *buf)
> +{
> +	struct uio_map *map = to_map(kobj);
> +	struct uio_mem *mem = map->mem;
> +	struct uio_sysfs_entry *entry;
> +
> +	entry = container_of(attr, struct uio_sysfs_entry, attr);
> +
> +	if (!entry->show)
> +		return -EIO;
> +
> +	return entry->show(mem, buf);
> +}
> +
> +static struct sysfs_ops uio_sysfs_ops = {
> +	.show = map_type_show,
> +};
> +
>  static struct kobj_type map_attr_type = {
>  	.release	= map_release,
> +	.sysfs_ops	= &uio_sysfs_ops,
>  	.default_attrs	= attrs,
>  };
