Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbYGJUC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbYGJUC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYGJUCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:02:16 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:35676 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751455AbYGJUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:02:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yFz5tK9t+X5ARrpstbiyJjHYb6RcnxhMcmTUaKWWs3iTz1Ljvfh9rJ9JOqkYhIlBNJstZyxYkW9i7mC9qX9Cw9funYZrD/dAEjbxmDZEKvMmT2ezP1r696g4zFZ7o4yUWImjd87deQt+Hr58EVfS54vl73b4S6SBjkbmPbmo/s8=  ;
X-YMail-OSG: 4hlhj.cVM1metRMY4m7nZkyhKH48v75QH0tBo5lLIrk7ZCiPdDJPdYOD9QGcj8qzeiNbR6HR06jRJWBYqX0Q9rW6JxjbnlCN0USy8VqXpg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jiri Slaby <jirislaby@gmail.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
Date: Thu, 10 Jul 2008 13:02:12 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mchehab@infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
References: <200807101914.10174.mb@bu3sch.de> <487651CA.6030405@gmail.com>
In-Reply-To: <487651CA.6030405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807101302.12765.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008, Jiri Slaby wrote:
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-next/drivers/gpio/bt8xxgpio.c	2008-07-10 19:05:56.000000000 +0200
> > @@ -0,0 +1,348 @@
> [...]
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

Not that routine (see Documentation/gpio.txt where
that's specified) ... but other using the same lock.

When setting GPIO direction, spin_lock_irq() style
calls are appropriate (but this isn't wrong).

The gpio_{get,set}_value() accessors may be called
from IRQ context, so they need to save/restor the
IRQ flags.


> some flushing of posted values here?

See Documentation/gpio.txt:

+ Note that these operations include I/O barriers on platforms
+ which need to use them; drivers don't need to add them explicitly.

That's the key thing:  drivers using I/O calls should
not need to insert bus or platform specific calls to
make sure the calls take effect.


Also:

> +	return !!(val & (1 << nr));

GPIO values are zero/nonzero, not zero/one.  So the "!!"
can be removed.

- Dave
