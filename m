Return-Path: <linux-kernel-owner+w=401wt.eu-S1030299AbXCAVf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030299AbXCAVf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030300AbXCAVf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:35:56 -0500
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:45938 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030299AbXCAVfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:35:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=s0kILt1bVFlYkjNM+6w5djvnKQdA/TUVcbQGQuLRoi415AWs6dDbR0tPVCGrXww9/QH2KOP0hXpGwj8rMgMiUswRZ4uRqFCynus7L3LURagVpzOtwCamiWjEM4DyZMOWbaUoHSt79tr6Hf+yDCp5E3Ys4uSWE5jnQS6j9P15HBw=  ;
X-YMail-OSG: BHs1bPoVM1kb36sRHWr3AfHezZh_MmtkC6QllIkbYi66QU7PUbTocmS4k78sIcEoWpAMy0B5sda4JSocntrbKjIIckWemSv2ThEJ2fItOYBO5bB1g8qTuMvCD957z4x0YkqJQ35Xjpp.oA--
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: + blackfin-on-chip-rtc-controller-driver.patch added to -mm tree
Date: Thu, 1 Mar 2007 13:35:47 -0800
User-Agent: KMail/1.7.1
Cc: akpm@linux-foundation.org, bryan.wu@analog.com, mm-commits@vger.kernel.org,
       a.zummo@towertech.it, "Paul Mundt" <lethal@linux-sh.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200703010848.l218me3e008819@shell0.pdx.osdl.net> <200703011039.32876.david-b@pacbell.net> <8bd0f97a0703011106j7cb3664dx190686b0251cd1fa@mail.gmail.com>
In-Reply-To: <8bd0f97a0703011106j7cb3664dx190686b0251cd1fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011335.48430.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 11:06 am, Mike Frysinger wrote:

> > The set_alarm() method needs to enable the alarm irq if the
> > "enabled" flag is set, and the read_alarm() method needs to
> > report whether the alarm is enabled.
> 
> from reading other drivers and the documentation,

That particular call came from the RTC interface exposed by EFI,
which is pretty clear on things.  The only notable glitch in
translating it to Linux is that Linux splits "alarm" and "wakeup"
capabilities ... but then, EFI lets you poll that RTC and gives
effectively that same consequence:  alarm not coupled to wakeup,
at least if the system isn't asleep.


> > It's unclear why you
> > chose to report "pending" (irq issued but not yet acked) since
> > that's uselessly transient state on non-polled hardwre.  (That
> > flag definition came from EFI, a polled firmware RTC.)
> 
> because other drivers do ?  there is no documentation here that covers
> what exactly the read_alarm function in the rtc_class_ops is supposed
> to do which leaves it up to people looking at other drivers
> 
> rtc-sa1100.c for example:
> static int sa1100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> {
>     memcpy(&alrm->time, &rtc_alarm, sizeof(struct rtc_time));
>     alrm->pending = RTSR & RTSR_AL ? 1 : 0;
>     return 0;
> }

Look again, but at 2.6.21-rc2 instead ... ISTR that fix went into RC1,
but that one's been fixed in various trees (like handhelds.org) for
some time.


> if someone decides what the behavior is supposed to be here, i'll
> happily implement it
> 
> > Correct handling of the "enabled" flag in read_alarm() will let
> > you remove a redundant seq_printf() in your proc() callback...
> 
> i dont understand this ... rtc-sh.c and rtc-sa1100.c both do a
> seq_printf() for the alarm irq

Look again at current kernel sources ... bugfixes have been merged
since the codebase you seem to have used as a reference.  I did an
audit of driver handling of those flags; most drivers are now fixed.


> > It looks to me like you're handling the time in set_alarm()
> > incorrectly.  Do the conversion and test in set_alarm, not
> > AIE_ON ... since set_alarm() needs to be able to include AIE_ON
> > capability.
> 
> the reason for this is so that i do not have to worry about keeping
> two structures in sync ... there's the common RTC representation and
> then there's the funky Blackfin representation, so by delaying the
> conversion until RTC_AIE_ON, i didnt have to worry about keeping these
> fields in sync

Yes, Blackfin has an unusually funky representation, but that
doesn't mean you can't do the conversion when the alarm time
comes into the driver.  It's not like the alarm is based on
offset-from-current-time, so that it'd need to be adjusted when
the current time gets updated (like some RTCs)... it's just a
strange way to encode an absolute time.


> > The fields tm_{wday,yday,isdst} are never used,
> > but you're testing tm_yday.  If you meant to test tm_mday in
> > order to distinguish the WKALM_SET and ALM_SET cases, then you
> > are mishandling a wraparound case; see how rtc-omap handles
> > it.  (If it's 23:00 now, an 01:00 alarm means TOMORROW.  I
> > think other RTCs may goof this case too.)
> 
> this is exactly why i'm checking tm_yday ... the rtc-dev interface
> sets those fields to -1 when using the WKALM ioctls and there's no
> other way to distinguish this

Thing is, "man 4 rtc" reports those fields as unused, which means
they can come from userspace with arbitrary values.  You should
stick to testing tm_mday, which *is* used.


> if the wraparound case is so common, then perhaps it should be a
> helper function in the generic rtc code rather than reimplementing in
> every rtc driver ...

You have a point there.  Someone (other than me) should come
up with a patch to handle that.

- Dave

 
> > The use of class_device conflicts with the patch series I
> > recently resubmitted, see it on rtc-linux@googlegroups.com ...
> > if you submit a separate patch, then maybe your Blackfin RTC
> > can be merged first.
> 
> i'll take a look
> -mike
> 
