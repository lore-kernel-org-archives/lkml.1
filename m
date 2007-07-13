Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbXGMCWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbXGMCWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 22:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbXGMCWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 22:22:38 -0400
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:34630 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755545AbXGMCWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 22:22:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KGC4hCJdk4e6wTMdgcphk9duqXpUQT8EBcNr1h9b5cUebGb8wE8cXNx+JtdBbMIhfwEX6WPaFv+9RIwcPSAz8lfn7Tnlh1dtOsvUDyxLo45VnIZPkxK+IlqRjtZZpW3vmz4ME7Bh7NiFr037LxoSsM4GXsMPV+YIAYTTed+mshc=  ;
X-YMail-OSG: iK_1mSwVM1ksITS1P_5gunM_ouRucz0XmmFzEJY8VJKmmIzFgS61aWGv8ycq0Mj98kRf1De9oA--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: OMAP: Add TI TWL92330/Menelaus Power Management chip driver
Date: Thu, 12 Jul 2007 19:22:33 -0700
User-Agent: KMail/1.9.6
Cc: "Trilok Soni" <soni.trilok@gmail.com>, i2c@lm-sensors.org,
       "Jean Delvare" <khali@linux-fr.org>, "Tony Lindgren" <tony@atomide.com>,
       drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org,
       amit.kucheria@gmail.com
References: <5d5443650707092353v153fe90clbd1a42d465ed79a4@mail.gmail.com> <20070712170844.a367b8c9.akpm@linux-foundation.org>
In-Reply-To: <20070712170844.a367b8c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121922.34324.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007, Andrew Morton wrote:
> On Tue, 10 Jul 2007 12:23:06 +0530
> "Trilok Soni" <soni.trilok@gmail.com> wrote:

> > +	u8			mask1, mask2;
> > +	void			(*handlers[16])(struct menelaus_chip *);
> 
> What determined the value of this hard-wired 16?

Two 8-bit registers for IRQ status, so total of 16 potential handlers.
Of course, I think several of those bits aren't actually used.


> > +/* Handles Menelaus interrupts. Does not run in interrupt context */
> > +static void menelaus_work(struct work_struct *_menelaus)
> > +{
> > +	struct menelaus_chip *menelaus =
> > +			container_of(_menelaus, struct menelaus_chip, work);
> > +	void (*handler)(struct menelaus_chip *menelaus);
> > +
> > +	while (1) {
> > +		unsigned isr;
> > +
> > +		isr = (menelaus_read_reg(MENELAUS_INT_STATUS2)
> > +				& ~menelaus->mask2) << 8;
> > +		isr |= menelaus_read_reg(MENELAUS_INT_STATUS1)
> > +				& ~menelaus->mask1;
> > +		if (!isr)
> > +			break;
> > +
> > +		while (isr) {
> > +			int irq = fls(isr) - 1;
> > +			isr &= ~(1 << irq);
> > +
> > +			mutex_lock(&menelaus->lock);
> > +			menelaus_disable_irq(irq);
> > +			menelaus_ack_irq(irq);
> > +			handler = menelaus->handlers[irq];
> > +			if (handler)
> > +				handler(menelaus);
> > +			menelaus_enable_irq(irq);
> > +			mutex_unlock(&menelaus->lock);
> > +		}
> > +	}
> > +	enable_irq(menelaus->client->irq);
> 
> This can do an enable_irq() of an already-enabled IRQ.  I don't know if
> that will cause runtime problems, but it doesn't seem desirable.

How could it do that?


> > +}
> > +
> > +/*
> > + * We cannot use I2C in interrupt context, so we just schedule work.
> > + */
> > +static irqreturn_t menelaus_irq(int irq, void *_menelaus)
> > +{
> > +	struct menelaus_chip *menelaus = _menelaus;
> > +
> > +	disable_irq_nosync(irq);
> 
> I guess the reader of this code will wonder why the nosync variant was
> used.  A comment would explain that.

Right.  ISTR that the "sync" version waits for any active
IRQ handler to complete.  That is, it's specified to cause
a self-deadlock in this call context (wait for self) ...


> In fact the reader might wonder why the heck we use a workqueue at all,
> rather than just doing the work in interrupt context as drivers normally
> do.
> 
> Perhaps that was all explained somewhere and I missed it.  If not, I'd
> suggest that this design decision should be described in a code comment
> somewhere.

Evidently the "we cannot use I2C in interrupt context" comment was
excessively subtle.  ;)

The whole I2C stack is synchronous; *EVERY* request to perform I/O
requires a can-sleep task context.  It's not like USB or SPI, where
the IRQ handler can submit I/O requests which will complete later.

Which is why every I2C driver that needs to handle an IRQ will need
to arrange some task context ... ergo the workqueue.  It's something
far more common in embedded systems than in the original "sensors"
context from which the I2C stack evolved.


> > +	int			err = 0;
> > +	struct menelaus_platform_data *menelaus_pdata =
> > +					client->dev.platform_data;
> > +
> > +	if (the_menelaus) {
> > +		dev_dbg(&client->dev, "only one %s for now\n",
> > +				DRIVER_NAME);
> > +		return -ENODEV;
> 
> I doubt if this can happen?

It's just paranoia.  If it ever *did* happen there would be
extreme confusion; it's easy to prevent, and useful to be
very explicit about this rule.


