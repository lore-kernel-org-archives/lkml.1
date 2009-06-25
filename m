Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZFYNLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZFYNLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZFYNLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:11:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:22168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZFYNLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:11:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,290,1243839600"; 
   d="scan'208";a="425260856"
Date: Thu, 25 Jun 2009 21:06:42 +0800
From: Alek Du <alek.du@intel.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
CC: LKML <linux-kernel@vger.kernel.org>, Trilok Soni <soni.trilok@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys
 	driver
Message-ID: <20090625210642.432e08a5@dxy.sh.intel.com>
In-Reply-To: <359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	<5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
	<359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 18:29:25 +0800
Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:

> On Fri, Jun 12, 2009 at 8:40 PM, Trilok Soni<soni.trilok@gmail.com> wrote:
> >>  static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
> >>  {
> >>        struct gpio_button_data *bdata = dev_id;
> >> @@ -62,10 +61,10 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
> >>        BUG_ON(irq != gpio_to_irq(button->gpio));
> >>
> >>        if (button->debounce_interval)
> >> -               mod_timer(&bdata->timer,
> >> -                       jiffies + msecs_to_jiffies(button->debounce_interval));
> >> +               schedule_delayed_work(&bdata->work,
> >> +                       msecs_to_jiffies(button->debounce_interval));
> >>        else
> >> -               gpio_keys_report_event(bdata);
> >> +               schedule_work(&bdata->work.work);
> >>
> >>        return IRQ_HANDLED;
> >>  }
> 
> Correct me if I'm wrong, but as far as I can tell,
> schedule_delayed_work doesn't modify the timer if the work was already
> pending. The result is not the same as with the timer. This breaks the
> debouncing.

No. The workqueue is per button, if the work is already pending, then last
key press is not handled yet. That keeps the debouncing. Why you want the second
key press to break the first one? The second key press should be ignored, that's
the meaning of debouncing right?

> 
> It looks like a slightly modified version of this patch has already
> been committed [1], but it has the same problem.
> 
> [1] 0b346838c5862bfe911432956a106d602535d030 Input: gpio-keys - change
> timer to workqueue

Yes, the patch is already in Linus tree.


Thanks,
Alek
