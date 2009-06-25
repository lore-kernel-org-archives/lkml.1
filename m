Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZFYOxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZFYOxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZFYOxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:53:03 -0400
Received: from smtp.nokia.com ([192.100.122.230]:35781 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbZFYOxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:53:02 -0400
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys
	driver
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext Alek Du <alek.du@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Trilok Soni <soni.trilok@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>
In-Reply-To: <20090625220826.1fa7413e@dxy.sh.intel.com>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	 <5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
	 <359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
	 <20090625210642.432e08a5@dxy.sh.intel.com>
	 <1245936693.20530.107.camel@jani-desktop>
	 <20090625220826.1fa7413e@dxy.sh.intel.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 17:52:45 +0300
Message-Id: <1245941565.20530.134.camel@jani-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 14:52:51.0567 (UTC) FILETIME=[9D15E7F0:01C9F5A4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 16:08 +0200, ext Alek Du wrote:
> On Thu, 25 Jun 2009 21:31:33 +0800
> Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:
> 
> > On Thu, 2009-06-25 at 15:06 +0200, ext Alek Du wrote:
> > > On Thu, 25 Jun 2009 18:29:25 +0800
> > > Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:
> > > > Correct me if I'm wrong, but as far as I can tell,
> > > > schedule_delayed_work doesn't modify the timer if the work was already
> > > > pending. The result is not the same as with the timer. This breaks the
> > > > debouncing.
> > > 
> > > No. The workqueue is per button, if the work is already pending, then last
> > > key press is not handled yet. That keeps the debouncing. Why you want the second
> > > key press to break the first one? The second key press should be ignored, that's
> > > the meaning of debouncing right?
> > 
> > No, debouncing is supposed to let the gpio line stabilize to either
> > state before doing *anything*. You only want to schedule the work (and
> > send the input event) once the line has been in the same state for
> > debounce_interval ms. This is what the original code did, by kicking the
> > timer further at each state change.
> > 
> If you schedule the timer when you decide it "stabilized", the final gpio_get_value()
> could still return 0 in the timer handler, if the key released at that time. So your previous
> "stabilized" state is useless.

True, gpio_keys_report_event should also compare the value to the
previous state and bail out if it's unchanged. Something along the lines
of:

@@ -46,6 +46,10 @@ static void gpio_keys_report_event(struct work_struct *work)
 	unsigned int type = button->type ?: EV_KEY;
 	int state = (gpio_get_value(button->gpio) ? 1 : 0) ^ button->active_low;
 
+	if (state == bdata->state)
+		return;
+	bdata->state = state;
+
 	input_event(input, type, button->code, !!state);
 	input_sync(input);
 }

Bailing out would mean the gpio line wasn't quite long enough in the
same state after all.

> Isn't the delay work itself the mechanism to decide the "stabilized" ?

Delay is like "something happenened now, take a random sample later".

> The work will finally call gpio_get_value to determine the state to be sent
> to input layer. I don't think there is any defect here. 

Please try to consider the difference in functionality before and after
your patch. What if the line keeps going high and low faster than
debounce_interval?

Debouncing should also completely ignore a single spike shorter than
debounce_interval. Admittedly gpio-keys was flawed, but please consider
a change like above which should fix that.

> No, the original timer handler will crash kernel if you are using a I2C GPIO or SPI GPIO expander
> Since it try to call sleep-able gpio_get_value in atomic context.

It should be fixed then.


BR,
Jani.


