Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbXDZAv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbXDZAv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbXDZAv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:51:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688AbXDZAvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:51:54 -0400
Date: Wed, 25 Apr 2007 17:46:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Matt Reimer <mreimer@vpop.net>, linux-kernel@vger.kernel.org
Subject: Re: [2/2] Driver for the Maxim DS1WM, a 1-wire bus master ASIC
 core.
Message-Id: <20070425174643.f1fc189d.akpm@linux-foundation.org>
In-Reply-To: <20070424100203.GB16473@2ka.mipt.ru>
References: <20070424100203.GB16473@2ka.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 14:02:03 +0400 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> +#define DS1WM_CMD_1W_RESET  1 << 0	/* force reset on 1-wire bus */
> +#define DS1WM_CMD_SRA	    1 << 1	/* enable Search ROM accelerator mode */
> +#define DS1WM_CMD_DQ_OUTPUT 1 << 2	/* write only - forces bus low */
> +#define DS1WM_CMD_DQ_INPUT  1 << 3	/* read only - reflects state of bus */
> +
> +#define DS1WM_INT_PD	    1 << 0	/* presence detect */
> +#define DS1WM_INT_PDR	    1 << 1	/* presence detect result */
> +#define DS1WM_INT_TBE	    1 << 2	/* tx buffer empty */
> +#define DS1WM_INT_TSRE	    1 << 3	/* tx shift register empty */
> +#define DS1WM_INT_RBF	    1 << 4	/* rx buffer full */
> +#define DS1WM_INT_RSRF	    1 << 5	/* rx shift register full */
> +
> +#define DS1WM_INTEN_EPD	    1 << 0	/* enable presence detect int */
> +#define DS1WM_INTEN_IAS	    1 << 1	/* INTR active state */
> +#define DS1WM_INTEN_ETBE    1 << 2	/* enable tx buffer empty int */
> +#define DS1WM_INTEN_ETMT    1 << 3	/* enable tx shift register empty int */
> +#define DS1WM_INTEN_ERBF    1 << 4	/* enable rx buffer full int */
> +#define DS1WM_INTEN_ERSRF   1 << 5	/* enable rx shift register full int */
> +#define DS1WM_INTEN_DQO	    1 << 6	/* enable direct bus driving ops
> +					   (undocumented), Szabolcs Gyurko */

These macros are very dangerous - please parenthesise them all.

> +
> +struct ds1wm_data {
> +	void		*map;
> +	int		bus_shift; /* # of shifts to calc register offsets */
> +	struct platform_device *pdev;
> +	struct ds1wm_platform_data *pdata;
> +	int		irq;
> +	struct clk	*clk;
> +	int		slave_present;
> +	void		*reset_complete;
> +	void		*read_complete;
> +	void		*write_complete;
> +	u8		read_byte; /* last byte received */
> +};
> +
> +static inline void ds1wm_write_register(struct ds1wm_data *ds1wm_data, u32 reg,
> +					u8 val)
> +{
> +        __raw_writeb(val, ds1wm_data->map + (reg << ds1wm_data->bus_shift));
> +}
> +
> +static inline u8 ds1wm_read_register(struct ds1wm_data *ds1wm_data, u32 reg)
> +{
> +        return __raw_readb(ds1wm_data->map + (reg << ds1wm_data->bus_shift));
> +}
> +
> +
> +static irqreturn_t ds1wm_isr(int isr, void *data)
> +{
> +	struct ds1wm_data *ds1wm_data = data;
> +	u8 intr = ds1wm_read_register(ds1wm_data, DS1WM_INT);
> +
> +	ds1wm_data->slave_present = intr & DS1WM_INT_PDR ? 0 : 1;

Normally we'd parenthesise an expression like this so people don't have to
go scrambling for the C precedence table.


> +	if (intr & DS1WM_INT_PD && ds1wm_data->reset_complete)
> +		complete(ds1wm_data->reset_complete);

Ditto (lots of instances of this in this patch)

> +	if (intr & DS1WM_INT_RBF) {
> +		ds1wm_data->read_byte = ds1wm_read_register(ds1wm_data,
> +							    DS1WM_DATA);
> +		if (ds1wm_data->read_complete)
> +			complete(ds1wm_data->read_complete);
> +	}
> +
> +	if (intr & DS1WM_INT_TSRE && ds1wm_data->write_complete)
> +		complete(ds1wm_data->write_complete);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
> +{
> +	unsigned long timeleft;
> +	DECLARE_COMPLETION(reset_done);

This will cause lockdep warnings.

- Convert to DECLARE_COMPLETION_ONSTACK

- Test the code using lockdep!  This is covered in
  Documentation/SubmitChecklist, which has many other useful tips.

> +	ds1wm_data->reset_complete = &reset_done;
> +
> +	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN, DS1WM_INTEN_EPD |
> +		(ds1wm_data->pdata->active_high ? DS1WM_INTEN_IAS : 0));
> +
> +	ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_1W_RESET);
> +
> +	timeleft = wait_for_completion_timeout(&reset_done, DS1WM_TIMEOUT);
> +	ds1wm_data->reset_complete = NULL;
> +	if (!timeleft) {
> +                dev_dbg(&ds1wm_data->pdev->dev, "reset failed\n");
> +                return 1;
> +	}
> +
> +	/* Wait for the end of the reset. According to the specs, the time
> +	 * from when the interrupt is asserted to the end of the reset is:
> +	 *     tRSTH  - tPDH  - tPDL - tPDI
> +	 *     625 us - 60 us - 240 us - 100 ns = 324.9 us
> +	 *
> +	 * We'll wait a bit longer just to be sure.
> +	 */
> +	udelay(500);
> +
> +	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
> +		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
> +		(ds1wm_data->pdata->active_high ? DS1WM_INTEN_IAS : 0));
> +
> +	if (!ds1wm_data->slave_present) {
> +                dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
> +                return 1;
> +        }

whitespace broke here.

> +        return 0;
> +}
> +
> +static int ds1wm_write(struct ds1wm_data *ds1wm_data, u8 data)
> +{
> +	DECLARE_COMPLETION(write_done);

Multiple instances of this.

> +	ds1wm_data->write_complete = &write_done;
> +
> +	ds1wm_write_register(ds1wm_data, DS1WM_DATA, data);
> +
> +	wait_for_completion_timeout(&write_done, DS1WM_TIMEOUT);
> +	ds1wm_data->write_complete = NULL;
> +
> +	return 0;
> +}
> +
> +static int ds1wm_read(struct ds1wm_data *ds1wm_data, unsigned char write_data)
> +{
> +	DECLARE_COMPLETION(read_done);
> +	ds1wm_data->read_complete = &read_done;
> +
> +	ds1wm_write(ds1wm_data, write_data);
> +	wait_for_completion_timeout(&read_done, DS1WM_TIMEOUT);
> +	ds1wm_data->read_complete = NULL;
> +
> +	return ds1wm_data->read_byte;
> +}
> +
> +static int ds1wm_find_divisor(int gclk)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE (freq); i++)

No space after the ARRAY_SIZE

> +		if (gclk <= freq[i].freq)
> +			return freq[i].divisor;
> +
> +	return 0;
> +}
> +
> +static void ds1wm_up(struct ds1wm_data *ds1wm_data)
> +{
> +	int gclk, divisor;
> +	
> +	if (ds1wm_data->pdata->enable)
> +		ds1wm_data->pdata->enable(ds1wm_data->pdev);
> +
> +	gclk = clk_get_rate(ds1wm_data->clk);
> +	clk_enable(ds1wm_data->clk);
> +	divisor = ds1wm_find_divisor(gclk);
> +	if (divisor == 0) {
> +		dev_err(&ds1wm_data->pdev->dev,
> +			"no suitable divisor for %dHz clock\n", gclk);
> +		return;
> +	}
> +	ds1wm_write_register(ds1wm_data, DS1WM_CLKDIV, divisor);
> +
> +	/* Let the w1 clock stabilize. */
> +	msleep(1);
> +
> +	enable_irq(ds1wm_data->irq);
> +}
> +
> +static void ds1wm_down(struct ds1wm_data *ds1wm_data)
> +{
> +	disable_irq(ds1wm_data->irq);
> +	if (ds1wm_data->pdata->disable)
> +		ds1wm_data->pdata->disable(ds1wm_data->pdev);
> +
> +	clk_disable(ds1wm_data->clk);
> +}

eh?  What happens if that IRQ is shared with another device?

Isn't there some chip register which can be written to to disable the
device's interrupts?


> +static struct w1_bus_master ds1wm_master = {
> +	.read_byte  = ds1wm_read_byte,
> +	.write_byte = ds1wm_write_byte,
> +	.reset_bus  = ds1wm_reset_bus,
> +	.search	    = ds1wm_search,
> +};
> +
> +static int ds1wm_probe(struct platform_device *pdev)
> +{
> +	struct ds1wm_data *ds1wm_data;
> +	struct ds1wm_platform_data *plat;
> +	struct resource *res;
> +	int ret;
> +
> +	if (!pdev)
> +		return -ENODEV;
> +
> +	ds1wm_data = kzalloc(sizeof (*ds1wm_data), GFP_KERNEL);
> +	if (!ds1wm_data)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, ds1wm_data);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		ret = -ENXIO;
> +		goto err0;
> +	}
> +	ds1wm_data->map = ioremap(res->start, res->end - res->start + 1);
> +	if (!ds1wm_data->map) {
> +		ret = -ENOMEM;
> +		goto err0;
> +	}
> +	plat = pdev->dev.platform_data;
> +	ds1wm_data->bus_shift = plat->bus_shift;
> +	ds1wm_data->pdev = pdev;
> +	ds1wm_data->pdata = plat;
> +
> +	ds1wm_data->irq = platform_get_irq(pdev, 0);
> +	if (ds1wm_data->irq < 0) {
> +		ret = -ENXIO;
> +		goto err1;
> +	}
> +	
> +	if (plat->falling_edge)
> +		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
> +	else
> +		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
> +
> +	ret = request_irq(ds1wm_data->irq, ds1wm_isr,
> +			  IRQF_DISABLED | IRQF_SAMPLE_RANDOM, "ds1wm",
> +			  ds1wm_data);

Is w1 really a suitable source of entropy?

> +	if (ret)
> +		goto err1;
> +	disable_irq(ds1wm_data->irq);
> +
> +	ds1wm_data->clk = clk_get(&pdev->dev, "ds1wm");
> +	if (!ds1wm_data->clk) {
> +		ret = -ENOENT;
> +		goto err2;
> +	}
> +
> +	ds1wm_up(ds1wm_data);
> +
> +	ds1wm_master.data = (void *)ds1wm_data;
> +
> +	ret = w1_add_master_device(&ds1wm_master);
> +	if (ret)
> +		goto err3;
> +
> +	return 0;
> +
> +err3:
> +	ds1wm_reset(ds1wm_data);
> +	ds1wm_down(ds1wm_data);
> +	clk_put(ds1wm_data->clk);
> +err2:
> +	free_irq(ds1wm_data->irq, ds1wm_data);
> +err1:
> +	iounmap(ds1wm_data->map);
> +err0:
> +	kfree(ds1wm_data);
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_PM
> +static int ds1wm_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct ds1wm_data *ds1wm_data = platform_get_drvdata(pdev);
> +
> +	ds1wm_down(ds1wm_data);
> +
> +	return 0;
> +}
> +
> +static int ds1wm_resume(struct platform_device *pdev)
> +{
> +	struct ds1wm_data *ds1wm_data = platform_get_drvdata(pdev);
> +
> +	ds1wm_up(ds1wm_data);
> +
> +	return 0;
> +}
> +#endif

Here, please do

#else
#define ds1wm_suspend NULL
#define ds1wm_resume NULL
#endif

> +static int ds1wm_remove(struct platform_device *pdev)
> +{
> +	struct ds1wm_data *ds1wm_data = platform_get_drvdata(pdev);
> +
> +	w1_remove_master_device(&ds1wm_master);
> +	ds1wm_reset(ds1wm_data);
> +	ds1wm_down(ds1wm_data);
> +	clk_put(ds1wm_data->clk);
> +	free_irq(ds1wm_data->irq, ds1wm_data);
> +	iounmap(ds1wm_data->map);
> +	kfree(ds1wm_data);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver ds1wm_driver = {
> +	.driver   = {
> +		.name = "ds1wm",
> +	},
> +	.probe    = ds1wm_probe,
> +	.remove   = ds1wm_remove,
> +#ifdef CONFIG_PM
> +	.suspend  = ds1wm_suspend,
> +	.resume   = ds1wm_resume
> +#endif

then remove these ifdefs.

> +};
> +
> +static int ds1wm_init(void)
> +{
> +	printk("DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko\n");
> +	return platform_driver_register(&ds1wm_driver);
> +}

__init

> +static void ds1wm_exit(void)
> +{
> +	platform_driver_unregister(&ds1wm_driver);
> +}

__exit

> +module_init(ds1wm_init);
> +module_exit(ds1wm_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>, "
> +	      "Matt Reimer <mreimer@vpop.net>");
> +MODULE_DESCRIPTION("DS1WM w1 busmaster driver");
> diff --git a/include/linux/ds1wm.h b/include/linux/ds1wm.h
> new file mode 100644
> index 0000000..72d92ee
> --- /dev/null
> +++ b/include/linux/ds1wm.h
> @@ -0,0 +1,13 @@
> +/* platform data for the DS1WM driver */
> +
> +struct ds1wm_platform_data {
> +	int bus_shift;	    /* number of shifts needed to calculate the
> +			     * offset between DS1WM registers;
> +			     * e.g. on h5xxx and h2200 this is 2
> +			     * (registers aligned to 4-byte boundaries),
> +			     * while on hx4700 this is 1 */
> +	int falling_edge;   /* interrupt edge - passed to set_irq_type() */
> +	int active_high;    /* interrupt polarity, passed to DS1WM as IAS bit */
> +	void (*enable)(struct platform_device *pdev);
> +	void (*disable)(struct platform_device *pdev);
> +};

