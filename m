Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYH0GfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYH0GfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYH0GfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:35:09 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:33605 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752394AbYH0GfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:35:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ra202r0CPB71fnXMQe/XQScQTCwmgep9+NltOzyc+brdF5EgF21xrzfu7R/aBQtwJWc9ku7VbRjTUHt7Ms4zLFXVXQNYOFjd/8UeTwI52nQuZsIepHqM0ErdSnPQ7fz0E9B/uVYQV0PfL7r3lxqWLZiufx6OpFIkAyxYYuvJo2g=  ;
X-YMail-OSG: Rk76i_oVM1mbn.9LEoVolm85EqCF9ojpvpn2qQBjH5uynsMuQ9J6gegQQHqmCwS5MJFSm3WwGdrLcz.B6cnLKnNprbihg2iN3___7AkQBwzKRnxdqBkrcK06RaBJv67a40Tw7L8qvBNPZdtv3vuOgZCC
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: amruth_pv@yahoo.com
Subject: Re: USB Serial device disconnect causes IRQ disable after using ehci controller halted
Date: Tue, 26 Aug 2008 23:35:04 -0700
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Karsten Wiese <fzu@wemgehoertderstaat.de>,
       Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
References: <434860.93444.qm@web45203.mail.sp1.yahoo.com>
In-Reply-To: <434860.93444.qm@web45203.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808262335.05204.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008, amruth wrote:
> This patch below does not fix the issue it just stops IRQ being
> disabled but still ehci hcd crashes. 

That patch was only intended to address the issue of bogus error
handling.


> Please let me know what could be causing the issue.

If it's like the other case, I'd hope this patch would solve it.

Note that you also seem to be having hardware or firmware issues
with the peripheral you're connecting ... this won't change that
stuff at all.

- Dave

================ SNIP!
From: David Brownell <dbrownell@users.sourceforge.net>

As noted by Stefan Neis <Stefan.Neis@kobil.com>, we had a recent
regression with EHCI periodic transfers, in some (seemingly not
all that common) cases.

The root cause was that the schedule activation was only loosely
coupled to the addition or removal of transfers, so two different 
execution contexts could both think they had to deactivate (or
conversely activate) the schedule.  So this fix tightens that
coupling, managing it more like a refcount.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/host/ehci-sched.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/drivers/usb/host/ehci-sched.c	2008-08-15 16:38:19.000000000 -0700
+++ b/drivers/usb/host/ehci-sched.c	2008-08-15 17:47:02.000000000 -0700
@@ -437,6 +437,9 @@ static int enable_periodic (struct ehci_
 	u32	cmd;
 	int	status;
 
+	if (ehci->periodic_sched++)
+		return 0;
+
 	/* did clearing PSE did take effect yet?
 	 * takes effect only at frame boundaries...
 	 */
@@ -461,6 +464,9 @@ static int disable_periodic (struct ehci
 	u32	cmd;
 	int	status;
 
+	if (--ehci->periodic_sched)
+		return 0;
+
 	/* did setting PSE not take effect yet?
 	 * takes effect only at frame boundaries...
 	 */
@@ -544,13 +550,10 @@ static int qh_link_periodic (struct ehci
 		: (qh->usecs * 8);
 
 	/* maybe enable periodic schedule processing */
-	if (!ehci->periodic_sched++)
-		return enable_periodic (ehci);
-
-	return 0;
+	return enable_periodic(ehci);
 }
 
-static void qh_unlink_periodic (struct ehci_hcd *ehci, struct ehci_qh *qh)
+static int qh_unlink_periodic(struct ehci_hcd *ehci, struct ehci_qh *qh)
 {
 	unsigned	i;
 	unsigned	period;
@@ -586,9 +589,7 @@ static void qh_unlink_periodic (struct e
 	qh_put (qh);
 
 	/* maybe turn off periodic schedule */
-	ehci->periodic_sched--;
-	if (!ehci->periodic_sched)
-		(void) disable_periodic (ehci);
+	return disable_periodic(ehci);
 }
 
 static void intr_deschedule (struct ehci_hcd *ehci, struct ehci_qh *qh)
@@ -1562,9 +1563,7 @@ itd_link_urb (
 	urb->hcpriv = NULL;
 
 	timer_action (ehci, TIMER_IO_WATCHDOG);
-	if (unlikely (!ehci->periodic_sched++))
-		return enable_periodic (ehci);
-	return 0;
+	return enable_periodic(ehci);
 }
 
 #define	ISO_ERRS (EHCI_ISOC_BUF_ERR | EHCI_ISOC_BABBLE | EHCI_ISOC_XACTERR)
@@ -1642,7 +1641,7 @@ itd_complete (
 	ehci_urb_done(ehci, urb, 0);
 	retval = true;
 	urb = NULL;
-	ehci->periodic_sched--;
+	(void) disable_periodic(ehci);
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs--;
 
 	if (unlikely (list_empty (&stream->td_list))) {
@@ -1951,9 +1950,7 @@ sitd_link_urb (
 	urb->hcpriv = NULL;
 
 	timer_action (ehci, TIMER_IO_WATCHDOG);
-	if (!ehci->periodic_sched++)
-		return enable_periodic (ehci);
-	return 0;
+	return enable_periodic(ehci);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -2019,7 +2016,7 @@ sitd_complete (
 	ehci_urb_done(ehci, urb, 0);
 	retval = true;
 	urb = NULL;
-	ehci->periodic_sched--;
+	(void) disable_periodic(ehci);
 	ehci_to_hcd(ehci)->self.bandwidth_isoc_reqs--;
 
 	if (list_empty (&stream->td_list)) {
@@ -2243,8 +2240,7 @@ restart:
 			if (unlikely (modified)) {
 				if (likely(ehci->periodic_sched > 0))
 					goto restart;
-				/* maybe we can short-circuit this scan! */
-				disable_periodic(ehci);
+				/* short-circuit this scan */
 				now_uframe = clock;
 				break;
 			}
