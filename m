Return-Path: <linux-kernel-owner+w=401wt.eu-S1764689AbYBBRbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764689AbYBBRbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYBBRbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:31:41 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:43195 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751369AbYBBRbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:31:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=096iV6mN+mWgEoKB+uDF6WLl6ovguexHkFGmHYjY1I108fbrN3RsJuohX0DR6vMUOEGFlJ3Qr7r4ULWNKrf6ZXxqJPD7Ady4SgQ62nggQ2MqOWojA0gvvzgwsiOuKLStfZdOAj3y2+P9y/Y9y/Y6SpjUHb8uaSj6PdpX5dNmFYo=  ;
X-YMail-OSG: Mro1qVIVM1kpE29BDUqX6thtzd3AXAYJ5mDarqNGoCXBqeHS3y4pmipowvUBIl9j5OAXa4aOeg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] sleepy linux self-test
Date: Sat, 2 Feb 2008 09:31:38 -0800
User-Agent: KMail/1.9.6
Cc: linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080130131748.GA3796@elf.ucw.cz> <200801311755.33899.david-b@pacbell.net> <20080202124759.GB25773@elf.ucw.cz>
In-Reply-To: <20080202124759.GB25773@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802020931.38689.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, Pavel Machek wrote:
> Hi!
> 
> > > --- a/drivers/rtc/rtc-cmos.c
> > > +++ b/drivers/rtc/rtc-cmos.c
> > > @@ -78,7 +78,7 @@ static inline int is_intr(u8 rtc_intr)
> > >  
> > >  /*----------------------------------------------------------------*/
> > >  
> > > -static int cmos_read_time(struct device *dev, struct rtc_time *t)
> > > +int cmos_read_time(struct device *dev, struct rtc_time *t)
> > >  {
> > >
> > >	... etc ...
> > 
> > You should be using the standard RTC library calls, exported
> > from drivers/rtc/interface.c ... and making sure this mechanism
> > will work with any wakeup-capable RTC.  Otherwise you'll end
> > being needlessly x86-specific, or reinventing those calls.
> > 
> > Plus, the way you're doing it now is violating the locking
> > protocol used by that driver.
> 
> Yep, you are right, but that is the easy issue to fix.

Which is why I was puzzled that you didn't start out doing it
the "right" way ... even just hard-wiring the dubious assumption
that "rtc0" is the right RTC to use.  :)


> There's hard issue: I need 
> 
> struct rtc_device *rtc
> 
> for the rtc that can be used for system resume,

Well, "rtc which (a) has an alarm, (b) may be used for system wakeup".

Assuming there *is* such an RTC ... fortunately, there will usually be
one on systems that are designed to go to sleep.


> and I'd like to get it 
> without violating too many layers. How to do that?
> 
> Ideally, I need 
> 
> set_alarm(int)
> 
> ...that will magically pick the right rtc device to talk to, and set
> alarm on it. I don't see how to implement it with current code.

Easy enough.  Given an RTC device node, you can tell whether it has
no chance at all to meet those requirements:

	static int has_wakealarm(struct device *dev, void *name_ptr)
	{
		struct rtc_device *rtc = to_rtc_device(dev);

		/* (a) has an alarm */
		if (!rtc->op->set_alarm)
			return 0;

		/* (b) may be used for system wakeup */
		if (device_may_wakeup(dev->parent))
			return 0;
		
		*(char **)name_ptr = rtc->name;
		return 1;
	}

Then there's a new class interface you may not have known about,
since it's been merged barely over a week now.  You can use it
to find the name of the rtc to pass to rtc_open():

	static char *find_wake_rtc(void)
	{
		char *pony = NULL;

		dev = class_find_device(rtc_class, &rtc, has_wakealarm);
		return pony;
	}

On most PCs that will return the name "rtc0" ... and it'll do
the same on most of the other systems I have.  On both of the
two-RTC systems I have that will return "rtc1".   On systems
with no wakealarm-enabled RTC, that will return NULL.

Voila!

- Dave
