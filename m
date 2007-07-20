Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbXGTMt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbXGTMt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbXGTMtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:49:19 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4948 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999AbXGTMtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:49:18 -0400
Date: Fri, 20 Jul 2007 14:49:40 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH/RFC] msleep() with hrtimers 
In-Reply-To: <28799.1184607969@lwn.net>
Message-ID: <Pine.LNX.4.64.0707201332530.1817@scrub.home>
References: <28799.1184607969@lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Jonathan Corbet wrote:

> > That's a bit my problem - we have to consider other setups as well.
> > Is it worth converting all msleep users behind their back or should we 
> > just a provide a separate function for those who care?
> 
> Any additional overhead is clearly small - enough not to disrupt a *high
> resolution* timer, after all.

If you use already high resolution timer, you also need a fast time 
source, so that in this case it indeed doesn't matter much how you sleep.

>  And msleep() is used mostly during
> initialization time.  My box had a few hundred calls, almost all during
> boot.  Any cost will be bounded by the fact that, well, it sleeps for
> milliseconds on every call.

Well, there are over 1500 msleep calls, so I'm not sure they're mostly 
during initialization.

> I'm not *that* attached to this patch; if it causes heartburn we can
> just forget it.  But I had thought it might be useful...

I'm not against using hrtimer in drivers, if you add a hrsleep() function 
and use that, that would be perfectly fine.
The really important point is to keep our APIs clean, so it's obvious who 
is using what. The requirements for both timers are different, so there 
should be a choice in what to use.

> > Which driver is this? I'd like to look at this, in case there's some other 
> > hidden problem. 
> 
> drivers/media/video/cafe_ccic.c, and cafe_smbus_write_data() in
> particular.  The "hidden problem," though, is that the hardware has
> periods where reading the status registers will send it off into its
> room where it will hide under its bed and never come out.

It's indeed not a trivial problem, as it's not localized to the driver 
(the request comes from generic code).
The most elegant and general solution might be to move such initialization 
sequences into a separate thread, where they don't hold up the rest.

> My understanding is that the current dyntick code only turns off the
> tick during idle periods; while things are running it's business as
> usual.  Perhaps I misunderstood?

jiffies needs to be updated, theoretically one could reduce the timer 
tick even then, but one has to be careful about the increased resolution, 
so jiffies+1 isn't enough anymore to round it up.
In general it's doable by further cleaning up our APIs, but here it's 
really important to keep the APIs clean to keep Linux running on a wide 
range of hardware. It should be clear whether one requests a low 
resolution, but low overhead timer or a high resolution and more precise 
timer (and _please_ ignore that "likely to expire" stuff).
It's e.g. a possibility to map everything to high resolution timer on a 
hardware, which can deal with this, but on other hardware that's not
possible without paying a significant price.

bye, Roman
