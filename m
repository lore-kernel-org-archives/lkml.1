Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbXK3UfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbXK3UfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXK3UfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:35:04 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51883 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750720AbXK3UfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:35:02 -0500
Date: Fri, 30 Nov 2007 21:35:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com, kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Message-ID: <20071130203544.GB1677@elf.ucw.cz>
References: <20070920103225.GA4410@elf.ucw.cz> <200709212238.05130.david-b@pacbell.net> <20071128232647.GC4947@elf.ucw.cz> <200711291010.12707.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711291010.12707.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > rtc-sysfs.c: why this?
> > 
> >         if (alarm > now) {
> >                 /* Avoid accidentally clobbering active alarms; we can't
> >                  * entirely prevent that here, without even the minimal
> >                  * locking from the /dev/rtcN api.
> >                  */
> >                 retval = rtc_read_alarm(rtc, &alm);
> >                 if (retval < 0)
> >                         return retval;
> >                 if (alm.enabled)
> >                         return -EBUSY;
> > 
> >                 alm.enabled = 1;
> > 
> > People should not be "accidentally" writing to sysfs files...
> 
> It's not an issue of accidental writes, it's an issue of there being
> no other synchronization for setting those alarms.  Remember that both
> RTC_WKALM_SET and RTC_ALM_SET ioctls can set that same alarm, and so
> could a different userspace activity ...

We have 3 interfaces to one hardware resource. I do not think kernel
should try to arbitrate it here. There's just one alarm clock with
three interfaces.

> If there's no alarm set, it's clear that changing the (single) alarm
> can't cause event lossage.  But if an alarm *is* set it sure seems
> that changing it would discard an event that something was expecting,
> and thus cause breakage.

I do not believe current interface has any users. ...or any users that
would break anyway.

> As written, this allows one userspace activity to clobber another if
> it does so explicitly, by first disabling the other one and then
> setting its own alarm.  But the idea is to minimize "accidents" like
> unintentionally clobbering an alarm set by someone else.

Well, I could not get it to work with this "avoid-clobber" feature.

> > If I remove "accidental alarm modify" logic, I can actually use rtc to
> > wake up more than once per boot.
> 
> Evidently the alarm isn't being disabled then...
> 
> I think the issue there is that the alarm isn't acting as a one-shot
> event.  There are some model questions lurking there ... if the RTC
> has a sane alarm model, "fire at YYYY-MM-DD at HH:MM:SS", then it's
> naturally one-shot.
> 
> But if the YYYY-MM-DD part is a wildcard (or equivalently, ignored)
> at the hardware level, that model is awkward.  You can't easily look
> at such alarms and know if they already triggered -- especially after
> hibernation.  With respect to rtc-cmos, it'd always be practical to
> disable the alarm after it triggers while the system is running.
> (Not currently done, pending resolution of such issues.)  And there's
> an ACPI flag -- currently ignored by Linux, or maybe trashed -- to
> report whether the system wakeup was triggered by an alarm; that
> could be read, and used to disable the alarm.

I think we should just remove the 'avoid-clobber' logic. If userland
wants to somehow arbitrate access, it can.

Now, if we want to provide "nice" interface for timed sleep, I think
we can. Actually, I'd like to use normal select() as such an
interface, and enable kernel to automatically detect when it can sleep
and when it has to wake up.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
