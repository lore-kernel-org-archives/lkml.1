Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbYBSStm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbYBSStm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYBSSte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:49:34 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:34807 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753574AbYBSStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:49:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cWUtrhJ2dIm4emi7tHbTg6hdmkBqzcGL4mCknQ05ksgHkF4SHpQmF7X7JCcLZf/iZ9uM0dDho0dgk2a7C70IqP/NdK8+rH/D18bDMdlnbUWvyfl3fcgUtATHp99ry7/8v4MsG5fr5eFDlMGe/fIU/yS3zxhMO+w0UZPdPCNb+oI=  ;
X-YMail-OSG: 7SooxugVM1kS85gyrNauPsFsSKHyTnalU9QcYXGs4pZRv2RBjNScLD29rzuV9mwdDYBPIatyuQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andre Tomt <andre@tomt.net>
Subject: Re: USB OOPS 2.6.25-rc2-git1
Date: Tue, 19 Feb 2008 10:49:25 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <47BAF36C.4000509@tomt.net>
In-Reply-To: <47BAF36C.4000509@tomt.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191049.25869.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Andre Tomt wrote:
> Got this on a serial console today, using 2.6.25-rc2-git1. Machine was 
> not doing anything interesting at the time, but has its / and kernel on 
> a usb-storage device (usb pen drive).

Can you try this diagnostic patch, to see if it reports any messages
about IAA and/or IAAD oddities?  There's surely a quick workaround
for this, but I'd rather understand the root cause before patching.

- Dave


Work around for an evident bug in one EHCI controller:  IAA didn't get
set when IAAD was cleared.  Evidently writing the status register can
prevent setting IAA; someone's VHDL (or whatever) code was wrong.
This workaround catches that specific bug (in the IRQ handler and in
the IAA watchdog) and treats it as if IAA was properly set.

The patch also adds *LOTS* of related paranoia, insisting IAAD is clear
(or set, as appropriate) at various points, and adding code to improve
the handling of some such cases.  It also raises the volume and precision
of debug messaging related to IAA problems.

This patch is EXPERIMENTAL and DIAGNOSTIC ... not intended for merge.
It's also in *addition* to the IAA watchdog timer rework that's already
been merged into 2.6.25-rc1, which will help some systems.

If you use this, run with CONFIG_USB_DEBUG enabled.  Most messages
with IAA or IAAD should then be "interesting" in the sense that they
will indicate something odd happening ... maybe something that's
fully worked around, maybe not.

---
 drivers/usb/host/ehci-hcd.c |   38 ++++++++++++++++++++++++++++++--------
 drivers/usb/host/ehci-q.c   |   27 ++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 9 deletions(-)

--- g26.orig/drivers/usb/host/ehci-hcd.c	2008-02-11 19:18:39.000000000 -0800
+++ g26/drivers/usb/host/ehci-hcd.c	2008-02-13 15:30:56.000000000 -0800
@@ -255,21 +255,33 @@ static void ehci_iaa_watchdog(unsigned l
 	u32			status, cmd;
 
 	spin_lock_irqsave (&ehci->lock, flags);
-	WARN_ON(!ehci->reclaim);
 
 	status = ehci_readl(ehci, &ehci->regs->status);
 	cmd = ehci_readl(ehci, &ehci->regs->command);
-	ehci_dbg(ehci, "IAA watchdog: status %x cmd %x\n", status, cmd);
 
 	/* lost IAA irqs wedge things badly; seen first with a vt8235 */
 	if (ehci->reclaim) {
-		if (status & STS_IAA) {
-			ehci_vdbg (ehci, "lost IAA\n");
+		/* STS_IAA means we got the status, but no IRQ.  (Or at
+		 * best, the IRQ took until just now to arrive.)  Missing
+		 * CMD_IAAD means we got the effect, but no status or IRQ.
+		 */
+		if ((status & STS_IAA) || !(cmd & CMD_IAAD)) {
 			COUNT (ehci->stats.lost_iaa);
-			ehci_writel(ehci, STS_IAA, &ehci->regs->status);
+			if (status & STS_IAA)
+				ehci_writel(ehci, STS_IAA,
+						&ehci->regs->status);
 		}
-		ehci_writel(ehci, cmd & ~CMD_IAAD, &ehci->regs->command);
+		ehci_dbg(ehci, "IAA watchdog%s: status %x cmd %x\n",
+				((status & STS_IAA) || !(cmd & CMD_IAAD))
+					? ", lost IAA" : "",
+				status, cmd);
 		end_unlink_async(ehci);
+
+	} else if (status & STS_IAA) {
+		ehci_writel(ehci, STS_IAA, &ehci->regs->status);
+		ehci_dbg(ehci, "IAA watchdog%s: status %x cmd %x\n",
+				", IAA with empty reclaim",
+				status, cmd);
 	}
 
 	spin_unlock_irqrestore(&ehci->lock, flags);
@@ -602,7 +614,7 @@ static int ehci_run (struct usb_hcd *hcd
 static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
-	u32			status, pcd_status = 0;
+	u32			status, pcd_status = 0, cmd;
 	int			bh;
 
 	spin_lock (&ehci->lock);
@@ -623,7 +635,7 @@ static irqreturn_t ehci_irq (struct usb_
 
 	/* clear (just) interrupts */
 	ehci_writel(ehci, status, &ehci->regs->status);
-	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted write */
+	cmd = ehci_readl(ehci, &ehci->regs->command);
 	bh = 0;
 
 #ifdef	VERBOSE_DEBUG
@@ -642,6 +654,16 @@ static irqreturn_t ehci_irq (struct usb_
 		bh = 1;
 	}
 
+	/* Cope with silicon bug where IAA sometimes isn't set, but
+	 * IAAD is cleared ... clearing should be a side effect of
+	 * setting IAA.  So assume that when we expect IAA but neither
+	 * IAA nor IAAD are set, we should act as if IAA was reported.
+	 */
+	if (ehci->reclaim && !(status & STS_IAA) && !(cmd & CMD_IAAD)) {
+		ehci_dbg(ehci, "IAAD cleared without IAA\n");
+		status |= STS_IAA;
+	}
+
 	/* complete the unlinking of some qh [4.15.2.3] */
 	if (status & STS_IAA) {
 		COUNT (ehci->stats.reclaim);
--- g26.orig/drivers/usb/host/ehci-q.c	2008-02-11 19:18:39.000000000 -0800
+++ g26/drivers/usb/host/ehci-q.c	2008-02-13 17:44:48.000000000 -0800
@@ -1018,6 +1018,19 @@ static void end_unlink_async (struct ehc
 			timer_action (ehci, TIMER_ASYNC_OFF);
 	}
 
+	/* IAAD being set after STS_IAA indicates a silicon bug.  But some
+	 * suspend paths force unlinks to complete; this can be fine.
+	 */
+	if (HC_IS_RUNNING(ehci_to_hcd(ehci)->state)) {
+		u32 cmd = ehci_readl(ehci, &ehci->regs->command);
+
+		if (cmd & CMD_IAAD) {
+			ehci_dbg(ehci, "IAAD wasn't clear %08x\n", cmd);
+			cmd &= ~CMD_IAAD;
+			ehci_writel(ehci, cmd, &ehci->regs->command);
+		}
+	}
+
 	if (next) {
 		ehci->reclaim = NULL;
 		start_unlink_async (ehci, next);
@@ -1041,6 +1054,13 @@ static void start_unlink_async (struct e
 		BUG ();
 #endif
 
+	if (cmd & CMD_IAAD) {
+		ehci_writel(ehci, cmd & ~CMD_IAAD, &ehci->regs->command);
+		cmd = ehci_readl(ehci, &ehci->regs->command);
+		ehci_err(ehci, "IAAD already set%s\n",
+				(cmd & CMD_IAAD) ? "; clear failed" : "");
+	}
+
 	/* stop async schedule right now? */
 	if (unlikely (qh == ehci->async)) {
 		/* can't get here without STS_ASS set */
@@ -1077,7 +1097,12 @@ static void start_unlink_async (struct e
 
 	cmd |= CMD_IAAD;
 	ehci_writel(ehci, cmd, &ehci->regs->command);
-	(void)ehci_readl(ehci, &ehci->regs->command);
+	cmd = ehci_readl(ehci, &ehci->regs->command);
+	if (!(cmd & CMD_IAAD)) {
+		if (!(ehci_readl(ehci, &ehci->regs->status) & STS_IAA))
+			ehci_err(ehci, "write of IAAD didn't take? %08x\n",
+					cmd);
+	}
 	iaa_watchdog_start(ehci);
 }
 
