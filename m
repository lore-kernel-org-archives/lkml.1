Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZG1XDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZG1XDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZG1XDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:03:51 -0400
Received: from kroah.org ([198.145.64.141]:42927 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbZG1XDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:03:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:41 2009
Message-Id: <20090728225941.846061551@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 06/37] USB: EHCI: report actual_length for iso transfers
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=usb-ehci-report-actual_length-for-iso-transfers.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit ec6d67e39f5638c792eb7490bf32586ccb9d8005 upstream.

This patch (as1259b) makes ehci-hcd return the total number of bytes
transferred in urb->actual_length for Isochronous transfers.
Until now, the actual_length value was unaccountably left at 0.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-sched.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1617,11 +1617,14 @@ itd_complete (
 				desc->status = -EPROTO;
 
 			/* HC need not update length with this error */
-			if (!(t & EHCI_ISOC_BABBLE))
-				desc->actual_length = EHCI_ITD_LENGTH (t);
+			if (!(t & EHCI_ISOC_BABBLE)) {
+				desc->actual_length = EHCI_ITD_LENGTH(t);
+				urb->actual_length += desc->actual_length;
+			}
 		} else if (likely ((t & EHCI_ISOC_ACTIVE) == 0)) {
 			desc->status = 0;
-			desc->actual_length = EHCI_ITD_LENGTH (t);
+			desc->actual_length = EHCI_ITD_LENGTH(t);
+			urb->actual_length += desc->actual_length;
 		} else {
 			/* URB was too late */
 			desc->status = -EXDEV;
@@ -2012,7 +2015,8 @@ sitd_complete (
 			desc->status = -EPROTO;
 	} else {
 		desc->status = 0;
-		desc->actual_length = desc->length - SITD_LENGTH (t);
+		desc->actual_length = desc->length - SITD_LENGTH(t);
+		urb->actual_length += desc->actual_length;
 	}
 	stream->depth -= stream->interval << 3;
 


