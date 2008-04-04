Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbYDDTg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbYDDTg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYDDTgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:36:48 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:48776 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYDDTgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:36:47 -0400
Date: Fri, 4 Apr 2008 21:36:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <tpiepho@freescale.com>
Cc: David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
Message-ID: <20080404213632.300eb3de@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0804041102230.20532@t2.domain.actdsltmp>
References: <200710291809.29936.david-b@pacbell.net>
	<200711301040.54777.david-b@pacbell.net>
	<20071130211332.49a21a6b@hyperion.delvare>
	<200711301259.22666.david-b@pacbell.net>
	<Pine.LNX.4.64.0804031844500.11928@t2.domain.actdsltmp>
	<20080404100933.077bee33@hyperion.delvare>
	<Pine.LNX.4.64.0804041102230.20532@t2.domain.actdsltmp>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008 12:07:12 -0700 (PDT), Trent Piepho wrote:
> On Fri, 4 Apr 2008, Jean Delvare wrote:
> > On Thu, 3 Apr 2008 19:06:27 -0700 (PDT), Trent Piepho wrote:
> >> +	strcpy(buf, test_bit(FLAG_IS_OUT, &gdesc->flags) ? "out\n" : "in\n\0");
> >> +
> >> +	return 5;
> >
> > Confusing construct... I suggest using sprintf instead, which will
> > automatically return the correct number of bytes for you.
> 
> But it's less efficient!  Will nobody think of the wasted cycles?

Can you prove that it is actually less efficient, and if so, by how
much? The time spent in this single function if probably insignificant
in comparison to the whole chain from the user-space process to the
GPIO chip.

Not that it really matters anyway, this is in no way a hot path
so clarity and correctness definitely take over efficiency. And the
code above is actually incorrect: as I mentioned elsewhere in this
thread, you aren't support to include trailing \0s in the buffer you
pass back to sysfs. Not all programming languages use \0 for string
termination.

> (...)
> >> +static void __exit gpio_class_exit(void)
> >> +{
> >> +	/* FIXME:  Code to remove all the sysfs devices and files created
> >> +	 * should go here */
> >
> > Oh yes it really should ;)
> 
> I know, but I'm not using modules for the system this is in, so it will never
> get called.  What's the point of writing code I'll never use if this isn't
> useful for the kernel?

Because most certainly your code won't be accepted upstream until this
is fixed, and presumably you posted this patch in the hope that it
would go upstream ;) Just because it isn't useful to you doesn't mean
it won't be useful to others. Otherwise this particular piece of code
couldn't be built as a module at all.

> (...)
> >> @@ -118,6 +290,22 @@ int gpiochip_add(struct gpio_chip *chip)
> >>   	}
> >>
> >>   	spin_unlock_irqrestore(&gpio_lock, flags);
> >> +
> >> +	if (status)
> >> +		goto fail;
> >> +
> >> +	if (chip->dev) {
> >> +		/* can sleep, so can't call with the spinlock held */
> >
> > You don't actually hold the spinlock at this point.
> 
> It would be easier to call gpiochip_classdev_register() earlier when the spin
> lock is held, but one can't because it could sleep.  The comment was a warning
> to anyone who thought they could simplify the logic.

Oops, sorry. I totally missed the "can't" in the comment.

-- 
Jean Delvare
