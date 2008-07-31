Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYGaUyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYGaUyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYGaUyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:54:06 -0400
Received: from mail.queued.net ([207.210.101.209]:4061 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYGaUyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:54:05 -0400
Date: Thu, 31 Jul 2008 16:53:46 -0400
From: Andres Salomon <dilinger@queued.net>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>,
       linux-geode@bombadil.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: MFGPT driver inhibits boot on some boards
Message-ID: <20080731165346.73901e9e@fred>
In-Reply-To: <20080731143635.GA12585@cosmic.amd.com>
References: <48916864.901@LiPPERTEmbedded.de>
	<20080731143635.GA12585@cosmic.amd.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 08:36:35 -0600
Jordan Crouse <jordan.crouse@amd.com> wrote:

> On 31/07/08 09:23 +0200, Jens Rottmann wrote:
> > The driver defaults to IRQ7. Our boards use this for the parallel
> > port. This alone would be ok, but the parallel port is on a LPC
> > SIO, so IRQ7 is routed to the LPC bus in MSR 51400025, so MFGPT
> > IRQs are not received.
> > 
> > Possible solution 1: make geode_mfgpt_set_irq() clear the needed
> > bit in MSR 51400025. This would break lp0, but at least Linux would
> > boot and users could cat /proc/interrupts and see what's going on.
> > 
> > Possible solution 2: make geode_mfgpt_set_irq() check the bit and
> > fail if the IRQ is routed to LPC. (I think I'd prefer this over 1.)
> 
> Either of these solutions is the "right" solution. I prefer
> automatically detecting the SIO interrupts and finding a free
> interrupt. 
> 

Except the broken lp0 would be a problem, no?


> > But that's not clean, even an IRQ not routed to LPC might be the
> > wrong one. The BIOS we're using (Insyde BIOS, uses VSA and 5
> > MFGPTs, but leaves 3 timers available) exports a PCI header for
> > MFGPT, which of course gets an IRQ assigned (LNKB-->IRQ11), and
> > this is the right IRQ to use. Some autodetection instead of
> > hardcoding IRQ7 would be perfect. But looking for the PCI header
> > won't work, because AMD removed them from the spec, most BIOSes
> > don't support them (any more) and some day our BIOS will hide them,
> > too.
> 
> I know the platform you are talking about - that was a special test
> case the MFGPT header.  It would have become standard, but then
> circumstances intervened, and we lost the resources to push that into
> the VSA and to all of our BIOS vendors.  It is easiest for us to
> assume that we won't have the PCI header for the MFGPT.
> 
> > I guess MSR 51400022 aka MSR_PIC_ZSEL_LOW is the key here.
> > geode_mfgpt_set_irq() overwrites this unconditionally, which I
> > think is bad. If the BIOS has already set an IRQ here, the driver
> > should keep it and assume it to be ok.
> 
> Agreed.
> 
> > Possible solution 3: keep the IRQ already chosen in MSR_PIC_ZSEL_LOW
> > unless it's 0, only in that case use IRQ7
> 
> This goes against our basic policy of not trusting the BIOS.
> 

At some level, we have to trust the BIOS (especially when its is
filling in MSRs for us).   I think I prefer #3.  At the same time,
Jordan has a better idea of how BIOSes out there might manage to
screw up the entries in PIC_ZSEL_LOW... 


[...]
> > IMHO hardcoding IRQ7 is bad. Yes, you can override it, but this
> > isn't some non-critical device driver like audio where only this
> > one device won't work. And MFGPT can't be compiled as module, so
> > initramfs can't do anything about it.
> > I think, if there is any chance to do it, Linux should be able to
> > boot without any parameters given - even if with reduced
> > functionality.
> 
> I agree 100%.

Ditto.
