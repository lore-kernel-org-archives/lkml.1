Return-Path: <linux-kernel-owner+w=401wt.eu-S1751203AbZHSBJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbZHSBJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZHSBJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:09:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43313 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZHSBJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:09:23 -0400
Subject: Re: clock freezes??
From: john stultz <johnstul@us.ibm.com>
To: Victor =?ISO-8859-1?Q?Matar=E9?= <matare@lih.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4A8AAE44.5030008@lih.rwth-aachen.de>
References: <4A69C03E.3090706@lih.rwth-aachen.de>
	 <1f1b08da0907281446j685bcdf0i10975628e07ed1f8@mail.gmail.com>
	 <4A8190C0.5030400@lih.rwth-aachen.de> <1250008935.30440.8.camel@work-vm>
	 <4A8AAE44.5030008@lih.rwth-aachen.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Aug 2009 18:08:17 -0700
Message-Id: <1250644097.7002.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 15:36 +0200, Victor Mataré wrote:
> john stultz wrote:
> > On Tue, 2009-08-11 at 17:39 +0200, Victor Mataré wrote:
> >> john stultz wrote:
> >>> On Fri, Jul 24, 2009 at 7:07 AM, Victor Mataré<matare@lih.rwth-aachen.de> wrote:
> >>>> I have a dual Xeon server (old Xeon HT) with an Intel E7505 chipset,
> >>>> with hrtimer and dynticks enabled. On bootup, the kernel
> >>>> (2.6.29-gentoo-r5) tells me it's using the PM-Timer bug workaround, but
> >>>> then it uses tsc as clocksource. Now the clock was running slow for
> >>>> about 15sec/12hrs, which is quite a lot. So in a careless moment, I just
> >>>> tried "echo jiffies > clocksource0/current_clocksource". This froze the
> >>>> system time. Now I couldn't switch back to tsc or acpi_pm, echoing those
> >>>> was just ignored. Subsequently, the entire system locked up and I needed
> >>>> to reboot.
> >>>>
> >>>> Now what does that mean? Is this supposed to happen? Should I disable
> >>>> dynticks and/or hrtimer?
> >>> The system lockup is a known issue and should be resolved with the
> >>> following commit:
> >>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3f68535adad8dd89499505a65fb25d0e02d118cc
> >>>
> >>> I might be curious if you could expand a bit more about the clock skew
> >>> (15sec per 12 hours) you're seeing. Are you running NTP? Do you have
> >>> the output of ntpdc -c kerninfo , ntpdc -c peers? Do you see lots of
> >>> ntp messages in /var/log/messages or /var/log/syslog ?
> >>>
> >>> thanks
> >>> -john
> >> Until now, I was just using BSD netdate, which kept adding 12-25 seconds
> >> every 24 hours.
> >> The whole issue is related to strange lockups I had been seeing about
> >> monthly, apparently everytime the clock was rewound instead of put
> >> forward (clock freezes, programs hang, system ends up deadlocked within
> >> 10-300 minutes depending on usage). The system is a production
> >> fileserver acting mainly as a Samba PDC, so testing this scenario is
> >> quite difficult. Now recently, I swapped the motherboard including RAM
> >> and CPU with our webserver, which seems to have removed the monthly
> >> time-freeze, but led to the above-mentioned freeze caused by me
> >> experimenting with clocksource=jiffies because of the slow clock.
> >> However, the monthly freezes upon rewinding the clock may be gone now
> >> just because the clock is consistently running slow, so it doesn't need
> >> to be rewound any more.
> >> I've just switched both systems to ntpd:
> >>
> >> # ntpdc -c kerninfo
> >> pll offset:           0 s
> >> pll frequency:        0.000 ppm
> >> maximum error:        16 s
> >> estimated error:      16 s
> >> status:               0040  unsync
> >> pll time constant:    4
> >> precision:            1e-06 s
> >> frequency tolerance:  500 ppm
> > 
> > So here its reporting you're still in unsync mode, so ntp hasn't run
> > long enough to do any corrections.  You might let the system run with
> > ntpd for a few hours (or a day) and then try re-try the "ntpdc -c
> > kerninfo" command. 
> > 
> > 
> >> # ntpdc -c peers -n
> >>      remote           local      st poll reach  delay   offset    disp
> >> =======================================================================
> >> =134.130.4.17    137.226.164.2    1   64  377 0.00061  0.156253 0.03084
> >> *134.130.5.17    137.226.164.2    1   64  377 0.00035  0.205312 0.03041
> >>
> >> Dunno how to interpret that. Syslog now gives:
> >>
> >> Aug 11 17:13:02 bussard ntpd[21845]: ntpd 4.2.4p7@1.1607-o Tue Jun 23
> >> 10:58:51 UTC 2009 (1)
> >> Aug 11 17:13:02 bussard ntpd[21874]: precision = 1.000 usec
> >> Aug 11 17:13:02 bussard ntpd[21874]: Listening on interface #0 wildcard,
> >> 0.0.0.0#123 Disabled
> >> Aug 11 17:13:02 bussard ntpd[21874]: Listening on interface #1 lo,
> >> 127.0.0.1#123 Enabled
> >> Aug 11 17:13:02 bussard ntpd[21874]: Listening on interface #2 eth0,
> >> 137.226.164.2#123 Enabled
> >> Aug 11 17:13:02 bussard ntpd[21874]: Listening on interface #3 eth0:1,
> >> 192.168.23.3#123 Enabled
> >> Aug 11 17:13:02 bussard ntpd[21874]: kernel time sync status 0040
> >> ...
> >> Aug 11 17:16:18 bussard ntpd[21874]: synchronized to 134.130.4.17, stratum 1
> >> Aug 11 17:16:32 bussard ntpd[21874]: time reset +13.979355 s
> >> ...
> >> Aug 11 17:20:43 bussard ntpd[21874]: synchronized to 134.130.5.17, stratum 1
> > 
> > 
> > 
> > I'd also be interested in seeing the syslog data as well after a day or
> > so of running ntpd.
> > 
> >> However, the issue of the clock freezing upon time-rewind still remains
> >> quite unclear to me. Can it be caused by the careless way in which
> >> netdate does it? Can it be related to the jiffies-hrtimer issue?
> > 
> > I'm not familiar with netdate, however the time should be able to be set
> > in either forward or backward direction without the system hanging.
> > 
> > Can you trigger the problem yourself using date -s ?
> > 
> > thanks
> > -john
> > 
> 
> OK, ntpd has been running for a week now, and I'm not sure what it has
> been doing. Last week, on the day I set it up, there was this:
> 
> # grep ntpd\\[ /var/log/syslog
> Aug 11 17:16:18 bussard ntpd[21874]: synchronized to 134.130.4.17, stratum 1
> Aug 11 17:16:32 bussard ntpd[21874]: time reset +13.979355 s
> Aug 11 17:20:43 bussard ntpd[21874]: synchronized to 134.130.5.17, stratum 1
> Aug 11 17:32:31 bussard ntpd[21874]: time reset +0.300276 s
> Aug 11 17:32:31 bussard ntpd[21874]: kernel time sync status change 0001
> Aug 11 17:36:27 bussard ntpd[21874]: synchronized to 134.130.4.17, stratum 1
> Aug 11 17:40:56 bussard ntpd[21874]: no servers reachable
> Aug 11 18:32:16 bussard ntpd[21874]: synchronized to 134.130.5.17, stratum 1
> Aug 11 18:32:16 bussard ntpd[21874]: kernel time sync status change 4001
> 
> Now after that, up until today, I see only this:
> 
> Aug 17 18:43:42 bussard ntpd[21874]: synchronized to 134.130.5.17, stratum 1
> Aug 17 18:50:28 bussard ntpd[21874]: kernel time sync status change 0001
> Aug 17 19:17:50 bussard ntpd[21874]: no servers reachable
> Aug 17 20:09:06 bussard ntpd[21874]: synchronized to 134.130.5.17, stratum 1
> Aug 17 20:09:06 bussard ntpd[21874]: kernel time sync status change 4001
> Aug 17 20:32:56 bussard ntpd[21874]: kernel time sync status change 0001
> Aug 17 20:43:17 bussard ntpd[21874]: no servers reachable
> Aug 17 23:06:35 bussard ntpd[21874]: synchronized to 134.130.5.17, stratum 1
> Aug 17 23:06:35 bussard ntpd[21874]: kernel time sync status change 4001
> Aug 17 23:16:53 bussard ntpd[21874]: no servers reachable
> Aug 18 11:48:13 bussard ntpd[21874]: synchronized to 134.130.5.17, stratum 1
> Aug 18 12:05:18 bussard ntpd[21874]: no servers reachable
> Aug 18 14:11:32 bussard ntpd[21874]: synchronized to 134.130.5.17, stratum 1
> Aug 18 14:21:57 bussard ntpd[21874]: no servers reachable
> 
> # grep ntpd\\[ /var/log/syslog | wc
>     177    1737   12413
> (Starting from August 11, when I set up ntpd)
> 
> # ntpdc -c kerninfo
> pll offset:           -0.002368 s
> pll frequency:        272.989 ppm
> maximum error:        1.51074 s
> estimated error:      0.003472 s
> status:               4001  pll
> pll time constant:    10
> precision:            1e-06 s
> frequency tolerance:  500 ppm
> 
> Now I guess it does adjust the time quite frequently, although it
> doesn't tell me the differences in syslog, right? At least all servers
> are nicely synchronized in time, now.

It is slewing the clock instead of setting it, and the log messages seem
to either be due to the time server becoming unreachable (network
outage?) periodically. 

> However, I've never been able to manually trigger that regular
> time-freeze that occurred about monthly. Note that above data are from
> the system that did not experience that monthly freeze, but did freeze
> on the "echo jiffies > current_clocksource" thing.
> On the system that did freeze spontaneously syslog looks just about the
> same, with:
> 
> # grep "ntpd\[" syslog | wc
>     199    1934   13332
> 
> and:
> 
> # ntpdc -c kerninfo
> pll offset:           -0.055492 s
> pll frequency:        -164.169 ppm
> maximum error:        1.14918 s
> estimated error:      0.018156 s
> status:               4001  pll
> pll time constant:    10
> precision:            1e-06 s
> frequency tolerance:  500 ppm
> 
> Now I might be inclined to account the apparently higher deviation to
> the higher CPU clock this system uses (2x Xeon HT 3.06 GHz on Intel
> E7501 vs. 2x Xeon HT 2.4 GHz on Intel E7505 in the first system. Both
> have clocksource=tsc).
> 
> I'm sorry for the long delay, but my working time in this place is very
> limited. I'd really appreciate some ideas on how I might:
> - Narrow in on the problem once I get so lucky as to witness the machine
>  freezing...
> - Trigger the timer freeze with something other than the jiffies thing

Yes, the jiffies thing is a different issue entirely and has been fixed
upstream. 

I am interested in the hang you describe, but from the logs above it
looks like things are functioning properly.

> Both systems have now been up for 20, resp. 25 days, so the monthly
> freeze (if it does occur now after swapping the mainboards) is to be
> expected within the next 10 days.

Do let me know if you continue to see it.

thanks
-john


