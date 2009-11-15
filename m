Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbZKOWmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbZKOWmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZKOWmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:42:44 -0500
Received: from mga10.intel.com ([192.55.52.92]:5344 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751740AbZKOWmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:42:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,747,1249282800"; 
   d="scan'208";a="514115637"
Date: Sun, 15 Nov 2009 23:44:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Move WM831x to generic IRQ
Message-ID: <20091115224434.GD8367@sortiz.org>
References: <1257955822-31097-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257955822-31097-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 04:10:22PM +0000, Mark Brown wrote:
> Replace the wm831x-local IRQ infrastructure with genirq, allowing access
> to the diagnostic infrastructure of genirq and allowing us to implement
> interrupt support for the GPIOs.  The switchover is done within the
> wm831x specific IRQ API, further patches will convert the individual
> drivers to use genirq directly.
Thanks Mark, patch applied.

Cheers,
Samuel.

 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm831x-core.c        |    9 +-
>  drivers/mfd/wm831x-irq.c         |  209 ++++++++++++++++----------------------
>  include/linux/mfd/wm831x/core.h  |   40 +++++--
>  include/linux/mfd/wm831x/pdata.h |    1 +
>  4 files changed, 122 insertions(+), 137 deletions(-)
> 
> diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
> index e9ce8c6..ab3f5ca 100644
> --- a/drivers/mfd/wm831x-core.c
> +++ b/drivers/mfd/wm831x-core.c
> @@ -1504,19 +1504,19 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
>  	case WM8310:
>  		ret = mfd_add_devices(wm831x->dev, -1,
>  				      wm8310_devs, ARRAY_SIZE(wm8310_devs),
> -				      NULL, 0);
> +				      NULL, wm831x->irq_base);
>  		break;
>  
>  	case WM8311:
>  		ret = mfd_add_devices(wm831x->dev, -1,
>  				      wm8311_devs, ARRAY_SIZE(wm8311_devs),
> -				      NULL, 0);
> +				      NULL, wm831x->irq_base);
>  		break;
>  
>  	case WM8312:
>  		ret = mfd_add_devices(wm831x->dev, -1,
>  				      wm8312_devs, ARRAY_SIZE(wm8312_devs),
> -				      NULL, 0);
> +				      NULL, wm831x->irq_base);
>  		break;
>  
>  	case WM8320:
> @@ -1538,7 +1538,8 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
>  	if (pdata && pdata->backlight) {
>  		/* Treat errors as non-critical */
>  		ret = mfd_add_devices(wm831x->dev, -1, backlight_devs,
> -				      ARRAY_SIZE(backlight_devs), NULL, 0);
> +				      ARRAY_SIZE(backlight_devs), NULL,
> +				      wm831x->irq_base);
>  		if (ret < 0)
>  			dev_err(wm831x->dev, "Failed to add backlight: %d\n",
>  				ret);
> diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
> index ac056ea..3013276 100644
> --- a/drivers/mfd/wm831x-irq.c
> +++ b/drivers/mfd/wm831x-irq.c
> @@ -15,6 +15,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/i2c.h>
> +#include <linux/irq.h>
>  #include <linux/mfd/core.h>
>  #include <linux/interrupt.h>
>  
> @@ -339,110 +340,71 @@ static inline int irq_data_to_mask_reg(struct wm831x_irq_data *irq_data)
>  	return WM831X_INTERRUPT_STATUS_1_MASK - 1 + irq_data->reg;
>  }
>  
> -static void __wm831x_enable_irq(struct wm831x *wm831x, int irq)
> +static inline struct wm831x_irq_data *irq_to_wm831x_irq(struct wm831x *wm831x,
> +							int irq)
>  {
> -	struct wm831x_irq_data *irq_data = &wm831x_irqs[irq];
> -
> -	wm831x->irq_masks[irq_data->reg - 1] &= ~irq_data->mask;
> -	wm831x_reg_write(wm831x, irq_data_to_mask_reg(irq_data),
> -			 wm831x->irq_masks[irq_data->reg - 1]);
> +	return &wm831x_irqs[irq - wm831x->irq_base];
>  }
>  
> -void wm831x_enable_irq(struct wm831x *wm831x, int irq)
> +static void wm831x_irq_lock(unsigned int irq)
>  {
> -	mutex_lock(&wm831x->irq_lock);
> -	__wm831x_enable_irq(wm831x, irq);
> -	mutex_unlock(&wm831x->irq_lock);
> -}
> -EXPORT_SYMBOL_GPL(wm831x_enable_irq);
> +	struct wm831x *wm831x = get_irq_chip_data(irq);
>  
> -static void __wm831x_disable_irq(struct wm831x *wm831x, int irq)
> -{
> -	struct wm831x_irq_data *irq_data = &wm831x_irqs[irq];
> -
> -	wm831x->irq_masks[irq_data->reg - 1] |= irq_data->mask;
> -	wm831x_reg_write(wm831x, irq_data_to_mask_reg(irq_data),
> -			 wm831x->irq_masks[irq_data->reg - 1]);
> -}
> -
> -void wm831x_disable_irq(struct wm831x *wm831x, int irq)
> -{
>  	mutex_lock(&wm831x->irq_lock);
> -	__wm831x_disable_irq(wm831x, irq);
> -	mutex_unlock(&wm831x->irq_lock);
>  }
> -EXPORT_SYMBOL_GPL(wm831x_disable_irq);
>  
> -int wm831x_request_irq(struct wm831x *wm831x,
> -		       unsigned int irq, irq_handler_t handler,
> -		       unsigned long flags, const char *name,
> -		       void *dev)
> +static void wm831x_irq_sync_unlock(unsigned int irq)
>  {
> -	int ret = 0;
> -
> -	if (irq < 0 || irq >= WM831X_NUM_IRQS)
> -		return -EINVAL;
> -
> -	mutex_lock(&wm831x->irq_lock);
> -
> -	if (wm831x_irqs[irq].handler) {
> -		dev_err(wm831x->dev, "Already have handler for IRQ %d\n", irq);
> -		ret = -EINVAL;
> -		goto out;
> +	struct wm831x *wm831x = get_irq_chip_data(irq);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
> +		/* If there's been a change in the mask write it back
> +		 * to the hardware. */
> +		if (wm831x->irq_masks_cur[i] != wm831x->irq_masks_cache[i]) {
> +			wm831x->irq_masks_cache[i] = wm831x->irq_masks_cur[i];
> +			wm831x_reg_write(wm831x,
> +					 WM831X_INTERRUPT_STATUS_1_MASK + i,
> +					 wm831x->irq_masks_cur[i]);
> +		}
>  	}
>  
> -	wm831x_irqs[irq].handler = handler;
> -	wm831x_irqs[irq].handler_data = dev;
> -
> -	__wm831x_enable_irq(wm831x, irq);
> -
> -out:
>  	mutex_unlock(&wm831x->irq_lock);
> -
> -	return ret;
>  }
> -EXPORT_SYMBOL_GPL(wm831x_request_irq);
>  
> -void wm831x_free_irq(struct wm831x *wm831x, unsigned int irq, void *data)
> +static void wm831x_irq_unmask(unsigned int irq)
>  {
> -	if (irq < 0 || irq >= WM831X_NUM_IRQS)
> -		return;
> -
> -	mutex_lock(&wm831x->irq_lock);
> +	struct wm831x *wm831x = get_irq_chip_data(irq);
> +	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
>  
> -	wm831x_irqs[irq].handler = NULL;
> -	wm831x_irqs[irq].handler_data = NULL;
> -
> -	__wm831x_disable_irq(wm831x, irq);
> -
> -	mutex_unlock(&wm831x->irq_lock);
> +	wm831x->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
>  }
> -EXPORT_SYMBOL_GPL(wm831x_free_irq);
>  
> -
> -static void wm831x_handle_irq(struct wm831x *wm831x, int irq, int status)
> +static void wm831x_irq_mask(unsigned int irq)
>  {
> -	struct wm831x_irq_data *irq_data = &wm831x_irqs[irq];
> -
> -	if (irq_data->handler) {
> -		irq_data->handler(irq, irq_data->handler_data);
> -		wm831x_reg_write(wm831x, irq_data_to_status_reg(irq_data),
> -				 irq_data->mask);
> -	} else {
> -		dev_err(wm831x->dev, "Unhandled IRQ %d, masking\n", irq);
> -		__wm831x_disable_irq(wm831x, irq);
> -	}
> +	struct wm831x *wm831x = get_irq_chip_data(irq);
> +	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
> +
> +	wm831x->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
>  }
>  
> -/* Main interrupt handling occurs in a workqueue since we need
> - * interrupts enabled to interact with the chip. */
> -static void wm831x_irq_worker(struct work_struct *work)
> +static struct irq_chip wm831x_irq_chip = {
> +	.name = "wm831x",
> +	.bus_lock = wm831x_irq_lock,
> +	.bus_sync_unlock = wm831x_irq_sync_unlock,
> +	.mask = wm831x_irq_mask,
> +	.unmask = wm831x_irq_unmask,
> +};
> +
> +/* The processing of the primary interrupt occurs in a thread so that
> + * we can interact with the device over I2C or SPI. */
> +static irqreturn_t wm831x_irq_thread(int irq, void *data)
>  {
> -	struct wm831x *wm831x = container_of(work, struct wm831x, irq_work);
> +	struct wm831x *wm831x = data;
>  	unsigned int i;
>  	int primary;
> -	int status_regs[5];
> -	int read[5] = { 0 };
> +	int status_regs[WM831X_NUM_IRQ_REGS] = { 0 };
> +	int read[WM831X_NUM_IRQ_REGS] = { 0 };
>  	int *status;
>  
>  	primary = wm831x_reg_read(wm831x, WM831X_SYSTEM_INTERRUPTS);
> @@ -452,8 +414,6 @@ static void wm831x_irq_worker(struct work_struct *work)
>  		goto out;
>  	}
>  
> -	mutex_lock(&wm831x->irq_lock);
> -
>  	for (i = 0; i < ARRAY_SIZE(wm831x_irqs); i++) {
>  		int offset = wm831x_irqs[i].reg - 1;
>  
> @@ -471,41 +431,34 @@ static void wm831x_irq_worker(struct work_struct *work)
>  				dev_err(wm831x->dev,
>  					"Failed to read IRQ status: %d\n",
>  					*status);
> -				goto out_lock;
> +				goto out;
>  			}
>  
> -			/* Mask out the disabled IRQs */
> -			*status &= ~wm831x->irq_masks[offset];
>  			read[offset] = 1;
>  		}
>  
> -		if (*status & wm831x_irqs[i].mask)
> -			wm831x_handle_irq(wm831x, i, *status);
> +		/* Report it if it isn't masked, or forget the status. */
> +		if ((*status & ~wm831x->irq_masks_cur[offset])
> +		    & wm831x_irqs[i].mask)
> +			handle_nested_irq(wm831x->irq_base + i);
> +		else
> +			*status &= ~wm831x_irqs[i].mask;
>  	}
>  
> -out_lock:
> -	mutex_unlock(&wm831x->irq_lock);
>  out:
> -	enable_irq(wm831x->irq);
> -}
> -
> -
> -static irqreturn_t wm831x_cpu_irq(int irq, void *data)
> -{
> -	struct wm831x *wm831x = data;
> -
> -	/* Shut the interrupt to the CPU up and schedule the actual
> -	 * handler; we can't check that the IRQ is asserted. */
> -	disable_irq_nosync(irq);
> -
> -	queue_work(wm831x->irq_wq, &wm831x->irq_work);
> +	for (i = 0; i < ARRAY_SIZE(status_regs); i++) {
> +		if (status_regs[i])
> +			wm831x_reg_write(wm831x, WM831X_INTERRUPT_STATUS_1 + i,
> +					 status_regs[i]);
> +	}
>  
>  	return IRQ_HANDLED;
>  }
>  
>  int wm831x_irq_init(struct wm831x *wm831x, int irq)
>  {
> -	int i, ret;
> +	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
> +	int i, cur_irq, ret;
>  
>  	mutex_init(&wm831x->irq_lock);
>  
> @@ -515,41 +468,53 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
>  		return 0;
>  	}
>  
> -
> -	wm831x->irq_wq = create_singlethread_workqueue("wm831x-irq");
> -	if (!wm831x->irq_wq) {
> -		dev_err(wm831x->dev, "Failed to allocate IRQ worker\n");
> -		return -ESRCH;
> +	if (!pdata || !pdata->irq_base) {
> +		dev_err(wm831x->dev,
> +			"No interrupt base specified, no interrupts\n");
> +		return 0;
>  	}
>  
>  	wm831x->irq = irq;
> -	INIT_WORK(&wm831x->irq_work, wm831x_irq_worker);
> +	wm831x->irq_base = pdata->irq_base;
>  
>  	/* Mask the individual interrupt sources */
> -	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks); i++) {
> -		wm831x->irq_masks[i] = 0xffff;
> +	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
> +		wm831x->irq_masks_cur[i] = 0xffff;
> +		wm831x->irq_masks_cache[i] = 0xffff;
>  		wm831x_reg_write(wm831x, WM831X_INTERRUPT_STATUS_1_MASK + i,
>  				 0xffff);
>  	}
>  
> -	/* Enable top level interrupts, we mask at secondary level */
> -	wm831x_reg_write(wm831x, WM831X_SYSTEM_INTERRUPTS_MASK, 0);
> +	/* Register them with genirq */
> +	for (cur_irq = wm831x->irq_base;
> +	     cur_irq < ARRAY_SIZE(wm831x_irqs) + wm831x->irq_base;
> +	     cur_irq++) {
> +		set_irq_chip_data(cur_irq, wm831x);
> +		set_irq_chip_and_handler(cur_irq, &wm831x_irq_chip,
> +					 handle_edge_irq);
> +		set_irq_nested_thread(cur_irq, 1);
> +
> +		/* ARM needs us to explicitly flag the IRQ as valid
> +		 * and will set them noprobe when we do so. */
> +#ifdef CONFIG_ARM
> +		set_irq_flags(cur_irq, IRQF_VALID);
> +#else
> +		set_irq_noprobe(cur_irq);
> +#endif
> +	}
>  
> -	/* We're good to go.  We set IRQF_SHARED since there's a
> -	 * chance the driver will interoperate with another driver but
> -	 * the need to disable the IRQ while handing via I2C/SPI means
> -	 * that this may break and performance will be impacted.  If
> -	 * this does happen it's a hardware design issue and the only
> -	 * other alternative would be polling.
> -	 */
> -	ret = request_irq(irq, wm831x_cpu_irq, IRQF_TRIGGER_LOW | IRQF_SHARED,
> -			  "wm831x", wm831x);
> +	ret = request_threaded_irq(irq, NULL, wm831x_irq_thread,
> +				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				   "wm831x", wm831x);
>  	if (ret != 0) {
>  		dev_err(wm831x->dev, "Failed to request IRQ %d: %d\n",
>  			irq, ret);
>  		return ret;
>  	}
>  
> +	/* Enable top level interrupts, we mask at secondary level */
> +	wm831x_reg_write(wm831x, WM831X_SYSTEM_INTERRUPTS_MASK, 0);
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
> index d01d293..5184b79 100644
> --- a/include/linux/mfd/wm831x/core.h
> +++ b/include/linux/mfd/wm831x/core.h
> @@ -16,7 +16,6 @@
>  #define __MFD_WM831X_CORE_H__
>  
>  #include <linux/interrupt.h>
> -#include <linux/workqueue.h>
>  
>  /*
>   * Register values.
> @@ -236,6 +235,8 @@
>  
>  struct regulator_dev;
>  
> +#define WM831X_NUM_IRQ_REGS 5
> +
>  struct wm831x {
>  	struct mutex io_lock;
>  
> @@ -249,10 +250,9 @@ struct wm831x {
>  
>  	int irq;  /* Our chip IRQ */
>  	struct mutex irq_lock;
> -	struct workqueue_struct *irq_wq;
> -	struct work_struct irq_work;
>  	unsigned int irq_base;
> -	int irq_masks[5];
> +	int irq_masks_cur[WM831X_NUM_IRQ_REGS];   /* Currently active value */
> +	int irq_masks_cache[WM831X_NUM_IRQ_REGS]; /* Cached hardware value */
>  
>  	int num_gpio;
>  
> @@ -281,12 +281,30 @@ int wm831x_bulk_read(struct wm831x *wm831x, unsigned short reg,
>  int wm831x_irq_init(struct wm831x *wm831x, int irq);
>  void wm831x_irq_exit(struct wm831x *wm831x);
>  
> -int __must_check wm831x_request_irq(struct wm831x *wm831x,
> -				    unsigned int irq, irq_handler_t handler,
> -				    unsigned long flags, const char *name,
> -				    void *dev);
> -void wm831x_free_irq(struct wm831x *wm831x, unsigned int, void *);
> -void wm831x_disable_irq(struct wm831x *wm831x, int irq);
> -void wm831x_enable_irq(struct wm831x *wm831x, int irq);
> +static inline int __must_check wm831x_request_irq(struct wm831x *wm831x,
> +						  unsigned int irq,
> +						  irq_handler_t handler,
> +						  unsigned long flags,
> +						  const char *name,
> +						  void *dev)
> +{
> +	return request_threaded_irq(irq, NULL, handler, flags, name, dev);
> +}
> +
> +static inline void wm831x_free_irq(struct wm831x *wm831x,
> +				   unsigned int irq, void *dev)
> +{
> +	free_irq(irq, dev);
> +}
> +
> +static inline void wm831x_disable_irq(struct wm831x *wm831x, int irq)
> +{
> +	disable_irq(irq);
> +}
> +
> +static inline void wm831x_enable_irq(struct wm831x *wm831x, int irq)
> +{
> +	enable_irq(irq);
> +}
>  
>  #endif
> diff --git a/include/linux/mfd/wm831x/pdata.h b/include/linux/mfd/wm831x/pdata.h
> index 90d8202..415c228 100644
> --- a/include/linux/mfd/wm831x/pdata.h
> +++ b/include/linux/mfd/wm831x/pdata.h
> @@ -91,6 +91,7 @@ struct wm831x_pdata {
>  	/** Called after subdevices are set up */
>  	int (*post_init)(struct wm831x *wm831x);
>  
> +	int irq_base;
>  	int gpio_base;
>  	struct wm831x_backlight_pdata *backlight;
>  	struct wm831x_backup_pdata *backup;
> -- 
> 1.6.5.2
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
