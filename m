Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbXIISaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbXIISaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbXIIS3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:29:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39173 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbXIIS3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:29:53 -0400
Date: Sun, 9 Sep 2007 19:28:07 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: "Adrian McMenamin" <lkmladrian@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, linuxsh-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Maple bus support for the Sega Dreamcast
Message-ID: <20070909192807.3bc2410d@laptopd505.fenrus.org>
In-Reply-To: <8b67d60709090946y31508ffhf752414872368d8c@mail.gmail.com>
References: <8b67d60709090946y31508ffhf752414872368d8c@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007 17:46:54 +0100
"Adrian McMenamin" <lkmladrian@gmail.com> wrote:

> This patch adds support for Sega's proprietary Maple bus - which is
> required to support the Dreamcast's peripherals.

Hi,

in general the code looks clean; great job on that.
A few suggestions and comments to hopefully help this driver to become
even better:

First of all, I'm a little concerned about the lack of locking that
this driver seems to have; what guarantees the integrity of the lists
used in the driver?

Second, you have a lot of use of likely() and unlikely(); so much that I think it's waaaay overkill. The code it's in generally isn't hotpath, and gcc also does a pretty decent job without giving these hints in general.



> +
> +void maple_add_packet(struct mapleq *mq)
> +{
> +	list_add((struct list_head *) mq, &maple_waitq);
> +}

for example this list.. what makes sure that no 2 pieces of code muck with it at the same time?




> +static struct maple_device *maple_alloc_dev(int port, int unit)
> +{
> +	struct maple_device *dev;
> +
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (unlikely(!dev))
> +		return NULL;
> +
> +	dev->port = port;
> +	dev->unit = unit;
> +	dev->mq = maple_allocq(dev);
> +
> +	if (unlikely(!dev->mq)) {

this unlikely isn't needed; gcc basically assumes that NULL pointer checks are unlikely anyway...



> +
> +static int setup_maple_commands(struct device *device, void *ignored)
> +{
> +	struct maple_device *maple_dev = to_maple_dev(device);
> +
> +	if (likely(maple_dev->interval > 0)) {
> +		if (likely(jiffies > maple_dev->when)) {

this is I think a small bug; it is for sure unsafe against jiffies wrapping... please consider using the time_before() and time_after() helpers which will make this comparison safe wrt jiffies wrapping. The same is true for all other jiffies use in the driver...


> +static irqreturn_t maplebus_dma_interrupt(int irq, void *dev_id)
> +{
> +	/* Load everything into the bottom half */
> +	schedule_work(&maple_dma_process);
> +	return IRQ_HANDLED;
> +}

I wonder if you want to at least check if the work was really for you before returning IRQ_HANDLED....
