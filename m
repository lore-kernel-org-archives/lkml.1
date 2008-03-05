Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbYCEEZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbYCEEZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 23:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbYCEEZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 23:25:34 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:31940 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755071AbYCEEZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 23:25:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3A8hKmYVgh74pzBeyClGf61UvJH7454B8BFs+60E6y7OCYHBdOjQIPB41DwEgEdB36PJHwsaYqmkbU/fnubetZD2FPTfVjWyNZBviPs79RcMys4fYMTrfwCeP7d+o4q2LKbPORzKUsoE6+clLu5b5wJEpAMMnWQ7T07/WpGMq/4=  ;
X-YMail-OSG: y8S8U5gVM1mRcYpfGKk3nPC9Bdyw55KCf3RdHG6BXVVRpNaGEtfR83ZtjgL2fEt8Jxm0OrUH49op0gbJuYcXQQbqM5S20.WCpRg4aNmS17kLalfodcrvLFr4kX.H
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Christian Kujau <lists@nerdbynature.de>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
Date: Tue, 4 Mar 2008 20:25:30 -0800
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803041553320.15986-100000@iolanthe.rowland.org> <200803041630.11832.david-b@pacbell.net> <alpine.DEB.1.00.0803050215140.7069@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0803050215140.7069@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042025.30613.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Christian Kujau wrote:
> On Tue, 4 Mar 2008, David Brownell wrote:

> > There are other lurking issues though.
> 
> uuh...let's hope they don't wake up?

Nah.  See the patch I just attached to

	http://bugzilla.kernel.org/show_bug.cgi?id=10078

... appended here for reference.

- Dave


======== CUT HERE
The recent EHCI driver update to split the IAA watchdog timer out from
the other timers made several things work better, but not everything;
and it created a couple new issues in bugzilla.  Ergo this patch:

  - Handle a should-be-rare SMP race between the watchdog firing
    and (very late) IAA interrupts;

  - Remove a shouldn't-have-been-added WARN_ON() test;

  - Guard against one observed OOPS;

  - If this watchdog fires during clean HC shutdown, it should act
    as a NOP instead of interfering with the shutdown sequence;

  - Guard against silicon errata hypothesized by some vendors:
      * IAA status latch broken, but IAAD cleared OK;
      * IAAD wasn't cleared when IAA status got reported;

The WARN_ON is in bugzilla as 10168; the OOPS as 10078.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/host/ehci-hcd.c |   60 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 15 deletions(-)

--- g26.orig/drivers/usb/host/ehci-hcd.c	2008-03-04 17:24:22.000000000 -0800
+++ g26/drivers/usb/host/ehci-hcd.c	2008-03-04 20:08:28.000000000 -0800
@@ -257,23 +257,44 @@ static void ehci_iaa_watchdog(unsigned l
 {
 	struct ehci_hcd		*ehci = (struct ehci_hcd *) param;
 	unsigned long		flags;
-	u32			status, cmd;
 
 	spin_lock_irqsave (&ehci->lock, flags);
-	WARN_ON(!ehci->reclaim);
 
-	status = ehci_readl(ehci, &ehci->regs->status);
-	cmd = ehci_readl(ehci, &ehci->regs->command);
-	ehci_dbg(ehci, "IAA watchdog: status %x cmd %x\n", status, cmd);
-
-	/* lost IAA irqs wedge things badly; seen first with a vt8235 */
-	if (ehci->reclaim) {
-		if (status & STS_IAA) {
-			ehci_vdbg (ehci, "lost IAA\n");
+	/* Lost IAA irqs wedge things badly; seen first with a vt8235.
+	 * So we need this watchdog, but must protect it against both
+	 * (a) SMP races against real IAA firing and retriggering, and
+	 * (b) clean HC shutdown, when IAA watchdog was pending.
+	 */
+	if (ehci->reclaim
+			&& !timer_pending(&ehci->iaa_watchdog)
+			&& HC_IS_RUNNING(ehci_to_hcd(ehci)->state)) {
+		u32 cmd, status;
+
+		/* If we get here, IAA is *REALLY* late.  It's barely
+		 * conceivable that the system is so busy that CMD_IAAD
+		 * is still legitimately set, so let's be sure it's
+		 * clear before we read STS_IAA.  (The HC should clear
+		 * CMD_IAAD when it sets STS_IAA.)
+		 */
+		cmd = ehci_readl(ehci, &ehci->regs->command);
+		if (cmd & CMD_IAAD)
+			ehci_writel(ehci, cmd & ~CMD_IAAD,
+					&ehci->regs->command);
+
+		/* If IAA is set here it either legitimately triggered
+		 * before we cleared IAAD above (but _way_ late, so we'll
+		 * still count it as lost) ... or a silicon erratum:
+		 * - VIA seems to set IAA without triggering the IRQ;
+		 * - IAAD potentially cleared without setting IAA.
+		 */
+		status = ehci_readl(ehci, &ehci->regs->status);
+		if ((status & STS_IAA) || !(cmd & CMD_IAAD)) {
 			COUNT (ehci->stats.lost_iaa);
 			ehci_writel(ehci, STS_IAA, &ehci->regs->status);
 		}
-		ehci_writel(ehci, cmd & ~CMD_IAAD, &ehci->regs->command);
+
+		ehci_vdbg(ehci, "IAA watchdog: status %x cmd %x\n",
+				status, cmd);
 		end_unlink_async(ehci);
 	}
 
@@ -607,7 +628,7 @@ static int ehci_run (struct usb_hcd *hcd
 static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
-	u32			status, pcd_status = 0;
+	u32			status, pcd_status = 0, cmd;
 	int			bh;
 
 	spin_lock (&ehci->lock);
@@ -628,7 +649,7 @@ static irqreturn_t ehci_irq (struct usb_
 
 	/* clear (just) interrupts */
 	ehci_writel(ehci, status, &ehci->regs->status);
-	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted write */
+	cmd = ehci_readl(ehci, &ehci->regs->command);
 	bh = 0;
 
 #ifdef	VERBOSE_DEBUG
@@ -649,8 +670,17 @@ static irqreturn_t ehci_irq (struct usb_
 
 	/* complete the unlinking of some qh [4.15.2.3] */
 	if (status & STS_IAA) {
-		COUNT (ehci->stats.reclaim);
-		end_unlink_async(ehci);
+		/* guard against (alleged) silicon errata */
+		if (cmd & CMD_IAAD) {
+			ehci_writel(ehci, cmd & ~CMD_IAAD,
+					&ehci->regs->command);
+			ehci_dbg(ehci, "IAA with IAAD still set?\n");
+		}
+		if (ehci->reclaim) {
+			COUNT(ehci->stats.reclaim);
+			end_unlink_async(ehci);
+		} else
+			ehci_dbg(ehci, "IAA with nothing to reclaim?\n");
 	}
 
 	/* remote wakeup [4.3.1] */
