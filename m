Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbZBMJuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbZBMJuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZBMJtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:49:49 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34850 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZBMJts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:49:48 -0500
Subject: [PATCH] Bluetooth USB: fix kernel panic during suspend - 2.6.24
From: Colin Ian King <colin.king@canonical.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 09:49:45 +0000
Message-Id: <1234518585.6647.26.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The kernel panics when hci_usb_tx_complete() calls _urb_unlink()
on an _urb which has been previously been removed from a list.
This occurs during suspend while audio is being streamed to
a bluetooth headset.

The panic occurs because hci_usb_suspend() dequeues _urb
and then calls usb_kill_urb() - instead it should put _urb on
the killed list first before killing the urb.

Also added a spin_lock around the list_add operation.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/bluetooth/hci_usb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
index cf734ca..22fd5b5 100644
--- a/drivers/bluetooth/hci_usb.c
+++ b/drivers/bluetooth/hci_usb.c
@@ -1029,8 +1029,10 @@ static int hci_usb_suspend(struct usb_interface
*intf, pm_message_t message)
 		while ((_urb = _urb_dequeue(q))) {
 			/* reset queue since _urb_dequeue sets it to NULL */
 			_urb->queue = q;
-			usb_kill_urb(&_urb->urb);
+			spin_lock_irqsave(&q->lock, flags);
 			list_add(&_urb->list, &killed);
+			spin_unlock_irqrestore(&q->lock, flags);
+			usb_kill_urb(&_urb->urb);
 		}
 
 		spin_lock_irqsave(&q->lock, flags);
-- 

