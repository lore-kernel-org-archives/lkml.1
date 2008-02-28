Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbYB1PbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbYB1PbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbYB1Pax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:30:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34691 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757253AbYB1Pav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:30:51 -0500
Date: Thu, 28 Feb 2008 15:30:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Pete MacKay <linux01@architechnical.net>,
       Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
       Vincent Sanders <vince@kyllikki.org>,
       Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
Message-ID: <20080228153048.GB17356@rakim.wolfsonmicro.main>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Graeme Gregory <gg@opensource.wolfsonmicro.com>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Pete MacKay <linux01@architechnical.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
	Vincent Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>
References: <12040332183316-git-send-email-broonie@opensource.wolfsonmicro.com> <20080227230928.993d424e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227230928.993d424e.akpm@linux-foundation.org>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 11:09:28PM -0800, Andrew Morton wrote:

> Nice looking drivers.

Thanks.

> On Tue, 26 Feb 2008 13:40:13 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > +	queue_delayed_work(wm->ts_workq, &wm->ts_reader, 0);

> This is equvaltnet to queue_work().

> Why queue the work instead of just callng it synchronously right here?

No good reason any more, I think.  I'll take a closer look and either
change it to an immediate call or document what's going on.

> > +static irqreturn_t wm97xx_pen_interrupt(int irq, void *dev_id)
> > +{
> > +	struct wm97xx *wm = dev_id;
> > +	wm->mach_ops->irq_enable(wm, 0);
> > +	queue_work(wm->ts_workq, &wm->pen_event_work);
> > +	return IRQ_HANDLED;
> > +}

> We can lose events, can't we?  We only have one work to queue, and if it is
> already queued, the queue_work() here is a no-op.

> otoh there's no payload so there's actually no data to lose.

Indeed - only scheduling the work a single time is exactly the behaviour
that's desired here.

> Still, this stands out a bit and perhaps a comment which describes the
> overall interrupt handling design would help here.

I agree, I'll add something.

> > +	if (wm->pen_is_down || !wm->pen_irq)
> > +		queue_delayed_work(wm->ts_workq, &wm->ts_reader,
> > +				   wm->ts_reader_interval);
> > +}

> again, if this work is already scheduled, your queue_delayed_work() here is
> a no-op.  Will things all work correctly?

Yes, the worst that would happen would be that we'd read one less sample
which might cause a glitch in input but we're reading sufficiently often
to make that not an issue.

> A bit of whitecpace inconsistency there.

Fixed, thanks.

> > +	 * failed to acquire it then we need to poll.
> > +	 */
> > +	if (wm->pen_irq == 0)
> > +		queue_delayed_work(wm->ts_workq, &wm->ts_reader,
> > +				   wm->ts_reader_interval);
> > +
> > +	return 0;
> > +}

> So...  this driver continuously polls the hardware at 100HZ?  If so,
> powertop users will come after you with pitchforks.

It'll only do that while the pen is down.  It'd be possible to turn that
down but that needs to be traded off against responsiveness.

If the user has provided an accelerated touch driver then while the pen
is up we won't poll the device at all, relying on an interrupt to wake
the driver up when the pen goes down.  We strongly recommend doing this
for power sensitive applications but it requires board-specific code.

If no acclerated touch driver is provided then we don't have much option
other than polling but the driver will gradually back off to 10Hz.  This
is still far from ideal but not quite so bad.  Reducing it any more than
that would make the pen down event unresponsive.

> > +#ifdef CONFIG_TOUCHSCREEN_WM9713
> > +	case 0x13:
> > +		wm->codec = &wm9713_codec;
> > +		break;
> > +#endif

> That's a wee bit combersome.  Really a "core" should not know about its
> specific clients.  A better and more typical design would have the clients
> registering themselves with the core via some registration interface.

Yes, that would be nicer.  Unfortunately the driver isn't actually fully
factored out like that yet - there are still a couple of places in the
core code with device-specific checks.  We could improve it further but
it's probably more trouble than it's worth until more substantial work
such as adding new chips is required.

> > +	/* set up touch configuration */
> > +	wm->input_dev->name = "wm97xx touchscreen";

> spaces in names are OK here?  They can make proc files basically
> unparseable.

Yes, it's fine.  This ends up in /proc/bus/input/devices as:

   N: Name="wm97xx touchscreen"

which is parsable and a quick survey of drivers/input/touchscreen
suggests that spaces are even the common case for touchscreen drivers.

> The kernel->userspace interface looks fairly complex.  Is it documented
> anywhere?

I'm not aware of anything specific to touchscreens beyond the source to
existing applications and drivers but IME it's fairly straightforward
within the input framework.

> > +#else
> > +#define wm97xx_resume		NULL
> > +#endif

> It's strange to see a .resume but no .suspend.

Yes.  The actual chip shutdown is handled by AC97 though we really
should quiesce the poll if it is running when we suspend - I'll add
something for that.

> > +/*
> > + * WM97xx AC97 Touchscreen registers
> > + */

> ac97 stuff?  But I saw no appropriate dependencies for this in the Kconfig
> patch?

Yes, they're AC97 parts.  There's this in Kconfig ATM:

+config TOUCHSCREEN_WM97XX
+       tristate "Support for WM97xx AC97 touchscreen controllers"
+       depends on AC97_BUS

I'm not sure what else would be useful?

> > +/*
> > + * Codec GPIO wake
> > + */
> > +enum wm97xx_gpio_wake {
> > +    WM97XX_GPIO_WAKE,
> > +    WM97XX_GPIO_NOWAKE
> > +};

> Are these gpio's really gp?  If so, should this driver be using the
> drivers/gpio/ infrastructure?

Well, they're multi-function pins so they can do GPIO plus specific
functionality for the device but yes they could do that.  They are
rarely used as fully GP pins since the SoC based systems where these
codecs are most frequently deployed usually have an abundance of GPIO
pins on the SoC itself which don't require going over the AC97 bus to
manipulate.

Aside from the disruption to existing users the main problem with doing
that is that it would require that platform data be passed into the
driver to specify the base for the GPIOs (this would be useful for all
the other configuration too).  I can't see a suitably nice way to do
that at the minute, unfortunately.  Without such a method I'd really
rather avoid using gpiolib since it doesn't feel like a sufficient win.

Thanks for the review.
