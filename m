Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbYHSOuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbYHSOuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYHSOue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:50:34 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:21335 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751375AbYHSOud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:50:33 -0400
Date: Tue, 19 Aug 2008 18:50:31 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: linuxppc-dev@ozlabs.org, Greg Kroah-Hartman <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 1/3] gpiolib: make gpio_to_chip() public
Message-ID: <20080819145031.GA28616@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080808161717.GA19095@polina.dev.rtsoft.ru> <200808181644.45480.laurentp@cse-semaphore.com> <20080818153300.GA10163@oksana.dev.rtsoft.ru> <200808191126.33133.laurentp@cse-semaphore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <200808191126.33133.laurentp@cse-semaphore.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:26:28AM +0200, Laurent Pinchart wrote:
[...]
> > I didn't say "SOC-specific". I said "SOC-model specific", which
> > means that the driver would be not portable even across QE chips
> > (i.e. MPC8323 vs. MPC8360, you can assume that the "CLK12" function
> > is having same PAR/ODR/DAT/DIR bits).
> 
> If I'm not mistaken, the PAR bit is used to select between GPIO and
> dedicated mode by definition. It should be safe to assume that setting
> a GPIO in dedicated mode requires the PAR bit to be set. But as I
> stated above, we can ignore that for now until a hardware use case
> comes up.

One more thing: you're assuming that there is one par bit, but
there are two par bits for QE chips. Which one would you set in
set_dedicated()? ;-)

> > > > > If, for some
> > > > > reason (driver not loaded, ...), no GPIO user shows up for that
> > > > > pin, it will stay configured in dedicated mode.
> > > > 
> > > > Yes.
> > > > 
> > > > > It might be better to set the PAR bit unconditionally in
> > > > 
> > > > Why it might be better?
> > > 
> > > Because, as explained a few lines down, the board initialization code
> > > will be able to configure a pin in a known state (PAR not set) at boot
> > > time until a driver requests the pin to be switched to dedicated mode.
> > 
> > You can do this as I described above. But prior to this, yes, you have
> > to configure the pins and let Linux save these values. There is no other
> > way to pass this information, unfortunately.
> 
> Ok.
> 
> I started implementing CPM2 dedicated mode support to be used in the
> CPM UART driver for RTS/CTS flow control, and soon realized there was
> a show stopper. The CPM UART driver is mostly CPM1/CPM2 agnostic.
> I can't use a function such as cpm2_gpio32_set_dedicated, as that
> wouldn't work on a CPM1 (at least not on all its ports). I could call
> the right function depending on which port the GPIO is on, but that's
> really hackish and would defeat the purpose of using GPIOs.

You can easily refactor cpm gpio code so that you'll have
common cpm structure with platform-specific "GPIO API extension"
callbacks. Something like this:

/*
 * generic structure, does not know anything about cpm1/2/qe, or
 * ports width.
 */
struct cpm_gpio_chip {
	struct of_mm_gpio_chip mm_gc;
	spinlock_t lock;
	void (*set_dedicated)(unsigned int gpio);
};

struct cpm1_gpio16_chip {
	struct cpm_gpio_chip cpgc;

	/* shadowed data register to clear/set bits safely */
	u16 cpdata;
};

void cpm_gpio_set_dedicated(unsigned int gpio)
{
	struct gpio_chip *gc = gpio_to_chip(gpio);
	struct of_gpio_chip *ofgc = to_of_gpio_chip(gc);
	struct cpm_gpio_chip *cpgc = to_cpm_gpio_chip(ofgc);

	if (cpgc->set_dedicated)
		cpgc->set_dedicated(gc->base - gpio);
}

> What we
> really need there is a set_dedicated/set_option/set_whatever function
> in the GPIO API :-/

Won't happen. ;-)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
