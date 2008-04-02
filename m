Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbYDBPrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbYDBPrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbYDBPri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:47:38 -0400
Received: from rtr.ca ([76.10.145.34]:4359 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbYDBPrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:47:37 -0400
Message-ID: <47F3AA97.1010704@rtr.ca>
Date: Wed, 02 Apr 2008 11:47:35 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@suse.cz>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, jikos@suse.cz,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.25-rc7:  Ugh. ---> PATCH
References: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org> <47F3A9C3.7030702@rtr.ca>
In-Reply-To: <47F3A9C3.7030702@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> This patch seems to fix it.
> Could you guys look this over some more,
> as I really am not familiar with the USB code.

Here it is again, with more lines of context, for easier review:

* * *

When comparing 2.6.24 against 2.6.25, this line of code
stood out as not looking entirely correct, given the new
uses of QH_STATE_UNLINK_WAIT in 2.6.25.

Applying this patch seems to fix the USB suspend/resume deaths
on my machine here.  More testing is needed to be sure.

Signed-off-by: Mark Lord <mlord@pobox.com>
---

Regenerated with more context in diff, for easier review.

--- linux/drivers/usb/host/ehci-hcd.c.orig	2008-03-11 11:18:40.000000000 -0400
+++ linux/drivers/usb/host/ehci-hcd.c	2008-04-02 11:36:13.000000000 -0400
@@ -801,35 +801,35 @@
 		return intr_submit(ehci, urb, &qtd_list, mem_flags);
 
 	case PIPE_ISOCHRONOUS:
 		if (urb->dev->speed == USB_SPEED_HIGH)
 			return itd_submit (ehci, urb, mem_flags);
 		else
 			return sitd_submit (ehci, urb, mem_flags);
 	}
 }
 
 static void unlink_async (struct ehci_hcd *ehci, struct ehci_qh *qh)
 {
 	/* failfast */
 	if (!HC_IS_RUNNING(ehci_to_hcd(ehci)->state) && ehci->reclaim)
 		end_unlink_async(ehci);
 
 	/* if it's not linked then there's nothing to do */
-	if (qh->qh_state != QH_STATE_LINKED)
+	if (qh->qh_state != QH_STATE_LINKED && qh->qh_state != QH_STATE_UNLINK_WAIT)
 		;
 
 	/* defer till later if busy */
 	else if (ehci->reclaim) {
 		struct ehci_qh		*last;
 
 		for (last = ehci->reclaim;
 				last->reclaim;
 				last = last->reclaim)
 			continue;
 		qh->qh_state = QH_STATE_UNLINK_WAIT;
 		last->reclaim = qh;
 
 	/* start IAA cycle */
 	} else
 		start_unlink_async (ehci, qh);
 }
