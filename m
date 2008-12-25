Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYLYOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYLYOQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYLYOPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:15:14 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:53995 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751925AbYLYOPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:15:11 -0500
Date: Thu, 25 Dec 2008 17:15:09 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] USB: fsl_qe_udc: Fix disconnects reporting during bus
	reset
Message-ID: <20081225141509.GD6786@oksana.dev.rtsoft.ru>
References: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freescale QE UDC controllers can't report the "port change" states,
so the only way to handle disconnects is to process bus reset
interrupts. The bus reset can take some time, that is, few irqs.
Gadgets may print the disconnection events, and this causes few
repetitive messages in the kernel log.

This patch fixes the issue by using the usb_state machine, if the
usb controller has been already reset, just quit the reset irq
early.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/gadget/fsl_qe_udc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index b460c6d..4726582 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2161,6 +2161,9 @@ static int reset_irq(struct qe_udc *udc)
 {
 	unsigned char i;
 
+	if (udc->usb_state == USB_STATE_DEFAULT)
+		return 0;
+
 	qe_usb_disable();
 	out_8(&udc->usb_regs->usb_usadr, 0);
 
-- 
1.5.6.5

