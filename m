Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbZKXOJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbZKXOJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932972AbZKXOJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:09:55 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56332 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932956AbZKXOJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:09:54 -0500
X-Sasl-enc: I26wPUrqQ74XMPVtIIN6YOohmygWdSbAWu8WyZsqgH20 1259071799
Message-ID: <4B0BE935.1050708@ladisch.de>
Date: Tue, 24 Nov 2009 15:09:57 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Serge Belyshev <belyshev@depni.sinp.msu.ru>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3] k10temp: temperature sensor for AMD Family 10h/11h
 CPUs
References: <4AF91F70.10106@ladisch.de>	<4B06501B.8080509@ladisch.de>	<87ws1l5wcl.fsf@depni.sinp.msu.ru>	<4B0673D7.5010006@ladisch.de>	<20091120123016.19d98ab4@hyperion.delvare>	<4B068402.7020606@ladisch.de>	<20091120131855.7f8f8722@hyperion.delvare>	<4B0A3DB6.9090703@ladisch.de>	<20091123145154.5b2b5735@hyperion.delvare>	<4B0AAA55.3040702@ladisch.de>	<20091123200527.1114cbc2@hyperion.delvare>	<4B0B9CB1.3090808@ladisch.de> <20091124142654.76f4d166@hyperion.delvare>
In-Reply-To: <20091124142654.76f4d166@hyperion.delvare>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Tue, 24 Nov 2009 09:43:29 +0100, Clemens Ladisch wrote:
> > In any case, it might make more sense to show such values as something
> > like "20 °C below maximum".
> 
> I think so, yes. Now the difficulty is to come up with a suitable sysfs
> interface. Dropping the current interface altogether doesn't sound
> right as it will take time before a new version of libsensors is
> written and spread out and all applications add support for the new
> interface. In the meantime, I guess we want users to still see the
> approximate value.

k10temp is a new driver, so no old systems would break if it introduced
a new class of measurements with names like, e.g., reltemp#_*.
We could add this in parallel with the old interface.  If we wanted to.

> So ideally we would come up with an interface that adds up to the one
> we have currently. Future libsensors/applications could read the extra
> information to display the value in a different format so that the
> users see the difference.
> 
> An idea I have about this is adding a sysfs file temp#_relative, which
> would contain the fake temperature value that is used as a reference
> for the thermal sensor in question. In the case of k10temp, the value
> would be 70000. So for example we would have:
> 
> temp1_input: 46000
> temp1_relative: 70000
> 
> Old applications would display this as 46°C while new ones would
> display "24°C below the limit".

In this case, temp1_relative is identical with temp1_max.  In the
general case, there always must be some kind of limit (whether "max" or
"crit" or something else) against which the values are measured,
otherwise a relative value would not make sense.

This means that one of the already existing limit values must be the
reference base, so we'd need just a mechanism to specify which of them
is it, i.e., "temp1_relative_base: max".  If we'd have
"temp1_relative: 70000", the application would have to search among the
limit values for one with the same value.

(It doesn't really matter which one is the base, as all values are
relative anyway, so we could just define that temp#_max is the base;
so we'd have "temp1_relative: true").

> It may not be considered flexible enough though... For example it does
> not support sensors with totally arbitrary scales (where 1000 != 1°C.)

When the scale differs but is _known_, the driver can just rescale its
internal register values to millidegrees.

When we have some scale like "0%...100%", that should probably be
exported as "pwm#_target" or something like that.


Best regards,
Clemens
