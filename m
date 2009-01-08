Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZAHL2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZAHL2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 06:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbZAHL1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 06:27:52 -0500
Received: from www.tglx.de ([62.245.132.106]:56212 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbZAHL1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 06:27:51 -0500
Date: Thu, 8 Jan 2009 12:27:42 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       ben-linux@fluff.org
Subject: Re: [PATCH 1/3] Driver for user access to internal clocks
Message-ID: <20090108112741.GA3053@local>
References: <8447d6730901080149l4146139an9fad00fd88d72fb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730901080149l4146139an9fad00fd88d72fb9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 10:49:12AM +0100, Davide Rizzo wrote:
> This driver is for user level programs to interact with system clocks.
> It allows to read and modify rates and parents, using virtual files.
> It requires the implementation of 2 additional functions in the clk interface:
>  clk_for_each() and clk_name().
> Actually I implemented that functions only for Samsung S3C24xx platform.
> 
> Signed-off-by: Davide Rizzo <elpa-rizzo@gmail.com>
> ---
> diff -urNp linux-2.6.28/drivers/uio/clock.c
> linux-2.6.28.elpa/drivers/uio/clock.c
> --- linux-2.6.28/drivers/uio/clock.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.28.elpa/drivers/uio/clock.c	2009-01-07 18:52:09.000000000 +0100

Davide,
please don't put this in the drivers/uio/ directory. This is no UIO driver.

Thanks,
Hans


> @@ -0,0 +1,313 @@
> +/*
> + driver/misc/clock.c

Ah, it used to have a different place ;-)

> +
> + Written Feb 2008 by Davide Rizzo <davide@elpa.it>
> +
> + This driver allows to read and modify internal clocks' rates using
> +  virtual files. User can also read and modify parents.
> +
> + This driver requires implementation of clk_name() and clk_enum() functions
> +  in architecture specific clock.c
> +
> + This program is free software; you can redistribute it and/or modify
> + it under the terms of the GNU General Public License as published by
> + the Free Software Foundation; either version 2 of the License, or
> + (at your option) any later version.
> +
> + This program is distributed in the hope that it will be useful,
> + but WITHOUT ANY WARRANTY; without even the implied warranty of
> + MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + GNU General Public License for more details.
> +
> + You should have received a copy of the GNU General Public License
> + along with this program; if not, write to the Free Software
> + Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> +*/
> +
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +
> +struct clk_info {
> +	struct mutex mutex;
> +	struct list_head head;
> +	struct device *dev;	/* here because needed by create_clock_attr */
> +	int count;
> +};
> +
> +struct attr {
> +	struct list_head list;
> +	struct device_attribute at;
> +};
> +
> +static ssize_t clk_show(struct device *dev, struct device_attribute *attr,
> +	char *buffer)
> +{
> +	unsigned long rate;
> +	struct clk_info *info = dev_get_drvdata(dev);
> +	struct clk *clk = clk_get(dev, attr->attr.name);
> +
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	rate = 0;
> +
> +	if (!IS_ERR(clk)) {
> +
> +		mutex_lock(&info->mutex);
> +
> +		rate = clk_get_rate(clk);
> +
> +		mutex_unlock(&info->mutex);
> +
> +		clk_put(clk);
> +
> +	}
> +	if (snprintf(buffer, PAGE_SIZE, "%ld\n", rate) > PAGE_SIZE)
> +		buffer[PAGE_SIZE - 1] = '\0';
> +	return strlen(buffer);
> +}
> +
> +static ssize_t clk_store(struct device *dev, struct device_attribute *attr,
> +	const char *buffer, size_t count)
> +{
> +	struct clk_info *info = dev_get_drvdata(dev);
> +	unsigned long rate;
> +	struct clk *clk;
> +	int err = strict_strtoul(buffer, 10, &rate);
> +
> +	if (err)
> +		return err;
> +
> +	clk = clk_get(dev, attr->attr.name);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	mutex_lock(&info->mutex);
> +
> +	if (rate != 0) {
> +		clk_set_rate(clk, clk_round_rate(clk, rate));
> +		clk_enable(clk);
> +	} else
> +		clk_disable(clk);
> +
> +	mutex_unlock(&info->mutex);
> +
> +	clk_put(clk);
> +
> +	return count;
> +}
> +
> +static ssize_t clk_parent_show(struct device *dev,
> +	struct device_attribute *attr, char *buffer)
> +{
> +	struct clk_info *info = dev_get_drvdata(dev);
> +	struct clk *clk, *parent;
> +	char *s = kstrdup(attr->attr.name, GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +	s[strlen(attr->attr.name) - 7] = '\0';
> +	clk = clk_get(dev, s);
> +	kfree(s);
> +	buffer[0] = '\0';
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +	if (!IS_ERR(clk)) {
> +
> +		mutex_lock(&info->mutex);
> +
> +		parent = clk_get_parent(clk);
> +		if (parent && !IS_ERR(parent)) {
> +			const char *full_name = clk_get_name(parent);
> +			if (IS_ERR(full_name)) {
> +				mutex_unlock(&info->mutex);
> +				return PTR_ERR(full_name);
> +			}
> +			strlcpy(buffer, full_name, PAGE_SIZE);
> +			kfree(full_name);
> +		}
> +		strlcat(buffer, "\n", PAGE_SIZE);
> +
> +		mutex_unlock(&info->mutex);
> +
> +		clk_put(clk);
> +	}
> +	return strlen(buffer);
> +}
> +
> +static ssize_t clk_parent_store(struct device *dev,
> +	struct device_attribute *attr, const char *buffer, size_t count)
> +{
> +	struct clk_info *info = dev_get_drvdata(dev);
> +	struct clk *clk, *parent;
> +	char *s;
> +
> +	parent = clk_get(dev, buffer);
> +	if (IS_ERR(parent))
> +		return PTR_ERR(parent);
> +
> +	s = kstrdup(attr->attr.name, GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +	s[strlen(attr->attr.name) - 7] = '\0';
> +	clk = clk_get(dev, s);
> +	kfree(s);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	if (!IS_ERR(clk)) {
> +
> +		mutex_lock(&info->mutex);
> +
> +		clk_set_parent(clk, parent);
> +
> +		mutex_unlock(&info->mutex);
> +
> +		clk_put(clk);
> +	}
> +	clk_put(parent);
> +	return count;
> +}
> +
> +static int remove_driver(struct platform_device *pdev)
> +{
> +	struct clk_info *info = platform_get_drvdata(pdev);
> +	struct attr *atp;
> +
> +	mutex_lock(&info->mutex);
> +
> +	/* Remove all virtual files */
> +	while (!list_empty(&info->head)) {
> +		atp = list_first_entry(&info->head, struct attr, list);
> +		device_remove_file(&pdev->dev, &atp->at);
> +		kfree(atp->at.attr.name);
> +		list_del(&atp->list);
> +		kfree(atp);
> +	}
> +	platform_set_drvdata(pdev, NULL);
> +
> +	mutex_unlock(&info->mutex);
> +
> +	kfree(info);
> +	dev_notice(&pdev->dev, "removed\n");
> +	return 0;
> +}
> +
> +static int create_clock_attr(struct clk *clk, void *data)
> +{
> +	struct attr *atp;
> +	int err, len;
> +	struct clk_info *info = data;
> +	const char *name = clk_get_name(clk);
> +
> +	/* Retrieve clock's name */
> +	if (name == NULL || IS_ERR(name)) {
> +		/* Don't return error, simply skip this one */
> +		dev_err(info->dev, "invalid clock's name\n");
> +		return PTR_ERR(name);
> +	}
> +
> +	/* Create rate virtual file */
> +	atp = kzalloc(sizeof(struct attr), GFP_KERNEL);
> +	if (!atp) {
> +		dev_err(info->dev, "out of kernel memory\n");
> +		return -ENOMEM;
> +	}
> +	atp->at.attr.mode = S_IRUGO | S_IWUSR;
> +	atp->at.attr.name = kstrdup(name, GFP_KERNEL);
> +	if (!atp->at.attr.name) {
> +		kfree(atp);
> +		dev_err(info->dev, "out of kernel memory\n");
> +		return -ENOMEM;
> +	}
> +	atp->at.show = clk_show;
> +	atp->at.store = clk_store;
> +	err = device_create_file(info->dev, &atp->at);
> +	if (err) {
> +		kfree(atp->at.attr.name);
> +		kfree(atp);
> +		dev_err(info->dev, "failed to create file\n");
> +		return err;
> +	}
> +	list_add(&atp->list, &info->head);
> +
> +	/* Create parent virtual file */
> +	atp = kzalloc(sizeof(struct attr), GFP_KERNEL);
> +	if (!atp) {
> +		dev_err(info->dev, "out of kernel memory\n");
> +		return -ENOMEM;
> +	}
> +	atp->at.attr.mode = S_IRUGO | S_IWUSR;
> +	len = strlen(name) + 8;
> +	atp->at.attr.name = kmalloc(len, GFP_KERNEL);
> +	if (!atp->at.attr.name) {
> +		kfree(atp);
> +		dev_err(info->dev, "out of kernel memory\n");
> +		return -ENOMEM;
> +	}
> +	strlcpy((char *)atp->at.attr.name, name, len);
> +	strlcat((char *)atp->at.attr.name, "-parent", len);
> +	atp->at.show = clk_parent_show;
> +	atp->at.store = clk_parent_store;
> +	err = device_create_file(info->dev, &atp->at);
> +	if (err) {
> +		kfree(atp->at.attr.name);
> +		kfree(atp);
> +		dev_err(info->dev, "failed to create file\n");
> +		return err;
> +	}
> +	list_add(&atp->list, &info->head);
> +
> +	info->count++;
> +	return 0;
> +}
> +
> +static int probe_driver(struct platform_device *pdev)
> +{
> +	struct clk_info *info;
> +	int err;
> +
> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	if (!info) {
> +		dev_err(&pdev->dev, "out of kernel memory\n");
> +		return -ENOMEM;
> +	}
> +	mutex_init(&info->mutex);
> +	INIT_LIST_HEAD(&info->head);
> +	info->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, info);
> +	err = clk_for_each(create_clock_attr, info);
> +	if (err)
> +		remove_driver(pdev);
> +	else
> +		dev_notice(&pdev->dev, "probed OK - %d clocks recognized\n",
> +			info->count);
> +	return err;
> +}
> +
> +static struct platform_driver driver = {
> +	.probe  = probe_driver,
> +	.remove = remove_driver,
> +	.driver = {
> +		.name = "clocks",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static int __init clk_init_module(void)
> +{
> +	return platform_driver_register(&driver);
> +}
> +
> +static void __exit clk_cleanup_module(void)
> +{
> +	platform_driver_unregister(&driver);
> +}
> +
> +module_init(clk_init_module);
> +module_exit(clk_cleanup_module);
> +
> +MODULE_AUTHOR("Davide Rizzo <davide@elpa.it>");
> +MODULE_DESCRIPTION("Clock driver");
> +MODULE_SUPPORTED_DEVICE("clocks");
> +MODULE_LICENSE("GPL");
> diff -urNp linux-2.6.28/drivers/uio/Kconfig
> linux-2.6.28.elpa/drivers/uio/Kconfig
> --- linux-2.6.28/drivers/uio/Kconfig	2008-12-25 00:26:37.000000000 +0100
> +++ linux-2.6.28.elpa/drivers/uio/Kconfig	2009-01-07 18:58:10.000000000 +0100
> @@ -13,6 +13,18 @@ menuconfig UIO
> 
>  if UIO
> 
> +
> +config UIO_CLOCK
> +	tristate "General purpose clock driver"
> +	default y
> +	---help---
> +	  This driver allows to configure and control internal clocks'
> +	   rates and parents through virtual files.
> +	  This driver requires implementation of some additional functions
> +	   in architecture specific low-level drivers:
> +	   clk_for_each() and clk_get_name()
> +	  Currently they're implemented only on Samsung S3C24xx platforms.
> +
>  config UIO_CIF
>  	tristate "generic Hilscher CIF Card driver"
>  	depends on PCI
> diff -urNp linux-2.6.28/drivers/uio/Makefile
> linux-2.6.28.elpa/drivers/uio/Makefile
> --- linux-2.6.28/drivers/uio/Makefile	2008-12-25 00:26:37.000000000 +0100
> +++ linux-2.6.28.elpa/drivers/uio/Makefile	2009-01-06 18:20:17.000000000 +0100
> @@ -1,4 +1,5 @@
>  obj-$(CONFIG_UIO)	+= uio.o
> +obj-$(CONFIG_UIO_CLOCK) += clock.o
>  obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
>  obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
>  obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
