Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbZHKPjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbZHKPjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZHKPjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:39:44 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:51337 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbZHKPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:39:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=ISO-8859-1
X-IronPort-AV: E=Sophos;i="4.43,361,1246831200";   d="scan'208";a="22163836"
Message-id: <4A8190C0.5030400@lih.rwth-aachen.de>
Date: Tue, 11 Aug 2009 17:39:44 +0200
From: =?ISO-8859-1?Q?Victor_Matar=E9?= <matare@lih.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090723)
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: clock freezes??
References: <4A69C03E.3090706@lih.rwth-aachen.de>
 <1f1b08da0907281446j685bcdf0i10975628e07ed1f8@mail.gmail.com>
In-reply-to: <1f1b08da0907281446j685bcdf0i10975628e07ed1f8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Fri, Jul 24, 2009 at 7:07 AM, Victor Mataré<matare@lih.rwth-aachen.de> wrote:
>> I have a dual Xeon server (old Xeon HT) with an Intel E7505 chipset,
>> with hrtimer and dynticks enabled. On bootup, the kernel
>> (2.6.29-gentoo-r5) tells me it's using the PM-Timer bug workaround, but
>> then it uses tsc as clocksource. Now the clock was running slow for
>> about 15sec/12hrs, which is quite a lot. So in a careless moment, I just
>> tried "echo jiffies > clocksource0/current_clocksource". This froze the
>> system time. Now I couldn't switch back to tsc or acpi_pm, echoing those
>> was just ignored. Subsequently, the entire system locked up and I needed
>> to reboot.
>>
>> Now what does that mean? Is this supposed to happen? Should I disable
>> dynticks and/or hrtimer?
> 
> The system lockup is a known issue and should be resolved with the
> following commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3f68535adad8dd89499505a65fb25d0e02d118cc
> 
> I might be curious if you could expand a bit more about the clock skew
> (15sec per 12 hours) you're seeing. Are you running NTP? Do you have
> the output of ntpdc -c kerninfo , ntpdc -c peers? Do you see lots of
> ntp messages in /var/log/messages or /var/log/syslog ?
> 
> thanks
> -john

Until now, I was just using BSD netdate, which kept adding 12-25 seconds
every 24 hours.
The whole issue is related to strange lockups I had been seeing about
monthly, apparently everytime the clock was rewound instead of put
forward (clock freezes, programs hang, system ends up deadlocked within
10-300 minutes depending on usage). The system is a production
fileserver acting mainly as a Samba PDC, so testing this scenario is
quite difficult. Now recently, I swapped the motherboard including RAM
and CPU with our webserver, which seems to have removed the monthly
time-freeze, but led to the above-mentioned freeze caused by me
experimenting with clocksource=jiffies because of the slow clock.
However, the monthly freezes upon rewinding the clock may be gone now
just because the clock is consistently running slow, so it doesn't need
to be rewound any more.
I've just switched both systems to ntpd:

# ntpdc -c kerninfo
pll offset:           0 s
pll frequency:        0.000 ppm
maximum error:        16 s
estimated error:      16 s
status:               0040  unsync
pll time constant:    4
precision:            1e-06 s
frequency tolerance:  500 ppm

# ntpdc -c peers -n
     remote           local      st poll reach  delay   offset    disp
=======================================================================
=134.130.4.17    137.226.164.2    1   64  377 0.00061  0.156253 0.03084
*134.130.5.17    137.226.164.2    1   64  377 0.00035  0.205312 0.03041

Dunno how to interpret that. Syslog now gives:

Aug 11 17:13:02 bussard ntpd[21845]: ntpd 4.2.4p7@1.1607-o Tue Jun 23
10:58:51 UTC 2009 (1)
Aug 11 17:13:02 bussard ntpd[21874]: precision = 1.000 usec
Aug 11 17:13:02 bussard ntpd[21874]: Listening on interface #0 wildcard,
0.0.0.0#123 Disabled
Aug 11 17:13:02 bussard ntpd[21874]: Listening on interface #1 lo,
127.0.0.1#123 Enabled
Aug 11 17:13:02 bussard ntpd[21874]: Listening on interface #2 eth0,
137.226.164.2#123 Enabled
Aug 11 17:13:02 bussard ntpd[21874]: Listening on interface #3 eth0:1,
192.168.23.3#123 Enabled
Aug 11 17:13:02 bussard ntpd[21874]: kernel time sync status 0040
...
Aug 11 17:16:18 bussard ntpd[21874]: synchronized to 134.130.4.17, stratum 1
Aug 11 17:16:32 bussard ntpd[21874]: time reset +13.979355 s
...
Aug 11 17:20:43 bussard ntpd[21874]: synchronized to 134.130.5.17, stratum 1

However, the issue of the clock freezing upon time-rewind still remains
quite unclear to me. Can it be caused by the careless way in which
netdate does it? Can it be related to the jiffies-hrtimer issue?

Thanks for your help so far, I'll be back when I know more.
Victor
