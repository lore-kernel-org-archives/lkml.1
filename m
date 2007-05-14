Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbXENVP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbXENVP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbXENVPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:15:38 -0400
Received: from mx6.mail.ru ([194.67.23.26]:32868 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbXENVPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:15:37 -0400
Date: Tue, 15 May 2007 01:13:36 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: kogiidena@eggplant.ddo.jp, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
Message-ID: <20070514211336.GA27394@zarina>
Reply-To: cbou@mail.ru
References: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp> <1178628889.6061.33.camel@localhost.localdomain> <2490.192.168.1.10.1178720780.squirrel@eggplant.ddo.jp> <1178723594.6291.21.camel@localhost.localdomain> <20070509160328.GA13640@zarina> <1179098182.5883.31.camel@localhost.localdomain> <20070514201256.GB26554@zarina> <1179174816.5877.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1179174816.5877.60.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 09:33:36PM +0100, Richard Purdie wrote:
> On Tue, 2007-05-15 at 00:12 +0400, Anton Vorontsov wrote:
> > This change needed for two purposes:
> > 
> > 1. When somebody sets trigger, and that trigger would setup
> >    brightness in its activate() function, and led driver would check
> >    if that trigger supported (used by hwtimer trigger and drivers
> >    supporting hw blinking LEDs, not in mainline yet).
> 
> Why does led_cdev->trigger need to be set to do this? Any well written
> LED drivers shouldn't need to look at it as the LED drivers shouldn't
> have or need any knowledge about specific triggers. If they need this,
> you hw blinking abstraction isn't generic.

Well, yes. Hw blinking abstraction not generic, in sense that driver
*must* know that it may be asked for "blinking trigger", i.e. hwtimer or
its derivate. There just isn't other way to do it, because
brightness_set function accepts only "enum led_brightness" argument,
because your initial intention: avoid other properties but brightness.
It's okay, but..

Because of all above, the only way I see hwtimer could be done (and
it done that way) on driver side is:

static void samcop_leds_set(struct led_classdev *led_cdev,
                            enum led_brightness b)
{
[...]
        if (b == LED_OFF)
                samcop_set_led(samcop_dev, PWM_RATE, led->hw_num, 0, 16);
        else {
                #ifdef CONFIG_LEDS_TRIGGER_HWTIMER
                if (led_cdev->trigger && led_cdev->trigger->is_led_supported &&
                               (led_cdev->trigger->is_led_supported(led_cdev) &
                                LED_SUPPORTS_HWTIMER)) {

/* ^^^ we're checking if trigger require us hwblinking, so it's hwtimer
 * or "derivate", i.e. any trigger passing hwtimer_data. LEDs API don't
 * have any other way to pass "blinking parameters" to the driver, i.e.
 * on/off delays. */

                        struct hwtimer_data *td = led_cdev->trigger_data;

                        if (!td) return;

                        samcop_set_led(samcop_dev, PWM_RATE, led->hw_num,
                          (PWM_RATE * td->delay_on)/1000,
                          (PWM_RATE * (td->delay_on + td->delay_off))/1000);
                }
                else
                #endif
                samcop_set_led(samcop_dev, PWM_RATE, led->hw_num, 16, 16);
        }

        return;
}

> I'm going to hold this patch until we're about the merge
> something that needs it, if it really needs it.

Fair enough.

Side note: I'm still dreaming about hwtimer -> timer merge, and make
it smart enough to use software blinking if hwtimer on/off delays limits
exceeded. Though, I'm still unsure when I'll start that work.

> > 2. If trigger would access itself through led_cdev in its activate()
> >    function.
> 
> I can't see why you'd need to do this...

Yes, there is no any user of that feature. Even not in handhelds.org tree
anymore. Though, hwtimer still using "1." reason.

> > 1. No mainline kernel user, but offshores.
> 
> 2. Encourages bad code ;-). 

:-) I'll agree here, but only after I or anyone else will make hwtimer other
way, generic one.

> -- 
> Richard

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
