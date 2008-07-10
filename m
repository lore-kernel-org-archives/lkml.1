Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbYGJSSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbYGJSSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYGJSSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:18:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:61316 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYGJSSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=eCqXz5cIh2SbrTuBQ34x02JN1sJwivyP6rPX7yX4lX6R5zk7892LOkaapLgivGfo9Y
         X3+zRKSPA0X+K65G8k830dO7vgNxcWrIUwIdbWEAYHS9FUI3YCyJgYy4sTPh7aCN3XQ9
         O2+JRvltBdFWteMZEpn9bb/4oKfvGJBNQxa+8=
Message-ID: <487651CA.6030405@gmail.com>
Date: Thu, 10 Jul 2008 20:15:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mchehab@infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
References: <200807101914.10174.mb@bu3sch.de>
In-Reply-To: <200807101914.10174.mb@bu3sch.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<Moved from the bottom>
+A·generic·digital·24-port·PCI·GPIO·card·can·be·built·out·of·an·ordinary
+Brooktree·bt848,·bt849,·bt878·or·bt879·based·analog·TV·tuner·card.·The
+Brooktree·chip·is·used·in·old·analog·Hauppauge·WinTV·PCI·cards.·You·can·easily
+find·them·used·for·low·prices·on·the·net.

Thanks for that!

On 07/10/2008 07:14 PM, Michael Buesch wrote:
> Index: linux-next/drivers/gpio/bt8xxgpio.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-next/drivers/gpio/bt8xxgpio.c	2008-07-10 19:05:56.000000000 +0200
> @@ -0,0 +1,348 @@
[...]
> +static int bt8xxgpio_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
> +{
> +	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
> +	unsigned long flags;
> +	u32 outen, data;
> +
> +	spin_lock_irqsave(&bg->lock, flags);

Why all those irq variants? I can't see interrupts anywhere. May gpio call this 
from irq?

> +
> +	data = bgread(BT848_GPIO_DATA);
> +	data &= ~(1 << nr);
> +	bgwrite(data, BT848_GPIO_DATA);
> +
> +	outen = bgread(BT848_GPIO_OUT_EN);
> +	outen &= ~(1 << nr);
> +	bgwrite(outen, BT848_GPIO_OUT_EN);

some flushing of posted values here?

> +	spin_unlock_irqrestore(&bg->lock, flags);
> +
> +	return 0;
> +}
[...]
> +static int bt8xxgpio_gpio_direction_output(struct gpio_chip *gpio,
> +					unsigned nr, int val)
> +{
> +	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
> +	unsigned long flags;
> +	u32 outen, data;
> +
> +	spin_lock_irqsave(&bg->lock, flags);
> +
> +	outen = bgread(BT848_GPIO_OUT_EN);
> +	outen |= (1 << nr);
> +	bgwrite(outen, BT848_GPIO_OUT_EN);
> +
> +	data = bgread(BT848_GPIO_DATA);
> +	if (val)
> +		data |= (1 << nr);
> +	else
> +		data &= ~(1 << nr);
> +	bgwrite(data, BT848_GPIO_DATA);

and here

> +
> +	spin_unlock_irqrestore(&bg->lock, flags);
> +
> +	return 0;
> +}
> +
> +static void bt8xxgpio_gpio_set(struct gpio_chip *gpio,
> +			    unsigned nr, int val)
> +{
> +	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
> +	unsigned long flags;
> +	u32 data;
> +
> +	spin_lock_irqsave(&bg->lock, flags);
> +
> +	data = bgread(BT848_GPIO_DATA);
> +	if (val)
> +		data |= (1 << nr);
> +	else
> +		data &= ~(1 << nr);
> +	bgwrite(data, BT848_GPIO_DATA);

and here and further in the code

> +	spin_unlock_irqrestore(&bg->lock, flags);
> +}
[...]
> +static int bt8xxgpio_probe(struct pci_dev *dev,
> +			const struct pci_device_id *pci_id)
> +{
> +	struct bt8xxgpio *bg;
> +	int err;
> +
> +	bg = kzalloc(sizeof(*bg), GFP_KERNEL);
> +	if (!bg)
> +		return -ENOMEM;
> +
> +	bg->pdev = dev;
> +	spin_lock_init(&bg->lock);
> +
> +	err = pci_enable_device(dev);
> +	if (err) {
> +		printk(KERN_ERR "bt8xxgpio: Can't enable device.\n");

dev_err() et al. all over here.

> +		goto err_freebg;
> +	}
> +	if (!request_mem_region(pci_resource_start(dev, 0),
> +				pci_resource_len(dev, 0),
> +				"bt8xxgpio")) {

pci_request_region();?

> +		printk(KERN_WARNING
> +		       "bt8xxgpio: Can't request iomem (0x%llx).\n",
> +		       (unsigned long long)pci_resource_start(dev, 0));

You don't need to print the value out, we can see it in lspci.

> +		err = -EBUSY;
> +		goto err_disable;
> +	}
> +	pci_set_master(dev);
> +	pci_set_drvdata(dev, bg);
> +
> +	bg->mmio = ioremap(pci_resource_start(dev, 0), 0x1000);
> +	if (!bg->mmio) {
> +		printk(KERN_ERR "bt8xxgpio: ioremap() failed\n");
> +		err = -EIO;
> +		goto err_release_mem;
> +	}
[...]
> +static int bt8xxgpio_resume(struct pci_dev *pdev)
> +{
> +	struct bt8xxgpio *bg = pci_get_drvdata(pdev);
> +	unsigned long flags;
> +	int err;
> +
> +	pci_set_power_state(pdev, 0);

No need to set that state again (PCI layer cares).

> +	err = pci_enable_device(pdev);
> +	if (err)
> +		return err;
> +	pci_restore_state(pdev);
> +
> +	spin_lock_irqsave(&bg->lock, flags);
[...]
> +static int bt8xxgpio_init(void)

__init

> +{
> +	return pci_register_driver(&bt8xxgpio_pci_driver);
> +}
> +module_init(bt8xxgpio_init)
> +
> +static void bt8xxgpio_exit(void)

__exit

> +{
> +	pci_unregister_driver(&bt8xxgpio_pci_driver);
> +}
> +module_exit(bt8xxgpio_exit)

