Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbYFJGLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbYFJGLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 02:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYFJGL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 02:11:28 -0400
Received: from mail161.messagelabs.com ([216.82.253.115]:10201 "EHLO
	mail161.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYFJGL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 02:11:27 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-161.messagelabs.com!1213078285!9689144!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Tue, 10 Jun 2008 08:11:21 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080610061121.GA22814@digi.com>
References: <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local> <20080609075701.GA20656@digi.com> <20080609095408.GB3223@local> <20080609123204.GA27803@digi.com> <20080609142007.GH3223@local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080609142007.GH3223@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Jun 2008 06:11:21.0909 (UTC) FILETIME=[CE05FE50:01C8CAC0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

> > > > - Either rely on userspace to enable the irq before reading/polling or
> > > >   assert that in kernel space.  See also
> > > >   http://thread.gmane.org/gmane.linux.kernel/684683/focus=689635
> > > >   (I asked tglx about the race condition via irc, but without a response
> > > >   so far.)
> > >
> > > There are two problems:
> > > 1) If the hardware is designed in such a broken way that userspace needs
> > > a read-modify-write operation on a combined irq mask/status register to
> > > re-enable the irq, then this is racy against a new interrupt that occurs
> > > simultaneously. We have seen this on two devices so far.
> > You didn't understand what I want.  (Probably because I choosed a poor
> > wording.)
> >
> > IMHO it should be asserted that irqs are on before waiting for the irq
> > in poll and read.  So I suggest to call irqcontrol(ON) before doing so.
> > This should allow to work with that kind of hardware, right?
> 
> Yes. But userspace can simply write() a 1 to /dev/uioX to achieve the
> same result. This would clearly show what's happening. Remember, this is
> only needed for certain (broken) hardware. If we hide some automagic irq
> enabling in the kernel, it'll become less obvious and might even have
> some bad side effects. I want to avoid this kind of trickery, especially
> as it is not needed. Userspace should use write() to control irqs. It's
> like this with any normal UIO driver, and we shouldn't have a different
> handling in uio_pdrv.
> Think of a chip that's directly connected to the bus on some embedded
> board. You use uio_pdrv to handle it. Then the very same chip appears on
> a PCI card in a normal PC. You write a normal UIO driver for it. The
> userspace part of both drivers could be exactly the same. But if
> uio_pdrv automagically reenabled the irq, we would need different
> handling in userspace, without reasons obvious to the user.
Note that my intention is to enable irqs in uio.c, not uio_pdrv.c.  So
you could still use the same driver for a PCI card and similar a memory
mapped chip.

Probably I should show some code, but I think I won't have time today to
do so and then I will be in vacation for two weeks.  So this has to
wait.
 
> > > > The last point is a bit independent from that mode, but applies to
> > > > devices that have a irqcontrol function in general.
> > > >
> > > > Apart from the general things above, I'd change a few things in the
> > > > implementation:
> > > >
> > > >  - call dev_info->irqcontrol(OFF) in the handler (instead of
> > > >    disable_irq()) and demand that calling this is idempotent.
> > > >    With this change it isn't uio_pdrv specific any more and could go to
> > > >    uio.c.
> > >
> > > Why should we want to do this? You save five lines of irq handler code
> > > by introducing the need for an irqcontrol() function.
> > Taking Magnus' patch there is a default irqcontrol() function that does
> > the right thing in this case.  This should probably go to uio_pdrv.c.
> 
> Just doing irq_disable() limits it to irqs that are not shared. If there
> was a huge advantage, I'd think about it. But as it is, I'll never
> accept that. Magnus' patch is not needed, not even by himself.
I don't suggest to *use* that function per default, just provide it and
allow board support to use it as a call back.

> > > I already said that in the discussion with Magnus, I don't see any
> > > advantage in this. Magnus cannot tell me either, he just keeps telling
> > > me "but we can do it" over and over again.
> > I think the benefit is to add some code to uio_pdrv and/or uio and in
> > turn save some code in board support code.
> 
> Yes, but the savings (if any) are small compared with the disadvantages.
Currently I don't see any disadvantages.  IMHO we should wait on a new
version of Magnus' patch.  Then we can discuss this more effective
referering to code.
 
Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
