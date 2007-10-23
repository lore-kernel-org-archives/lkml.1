Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXJWEBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXJWEBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbXJWEBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:01:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4514 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750815AbXJWEBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:01:38 -0400
Date: Tue, 23 Oct 2007 00:01:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: gregkh@suse.de, <linux-arch@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>, <matthew@wil.cx>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, <viro@zeniv.linux.org.uk>,
       <viro@ftp.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, <adobriyan@gmail.com>
Subject: Re: [linux-usb-devel] USB HCD: avoid duplicate local_irq_disable()
In-Reply-To: <200710230328.33915.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.0710222359290.13902-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Arnd Bergmann wrote:

> usb_hcd_flush_endpoint() has a retry loop that starts with a spin_lock_irq(),
> but only gives up the spinlock, not the irq_disable before jumping to the
> rescan label.
> 
> Split the spin_lock_irq into the retryable part and the local_irq_disable()
> that is only done once as a micro-optimization and slight cleanup.

I agree with your sentiment, but it would be better to solve this 
problem without using local_irq_disable().  The patch below does this.

---

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: usb-2.6/drivers/usb/core/hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/hcd.c
+++ usb-2.6/drivers/usb/core/hcd.c
@@ -1312,8 +1312,8 @@ void usb_hcd_flush_endpoint(struct usb_d
 	hcd = bus_to_hcd(udev->bus);
 
 	/* No more submits can occur */
-rescan:
 	spin_lock_irq(&hcd_urb_list_lock);
+rescan:
 	list_for_each_entry (urb, &ep->urb_list, urb_list) {
 		int	is_in;
 
@@ -1346,6 +1346,7 @@ rescan:
 		usb_put_urb (urb);
 
 		/* list contents may have changed */
+		spin_lock(&hcd_urb_list_lock);
 		goto rescan;
 	}
 	spin_unlock_irq(&hcd_urb_list_lock);

