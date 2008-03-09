Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYCILLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYCILLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 07:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYCILK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 07:10:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52529 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751525AbYCILK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 07:10:57 -0400
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200803071943.14805.david-b@pacbell.net>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main>
	 <200803071943.14805.david-b@pacbell.net>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 11:10:53 +0000
Message-Id: <1205061053.13653.114.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 19:43 -0800, David Brownell wrote:
> On Thursday 06 March 2008, Liam Girdwood wrote:
> > +static inline int uA_to_A(int uA) { return uA / 1000000; }
> 
> So:  999999 uA == 0A ... should DIV_ROUND_UP() or another
> rounding function be involved in some of these conversions?
>  
> Or maybe the dividing conversions should not be provided, and
> code should just be doing math in units that don't encourage
> such problems to appear.  I don't think one rounding policy
> can fit all (including truncation, as above).
> 

ok, this sounds like the best approach.

> 
> > +struct regulator *__must_check regulator_get(struct device *dev,
> > +                                            const char *id);
> 
> The semantics of "id" and "dev" are unspecified in this patch,
> so this isn't a good definition of the consumer interface!
> 

'id' is really the regulator name and will be renamed in the next patch.

> Plus, that works more like a "lookup" than a "get" ... the
> usual convention is that "get" and "put" update refcounts.
> But I think I see an assumption here that a regulator may
> have only one user...

A regulator only has one user as it's used to store some device specific
power data. However, a regulator_dev has many users. I'll add a refcount
on get/put.

> 
> 
> > +int regulator_set_voltage(struct regulator *regulator, int uV);
> 
> You described a mode where consumers could set ranges that
> might overlap (e.g. 1.6 to 1.9V, 1.8 to 2.0) and the result
> would be some compatible result.  But I don't see how that
> could be achieved, since that's the only call to provide
> a consumer's constraints.

In this example the power domain constraint (not consumer constraint)
would be 1.6 - > 2.0 V. i.e. this range is safe for all consumers on
this domain as all can operate at 2.0V and some can operate as low as
1.6V.

The actual regulator output will be determined by consumer voltage
requests. e.g. On power domain A, consumer x sets 1.8V and consumer y
sets 1.9V, hence regulator output will be 1.9V. (as y needs 1.9 to
operate, but x can operate at 1.8 - 2.0)


> 
> Presumably one configures a voltage then enables it?  How
> does one turn a voltage supply on or off?  I'm guessing
> that zero volts doesn't equate to "off"...

Some regulators cant go down as far as 0V ;)

We have regulator_enable() and regulator_disable() to turn on and off
regulator output.

e.g. set voltage -> enable -> do some stuff -> disable. 

> 
> Something that's lacking here is simple examples.  Like:  how
> do I get the power supply associated with an MMC/SD card socket,
> turn it on (to, say, 3V3), set it to supply a different voltage
> (maybe 1V8), then turn it off? 

I have some examples in my git tree :-

backlight

http://opensource.wolfsonmicro.com/cgi-bin/gitweb.cgi?p=linux-2.6-audioplus.git;a=blob;f=drivers/video/backlight/wm8350_bl.c;h=ce79cf008b0e830be91c98fac0fb845efb767aa5;hb=imx31

LED's

http://opensource.wolfsonmicro.com/cgi-bin/gitweb.cgi?p=linux-2.6-audioplus.git;a=blob;f=drivers/leds/leds-wm8350.c;h=e46156439efd3f63e1bc0af9bc96fe6e855a22c2;hb=imx31

CPUfreq

http://opensource.wolfsonmicro.com/cgi-bin/gitweb.cgi?p=linux-2.6-audioplus.git;a=blob;f=arch/arm/mach-mx3/cpufreq.c;h=c6539737105c64b336cbb4f068b7ad20e918bca6;hb=imx31

Audio

http://opensource.wolfsonmicro.com/cgi-bin/gitweb.cgi?p=linux-2.6-audioplus.git;a=blob;f=sound/soc/imx/imx32ads-wm8350.c;h=4dcb3619e6152959f7d6f26e2febf1b0a688bf86;hb=imx31


In most cases we are passing the power supply name to the consumer
driver as platform data. e.g.

struct wm8350_led_platform_data wm8350_led_data = {
	.name		= "wm8350:white",
	.default_trigger	= "heartbeat",
	.isink		= WM8350_ISINK_A,
	.dcdc		= WM8350_DCDC_5,
	.voltage_ramp	= WM8350_DC5_RMP_20V,
	.retries	= 5,
	.half_value	= 9863,
	.full_value	= 27898,
};


>  How would I cope with that
> voltage supply being shared by two sockets, with cards that may
> support different voltage ranges and have different current
> requirements?  (Configurations of interest include two cards
> that can coexist at 1V8, and two that can't ... one might not
> support 1V8, or it might demand too much power.  Also, zero
> and one cards present.)

In this case the MMC/SD power domain would be 1V8 to 3V3 and it would be
upto the MMC/SD driver to ensure it didn't over voltage a 1V8 card with
3V3 in this case.  It would also be possible that the system designer
would assign each slot a separate regulator to provide max flexibility
in this case.

Liam

