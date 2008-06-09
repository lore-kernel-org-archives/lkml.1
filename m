Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbYFIMcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbYFIMcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbYFIMcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:32:10 -0400
Received: from mail161.messagelabs.com ([216.82.253.115]:40822 "EHLO
	mail161.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbYFIMcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:32:09 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-11.tower-161.messagelabs.com!1213014727!8967329!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Mon, 9 Jun 2008 14:32:04 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080609123204.GA27803@digi.com>
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se> <20080604101144.GA3207@local> <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local> <20080609075701.GA20656@digi.com> <20080609095408.GB3223@local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080609095408.GB3223@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 Jun 2008 12:32:04.0347 (UTC) FILETIME=[D2C3ACB0:01C8CA2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Hans J. Koch wrote:
> On Mon, Jun 09, 2008 at 09:57:01AM +0200, Uwe Kleine-König wrote:
> > Hello Hans,
> >
> > > Did you notice that in this thread nobody spoke up to support your
> > > patch?
> > Actually I like what the patch tries to achieve.  I'd like to have it a
> > bit more explicit tough:
> >
> > - Provide the irq disabling handler in uio_pdrv.c (or even uio.c) with a
> >   prototype in an adequate header.  Then the platforms that want this
> >   kind of handling can request it explicitly.
> 
> You could provide an irqcontrol() function in uio_pdrv that calls a function
> defined in board support. If no function is defined there, it returns
> -ENOSYS. That would be consistent behaviour and not limited to
> non-shared interrupts. Note that this requires the add-write-function
> patch I recently posted.
I didn't check, but I think this is what is happening just now, though
with a different implementation: board support passed the uio_info which
might or might not include a irqcontrol() function.  This is given
unchanged to uio_register.  Assuming that writing without an
irqcontrol() function yields -ENOSYS we're already there.
 
> > - Don't use this handler automatically.
> >
> > - Provide the function named uio_pdrv_unique_irqcontrol in Magnus' patch
> >   in uio_pdrv.c and in an adequate header.
> 
> Why invent a new name? The approach above works with all kinds of irqs on
> all platforms.
> 
> >
> > - Either rely on userspace to enable the irq before reading/polling or
> >   assert that in kernel space.  See also
> >   http://thread.gmane.org/gmane.linux.kernel/684683/focus=689635
> >   (I asked tglx about the race condition via irc, but without a response
> >   so far.)
> 
> There are two problems:
> 1) If the hardware is designed in such a broken way that userspace needs
> a read-modify-write operation on a combined irq mask/status register to
> re-enable the irq, then this is racy against a new interrupt that occurs
> simultaneously. We have seen this on two devices so far.
You didn't understand what I want.  (Probably because I choosed a poor
wording.)

IMHO it should be asserted that irqs are on before waiting for the irq
in poll and read.  So I suggest to call irqcontrol(ON) before doing so.
This should allow to work with that kind of hardware, right?
 
> 2) If we wanted to make sure the interrupt is enabled in read() and
> poll(), we would have the problem that userspace usually calls poll()
> and then read() immediately afterwards. This would enable the irq twice,
> which can lead to two interrupts being seen in some cases.
OK, for this case a pending flag would be needed.  (This doesn't mean I
suggest to implement it that way.)  I'll think about that a bit.

> For both reasons, we decided that introducing the write() function to
> enable and disable irqs is the best solution. Greg already added that
> patch to his tree, so it should appear in one of the next kernels.
> 
> >   Currently the former is done, but if we decide to let it as it is, I'd
> >   like to have it documented.  (I.e. something like:  "Before
> >   polling/reading /dev/uioX assert that irqs are enabled.")
> 
> We cannot do this, at least not in a clean way.
We cannot document it in a clean way?  (Probably not, I assume "this"
still refers to "enable the irq in read and poll"?)
 
> > The last point is a bit independent from that mode, but applies to
> > devices that have a irqcontrol function in general.
> >
> > Apart from the general things above, I'd change a few things in the
> > implementation:
> >
> >  - call dev_info->irqcontrol(OFF) in the handler (instead of
> >    disable_irq()) and demand that calling this is idempotent.
> >    With this change it isn't uio_pdrv specific any more and could go to
> >    uio.c.
> 
> Why should we want to do this? You save five lines of irq handler code
> by introducing the need for an irqcontrol() function.
Taking Magnus' patch there is a default irqcontrol() function that does
the right thing in this case.  This should probably go to uio_pdrv.c.

> I already said that in the discussion with Magnus, I don't see any
> advantage in this. Magnus cannot tell me either, he just keeps telling
> me "but we can do it" over and over again.
I think the benefit is to add some code to uio_pdrv and/or uio and in
turn save some code in board support code.  In fact this is similar to
the whole uio_pdrv driver.  Each platform could implement it without
much hassle itself.  But having all that in one central place makes it
easier for most people.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
