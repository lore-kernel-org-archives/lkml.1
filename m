Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbYLYOQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbYLYOQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYLYOPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:15:17 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:54002 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751969AbYLYOPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:15:13 -0500
Date: Thu, 25 Dec 2008 17:15:11 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] USB: fsl_qe_udc: Fix muram corruption by disabled
	endpoints
Message-ID: <20081225141511.GE6786@oksana.dev.rtsoft.ru>
References: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before freeing an endpoint's muram memory, we should stop all activity
of the endpoint, otherwise the QE UDC controller might do nasty things
with the muram memory that isn't belong to that endpoint anymore.

The qe_ep_reset() effectively flushes the hardware fifos, finishes all
late transaction and thus prevents the corruption.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/gadget/fsl_qe_udc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 4726582..ea42088 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -1622,6 +1622,7 @@ static int qe_ep_disable(struct usb_ep *_ep)
 	nuke(ep, -ESHUTDOWN);
 	ep->desc = NULL;
 	ep->stopped = 1;
+	qe_ep_reset(udc, ep->epnum);
 	spin_unlock_irqrestore(&udc->lock, flags);
 
 	cpm_muram_free(cpm_muram_offset(ep->rxbase));
-- 
1.5.6.5

