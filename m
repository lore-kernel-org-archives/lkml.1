Return-Path: <linux-kernel-owner+w=401wt.eu-S1763400AbZCCWZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763400AbZCCWZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763031AbZCCWXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:23:00 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:59094 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763017AbZCCWW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:22:58 -0500
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <49AD90E2.7050209@krogh.cc>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A6F39F.9040801@krogh.cc>
	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
	 <49A70B24.6090706@krogh.cc>
	 <1235685269.6811.11.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>
	 <1235766936.7402.5.camel@localhost.localdomain> <49ABACA0.3090300@krogh.cc>
	 <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>
	 <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>
Content-Type: multipart/mixed; boundary="=-Nuzx9kdWq+l8zxjCJEeY"
Date: Tue, 03 Mar 2009 14:22:49 -0800
Message-Id: <1236118969.6068.87.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Nuzx9kdWq+l8zxjCJEeY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2009-03-03 at 21:19 +0100, Jesper Krogh wrote:
> john stultz wrote:
> > On Tue, 2009-03-03 at 07:04 +0100, Jesper Krogh wrote:
> >> john stultz wrote:
> >>> On Mon, 2009-03-02 at 10:53 +0100, Jesper Krogh wrote:
> >>>> john stultz wrote:
> >>>>> Ok, so it seems ntp hasn't really had a chance to settle down, its only
> >>>>> made a 10ppm adjustment so far. NTPd will stop corrections at ~
> >>>>> +/-500ppm, so you're not at that bound yet, where things would be really
> >>>>> broken.
> >>>>>
> >>>>> If the affected kernel isn't resetting in the logs anymore, I'd be
> >>>>> interested in what the new ppm value is.
> >>>> After 20 hours.. its still resetting.
> >>>> Mar  2 10:43:24 quad12 ntpd[4416]: synchronized to 10.194.133.12, stratum 4
> >>>> Mar  2 10:50:37 quad12 ntpd[4416]: time reset -1.103654 s
> >>> So what's the "ntpdc -c kerninfo" output now?
> >> Mar  3 06:41:10 quad12 ntpd[4416]: time reset -0.813957 s
> >> Mar  3 06:45:20 quad12 ntpd[4416]: synchronized to LOCAL(0), stratum 13
> >> Mar  3 06:45:36 quad12 ntpd[4416]: synchronized to 10.194.133.12, stratum 4
> >> Mar  3 06:51:57 quad12 ntpd[4416]: synchronized to 10.194.133.13, stratum 4
> >> Mar  3 07:00:29 quad12 ntpd[4416]: time reset -0.783390 s
> >> jk@quad12:~$ ntpdc -c kerninfo
> >> pll offset:           0 s
> >> pll frequency:        -28.691 ppm
> > 
> > 
> > This is baffling. You've only gone from -34.754ppm to -28.691ppm in over
> > a day? And you're still not syncing? If the calibration was so bad that
> > NTP couldn't sync, I'd expect the freq value to hit +/-500ppm before it
> > gave up. This just doesn't follow my expectations.
> 
> It's resetting.. without deep knowledge about ntp, doesnt that mean 
> "start over again"? I believe it hits +/-500ppm

No, the "time reset" message means that when the offset is larger
then .125sec (the slew boundary), NTPd has corrected it by calling
settimeofday instead of slewing the clock.

Here's some background about how NTP and the kernel interact:
Every time NTPd calls adjtimex(), its provides the current offset from
the tracked ntp server. The kernel takes this offset and applies a
temporary correction factor to the clocksource frequency to converge
that offset. It also takes the provided offset, dampens it, and then
uses the result to adjust the frequency value. Once the freq value hits
the max adjustment value (+/- 500ppm), then NTP will start throwing
error messages and give up.

The part that is so odd with your data, is that the freq value isn't
changing very much. After a time reset, I'd expect to see adjustments in
the 100us, then multiple ms, and only once we get above 100ms to see
another time reset. All the while, these adjustment values should be
tweaking the freq value, causing the clocks to converge.

The case I can think of that could cause this, is if the drift is
somehow jumping above the slew boundary before NTPd actually makes any
adjtimex calls, so we end up with minimal correction to the freq value,
but that still doesn't completely vibe with the data.


> > Could you provide:
> > /usr/sbin/ntpdc -c version
> 
> $ ntpdc -c version
> ntpdc 4.2.4p4@1.1520-o Tue Jan  6 15:51:00 UTC 2009 (1)
> 
> > Do you see the same behavior if you drop all but one server (including
> > the local clock: 127.127.1.0)? 
> > 
> > You might also add "minpoll 4 maxpoll 4" to the server line to speed up
> > testing.
> 
> Will try those option while debugging.
> 
> > Actually, if you could, I'd be interested if you could send your
> > ntp.conf 
> 
> http://krogh.cc/~jesper/ntp.conf

Cool, I see you're collecting stats already. Depending on the results of
the tests above I may want to check those out as well.

> But this seems to be a "regression". Since 2.6.27.19 doesn't misbehave. 
> Same NTP, same configuration, same hardware. only change is the kernel 
> version. Or am I missing some parameter here?
> 
> Would it make sense to try to bisect it?

Well, I suspect you'll just bisect it to the fast-pit TSC calibration
causing a different correction freq to be needed for synchronization.
The odd part is that the userland NTPd isn't behaving as I'd expect if
the TSC calibration was really so bad that NTP couldn't handle it.

Bisection may be something worth trying just to verify or disprove that
theory, so if you have the time, it would be interesting to see. But if
the theory is true then we're back to the same spot.

I guess something to test my idea above (that the drift is bad enough
that NTPd isn't making slew adjustments via adjtimex offset) is to
remove NTPd from the init.d startup.

Then after rebooting (into 2.6.29), run the attached python script for
10 minutes or so to get an idea of the ppm drift. Then repeat with
2.6.26.

To run: 
./drift-test.py <ntp server>

It will give some wild ppm numbers, but after a few minutes it should
settle down to the "natural drift" of the system.

thanks
-john


--=-Nuzx9kdWq+l8zxjCJEeY
Content-Disposition: attachment; filename="drift-test.py"
Content-Type: text/x-python; name="drift-test.py"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

#!/usr/bin/python

# Time Drift Script
#		Periodically checks and displays time drift
#		by john stultz (jstultz@us.ibm.com)

import commands
import sys
import string
import time

server_default = "yourserverhere"
sleep_time_default  = 60

server = ""
sleep_time = 0
set_time = 0

#parse args
for arg in sys.argv[1:]:
	if arg == "-s":
		set_time = 1
	elif server == "":
		server = arg
	elif sleep_time == 0:
		sleep_time = string.atoi(arg)

if server == "":
	server = server_default
if sleep_time == 0:
	sleep_time = sleep_time_default

#set time
if (set_time == 1):
	cmd = commands.getoutput('/usr/sbin/ntpdate -ub ' + server)

cmd = commands.getoutput('/usr/sbin/ntpdate -uq ' + server)
line = string.split(cmd)

#parse original offset
start_offset = string.atof(line[-2]);
#parse original time
start_time = time.localtime(time.time())
datestr = time.strftime("%d %b %Y %H:%M:%S", start_time)

time.sleep(1)
while 1:
	cmd = commands.getoutput('/usr/sbin/ntpdate -uq ' + server)
	line = string.split(cmd)

	#parse offset
	now_offset = string.atof(line[-2]);

	#parse time
	now_time = time.localtime(time.time())
	datestr = time.strftime("%d %b %Y %H:%M:%S", now_time)

	# calculate drift
	delta_time = time.mktime(now_time) - time.mktime(start_time)
	delta_offset = now_offset - start_offset
	drift =  delta_offset / delta_time * 1000000

	#print output
	print time.strftime("%d %b %H:%M:%S",now_time), 
	print "	offset:", now_offset , 
	print "	drift:", drift ,"ppm"
	sys.stdout.flush()

	#sleep 
	time.sleep(sleep_time)

--=-Nuzx9kdWq+l8zxjCJEeY--

