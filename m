Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0BBJMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 04:12:05 -0500
Received: from www.tglx.de ([62.245.132.106]:59955 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab0BBJMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 04:12:00 -0500
Date: Tue, 2 Feb 2010 10:11:39 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100202091139.GA3591@www.tglx.de>
References: <20100129185434.GH19501@one-eyed-alien.net> <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas | 2010-02-01 17:29:14 [+0000]:

>> So, let's put this in the HCD drivers and be done with it.
That is the correct place. MMC -hcd drivers for instance are doing this
way.

>The patch below is what fixes the I-D cache incoherency issues on ARM. I
>don't particularly like the solution but it seems to be the only one
>available.
The PIO-MMC drivers walk through a scatter list via sg_miter_start() and
friends. Those helpers take care of this automaticly.

>IMHO, Linux should have functions similar to the DMA API but for PIO
>drivers (e.g. pio_map_single/pio_unmap_single) that non-coherent
>architectures can define, otherwise being no-ops. Any thoughts?
What is wrong with flush_dcache_page() ? And I think linux-arch is the
appropriate place.

>isp1760: Flush the D-cache for the pipe-in transfer buffers
>
>From: Catalin Marinas <catalin.marinas@arm.com>
>
>When the HDC driver writes the data to the transfer buffers it pollutes
>the D-cache (unlike DMA drivers where the device writes the data). If
>the corresponding pages get mapped into user space, there are no
>additional cache flushing operations performed and this causes random
>user space faults on architectures with separate I and D caches
>(Harvard) or those with aliasing D-cache.
>
>Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
>Cc: Greg KH <greg@kroah.com>
>Cc: Sebastian Siewior <bigeasy@linutronix.de>
>---
> drivers/usb/host/isp1760-hcd.c |   10 ++++++++++
> 1 files changed, 10 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
>index 27b8f7c..4d3eeee 100644
>--- a/drivers/usb/host/isp1760-hcd.c
>+++ b/drivers/usb/host/isp1760-hcd.c
>@@ -18,6 +18,8 @@
> #include <linux/uaccess.h>
> #include <linux/io.h>
> #include <asm/unaligned.h>
>+#include <asm/cacheflush.h>
>+#include <asm/memory.h>

I'm fine with the patch generally but I don't like the asm headers.
cacheflush.h is available on most architectures as far as I can see it but
memory.h is only available on arm. So you break the build on !arm and
therefore I NAK this.

> #include "../core/hcd.h"
> #include "isp1760-hcd.h"
>@@ -904,6 +906,14 @@ __acquires(priv->lock)
> 			status = 0;
> 	}
> 
>+	if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) == PIPE_BULK) {
>+		void *ptr;
>+		for (ptr = urb->transfer_buffer;
>+		     ptr < urb->transfer_buffer + urb->transfer_buffer_length;
>+		     ptr += PAGE_SIZE)
>+			flush_dcache_page(virt_to_page(ptr));
>+	}
>+
> 	/* complete() can reenter this HCD */
> 	usb_hcd_unlink_urb_from_ep(priv_to_hcd(priv), urb);
> 	spin_unlock(&priv->lock);
>

Sebastian
