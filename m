Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZFPI6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZFPI6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZFPI5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:57:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:16494 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053AbZFPI5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:57:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,227,1243839600"; 
   d="scan'208";a="699768511"
Date: Tue, 16 Jun 2009 16:51:35 +0800
From: Alek Du <alek.du@intel.com>
To: Ben Dooks <ben-linux@fluff.org>
CC: Florian Fainelli <florian@openwrt.org>, Ben Dooks <ben-linux@fluff.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
 gpio_alt_func features to GPIOLIB
Message-ID: <20090616165135.2ef993a4@dxy.sh.intel.com>
In-Reply-To: <20090616084524.GC14476@trinity.fluff.org>
References: <20090615171502.2a981bf5@dxy.sh.intel.com>
	<20090615125146.GC19873@fluff.org.uk>
	<200906151504.51934.florian@openwrt.org>
	<20090616092121.3ed42b63@dxy.sh.intel.com>
	<20090616084524.GC14476@trinity.fluff.org>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 16:45:24 +0800
Ben Dooks <ben-linux@fluff.org> wrote:

under set_type callback.
> 
> Somehow you are still missing my point, this is the way it can be done
> at the moment, without any extension to the API!
> 
> int attach_my_gpio_irq(int gpio, void *irqpw)
> {
> 	int ret;
> 	int irq;
> 
> 	irq = gpio_to_irq(gpio);
> 	if (irq < 0) {
> 		printk(KERN_ERR "%s: no gpio irq available\n", __func__);
> 		return irq;
> 	}
> 
> 	ret = request_irq(irq, my_irq_handler, IRQF_TRIGGER_FALLING,
> 			  "mygpio", irqpw);
> 	if (ret < 0) 
> 		printk(KERN_ERR "%s: cannot request irq\n", __func__);
> 
> 	return ret;
> }
> 
I mean, in the set_type of the irq_chip driver, you need to call something like rb532_gpio_set_ilevel.
The GPIO driver needs to export rb532_gpio_set_ilevel, and this is specific to each GPIO driver. Ideally,
I should always call gpio_detect(gpio, ...) here.

static int rb532_set_type(unsigned int irq_nr, unsigned type)
{
	int gpio = irq_nr - GPIO_MAPPED_IRQ_BASE;
	int group = irq_to_group(irq_nr);

	if (group != GPIO_MAPPED_IRQ_GROUP || irq_nr > (GROUP4_IRQ_BASE + 13))
		return (type == IRQ_TYPE_LEVEL_HIGH) ? 0 : -EINVAL;

	switch (type) {
	case IRQ_TYPE_LEVEL_HIGH:
		rb532_gpio_set_ilevel(1, gpio);
		break;
	case IRQ_TYPE_LEVEL_LOW:
		rb532_gpio_set_ilevel(0, gpio);
		break;
	default:
		return -EINVAL;
	}
	return 0;
}




