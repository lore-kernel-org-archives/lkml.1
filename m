Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbXK1X0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbXK1X0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbXK1X0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:26:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48188 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756124AbXK1X0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:26:10 -0500
Date: Thu, 29 Nov 2007 00:26:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com, kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Message-ID: <20071128232647.GC4947@elf.ucw.cz>
References: <20070920103225.GA4410@elf.ucw.cz> <20070920105002.GA4611@elf.ucw.cz> <200709212238.05130.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709212238.05130.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Sorry for long delay. I got rtc wakeup to work... once per boot. On
2.6.24-rc3.


> > > root@amd:/sys/class/rtc/rtc0# ls -al wakealarm 
> > > -rw-r--r-- 1 root root 0 Sep 20 12:30 wakealarm
> > > root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> > > root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> 
> The alarm isn't set; so no value gets displayed.
> 
> 
> > > root@amd:/sys/class/rtc/rtc0# 
> > > 
> > > 
> > > ...standard PC with reasonably recent kernel...
> 
> Yeah, well a "standard PC" is chock full of fairly bizarrely
> glitchey hardware.  Clocks and timers have more than their
> fair share, or x86_64 NOHZ support would be merged by now!

Oops. Ok, this is thinkpad x60, if that helps.

> > root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> > 2051629528
> > root@amd:/sys/class/rtc/rtc0# date +%s
> > 1190285030
> 
> OK, in that situation you've definitely got some buglike behavior.
> My question is:  how to fix it?
> 
> The problem is that the RTC is reporting an alarm value with some
> fields flagged as "wildcard" -- e.g. day/month/year "out of range"
> so the hardware ignores those fields.  This is very common on PC
> based RTCs, and much less common on embedded systems.  (Which for
> some reason don't tend to cheap out on full date specs like PCs.)

I see... so situation is not nice :-(.

> I'm not sure which fix would be best; maybe Alessandro has an
> opinion.

Alessandro?

> Better might be
> 
> 	echo $(( $(cat since_epoch) + 20 )) > wakealarm
> 
> which has no timezone offset issues.

Good. that actually works.

> > root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> > root@amd:/sys/class/rtc/rtc0# 
> > 
> > Also, is there some documentation for wakealarm?
> 
> "git show 3925a5ce44330767f7f0de5c58c6a797009f0f75" has some.

Thanks. Will put it into Doc*/rtc.txt.

> Are you sure it's not working?  Other than the two issues I noted
> above -- borkage w.r.t. ACPI (which wasn't necessarily shown in your
> scripts above), and with wildcarding -- it looked to be correct.

It seems to be working now, not sure what changed.

rtc-sysfs.c: why this?

        if (alarm > now) {
                /* Avoid accidentally clobbering active alarms; we
can't
                 * entirely prevent that here, without even the
minimal
                 * locking from the /dev/rtcN api.
                 */
                retval = rtc_read_alarm(rtc, &alm);
                if (retval < 0)
                        return retval;
                if (alm.enabled)
                        return -EBUSY;

                alm.enabled = 1;

People should not be "accidentally" writing to sysfs files...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
