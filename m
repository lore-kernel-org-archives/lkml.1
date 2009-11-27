Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbZK0ND2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbZK0ND2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZK0ND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:03:28 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54850 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbZK0ND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:03:27 -0500
X-Sasl-enc: rjUZuuXzcptQxL8+nFchGFogkbY8+ya0JkP5JJx1uYWk 1259327012
Message-ID: <4B0FCE21.9070007@ladisch.de>
Date: Fri, 27 Nov 2009 14:03:29 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3] k10temp: temperature sensor for AMD Family 10h/11h
 CPUs
References: <4AF91F70.10106@ladisch.de>	<4B06501B.8080509@ladisch.de>	<87ws1l5wcl.fsf@depni.sinp.msu.ru>	<4B0673D7.5010006@ladisch.de>	<20091120123016.19d98ab4@hyperion.delvare>	<4B068402.7020606@ladisch.de>	<20091120131855.7f8f8722@hyperion.delvare>	<4B0A3DB6.9090703@ladisch.de>	<20091123145154.5b2b5735@hyperion.delvare>	<4B0AAA55.3040702@ladisch.de>	<20091123200527.1114cbc2@hyperion.delvare>	<4B0B9CB1.3090808@ladisch.de>	<20091124142654.76f4d166@hyperion.delvare>	<4B0BE935.1050708@ladisch.de>	<20091124211134.12971937@hyperion.delvare>	<4B0CFE2A.6010008@ladisch.de> <20091126214429.6ac22d3f@hyperion.delvare>
In-Reply-To: <20091126214429.6ac22d3f@hyperion.delvare>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Wed, 25 Nov 2009 10:51:38 +0100, Clemens Ladisch wrote:
> > temp1_input: -1000
> > temp1_max: 40000
> > temp1_relative: 0
> > Should the values be labeled as "1 °C below normal" and "40 °C above
> > normal", and how should the application know that 0 is to be labeled
> > "normal"?  It might make more sense to display the temperature just as
> > "41 °C below max", in which case the actual value of temp1_relative is
> > not used at all.
> 
> Except that there may be no temp1_max, just a temperature value
> relative to the "normal" operating point of the CPU. In that case we
> can't fallback to the max limit.
> 
> Even your initial proposal doesn't work there yet: the hwmon interface
> has no standard name for "normal operating temperature", so we can't put
> that name in temp#_relative. [...]
> If the base has a meaning (normal operating temperature, or critical
> temperature, etc.) we have to let the user know somehow.

I chose that example because "normal" does not exist; and it's a bad
example because "normal" actually has a meaning.

Better take the AMD CPUs: The base of all relative values is zero (by
definition), _not_ 70000, and the meaning of that base is just "70 °C
below the temperature at which the processor wants 100% cooling".  This
base value is meaningless for any monitoring purposes.

If any point on the scale has a meaning, it should be reported with some
temp#_whatever file.  However, the base itself does not necessarily have
any meaning.

As long as we have some corresponding _max or _crit limit that can be
used for comparisons, we do not need a base value.  Only if there is
no known predefined limit do we need a temp#_relative value.

> Or maybe create a new label (temp#_relative_label or similar) but I'm
> not sure how we would integrate this into libsensors and applications.
> In particular I am worried about translation issues if we make the
> drivers too verbose.

All known CPUs with relative temperature scale also have known _max
limits, and I don't think that a CPU with relative scale and both
unknown _max and _crit will ever be designed.  In other words,
temp#_relative* is not needed at the moment.  I think we should not
try to define how the semantics of such an unknown scale can be
described.

> > > Additionally it wouldn't fit in libsensors as it exists today.
> > 
> > Then the best bet would probably be an entry like temp#_unit, with
> > 0 = absolute °C (default); 1 = relative °C or °K; other values
> > "unknown".  Even if some silly scale is introduced later, applications
> > that read this entry then know that they must not display a unit like °C
> > for unknown unit specifications.
> 
> This could work, yes. Note that current drivers and libsensors don't
> have/know about this file yet, and they generally use an absolute °C
> scale. So the absence of temp#_unit file would be interpreted exactly
> as if the file was there and contained value 0.
> 
> (I'd rather name that file temp#_scale - but that's an implementation
> detail.)

Like this?

--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -314,6 +314,19 @@ temp_reset_history
 		Reset temp_lowest and temp_highest for all sensors
 		WO
 
+temp[1-*]_scale	Temperature scale type.
+		Integer
+		RO
+		0: millidegrees Celsius (default if no _scale entry)
+		1: relative millidegrees Celsius; see below
+		2: millivolts; see below
+		other values: unknown
+		When scale=1 (relative), the temperature value 0 does not
+		correspond to zero degrees Celsius but to some unknown
+		temperature. In this case, temperate values should not be
+		interpreted or displayed as absolute values and make sense
+		only when compared to other values of the same channel.
+
 Some chips measure temperature using external thermistors and an ADC, and
 report the temperature measurement as a voltage. Converting this voltage
 back to a temperature (or the other way around for limits) requires


Hmm, which drivers use millivolt temperatures?


Best regards,
Clemens
