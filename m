Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbYLXTNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbYLXTNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 14:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYLXTNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 14:13:07 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:50751 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751214AbYLXTNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 14:13:04 -0500
Date: Wed, 24 Dec 2008 22:13:03 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/3] USB: FHCI: Driver should be responsible for
	managing endpoint queues
Message-ID: <20081224191303.GA21815@oksana.dev.rtsoft.ru>
References: <20081223210322.GA2802@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081223210322.GA2802@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow these changes for the FHCI driver:

commit e9df41c5c5899259541dc928872cad4d07b82076
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Wed Aug 8 11:48:02 2007 -0400

USB: make HCDs responsible for managing endpoint queues

This patch (as954) implements a suggestion of David Brownell's.  Now
the host controller drivers are responsible for linking and unlinking
URBs to/from their endpoint queues.  This eliminates the possiblity of
strange situations where usbcore thinks an URB is linked but the HCD
thinks it isn't.  It also means HCDs no longer have to check for URBs
being dequeued before they were fully enqueued.

In addition to the core changes, this requires changing every host
controller driver and the root-hub URB handler.  For the most part the
required changes are fairly small; drivers have to call
usb_hcd_link_urb_to_ep() in their urb_enqueue method,
usb_hcd_check_unlink_urb() in their urb_dequeue method, and
usb_hcd_unlink_urb_from_ep() before giving URBs back.  A few HCDs make
matters more complicated by the way they split up the flow of control.

In addition some method interfaces get changed.  The endpoint argument
for urb_enqueue is now redundant so it is removed.  The unlink status
is required by usb_hcd_check_unlink_urb(), so it has been added to
urb_dequeue.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/usb/host/fhci-hcd.c |   24 ++++++++++++++++++++----
 drivers/usb/host/fhci-q.c   |    3 +++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index e47b8e9..47ac33f 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -385,7 +385,9 @@ static int fhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 {
 	struct fhci_hcd *fhci = hcd_to_fhci(hcd);
 	u32 pipe = urb->pipe;
-	int i, size = 0;
+	int ret;
+	int i;
+	int size = 0;
 	struct urb_priv *urb_priv;
 	unsigned long flags;
 
@@ -434,6 +436,11 @@ static int fhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	}
 
 	spin_lock_irqsave(&fhci->lock, flags);
+
+	ret = usb_hcd_link_urb_to_ep(hcd, urb);
+	if (ret)
+		goto err;
+
 	/* fill the private part of the URB */
 	urb_priv->num_of_tds = size;
 
@@ -443,9 +450,13 @@ static int fhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	urb->hcpriv = urb_priv;
 
 	queue_urb(fhci, urb);
-
+err:
+	if (ret) {
+		kfree(urb_priv->tds);
+		kfree(urb_priv);
+	}
 	spin_unlock_irqrestore(&fhci->lock, flags);
-	return 0;
+	return ret;
 }
 
 /* dequeue FHCI URB */
@@ -453,6 +464,7 @@ static int fhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 {
 	struct fhci_hcd *fhci = hcd_to_fhci(hcd);
 	struct fhci_usb *usb = fhci->usb_lld;
+	int ret = -EINVAL;
 	unsigned long flags;
 
 	if (!urb || !urb->dev || !urb->dev->bus)
@@ -460,6 +472,10 @@ static int fhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 
 	spin_lock_irqsave(&fhci->lock, flags);
 
+	ret = usb_hcd_check_unlink_urb(hcd, urb, status);
+	if (ret)
+		goto out2;
+
 	if (usb->port_status != FHCI_PORT_DISABLED) {
 		struct urb_priv *urb_priv;
 
@@ -483,7 +499,7 @@ static int fhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 out2:
 	spin_unlock_irqrestore(&fhci->lock, flags);
 out:
-	return 0;
+	return ret;
 }
 
 static void fhci_endpoint_disable(struct usb_hcd *hcd,
diff --git a/drivers/usb/host/fhci-q.c b/drivers/usb/host/fhci-q.c
index 721d07d..1173318 100644
--- a/drivers/usb/host/fhci-q.c
+++ b/drivers/usb/host/fhci-q.c
@@ -200,6 +200,9 @@ void urb_complete_free(struct fhci_hcd *fhci, struct urb *urb)
 		else
 			urb->status = 0;
 	}
+
+	usb_hcd_unlink_urb_from_ep(fhci_to_hcd(fhci), urb);
+
 	spin_unlock(&fhci->lock);
 
 	usb_hcd_giveback_urb(fhci_to_hcd(fhci), urb, urb->status);
-- 
1.5.6.5

