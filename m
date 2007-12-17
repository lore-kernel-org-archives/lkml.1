Return-Path: <linux-kernel-owner+w=401wt.eu-S1762820AbXLQGBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762820AbXLQGBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 01:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXLQGBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 01:01:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:65069 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbXLQGBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 01:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sNJTDZr6fEGoKX5X6r4t2OUKUm2FUJU7YbFIJ49ijw7FPdGqrXC9hZXqiQTvUTnezkwjQ6u/Ofbz/anMot+5wPTBBwZtJmxBArW1edJrAwxkoEfohjjE9slYCWf/u50qqaJ+eL/BDDXz1ffmvndB5HwEFo+KRBLLGhhBwxFxakY=
Date: Mon, 17 Dec 2007 08:51:23 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] power: RFC: introduce a new power API
Message-ID: <20071217055123.GA2274@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20071216212443.4a1fff3d@ephemeral> <1197858984.3798.201.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1197858984.3798.201.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andres, David,

Firstly, Andres, thank you for the efforts.

I quite foreseen what exactly you had in mind when we were
discussing the idea. With patches it's indeed easier to show
flaws of this approach.


On Sun, Dec 16, 2007 at 09:36:24PM -0500, David Woodhouse wrote:
> On Sun, 2007-12-16 at 21:24 -0500, Andres Salomon wrote:
> > This API has the power_supply drivers device their own device_attribute
> > list; I find this to be a lot more flexible and cleaner.  

I don't see how this is more flexible and cleaner. See below.

> > For example,
> > rather than having a function with a huge switch statement (as olpc_battery
> > currently has), we have separate callback functions.

Is this an improvement? Look into ds2760_battery.c. I scared to
imagine what it will look like after conversion.

As for olpc's "huge switch statement", it could be split into
functions _without_ drastic changes to PSY class. As the bonus,
you will get _inlining_ of these functions by gcc, because
there will be just single user of these functions. With
"exported-via-pointers" functions you can't do that.

You have tons of similar functions with similar functionality, that
only differs by the data source. That scheme was in the early PSY
class I posted here this summer. And I turned it down, fortunately.


On a bet, I can convert "huge switch statement" to nicely look switch
statement. It will as nice as ds2760's.

The problem isn't in the PSY class.

> > We're not limited
> > to drivers only being able to pass 'int' and 'char*'s in sysfs,

You're not limited to "int" and "char *". Anything more than that
is unnecessary, so far.

> > we're
> > not forced to keep a global string around in memory (as is again the
> > case for olpc_battery's serial number code),

If battery chip can report strings, then you anyway must keep it in
the memory. The question is when to allocate memory and when to free
it. Side question is for how long to keep it.

Given that that string is small enough (dozen bytes), it's doesn't
matter for how long we'll allocate it. So, in most cases it's easy
to answer: allocate at probe, free at remove, so keep it for whole
battery lifetime. (In contrast, adding tons of functions will waste
_much more_ space than these dozen bytes!)


IIRC this is the main difficulty you're facing with current properties
approach. You've converted whole class to the something different..
but you didn't show a single user of that change. Sorry, olpc still
using hard-coded manufacturer string:

+static ssize_t olpc_bat_manufacturer(struct device *dev,
+               struct device_attribute *attr, char *buf)
+{
+       int ret;
+       uint8_t ec_byte;
+
+       ret = olpc_bat_get_status(&ec_byte);
+       if (ret)
+               return ret;
+
+       ec_byte = BAT_ADDR_MFR_TYPE;
+       ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+       if (ret)
+               return ret;

+       switch (ec_byte >> 4) {
+       case 1:
+               strcpy(buf, "Gold Peak");
                break;
+       case 2:
+               strcpy(buf, "BYD");
                break;
+       default:
+               strcpy(buf, "Unknown");
                break;
+       }
+
+       return ret;
+}

In other words: all these strings can and should be static. Why
spend cpu cycles on strcpy'ing things that can be not strcpy'ed?

I don't see S/N function. I'm sure it could be implemented easily
using today's properties approach.

> > we don't have ordering
> > restrictions w/ the return value being interpreted based upon where it's
> > located in the array... etc.  

What exact "restrictions" you're talking about? There are no
restrictions per se.

> > The other API seems to encourage driver
> > authors to get their custom sysfs knobs into the list of sysfs knobs, and
> > this one doesn't.

Yes, API is encouraging to add knobs, but not just any knobs. Only
ones that make sense as a property of a PSY (opposite to some kind
property of PSY driver itself). The count of such properties is
limited, physically.

I'm recalling question about raw data. No, PSY class isn't for raw
data you're getting from the firmware. Implement driver-specific
binary attribute, that will contain device-specific raw data.
Ideally, you should not export raw data at all (though, good idea
is to export them into the debugfs).

> > If there is interest in this API, I'll convert the rest of the power_supply
> > drivers over to it and resubmit patches.
> 
> Looks sane enough to me.

Heh..

> If Anton has no objections, I'll merge it.

Sorry, lots of objections.

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
