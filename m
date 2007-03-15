Return-Path: <linux-kernel-owner+w=401wt.eu-S933634AbXCOUAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbXCOUAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933645AbXCOUAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:00:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57741 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933634AbXCOUAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:00:33 -0400
Date: Thu, 15 Mar 2007 16:00:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <4af2d03a0703130913n3f51a3ffiec6e498c56a34826@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703151556420.2482-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Jiri Slaby wrote:

> So, do you mean rmmod uhci_hcd, unplug the keyboard, modprobe
> uhci_hcd, start usbmon, plug the keyboard, press numlock, stop usbmon,
> post it?

By the way, what happens if you press CapsLock rather than NumLock?  It 
should behave pretty the same, sending a command to the keyboard to change 
an LED setting.  Does the keyboard then stop working in the same way?

Alan Stern

P.S.: When you do your testing, please apply the patch below.  I don't 
know if it's related to your problem, but I did see this error show up in 
someone else's system log.


Index: usb-2.6/drivers/usb/host/uhci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/uhci-q.c
+++ usb-2.6/drivers/usb/host/uhci-q.c
@@ -139,8 +139,10 @@ static struct uhci_td *uhci_alloc_td(str
 
 static void uhci_free_td(struct uhci_hcd *uhci, struct uhci_td *td)
 {
-	if (!list_empty(&td->list))
+	if (!list_empty(&td->list)) {
 		dev_warn(uhci_dev(uhci), "td %p still in list!\n", td);
+		WARN_ON(1);
+	}
 	if (!list_empty(&td->fl_list))
 		dev_warn(uhci_dev(uhci), "td %p still in fl_list!\n", td);
 

