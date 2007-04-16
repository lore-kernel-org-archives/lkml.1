Return-Path: <linux-kernel-owner+w=401wt.eu-S1030916AbXDPTjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030916AbXDPTjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030919AbXDPTjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:39:23 -0400
Received: from mx33.mail.ru ([194.67.23.194]:19847 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030917AbXDPTjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:39:22 -0400
Date: Mon, 16 Apr 2007 23:35:18 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Matt Reimer <mattjreimer@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, dwmw2@infradead.org
Subject: Re: [PATCH 6/7] [RFC] ds2760 battery driver
Message-ID: <20070416193518.GA3580@zarina>
Reply-To: cbou@mail.ru
References: <20070411232522.GF20095@zarina> <20070415194001.GF10097@ucw.cz> <f383264b0704161214x168b36f4tdd9a074d604b36cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <f383264b0704161214x168b36f4tdd9a074d604b36cb@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 12:14:27PM -0700, Matt Reimer wrote:
>  On 4/15/07, Pavel Machek <pavel@ucw.cz> wrote:
> > > +     di->update_time = jiffies;
> > > +
> > > +     /* DS2760 reports voltage in units of 4.88mV, but the battery class
> > > +      * reports in units of mV, so convert by multiplying by 4.875.
> > > +      * We approximate because integer math is cheap, and close enough. 
> > */
> > > +     di->voltage_raw = (di->raw[DS2760_VOLTAGE_MSB] << 3) |
> > > +                       (di->raw[DS2760_VOLTAGE_LSB] >> 5);
> > > +     di->voltage_mV = (di->voltage_raw * 5) - (di->voltage_raw / 8);
> >
> > Hmm, not sure if such tricks re really worth it... should not compiler
> > be doing this?
> 
>  The shifts (<< 3 and >> 5) are just to get the bits reassembled in the
>  right positions. The multiplication by 5 and subtracting 1/8 is
>  because (AFAIK) we can't do floating point multiplication in the
>  kernel. I'm open to suggestions.

Because we are in micro world now, divisions already replaced by
multiplication. I.e.

        /* DS2760 reports voltage in units of 4.88mV, but the battery class
         * reports in units of uV, so convert by multiplying by 4880. */
        di->voltage_raw = (di->raw[DS2760_VOLTAGE_MSB] << 3) |
                          (di->raw[DS2760_VOLTAGE_LSB] >> 5);
        di->voltage_uV = di->voltage_raw * 4880;

As a side effect, now we're not losing any precision. :-)

> > > +     /* Calculate the empty level at the present temperature. */
> > > +     scale[4] = di->raw[DS2760_ACTIVE_EMPTY + 4];
> > > +     for (i = 3; i >= 0; i--)
> > > +             scale[i] = scale[i + 1] + di->raw[DS2760_ACTIVE_EMPTY + i];
> > > +
> > > +     di->empty_mAh = battery_interpolate(scale, di->temp_C / 10);
> >
> > Wow.
> 
>  Yeah, mea culpa. I don't like its obtuseness either, and haven't
>  revisited it since I got it working. Basically the battery has an
>  array stored in its EEPROM that represents the empty level at various
>  temperature thresholds. What makes this complicated is that the array
>  does not contain all absolute values; just the first is absolute, and
>  the others are relative to it, in reverse order. The above code
>  converts it to an array of absolute values from low to high. I'm open
>  to suggestions about this one too.

By the way. Matt, you're more familiar with ds2760 specs, could you
enlighten me about "* 4" in this snippet?

>       acr[0] = (di->full_active_mAh * 4) >> 8;
                                      ^^^
>       acr[1] = (di->full_active_mAh * 4) & 0xff;
                                      ^^^
>       if (w1_ds2760_write(di->w1_dev, acr,
>                           DS2760_CURRENT_ACCUM_MSB, 2) < 2)
>              printk(KERN_ERR "ACR reset failed\n");


>  Matt

Thanks!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
