Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab0BBLLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:11:43 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65054 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609Ab0BBLLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:11:42 -0500
Subject: [PATCH] isp1760: Flush the D-cache for the pipe-in transfer buffers
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sebastian Siewior <bigeasy@linutronix.de>
Date: Tue, 02 Feb 2010 11:11:35 +0000
Message-ID: <20100202111135.18636.62688.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-36-g53e3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 11:11:35.0778 (UTC) FILETIME=[7BCDC420:01CAA3F8]
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
---
 drivers/usb/host/isp1760-hcd.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 27b8f7c..51445ad 100644
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

