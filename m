Return-Path: <linux-kernel-owner+w=401wt.eu-S1423663AbXEAVbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423663AbXEAVbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423682AbXEAVbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:31:14 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4018 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423663AbXEAVbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:31:13 -0400
Date: Tue, 1 May 2007 22:31:03 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 3/4] SoC base drivers: ASIC3 driver
Message-ID: <20070501213102.GF19872@flint.arm.linux.org.uk>
Mail-Followup-To: Paul Sokolovsky <pmiscml@gmail.com>,
	linux-kernel@vger.kernel.org
References: <06028862.20070501080948@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06028862.20070501080948@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 08:09:48AM +0300, Paul Sokolovsky wrote:
> +static void asic3_release(struct device *dev)
> +{
> +	struct platform_device *sdev = to_platform_device(dev);
> +
> +	kfree(sdev->resource);
> +	kfree(sdev);
> +}
> +
> +int asic3_register_mmc(struct device *dev)
> +{
> +	struct platform_device *sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
> +	struct tmio_mmc_hwconfig *mmc_config = kmalloc(sizeof(*mmc_config),
> +						       GFP_KERNEL);
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct asic3_data *asic = dev->driver_data;
> +	struct asic3_platform_data *asic3_pdata = dev->platform_data;
> +	struct resource *res;
> +	int rc;
> +
> +	if (sdev == NULL || mmc_config == NULL)
> +		return -ENOMEM;
> +
> +	if (asic3_pdata->tmio_mmc_hwconfig) {
> +		memcpy(mmc_config, asic3_pdata->tmio_mmc_hwconfig,
> +		       sizeof(*mmc_config));
> +	} else {
> +		memset(mmc_config, 0, sizeof(*mmc_config));
> +	}
> +	mmc_config->address_shift = asic->bus_shift;
> +
> +	sdev->id = -1;
> +	sdev->name = "asic3_mmc";
> +	sdev->dev.parent = dev;
> +	sdev->num_resources = 2;
> +	sdev->dev.platform_data = mmc_config;
> +	sdev->dev.release = asic3_release;
> +
> +	res = kzalloc(sdev->num_resources * sizeof(struct resource),
> +		      GFP_KERNEL);
> +	if (res == NULL) {
> +		kfree(sdev);
> +		kfree(mmc_config);
> +		return -ENOMEM;
> +	}
> +	sdev->resource = res;
> +
> +	res[0].start = pdev->resource[2].start;
> +	res[0].end   = pdev->resource[2].end;
> +	res[0].flags = IORESOURCE_MEM;
> +	res[1].start = res[1].end = pdev->resource[3].start;
> +	res[1].flags = IORESOURCE_IRQ;
> +
> +	rc = platform_device_register(sdev);
> +	if (rc) {
> +		printk(KERN_ERR "asic3_base: "
> +		       "Could not register asic3_mmc device\n");
> +		kfree(res);
> +		kfree(sdev);
> +		return rc;
> +	}
> +
> +	asic->mmc_dev = sdev;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(asic3_register_mmc);
> +
> +int asic3_unregister_mmc(struct device *dev)
> +{
> +	struct asic3_data *asic = dev->driver_data;
> +	platform_device_unregister(asic->mmc_dev);
> +	asic->mmc_dev = 0;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(asic3_unregister_mmc);
...
> +static int asic3_probe(struct platform_device *pdev)
> +{
...
> +	if (pdev->num_resources > 2) {
> +		int rc;
> +		rc = asic3_register_mmc(dev);
...
> +	return 0;
> +}
> +
> +static int asic3_remove(struct platform_device *pdev)
> +{
> +	struct asic3_platform_data *pdata = pdev->dev.platform_data;
> +	struct asic3_data *asic = platform_get_drvdata(pdev);
> +	int i;
...
> +	if (asic->mmc_dev)
> +		asic3_unregister_mmc(&pdev->dev);
...
> +	return 0;
> +}
...
> +static struct platform_driver asic3_device_driver = {
> +	.driver		= {
> +		.name	= "asic3",
> +	},
> +	.probe		= asic3_probe,
> +	.remove		= asic3_remove,
> +	.suspend	= asic3_suspend,
> +	.resume		= asic3_resume,
> +	.shutdown	= asic3_shutdown,
> +};
...
> +static void __exit asic3_base_exit(void)
> +{
> +	platform_driver_unregister(&asic3_device_driver);
> +}
...
> +module_exit(asic3_base_exit);

What stops the remove function from being called after the module
has been removed from the system?

Again, with platform devices you _really_ want to use the already
provided dynamic allocation methods precisely because they don't
suffer from these problems.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
