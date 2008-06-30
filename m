Return-Path: <linux-kernel-owner+w=401wt.eu-S1763557AbYF3Ubc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557AbYF3Ubc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYF3UbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:31:23 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:29473 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752377AbYF3UbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:31:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zHFhAV05alPnRnOSTFIOYQXt9TJ/olKTEpz5g4/L4yqyVeyjSl8GUUVsetVlEnLTsVyRCjtXs7CLEhFEmcvjm0hZkiCSjkOCf4AcD8ZBEiG7GnFRJFaTyAV3/79lRnu6EBm67X2ED6BdZ/frfhqlo3Ic6e0VLmu9cIvZDQGTT7E=  ;
X-YMail-OSG: c4DlwIUVM1makdyedS1ijPuPg.5MUHKCx9bzyx5yqDE37WzgaoXBxh7dQcu2DrGYMi_aXo.O10fbBx5LJx8zDWDt9K5IWxO1zatJ4i1rOthew3Ji7lmcCBjN9Poug9.UPws-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared interrupt handlers
Date: Mon, 30 Jun 2008 13:31:20 -0700
User-Agent: KMail/1.9.9
Cc: Stefan Becker <Stefan.Becker@nokia.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <Pine.LNX.4.44L0.0806301532500.2138-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806301532500.2138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806301331.21077.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008, Alan Stern wrote:
> Don't bother with this extra stuff.  All USB host controller drivers
> want to have interrupts disabled when their IRQ handlers run.

How about this one instead?  I think it's probably almost midnight
where Stefan is, so I'd not expect Stefan to have an updated
patch very soon ... :)

- dave


====== CUT HERE
Add a workaround for the way the IRQ framework can disregard
IRQF_DISABLED when IRQF_SHARED is set and lockdep isn't in use.

This leaves IRQF_DISABLED active for unshared IRQs, but clears
that flag otherwise (since the genirq code should eventually
start warning folk about that bad combination of flags).

(Thanks to Stefan Becker <Stefan.Becker@nokia.com> for tracking
down the source of hard lockups on his hardware; on some systems
this problem could lead to oopsing.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
UNTESTED but "obviously right" yes?  Candidate for 2.6.26-rc8+ ...

 drivers/usb/core/hcd.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/hcd.c	2008-06-30 13:09:00.000000000 -0700
+++ b/drivers/usb/core/hcd.c	2008-06-30 13:28:04.000000000 -0700
@@ -1687,19 +1687,31 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
 irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 {
 	struct usb_hcd		*hcd = __hcd;
-	int			start = hcd->state;
+	int			start;
+	unsigned long		flags;
+	irqreturn_t		value = IRQ_NONE;
+
+	/* IRQF_DISABLED doesn't work correctly with shared IRQs
+	 * when the first handler doesn't use it.  So let's just
+	 * assume it's never used.
+	 */
+	local_irq_save(flags);
 
+	start = hcd->state;
 	if (unlikely(start == HC_STATE_HALT ||
 	    !test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags)))
-		return IRQ_NONE;
+		goto done;
 	if (hcd->driver->irq (hcd) == IRQ_NONE)
-		return IRQ_NONE;
+		goto done;
 
+	value = IRQ_HANDLED;
 	set_bit(HCD_FLAG_SAW_IRQ, &hcd->flags);
 
 	if (unlikely(hcd->state == HC_STATE_HALT))
 		usb_hc_died (hcd);
-	return IRQ_HANDLED;
+done:
+	local_irq_restore(flags);
+	return value;
 }
 
 /*-------------------------------------------------------------------------*/
@@ -1865,6 +1877,8 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	if (hcd->driver->irq) {
 		snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
 				hcd->driver->description, hcd->self.busnum);
+		/* work around (IRQF_SHARED|IRQF_DISABLED) misbehavior.. */
+		irqflags &= ~IRQF_DISABLED;
 		if ((retval = request_irq(irqnum, &usb_hcd_irq, irqflags,
 				hcd->irq_descr, hcd)) != 0) {
 			dev_err(hcd->self.controller,
