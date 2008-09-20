Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYITSLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYITSLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 14:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYITSLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 14:11:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:35112 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbYITSLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 14:11:12 -0400
Date: Sat, 20 Sep 2008 11:11:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debug: Introduce a dev_WARN() function
Message-ID: <20080920111113.18954688@infradead.org>
In-Reply-To: <20080920042630.GA21501@kroah.com>
References: <20080919210733.4e9c58e8@infradead.org>
	<20080920042630.GA21501@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 21:26:30 -0700
Greg KH <greg@kroah.com> wrote:

> On Fri, Sep 19, 2008 at 09:07:33PM -0700, Arjan van de Ven wrote:
> > 
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Fri, 19 Sep 2008 21:03:06 -0700
> > Subject: [PATCH] debug: Introduce a dev_WARN() function
> > 
> > in the line of dev_printk(), this patch introduces a dev_WARN()
> > macro, that takes a struct device and then a printk format/args set
> > of arguments. Unlike dev_printk(), the effect is that of WARN() in
> > that a full warning message (including filename/line, module list,
> > versions and a backtrace) is printed in addition to the device name
> > and the arguments.
> 
> I like the idea, but we already have dev_warn(), so dev_WARN() might
> be a bit confusing for people.
> 
> Perhaps just documenting it with a docbook tag would suffice?
> 

I added a set of comments, and also ended up doing the below USB change

>From 8a2fde5066bed00906df2fff1121d361e9e552f7 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 20 Sep 2008 10:35:51 -0700
Subject: [PATCH] usb: turn dev_warn+WARN_ON combos into dev_WARN

dev_WARN is both compacter and gives better debug information
than just a WARN_ON, since people and tools will copy the device
information message together with the WARN_ON in bug reports.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
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
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
