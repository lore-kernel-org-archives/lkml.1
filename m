Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZB0Gry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZB0Gry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZB0Grl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:47:41 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:50466 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325AbZB0Grk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:47:40 -0500
Message-ID: <49A78C79.304@krogh.cc>
Date: Fri, 27 Feb 2009 07:47:21 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>	 <49A6F39F.9040801@krogh.cc>	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>	 <49A6FEE2.90700@krogh.cc>	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>	 <49A70B24.6090706@krogh.cc>	 <1235685269.6811.11.camel@localhost.localdomain>	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain> <1235687483.6811.26.camel@localhost.localdomain>
In-Reply-To: <1235687483.6811.26.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Thu, 2009-02-26 at 23:06 +0100, Thomas Gleixner wrote:
>> On Thu, 26 Feb 2009, john stultz wrote:
>>> On Thu, 2009-02-26 at 22:35 +0100, Jesper Krogh wrote:
>>>>> Also mind sending the full dmesg for both kernels?
>>>> http://krogh.cc/~jesper/dmesg-2.6.29-rc6.txt
>>>> http://krogh.cc/~jesper/dmesg-2.6.26.8.txt
>>> So one interesting difference:
>>> 2.6.26.8:	TSC calibrated against PM_TIMER
>>> 2.6.29-rc6:	Fast TSC calibration using PIT
>>>
>>> Thomas, any thoughts as to why we might be calibrating off the PIT
>>> instead of the PM_TIMER w/ 2.6.29?
>> Yup, because we introduced the Fast PIT calibration in 2.6.28.
> 
> Ah. Ok.
> 
>> Is the delta anything NTP might get upset about:
>>
>> 2.6.26: time.c: Detected 2311.847 MHz processor.
>> 2.6.29: Detected 2310.029 MHz processor.
> 
> I wouldn't think so.
> 
> Although, I'm recalling on some systems here right after we deploy them
> we'll see something similar to the originally reported ntpd "time reset"
> noise for a period of time while ntpd tries to find the right freq. For
> some reason, I've noticed, having multiple servers in your ntp.conf
> seems to increase NTP's difficulty at picking a time and converging. 
> 
> So this may be just the slight calibration change is confusing ntp or it
> may be the NTP_INTERVAL_LENGTH change from awhile back which would cause
> the drift value to change could be doing the same thing (although I
> thought that landed in the 2.6.24 timeframe, but I may be forgetting).
> 
> I'll kick up some of my own testing between these two releases to see if
> I can't find something similar.
> 
> Jesper: How long was the box up for when you noticed the ntpd noise?

I was booted Feb 25 21:58 .. the first noice from ntp starts here:
Feb 25 22:09:53 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
Feb 25 22:09:56 quad12 ntpd[4901]: synchronized to 10.194.133.13, stratum 4
Feb 25 22:14:08 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
Feb 25 22:16:20 quad12 ntpd[4901]: synchronized to 10.194.133.13, stratum 4
Feb 25 22:32:25 quad12 ntpd[4901]: time reset -1.601641 s
Feb 25 22:36:18 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
Feb 25 22:36:45 quad12 ntpd[4901]: synchronized to 10.194.133.12, stratum 4
Feb 25 22:51:41 quad12 ntpd[4901]: time reset -0.922993 s
Feb 25 22:55:05 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13



> Also what's the output of the following under the different kernels:
> ntpdc -c peers
> ntpdc -c kerninfo

Working (clocksource=acpi_pm) 2.6.29-rc6
jk@quad02:~$ ntpdc -c kerninfo
pll offset:           -0.001577 s
pll frequency:        -45.787 ppm
maximum error:        0.066739 s
estimated error:      0.000768 s
status:               0001  pll
pll time constant:    6
precision:            1e-06 s
frequency tolerance:  500 ppm
jk@quad02:~$ ntpdc -c peers
      remote           local      st poll reach  delay   offset    disp
=======================================================================
*hal.nzcorp.net  10.194.132.81    4   64  377 0.00008  0.003752 0.04816
=svn.nzcorp.net  10.194.132.81    4   64  377 0.00009 -0.008724 0.04979
=LOCAL(0)        127.0.0.1       13   64  377 0.00000  0.000000 0.03082


Working (clocksource=tsc) 2.6.26.8
jk@quad03:~$ ntpdc -c kerninfo
pll offset:           0.003208 s
pll frequency:        -25.070 ppm
maximum error:        0.833193 s
estimated error:      0.002787 s
status:               4001  pll
pll time constant:    10
precision:            1e-06 s
frequency tolerance:  500 ppm
jk@quad03:~$ ntpdc -c peers
      remote           local      st poll reach  delay   offset    disp
=======================================================================
*hal.nzcorp.net  10.194.132.82    4 1024  377 0.00781  0.006788 0.13666
=sal.nzcorp.net  10.194.132.82    4 1024  377 0.00018 -0.000541 0.12175
=LOCAL(0)        127.0.0.1       13   64  377 0.00000  0.000000 0.03041

Non-working (clocksource=tsc) 2.6.29-rc6
jk@quad12:~$ ntpdc -c kerninfo
pll offset:           0 s
pll frequency:        -34.754 ppm
maximum error:        0.023514 s
estimated error:      0 s
status:               0001  pll
pll time constant:    6
precision:            1e-06 s
frequency tolerance:  500 ppm
jk@quad12:~$ ntpdc -c peers
      remote           local      st poll reach  delay   offset    disp
=======================================================================
=hal.nzcorp.net  10.194.132.91    4   64   17 0.00011 -0.069377 0.96895
=trac.nzcorp.net 10.194.132.91    4   64   17 0.00011 -0.096107 0.96904
*LOCAL(0)        127.0.0.1       13   64   17 0.00000  0.000000 0.96857

