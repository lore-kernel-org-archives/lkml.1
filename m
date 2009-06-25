Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZFYNcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZFYNcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZFYNcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:32:35 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19280 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZFYNce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:32:34 -0400
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys
	driver
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext Alek Du <alek.du@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Trilok Soni <soni.trilok@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>
In-Reply-To: <20090625210642.432e08a5@dxy.sh.intel.com>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	 <5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
	 <359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
	 <20090625210642.432e08a5@dxy.sh.intel.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 16:31:33 +0300
Message-Id: <1245936693.20530.107.camel@jani-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 13:31:36.0099 (UTC) FILETIME=[43148730:01C9F599]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 15:06 +0200, ext Alek Du wrote:
> On Thu, 25 Jun 2009 18:29:25 +0800
> Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:
> 
> > On Fri, Jun 12, 2009 at 8:40 PM, Trilok Soni<soni.trilok@gmail.com> wrote:
> > >>  static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
> > >>  {
> > >>        struct gpio_button_data *bdata = dev_id;
> > >> @@ -62,10 +61,10 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
> > >>        BUG_ON(irq != gpio_to_irq(button->gpio));
> > >>
> > >>        if (button->debounce_interval)
> > >> -               mod_timer(&bdata->timer,
> > >> -                       jiffies + msecs_to_jiffies(button->debounce_interval));
> > >> +               schedule_delayed_work(&bdata->work,
> > >> +                       msecs_to_jiffies(button->debounce_interval));
> > >>        else
> > >> -               gpio_keys_report_event(bdata);
> > >> +               schedule_work(&bdata->work.work);
> > >>
> > >>        return IRQ_HANDLED;
> > >>  }
> > 
> > Correct me if I'm wrong, but as far as I can tell,
> > schedule_delayed_work doesn't modify the timer if the work was already
> > pending. The result is not the same as with the timer. This breaks the
> > debouncing.
> 
> No. The workqueue is per button, if the work is already pending, then last
> key press is not handled yet. That keeps the debouncing. Why you want the second
> key press to break the first one? The second key press should be ignored, that's
> the meaning of debouncing right?

No, debouncing is supposed to let the gpio line stabilize to either
state before doing *anything*. You only want to schedule the work (and
send the input event) once the line has been in the same state for
debounce_interval ms. This is what the original code did, by kicking the
timer further at each state change.

> > It looks like a slightly modified version of this patch has already
> > been committed [1], but it has the same problem.
> > 
> > [1] 0b346838c5862bfe911432956a106d602535d030 Input: gpio-keys - change
> > timer to workqueue
> 
> Yes, the patch is already in Linus tree.

IMHO it should be either fixed or reverted.


BR,
Jani.


