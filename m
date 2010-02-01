Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0BAR3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:29:33 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59343 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764Ab0BAR3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:29:32 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
In-Reply-To: <20100129185434.GH19501@one-eyed-alien.net>
References: <20100129185434.GH19501@one-eyed-alien.net>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 01 Feb 2010 17:29:14 +0000
Message-Id: <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2010 17:29:15.0431 (UTC) FILETIME=[1398AB70:01CAA364]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 18:54 +0000, Matthew Dharm wrote:
> HOWEVER, I firmly believe that the cache-management functions belong with
> the driver that actually talks to the low-level hardware, as that's the
> only place where you can be 100% certain of what cache operations are
> needed.  After all, I think someone is working on a USB-over-IP transport,
> and trying to manage cache at the usb-storage level in that scenario is
> just silly.
> 
> So, let's put this in the HCD drivers and be done with it.

The patch below is what fixes the I-D cache incoherency issues on ARM. I
don't particularly like the solution but it seems to be the only one
available.

IMHO, Linux should have functions similar to the DMA API but for PIO
drivers (e.g. pio_map_single/pio_unmap_single) that non-coherent
architectures can define, otherwise being no-ops. Any thoughts?

Thanks.



isp1760: Flush the D-cache for the pipe-in transfer buffers

From: Catalin Marinas <catalin.marinas@arm.com>

When the HDC driver writes the data to the transfer buffers it pollutes
the D-cache (unlike DMA drivers where the device writes the data). If
the corresponding pages get mapped into user space, there are no
additional cache flushing operations performed and this causes random
user space faults on architectures with separate I and D caches
(Harvard) or those with aliasing D-cache.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Greg KH <greg@kroah.com>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
---
 drivers/usb/host/isp1760-hcd.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 27b8f7c..4d3eeee 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -18,6 +18,8 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <asm/unaligned.h>
+#include <asm/cacheflush.h>
+#include <asm/memory.h>
 
 #include "../core/hcd.h"
 #include "isp1760-hcd.h"
@@ -904,6 +906,14 @@ __acquires(priv->lock)
 			status = 0;
 	}
 
+	if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) == PIPE_BULK) {
+		void *ptr;
+		for (ptr = urb->transfer_buffer;
+		     ptr < urb->transfer_buffer + urb->transfer_buffer_length;
+		     ptr += PAGE_SIZE)
+			flush_dcache_page(virt_to_page(ptr));
+	}
+
 	/* complete() can reenter this HCD */
 	usb_hcd_unlink_urb_from_ep(priv_to_hcd(priv), urb);
 	spin_unlock(&priv->lock);

-- 
Catalin

