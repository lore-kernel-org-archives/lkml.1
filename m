Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYGVXW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYGVXW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYGVXSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:18:21 -0400
Received: from mail.suse.de ([195.135.220.2]:52919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbYGVXST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:18:19 -0400
Date: Tue, 22 Jul 2008 16:15:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Becker <stefan.becker@nokia.com>,
       David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 13/47] USB: fix interrupt disabling for HCDs with shared
	interrupt handlers
Message-ID: <20080722231502.GN8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-interrupt-disabling-for-hcds-with-shared-interrupt-handlers.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Stefan Becker <Stefan.Becker@nokia.com>

commit de85422b94ddb23c021126815ea49414047c13dc upstream

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
Acked-by: David Brownell <david-b@pacbell.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hcd.c |   42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1685,19 +1685,30 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
 irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 {
 	struct usb_hcd		*hcd = __hcd;
-	int			start = hcd->state;
+	unsigned long		flags;
+	irqreturn_t		rc;
 
-	if (unlikely(start == HC_STATE_HALT ||
-	    !test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags)))
-		return IRQ_NONE;
-	if (hcd->driver->irq (hcd) == IRQ_NONE)
-		return IRQ_NONE;
-
-	set_bit(HCD_FLAG_SAW_IRQ, &hcd->flags);
-
-	if (unlikely(hcd->state == HC_STATE_HALT))
-		usb_hc_died (hcd);
-	return IRQ_HANDLED;
+	/* IRQF_DISABLED doesn't work correctly with shared IRQs
+	 * when the first handler doesn't use it.  So let's just
+	 * assume it's never used.
+	 */
+	local_irq_save(flags);
+
+	if (unlikely(hcd->state == HC_STATE_HALT ||
+		     !test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags))) {
+		rc = IRQ_NONE;
+	} else if (hcd->driver->irq(hcd) == IRQ_NONE) {
+		rc = IRQ_NONE;
+	} else {
+		set_bit(HCD_FLAG_SAW_IRQ, &hcd->flags);
+
+		if (unlikely(hcd->state == HC_STATE_HALT))
+			usb_hc_died(hcd);
+		rc = IRQ_HANDLED;
+	}
+
+	local_irq_restore(flags);
+	return rc;
 }
 
 /*-------------------------------------------------------------------------*/
@@ -1861,6 +1872,13 @@ int usb_add_hcd(struct usb_hcd *hcd,
 
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

-- 
