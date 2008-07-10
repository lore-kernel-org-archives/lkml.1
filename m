Return-Path: <linux-kernel-owner+w=401wt.eu-S1762973AbYGJStp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762973AbYGJStp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbYGJSp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:45:29 -0400
Received: from bu3sch.de ([62.75.166.246]:47763 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759441AbYGJSp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:45:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
Date: Thu, 10 Jul 2008 20:44:21 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mchehab@infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Brownell <david-b@pacbell.net>
References: <200807101914.10174.mb@bu3sch.de> <487651CA.6030405@gmail.com>
In-Reply-To: <487651CA.6030405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807102044.21712.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008 20:15:38 Jiri Slaby wrote:
> > +static int bt8xxgpio_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
> > +{
> > +	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
> > +	unsigned long flags;
> > +	u32 outen, data;
> > +
> > +	spin_lock_irqsave(&bg->lock, flags);
> 
> Why all those irq variants? I can't see interrupts anywhere. May gpio call this 
> from irq?

Yes. Call context is undefined.

> > +
> > +	data = bgread(BT848_GPIO_DATA);
> > +	data &= ~(1 << nr);
> > +	bgwrite(data, BT848_GPIO_DATA);
> > +
> > +	outen = bgread(BT848_GPIO_OUT_EN);
> > +	outen &= ~(1 << nr);
> > +	bgwrite(outen, BT848_GPIO_OUT_EN);
> 
> some flushing of posted values here?


> > +static void bt8xxgpio_gpio_set(struct gpio_chip *gpio,
> > +			    unsigned nr, int val)
> > +{
> > +	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
> > +	unsigned long flags;
> > +	u32 data;
> > +
> > +	spin_lock_irqsave(&bg->lock, flags);
> > +
> > +	data = bgread(BT848_GPIO_DATA);
> > +	if (val)
> > +		data |= (1 << nr);
> > +	else
> > +		data &= ~(1 << nr);
> > +	bgwrite(data, BT848_GPIO_DATA);
> 
> and here and further in the code

Well, I'm not sure. This is pretty damn hotpath code. It can be used
for bitbanging busdata, for example. I do actually consider optimizing
that bgread() in the function above away, by caching it in memory.
(First need to do measurements on whether it improves stuff).

So well. What about flushing. In theory it might be needed on some
hardware. But unless somebody can show me some hardware, where this
actually breaks without flushing, I won't consider adding flushes
for performance reasons.

However, an mmiowb() might be added here right before the
spinlock to make the locking safe.

> > +	spin_unlock_irqrestore(&bg->lock, flags);
> > +}
> [...]
> > +static int bt8xxgpio_probe(struct pci_dev *dev,
> > +			const struct pci_device_id *pci_id)
> > +{
> > +	struct bt8xxgpio *bg;
> > +	int err;
> > +
> > +	bg = kzalloc(sizeof(*bg), GFP_KERNEL);
> > +	if (!bg)
> > +		return -ENOMEM;
> > +
> > +	bg->pdev = dev;
> > +	spin_lock_init(&bg->lock);
> > +
> > +	err = pci_enable_device(dev);
> > +	if (err) {
> > +		printk(KERN_ERR "bt8xxgpio: Can't enable device.\n");
> 
> dev_err() et al. all over here.
> 
> > +		goto err_freebg;
> > +	}
> > +	if (!request_mem_region(pci_resource_start(dev, 0),
> > +				pci_resource_len(dev, 0),
> > +				"bt8xxgpio")) {
> 
> pci_request_region();?

Hell, I shouldn't have derived this from the bttv driver. Almost all
style comments origin from that. ;)

> > +		printk(KERN_WARNING
> > +		       "bt8xxgpio: Can't request iomem (0x%llx).\n",
> > +		       (unsigned long long)pci_resource_start(dev, 0));
> 
> You don't need to print the value out, we can see it in lspci.

Also from bttv...

-- 
Greetings Michael.
