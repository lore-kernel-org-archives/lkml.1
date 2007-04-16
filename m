Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXDPTOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXDPTOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXDPTOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:14:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:2602 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXDPTOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:14:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PJmgY/eofx7Pgb3dtV+2PQDcgSpAtmVVGlRODdXx0F/soGU79QPtwcCuJ2OpGOhT1BrgYuBt2JaBTGIT5SAkbgZExstQvlQs8Qnl4BcZ/zVpQ5E5GgBUkDfPxOmW1+3PkaKg3zpw9/U8kQ6yZ3d//KGM4V+uu5nrzkelX9qAyBc=
Message-ID: <f383264b0704161214x168b36f4tdd9a074d604b36cb@mail.gmail.com>
Date: Mon, 16 Apr 2007 12:14:27 -0700
From: "Matt Reimer" <mattjreimer@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH 6/7] [RFC] ds2760 battery driver
Cc: "Anton Vorontsov" <cbou@mail.ru>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, dwmw2@infradead.org
In-Reply-To: <20070415194001.GF10097@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070411232522.GF20095@zarina> <20070415194001.GF10097@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/07, Pavel Machek <pavel@ucw.cz> wrote:
> > +     di->update_time = jiffies;
> > +
> > +     /* DS2760 reports voltage in units of 4.88mV, but the battery class
> > +      * reports in units of mV, so convert by multiplying by 4.875.
> > +      * We approximate because integer math is cheap, and close enough. */
> > +     di->voltage_raw = (di->raw[DS2760_VOLTAGE_MSB] << 3) |
> > +                       (di->raw[DS2760_VOLTAGE_LSB] >> 5);
> > +     di->voltage_mV = (di->voltage_raw * 5) - (di->voltage_raw / 8);
>
> Hmm, not sure if such tricks re really worth it... should not compiler
> be doing this?

The shifts (<< 3 and >> 5) are just to get the bits reassembled in the
right positions. The multiplication by 5 and subtracting 1/8 is
because (AFAIK) we can't do floating point multiplication in the
kernel. I'm open to suggestions.

> > +     /* Calculate the empty level at the present temperature. */
> > +     scale[4] = di->raw[DS2760_ACTIVE_EMPTY + 4];
> > +     for (i = 3; i >= 0; i--)
> > +             scale[i] = scale[i + 1] + di->raw[DS2760_ACTIVE_EMPTY + i];
> > +
> > +     di->empty_mAh = battery_interpolate(scale, di->temp_C / 10);
>
> Wow.

Yeah, mea culpa. I don't like its obtuseness either, and haven't
revisited it since I got it working. Basically the battery has an
array stored in its EEPROM that represents the empty level at various
temperature thresholds. What makes this complicated is that the array
does not contain all absolute values; just the first is absolute, and
the others are relative to it, in reverse order. The above code
converts it to an array of absolute values from low to high. I'm open
to suggestions about this one too.

Matt
