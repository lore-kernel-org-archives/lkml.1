Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbZFLAhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbZFLAhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 20:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbZFLAhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 20:37:11 -0400
Received: from ru.mvista.com ([213.79.90.228]:29959 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753685AbZFLAhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 20:37:10 -0400
Date: Fri, 12 Jun 2009 04:37:01 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stefan Strobl <nst@gersys.de>, ppc-dev <linuxppc-dev@ozlabs.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PWM class? (was: Re: MPC52xx simple GPIO support)
Message-ID: <20090612003701.GA9496@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <4A255B21.8040002@gersys.de> <20090602171527.GA8745@oksana.dev.rtsoft.ru> <4A266FB2.2040902@gersys.de> <20090603132217.GA18353@oksana.dev.rtsoft.ru> <fa686aa40906111500w1760290bm890f3ee132500b1d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa40906111500w1760290bm890f3ee132500b1d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 04:00:51PM -0600, Grant Likely wrote:
> On Wed, Jun 3, 2009 at 7:22 AM, Anton Vorontsov<avorontsov@ru.mvista.com> wrote:
> > On Wed, Jun 03, 2009 at 02:42:26PM +0200, Stefan Strobl wrote:
> > [...]
> >> The led class provides support for setting the brightness, which
> >> obviously the gpio driver doesn't support. The hardware (mpc52xx_gpt)
> >> would support it in PWM mode though. I'm now wandering how this could be
> >> best implemented.
> >>
> >> 1) - Create some PWM class similar to the GPIO class
> >>    - Add support for PWM mode in mpc52xx_gpt.c that uses that PWM class
> >>    - And add an interface for the LED to use the PWM class
> >>
> >> 2) - Create an LED driver that accesses the mpc52xx_gpt directly.
> >>
> >> I think I would be overwhelmed trying to implement (1) but am confident
> >> to do (2). What do you think is the right approach?
> >
> > I'd suggest creating a generic PWM class, i.e. PWMLIB, alike to
> > GPIOLIB. (2) can be an acceptable approach for now, but for the
> > long-term solution (1) is the way to go.
> >
> > The non-lib PWM API is already there, see include/linux/pwm.h,
> > and arch/arm/mach-pxa/pwm.c as an implementation example.
> >
> > Note that PXA implementation is SOC-specific, which is not very
> > good.
> >
> > So I'd suggest creating drivers/pwm/pwmlib.c, borrowing
> > ideas from gpiolib. And then we can reuse drivers/leds/leds-pwm.c
> > driver (of course, after adding appropriate OF code into it).
> 
> Ugh.  The referenced pwm api is about as trivial as it gets; it is an
> anonymous context pointer (anonymous struct pwm_device *) with a set
> of accessor functions.  PWMs are also not nearly as common as GPIO
> pins, and I am not interested in gpiolib being duplicated for PWMs, at
> least not until there are more that just two examples of use to draw
> from.

I didn't say that we should duplicate gpiolib. I said that we
might borrow some ideas. ;-)

> If anything, I'd rather struct pwm_device be non-anonymous and contain
> a set of ops which call directly into the driver.  That way is at
> least multiplatform friendly.  I don't think the gpio API is the
> example to follow here.  But even then I think it is premature to try
> and define a PWM api.  Personally, I'd modify mpc52xx_gpt to export
> its own PWM interface for the time being using the existing GPIO
> infrastructure to find the appropriate pin.

Jon Smirl found that there were already some efforts put
into making generic PWM class:

http://thread.gmane.org/gmane.linux.kernel.embedded/1160

Briefly looking, the class is pretty cool. Somebody should just
continue this work.

> If you do decide to do a generic PWM api, then I think the way to go
> is to build it as an extension to gpiolib.

I don't think David Brownell will like this idea. But
who knows... maybe.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
