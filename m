Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbZJJXss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbZJJXss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 19:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZJJXss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 19:48:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:44410 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbZJJXsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 19:48:47 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josua Dietze <digidietze@draisberghof.de>, Ben Efros <ben@pc-doctor.com>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
In-Reply-To: <1255217186.2192.18.camel@pasglop>
References: <Pine.LNX.4.44L0.0910101851430.7922-100000@netrider.rowland.org>
	 <1255217186.2192.18.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 10:47:17 +1100
Message-Id: <1255218437.2192.26.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-11 at 10:26 +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2009-10-10 at 18:52 -0400, Alan Stern wrote:
> > > Maybe a better approach would be to go back to 18 bytes when it fails,
> > > what do you think ?
> > 
> > We certainly could do that.  But should we turn off the SANE_SENSE flag 
> > at the same time? 
> 
> I would think so, and not set it back the next time the sense buffer
> claims more data in it (something like setting a NOT_REALLY_SANE_SENSE
> flag ? :-)
> 
> Or not care and always do double sense on those devices. Whatever
> works. It's not that sense was a fast path.

Ok, so here's an absolutely horrible hack that makes it work here,
but of course, I think that should be done more cleanly.

With some printk added I verified that it does ping pong
US_FL_SANE_SENSE (ie, sets it back as soon as the command
succeeds) but I don't see that as a big deal though.

I doubt you want to apply that as-is though but in case you do:

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.

--- a/drivers/usb/storage/transport.c	2009-10-09 14:34:14.638445171 +1100
+++ b/drivers/usb/storage/transport.c	2009-10-11 10:40:55.890868361 +1100
@@ -687,6 +687,7 @@
 		US_DEBUGP("-- unexpectedly short transfer\n");
 	}
 
+ Retry_Sense:
 	/* Now, if we need to do the auto-sense, let's do it */
 	if (need_auto_sense) {
 		int temp_result;
@@ -722,6 +723,11 @@
 		}
 		if (temp_result != USB_STOR_TRANSPORT_GOOD) {
 			US_DEBUGP("-- auto-sense failure\n");
+			if (us->fflags & US_FL_SANE_SENSE) {
+				us->fflags &= ~US_FL_SANE_SENSE;
+				US_DEBUGP("-- retry without SANE_SENSE\n");
+				goto Retry_Sense;
+			}
 
 			/* we skip the reset if this happens to be a
 			 * multi-target device, since failure of an


