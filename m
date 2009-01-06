Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZAFCbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZAFCbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZAFCbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:31:13 -0500
Received: from vps1.tull.net ([66.180.172.116]:46801 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752079AbZAFCbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:31:10 -0500
Date: Tue, 6 Jan 2009 13:31:03 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Linas Vepstas <linasvepstas@gmail.com>
Cc: David Newall <davidn@davidnewall.com>, david@lang.hm,
       Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years	2008-2009
Message-ID: <20090106023103.GA28431@mail.local.tull.net>
References: <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com> <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm> <49614835.7000505@davidnewall.com> <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com> <20090105143335.GC18055@mail.local.tull.net> <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:08:50AM -0600, Linas Vepstas wrote:
> 2009/1/5 Nick Andrew <nick@nick-andrew.net>:
> > On Sun, Jan 04, 2009 at 11:48:31PM -0600, Linas Vepstas wrote:
> > Arguably the kernel's responsibility should be to keep track of the
> > most fundamental representation of time possible for a machine (that's
> > probably TAI) and it is a userspace responsibility to map from that
> > value to other time standards including UTC,
> 
> Yes, this really does seem like the right solution.
> 
> > using control files
> > which are updated as leap seconds are declared.
> 
> Lets be clear on what "control files" means.  This does
> *NOT* mean some config file shipped by some distro
> for some package. That would be a horrid solution.
> People don't install updates, patches, etc.  Distros
> ship them late, or never, if the distro is old enough.

To clarify - as far as I know, TAI is a fundamental time scale
because it's regular and monotonically increasing. Wikipedia
talks about specifying TAI using both Julian Dates and the
Gregorian Calendar - I don't know whether that means representations
of TAI time may suffer gaps depending on declared (subtracted)
leap seconds. In any case I was thinking of something like
Bernsteins TAI64 (http://cr.yp.to/libtai/tai64.html) which is
just a count of seconds (and nanoseconds using TAI64N).

Considering TAI64 as a count of seconds, other time values (UTC,
unix epoch time) can be derived from TAI64 by applying some mapping
function which takes into account all the irregularities introduced
by our complex time systems (including leap years, leap seconds, DST,
pre-Gregorian calendars and so on).

Unix epoch time (seconds since 1 Jan 1970 00:00:00 GMT) is
also regular and monotonically increasing however it's no
longer suitable as a fundamental timebase because it doesn't
recognise the existence of leap seconds. In unix epoch time
a day is always 86400 seconds long and when I said "preserve
the existing behaviour of time()" I meant that this constant
must be maintained.

As Linas correctly noted, UTC allows a distinct representation of a
leap second (xx:59:60). It follows from the previous paragraph that
a mapping from time_t to UTC can never result in ":60". Mapping from
UTC to time_t is lossy: if the input is a leap second then something
must be done with it: mktime() for 09:59:60 returns the same time_t
value as for 10:00:00.

Mapping from TAI64 to UTC or time_t requires knowledge of what leap
seconds were already applied, and when. Wikipedia says TAI is 34
seconds ahead of UTC right now, but I'm talking about converting any
past TAI value, not just current time. So it's not really suitable for
the kernel to just learn about leap seconds on the fly, there needs to
be a persistent table of some kind which states what changes happened
and when. This is analogous to the zoneinfo file, which states not
just the current DST rules but also all past ones.

There will certainly be hosts where this mapping file is out of
date, however it is supplied. That's the case with zoneinfo too,
and there's a general problem in that politicians keep mucking about
with daylight saving time. We're experiencing that now in Australia,
where the state of Western Australia which never had DST in the past,
now has it as a "test". So WA has got it now, much to my displeasure,
and may or may not have it in future. In general it's not possible to
reliably convert future dates from time_t to local time, where future
dates are anything more recent than your zoneinfo file. The same
constraint applies to conversion from TAI64.

There's a good argument for including up-to-date conversion information
in the NTP protocol. I don't know enough about NTP whether it has this
capability already. Hosts which don't have up-to-date zoneinfo files
and don't sync time with NTP probably don't care about accurate time
conversion anyway.

> Well, 'man 2 time' is as clear as mud. It talks about leap seconds,
> but I can't figure out what its saying.  I rather
> doubt that time() is doing what POSIX.1 seems to want
> it to do (which is to ignore leap seconds?)

I think I read that linux "ticks the second twice" (I don't know
whether that's the 59 second or the 00 second, it should be 00 for
ctime(3) to make any sense) and I don't know whether gettimeofday(2)
will show tv_usec returning to zero and re-counting the microseconds.

I think POSIX.1 wants time_t to ignore leap seconds as if they
didn't exist. That means that the :59:60 and :00:00 wall clock
seconds share a single time_t value ... in other words, one
time_t second in linux persists for two wall clock seconds during
a leap second.

Sane behaviour would be for tv_sec and tv_usec to be monotonically
increasing while this is going on; the microseconds should pass
at half the usual rate to preserve this.

> The reason I'm guessing that time() is wrong, is because
> it seems that POSIX wants time() to use TAI time, and
> we don't have that handy anywhere (because we've lost
> track of those leap seconds)

I don't think POSIX wants TAI, but it makes sense for a kernel to
provide an unambiguous time reference to userspace. time_t is a
convenient approximation but it is non-linear due to ignoring the
leap seconds and it probably causes havoc for any precise measurements
occurring during the leap second.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
