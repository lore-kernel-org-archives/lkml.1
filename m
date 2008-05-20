Return-Path: <linux-kernel-owner+w=401wt.eu-S933712AbYETVHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbYETVHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760649AbYETVHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:07:32 -0400
Received: from www.tglx.de ([62.245.132.106]:48034 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760219AbYETVHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:07:31 -0400
Date: Tue, 20 May 2008 23:07:13 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, hjk@linutronix.de,
       gregkh@suse.de, linux-sh@vger.kernel.org, Uwe.Kleine-Koenig@digi.com
Subject: Re: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Message-ID: <20080520210713.GE3220@local>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 07:51:32PM +0900, Magnus Damm wrote:

Hi Magnus,

> These patches implement a reusable UIO platform driver. 

Uwe Kleine-Koenig already submitted such a framework:

http://lkml.org/lkml/2008/5/20/94

It's his third version, and it looks good. I presume you didn't know
about his work. The main difference is that he leaves interrupt handling
to platform code. That might look strange (it did to me first), but it
has the advantage that you can put hardware dependent stuff in your
board support (which depends on hardware anyway).

Could you have a look at his patch and tell me if that does what you
need?

> This driver
> can be used to export hardware to user space, as long as the device
> is a) memory mapped and b) equipped with an unique IRQ.
> 
> The uio_platform driver gets all information through platform data,
> including address window information and IRQ number. The driver also
> supports assigning a contiguous piece of memory to each instance.
> This may be useful when the exported hardware blocks can bus master
> but requires physically contiguous memory.
> 
> There are not many surprises in the code if you are familiar with UIO,
> except for the interrupt handling. All UIO kernel drivers that I've
> seen so far have hardware specific interrupt acknowledge code in the
> interrupt handler. The uio_platform driver is different.
> 
> The interrupt handling code in uio_platform assumes the device is the
> only user of the assigned interrupt. 

Uwe's approach doesn't have this limitation.

> This may be rare in the PC world
> but for SuperH almost all interrupt sources are unique. Having an
> unique interrupt for the device allows the code to use disable_irq()
> and enable_irq() in kernel space and leave actual interrupt acknowledge
> to user space. That way we have no hardware specific code in the kernel.
> 
> Interrupts are of course serviced in kernel space by the uio_platform
> driver, but the uio_platform interrupt handler will simply disable the
> IRQ until next read() or poll() syscall. The uio_platform kernel driver
> assumes that the user space driver has taken care of acknowledging
> the interrupt before doing read() and waiting for events again. If no
> acknowledge has happened then an interrupt will occur again (since it's
> still pending) and the kernel interrupt handler will disable the IRQ
> again and unblock the user space process.
> 
> The last patch contains SuperH specific code that exports various
> multimedia acceleration blocks to userspace. The following processors
> and hardware blocks are exported for now:
> 
> sh7343: VPU
> sh7722: VPU, VEU
> sh7723: VPU, VEU, VEU
> 
> If anyone is interested then I have a proof of concept vidix driver
> for mplayer that is interfacing using UIO to the VEU on a sh7722 to
> provide accelerated color space conversion and stretching.

This sounds quite interesting. Unfortunately, I'm not familiar with the
SuperH architecture. Could you also do this with Uwe's approach?

I'm about to sign-off Uwe's patch, and we'll possibly have that in
mainline soon. I don't mind having a second "generic platform" driver,
but you'll need to have good technical arguments.

Thanks,
Hans

