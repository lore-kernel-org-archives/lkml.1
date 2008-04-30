Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbYD3HCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbYD3HCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYD3HCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:02:10 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:49091 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752381AbYD3HCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:02:09 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-29.messagelabs.com!1209538925!12945013!6
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Wed, 30 Apr 2008 08:54:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: David Brownell <david-b@pacbell.net>
CC: Alessandro Zummo <a.zummo@towertech.it>, <linux-kernel@vger.kernel.org>
Subject: Re: rtc: how should I handle an invalid state?
Message-ID: <20080430065457.GB9977@digi.com>
References: <20080429121924.GA2137@digi.com> <200804291212.40638.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804291212.40638.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 30 Apr 2008 06:54:57.0800 (UTC) FILETIME=[1A478880:01C8AA8F]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15880.004
X-TM-AS-Result: No--25.991400-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

David Brownell wrote:
> On Tuesday 29 April 2008, Uwe Kleine-König wrote:
> > The problem is that hwclock tries to read the current time before
> > setting the new one.  And if that fails, it doesn't update the rtc.
> 
> Which version of hwclock?  That does seem like a bug in that
> particular version.  If it's in util-linux-ng or busybox,
> please send in a patch.  I don't think anyone should be
> deploying *new* systems using *old/unmaintained* util-linux.
This is hwclock from Debian/stable (i.e. 2.12r-19etch1).  With
Debian/unstables (2.13.1-5) this happens to:

	sh-3.1# /sbin/hwclock --systohc -D
	hwclock from util-linux-ng 2.13.1
	Using /dev interface to clock.
	Last drift adjustment done at 1209474623 seconds after 1969
	Last calibration done at 1209474623 seconds after 1969
	Hardware clock is on local time
	Assuming hardware clock is kept in local time.
	Waiting for clock tick...
	/dev/rtc does not have interrupt functions. Waiting in loop for time from /dev/rtc to change
	RTC_RD_TIME: Invalid argument
	ioctl() to /dev/rtc to read the time failed.

Oh, there is a new version in Debian/unstable (2.14~rc1-1), nothing new
though:

	sh-3.1# /sbin/hwclock --systohc -D
	hwclock from util-linux-ng 2.14-rc1
	Using /dev interface to clock.
	Last drift adjustment done at 1209474623 seconds after 1969
	Last calibration done at 1209474623 seconds after 1969
	Hardware clock is on local time
	Assuming hardware clock is kept in local time.
	Waiting for clock tick...
	/dev/rtc does not have interrupt functions. Waiting in loop for time from /dev/rtc to change
	RTC_RD_TIME: Invalid argument
	ioctl() to /dev/rtc to read the time failed.


I looked a bit in the source of hwclock (from unstable) and IMHO it does
strange things.  E.g. I wouldn't do

	if (getuid() != 0 && systohc) {
		fprintf(stderr,
			_("Sorry, only the superuser can change "
			  "the Hardware Clock.\n"));
		permitted = FALSE;
	}

I wonder further why do_rtc_read_ioctl has a return type of int if it is
unchecked in read_hardware_clock_rtc which unconditionally returns 0.
(Ah, OK, do_rtc_read_ioctl always returns 0, if there is an error,
exit() is called.  Nice.)

Anyhow ...

Ah, reading the hwclock is necessary to adjust /etc/adjtime.  So the
correct way to set the hwclock is 

	# /sbin/hwclock --systohc -D --noadjfile --utc

But as you already suspect, this doesn't help either.

I'll write a bugreport to Debian as I now don't fancy to work with that
piece of code anymore. :(

> I'll suspect this is on some util-linux version, since I'm
> quite sure that I've had busybox based systems that don't
> show this misbehavior.
Right, the busybox I have here behaves fine.

>                         Haven't had occasion to use non-PC
> RTCs with a util-linux-ng version; I wouldn't call a bug in
> such combinations a kernel regression, either...
> 
> I think the preferred solution never returns invalid times as
> valid.  Some RTC drivers do this themselves:
> 
>         int my_rtc_read_time(struct device *dev, struct rtc_time *time)
> 	{
> 		... read the hardware into *time ...
> 		return rtc_valid_tm(time);
> 	}
> 
> Or rtc_valid_tm() might be checked in the RTC framework glue,
> to provide more uniform behavior at the framework level.
Currently it doesn't, the ioctl function for RTC_RD_TIME simply does:

	err = rtc_read_time(rtc, &tm);
	if (err < 0)
		return err;

	if (copy_to_user(uarg, &tm, sizeof(tm)))
		return -EFAULT;

	...

	return err;

> Either way, it's not unknown that an un-initialized RTC have
> undefined state, and thus return invalid times until they've
> been set (using wall clock, NTP, or whatever).
For my rtc it's even better:  There are two flags that indicate that
the clock is running and the time is valid.  So I can do

	if (!clock_is_running || !time_is_valid)
		return -EINVAL;
	else
		readtime(&tm)
		return 0;

I remember that the rx8025, an rtc I wrote a driver for some time ago,
had something similar.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
