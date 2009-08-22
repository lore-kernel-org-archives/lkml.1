Return-Path: <linux-kernel-owner+w=401wt.eu-S933134AbZHVSYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbZHVSYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 14:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbZHVSYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 14:24:50 -0400
Received: from server1.wserver.cz ([82.113.45.157]:38746 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092AbZHVSYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 14:24:49 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] USB: make usb_buffer_map_sg consistent with doc
Date: Sat, 22 Aug 2009 20:24:49 +0200
Message-Id: <1250965489-27976-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_buffer_map_sg should return negative on error according to
its documentation. But dma_map_sg returns 0 on error. Take this
into account and return -ENOMEM in such situation.

While at it, return -EINVAL instead of -1 when wrong input is
passed in.

If this wasn't done, usb_sg_* operations used after usb_sg_init
which returned 0 may cause oopses/deadlocks since we don't init
structures/entries, esp. completion and status entry.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index a26f738..ba480c2 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -914,11 +914,11 @@ int usb_buffer_map_sg(const struct usb_device *dev, int is_in,
 			|| !(bus = dev->bus)
 			|| !(controller = bus->controller)
 			|| !controller->dma_mask)
-		return -1;
+		return -EINVAL;
 
 	/* FIXME generic api broken like pci, can't report errors */
 	return dma_map_sg(controller, sg, nents,
-			is_in ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+			is_in ? DMA_FROM_DEVICE : DMA_TO_DEVICE) ? : -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(usb_buffer_map_sg);
 
-- 
1.6.3.3

