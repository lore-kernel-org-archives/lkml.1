Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZKQMK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZKQMK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZKQMK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:10:27 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:34629 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbZKQMK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:10:26 -0500
Date: Tue, 17 Nov 2009 13:10:26 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       raffaele.recalcati@bticino.it
Message-ID: <20091117121026.GD8008@gundam.enneenne.com>
Mail-Followup-To: Janakiram Sistla <janakiram.sistla@gmail.com>,
	linux-kernel@vger.kernel.org,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	raffaele.recalcati@bticino.it
References: <1258457469-16145-1-git-send-email-giometti@linux.it> <4fb5db50911170345m687ea1fcmff1444250d341240@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fb5db50911170345m687ea1fcmff1444250d341240@mail.gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] gpio: show IRQ settings even if GPIO direction is
	"output"
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 05:15:49PM +0530, Janakiram Sistla wrote:
> On Tue, Nov 17, 2009 at 5:01 PM, Rodolfo Giometti <giometti@linux.it> wrote:
> > Some architectures (as PXA 27x for example) may define GPIO IRQ lines
> > as outputs since internal circuitry supports such configuration.
> >
> > This patch simply detects if a GPIO is a IRQ line or not just looking
> > for IRQ line number, "desc" and "desc->action" fields.
> >
> > Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> > Cc: raffaele.recalcati@bticino.it
> > ---
> >  drivers/gpio/gpiolib.c |   82 ++++++++++++++++++++++++------------------------
> >  1 files changed, 41 insertions(+), 41 deletions(-)
> >
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index 50de0f5..298b66f 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -1381,6 +1381,8 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
> >        unsigned                gpio = chip->base;
> >        struct gpio_desc        *gdesc = &gpio_desc[gpio];
> >        int                     is_out;
> > +       int                     irq;
> > +       struct irq_desc         *desc;
> >
> >        for (i = 0; i < chip->ngpio; i++, gpio++, gdesc++) {
> >                if (!test_bit(FLAG_REQUESTED, &gdesc->flags))
> > @@ -1394,48 +1396,46 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
> >                                ? (chip->get(chip, i) ? "hi" : "lo")
> >                                : "?  ");
> >
> > -               if (!is_out) {
> > -                       int             irq = gpio_to_irq(gpio);
> > -                       struct irq_desc *desc = irq_to_desc(irq);
> > -
> > -                       /* This races with request_irq(), set_irq_type(),
> > -                        * and set_irq_wake() ... but those are "rare".
> > -                        *
> > -                        * More significantly, trigger type flags aren't
> > -                        * currently maintained by genirq.
> > -                        */
> > -                       if (irq >= 0 && desc->action) {
> > -                               char *trigger;
> > -
> > -                               switch (desc->status & IRQ_TYPE_SENSE_MASK) {
> > -                               case IRQ_TYPE_NONE:
> > -                                       trigger = "(default)";
> > -                                       break;
> > -                               case IRQ_TYPE_EDGE_FALLING:
> > -                                       trigger = "edge-falling";
> > -                                       break;
> > -                               case IRQ_TYPE_EDGE_RISING:
> > -                                       trigger = "edge-rising";
> > -                                       break;
> > -                               case IRQ_TYPE_EDGE_BOTH:
> > -                                       trigger = "edge-both";
> > -                                       break;
> > -                               case IRQ_TYPE_LEVEL_HIGH:
> > -                                       trigger = "level-high";
> > -                                       break;
> > -                               case IRQ_TYPE_LEVEL_LOW:
> > -                                       trigger = "level-low";
> > -                                       break;
> > -                               default:
> > -                                       trigger = "?trigger?";
> > -                                       break;
> > -                               }
> > -
> > -                               seq_printf(s, " irq-%d %s%s",
> > -                                       irq, trigger,
> > -                                       (desc->status & IRQ_WAKEUP)
> > -                                               ? " wakeup" : "");
> > +               irq = gpio_to_irq(gpio);
> > +               desc = irq_to_desc(irq);
> > +
> > +               /* This races with request_irq(), set_irq_type(),
> > +                * and set_irq_wake() ... but those are "rare".
> > +                *
> > +                * More significantly, trigger type flags aren't
> > +                * currently maintained by genirq.
> > +                */
> > +               if (irq >= 0 && desc && desc->action) {
> > +                       char *trigger;
> > +
> > +                       switch (desc->status & IRQ_TYPE_SENSE_MASK) {
> > +                       case IRQ_TYPE_NONE:
> > +                               trigger = "(default)";
> > +                               break;
> > +                       case IRQ_TYPE_EDGE_FALLING:
> > +                               trigger = "edge-falling";
> > +                               break;
> > +                       case IRQ_TYPE_EDGE_RISING:
> > +                               trigger = "edge-rising";
> > +                               break;
> > +                       case IRQ_TYPE_EDGE_BOTH:
> > +                               trigger = "edge-both";
> > +                               break;
> > +                       case IRQ_TYPE_LEVEL_HIGH:
> > +                               trigger = "level-high";
> > +                               break;
> > +                       case IRQ_TYPE_LEVEL_LOW:
> > +                               trigger = "level-low";
> > +                               break;
> > +                       default:
> > +                               trigger = "?trigger?";
> > +                               break;
> >                        }
> > +
> > +                       seq_printf(s, " irq-%d %s%s",
> > +                               irq, trigger,
> > +                               (desc->status & IRQ_WAKEUP)
> > +                                       ? " wakeup" : "");
> >                }
> >
> >                seq_printf(s, "\n");
> > --
> > 1.6.3.3
> 
> Is there any valid test scenario that makes use of this
> patch???Detecting GPIO if it is IRQ in kernel what is the advantage?

My PXA270 based board uses a passive electrical circuit to detect a
CARD insert supplied by GPIO output current, so, in order to work, I
need to setup the GPIO as OUTPUT high level and then, thanks to a pull
down, I can read the CARD insert/removal event.

My solution is more generic then current one and applyes to those
architectures whose support such kind of GPIOs (as PXA27x does) with
no drawbacks for others.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
