Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYK1Vt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYK1Vt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 16:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYK1VtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 16:49:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:5266 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYK1VtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 16:49:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=qKsIpKctQYY7zxN/SriVzHp33M411bK4YNi4mGSG2kYHugvJ8Lrg8/z2HU23/5yU0h
         kWjFFlRGqXq+ssUIqoK5ekcNja7fBEDmSE9WXyQmUvyVuS6u5Vfc3N80ArAZ/b8Zv42K
         QrjHrTOxGnhllqK/oBFWO+mhXQg/HKLUhQUGU=
Message-ID: <cfd18e0f0811281349k4dafa1bdk16500af7e513460@mail.gmail.com>
Date: Fri, 28 Nov 2008 16:49:16 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: Document sysfs interface to RTC system wakeup
Cc: "kernel list" <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20081126161524.GD1983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081126161524.GD1983@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

Some comments and suggestions below.

On Wed, Nov 26, 2008 at 11:15 AM, Pavel Machek <pavel@suse.cz> wrote:
> diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
> index 8deffcd..ac843ab 100644
> --- a/Documentation/rtc.txt
> +++ b/Documentation/rtc.txt
> @@ -187,6 +187,88 @@ driver returns ENOIOCTLCMD.  Some common
>
>  If all else fails, check out the rtc-test.c driver!
>
> +           Even newer /sys interface
> +           ~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +tino.keitel@gmx.de
> +
> +How to use /sys/class/rtc/rtcX/wakealarm
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +This file takes the seconds since epoch to enable a wake event at the
> +specified time.

Better:

This file can be used to view / set the time of a wakeup event.  The
contents of the file are time measured in seconds since the Epoch
(00:00:00h, 1 Jan 1970, UTC).

> +
> +If a '0' is written, the alarm is disabled.

Now -- you started off talking about a "wake event" and now you
switched to talking about an "alarm" -- which is it?  Be consistent.

> +
> +If the alarm was already enabled, a new alarm can only be set after the
> +old alarm is disabled.
> +
> +
> +Migration from /proc/acpi/alarm
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +Users of /proc/acpi/alarm have to change their code to supply the
> +seconds since epoch instead of a date string.

As Jonathan said -- if I'm using  /proc/acpi/alarm, why do I care?
What advantages does the new interface provide for me that would
motivate me to change?

> +For shell scripts, this can be done using the date command, e.g. like
> +this:
> +
> +date -d tomorrow "+%s"
> +
> +This returns the seconds since epoch of the current time on the

s/epoch/the Epoch/

> +following day.
> +
> +Please note that you have to disable the old alarm first, if you want
> +to set a new alarm. Otherwise, you get an error. Example:
> +
> +echo 12345 > /sys/class/rtc/rtc0/wakealarm
> +echo 0 > /sys/class/rtc/rtc0/wakealarm
> +echo 23456 > /sys/class/rtc/rtc0/wakealarm

Here, it might be useful to show an example of an error.  E.g., if one
does these commands instead, show the error from the second command:

echo 12345 > /sys/class/rtc/rtc0/wakealarm
echo 23456 > /sys/class/rtc/rtc0/wakealarm
echo 0 > /sys/class/rtc/rtc0/wakealarm
echo 34567 > /sys/class/rtc/rtc0/wakealarm

> +cd /proc/acpi
> +echo EXP0 > wakeup
> +echo PCI1 > wakeup
> +echo USB0 > wakeup
> +echo USB1 > wakeup
> +echo USB2 > wakeup
> +echo USB7 > wakeup
> +echo HDEF > wakeup
> +cd /sys/class/rtc/rtc0
> +echo $(( $(cat since_epoch) + 20 )) > wakealarm
> +
> +    [PATCH] RTC gets sysfs wakealarm attribute
> +
> +    This adds a new "wakealarm" sysfs attribute to RTC class devices which support
> +    alarm operations and are wakeup-capable:
> +
> +     - It reads as either empty, or the scheduled alarm time as seconds
> +       since the POSIX epoch.  (That time may already have passed, since

s/epoch/Epoch/
(and other instances below)

> +       nothing currently enforces one-shot alarm semantics.)
> +
> +     - It can be written with an alarm time in the future, again seconds
> +       since the POSIX epoch, which enables the alarm.
> +
> +     - It can be written with an alarm time not in the future (such as 0,
> +       the start of the POSIX epoch) to disable the alarm.
> +
> +    Usage examples (some need GNU date) after "cd /sys/class/rtc/rtcN":
> +
> +        alarm after 10 minutes:
> +        # echo $(( $(cat since_epoch) + 10 * 60 )) > wakealarm
> +        alarm tuesday evening 10pm:
> +        # date -d '10pm tuesday' "+%s" > wakealarm
> +        disable alarm:
> +                # echo 0 > wakealarm
> +
> +    This resembles the /proc/acpi/alarm file in that nothing happens when the
> +    alarm triggers ...  except possibly waking the system from sleep.  It's also
> +    like that in a nasty way: not much can be done to prevent one task from
> +    clobbering another task's alarm settings.
> +
> +    It differs from that file in that there's no in-kernel date parser.
> +
> +    Note that a few RTCs ignore rtc_wkalrm.enabled when setting alarms, or aren't
> +    set up correctly, so they won't yet behave with this attribute.

The last sentence is garbled -- bad grammar/missing words -- somewhere
near "or aren't".

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
