Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYHYJOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYHYJOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYHYJNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:13:35 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:2915 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbYHYJNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:13:33 -0400
X-IronPort-AV: E=Sophos;i="4.32,264,1217822400"; 
   d="scan'208";a="58495744"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] usb: musb: fix bug - should call usb_hcd_unlink_urb_from_ep before usb_hcd_giveback_urb
Date: Mon, 25 Aug 2008 17:13:41 +0800
Message-Id: <1219655621-18510-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1219655621-18510-1-git-send-email-cooloney@kernel.org>
References: <1219655621-18510-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was found on Blackfin BF54x and BF52x board since kernel 2.6.24 USB API change
http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=4265

__musb_giveback is called by not only musb_giveback but also musb_urb_dequeue.
musb_urb_dequeue also need call usb_hcd_unlink_urb_from_ep before usb_hcd_giveback_urb.

So move usb_hcd_unlink_urb_from_ep from musb_giveback to __musb_giveback to fix this bug.

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/musb/musb_host.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 8b4be01..ba98ac5 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -291,6 +291,8 @@ __acquires(musb->lock)
 			urb->actual_length, urb->transfer_buffer_length
 			);
 
+	usb_hcd_unlink_urb_from_ep(musb_to_hcd(musb), urb);
+
 	spin_unlock(&musb->lock);
 	usb_hcd_giveback_urb(musb_to_hcd(musb), urb, status);
 	spin_lock(&musb->lock);
@@ -353,8 +355,6 @@ musb_giveback(struct musb_qh *qh, struct urb *urb, int status)
 		break;
 	}
 
-	usb_hcd_unlink_urb_from_ep(musb_to_hcd(musb), urb);
-
 	qh->is_ready = 0;
 	__musb_giveback(musb, urb, status);
 	qh->is_ready = ready;
-- 
1.5.6
