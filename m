Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZAEQJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZAEQJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZAEQIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:08:54 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:42269 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZAEQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:08:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=SdZynVLeXowA+Q7FxnTHsabqjgMMJSOJnRQde/L7To489HhG0/eSEYFSb0S6g5duLT
         WHBpehGHJQBoJbSfrdTjkkAZ1bSZ17trVUg2P7RuJZZYbbbxHJV/hrmhBeiaEHrE32YY
         AoU7RttaqFi+c00Gf2KM0bZZO/wovAz+dIQ5E=
Message-ID: <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
Date: Mon, 5 Jan 2009 10:08:50 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "Nick Andrew" <nick@nick-andrew.net>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "David Newall" <davidn@davidnewall.com>, david@lang.hm,
       "Kyle Moffett" <kyle@moffetthome.net>,
       "Ben Goodger" <goodgerster@gmail.com>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net
In-Reply-To: <20090105143335.GC18055@mail.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495F0672.6020708@davidnewall.com>
	 <496076A9.7030907@davidnewall.com>
	 <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
	 <4960897D.5030603@davidnewall.com>
	 <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	 <4961432A.80509@davidnewall.com>
	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	 <49614835.7000505@davidnewall.com>
	 <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	 <20090105143335.GC18055@mail.local.tull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/5 Nick Andrew <nick@nick-andrew.net>:
> On Sun, Jan 04, 2009 at 11:48:31PM -0600, Linas Vepstas wrote:
>> There *was* talk of eliminating them forever (so as to
>> avoid this kind of bug, which affects banks, satellites,
>> telecom equipment, etc.) but I guess they didn't do it.
>
> I can sympathise with the opinion that linux should be able to accurately
> distinguish xx:59:60 when a leap second is added (or the missing :59 when
> one is subtracted) but not at the expense of making a day which is not
> 86400 seconds long.

Careful: This seems to be *exactly* the intent of the
maintainers of the UTC definition: some days really
will have 86401 seconds in them.  That's why there's
all this talk of 'solar time' (see e.g. the wikipedia article)

> To fix the problem would require accurately modeling international
> timekeeping standards such as TAI and use of different syscalls to
> return time in TAI and UTC-with-leap-seconds represented. It
> wouldn't be good to change the semantics of time().

Now, this is the first proposal that I've heard that makes
sense.  I believe that the Linux kernel/userspace
infrastructure already " accurately models international
timekeeping standards", so we're good.

Changing the kernel to track TAI instead of UTC seems
like an excellent idea -- but not one without a significant
amount of work -- maybe new syscalls are needed, as
well as new monkeying-about in glibc, maybe in ntpd, etc.

> * http://en.wikipedia.org/wiki/International_Atomic_Time
> * http://en.wikipedia.org/wiki/Leap_second
>
> Arguably the kernel's responsibility should be to keep track of the
> most fundamental representation of time possible for a machine (that's
> probably TAI) and it is a userspace responsibility to map from that
> value to other time standards including UTC,

Yes, this really does seem like the right solution.

> using control files
> which are updated as leap seconds are declared.

Lets be clear on what "control files" means.  This does
*NOT* mean some config file shipped by some distro
for some package. That would be a horrid solution.
People don't install updates, patches, etc.  Distros
ship them late, or never, if the distro is old enough.

A more appropriate solution would be to have
either the kernel or ntpd track the leap seconds
automatically.  First, the ntp protocol already provides
the needed notification of a leap second to anyone
who cares about it (i.e. there is no point in getting a
Linux distro involved in this -- a distribution mechanism
already exists, and works *better* than having a distro
do it).

If the kernel needs to track leap seconds, it could do
so using a mechanism similar to the "random pool"
that is saved across reboots.  Alternately, ntpd already
stores slew rates &etc. in files, and could track leap
seconds likewise.

> Just so long as the
> existing behaviour of time() which doesn't recognise leap seconds
> is preserved.

Well, 'man 2 time' is as clear as mud. It talks about leap seconds,
but I can't figure out what its saying.  I rather
doubt that time() is doing what POSIX.1 seems to want
it to do (which is to ignore leap seconds?)

The reason I'm guessing that time() is wrong, is because
it seems that POSIX wants time() to use TAI time, and
we don't have that handy anywhere (because we've lost
track of those leap seconds)

--linas
