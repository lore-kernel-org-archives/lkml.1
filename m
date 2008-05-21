Return-Path: <linux-kernel-owner+w=401wt.eu-S933488AbYEULEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbYEULEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbYEULEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:04:31 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:37444 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbYEULEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:04:30 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-11.tower-164.messagelabs.com!1211367868!25701070!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Wed, 21 May 2008 13:04:16 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <lethal@linux-sh.org>, <gregkh@suse.de>, <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Message-ID: <20080521110416.GA10407@digi.com>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se> <20080520210713.GE3220@local> <aec7e5c30805202031x62b3b463lfde0b9e7eb32d35@mail.gmail.com> <20080521064938.GA11580@digi.com> <aec7e5c30805210109p664fd917r32f8dc6aa1c4c746@mail.gmail.com> <20080521092533.GB29607@digi.com> <aec7e5c30805210350l41b537c3n70cfef2e10b54548@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30805210350l41b537c3n70cfef2e10b54548@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 May 2008 11:04:17.0260 (UTC) FILETIME=[697CBAC0:01C8BB32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> On Wed, May 21, 2008 at 6:25 PM, Uwe Kleine-König
> <Uwe.Kleine-Koenig@digi.com> wrote:
> > Magnus Damm wrote:
> >> On Wed, May 21, 2008 at 3:49 PM, Uwe Kleine-König
> >> > What about adding uio_platform_handler (with a different name) to
> >> > uio_pdrv.c?
> >>
> >> I'm not sure if it will help. What would such function do? Please explain.
> > Just add irq_disabled to struct uio_platdata and define
> >
> >        irqreturn_t uio_pdrv_disirq(int irq, struct uio_info *dev_info)
> >        {
> >                struct uio_platdata *pdata = container_of(dev_info, struct uio_platdata, uio_info);
> >
> >                disable_irq(irq);
> >                pdata->irq_disabled = 1;
> >                return IRQ_HANDLED;
> >        }
> >        EXPORT_SYMBOL(uio_pdrv_disirq);
> >
> >        void uio_pdrv_enirq(struct uio_info *dev_info)
> >        {
> >                ...
> >        }
> >        EXPORT_SYMBOL(uio_pdrv_enirq);
> >
> > and then you can do
> >
> >        info->handler = uio_pdrv_disirq;
> >        info->enable_irq = uio_pdrv_enirq;
> >
> > in the arch specific code.  I just realize that you need to compile UIO
> > statically then :-(
> 
> I understand now. Thanks for the clear description.
> 
> What about letting the uio_pdrv code override info->handler and
> info->enable_irq with the above functions if info->handler is NULL?
... if both info->handler and info->prep_read_poll are NULL and
info->irq >= 0.

> That would be one step closer to a shared driver in my opinion. And it
> would remove the need for symbol exports and solve the
> static-compile-only issue.
> 
> The physically contiguous memory issue still needs to be solved
> somehow though. What about using struct resouce flagged as
> IORESOURCE_DMA to pass the amount of memory that should be allocated?
I'm not sure that solving that problem in uio_pdrv is the right
approach.  Other uio drivers might have the same problem, so better
allow the userspace driver to allocate some memory in a more generic
way?
 
> >> My uio_platform driver handles interrupts in a different way. The
> >> kernel UIO driver is not aware of the hardware device specific method
> >> to acknowledge the interrupt, instead it simply disables the interrupt
> >> and notifies user space which instead will acknowledge the interrupt.
> >> Next time a read() or poll() call gets made, the interrupt is enabled
> >> again.
> >>
> >> This allows us to export a hardware device to user space and allow
> >> user space to handle interrupts without knowing in kernel space how to
> >> acknowledge interrupts.
> > OK, got it.  The down-side is that you can only get a single interrupt
> > between two calls to read() (or poll()).  So you might or might not
> > loose information.  And you might run into problems if your device or
> > your interrupt goes berserk as your handler always returns IRQ_HANDLED.
> > With a functional handler you can rely on existing mechanisms in the
> > kernel.
> 
> I agree that I only get a single interrupt, but I'm not agreeing
> regarding the problems. =)
> 
> In my mind, disabling interrupts and acking them from user space only
> leads to increased interrupt latencies. People may dislike increased
> interrupt latencies, but if so they shouldn't have their driver in
> user space. And you may of course choose to ack interrupts in kernel
> space and queue information there which user space later reads out.
> But that sounds more like a specialized kernel driver. And that is not
> what i'm trying to do.
> 
> Regarding loosing information, if your hardware device can't cope with
> long latencies and drops things on the floor then improve your
> latency, increase buffer size or design better hardware. Also, I don't
> think the interrupt can go berserk since it will be disabled directly
> by the interrupt handler.
Assume your irq is stuck at its active level.  Normally the irq is
then disabled after some time.  You can handle that in your userspace
driver, but with acking in kernel space and returning IRQ_NONE or
IRQ_HANDLED you get it for free.  Nevertheless, go on.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
