Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYE2Mwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYE2Mwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYE2Mw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:52:26 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:44535 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYE2MwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:52:25 -0400
From: Li Yang <leoli@freescale.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Li Yang <leoli@freescale.com>,
       "Eugene T. Bordenkircher" <Eugene_Bordenkircher@selinc.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH] fsl_usb2_udc: fix recursive lock
Date: Thu, 29 May 2008 21:04:45 +0800
Message-Id: <1212066285-6013-1-git-send-email-leoli@freescale.com>
X-Mailer: git-send-email 1.5.5.1.248.g4b17
X-OriginalArrivalTime: 29 May 2008 12:52:18.0566 (UTC) FILETIME=[D3F38A60:01C8C18A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UDC needs to release lock before calling out to gadget driver, since
it may need to reenter.  The change fixes kernel BUG observed on rt
kernel.

> kernel BUG at kernel/rtmutex.c:683!
> stopped custom tracer.
> Oops: Exception in kernel mode, sig: 5 [#1]
> PREEMPT MPC834x ITX
> NIP: c021629c LR: c0216270 CTR: 00000000
> REGS: df761d70 TRAP: 0700   Not tainted  (2.6.23.9-rt13)
> MSR: 00021032 <ME,IR,DR>  CR: 28000022  XER: 00000000
> TASK = df632080[241] 'IRQ-38' THREAD: df760000
> GPR00: 00000001 df761e20 df632080 00000000 11111111 00000000 df761e6c
> 00000000
> GPR08: df761e48 00000000 df761e50 00000000 80000000 ede5cdde 1fffd000
> 00800000
> GPR16: ffffffff 00000000 007fff00 00000040 00000000 007ffeb0 00000000
> 1fff8b08
> GPR24: 00000000 00000026 00000000 df79a320 c026b2e8 c02240bc 00009032
> df79a320
> NIP [c021629c] rt_spin_lock_slowlock+0x9c/0x200
> LR [c0216270] rt_spin_lock_slowlock+0x70/0x200
> Call Trace:
> [df761e20] [c0216270] rt_spin_lock_slowlock+0x70/0x200 (unreliable)
> [df761e90] [c0182828] fsl_ep_disable+0xcc/0x154
> [df761eb0] [c0184d30] eth_reset_config+0x88/0x1d0
> [df761ed0] [c0184ec0] eth_disconnect+0x48/0x64
> [df761ef0] [c01831a4] reset_queues+0x60/0x78
> [df761f00] [c0183b74] fsl_udc_irq+0x9b8/0xa58
> [df761f50] [c003ef30] handle_IRQ_event+0x64/0x100
> [df761f80] [c003f758] thread_simple_irq+0x6c/0xc8
> [df761fa0] [c003f888] do_irqd+0xd4/0x2e4
> [df761fd0] [c0032284] kthread+0x50/0x8c
> [df761ff0] [c000f9b4] kernel_thread+0x44/0x60

Signed-off-by: Li Yang <leoli@freescale.com>
Cc: Eugene T. Bordenkircher <Eugene_Bordenkircher@selinc.com>
Cc: David Brownell <david-b@pacbell.net>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 651b827..1868754 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -1627,7 +1627,9 @@ static int reset_queues(struct fsl_udc *udc)
 		udc_reset_ep_queue(udc, pipe);
 
 	/* report disconnect; the driver is already quiesced */
+	spin_unlock(&udc->lock);
 	udc->driver->disconnect(&udc->gadget);
+	spin_lock(&udc->lock);
 
 	return 0;
 }
-- 
1.5.5.1.248.g4b17

