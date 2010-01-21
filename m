Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968Ab0AUTjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0AUTjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 14:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581Ab0AUTjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 14:39:53 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59875 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab0AUTjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 14:39:52 -0500
Date: Thu, 21 Jan 2010 14:39:51 -0500
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: Strange EHCI/OHCI IRQ and other PCI errors on boot with 2.6.32
	(which 2.6.26 did not see) on Geode LX/CS5536.
Message-ID: <20100121193951.GS24305@caffeine.csclub.uwaterloo.ca>
References: <20100120223855.GQ24305@caffeine.csclub.uwaterloo.ca> <Pine.LNX.4.44L0.1001202043540.3608-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1001202043540.3608-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 08:52:03PM -0500, Alan Stern wrote:
> You could try changing the set of drivers loaded in memory.  For 
> example, after booting with irqpoll you can unload ehci-hcd plus some 
> other driver, and then load ehci-hcd again.  If the IRQ storm occurs 
> then you'll know where to look.
> 
> > > Does 2.6.26 fail on the new machine?
> > 
> > Yes.
> > 
> > As far as I can tell some machines don't see the problem.  I am still
> > investigating that.
> 
> Same kernel, initramfs, and everything else?

Same 2.6.26 kernel, there is no initramfs involved.  Some user space
code has been updated on this one.

> What I meant was: Is your current 2.6.26 still built using the same 
> .config as the old 2.6.26 which used to work okay?

I haven't actually rebuilt 2.6.26.  It is the same kernel image.

I wonder if some of the cpu modules have a flaw that's making the IRQ
line go crazy.  I wasn't normally using it before except when a cellular
usb modem was installed.

I will try booting the same release of software on my box as the one
that works and see if it still sees a problem...

So it turns out every box behaves the same, but only if I change the
order things are loaded in.  If I load the usb driver before programming
the FPGA on the LPC bus, then I get the IRQ flood.  If I program the
FPGA first, then no problem.  I don't understand why since the LPC bus
has been told not to handle IRQ 5 at all, and the FPGA has the pin tri
stated and it is pulled up as per LPC SERIRQ spec, yet somehow it is
driving the system mad.  So the whole problem seems to be that by
adding udev I made usb load earlier than it used to, and then when
I tried building USB into the kernel instead, it loads even earlier,
and in both cases it complains.  Previously I just loaded things manually
in the order that made sense, but I really want to go to more modern
ways of doing things.  I guess I will have to tell udev to ignore the
usb controller and load that one manually after the FPGA.  At least
things make some sense now.

-- 
Len Sorensen
