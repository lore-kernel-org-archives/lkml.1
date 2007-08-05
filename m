Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbXHEN7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbXHEN7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 09:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXHEN7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 09:59:36 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:11825 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbXHEN7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 09:59:36 -0400
Date: Sun, 5 Aug 2007 09:55:00 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
Message-ID: <20070805135500.GF6221@jupiter.solarsys.private>
References: <46B5B290.4040907@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B5B290.4040907@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan:

* Stefan Richter <stefanr@s5r6.in-berlin.de> [2007-08-05 13:20:48 +0200]:
> Now that I booted from 2.6.22-rc5 to 2.6.23-rc2 I noticed that ksensors
> displayed 1/16 of the actual speed of the CPU fan (correct is ca. 1400
> RPM under light load) and 0 for the case fan (correct is ca. 480 RPM
> under light load).
> 
> I reverted patch
> 	hwmon/w83627ehf: No need to initialize fan_min
> and the behaviour changed as follows:  ksensors displays the correct CPU
> fan speed when loaded for the first time after the w83627ehf was loaded,
> then drops to 1/16th the next time it refreshes the display.  (I
> configured 30s update interval in ksensors.)  But the case fan's speed
> is now correctly displayed all the time.  Ksensors' fan speed
> multipliers are configured as 1.
> 
> I then also reverted
> 	hwmon/w83627ehf: Be quiet when no chip is found
> 	hwmon/w83627ehf: Export the thermal sensor types
> 	hwmon/w83627ehf: Enable VBAT monitoring
> 	hwmon/w83627ehf: Add support for the VID inputs
> 	hwmon/w83627ehf: Fix timing issues
> 	hwmon/w83627ehf: Add error messages for two error cases
> one after another but it didn't change anything.  More surprisingly, if
> I put all patches including "No need to initialize fan_min" back in, the
> behaviour remains like after referting that single patch, i.e. wrong CPU
> fan speed after first display update, correct case fan speed.  I didn't
> reboot between tests though, I only unloaded and reloaded w83627ehf.

It's not always sufficient to just reload the driver, especially when it's an
initialization problem as yours seems to be.  So what you're seeing there is
not too surprising.

> I wasn't able to revert
> 	hwmon/w83627ehf: Convert to a platform driver
> to something that compiles but I didn't try very hard.

That's because a later patch removes the i2c-isa support on which this driver
depends, prior to this patch.  If you can use git to back up, that would be
easier.

That said, I doubt the "Convert to a platform driver" is the problem.  It's
more likely the patch before that:

	hwmon/w83627ehf: Preserve speed reading when changing fan min

I'll reexamine the patch series here.  If you have time, it would help if you
could do a git bisect.  Use this command:

$ git bisect start v2.6.23-rc2 v2.6.22-rc5 drivers/hwmon/w83627ehf.c

Doing it this way will force you to reboot between tests; I think we would
need that anyway.

> Kernel messages when I load the drivers:
> w83627ehf: unsupported chip ID: 0xffff
> w83627ehf: Found W83627EHG chip at 0x290
> The former message is normally suppressed by patch "Be quiet when no
> chip is found".  Mainboard is an MSI 945GT Speedster-A4R, userland is
> Gentoo's lm_sensors-2.10.1 and ksensors-0.7.3.
> 
> Booting back into 2.6.22-rc5 (which seems identical with 2.6.22 as far
> as w83627ehf is concerned) brings back the correct fan speeds.

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

