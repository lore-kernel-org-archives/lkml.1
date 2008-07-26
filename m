Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYGZT6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYGZT6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 15:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYGZT6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 15:58:06 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:30364 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751166AbYGZT6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 15:58:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GBfAq4glQ9L9fjY8+S0btBnIOqn6RZJq9NdMnZIrI5PnfAGV1FKB+ZI4HI08vgsUZQfsz7XiHZpi9y20AlfcLzWfCTi32utLKEXUOMVMfeHtonvKOT1kNixrOrlMW2XXIG2YNIWrlLAKR8+SiHBTF/sy5NjWLUh+vNOYWQB9Xis=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Date: Sat, 26 Jul 2008 12:58:02 -0700
User-Agent: KMail/1.9.9
Cc: =?utf-8?q?Tom=C3=A1=C5=A1_Janou=C5=A1ek?= <tomi@nomi.cz>,
       linux-kernel@vger.kernel.org
References: <20080726154617.GA5613@notes.lisk.in> <20080726180610.GA12168@nomi.cz> <20080726201355.064a789e@i1501.lan.towertech.it>
In-Reply-To: <20080726201355.064a789e@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807261258.02753.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 July 2008, Alessandro Zummo wrote:
> On Sat, 26 Jul 2008 20:06:10 +0200 Tomáš Janoušek <tomi@nomi.cz> wrote:
> > On Sat, Jul 26, 2008 at 07:55:21PM +0200 Alessandro Zummo wrote:
> > 
> > >  I'm not sure this is appropriate. sometimes the PIE is used to control
> > >  external hardware and it doesn't make sense to have an application that's
> > >  always open to handle that. 

I'd stay that having an application running is the standard way
to handle such stuff!

In fact, how could the 1/(2^N) Hz periodic interrupt ever control
external hardware *by itself*?  It would need some control path
that's not part of the programming interface, like routing some
signal from the RTC to that hardware.  That's PWM functionality,
and isn't available from all timers/clocks/rtcs.

The only control path in scope of the RTC programming interface is
client/application code responding to a (periodic) IRQ by issuing
some type of command.


> > > 
> > >  Any app should be responsible to release what it has allocated, if appropriate,
> > >  and not rely on someone else to do on his behalf.

But exiting a task is responsible for freeing all of its kernel
resources ... closing file descriptors, releasing memory, and
so forth.  Programs rely on that, as in this case.


> > mplayer and aireplay-ng have never done so. And what about crashes? Am I
> 
>  that's not an excuse, they have been written on a false assumption. Unless
>  that behaviour is documented somewhere.

We can't rely on documentation for interfaces (like the legacy RTC
interface which the RTC framework is emulating) that never really
had complete documentation!!

In this case, we need to follow interface behavior, as observed, when
it's not a bug.  Like shutting down periodic IRQs on close()...


> > supposed to create a small "rtcpieoff" applications and make it into all
> > distributions so that everyone can clean up the mess?
> 
>  just send patches to mplayer and aireplay-ng and it will make in the distros.

Except ... that makes it even more clear that you're suggesting
changes to a well established userspace interface.  Which is not
something we like doing to the Linux userspace community.


> > Additionally, it has been a regression against the old rtc and drivers like
> > rtc-sh do so even today.
> 
>  Specific drivers might choice to do it on close. I believe rtc-cmos might
>  be one of the few that might have to do it in order to cope with badly
>  written programs. It's up to David to choice if it's appropriate too add it to
>  rtc-cmos. 

I want the framework to handle it, since that's how the RTC
programming interface has traditionally behaved and since there
should be as few driver-specific behaviors as practical.

Remember, those programs should not be growing needless
hardware dependencies.  In particular "only works on x86"
would be really nasty.

If it needs to be changed on x86 so that most Linux programs
behave correctly again, then it needs to be changed for all
RTC drivers.  Which means updating the framework is the most
effective way to solve the problem.

- Dave

