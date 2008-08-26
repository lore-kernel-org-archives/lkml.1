Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbYHZVn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbYHZVn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYHZVnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:43:50 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:29332 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751997AbYHZVnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:43:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rbiNBqB76beEw6ohrT8NiFwU6JLiEWTVzuKEs8X+zGHqUtvMKOCJYOWmRWHJIq7/VWNtWEb/kiRERdZBz5qXurhvEJ6fZ6FkGYcMH7pKNFhX8rVX+D+1+2MawySndjU7EBmp5Q7sS37FecnJvrCvKa/MRW2Hn9V+dHyYELR24ps=  ;
X-YMail-OSG: sB_QtUQVM1nlcTVYjzoRhFD8KqXlqnZ36U76fTot2Ka7zuBdChwVljV46ENyZ30WWODugYzUqBMznT6kB7Z7feygrwVsOxYdeclvXJkP3RRizemA5KZbIOY55ILzggI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB Serial device disconnect causes IRQ disable after using ehci controller halted
Date: Tue, 26 Aug 2008 14:43:46 -0700
User-Agent: KMail/1.9.9
Cc: Karsten Wiese <fzu@wemgehoertderstaat.de>, amruth <amruth_pv@yahoo.com>,
       Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
References: <Pine.LNX.4.44L0.0808261707090.2139-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808261707090.2139-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808261443.47064.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008, Alan Stern wrote:
> While it certainly would be a good idea to prevent the handshake 
> failures from occurring in the first place -- Dave, aren't you working 
> on a patch for that? -- we should also make sure that when they do 
> occur, the controller gets reset properly.  And an error message should 
> be printed in the log.

Like this?

Greg, please queue for 2.6.27 unless someone finds a
problem with this patch.


=========	SNIP!  SNIP!  SNIPPITY SNIP!
From: David Brownell <dbrownell@users.sourceforge.net>

I noticed that the "Refactor "if (handshake()) state = HC_STATE_HALT"
patch from earlier this year perpetuated a potential problem:  it can
mark the controller as halted when it's still running (but not acting
as, perhaps wrongly, expected).

That caused some hangs and crashes, rather than more polite failure
modes of a truly halted controller.  This patch forces a true halt,
and emits a (previously missing) diagnostic.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/host/ehci-hcd.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c	2008-08-15 14:04:27.000000000 -0700
+++ b/drivers/usb/host/ehci-hcd.c	2008-08-15 14:04:36.000000000 -0700
@@ -145,16 +145,6 @@ static int handshake (struct ehci_hcd *e
 	return -ETIMEDOUT;
 }
 
-static int handshake_on_error_set_halt(struct ehci_hcd *ehci, void __iomem *ptr,
-				       u32 mask, u32 done, int usec)
-{
-	int error = handshake(ehci, ptr, mask, done, usec);
-	if (error)
-		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
-
-	return error;
-}
-
 /* force HC to halt state from unknown (EHCI spec section 2.3) */
 static int ehci_halt (struct ehci_hcd *ehci)
 {
@@ -173,6 +163,22 @@ static int ehci_halt (struct ehci_hcd *e
 			  STS_HALT, STS_HALT, 16 * 125);
 }
 
+static int handshake_on_error_set_halt(struct ehci_hcd *ehci, void __iomem *ptr,
+				       u32 mask, u32 done, int usec)
+{
+	int error;
+
+	error = handshake(ehci, ptr, mask, done, usec);
+	if (error) {
+		ehci_halt(ehci);
+		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
+		ehci_err(ehci, "force halt; handhake %p %08x %08x -> %d\n",
+			ptr, mask, done, error);
+	}
+
+	return error;
+}
+
 /* put TDI/ARC silicon into EHCI mode */
 static void tdi_reset (struct ehci_hcd *ehci)
 {


