Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbYG0Gum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbYG0Gum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYG0Gud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:50:33 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:35602 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752585AbYG0Guc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:50:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tWer5bTJl4ViTrWZY9OJiQCAoI9nPypS8IpfgHDGRUwd5m+DZ8svBKZy8UhoKDkNKtyjeGCukaY9mXbyftM4gzIEq3f9GCRYAqQqTO2RXfVmNJ/2ScuLCjruEzZ0fmyalPQ+m2VE9iJNFxqccjU0EYWgajwCnbf/5LT4UBLGV6c=  ;
X-YMail-OSG: .1RZIS4VM1ktseJBmLXOit_IqdSa9hrHjD0rHYLy65N7c8A9gCCbsXJ8dnE.04_bpL0f6Ax8V8u_3AkVaZLlG9zlYRBKQpMx1Rou5ZnBlw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Date: Sat, 26 Jul 2008 22:03:36 -0700
User-Agent: KMail/1.9.9
Cc: "Tomas Janousek" <tomi@nomi.cz>, linux-kernel@vger.kernel.org,
       "Alessandro Zummo" <alessandro.zummo@towertech.it>
References: <20080726154617.GA5613@notes.lisk.in> <200807261350.55524.david-b@pacbell.net> <8bd0f97a0807262003y4000f55eh45d5d1b8c866fd10@mail.gmail.com>
In-Reply-To: <8bd0f97a0807262003y4000f55eh45d5d1b8c866fd10@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807262203.37023.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 July 2008, Mike Frysinger wrote:
> On Sat, Jul 26, 2008 at 4:50 PM, David Brownell wrote:
> > On Saturday 26 July 2008, Tomas Janousek wrote:
> >> I am aware that some drivers, like rtc-sh, handle userspace PIE sets in their
> >> ioctl op, exporting the irq_set_state op at the same time. The logic in
> >> rtc_irq_set_state should make sure it doesn't matter and the driver should not
> >> need to care stopping periodic interrupts in its release routine any more.
> >> I did not look at other drivers though.
> >
> > A quick grep shows that out of 42 (wow!) current RTC drivers:
> >
> >  - rtc-{bfin,sa1100,sh,test} support ioctl(PIE_ON/PIE_OFF), at least
> >   before some recent patches fixing that glitch (not in my tree) by
> >   switching to irq_set_state().
> 
> the rtc-bfin.c patches are in some queue somewhere to fix this ;)

Andrew's queue I hope!  Though right now I expect he's taking a
deep breath after merging over seven hundred patches for RC1 and
so he may not be quite current on the other stuff.  :)


> >  - Of those:  rtc-{bfin,s3c,sa1100,sh,vr41xx} all have release()
> >   methods ... though it looks to me like most of those wrongly
> >   disable *all* IRQs, even ones in use by something other than
> >   the /dev client closing that FD.
> 
> rtc-bfin.c turns off all irqs and frees it in the release() function
> (since the irq is requested in the open() function).  i guess that
> isnt supposed to happen huh.

I generally expect IRQs to be requested in probe() and freed in
remove(), so it's just a bit odd ... the main thing is that kernel
interfaces to alarm and periodic IRQs (drivers/rtc/interface.c) will
misbehave if IRQs only work when the RTC is driven from userspace.

So will wake alarms triggered through sysfs, though that driver
may not support that yet.


> > That suggests there's quite a mess yet to be fixed.  This patch
> > will ensure that periodic IRQs get properly shut off by close()
> > or exit() of a task that started them.  Those release() methods
> > shouldn't then be second-guessing things.
> >
> > And then there are the other two types of IRQ.  Update IRQs can
> > only be enabled through ioctl(UIE_ON), so they're fair game to
> > turn off when closing /dev files.  Alarms seem to be a special
> > case -- best not touched when closing files.
> 
> specific drivers shouldnt worry about this then right ?
> handle it in rtc-dev ? 

That's what I believe, yes.  That approach has a nice benefit
of letting all the RTC release() infrastructure vanish (I think,
based on a quick scan of the methods) ... and even shrinks
the rtc-dev.c code a bit.  In my book, it's particularly good
to remove code when it makes things behave more consistently.

- Dave

