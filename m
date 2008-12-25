Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbYLYOQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbYLYOQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYLYOPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:15:19 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:54009 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752056AbYLYOPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:15:16 -0500
Date: Thu, 25 Dec 2008 17:15:14 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] USB: fsl_qe_udc: Fix stalled TX requests bug
Message-ID: <20081225141514.GF6786@oksana.dev.rtsoft.ru>
References: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While disabling an endpoint the driver nuking any pending requests,
thus completing them with -ESHUTDOWN status. But the driver doesn't
clear the tx_req, which means that a next TX request (after
ep_enable), might get stalled, since the driver won't queue the new
reqests.

This patch fixes a bug I'm observing with ethernet gadget while
playing with ifconfig usb0 up/down (the up/down sequence disables
and enables `in' and `out' endpoints).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/gadget/fsl_qe_udc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index ea42088..69ccbeb 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -1622,6 +1622,7 @@ static int qe_ep_disable(struct usb_ep *_ep)
 	nuke(ep, -ESHUTDOWN);
 	ep->desc = NULL;
 	ep->stopped = 1;
+	ep->tx_req = NULL;
 	qe_ep_reset(udc, ep->epnum);
 	spin_unlock_irqrestore(&udc->lock, flags);
 
-- 
1.5.6.5
