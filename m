Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYGZPGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYGZPGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYGZPG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:06:29 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:25640 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752170AbYGZPG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:06:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=53bhLEYFm6pJghAJjhI1qgEDlBK1hKhcYGDyMrQ8f+ZpyUwXUzsjhisphzBtBu7HLkxNx1nNQiPSNLgpRCZMj4GtBEt36DZwyAQSU8FG2D+Qu7iyd1NnB7T7nCvtR5RvPgBFrlYZBciU0xgfLM1P9bg/Euqm+spif+hHkEmoUVg=  ;
X-YMail-OSG: bO8Lmi4VM1nxAHI7TFs9aVexVGQebQYcbpiQ_EZavb.r4m4rTOrj2sMth_xL8VKo5mUR5mh0fXqYfvBDYyycYht36Hqsb0Rrimfve9vZSXOJS3nWqTl__UDlsN.WSVCiTgU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [USB boot crash, -git] ecm_do_notify(), list_add corruption. prev->next should be next (ffff88003b8f82f8)
Date: Sat, 26 Jul 2008 08:06:24 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0807240931220.3494-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807240931220.3494-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807260806.24859.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008, Alan Stern wrote:
> Can you make the necessary change and try it out?

This resolves the problem for me ... and, I'd expect, for Ingo.


======= CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

This fixes a BUG() turned up by Ingo via randconfig testing, where
CONFIG_LIST_DEBUG turned up list corruption.  The corruption was
caused by the dummy_hcd (single-machine test harness for gadget and
HCD code) trashing the request queue when driven by the new CDC
composite gadget an I/O pattern that was previously uncommon.
Fix suggested by Alan Stern.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/gadget/dummy_hcd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/dummy_hcd.c	2008-07-24 18:27:52.000000000 -0700
+++ b/drivers/usb/gadget/dummy_hcd.c	2008-07-26 07:35:12.000000000 -0700
@@ -542,13 +542,14 @@ dummy_queue (struct usb_ep *_ep, struct 
 		req->req.context = dum;
 		req->req.complete = fifo_complete;
 
+		list_add_tail(&req->queue, &ep->queue);
 		spin_unlock (&dum->lock);
 		_req->actual = _req->length;
 		_req->status = 0;
 		_req->complete (_ep, _req);
 		spin_lock (&dum->lock);
-	}
-	list_add_tail (&req->queue, &ep->queue);
+	}  else
+		list_add_tail(&req->queue, &ep->queue);
 	spin_unlock_irqrestore (&dum->lock, flags);
 
 	/* real hardware would likely enable transfers here, in case

