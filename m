Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbYLYOQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbYLYOQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYLYOPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:15:11 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:53987 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751919AbYLYOPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:15:08 -0500
Date: Thu, 25 Dec 2008 17:15:07 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] USB: fsl_qe_udc: Fix QE USB controller initialization
Message-ID: <20081225141507.GC6786@oksana.dev.rtsoft.ru>
References: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qe_udc_reg_init() leaves the USB controller enabled before muram memory
initialized. Sometimes the uninitialized muram memory confuses the
controller, and it start sending the busy interrupts.

Fix this by disabling the controller, it will be enabled later by
the gadget driver, at bind time.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/usb/gadget/fsl_qe_udc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 2677c9e..b460c6d 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2452,8 +2452,12 @@ static int __devinit qe_udc_reg_init(struct qe_udc *udc)
 	struct usb_ctlr __iomem *qe_usbregs;
 	qe_usbregs = udc->usb_regs;
 
-	/* Init the usb register */
+	/* Spec says that we must enable the USB controller to change mode. */
 	out_8(&qe_usbregs->usb_usmod, 0x01);
+	/* Mode changed, now disable it, since muram isn't initialized yet. */
+	out_8(&qe_usbregs->usb_usmod, 0x00);
+
+	/* Initialize the rest. */
 	out_be16(&qe_usbregs->usb_usbmr, 0);
 	out_8(&qe_usbregs->usb_uscom, 0);
 	out_be16(&qe_usbregs->usb_usber, USBER_ALL_CLEAR);
-- 
1.5.6.5

