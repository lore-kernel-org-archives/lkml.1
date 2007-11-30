Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXK3VKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXK3VKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXK3VKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:10:44 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:27366 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751107AbXK3VKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:10:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1khSgG+nD0E5fJJ950Ki+h6Iysdi1sj5cr5w00BMffcGOXEzN5aq8sU1oAREdCY9JnnMONlPv3z0Sv99GHkpvvI3A19lvb5jqRSbgNxsXejvkBUkfS+GDngA/hnK3JTRjajl5QB2PTMnKoN+GwpeKM9k11g6hKJQnuwZM1zr3Sw=  ;
X-YMail-OSG: Ad1C2rEVM1kuCQlWi0LVW5vRhmOxzwtMbywRdGlaCbQsE5TY
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Date: Fri, 30 Nov 2007 13:10:40 -0800
User-Agent: KMail/1.9.6
Cc: rtc-linux@googlegroups.com, kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
References: <20070920103225.GA4410@elf.ucw.cz> <200711291010.12707.david-b@pacbell.net> <20071130203544.GB1677@elf.ucw.cz>
In-Reply-To: <20071130203544.GB1677@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301310.40360.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007, Pavel Machek wrote:
> > 
> > It's not an issue of accidental writes, it's an issue of there being
> > no other synchronization for setting those alarms.  Remember that both
> > RTC_WKALM_SET and RTC_ALM_SET ioctls can set that same alarm, and so
> > could a different userspace activity ...
> 
> We have 3 interfaces to one hardware resource. I do not think kernel
> should try to arbitrate it here. There's just one alarm clock with
> three interfaces.

Having three interfaces is bad enough ... ensuring that none of
them can ever be used safely would be stupid.


> > As written, this allows one userspace activity to clobber another if
> > it does so explicitly, by first disabling the other one and then
> > setting its own alarm.  But the idea is to minimize "accidents" like
> > unintentionally clobbering an alarm set by someone else.
> 
> Well, I could not get it to work with this "avoid-clobber" feature.

I had earlier pointed out a different issue, whereby "oneshot"
semantics weren't consistently followed.  I've been working on
some patches to address that.  The ACPI bits still need work,
but I'll forward one part soonish.


> > > If I remove "accidental alarm modify" logic, I can actually use rtc to
> > > wake up more than once per boot.
> > 
> > Evidently the alarm isn't being disabled then...

    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
That's the issue addressed by those patches.  (Specific to rtc-cmos,
not to RTCs on saner hardware.)


> I think we should just remove the 'avoid-clobber' logic. If userland
> wants to somehow arbitrate access, it can.

Pray tell, *HOW* could it arbitrate?


> Now, if we want to provide "nice" interface for timed sleep, I think
> we can. Actually, I'd like to use normal select() as such an
> interface,

Yeah, what ever happened to timerfd?  :)


> and enable kernel to automatically detect when it can sleep 
> and when it has to wake up.

There's the "rtcwake" thing.  That got merged into util-linux-ng, but
I happened to notice its setup_alarm() is calling gmtime() instead
of localtime() ... my suspicion is that the uClibc version I was using
had some timezone bugs, or else there's some other bug lurking in the
vicinity of dual-bootiness.

Note that "wakealarm" is not intende to be a "timed sleep" interface
at all ... it's just to set the wakealarm.  Something else is in charge
of putting the system to sleep, such as "echo mem > /sys/power/state"
or some GUI thing hooked up to logic that knows about how to make frame
buffers recover.

- Dave
