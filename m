Return-Path: <linux-kernel-owner+w=401wt.eu-S932917AbXHLJRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbXHLJRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXHLJQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:16:57 -0400
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:4231 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755223AbXHLJQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:16:56 -0400
Date: Sun, 12 Aug 2007 11:17:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
Message-ID: <20070812111713.1afb24c6@hyperion.delvare>
In-Reply-To: <46BDD8B3.8070708@s5r6.in-berlin.de>
References: <46B5B290.4040907@s5r6.in-berlin.de>
	<20070805162141.GI6221@jupiter.solarsys.private>
	<46B6053E.2050708@s5r6.in-berlin.de>
	<20070810230831.59cbc50f@hyperion.delvare>
	<46BCE6D0.7060300@s5r6.in-berlin.de>
	<20070811135705.0d0688d7@hyperion.delvare>
	<46BDD8B3.8070708@s5r6.in-berlin.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Sat, 11 Aug 2007 17:41:39 +0200, Stefan Richter wrote:
> While I test-booted 2.6.22(-rc) yesterday I had a look into the BIOS
> setup.  There is a fan speed control based on a temperature threshold,
> separately for CPU fan and case fan.  The thresholds are currently 55°C
> and 50°C respectively.

Hopefully it is programming the W83627EHG at boot time and no longer
touching it after that. You can check
in /sys/class/hwmon/hwmon*/device, some of the pwm*_enable files should
have value >= 2.

> During the time I spent in the BIOS setup, the CPU fan speed was
> displayed as something more than 1400, and the case fan speed was
> displayed as 0.  The latter is AFAIK typical with slow fans.

Correct.

> (...)
> I now updated to Gentoo's ksensors-0.7.3-r1 (which is v0.7.3 plus
> patches from Debian) and lm_sensors-2.10.4, added
> 
>     ignore fan5
>     set fan1_min    200
>     set fan2_min    1000
>     set fan3_min    0
> 
> to sensors.conf, compiled the drivers with CONFIG_HWMON_DEBUG_CHIP=y,
> and "sensors" alone seems to behave fine now.  Or maybe it did so
> already before that.  But as soon as I start "ksensors", "sensors" shows
> that the CPU fan divider suddenly changed from 8 to 128.  "sensors -s"
> will then cause the kernel to log
>     w83627ehf w83627ehf.656: fan2 clock divider changed from 128 to 8
>     w83627ehf w83627ehf.656: fan3 low limit and alarm disabled
> and sensors will show the correct CPU fan speed again --- but soon after
> that the divider will go up to 128 again if ksensors is running in parallel.
> 
> If I quit ksensors and run "sensors -s", sensors will continue to show
> correct speeds.  Actually with ksensors running, "while sensors | grep
> 'CPU Fan'; do sleep .2; done" shows that the CPU fan divider oscillates
> between 8 and 128 in ca. 5 seconds long periods:  16 times in a row it
> prints div = 8, and 8 times it prints div = 128, then div = 8 again, and
> so forth.  There are no dmesg messages during all that.
> 
> ksensors has different update interval settings, and although I had the
> w83627ehf readings configured to be updated every 30 seconds, some
> seemingly unrelated setting was at 5 seconds.  I changed that to 30
> seconds too and the period of above loop increased to ca. 30 seconds
> (127 times div = 8, 8 times div = 128).

Hmm. Is this "seemingly unrelated setting" the "Mainboard sensors"
panel? Maybe I get what's going on then. This panel gets the CPU
temperature from the ACPI "thermal" driver (/proc/acpi/thermal). Your report
suggests that the temperature value is taken from the W83627EHF's
temp2, which is in bank 1. If I am correct, then simply reading
from /proc/acpi/thermal/*/temperature would break the fan divider (when
my fixup patch isn't applied, that is.)

I recommend that you don't load the ACPI "thermal" driver together with
the w83627ehf driver, it won't give you any additional information and
the race condition that exists between both drivers can still result in
wrong values being reported from times to times (even with my patch.)

> So the BIOS seems innocent.

Good news.

One remaining mystery is why you did not observe the problem with the
older kernel. Maybe the ACPI thermal driver was not loaded (or not
working) back then?

-- 
Jean Delvare
