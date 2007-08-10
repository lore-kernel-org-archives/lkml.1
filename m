Return-Path: <linux-kernel-owner+w=401wt.eu-S933440AbXHJWag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbXHJWag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXHJWaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:30:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51762 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXHJWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:30:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46BCE6D0.7060300@s5r6.in-berlin.de>
Date: Sat, 11 Aug 2007 00:29:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
References: <46B5B290.4040907@s5r6.in-berlin.de>	<20070805162141.GI6221@jupiter.solarsys.private>	<46B6053E.2050708@s5r6.in-berlin.de> <20070810230831.59cbc50f@hyperion.delvare>
In-Reply-To: <20070810230831.59cbc50f@hyperion.delvare>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> I just tried 2.6.23-rc2 on a system where I use the w83627ehf hardware
> monitoring driver, and was not able to reproduce the problem you
> described. Fan speeds are reported properly for me. Which I kind of
> expected, as I tested all my w83627ehf patches on this system before
> submitting them.

Thanks that you are still after it.  I was busy with other stuff the
whole week, hence no git bisect result from me yet.

> Please try using sensors instead of ksensors, and confirm that the
> behavior is the same. I'd like to rule out a problem in ksensors
> itself. sensors will also report the fan divs, this is a useful
> information given the problem you have.

# sensors
w83627ehf-isa-0290
Adapter: ISA adapter
VCore:     +0.95 V  (min =  +0.00 V, max =  +1.74 V)
in1:      +12.30 V  (min =  +1.64 V, max =  +3.22 V) ALARM
AVCC:      +3.28 V  (min =  +1.89 V, max =  +1.94 V) ALARM
3VCC:      +3.26 V  (min =  +0.18 V, max =  +0.72 V) ALARM
in4:       +1.58 V  (min =  +0.57 V, max =  +0.90 V) ALARM
in5:       +1.70 V  (min =  +0.41 V, max =  +1.19 V) ALARM
in6:       +3.43 V  (min =  +0.31 V, max =  +3.05 V) ALARM
VSB:       +3.25 V  (min =  +0.37 V, max =  +3.01 V) ALARM
VBAT:      +3.18 V  (min =  +3.94 V, max =  +0.74 V) ALARM
in9:       +1.88 V  (min =  +0.79 V, max =  +1.40 V) ALARM
Case Fan:    0 RPM  (min =  753 RPM, div = 128) ALARM
CPU Fan:    88 RPM  (min =  659 RPM, div = 64) ALARM
Aux Fan:     0 RPM  (min = 10546 RPM, div = 128) ALARM
fan5:        0 RPM  (min =  753 RPM, div = 128) ALARM
Sys Temp:    +44 C  (high =    -5 C, hyst =   -34 C)   ALARM
CPU Temp:  +38.0 C  (high = +80.0 C, hyst = +75.0 C)
AUX Temp:  +43.5 C  (high = +80.0 C, hyst = +75.0 C)

coretemp-isa-0000
Adapter: ISA adapter

coretemp-isa-0001
Adapter: ISA adapter

(The aux fan and fan5 are not connected.)

> Your original post suggests that the fan speed is supposed to change
> depending on the system load? Or temperature? Please describe the
> mechanism used to achieve this. Could it be that this mechanism isn't
> working properly, and the reported (low) speeds are actually true?

The motherboard controls the CPU fan and I believe also the case fan,
probably based on temperatures.  (The manual is buried somewhere and
MSI's download site is down right in this moment.)

The low speeds or the dividers incorrect.  I'll reboot in a minute into
2.6.22(-rc5)  and post the "sensors" output.

> What fan inputs are used by your CPU and system fans? "sensors
> -c /dev/null" will tell.

...
fan1:      484 RPM  (min = 12053 RPM, div = 16) ALARM
fan2:       89 RPM  (min =  659 RPM, div = 64) ALARM
fan3:        0 RPM  (min = 10546 RPM, div = 128) ALARM
fan5:        0 RPM  (min = 1506 RPM, div = 128) ALARM
...

Hmm, interesting.  When I now re-run sensors I get
...
Case Fan:  484 RPM  (min = 12053 RPM, div = 16) ALARM
CPU Fan:    89 RPM  (min =  659 RPM, div = 64) ALARM
Aux Fan:     0 RPM  (min = 10546 RPM, div = 128) ALARM
fan5:        0 RPM  (min = 1506 RPM, div = 128) ALARM
...

(I'm still in 2.6.23-rc2.  Ksensors picked the 484 RPM of the case fan
up too, and that's most certainly the correct speed.  Just the CPU fan's
speed is still wrong; or rather its divider should be 16 rather than 64.)

> Other than that, I can only ask for the same things Mark already
> suggested: compile with HWMON debugging and provide the logs (this will
> show what fan div the driver is trying to select), and try bisecting
> using git to find out which patch exactly caused the problem.

How comes the divider of one of the fans changed from one minute to the
other?

FWIW, the ``chip "w83627ehf-*"´´ section in Gentoo's /etc/sensors.conf
provides only labels for fan{1,2,3}. It is titled
# Winbond W83627EHF configuration originally contributed by Leon Moonen
# This is for an Asus P5P800, voltages for A8V-E SE.

Should I hardwire correct dividers or pulse per rev in sensors.conf or
is the driver supposed to work the correct dividers out --- like it did
before 2.6.23-rc?
-- 
Stefan Richter
-=====-=-=== =--- -=-==
http://arcgraph.de/sr/
