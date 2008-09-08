Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbYIHUqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbYIHUqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623AbYIHUqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:46:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418AbYIHUqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:46:23 -0400
Date: Mon, 8 Sep 2008 13:46:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: jbarnes@virtuousgeek.org, bhutchings@solarflare.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] PCI: revise VPD access interface
Message-Id: <20080908134620.9efdcbf9.akpm@linux-foundation.org>
In-Reply-To: <20080904205718.626058270@vyatta.com>
References: <20080904205636.130211023@vyatta.com>
	<20080904205718.626058270@vyatta.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 13:56:38 -0700
Stephen Hemminger <shemminger@vyatta.com> wrote:

> Change PCI VPD API which was only used by sysfs to something usable
> in drivers. 
>    * move iteration over multiple words to the low level
>    * cleanup types of arguments
>    * add exportable wrapper
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> --- a/drivers/pci/access.c	2008-09-04 10:16:52.000000000 -0700
> +++ b/drivers/pci/access.c	2008-09-04 10:19:47.000000000 -0700
> @@ -66,6 +66,39 @@ EXPORT_SYMBOL(pci_bus_write_config_byte)
>  EXPORT_SYMBOL(pci_bus_write_config_word);
>  EXPORT_SYMBOL(pci_bus_write_config_dword);
>  
> +
> +/**
> + * pci_read_vpd - Read one entry from Vital Product Data
> + * @dev:	pci device struct
> + * @pos:	offset in vpd space
> + * @count:	number of bytes to read
> + * @buf:	pointer to where to store result
> + *
> + */
> +int pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf)
> +{
> +	if (!dev->vpd || !dev->vpd->ops)
> +		return -ENODEV;
> +	return dev->vpd->ops->read(dev, pos, count, buf);
> +}
> +EXPORT_SYMBOL(pci_read_vpd);

"read" functions normally return ssize_t, not int.

>
> ...
>  
>  static ssize_t
> -pci_read_vpd(struct kobject *kobj, struct bin_attribute *bin_attr,
> -	     char *buf, loff_t off, size_t count)
> +read_vpd_attr(struct kobject *kobj, struct bin_attribute *bin_attr,
> +	      char *buf, loff_t off, size_t count)
>  {

This returns size_t.

>  static ssize_t
> -pci_write_vpd(struct kobject *kobj, struct bin_attribute *bin_attr,
> -	      char *buf, loff_t off, size_t count)
> +write_vpd_attr(struct kobject *kobj, struct bin_attribute *bin_attr,
> +	       char *buf, loff_t off, size_t count)

as does this.

> @@ -739,8 +717,8 @@ int __must_check pci_create_sysfs_dev_fi
>  			attr->size = pdev->vpd->len;
>  			attr->attr.name = "vpd";
>  			attr->attr.mode = S_IRUSR | S_IWUSR;
> -			attr->read = pci_read_vpd;
> -			attr->write = pci_write_vpd;
> +			attr->read = read_vpd_attr;
> +			attr->write = write_vpd_attr;

But this (I think) is assigning a ssize_t-returning function to an
int-returning function pointer.

