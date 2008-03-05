Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbYCEEP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbYCEEP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 23:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYCEEPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 23:15:47 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:21419 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752925AbYCEEPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 23:15:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Am6LZHrCT3I8xcWe39oy7bCd9n68OWWLOlgTWxQaT3qgR82vChqVN8wG6x/kwFu1RdR18fAetN5izZ8XlnKiNafpCjN2LeOVFc42BoUozgS+dOWwMYyUjRIv5wqFd2vbQcz5NCr1iftldG5bzs74jOx97G7InE7EtMAuzJmts+8=  ;
X-YMail-OSG: UGBoCc0VM1n1DYakatYqKS7HNp_0YzjfmAXNMrp27TCsm4oTcM7EImxKAmRBoGSC5aa7Gy2Uuw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB OOPS 2.6.25-rc2-git1
Date: Tue, 4 Mar 2008 20:15:42 -0800
User-Agent: KMail/1.9.6
Cc: Andre Tomt <andre@tomt.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802211057440.4528-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802211057440.4528-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042015.43165.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008, Alan Stern wrote:
>
> Okay, so this isn't as bad as it seemed.  I don't have a copy of your 
> most recent patch, but it seems clear that the watchdog routine must:
> 
> 	First remove the circumstances that would cause the controller 
> 	to set IAA.  I guess that means clearing IAAD; it's not
> 	entirely clear from the spec whether this will do what we 
> 	want.

The spec says that IAAD gets cleared when IAA is set.  Clearing
IAAD should strictly speaking never be needed if IAA is seen ...
but my latest patch will do so (on both watchdog and IRQ paths)
when it's set.  Call it paranoia.


> 	Then clear IAA (if it happens to be set).

Yes; I re-ordered that to read IAAD first, to give more useful
diagnostics in case of an extremely belated trigger of IAA
that follows reading IAAD.

 
> This is the only way to avoid the race, and I know that my original
> version of the routine does these steps in the wrong order (if at all).  
> That should be fixed.

How does the appended patch look?


> Given sufficiently bizarre hardware we can't be 
> certain that things won't still go wrong on occasion, but this is the
> best we can do for now -- weird hardware can be handled as it arises.

The appended patch does include a bit of paranoia around IAA and IAAD;
I figure it can't hurt, although at this point I have no particular
reason to believe anyone except VIA has bugs in those areas.

 
> The other change to make (which you have already anticipated) is to 
> guard against ehci->reclaim == NULL in end_unlink_async().  There's no 
> real need for a warning or stack dump; it should just return silently 
> when this happens.  If there is a warning, maybe it should be placed at 
> the site of the caller (for example, in ehci_irq() when STS_IAA is 
> detected).

Yeah, that seems like a better place to do it.  All the other callers
guarantee ehci->reclaim is non-null before calling it.  The fact that
it happens in this case suggests IAAD and/or IAAD didn't get cleared
properly.

- Dave


========== CUT HERE
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
