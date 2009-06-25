Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926AbZFYONf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbZFYONf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZFYONZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:13:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:48857 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbZFYONX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:13:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,290,1243839600"; 
   d="scan'208";a="702446231"
Date: Thu, 25 Jun 2009 22:08:26 +0800
From: Alek Du <alek.du@intel.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
CC: LKML <linux-kernel@vger.kernel.org>, Trilok Soni <soni.trilok@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys
 driver
Message-ID: <20090625220826.1fa7413e@dxy.sh.intel.com>
In-Reply-To: <1245936693.20530.107.camel@jani-desktop>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	<5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
	<359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
	<20090625210642.432e08a5@dxy.sh.intel.com>
	<1245936693.20530.107.camel@jani-desktop>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 21:31:33 +0800
Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:

> On Thu, 2009-06-25 at 15:06 +0200, ext Alek Du wrote:
> > On Thu, 25 Jun 2009 18:29:25 +0800
> > Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:
> > 
> > > On Fri, Jun 12, 2009 at 8:40 PM, Trilok Soni<soni.trilok@gmail.com> wrote:
> > > >>  static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
> > > >>  {
> > > >>        struct gpio_button_data *bdata = dev_id;
> > > >> @@ -62,10 +61,10 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
> > > >>        BUG_ON(irq != gpio_to_irq(button->gpio));
> > > >>
> > > >>        if (button->debounce_interval)
> > > >> -               mod_timer(&bdata->timer,
> > > >> -                       jiffies + msecs_to_jiffies(button->debounce_interval));
> > > >> +               schedule_delayed_work(&bdata->work,
> > > >> +                       msecs_to_jiffies(button->debounce_interval));
> > > >>        else
> > > >> -               gpio_keys_report_event(bdata);
> > > >> +               schedule_work(&bdata->work.work);
> > > >>
> > > >>        return IRQ_HANDLED;
> > > >>  }
> > > 
> > > Correct me if I'm wrong, but as far as I can tell,
> > > schedule_delayed_work doesn't modify the timer if the work was already
> > > pending. The result is not the same as with the timer. This breaks the
> > > debouncing.
> > 
> > No. The workqueue is per button, if the work is already pending, then last
> > key press is not handled yet. That keeps the debouncing. Why you want the second
> > key press to break the first one? The second key press should be ignored, that's
> > the meaning of debouncing right?
> 
> No, debouncing is supposed to let the gpio line stabilize to either
> state before doing *anything*. You only want to schedule the work (and
> send the input event) once the line has been in the same state for
> debounce_interval ms. This is what the original code did, by kicking the
> timer further at each state change.
> 
If you schedule the timer when you decide it "stabilized", the final gpio_get_value()
could still return 0 in the timer handler, if the key released at that time. So your previous
"stabilized" state is useless.
Isn't the delay work itself the mechanism to decide the "stabilized" ?

The work will finally call gpio_get_value to determine the state to be sent
to input layer. I don't think there is any defect here. 
 
> IMHO it should be either fixed or reverted.
> 

No, the original timer handler will crash kernel if you are using a I2C GPIO or SPI GPIO expander
Since it try to call sleep-able gpio_get_value in atomic context.
