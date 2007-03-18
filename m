Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXCRPjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXCRPjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 11:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbXCRPjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 11:39:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1898 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751399AbXCRPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 11:39:17 -0400
Date: Sun, 18 Mar 2007 11:39:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <45FD4E59.3050007@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703181134020.19508-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007, Jiri Slaby wrote:

> Alan Stern napsal(a):
> > In drivers/usb/host/uhci-q.c, near the start is a function named
> > uhci_fsbr_on().  Put a "return" statement right at its beginning so that
> > the function doesn't do anything.  Does that make any difference?
> 
> Yes, it works.

Okay.  Take out that extra "return" statement and revert the WARN_ON, and
try this patch.  I don't like it because it adds extra PCI bus overhead to
the driver, but if some systems need it then there's no choice.

Warning: I just wrote this and haven't tried to test it.  Consider 
yourself a guinea pig.  :-)

Alan Stern



Index: usb-2.6/drivers/usb/host/uhci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/uhci-q.c
+++ usb-2.6/drivers/usb/host/uhci-q.c
@@ -54,22 +54,17 @@ static void uhci_fsbr_on(struct uhci_hcd
 	/* Find the first FSBR QH.  Linear search through the list is
 	 * acceptable because normally FSBR gets turned on as soon as
 	 * one QH needs it. */
-	fsbr_qh = NULL;
+	fsbr_qh = uhci->skel_term_qh;
 	list_for_each_entry_reverse(tqh, &uhci->skel_async_qh->node, node) {
 		if (tqh->skel < SKEL_FSBR)
 			break;
 		fsbr_qh = tqh;
 	}
 
-	/* No FSBR QH means we must insert the terminating skeleton QH */
-	if (!fsbr_qh) {
-		uhci->skel_term_qh->link = LINK_TO_QH(uhci->skel_term_qh);
-		wmb();
-		lqh->link = uhci->skel_term_qh->link;
-
-	/* Otherwise loop the last QH to the first FSBR QH */
-	} else
-		lqh->link = LINK_TO_QH(fsbr_qh);
+	/* The terminating skeleton QH points back to the first FSBR QH */
+	uhci->skel_term_qh->link = LINK_TO_QH(fsbr_qh);
+	wmb();
+	lqh->link = LINK_TO_QH(uhci->skel_term_qh);
 }
 
 static void uhci_fsbr_off(struct uhci_hcd *uhci)
@@ -139,10 +134,14 @@ static struct uhci_td *uhci_alloc_td(str
 
 static void uhci_free_td(struct uhci_hcd *uhci, struct uhci_td *td)
 {
-	if (!list_empty(&td->list))
+	if (!list_empty(&td->list)) {
 		dev_warn(uhci_dev(uhci), "td %p still in list!\n", td);
-	if (!list_empty(&td->fl_list))
+		WARN_ON(1);
+	}
+	if (!list_empty(&td->fl_list)) {
 		dev_warn(uhci_dev(uhci), "td %p still in fl_list!\n", td);
+		WARN_ON(1);
+	}
 
 	dma_pool_free(uhci->td_pool, td, td->dma_handle);
 }
@@ -307,8 +306,10 @@ static struct uhci_qh *uhci_alloc_qh(str
 static void uhci_free_qh(struct uhci_hcd *uhci, struct uhci_qh *qh)
 {
 	WARN_ON(qh->state != QH_STATE_IDLE && qh->udev);
-	if (!list_empty(&qh->queue))
+	if (!list_empty(&qh->queue)) {
 		dev_warn(uhci_dev(uhci), "qh %p list not empty!\n", qh);
+		WARN_ON(1);
+	}
 
 	list_del(&qh->node);
 	if (qh->udev) {
@@ -464,9 +465,8 @@ static void link_interrupt(struct uhci_h
  */
 static void link_async(struct uhci_hcd *uhci, struct uhci_qh *qh)
 {
-	struct uhci_qh *pqh, *lqh;
+	struct uhci_qh *pqh;
 	__le32 link_to_new_qh;
-	__le32 *extra_link = &link_to_new_qh;
 
 	/* Find the predecessor QH for our new one and insert it in the list.
 	 * The list of QHs is expected to be short, so linear search won't
@@ -476,31 +476,20 @@ static void link_async(struct uhci_hcd *
 			break;
 	}
 	list_add(&qh->node, &pqh->node);
-	qh->link = pqh->link;
 
+	/* Link it into the schedule */
+	qh->link = pqh->link;
+	wmb();
 	link_to_new_qh = LINK_TO_QH(qh);
+	pqh->link = link_to_new_qh;
 
 	/* If this is now the first FSBR QH, take special action */
 	if (uhci->fsbr_is_on && pqh->skel < SKEL_FSBR &&
 			qh->skel >= SKEL_FSBR) {
-		lqh = list_entry(uhci->skel_async_qh->node.prev,
-				struct uhci_qh, node);
 
-		/* If the new QH is also the last one, we must unlink
-		 * the terminating skeleton QH and make the new QH point
-		 * back to itself. */
-		if (qh == lqh) {
-			qh->link = link_to_new_qh;
-			extra_link = &uhci->skel_term_qh->link;
-
-		/* Otherwise the last QH must point to the new QH */
-		} else
-			extra_link = &lqh->link;
+		/* The terminating skeleton QH must point to the new QH */
+		uhci->skel_term_qh->link = link_to_new_qh;
 	}
-
-	/* Link it into the schedule */
-	wmb();
-	*extra_link = pqh->link = link_to_new_qh;
 }
 
 /*
@@ -561,31 +550,21 @@ static void unlink_interrupt(struct uhci
  */
 static void unlink_async(struct uhci_hcd *uhci, struct uhci_qh *qh)
 {
-	struct uhci_qh *pqh, *lqh;
+	struct uhci_qh *pqh;
 	__le32 link_to_next_qh = qh->link;
 
 	pqh = list_entry(qh->node.prev, struct uhci_qh, node);
+	pqh->link = link_to_next_qh;
 
-	/* If this is the first FSBQ QH, take special action */
+	/* If this is the first FSBR QH, take special action */
 	if (uhci->fsbr_is_on && pqh->skel < SKEL_FSBR &&
 			qh->skel >= SKEL_FSBR) {
-		lqh = list_entry(uhci->skel_async_qh->node.prev,
-				struct uhci_qh, node);
 
-		/* If this QH is also the last one, we must link in
-		 * the terminating skeleton QH. */
-		if (qh == lqh) {
-			link_to_next_qh = LINK_TO_QH(uhci->skel_term_qh);
-			uhci->skel_term_qh->link = link_to_next_qh;
-			wmb();
-			qh->link = link_to_next_qh;
-
-		/* Otherwise the last QH must point to the new first FSBR QH */
-		} else
-			lqh->link = link_to_next_qh;
+		/* The terminating skeleton QH must point to the new
+		 * first FSBR QH */
+		uhci->skel_term_qh->link = link_to_next_qh;
 	}
 
-	pqh->link = link_to_next_qh;
 	mb();
 }
 
@@ -786,9 +765,11 @@ static void uhci_free_urb_priv(struct uh
 {
 	struct uhci_td *td, *tmp;
 
-	if (!list_empty(&urbp->node))
+	if (!list_empty(&urbp->node)) {
 		dev_warn(uhci_dev(uhci), "urb %p still on QH's list!\n",
 				urbp->urb);
+		WARN_ON(1);
+	}
 
 	list_for_each_entry_safe(td, tmp, &urbp->td_list, list) {
 		uhci_remove_td_from_urbp(td);

