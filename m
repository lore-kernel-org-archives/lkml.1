Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZCSV0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZCSV0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZCSV0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:26:06 -0400
Received: from n29.bullet.mail.mud.yahoo.com ([68.142.207.48]:41958 "HELO
	n29.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754091AbZCSV0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:26:04 -0400
X-Yahoo-Newman-Id: 151391.91784.bm@omp403.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lwTYDnpxoWGyAbZk/1NeFvLUb4DFdmXbK5JOJiCul8OvvRMAizoR/noOI2gyqCneraTwfJkJ6XJxHEIjiU/Cn+ngx7EqJ4HKOBa5xokow7zoAMJib1mIu6l8uAWTNxahe9nfTMl43Jpxw6gVjzgi+adZ20HtsUU5vpSrTxxAQ0I=  ;
X-YMail-OSG: r_0kMzMVM1kVnYX.ZqEa.XRSd4pSK1P4XenR.NmeetMCguUjDJ0O7KxbmRYApH1qh0..mt.W.dPA_yoc.lxLF2o1djdlx_.MCHlwvGEa3WbfXf6pOLOV4fHJSZXXPCLI2ColASiEtO_OyOVreXCkAzXs1E7rLmVooIiD1BS2dJfu0v8krUi6yiFeygJDlBwtOStC9yp6XFKNm82LZIn73KDXO59rJy0Q0j0Q
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH] rtc-v3020: add ability to access v3020 chip with GPIOs
Date: Thu, 19 Mar 2009 14:25:58 -0700
User-Agent: KMail/1.9.10
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org, raph@8d.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <cover.1235400430.git.mike@compulab.co.il> <200903031308.29933.david-b@pacbell.net> <49B39803.2030505@compulab.co.il>
In-Reply-To: <49B39803.2030505@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903191425.59004.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Mike Rapoport wrote:

> 
> What about the below version?

Looks OK.


> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> CC: Alessandro Zummo <alessandro.zummo@towertech.it>
> CC: David Brownell <david-b@pacbell.net>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/rtc/rtc-v3020.c   |  183 ++++++++++++++++++++++++++++++++++++++++-----
>  include/linux/rtc-v3020.h |    6 ++
>  2 files changed, 169 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
> index 66955cc..9f29929 100644
> --- a/drivers/rtc/rtc-v3020.c
> +++ b/drivers/rtc/rtc-v3020.c
> @@ -27,17 +27,155 @@
>  #include <linux/bcd.h>
>  #include <linux/rtc-v3020.h>
>  #include <linux/delay.h>
> +#include <linux/gpio.h>
> 
>  #include <linux/io.h>
> 
>  #undef DEBUG
> 
> +struct v3020;
> +
> +struct v3020_chip_ops {
> +	int (*map_io)(struct v3020 *chip, struct platform_device *pdev,
> +		      struct v3020_platform_data *pdata);
> +	void (*unmap_io)(struct v3020 *chip);
> +	unsigned char (*read_bit)(struct v3020 *chip);
> +	void (*write_bit)(struct v3020 *chip, unsigned char bit);
> +};
> +
> +#define V3020_CS	0
> +#define V3020_WR	1
> +#define V3020_RD	2
> +#define V3020_IO	3
> +
>  struct v3020 {
> +	/* MMIO access */
>  	void __iomem *ioaddress;
>  	int leftshift;
> +
> +	/* GPIO access */
> +	unsigned int gpio[4];
> +
> +	struct v3020_chip_ops *ops;
> +
>  	struct rtc_device *rtc;
>  };
> 
> +
> +static int v3020_mmio_map(struct v3020 *chip, struct platform_device *pdev,
> +			  struct v3020_platform_data *pdata)
> +{
> +	if (pdev->num_resources != 1)
> +		return -EBUSY;
> +
> +	if (pdev->resource[0].flags != IORESOURCE_MEM)
> +		return -EBUSY;
> +
> +	chip->leftshift = pdata->leftshift;
> +	chip->ioaddress = ioremap(pdev->resource[0].start, 1);
> +	if (chip->ioaddress == NULL)
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +
> +static void v3020_mmio_unmap(struct v3020 *chip)
> +{
> +	iounmap(chip->ioaddress);
> +}
> +
> +static void v3020_mmio_write_bit(struct v3020 *chip, unsigned char bit)
> +{
> +	writel(bit << chip->leftshift, chip->ioaddress);
> +}
> +
> +static unsigned char v3020_mmio_read_bit(struct v3020 *chip)
> +{
> +	return readl(chip->ioaddress) & (1 << chip->leftshift);
> +}
> +
> +static struct v3020_chip_ops v3020_mmio_ops = {
> +	.map_io		= v3020_mmio_map,
> +	.unmap_io	= v3020_mmio_unmap,
> +	.read_bit	= v3020_mmio_read_bit,
> +	.write_bit	= v3020_mmio_write_bit,
> +};
> +
> +static const char *v3020_gpio_names[] = {
> +	"RTC CS",
> +	"RTC WR",
> +	"RTC RD",
> +	"RTC IO",
> +};
> +
> +static int v3020_gpio_map(struct v3020 *chip, struct platform_device *pdev,
> +			  struct v3020_platform_data *pdata)
> +{
> +	int i, err;
> +
> +	chip->gpio[V3020_CS] = pdata->gpio_cs;
> +	chip->gpio[V3020_WR] = pdata->gpio_wr;
> +	chip->gpio[V3020_RD] = pdata->gpio_rd;
> +	chip->gpio[V3020_IO] = pdata->gpio_io;
> +
> +	for (i = 0; i < ARRAY_SIZE(chip->gpio); i++) {
> +		err = gpio_request(chip->gpio[i], v3020_gpio_names[i]);
> +		if (err)
> +			goto err_request;
> +
> +		gpio_direction_output(chip->gpio[i], 1);
> +	}
> +
> +	return 0;
> +
> +err_request:
> +	while (--i >= 0)
> +		gpio_free(chip->gpio[i]);
> +
> +	return err;
> +}
> +
> +static void v3020_gpio_unmap(struct v3020 *chip)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(chip->gpio); i++)
> +		gpio_free(chip->gpio[i]);
> +}
> +
> +static void v3020_gpio_write_bit(struct v3020 *chip, unsigned char bit)
> +{
> +	gpio_direction_output(chip->gpio[V3020_IO], bit);
> +	gpio_set_value(chip->gpio[V3020_CS], 0);
> +	gpio_set_value(chip->gpio[V3020_WR], 0);
> +	udelay(1);
> +	gpio_set_value(chip->gpio[V3020_WR], 1);
> +	gpio_set_value(chip->gpio[V3020_CS], 1);
> +}
> +
> +static unsigned char v3020_gpio_read_bit(struct v3020 *chip)
> +{
> +	int bit;
> +
> +	gpio_direction_input(chip->gpio[V3020_IO]);
> +	gpio_set_value(chip->gpio[V3020_CS], 0);
> +	gpio_set_value(chip->gpio[V3020_RD], 0);
> +	udelay(1);
> +	bit = !!gpio_get_value(chip->gpio[V3020_IO]);
> +	udelay(1);
> +	gpio_set_value(chip->gpio[V3020_RD], 1);
> +	gpio_set_value(chip->gpio[V3020_CS], 1);
> +
> +	return bit;
> +}
> +
> +static struct v3020_chip_ops v3020_gpio_ops = {
> +	.map_io		= v3020_gpio_map,
> +	.unmap_io	= v3020_gpio_unmap,
> +	.read_bit	= v3020_gpio_read_bit,
> +	.write_bit	= v3020_gpio_write_bit,
> +};
> +
>  static void v3020_set_reg(struct v3020 *chip, unsigned char address,
>  			unsigned char data)
>  {
> @@ -46,7 +184,7 @@ static void v3020_set_reg(struct v3020 *chip, unsigned char address,
> 
>  	tmp = address;
>  	for (i = 0; i < 4; i++) {
> -		writel((tmp & 1) << chip->leftshift, chip->ioaddress);
> +		chip->ops->write_bit(chip, (tmp & 1));
>  		tmp >>= 1;
>  		udelay(1);
>  	}
> @@ -54,7 +192,7 @@ static void v3020_set_reg(struct v3020 *chip, unsigned char address,
>  	/* Commands dont have data */
>  	if (!V3020_IS_COMMAND(address)) {
>  		for (i = 0; i < 8; i++) {
> -			writel((data & 1) << chip->leftshift, chip->ioaddress);
> +			chip->ops->write_bit(chip, (data & 1));
>  			data >>= 1;
>  			udelay(1);
>  		}
> @@ -67,14 +205,14 @@ static unsigned char v3020_get_reg(struct v3020 *chip, unsigned char address)
>  	int i;
> 
>  	for (i = 0; i < 4; i++) {
> -		writel((address & 1) << chip->leftshift, chip->ioaddress);
> +		chip->ops->write_bit(chip, (address & 1));
>  		address >>= 1;
>  		udelay(1);
>  	}
> 
>  	for (i = 0; i < 8; i++) {
>  		data >>= 1;
> -		if (readl(chip->ioaddress) & (1 << chip->leftshift))
> +		if (chip->ops->read_bit(chip))
>  			data |= 0x80;
>  		udelay(1);
>  	}
> @@ -164,25 +302,23 @@ static int rtc_probe(struct platform_device *pdev)
>  	int i;
>  	int temp;
> 
> -	if (pdev->num_resources != 1)
> -		return -EBUSY;
> -
> -	if (pdev->resource[0].flags != IORESOURCE_MEM)
> -		return -EBUSY;
> -
>  	chip = kzalloc(sizeof *chip, GFP_KERNEL);
>  	if (!chip)
>  		return -ENOMEM;
> 
> -	chip->leftshift = pdata->leftshift;
> -	chip->ioaddress = ioremap(pdev->resource[0].start, 1);
> -	if (chip->ioaddress == NULL)
> +	if (pdata->use_gpio)
> +		chip->ops = &v3020_gpio_ops;
> +	else
> +		chip->ops = &v3020_mmio_ops;
> +
> +	retval = chip->ops->map_io(chip, pdev, pdata);
> +	if (retval)
>  		goto err_chip;
> 
>  	/* Make sure the v3020 expects a communication cycle
>  	 * by reading 8 times */
>  	for (i = 0; i < 8; i++)
> -		temp = readl(chip->ioaddress);
> +		temp = chip->ops->read_bit(chip);
> 
>  	/* Test chip by doing a write/read sequence
>  	 * to the chip ram */
> @@ -196,10 +332,17 @@ static int rtc_probe(struct platform_device *pdev)
>  	 * are all disabled */
>  	v3020_set_reg(chip, V3020_STATUS_0, 0x0);
> 
> -	dev_info(&pdev->dev, "Chip available at physical address 0x%llx,"
> -		"data connected to D%d\n",
> -		(unsigned long long)pdev->resource[0].start,
> -		chip->leftshift);
> +	if (pdata->use_gpio)
> +		dev_info(&pdev->dev, "Chip available at GPIOs "
> +			 "%d, %d, %d, %d\n",
> +			 chip->gpio[V3020_CS], chip->gpio[V3020_WR],
> +			 chip->gpio[V3020_RD], chip->gpio[V3020_IO]);
> +	else
> +		dev_info(&pdev->dev, "Chip available at "
> +			 "physical address 0x%llx,"
> +			 "data connected to D%d\n",
> +			 (unsigned long long)pdev->resource[0].start,
> +			 chip->leftshift);
> 
>  	platform_set_drvdata(pdev, chip);
> 
> @@ -214,7 +357,7 @@ static int rtc_probe(struct platform_device *pdev)
>  	return 0;
> 
>  err_io:
> -	iounmap(chip->ioaddress);
> +	chip->ops->unmap_io(chip);
>  err_chip:
>  	kfree(chip);
> 
> @@ -229,7 +372,7 @@ static int rtc_remove(struct platform_device *dev)
>  	if (rtc)
>  		rtc_device_unregister(rtc);
> 
> -	iounmap(chip->ioaddress);
> +	chip->ops->unmap_io(chip);
>  	kfree(chip);
> 
>  	return 0;
> diff --git a/include/linux/rtc-v3020.h b/include/linux/rtc-v3020.h
> index bf74e63..8ba646e 100644
> --- a/include/linux/rtc-v3020.h
> +++ b/include/linux/rtc-v3020.h
> @@ -14,6 +14,12 @@
>   * is used depends on the board. */
>  struct v3020_platform_data {
>  	int leftshift; /* (1<<(leftshift)) & readl() */
> +
> +	int use_gpio:1;
> +	unsigned int gpio_cs;
> +	unsigned int gpio_wr;
> +	unsigned int gpio_rd;
> +	unsigned int gpio_io;
>  };
> 
>  #define V3020_STATUS_0	0x00
> -- 
> 1.5.6.4
> 
> 
> 
> 
> -- 
> Sincerely yours,
> Mike.
> 
> 



