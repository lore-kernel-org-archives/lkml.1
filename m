Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYKQHeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYKQHeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYKQHVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:42 -0500
Received: from kroah.org ([198.145.64.141]:38707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755814AbYKQHVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:39 -0500
Date: Sun, 16 Nov 2008 23:16:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 40/46] USB: EHCI: fix handling of dead controllers
Message-ID: <20081117071658.GO29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ehci-fix-handling-of-dead-controllers.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 67b2e029743a52670d77864723b4d0d40f7733b5 upstream.

This patch (as1165) makes a few small changes in the logic used by
ehci-hcd when it encounters a controller error:

	Instead of printing out the masked status, it prints the
	original status as read directly from the hardware.

	It doesn't check for the STS_HALT status bit before taking
	action.  The mere fact that the STS_FATAL bit is set means
	that something bad has happened and the controller needs to
	be reset.  With the old code this test could never succeed
	because the STS_HALT bit was masked out from the status.

I anticipate that this will prevent the occasional "irq X: nobody cared"
problem people encounter when their EHCI controllers die.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -643,7 +643,7 @@ static int ehci_run (struct usb_hcd *hcd
 static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
-	u32			status, pcd_status = 0, cmd;
+	u32			status, masked_status, pcd_status = 0, cmd;
 	int			bh;
 
 	spin_lock (&ehci->lock);
@@ -656,14 +656,14 @@ static irqreturn_t ehci_irq (struct usb_
 		goto dead;
 	}
 
-	status &= INTR_MASK;
-	if (!status) {			/* irq sharing? */
+	masked_status = status & INTR_MASK;
+	if (!masked_status) {		/* irq sharing? */
 		spin_unlock(&ehci->lock);
 		return IRQ_NONE;
 	}
 
 	/* clear (just) interrupts */
-	ehci_writel(ehci, status, &ehci->regs->status);
+	ehci_writel(ehci, masked_status, &ehci->regs->status);
 	cmd = ehci_readl(ehci, &ehci->regs->command);
 	bh = 0;
 
@@ -731,19 +731,18 @@ static irqreturn_t ehci_irq (struct usb_
 
 	/* PCI errors [4.15.2.4] */
 	if (unlikely ((status & STS_FATAL) != 0)) {
+		ehci_err(ehci, "fatal error\n");
 		dbg_cmd (ehci, "fatal", ehci_readl(ehci,
 						   &ehci->regs->command));
 		dbg_status (ehci, "fatal", status);
-		if (status & STS_HALT) {
-			ehci_err (ehci, "fatal error\n");
+		ehci_halt(ehci);
 dead:
-			ehci_reset (ehci);
-			ehci_writel(ehci, 0, &ehci->regs->configured_flag);
-			/* generic layer kills/unlinks all urbs, then
-			 * uses ehci_stop to clean up the rest
-			 */
-			bh = 1;
-		}
+		ehci_reset(ehci);
+		ehci_writel(ehci, 0, &ehci->regs->configured_flag);
+		/* generic layer kills/unlinks all urbs, then
+		 * uses ehci_stop to clean up the rest
+		 */
+		bh = 1;
 	}
 
 	if (bh)

-- 
