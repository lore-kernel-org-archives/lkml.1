Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbZDPFzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbZDPFzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZDPFyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:54:52 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:7117
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777AbZDPFyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:54:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBAJxk5kl8qNY8/2dsb2JhbAAI0BuDfQY
X-IronPort-AV: E=Sophos;i="4.40,197,1238947200"; 
   d="scan'208";a="419598016"
Subject: [PATCH 2/9] pxa25x_udc: Use disable_irq_nosync() from within irq
	handlers.
From: Ben Nizette <bn@niasdigital.com>
To: Eric Miao <eric.miao@marvell.com>, linux@arm.linux.org.uk
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:54:23 +1000
Message-Id: <1239861263.29831.116.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


disable_irq() should wait for all running handlers to complete
before returning.  As such, if it's used to disable an interrupt
from that interrupt's handler it will deadlock.  This replaces
the dangerous instances with the _nosync() variant which doesn't
have this problem.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
---
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index 0ce4e28..6ab6f26 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -1382,12 +1382,12 @@ lubbock_vbus_irq(int irq, void *_dev)
 	switch (irq) {
 	case LUBBOCK_USB_IRQ:
 		vbus = 1;
-		disable_irq(LUBBOCK_USB_IRQ);
+		disable_irq_nosync(LUBBOCK_USB_IRQ);
 		enable_irq(LUBBOCK_USB_DISC_IRQ);
 		break;
 	case LUBBOCK_USB_DISC_IRQ:
 		vbus = 0;
-		disable_irq(LUBBOCK_USB_DISC_IRQ);
+		disable_irq_nosync(LUBBOCK_USB_DISC_IRQ);
 		enable_irq(LUBBOCK_USB_IRQ);
 		break;
 	default:
-- 
1.6.0.2



