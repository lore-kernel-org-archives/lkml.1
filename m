Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbXK2SLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbXK2SLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763852AbXK2SKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:10:43 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:32965 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763777AbXK2SKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:10:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QgHZHxLQBplA8mCLswwM3/TAntbt2T9nssFdYax5S7VULq3oSWuiAZkgsLvJIB5/tvIpwsDQ/4LfO1J97Xb0lLh3O65+o9rg/vnA4VBgQCCTt2yhn7OFWMHR+0LXylzPD7n/5UWesuQAyY8wQmmmmj9mFE9hqCn79LTYD2vPW5E=  ;
X-YMail-OSG: lwPCHQUVM1mNZK1www9bG9SJe3QlQYc0.JIkNwzp4g_rr9AqT.bQTnwgSNykMFVk5PMGe7DVnw--
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Date: Thu, 29 Nov 2007 10:10:12 -0800
User-Agent: KMail/1.9.6
Cc: rtc-linux@googlegroups.com, kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
References: <20070920103225.GA4410@elf.ucw.cz> <200709212238.05130.david-b@pacbell.net> <20071128232647.GC4947@elf.ucw.cz>
In-Reply-To: <20071128232647.GC4947@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711291010.12707.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007, Pavel Machek wrote:
> > Are you sure it's not working?  Other than the two issues I noted
> > above -- borkage w.r.t. ACPI (which wasn't necessarily shown in your
> > scripts above), and with wildcarding -- it looked to be correct.
> 
> It seems to be working now, not sure what changed.

There were some patches from Mark Lord to update the wildcarding,
and to hibernation to work better with ACPI.  I still don't think
the wildcarding is done quite right; there are some date-wrap cases
that looked wrong.


> rtc-sysfs.c: why this?
> 
>         if (alarm > now) {
>                 /* Avoid accidentally clobbering active alarms; we can't
>                  * entirely prevent that here, without even the minimal
>                  * locking from the /dev/rtcN api.
>                  */
>                 retval = rtc_read_alarm(rtc, &alm);
>                 if (retval < 0)
>                         return retval;
>                 if (alm.enabled)
>                         return -EBUSY;
> 
>                 alm.enabled = 1;
> 
> People should not be "accidentally" writing to sysfs files...

It's not an issue of accidental writes, it's an issue of there being
no other synchronization for setting those alarms.  Remember that both
RTC_WKALM_SET and RTC_ALM_SET ioctls can set that same alarm, and so
could a different userspace activity ...

If there's no alarm set, it's clear that changing the (single) alarm
can't cause event lossage.  But if an alarm *is* set it sure seems
that changing it would discard an event that something was expecting,
and thus cause breakage.

As written, this allows one userspace activity to clobber another if
it does so explicitly, by first disabling the other one and then
setting its own alarm.  But the idea is to minimize "accidents" like
unintentionally clobbering an alarm set by someone else.


> If I remove "accidental alarm modify" logic, I can actually use rtc to
> wake up more than once per boot.

Evidently the alarm isn't being disabled then...

I think the issue there is that the alarm isn't acting as a one-shot
event.  There are some model questions lurking there ... if the RTC
has a sane alarm model, "fire at YYYY-MM-DD at HH:MM:SS", then it's
naturally one-shot.

But if the YYYY-MM-DD part is a wildcard (or equivalently, ignored)
at the hardware level, that model is awkward.  You can't easily look
at such alarms and know if they already triggered -- especially after
hibernation.  With respect to rtc-cmos, it'd always be practical to
disable the alarm after it triggers while the system is running.
(Not currently done, pending resolution of such issues.)  And there's
an ACPI flag -- currently ignored by Linux, or maybe trashed -- to
report whether the system wakeup was triggered by an alarm; that
could be read, and used to disable the alarm.

I think the right thing to do there is just insist that in the RTC
framework, alarms should always follow the one-shot model.

- Dave
