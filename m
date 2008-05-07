Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbYEGUq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbYEGUq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYEGUqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:46:18 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63735 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751330AbYEGUqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:46:14 -0400
Date: Wed, 7 May 2008 21:43:53 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
       Jean Delvare <khali@linux-fr.org>, Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, i2c@lm-sensors.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [RFC][PATCH 1/4] RTC: Class device support for
 persistent clock
In-Reply-To: <1210148655.25560.825.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.55.0805072109090.25644@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070015360.16173@cliff.in.clinika.pl>
 <1210148655.25560.825.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, David Woodhouse wrote:

> Ooh, shiny -- you saved me the trouble of doing this (and hopefully also
> the trouble of looking through it to check whether all the callers of
> read_persistent_clock() can sleep, etc.?)

 :-)

 Yes, the generic callers of read_persistent_clock() seem to be fine.  I
have not dug into various pieces of platform code to check there though.  
I do hope platform maintainers enable these debugging checks from time to
time -- I mean especially those taking care of all these more or less
exotic systems and boards residing one level below generic architecture
support... ;-)

> One thing I was going to do in rtc_update_persistent_clock() was make it
> use mutex_trylock() for grabbing rtc->lock. We go to great lengths to
> make sure we're updating the clock at the correct time -- we don't want
> to be doing things which delay the update. So we should probably just
> use mutex_trylock() and abort the update (this time) if it fails.

 Good idea.

> I was also thinking of holding the RTC_HCTOSYS device open all the time,
> too. If it's a problem that you then couldn't unload the module, perhaps
> a sysfs interface to set/change/clear which device is used for this?

 I have thought of this and recognised the concern about modules.  I think
another possibility that could work with modules might be opening and
closing the device on demand.  But still it is just an optimisation, which
can certainly be done gradually on top of these changes without even
changing the interface.

 From the code structure's point of view it is certainly cleaner to open
and close the device each time it is used and I think as such it is a good
starting point -- let's spoil it later. ;-)

> When we discussed it last week, Alessandro was concerned that the
> 'update at precisely 500ms past the second' rule was not universal to
> all RTC devices, although I'm not entirely sure. It might be worth
> moving that logic into a 'default' NTP-sync routine provided by the RTC
> class, so that if any strange devices exist which require different
> treatment, they can override that.

 Even better than that -- some devices may have better precision and 
require no strange handling.  For example this very M41T81 chip I am 
working with supports resolution up to .01s -- which means there is little 
point in trying to work out delays, etc. to get the clock written back at 
the right point, where we can easily obtain two levels of magnitude better 
a resolution by simply not discarding the sub-second part of a timestamp.  

 Of course for sub-second resolution of the RTC the interface of
read_persistent_clock() would have to be modified to return a struct
timespec; contrarily update_persistent_clock() is ready for that, but then
struct rtc_time plus rtc_read_time(), rtc_set_mmss() and rtc_set_time()  
will still have to be updated accordingly.

 BTW, this chip is even better than that, because it can be disciplined --
there is a five-bit calibration register that lets one add or remove
oscillator ticks to/from the input at a certain stage of the divider chain
-- that could be used by the NTP daemon or tools like `hwclock --adjust'
somehow.  It's just an idea -- I have not investigated it further.

> I wouldn't worry too much about leaving the old
> update_persistent_clock() and read_persistent_clock() -- I hope we can
> plan to remove those entirely in favour of the RTC class methods.

 Yes, that I would consider a reasonable long-term plan, but it will take
at least a short while during which it might not be a good idea to break
all the platforms that have not got converted yet.  Especially as, however
unbelievable it may sound, unlike myself I think most people do not
consider the Broadcom SWARM the most obvious platform to use and/or
support.

  Maciej
