Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZAJJqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZAJJqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 04:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZAJJqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 04:46:21 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:43993 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZAJJqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 04:46:19 -0500
Message-ID: <49686E5A.6040000@davidnewall.com>
Date: Sat, 10 Jan 2009 20:16:02 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Nick Andrew <nick@nick-andrew.net>, Linas Vepstas <linasvepstas@gmail.com>,
       david@lang.hm, Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <496076A9.7030907@davidnewall.com>	<f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>	<4960897D.5030603@davidnewall.com>	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>	<4961432A.80509@davidnewall.com>	<alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>	<49614835.7000505@davidnewall.com>	<3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>	<20090105143335.GC18055@mail.local.tull.net>	<4962BB13.7060304@davidnewall.com>	<20090106025125.GB28431@mail.local.tull.net>	<20090106094058.64c89586@lxorguk.ukuu.org.uk>	<496479EA.1020207@davidnewall.com>	<20090107095419.70b78dc7@lxorguk.ukuu.org.uk>	<49648163.9060007@davidnewall.com>	<20090107105201.054c011f@lxorguk.ukuu.org.uk>	<4964B20B.4030406@davidnewall.com>	<20090107141025.143158b7@lxorguk.ukuu.org.uk>	<4964BDD2.3000803@davidnewall.com> <20090107154035.3fce1c07@lxorguk.ukuu.org.uk>
In-Reply-To: <20090107154035.3fce1c07@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Is there a mktime() in the kernel?  Isn't it pure user-space?  Mktime
>> does appear to know all about leap seconds (assuming they're in zoneinfo.)
>>     
>
> The GPL goes to great trouble to ensure you get the kernel source code.
> Why not use it.
>   

Okay.  I'm not sure how long you have realised that two, completely
different mktimes have been confused with each other, but surely longer
than me.

The kernel mktime, as far as I can tell without spending a week on it,
is used only on some platforms, during startup to read and set real time
clocks and alarms.  Where it matters is RTC ioctls which, tragically, I
think, are passed a struct rtc_time.  They should be passed a time_t or
struct timeval because these are what's used everywhere else that I can
think of, between kernel and user-space.

Ideally, struct rtc_time should be deprecated in favour of time_t. 
Changes to user-space programs should be trivial; probably, they
currently look like

  { struct rtc_time *rt = gmtime(&t); ioctl(fd, RTC_xxx, rt); }


This is not going to happen without a huge song and dance, which I
certainly don't have the energy for.  I think it makes no practical
difference, and only affects how tidy the kernel looks.  Assuming
leap-seconds are properly configured if zoneinfo, user-space programs
which use gmtime() to set the RTC will run it fast by the current number
of leap-seconds.  However the RTC will continue to advance by one second
per second, and being that fast, mktime will produce the correct time_t
when RTC is read back.  This will eventually cause a real problem with
RTCs that handle leap years.  When we have 4 years worth of
leap-seconds, or maybe its 96 years worth, the RTC will be set for a
leap-year when it is not, or vice versa.  That's a long time away.

It's something of a farce that some systems crashed at the leap-second
because no adjustment was needed.  Trying to turn two seconds into one
was a mistake.  I gather the mistake is in the NTP client, which should
just ignore the LEAP-SECOND bit, and use the leap-second information
from zoneinfo to convert from the NTP timebase to Linux's.

>> showing "#15 0xffffffff8104ec16 in ntp_leap_second (timer=<value
>> optimized out>) at kernel/time/ntp.c:143".  That would be kernel code to
>> process leap seconds from NTP broadcasts, I think.  That code needs to
>> be removed.
>>     
>
> I suggest you read that code and understand it.
>   

Well, there's rather a lot wrong with it, isn't there?  All of the stuff
that tries to handle leap seconds is wrong; that goes for timex.h, too. 
The kernel needs to do nothing special to handle leap-seconds; they're
just seconds, like every other one.

For the third time, this code has to come out.
