Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXHKPmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXHKPmF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 11:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbXHKPly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 11:41:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42992 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbXHKPlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 11:41:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46BDD8B3.8070708@s5r6.in-berlin.de>
Date: Sat, 11 Aug 2007 17:41:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
References: <46B5B290.4040907@s5r6.in-berlin.de>	<20070805162141.GI6221@jupiter.solarsys.private>	<46B6053E.2050708@s5r6.in-berlin.de>	<20070810230831.59cbc50f@hyperion.delvare>	<46BCE6D0.7060300@s5r6.in-berlin.de> <20070811135705.0d0688d7@hyperion.delvare>
In-Reply-To: <20070811135705.0d0688d7@hyperion.delvare>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Sat, 11 Aug 2007 00:29:36 +0200, Stefan Richter wrote:
...
>> The motherboard controls the CPU fan and I believe also the case fan,
>> probably based on temperatures.  (The manual is buried somewhere and
>> MSI's download site is down right in this moment.)
> 
> I would like to know what it is doing exactly, and how. Can this
> feature be disabled? If the BIOS accesses the W83627EHG chip in our
> back, this can cause lots of trouble, such as what you are seeing.

While I test-booted 2.6.22(-rc) yesterday I had a look into the BIOS
setup.  There is a fan speed control based on a temperature threshold,
separately for CPU fan and case fan.  The thresholds are currently 55°C
and 50°C respectively.

During the time I spent in the BIOS setup, the CPU fan speed was
displayed as something more than 1400, and the case fan speed was
displayed as 0.  The latter is AFAIK typical with slow fans.

...
>> When I now re-run sensors I get
>> ...
>> Case Fan:  484 RPM  (min = 12053 RPM, div = 16) ALARM
[instead of what was shown a minute before:
   Case Fan:    0 RPM  (min =  753 RPM, div = 128) ALARM]
>> CPU Fan:    89 RPM  (min =  659 RPM, div = 64) ALARM
>> Aux Fan:     0 RPM  (min = 10546 RPM, div = 128) ALARM
>> fan5:        0 RPM  (min = 1506 RPM, div = 128) ALARM
>> ...
>>
>> (I'm still in 2.6.23-rc2.  Ksensors picked the 484 RPM of the case fan
>> up too, and that's most certainly the correct speed.  Just the CPU fan's
>> speed is still wrong; or rather its divider should be 16 rather than 64.)
> 
> Divider should be 4,not 16, methinks.

Yes, years of reliance on pocket calculators did that to me.

> You can dump the chip registers using the following command:
> isadump 0x295 0x296
> From now on, whenever you paste the output of "sensors", please dump
> the contents of the chip too and include the output.
> 
>>> Other than that, I can only ask for the same things Mark already
>>> suggested: compile with HWMON debugging and provide the logs (this will
>>> show what fan div the driver is trying to select), and try bisecting
>>> using git to find out which patch exactly caused the problem.
>> How comes the divider of one of the fans changed from one minute to the
>> other?
> 
> No idea. The new driver can only increase, not decrease, the clock
> divider when you poll for a speed value. So the change above (from 128
> to 16) is not supposed to happen. However... I also can't explain why
> the original reading is 0 (with div=128). A reading of 0 only happens
> if the divider is too low (i.e. less than 16.) If the driver increased
> the divider to 16, it means that it was previously 8, not 128.
> 
> Now, given how dividers are encoded:
> 128 -> 111b
>  64 -> 110b
>   8 -> 011b
>   4 -> 010b
> 
> See the pattern? The case fan's clock divider reads 128 when it is 8,
> the CPU fan's clock divider reads 64 when it is 4. In both cases, it is
> the most significant bit that is wrong. And it happens that this bit is
> in a separate register (VBAT, 0x5d), which happens to be in the banked
> register range of the W83627EHG (0x50-0x5f).
> 
> So my theory is that something else (BIOS, ACPI?) is changing the bank,
> probably to read temperature values which are in banks 1 and 2, causing
> the w83627ehf to get a wrong value for the VBAT register. If I am
> right, then the attached patch should help. Please give it a try and
> report.

Will try it in a minute.

> Mark: the previous version of the driver was initializing the fan mins.
> This wasn't needed, however the bank was reset to 0 as a side effect
> when initializing fan5_min. When removing the unneeded code, I caused
> the initial bank value to become undefined. This explains in part the
> odd behavior reported by Stefan. The fix is to either set the bank to 0
> explicitly on driver load, or to stop assuming that bank is 0 by
> default. My patch does the latter, as it might also help in case
> something is later doing concurrent accesses to the chip.
> 
>> FWIW, the ``chip "w83627ehf-*"´´ section in Gentoo's /etc/sensors.conf
>> provides only labels for fan{1,2,3}. It is titled
>> # Winbond W83627EHF configuration originally contributed by Leon Moonen
>> # This is for an Asus P5P800, voltages for A8V-E SE.
> 
> This is from the standard default sensors configuration file. It is
> expected that you tweak the labels, limits etc. to match your own
> motherboard.
> 
>> Should I hardwire correct dividers or pulse per rev in sensors.conf or
>> is the driver supposed to work the correct dividers out --- like it did
>> before 2.6.23-rc?
> 
> The driver is supposed to pick the best divider if you set the min fan
> speed limits properly (which it seems you didn't.) If you don't set the
> min limits, all the driver will do is increase the divider as long as
> it gets a 0 reading, so the dividers will be good, but not necessarily
> optimum.

I now updated to Gentoo's ksensors-0.7.3-r1 (which is v0.7.3 plus
patches from Debian) and lm_sensors-2.10.4, added

    ignore fan5
    set fan1_min    200
    set fan2_min    1000
    set fan3_min    0

to sensors.conf, compiled the drivers with CONFIG_HWMON_DEBUG_CHIP=y,
and "sensors" alone seems to behave fine now.  Or maybe it did so
already before that.  But as soon as I start "ksensors", "sensors" shows
that the CPU fan divider suddenly changed from 8 to 128.  "sensors -s"
will then cause the kernel to log
    w83627ehf w83627ehf.656: fan2 clock divider changed from 128 to 8
    w83627ehf w83627ehf.656: fan3 low limit and alarm disabled
and sensors will show the correct CPU fan speed again --- but soon after
that the divider will go up to 128 again if ksensors is running in parallel.

If I quit ksensors and run "sensors -s", sensors will continue to show
correct speeds.  Actually with ksensors running, "while sensors | grep
'CPU Fan'; do sleep .2; done" shows that the CPU fan divider oscillates
between 8 and 128 in ca. 5 seconds long periods:  16 times in a row it
prints div = 8, and 8 times it prints div = 128, then div = 8 again, and
so forth.  There are no dmesg messages during all that.

ksensors has different update interval settings, and although I had the
w83627ehf readings configured to be updated every 30 seconds, some
seemingly unrelated setting was at 5 seconds.  I changed that to 30
seconds too and the period of above loop increased to ca. 30 seconds
(127 times div = 8, 8 times div = 128).

So the BIOS seems innocent.
-- 
Stefan Richter
-=====-=-=== =--- -=-==
http://arcgraph.de/sr/
