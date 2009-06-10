Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbZFJHqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbZFJHqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 03:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZFJHqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 03:46:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbZFJHqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 03:46:06 -0400
Date: Wed, 10 Jun 2009 00:44:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux@arm.linux.org.uk
Subject: Re: [PATCH v4] gpio: driver for PrimeCell PL061 GPIO controller
Message-Id: <20090610004447.78b84cd5.akpm@linux-foundation.org>
In-Reply-To: <20090610072229.GC10382@tarshish>
References: <1244399935-23128-1-git-send-email-baruch@tkos.co.il>
	<20090609140239.260428eb.akpm@linux-foundation.org>
	<20090610072229.GC10382@tarshish>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 10:22:31 +0300 Baruch Siach <baruch@tkos.co.il> wrote:

> Hi Andrew,
> 
> > >  static unsigned int pl061_irq_startup(unsigned irq)
> > >  {
> > > -	int ret;
> > > -
> > > -	ret = gpio_request(irq_to_gpio(irq), "IRQ");
> > > -	if (ret < 0) {
> > > -		pr_warning("%s: warning: gpio_request(%d) returned %d\n",
> > > -				__func__, irq_to_gpio(irq), ret);
> > > -		return 0;
> > > -	}
> > > +	if (gpio_request(irq_to_gpio(irq), "IRQ") == 0)
> > > +		pr_warning("%s: warning: GPIO%d has not been requested\n",
> > > +				__func__, irq_to_gpio(irq));
> > 
> > This is wrong, isn't it?  gpio_request() returns 0 on success.
> 
> Russell said that gpio configuration is the responsibility of the platform 
> code. Here I just warn when the gpio has not been requested, and thus 
> gpio_request() succeeds. I'll add a comment.

OK.

If the gpio_request() accidentally succeeded, should we gpio_free() the
result here?

Should the gpio core provide a primitive to check that a gpio has been
properly requested rathe rthan open-coding it here?

> > >  static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
> > >  {
> > > +	struct list_head *chip_list = get_irq_chip_data(irq);
> > > +	struct list_head *ptr;
> > > +	struct pl061_gpio *chip;
> > > +
> > >  	desc->chip->ack(irq);
> > > -	while (1) {
> > > +	list_for_each(ptr, chip_list) {
> > 
> > What locking protects the newly-added list?
> 
> Do we need locking even though we list_add() only at probe time?

Nope.  I guess.  It depends on the driver.  hotplug/hot-remove needs to
beconsidered often.

> (Compiling as 
> a module is not supported, so this only happens at boot time).

The probe handler is probably serialised against everything else even if
the driver _is_ a module.

