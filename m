Return-Path: <linux-kernel-owner+w=401wt.eu-S1752378AbZK0Te5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbZK0Te5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 14:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZK0Te4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 14:34:56 -0500
Received: from mga06.intel.com ([134.134.136.21]:56714 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751176AbZK0Tey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 14:34:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,303,1257148800"; 
   d="scan'208";a="471035872"
Date: Fri, 27 Nov 2009 20:36:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-omap@vger.kernel.org, Mikko Ylinen <mikko.k.ylinen@nokia.com>
Subject: Re: [PATCH] mfd: twl4030: Driver for twl4030 madc module
Message-ID: <20091127193636.GA16866@sortiz.org>
References: <1259146071-2372-1-git-send-email-amit.kucheria@verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259146071-2372-1-git-send-email-amit.kucheria@verdurent.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Wed, Nov 25, 2009 at 12:47:51PM +0200, Amit Kucheria wrote:
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index af0fc90..df1897b 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -25,8 +25,9 @@ obj-$(CONFIG_TPS65010)		+= tps65010.o
>  obj-$(CONFIG_MENELAUS)		+= menelaus.o
>  
>  obj-$(CONFIG_TWL4030_CORE)	+= twl4030-core.o twl4030-irq.o
> -obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
> +obj-$(CONFIG_TWL4030_POWER)	+= twl4030-power.o
>  obj-$(CONFIG_TWL4030_CODEC)	+= twl4030-codec.o
> +obj-$(CONFIG_TWL4030_MADC)	+= twl4030-madc.o
>  
>  obj-$(CONFIG_MFD_MC13783)	+= mc13783-core.o
>  
> diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
> new file mode 100644
> index 0000000..90ce99a
> --- /dev/null
> +++ b/drivers/mfd/twl4030-madc.c
> @@ -0,0 +1,548 @@
> +/*
> + * drivers/i2c/chips/twl4030-madc.c
drivers/mfd/twl4030-madc.c
By the way, have you considered moving this one to drivers/hwmon ?


> + * TWL4030 MADC module driver
> + *
> + * Copyright (C) 2008 Nokia Corporation
> + * Mikko Ylinen <mikko.k.ylinen@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/platform_device.h>
> +#include <linux/miscdevice.h>
> +#include <linux/i2c/twl4030.h>
> +#include <linux/i2c/twl4030-madc.h>
> +
> +#include <asm/uaccess.h>
> +
> +#define TWL4030_MADC_PFX	"twl4030-madc: "
> +
> +struct twl4030_madc_data {
> +	struct device		*dev;
> +	struct mutex		lock;
> +	struct work_struct	ws;
> +	struct twl4030_madc_request	requests[TWL4030_MADC_NUM_METHODS];
Typically, I'd expect to have a list (limited in length) of requests here, but
I guess you're happy with that array .



> +	int imr;
> +	int isr;
> +};
> +
> +static struct twl4030_madc_data *the_madc;
I dont particularly enjoy that. All of the twl4030 drivers have this bad habit
of assuming they will be alone on a platform. Although it's certainly very
likely, I still think having this kind of design is not so nice.


> +static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc, int chan, int on);
> +
> +static
> +const struct twl4030_madc_conversion_method twl4030_conversion_methods[] = {
> +	[TWL4030_MADC_RT] = {
> +		.sel	= TWL4030_MADC_RTSELECT_LSB,
> +		.avg	= TWL4030_MADC_RTAVERAGE_LSB,
> +		.rbase	= TWL4030_MADC_RTCH0_LSB,
> +	},
> +	[TWL4030_MADC_SW1] = {
> +		.sel	= TWL4030_MADC_SW1SELECT_LSB,
> +		.avg	= TWL4030_MADC_SW1AVERAGE_LSB,
> +		.rbase	= TWL4030_MADC_GPCH0_LSB,
> +		.ctrl	= TWL4030_MADC_CTRL_SW1,
> +	},
> +	[TWL4030_MADC_SW2] = {
> +		.sel	= TWL4030_MADC_SW2SELECT_LSB,
> +		.avg	= TWL4030_MADC_SW2AVERAGE_LSB,
> +		.rbase	= TWL4030_MADC_GPCH0_LSB,
> +		.ctrl	= TWL4030_MADC_CTRL_SW2,
> +	},
> +};
> +
> +static int twl4030_madc_read(struct twl4030_madc_data *madc, u8 reg)
> +{
> +	int ret;
> +	u8 val;
> +
> +	ret = twl4030_i2c_read_u8(TWL4030_MODULE_MADC, &val, reg);
> +	if (ret) {
> +		dev_dbg(madc->dev, "unable to read register 0x%X\n", reg);
> +		return ret;
> +	}
> +
> +	return val;
> +}
FWIW, you're not checking the return value on any of the madc_read calls
below.


> +static void twl4030_madc_write(struct twl4030_madc_data *madc, u8 reg, u8 val)
> +{
> +	int ret;
> +
> +	ret = twl4030_i2c_write_u8(TWL4030_MODULE_MADC, val, reg);
> +	if (ret)
> +		dev_err(madc->dev, "unable to write register 0x%X\n", reg);
> +}
> +
> +static int twl4030_madc_channel_raw_read(struct twl4030_madc_data *madc, u8 reg)
> +{
> +	u8 msb, lsb;
> +
> +	/* For each ADC channel, we have MSB and LSB register pair. MSB address
> +	 * is always LSB address+1. reg parameter is the addr of LSB register */
> +	msb = twl4030_madc_read(madc, reg + 1);
> +	lsb = twl4030_madc_read(madc, reg);
> +
> +	return (int)(((msb << 8) | lsb) >> 6);
> +}
> +
> +static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
> +		u8 reg_base, u16 channels, int *buf)
> +{
> +	int count = 0;
> +	u8 reg, i;
> +
> +	if (unlikely(!buf))
> +		return 0;
> +
> +	for (i = 0; i < TWL4030_MADC_MAX_CHANNELS; i++) {
> +		if (channels & (1<<i)) {
> +			reg = reg_base + 2*i;
> +			buf[i] = twl4030_madc_channel_raw_read(madc, reg);
> +			count++;
> +		}
> +	}
> +	return count;
> +}
> +
> +static void twl4030_madc_enable_irq(struct twl4030_madc_data *madc, int id)
> +{
> +	u8 val;
> +
> +	val = twl4030_madc_read(madc, madc->imr);
> +	val &= ~(1 << id);
> +	twl4030_madc_write(madc, madc->imr, val);
> +}
> +
> +static void twl4030_madc_disable_irq(struct twl4030_madc_data *madc, int id)
> +{
> +	u8 val;
> +
> +	val = twl4030_madc_read(madc, madc->imr);
> +	val |= (1 << id);
> +	twl4030_madc_write(madc, madc->imr, val);
> +}
> +
> +static irqreturn_t twl4030_madc_irq_handler(int irq, void *_madc)
> +{
> +	struct twl4030_madc_data *madc = _madc;
> +	u8 isr_val, imr_val;
> +	int i;
> +
> +#ifdef CONFIG_LOCKDEP
> +	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> +	 * we don't want and can't tolerate.  Although it might be
> +	 * friendlier not to borrow this thread context...
> +	 */
> +	local_irq_enable();
> +#endif
I'm curious, what's special about madc so that it can't tolerate that ?


> +	/* Use COR to ack interrupts since we have no shared IRQs in ISRx */
> +	isr_val = twl4030_madc_read(madc, madc->isr);
> +	imr_val = twl4030_madc_read(madc, madc->imr);
> +
> +	isr_val &= ~imr_val;
> +
> +	for (i = 0; i < TWL4030_MADC_NUM_METHODS; i++) {
> +
> +		if (!(isr_val & (1<<i)))
> +			continue;
> +
> +		twl4030_madc_disable_irq(madc, i);
> +		madc->requests[i].result_pending = 1;
> +	}
> +
> +	schedule_work(&madc->ws);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void twl4030_madc_work(struct work_struct *ws)
> +{
> +	const struct twl4030_madc_conversion_method *method;
> +	struct twl4030_madc_data *madc;
> +	struct twl4030_madc_request *r;
> +	int len, i;
> +
> +	madc = container_of(ws, struct twl4030_madc_data, ws);
> +	mutex_lock(&madc->lock);
> +
> +	for (i = 0; i < TWL4030_MADC_NUM_METHODS; i++) {
> +
> +		r = &madc->requests[i];
> +
> +		/* No pending results for this method, move to next one */
> +		if (!r->result_pending)
> +			continue;
> +
> +		method = &twl4030_conversion_methods[r->method];
> +
> +		/* Read results */
> +		len = twl4030_madc_read_channels(madc, method->rbase,
> +						 r->channels, r->rbuf);
> +
> +		/* Return results to caller */
> +		if (r->func_cb != NULL) {
> +			r->func_cb(len, r->channels, r->rbuf);
> +			r->func_cb = NULL;
> +		}
> +
> +		/* Free request */
> +		r->result_pending = 0;
> +		r->active	  = 0;
> +	}
> +
> +	mutex_unlock(&madc->lock);
> +}
I think you may want to consider using a threaded irq here, see
request_threaded_irq().


> +static int twl4030_madc_set_irq(struct twl4030_madc_data *madc,
> +		struct twl4030_madc_request *req)
> +{
> +	struct twl4030_madc_request *p;
> +
> +	p = &madc->requests[req->method];
> +
> +	memcpy(p, req, sizeof *req);
> +
> +	twl4030_madc_enable_irq(madc, req->method);
> +
> +	return 0;
> +}
> +
> +static inline void twl4030_madc_start_conversion(struct twl4030_madc_data *madc,
> +		int conv_method)
> +{
> +	const struct twl4030_madc_conversion_method *method;
> +
> +	method = &twl4030_conversion_methods[conv_method];
> +
> +	switch (conv_method) {
> +	case TWL4030_MADC_SW1:
> +	case TWL4030_MADC_SW2:
> +		twl4030_madc_write(madc, method->ctrl, TWL4030_MADC_SW_START);
> +		break;
> +	case TWL4030_MADC_RT:
> +	default:
> +		break;
> +	}
> +}
> +
> +static int twl4030_madc_wait_conversion_ready(
> +		struct twl4030_madc_data *madc,
> +		unsigned int timeout_ms, u8 status_reg)
> +{
> +	unsigned long timeout;
> +
> +	timeout = jiffies + msecs_to_jiffies(timeout_ms);
> +	do {
> +		int reg;
> +
> +		reg = twl4030_madc_read(madc, status_reg);
> +		if (unlikely(reg < 0))
> +			return reg;
> +		if (!(reg & TWL4030_MADC_BUSY) && (reg & TWL4030_MADC_EOC_SW))
> +			return 0;
> +	} while (!time_after(jiffies, timeout));
> +
> +	return -EAGAIN;
> +}
> +
> +static int twl4030_madc_set_power(struct twl4030_madc_data *madc, int on);
> +int twl4030_madc_conversion(struct twl4030_madc_request *req)
> +{
> +	const struct twl4030_madc_conversion_method *method;
> +	u8 ch_msb, ch_lsb;
> +	int ret;
> +
> +	if (unlikely(!req))
> +		return -EINVAL;
> +
> +	mutex_lock(&the_madc->lock);
> +
> +	twl4030_madc_set_power(the_madc, 1);
> +
> +	/* Do we have a conversion request ongoing */
> +	if (the_madc->requests[req->method].active) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	ch_msb = (req->channels >> 8) & 0xff;
> +	ch_lsb = req->channels & 0xff;
> +
> +	method = &twl4030_conversion_methods[req->method];
> +
> +	/* Select channels to be converted */
> +	twl4030_madc_write(the_madc, method->sel + 1, ch_msb);
> +	twl4030_madc_write(the_madc, method->sel, ch_lsb);
> +
> +	/* Select averaging for all channels if do_avg is set */
> +	if (req->do_avg) {
> +		twl4030_madc_write(the_madc, method->avg + 1, ch_msb);
> +		twl4030_madc_write(the_madc, method->avg, ch_lsb);
> +	}
> +
> +	if ((req->type == TWL4030_MADC_IRQ_ONESHOT) && (req->func_cb != NULL)) {
> +		twl4030_madc_set_irq(the_madc, req);
> +		twl4030_madc_start_conversion(the_madc, req->method);
> +		the_madc->requests[req->method].active = 1;
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	/* With RT method we should not be here anymore */
> +	if (req->method == TWL4030_MADC_RT) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	twl4030_madc_start_conversion(the_madc, req->method);
> +	the_madc->requests[req->method].active = 1;
> +
> +	/* Wait until conversion is ready (ctrl register returns EOC) */
> +	ret = twl4030_madc_wait_conversion_ready(the_madc, 5, method->ctrl);
So, you're busy looping with all conversions ? I have no idea how often this
is called, but putting the caller to sleep on e.g. a waitqueue would be more
elegant.


> +	if (ret) {
> +		dev_dbg(the_madc->dev, "conversion timeout!\n");
> +		the_madc->requests[req->method].active = 0;
> +		goto out;
> +	}
> +
> +	ret = twl4030_madc_read_channels(the_madc, method->rbase, req->channels,
> +					 req->rbuf);
> +
> +	the_madc->requests[req->method].active = 0;
> +
> +	twl4030_madc_set_power(the_madc, 0);
> +
> +out:
> +	mutex_unlock(&the_madc->lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(twl4030_madc_conversion);
Who's supposed to use this one ?


> +static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc,
> +		int chan, int on)
> +{
> +	int ret;
> +	u8 regval;
> +
> +	/* Current generator is only available for ADCIN0 and ADCIN1. NB:
> +	 * ADCIN1 current generator only works when AC or VBUS is present */
> +	if (chan > 1)
> +		return EINVAL;
> +
> +	ret = twl4030_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE,
> +				  &regval, TWL4030_BCI_BCICTL1);
> +	if (ret) {
> +		dev_dbg(madc->dev, "unable to read register 0x%X\n", TWL4030_BCI_BCICTL1);
> +		return ret;
> +	}
> +
> +	if (on) {
> +		regval |= (chan) ? TWL4030_BCI_ITHEN : TWL4030_BCI_TYPEN;
> +		regval |= TWL4030_BCI_MESBAT;
> +	}
> +	else {
> +		regval &= (chan) ? ~TWL4030_BCI_ITHEN : ~TWL4030_BCI_TYPEN;
> +		regval &= ~TWL4030_BCI_MESBAT;
> +	}
> +
> +	ret = twl4030_i2c_write_u8(TWL4030_MODULE_MAIN_CHARGE,
> +				   regval, TWL4030_BCI_BCICTL1);
> +	if (ret) {
> +		dev_dbg(madc->dev, "unable to write register 0x%X\n", TWL4030_BCI_BCICTL1);
> +	}
> +	return ret;
> +}
> +
> +static int twl4030_madc_set_power(struct twl4030_madc_data *madc, int on)
> +{
> +	int ret = 0;
> +	u8 regval;
> +
> +	if (on) {
> +		regval = twl4030_madc_read(madc, TWL4030_MADC_CTRL1);
> +		regval |= TWL4030_MADC_MADCON;
> +		twl4030_madc_write(madc, TWL4030_MADC_CTRL1, regval);
> +
> +		ret |= twl4030_madc_set_current_generator(madc, 0, 1);
> +
> +	} else {
> +		ret |= twl4030_madc_set_current_generator(madc, 0, 0);
> +
> +		regval = twl4030_madc_read(madc, TWL4030_MADC_CTRL1);
> +		regval &= ~TWL4030_MADC_MADCON;
> +		twl4030_madc_write(madc, TWL4030_MADC_CTRL1, regval);
> +	}
> +	return ret;
> +}
> +
> +static long twl4030_madc_ioctl(struct file *filp, unsigned int cmd,
> +			       unsigned long arg)
> +{
> +	struct twl4030_madc_user_parms par;
> +	int val, ret;
> +
> +	ret = copy_from_user(&par, (void __user *) arg, sizeof(par));
> +	if (ret) {
> +		dev_dbg(the_madc->dev, "copy_from_user: %d\n", ret);
> +		return -EACCES;
> +	}
> +
> +	switch (cmd) {
> +	case TWL4030_MADC_IOCX_ADC_RAW_READ: {
> +		struct twl4030_madc_request req;
> +		if (par.channel >= TWL4030_MADC_MAX_CHANNELS)
> +			return -EINVAL;
> +
> +		req.channels = (1 << par.channel);
> +		req.do_avg	= par.average;
> +		req.method	= TWL4030_MADC_SW1;
> +		req.func_cb	= NULL;
> +		req.type	= TWL4030_MADC_WAIT;
> +
> +		val = twl4030_madc_conversion(&req);
> +		if (likely(val > 0)) {
> +			par.status = 0;
> +			par.result = (u16)req.rbuf[par.channel];
> +		} else if (val == 0) {
> +			par.status = -ENODATA;
> +		} else {
> +			par.status = val;
> +		}
> +		break;
> +					     }
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = copy_to_user((void __user *) arg, &par, sizeof(par));
> +	if (ret) {
> +		dev_dbg(the_madc->dev, "copy_to_user: %d\n", ret);
> +		return -EACCES;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct file_operations twl4030_madc_fileops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = twl4030_madc_ioctl
> +};
> +
> +static struct miscdevice twl4030_madc_device = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "twl4030-adc",
> +	.fops = &twl4030_madc_fileops
> +};
> +
> +static int __init twl4030_madc_probe(struct platform_device *pdev)
> +{
> +	struct twl4030_madc_data *madc;
> +	struct twl4030_madc_platform_data *pdata = pdev->dev.platform_data;
> +
> +	int ret;
> +	u8 regval;
> +
> +	madc = kzalloc(sizeof *madc, GFP_KERNEL);
> +	if (!madc)
> +		return -ENOMEM;
> +
> +	if (!pdata) {
> +		dev_dbg(&pdev->dev, "platform_data not available\n");
> +		ret = -EINVAL;
> +		goto err_pdata;
> +	}
> +
> +	madc->imr = (pdata->irq_line == 1) ? TWL4030_MADC_IMR1 : TWL4030_MADC_IMR2;
> +	madc->isr = (pdata->irq_line == 1) ? TWL4030_MADC_ISR1 : TWL4030_MADC_ISR2;
> +
> +	ret = misc_register(&twl4030_madc_device);
> +	if (ret) {
> +		dev_dbg(&pdev->dev, "could not register misc_device\n");
> +		goto err_misc;
> +	}
> +
> +	ret = request_irq(platform_get_irq(pdev, 0), twl4030_madc_irq_handler,
> +			  0, "twl4030_madc", madc);
> +	if (ret) {
> +		dev_dbg(&pdev->dev, "could not request irq\n");
> +		goto err_irq;
> +	}
> +
> +	platform_set_drvdata(pdev, madc);
> +	mutex_init(&madc->lock);
> +	INIT_WORK(&madc->ws, twl4030_madc_work);
> +
> +	the_madc = madc;
> +
> +	return 0;
> +
> +err_irq:
> +	misc_deregister(&twl4030_madc_device);
> +
> +err_misc:
> +err_pdata:
> +	kfree(madc);
> +
> +	return ret;
> +}
> +
> +static int __exit twl4030_madc_remove(struct platform_device *pdev)
> +{
> +	struct twl4030_madc_data *madc = platform_get_drvdata(pdev);
> +
> +	free_irq(platform_get_irq(pdev, 0), madc);
> +	cancel_work_sync(&madc->ws);
> +	misc_deregister(&twl4030_madc_device);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver twl4030_madc_driver = {
> +	.probe		= twl4030_madc_probe,
> +	.remove		= __exit_p(twl4030_madc_remove),
> +	.driver		= {
> +		.name	= "twl4030_madc",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init twl4030_madc_init(void)
> +{
> +	return platform_driver_register(&twl4030_madc_driver);
> +}
> +module_init(twl4030_madc_init);
> +
> +static void __exit twl4030_madc_exit(void)
> +{
> +	platform_driver_unregister(&twl4030_madc_driver);
> +}
> +module_exit(twl4030_madc_exit);
> +
> +MODULE_ALIAS("platform:twl4030-madc");
> +MODULE_AUTHOR("Nokia Corporation");
> +MODULE_DESCRIPTION("twl4030 ADC driver");
> +MODULE_LICENSE("GPL");
> +
> diff --git a/include/linux/i2c/twl4030-madc.h b/include/linux/i2c/twl4030-madc.h
> new file mode 100644
> index 0000000..24523b5
> --- /dev/null
> +++ b/include/linux/i2c/twl4030-madc.h
> @@ -0,0 +1,126 @@
> +/*
> + * include/linux/i2c/twl4030-madc.h
> + *
> + * TWL4030 MADC module driver header
> + *
> + * Copyright (C) 2008 Nokia Corporation
> + * Mikko Ylinen <mikko.k.ylinen@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#ifndef _TWL4030_MADC_H
> +#define _TWL4030_MADC_H
> +
> +struct twl4030_madc_conversion_method {
> +	u8 sel;
> +	u8 avg;
> +	u8 rbase;
> +	u8 ctrl;
> +};
> +
> +#define TWL4030_MADC_MAX_CHANNELS 16
> +
> +struct twl4030_madc_request {
> +	u16 channels;
> +	u16 do_avg;
> +	u16 method;
> +	u16 type;
> +	int active;
> +	int result_pending;
active and result_pending can be bool.

Cheers,
Samuel. 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
