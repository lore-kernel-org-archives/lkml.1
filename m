Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227Ab0B0RUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:20:39 -0500
Received: from netrider.rowland.org ([192.131.102.5]:47554 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030198Ab0B0RUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:20:37 -0500
Date: Sat, 27 Feb 2010 12:20:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Markus Rechberger <mrechberger@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       <linux-usb@vger.kernel.org>, <werner@guyane.dyn-o-saur.com>,
       Marcus Meissner <meissner@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
In-Reply-To: <20100227051737.GA14976@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1002271215290.25155-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Greg KH wrote:

> Hm, so it's back to the original idea of just doing a kzalloc of the
> initial buffer, that should solve the problem that Marcus found.
> 
> I'll go dig that back up and if you could test it, that would be most
> appreciated.

Here's a better solution.  In theory we could copy just the individual 
packets from within the transfer buffer, but that would probably take 
longer than simply copying the whole buffer.

(This was a little hasty; I haven't even compile-tested the patch. 
Some small fixes may be needed.)

Alan Stern


-----------------------------------------------------------------------

This patch fixes a bug in the way isochronous input data is returned
to userspace for usbfs transfers.  The entire buffer must be copied,
not just the first actual_length bytes, because the individual packets
will be discontiguous if any of them are short.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: stable <stable@kernel.org>

---

Index: usb-2.6/drivers/usb/core/devio.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/devio.c
+++ usb-2.6/drivers/usb/core/devio.c
@@ -1176,6 +1176,13 @@ static int proc_do_submiturb(struct dev_
 			free_async(as);
 			return -ENOMEM;
 		}
+		/* Isochronous input data may end up being discontiguous
+		 * if some of the packets are short.  Clear the buffer so
+		 * that the gaps don't leak kernel data to userspace.
+		 */
+		if (is_in && uurb->type == USBDEVFS_URB_TYPE_ISO)
+			memset(as->urb->transfer_buffer, 0,
+					uurb->buffer_length);
 	}
 	as->urb->dev = ps->dev;
 	as->urb->pipe = (uurb->type << 30) |
@@ -1312,10 +1319,14 @@ static int processcompl(struct async *as
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer && urb->actual_length)
-		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->actual_length))
+	if (as->userbuffer && urb->actual_length) {
+		if (urb->number_of_packets > 0)		/* Isochronous */
+			i = urb->transfer_buffer_length;
+		else					/* Non-Isoc */
+			i = urb->actual_length;
+		if (copy_to_user(as->userbuffer, urb->transfer_buffer, i))
 			goto err_out;
+	}
 	if (put_user(as->status, &userurb->status))
 		goto err_out;
 	if (put_user(urb->actual_length, &userurb->actual_length))

