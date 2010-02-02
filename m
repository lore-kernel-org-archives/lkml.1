Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0BBPbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:31:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55224 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009Ab0BBPbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:31:11 -0500
Subject: [PATCH v3] isp1760: Flush the D-cache for the pipe-in transfer buffers
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>,
       Sebastian Siewior <bigeasy@linutronix.de>
Date: Tue, 02 Feb 2010 15:31:02 +0000
Message-ID: <20100202152910.22252.3813.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-36-g53e3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 15:31:02.0657 (UTC) FILETIME=[BA62FF10:01CAA41C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Oliver Neukum <oliver@neukum.org>
---

The changes in the third version of this patch include flushing the
transfer buffer for all in-pipes except the PIPE_CONTROL ones.


 drivers/usb/host/isp1760-hcd.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 27b8f7c..9f01293 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -17,7 +17,9 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/mm.h>
 #include <asm/unaligned.h>
+#include <asm/cacheflush.h>
 
 #include "../core/hcd.h"
 #include "isp1760-hcd.h"
@@ -904,6 +906,14 @@ __acquires(priv->lock)
 			status = 0;
 	}
 
+	if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) != PIPE_CONTROL) {
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

