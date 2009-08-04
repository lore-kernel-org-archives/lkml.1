Return-Path: <linux-kernel-owner+w=401wt.eu-S932324AbZHDUKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbZHDUKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZHDUKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:10:34 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:35304 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbZHDUKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:10:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAA8xeEpR9dJI/2dsb2JhbADVSwmEDwU
Date: Tue, 4 Aug 2009 22:10:32 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add watchdog driver for w90p910
Message-ID: <20090804201032.GB30892@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A69CE00.10401@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wan,

I reviewed your code and have some comments and questions.

...

> +struct w90p910_wdt {
> +	struct resource  *res;
> +	struct clk	 *wdt_clock;
> +	struct platform_device *pdev;
> +	unsigned int     open_lock;
> +	unsigned int     wdt_irq;
> +	void __iomem	 *wdt_base;
> +	char		 expect_close;
> +	spinlock_t       wdt_lock;
> +};

Where is the spinlock initialized?

...

> +static irqreturn_t w90p910_wdt_irq(int irq, void *dev_id)
> +{
> +	w90p910_wdt_keepalive();
> +	return IRQ_HANDLED;
> +}

How does the interrupt work? what does the watchdog do when it times out?
(Is there a datasheet available somewhere?)

...

> +static int w90p910_wdt_settimeout(int new_time_level)
> +{
> +	unsigned int val;
> +
> +	if ((new_time_level < 0) || (new_time_level > WDT_MAX_TIME_LEVEL))
> +		return -EINVAL;
> +
> +	val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
> +	val &= ~WTIS;
> +	val |= new_time_level;

Shouldn't this be val |= (new_time_level << 0x04); ?
The read-write cyclus to REG_WTCR should also be guarded with a spinlock.
Can you incorporate the call to w90p910_wdt_start() in the ioctl code into this function?

...

> +static ssize_t w90p910_wdt_write(struct file *file, const char *data,
> +						size_t len, loff_t *ppos)

should be: ..., const char __user *data, ...

...

> +static int __devinit w90p910wdt_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	w90p910_wdt = kzalloc(sizeof(struct w90p910_wdt), GFP_KERNEL);
> +	if (!w90p910_wdt)
> +		return -ENOMEM;
> +
> +	w90p910_wdt->pdev = pdev;
> +
> +	w90p910_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (w90p910_wdt->res == NULL) {
> +		dev_err(&pdev->dev, "no memory resource specified\n");
> +		ret = -ENOENT;
> +		goto err_get;
> +	}
> +
> +	if (!request_mem_region(w90p910_wdt->res->start,
> +				resource_size(w90p910_wdt->res), pdev->name)) {
> +		dev_err(&pdev->dev, "failed to get memory region\n");
> +		ret = -ENOENT;
> +		goto err_req;

This should be: goto err_get;

...

> +
> +static int __devexit w90p910wdt_remove(struct platform_device *pdev)
> +{

The misc_deregister(&w90p910wdt_miscdev); should go first. We don't want userspace interactivity when we clean up all reservations.

> +	free_irq(w90p910_wdt->wdt_irq, NULL);
> +
> +	clk_disable(w90p910_wdt->wdt_clock);
> +	clk_put(w90p910_wdt->wdt_clock);
> +
> +	iounmap(w90p910_wdt->wdt_base);
> +
> +	release_mem_region(w90p910_wdt->res->start,
> +					resource_size(w90p910_wdt->res));
> +
> +	kfree(w90p910_wdt);
> +
> +	misc_deregister(&w90p910wdt_miscdev);

see comment about misc_deregister above.

For the rest the code looks good to me.

Kind regards,
Wim.

