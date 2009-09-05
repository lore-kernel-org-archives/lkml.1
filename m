Return-Path: <linux-kernel-owner+w=401wt.eu-S934678AbZIEAY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934678AbZIEAY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964790AbZIEAY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:24:26 -0400
Received: from kroah.org ([198.145.64.141]:42297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964800AbZIEAV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:56 2009
Message-Id: <20090905001456.619370111@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>
Subject: [patch 60/71] USB: EHCI: fix two new bugs related to Clear-TT-Buffer
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=usb-ehci-fix-two-new-bugs-related-to-clear-tt-buffer.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 7a0f0d951273eee889c2441846842348ebc00a2a upstream.

This patch (as1273) fixes two(!) bugs introduced by the new
Clear-TT-Buffer implementation in ehci-hcd.

	It is now possible for an idle QH to have some URBs on its
	queue -- this will happen if a Clear-TT-Buffer is pending for
	the QH's endpoint.  Consequently we should not issue a warning
	when someone tries to unlink an URB from an idle QH; instead
	we should process the request immediately.

	The refcounts for QHs could get messed up, because
	submit_async() would increment the refcount when calling
	qh_link_async() and qh_link_async() would then refuse to link
	the QH into the schedule if a Clear-TT-Buffer was pending.
	Instead we should increment the refcount only when the QH
	actually is added to the schedule.  The current code tries to
	be clever by leaving the refcount alone if an unlink is
	immediately followed by a relink; the patch changes this to an
	unconditional decrement and increment (although they occur in
	the opposite order).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: David Brownell <david-b@pacbell.net>
Tested-by: Manuel Lauss <manuel.lauss@gmail.com>
Tested-by: Matthijs Kooijman <matthijs@stdin.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c |    3 ++-
 drivers/usb/host/ehci-q.c   |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -903,7 +903,8 @@ static int ehci_urb_dequeue(struct usb_h
 			/* already started */
 			break;
 		case QH_STATE_IDLE:
-			WARN_ON(1);
+			/* QH might be waiting for a Clear-TT-Buffer */
+			qh_completions(ehci, qh);
 			break;
 		}
 		break;
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -938,6 +938,7 @@ static void qh_link_async (struct ehci_h
 	head->qh_next.qh = qh;
 	head->hw_next = dma;
 
+	qh_get(qh);
 	qh->xacterrs = QH_XACTERR_MAX;
 	qh->qh_state = QH_STATE_LINKED;
 	/* qtd completions reported later by interrupt */
@@ -1078,7 +1079,7 @@ submit_async (
 	 * the HC and TT handle it when the TT has a buffer ready.
 	 */
 	if (likely (qh->qh_state == QH_STATE_IDLE))
-		qh_link_async (ehci, qh_get (qh));
+		qh_link_async(ehci, qh);
  done:
 	spin_unlock_irqrestore (&ehci->lock, flags);
 	if (unlikely (qh == NULL))
@@ -1113,8 +1114,6 @@ static void end_unlink_async (struct ehc
 			&& HC_IS_RUNNING (ehci_to_hcd(ehci)->state))
 		qh_link_async (ehci, qh);
 	else {
-		qh_put (qh);		// refcount from async list
-
 		/* it's not free to turn the async schedule on/off; leave it
 		 * active but idle for a while once it empties.
 		 */
@@ -1122,6 +1121,7 @@ static void end_unlink_async (struct ehc
 				&& ehci->async->qh_next.qh == NULL)
 			timer_action (ehci, TIMER_ASYNC_OFF);
 	}
+	qh_put(qh);			/* refcount from async list */
 
 	if (next) {
 		ehci->reclaim = NULL;


