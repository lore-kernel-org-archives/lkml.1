Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbXFSRYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbXFSRYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbXFSRYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:24:36 -0400
Received: from eazy.amigager.de ([213.239.192.238]:40637 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685AbXFSRYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:24:35 -0400
Date: Tue, 19 Jun 2007 19:24:29 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: rtc_cmos: error after first write to wakealarm
Message-ID: <20070619172429.GA30990@dose.home.local>
Mail-Followup-To: Alessandro Zummo <alessandro.zummo@towertech.it>,
	rtc-linux@googlegroups.com,
	Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
	linux-kernel@vger.kernel.org
References: <20070615063308.GA18089@dose.home.local> <20070615155904.1d1da892.yoichi_yuasa@tripeaks.co.jp> <20070615070319.GA19455@dose.home.local> <20070619142404.42dcdc3c@inspiron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619142404.42dcdc3c@inspiron>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 14:24:04 +0200, Alessandro Zummo wrote:
> On Fri, 15 Jun 2007 09:03:19 +0200
> Tino Keitel <tino.keitel@gmx.de> wrote:
> 
> > > > I have the following strange behaviour with rtc_cmos:
> > > > 
> > > > $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> > > > bash: echo: write error: Device or resource busy
> > > > $ rmmod rtc_cmos
> > > > $ modprobe rtc_cmos
> > > > $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> > > > $ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
> > > > bash: echo: write error: Device or resource busy
> > > > $
> > > 
> > > If the alarm has already been enabled, you cannot set the next
> > > alarm.  You should disable first.
> > 
> > Ah, ok.
> >   
> > Where is the documentation that describes that I have to disable it
> > first, and how to do this? A migration document for
> > /proc/acpi/alarm users would be nice, too.
> 
>  Well, I guess there is no documentation. Maybe we could add
>  a dev_warn with an explicit message.

Isn't it somewhat ridiculous to plan the removal of a feature for
several months, and then replace it with something that behaves
differently without any documentation?

I don't know if there is any centralized form sysfs documentation. I
guess not. So at least a short text like the one below somewhere in
Documentation/ would be useful.

I still wonder how 'cat /sys/class/rtc/rtcX/wakealarm' is expected to
behave. With 2.6.22-rc5, I get this:

$ echo 1182351177 > /sys/class/rtc/rtc0/wakealarm 
$ cat /sys/class/rtc/rtc0/wakealarm
2051644873

There seems to be a constant difference of 869984896 seconds. Is this a
bug?


-----------------------------------------------------------------------

How to use /sys/class/rtc/rtcX/wakealarm
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This file takes the seconds since epoch to enable a wake event at the
specified time.

If a '0' is written, the alarm is disabled.

If the alarm was already enabled, a new alarm can only be set after the
old alarm is disabled.


Migration from /proc/acpi/alarm
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users of /proc/acpi/alarm have to change their code to supply the
seconds since epoch instead of a date string.

For shell scripts, this can be done using the date command, e.g. like
this:

date -d tomorrow "+%s"

This returns the seconds since epoch of the current time on the
following day.

Please note that you have to disable the old alarm first, if you want
to set a new alarm. Otherwise, you get an error. Example:

echo 12345 > /sys/class/rtc/rtc0/wakealarm
echo 0 > /sys/class/rtc/rtc0/wakealarm
echo 23456 > /sys/class/rtc/rtc0/wakealarm

-----------------------------------------------------------------------

Regards,
Tino
