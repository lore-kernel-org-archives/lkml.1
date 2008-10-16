Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYJPR12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYJPR12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbYJPROx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:53 -0400
Received: from kroah.org ([198.145.64.141]:47013 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756414AbYJPROw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/46] usb: turn dev_warn+WARN_ON combos into dev_WARN
Date: Thu, 16 Oct 2008 10:10:34 -0700
Message-Id: <1224177047-11859-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

dev_WARN is both compacter and gives better debug information
than just a WARN_ON, since people and tools will copy the device
information message together with the WARN_ON in bug reports.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/host/uhci-q.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/host/uhci-q.c b/drivers/usb/host/uhci-q.c
index db64593..1f0c2cf 100644
--- a/drivers/usb/host/uhci-q.c
+++ b/drivers/usb/host/uhci-q.c
@@ -123,14 +123,10 @@ static struct uhci_td *uhci_alloc_td(struct uhci_hcd *uhci)
 
 static void uhci_free_td(struct uhci_hcd *uhci, struct uhci_td *td)
 {
-	if (!list_empty(&td->list)) {
-		dev_warn(uhci_dev(uhci), "td %p still in list!\n", td);
-		WARN_ON(1);
-	}
-	if (!list_empty(&td->fl_list)) {
-		dev_warn(uhci_dev(uhci), "td %p still in fl_list!\n", td);
-		WARN_ON(1);
-	}
+	if (!list_empty(&td->list))
+		dev_WARN(uhci_dev(uhci), "td %p still in list!\n", td);
+	if (!list_empty(&td->fl_list))
+		dev_WARN(uhci_dev(uhci), "td %p still in fl_list!\n", td);
 
 	dma_pool_free(uhci->td_pool, td, td->dma_handle);
 }
@@ -295,10 +291,8 @@ static struct uhci_qh *uhci_alloc_qh(struct uhci_hcd *uhci,
 static void uhci_free_qh(struct uhci_hcd *uhci, struct uhci_qh *qh)
 {
 	WARN_ON(qh->state != QH_STATE_IDLE && qh->udev);
-	if (!list_empty(&qh->queue)) {
-		dev_warn(uhci_dev(uhci), "qh %p list not empty!\n", qh);
-		WARN_ON(1);
-	}
+	if (!list_empty(&qh->queue))
+		dev_WARN(uhci_dev(uhci), "qh %p list not empty!\n", qh);
 
 	list_del(&qh->node);
 	if (qh->udev) {
@@ -746,11 +740,9 @@ static void uhci_free_urb_priv(struct uhci_hcd *uhci,
 {
 	struct uhci_td *td, *tmp;
 
-	if (!list_empty(&urbp->node)) {
-		dev_warn(uhci_dev(uhci), "urb %p still on QH's list!\n",
+	if (!list_empty(&urbp->node))
+		dev_WARN(uhci_dev(uhci), "urb %p still on QH's list!\n",
 				urbp->urb);
-		WARN_ON(1);
-	}
 
 	list_for_each_entry_safe(td, tmp, &urbp->td_list, list) {
 		uhci_remove_td_from_urbp(td);
-- 
1.6.0.2

