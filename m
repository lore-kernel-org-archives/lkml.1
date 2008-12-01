Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYLAAIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYLAAIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYLAAIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:08:14 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56038 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbYLAAIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:08:13 -0500
Date: Mon, 1 Dec 2008 01:10:47 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
       Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc6 1/3] mfd: twl4030: simplified child creation
	code
Message-ID: <20081201001046.GB3067@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <200811261053.18805.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811261053.18805.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, Nov 26, 2008 at 10:53:18AM -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Minor cleanup to twl4030-core: define a helper function to populate
> a single child node, and use it to replace six inconsistent versions
> of the same logic.  Both object and source code shrink.
> 
> As part of this, some devices now have more IRQ resources:  battery
> charger, keypad, ADC, and USB transceiver.  That helps to remove some
> irq #defines that block the children's drivers code from compiling on
> non-OMAP platforms.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
> These three patches are not essential for 2.6.28-final, although
> having the first two merge would be appreciated by ASoc folk so
> they can test-build the twl4030 codec support on non-OMAP hw.
All 3 patches pushed to my for-next branch, thanks.

Cheers,
Samuel.


> The diff on this first one is particularly deceptive; ugh.
> 
>  drivers/mfd/twl4030-core.c |  298 +++++++++++--------------------------------
>  1 file changed, 83 insertions(+), 215 deletions(-)
> 
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -352,258 +352,126 @@ EXPORT_SYMBOL(twl4030_i2c_read_u8);
>  
>  /*----------------------------------------------------------------------*/
>  
> -/*
> - * NOTE:  We know the first 8 IRQs after pdata->base_irq are
> - * for the PIH, and the next are for the PWR_INT SIH, since
> - * that's how twl_init_irq() sets things up.
> - */
> -
> -static int add_children(struct twl4030_platform_data *pdata)
> +static struct device *add_child(unsigned chip, const char *name,
> +		void *pdata, unsigned pdata_len,
> +		bool can_wakeup, int irq0, int irq1)
>  {
> -	struct platform_device	*pdev = NULL;
> -	struct twl4030_client	*twl = NULL;
> -	int			status = 0;
> -
> -	if (twl_has_bci() && pdata->bci) {
> -		twl = &twl4030_modules[3];
> -
> -		pdev = platform_device_alloc("twl4030_bci", -1);
> -		if (!pdev) {
> -			pr_debug("%s: can't alloc bci dev\n", DRIVER_NAME);
> -			status = -ENOMEM;
> -			goto err;
> -		}
> -
> -		if (status == 0) {
> -			pdev->dev.parent = &twl->client->dev;
> -			status = platform_device_add_data(pdev, pdata->bci,
> -					sizeof(*pdata->bci));
> -			if (status < 0) {
> -				dev_dbg(&twl->client->dev,
> -					"can't add bci data, %d\n",
> -					status);
> -				goto err;
> -			}
> -		}
> -
> -		if (status == 0) {
> -			struct resource r = {
> -				.start = pdata->irq_base + 8 + 1,
> -				.flags = IORESOURCE_IRQ,
> -			};
> +	struct platform_device	*pdev;
> +	struct twl4030_client	*twl = &twl4030_modules[chip];
> +	int			status;
>  
> -			status = platform_device_add_resources(pdev, &r, 1);
> -		}
> +	pdev = platform_device_alloc(name, -1);
> +	if (!pdev) {
> +		dev_dbg(&twl->client->dev, "can't alloc dev\n");
> +		status = -ENOMEM;
> +		goto err;
> +	}
>  
> -		if (status == 0)
> -			status = platform_device_add(pdev);
> +	device_init_wakeup(&pdev->dev, can_wakeup);
> +	pdev->dev.parent = &twl->client->dev;
>  
> +	if (pdata) {
> +		status = platform_device_add_data(pdev, pdata, pdata_len);
>  		if (status < 0) {
> -			platform_device_put(pdev);
> -			dev_dbg(&twl->client->dev,
> -					"can't create bci dev, %d\n",
> -					status);
> +			dev_dbg(&pdev->dev, "can't add platform_data\n");
>  			goto err;
>  		}
>  	}
>  
> -	if (twl_has_gpio() && pdata->gpio) {
> -		twl = &twl4030_modules[1];
> +	if (irq0) {
> +		struct resource r[2] = {
> +			{ .start = irq0, .flags = IORESOURCE_IRQ, },
> +			{ .start = irq1, .flags = IORESOURCE_IRQ, },
> +		};
>  
> -		pdev = platform_device_alloc("twl4030_gpio", -1);
> -		if (!pdev) {
> -			pr_debug("%s: can't alloc gpio dev\n", DRIVER_NAME);
> -			status = -ENOMEM;
> +		status = platform_device_add_resources(pdev, r, irq1 ? 2 : 1);
> +		if (status < 0) {
> +			dev_dbg(&pdev->dev, "can't add irqs\n");
>  			goto err;
>  		}
> +	}
>  
> -		/* more driver model init */
> -		if (status == 0) {
> -			pdev->dev.parent = &twl->client->dev;
> -			/* device_init_wakeup(&pdev->dev, 1); */
> +	status = platform_device_add(pdev);
>  
> -			status = platform_device_add_data(pdev, pdata->gpio,
> -					sizeof(*pdata->gpio));
> -			if (status < 0) {
> -				dev_dbg(&twl->client->dev,
> -					"can't add gpio data, %d\n",
> -					status);
> -				goto err;
> -			}
> -		}
> +err:
> +	if (status < 0) {
> +		platform_device_put(pdev);
> +		dev_err(&twl->client->dev, "can't add %s dev\n", name);
> +		return ERR_PTR(status);
> +	}
> +	return &pdev->dev;
> +}
>  
> -		/* GPIO module IRQ */
> -		if (status == 0) {
> -			struct resource	r = {
> -				.start = pdata->irq_base + 0,
> -				.flags = IORESOURCE_IRQ,
> -			};
> +/*
> + * NOTE:  We know the first 8 IRQs after pdata->base_irq are
> + * for the PIH, and the next are for the PWR_INT SIH, since
> + * that's how twl_init_irq() sets things up.
> + */
>  
> -			status = platform_device_add_resources(pdev, &r, 1);
> -		}
> +static int add_children(struct twl4030_platform_data *pdata)
> +{
> +	struct device	*child;
>  
> -		if (status == 0)
> -			status = platform_device_add(pdev);
> +	if (twl_has_bci() && pdata->bci) {
> +		child = add_child(3, "twl4030_bci",
> +				pdata->bci, sizeof(*pdata->bci),
> +				false,
> +				/* irq0 = CHG_PRES, irq1 = BCI */
> +				pdata->irq_base + 8 + 1, pdata->irq_base + 2);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +	}
>  
> -		if (status < 0) {
> -			platform_device_put(pdev);
> -			dev_dbg(&twl->client->dev,
> -					"can't create gpio dev, %d\n",
> -					status);
> -			goto err;
> -		}
> +	if (twl_has_gpio() && pdata->gpio) {
> +		child = add_child(1, "twl4030_gpio",
> +				pdata->gpio, sizeof(*pdata->gpio),
> +				false, pdata->irq_base + 0, 0);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
>  	}
>  
>  	if (twl_has_keypad() && pdata->keypad) {
> -		pdev = platform_device_alloc("twl4030_keypad", -1);
> -		if (pdev) {
> -			twl = &twl4030_modules[2];
> -			pdev->dev.parent = &twl->client->dev;
> -			device_init_wakeup(&pdev->dev, 1);
> -			status = platform_device_add_data(pdev, pdata->keypad,
> -					sizeof(*pdata->keypad));
> -			if (status < 0) {
> -				dev_dbg(&twl->client->dev,
> -					"can't add keypad data, %d\n",
> -					status);
> -				platform_device_put(pdev);
> -				goto err;
> -			}
> -			status = platform_device_add(pdev);
> -			if (status < 0) {
> -				platform_device_put(pdev);
> -				dev_dbg(&twl->client->dev,
> -						"can't create keypad dev, %d\n",
> -						status);
> -				goto err;
> -			}
> -		} else {
> -			pr_debug("%s: can't alloc keypad dev\n", DRIVER_NAME);
> -			status = -ENOMEM;
> -			goto err;
> -		}
> +		child = add_child(2, "twl4030_keypad",
> +				pdata->keypad, sizeof(*pdata->keypad),
> +				true, pdata->irq_base + 1, 0);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
>  	}
>  
>  	if (twl_has_madc() && pdata->madc) {
> -		pdev = platform_device_alloc("twl4030_madc", -1);
> -		if (pdev) {
> -			twl = &twl4030_modules[2];
> -			pdev->dev.parent = &twl->client->dev;
> -			device_init_wakeup(&pdev->dev, 1);
> -			status = platform_device_add_data(pdev, pdata->madc,
> -					sizeof(*pdata->madc));
> -			if (status < 0) {
> -				platform_device_put(pdev);
> -				dev_dbg(&twl->client->dev,
> -					"can't add madc data, %d\n",
> -					status);
> -				goto err;
> -			}
> -			status = platform_device_add(pdev);
> -			if (status < 0) {
> -				platform_device_put(pdev);
> -				dev_dbg(&twl->client->dev,
> -						"can't create madc dev, %d\n",
> -						status);
> -				goto err;
> -			}
> -		} else {
> -			pr_debug("%s: can't alloc madc dev\n", DRIVER_NAME);
> -			status = -ENOMEM;
> -			goto err;
> -		}
> +		child = add_child(2, "twl4030_madc",
> +				pdata->madc, sizeof(*pdata->madc),
> +				true, pdata->irq_base + 3, 0);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
>  	}
>  
>  	if (twl_has_rtc()) {
> -		twl = &twl4030_modules[3];
> -
> -		pdev = platform_device_alloc("twl4030_rtc", -1);
> -		if (!pdev) {
> -			pr_debug("%s: can't alloc rtc dev\n", DRIVER_NAME);
> -			status = -ENOMEM;
> -		} else {
> -			pdev->dev.parent = &twl->client->dev;
> -			device_init_wakeup(&pdev->dev, 1);
> -		}
> -
>  		/*
> -		 * REVISIT platform_data here currently might use of
> +		 * REVISIT platform_data here currently might expose the
>  		 * "msecure" line ... but for now we just expect board
> -		 * setup to tell the chip "we are secure" at all times.
> +		 * setup to tell the chip "it's always ok to SET_TIME".
>  		 * Eventually, Linux might become more aware of such
>  		 * HW security concerns, and "least privilege".
>  		 */
> -
> -		/* RTC module IRQ */
> -		if (status == 0) {
> -			struct resource	r = {
> -				.start = pdata->irq_base + 8 + 3,
> -				.flags = IORESOURCE_IRQ,
> -			};
> -
> -			status = platform_device_add_resources(pdev, &r, 1);
> -		}
> -
> -		if (status == 0)
> -			status = platform_device_add(pdev);
> -
> -		if (status < 0) {
> -			platform_device_put(pdev);
> -			dev_dbg(&twl->client->dev,
> -					"can't create rtc dev, %d\n",
> -					status);
> -			goto err;
> -		}
> +		child = add_child(3, "twl4030_rtc",
> +				NULL, 0,
> +				true, pdata->irq_base + 8 + 3, 0);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
>  	}
>  
>  	if (twl_has_usb() && pdata->usb) {
> -		twl = &twl4030_modules[0];
> -
> -		pdev = platform_device_alloc("twl4030_usb", -1);
> -		if (!pdev) {
> -			pr_debug("%s: can't alloc usb dev\n", DRIVER_NAME);
> -			status = -ENOMEM;
> -			goto err;
> -		}
> -
> -		if (status == 0) {
> -			pdev->dev.parent = &twl->client->dev;
> -			device_init_wakeup(&pdev->dev, 1);
> -			status = platform_device_add_data(pdev, pdata->usb,
> -					sizeof(*pdata->usb));
> -			if (status < 0) {
> -				platform_device_put(pdev);
> -				dev_dbg(&twl->client->dev,
> -					"can't add usb data, %d\n",
> -					status);
> -				goto err;
> -			}
> -		}
> -
> -		if (status == 0) {
> -			struct resource r = {
> -				.start = pdata->irq_base + 8 + 2,
> -				.flags = IORESOURCE_IRQ,
> -			};
> -
> -			status = platform_device_add_resources(pdev, &r, 1);
> -		}
> -
> -		if (status == 0)
> -			status = platform_device_add(pdev);
> -
> -		if (status < 0) {
> -			platform_device_put(pdev);
> -			dev_dbg(&twl->client->dev,
> -					"can't create usb dev, %d\n",
> -					status);
> -		}
> +		child = add_child(0, "twl4030_usb",
> +				pdata->usb, sizeof(*pdata->usb),
> +				true,
> +				/* irq0 = USB_PRES, irq1 = USB */
> +				pdata->irq_base + 8 + 2, pdata->irq_base + 4);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
>  	}
>  
> -err:
> -	if (status)
> -		pr_err("failed to add twl4030's children (status %d)\n", status);
> -	return status;
> +	return 0;
>  }
>  
>  /*----------------------------------------------------------------------*/

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
