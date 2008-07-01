Return-Path: <linux-kernel-owner+w=401wt.eu-S1760833AbYGAQVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbYGAQVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYGAQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:21:22 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33771 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052AbYGAQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:21:21 -0400
Message-ID: <486A590A.4090806@nokia.com>
Date: Tue, 01 Jul 2008 19:19:22 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       ext Greg Kroah-Hartman <gregkh@suse.de>
CC: ext David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ext Leonardo Chiquitto <leonardo.lists@gmail.com>
Subject: [PATCH] USB: fix interrupt disabling for HCDs with shared interrupt
 handlers
References: <Pine.LNX.4.44L0.0807011005430.2780-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807011005430.2780-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2008 16:20:14.0195 (UTC) FILETIME=[57A33430:01C8DB96]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan & Greg,

third time is the charm (I hope)...

ext Alan Stern wrote:
> 
> flags must be unsigned long.  You don't have to initialize it to 0.

*Sigh* there are certain things you just shouldn't do when burning the midnight oil. I changed the patch according to your suggestions and also copied the comment for usb_hcd_irq() from David's changes.

I hope this can still make it into 2.6.26, because it seems to solve a lot of problems for the users out there...

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com

================================ CUT HERE =============================================
commit 89fa7659cb90f621513d7193b06cf19386451c33
Author: Stefan Becker <stefan.becker@nokia.com>
Date:   Mon Jun 30 21:18:29 2008 +0300

    USB: fix interrupt disabling for HCDs with shared interrupt handlers
    
    As has been discussed several times on LKML, IRQF_SHARED | IRQF_DISABLED
    doesn't work reliably, i.e. a shared interrupt handler CAN'T be certain to
    be called with interrupts disabled. Most USB HCD handlers use IRQF_DISABLED
    and therefore havoc can break out if they share their interrupt with a
    handler that doesn't use it.
    
    On my test machine the yenta_socket interrupt handler (no IRQF_DISABLED)
    was registered before ehci_hcd and one uhci_hcd instance. Therefore all
    usb_hcd_irq() invocations for ehci_hcd and for one uhci_hcd instance
    happened with interrupts enabled. That led to random lockups as USB core
    HCD functions that acquire the same spinlock could be called twice
    from interrupt handlers.
    
    This patch updates usb_hcd_irq() to always disable/restore interrupts.
    usb_add_hcd() will silently remove any IRQF_DISABLED requested from HCD code.
    
    Signed-off-by: Stefan Becker <stefan.becker@nokia.com>
---
 drivers/usb/core/hcd.c |   38 ++++++++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 09a53e7..c13479c 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1684,19 +1684,30 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
 irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 {
 	struct usb_hcd		*hcd = __hcd;
-	int			start = hcd->state;
+	unsigned long           flags;
+	irqreturn_t             rc;
 
-	if (unlikely(start == HC_STATE_HALT ||
-	    !test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags)))
-		return IRQ_NONE;
-	if (hcd->driver->irq (hcd) == IRQ_NONE)
-		return IRQ_NONE;
+	/* IRQF_DISABLED doesn't work correctly with shared IRQs
+	 * when the first handler doesn't use it.  So let's just
+	 * assume it's never used.
+	 */
+	local_irq_save(flags);
 
-	set_bit(HCD_FLAG_SAW_IRQ, &hcd->flags);
+	if (unlikely(hcd->state == HC_STATE_HALT ||
+		     !test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags))) {
+		rc = IRQ_NONE;
+	} else if (hcd->driver->irq(hcd) == IRQ_NONE) {
+		rc = IRQ_NONE;
+	} else {
+		set_bit(HCD_FLAG_SAW_IRQ, &hcd->flags);
 
-	if (unlikely(hcd->state == HC_STATE_HALT))
-		usb_hc_died (hcd);
-	return IRQ_HANDLED;
+		if (unlikely(hcd->state == HC_STATE_HALT))
+			usb_hc_died(hcd);
+		rc = IRQ_HANDLED;
+	}
+
+	local_irq_restore(flags);
+	return rc;
 }
 
 /*-------------------------------------------------------------------------*/
@@ -1860,6 +1871,13 @@ int usb_add_hcd(struct usb_hcd *hcd,
 
 	/* enable irqs just before we start the controller */
 	if (hcd->driver->irq) {
+
+		/* IRQF_DISABLED doesn't work as advertised when used together
+		 * with IRQF_SHARED. As usb_hcd_irq() will always disable
+		 * interrupts we can remove it here.
+		 */
+		irqflags &= ~IRQF_DISABLED;
+
 		snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
 				hcd->driver->description, hcd->self.busnum);
 		if ((retval = request_irq(irqnum, &usb_hcd_irq, irqflags,

