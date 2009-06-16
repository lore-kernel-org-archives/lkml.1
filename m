Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZFPIpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZFPIpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZFPIp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:45:26 -0400
Received: from trinity.fluff.org ([89.16.178.74]:39427 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbZFPIpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:45:24 -0400
Date: Tue, 16 Jun 2009 09:45:24 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Alek Du <alek.du@intel.com>
Cc: Florian Fainelli <florian@openwrt.org>, Ben Dooks <ben-linux@fluff.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and gpio_alt_func features to GPIOLIB
Message-ID: <20090616084524.GC14476@trinity.fluff.org>
References: <20090615171502.2a981bf5@dxy.sh.intel.com> <20090615125146.GC19873@fluff.org.uk> <200906151504.51934.florian@openwrt.org> <20090616092121.3ed42b63@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090616092121.3ed42b63@dxy.sh.intel.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 09:21:21AM +0800, Alek Du wrote:
> On Mon, 15 Jun 2009 21:04:50 +0800
> Florian Fainelli <florian@openwrt.org> wrote:
> 
> > Le Monday 15 June 2009 14:51:46 Ben Dooks, vous avez écrit :
> > > On Mon, Jun 15, 2009 at 05:15:02PM +0800, Alek Du wrote:
> > > > >From 7a76916ccea4a376a260ea67fbc79ac4d958757f Mon Sep 17 00:00:00 2001
> > > >
> > > > From: Alek Du <alek.du@intel.com>
> > > > Date: Fri, 8 May 2009 09:46:49 +0800
> > > > Subject: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
> > > > gpio_alt_func features to GPIOLIB
> > > >
> > > > Add some more functions to GPIOLIB, they are:
> > > > * gpio_detect is to set GPIO interrupt triggering method (edge, level,
> > > > high, low, etc.)
> > 
> > The name does not seem to reflect what it does, what about gpio_set_type or 
> > gpio_set_int_type for instance ?
> > 
> > >
> > > This is the wrong way of doing it, there is as a definit set_type
> > > method in the irq_chip structure which should be used to alter the
> > > way the IRQ is triggered.
> > 
> > I would expect your architecture IRQ handler to have a set_type callback for 
> > the GPIO lines capables of generating an interrupt. See how we have beeing 
> > doing it for rb532 for instance: 
> > http://www.linux-mips.org/git?p=linux-queue.git;a=blob;f=arch/mips/rb532/irq.c;h=f07882029a90d3d155c17b462812c2936229458c;hb=HEAD#l173
> 
> 
> For you case, in set_type handler it calls a "rb532_gpio_set_ilevel", my purpose of the gpio_detect is to provide the general way to replace 
> the private function like "rb532_gpio_set_ilevel". Suppose you have several type GPIO devices in the system, in you way, you have to export
> different private function to set each GPIO device triggering mode. Also for some system, we have i2c or SPI GPIO expander, we need to hook
> them on the fly. The gpio_detect API provide a general way to set triggering mode, you could call it under set_type callback.

Somehow you are still missing my point, this is the way it can be done
at the moment, without any extension to the API!

int attach_my_gpio_irq(int gpio, void *irqpw)
{
	int ret;
	int irq;

	irq = gpio_to_irq(gpio);
	if (irq < 0) {
		printk(KERN_ERR "%s: no gpio irq available\n", __func__);
		return irq;
	}

	ret = request_irq(irq, my_irq_handler, IRQF_TRIGGER_FALLING,
			  "mygpio", irqpw);
	if (ret < 0) 
		printk(KERN_ERR "%s: cannot request irq\n", __func__);

	return ret;
}

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

