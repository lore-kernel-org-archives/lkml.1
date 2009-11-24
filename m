Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbZKXULc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbZKXULc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbZKXULb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:11:31 -0500
Received: from bamako.nerim.net ([62.4.17.28]:49683 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932864AbZKXULb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:11:31 -0500
Date: Tue, 24 Nov 2009 21:11:34 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3] k10temp: temperature sensor for AMD Family 10h/11h 
 CPUs
Message-ID: <20091124211134.12971937@hyperion.delvare>
In-Reply-To: <4B0BE935.1050708@ladisch.de>
References: <4AF91F70.10106@ladisch.de>
	<4B06501B.8080509@ladisch.de>
	<87ws1l5wcl.fsf@depni.sinp.msu.ru>
	<4B0673D7.5010006@ladisch.de>
	<20091120123016.19d98ab4@hyperion.delvare>
	<4B068402.7020606@ladisch.de>
	<20091120131855.7f8f8722@hyperion.delvare>
	<4B0A3DB6.9090703@ladisch.de>
	<20091123145154.5b2b5735@hyperion.delvare>
	<4B0AAA55.3040702@ladisch.de>
	<20091123200527.1114cbc2@hyperion.delvare>
	<4B0B9CB1.3090808@ladisch.de>
	<20091124142654.76f4d166@hyperion.delvare>
	<4B0BE935.1050708@ladisch.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 15:09:57 +0100, Clemens Ladisch wrote:
> Jean Delvare wrote:
> > On Tue, 24 Nov 2009 09:43:29 +0100, Clemens Ladisch wrote:
> > > In any case, it might make more sense to show such values as something
> > > like "20 °C below maximum".
> > 
> > I think so, yes. Now the difficulty is to come up with a suitable sysfs
> > interface. Dropping the current interface altogether doesn't sound
> > right as it will take time before a new version of libsensors is
> > written and spread out and all applications add support for the new
> > interface. In the meantime, I guess we want users to still see the
> > approximate value.
> 
> k10temp is a new driver, so no old systems would break if it introduced
> a new class of measurements with names like, e.g., reltemp#_*.

I wasn't necessarily thinking of k10temp breaking a working system,
more of k10temp just not working on current systems (if we don't opt
for parallel implementations.) And there's also the coretemp case,
where we report relative values in some cases; that case would fit in
what we're discussing now, so we would modify an already existing
driver.

> We could add this in parallel with the old interface.  If we wanted to.

I think we want to, yes. I just don't know for how long.

> > So ideally we would come up with an interface that adds up to the one
> > we have currently. Future libsensors/applications could read the extra
> > information to display the value in a different format so that the
> > users see the difference.
> > 
> > An idea I have about this is adding a sysfs file temp#_relative, which
> > would contain the fake temperature value that is used as a reference
> > for the thermal sensor in question. In the case of k10temp, the value
> > would be 70000. So for example we would have:
> > 
> > temp1_input: 46000
> > temp1_relative: 70000
> > 
> > Old applications would display this as 46°C while new ones would
> > display "24°C below the limit".
> 
> In this case, temp1_relative is identical with temp1_max.  In the
> general case, there always must be some kind of limit (whether "max" or
> "crit" or something else) against which the values are measured,
> otherwise a relative value would not make sense.

I would love this to be true, but I can't see any reason why it would
have to be. I can easily imagine a CPU specification reading: "This
register contains a temperature value on an arbitrary scale; higher
values mean higher temperatures." I'm not claiming it would be
particularly useful... but if a CPU maker ever does this, don't we want
to support that? (This is a real question, maybe we don't.)

I really didn't expect the implementations we've seen in Intel Core or
AMD family 10h processors. So I wouldn't be surprised if future
implementations are different again.

> This means that one of the already existing limit values must be the
> reference base, so we'd need just a mechanism to specify which of them
> is it, i.e., "temp1_relative_base: max".  If we'd have
> "temp1_relative: 70000", the application would have to search among the
> limit values for one with the same value.

I fail to see why the application would care about this at all. When in
relative mode, all other values would be offset by the temp#_relative
value. But that value itself would not be displayed (it has no physical
value, otherwise we wouldn't be in absolute mode, would we?)

> (It doesn't really matter which one is the base, as all values are
> relative anyway, so we could just define that temp#_max is the base;
> so we'd have "temp1_relative: true").

This is taking flexibility away from us, for no benefit that I can see.
Am I missing something?

(Additionally it wouldn't fit in libsensors as it exists today. This
doesn't mean it can't be done, but the cost is higher, so it needs to
bring an significant improvement.)

> > It may not be considered flexible enough though... For example it does
> > not support sensors with totally arbitrary scales (where 1000 != 1°C.)
> 
> When the scale differs but is _known_, the driver can just rescale its
> internal register values to millidegrees.

Correct, and actually many drivers do that already. But the scale could
also be totally unknown (as in my theoretical example above), only
bounded by the register size (which would lead to pretty bad temp#_min
and _max IMHO.)

> When we have some scale like "0%...100%", that should probably be
> exported as "pwm#_target" or something like that.

That would be difficult, as we generally don't know which pwm output,
if any, is related to a given CPU. ACPI may know more, but the ACPI
interface to cooling zones and temperatures is very limited IMHO, and
hard to connect to physical devices, I doubt we can get anything usable
out of it. And anyway, deciding that cooling must be somehow
proportional to temperature is pretty arbitrary and doesn't match what
I've seen people do so far.

-- 
Jean Delvare
