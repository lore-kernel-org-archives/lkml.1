Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbXENXsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbXENXsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbXENXsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:48:07 -0400
Received: from rtr.ca ([64.26.128.89]:2450 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbXENXsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:48:06 -0400
Message-ID: <4648F532.4030809@rtr.ca>
Date: Mon, 14 May 2007 19:48:02 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       marcel@holtmann.org
Subject: Re: [BUG] usb/core/hub.c loops forever on resume from ram due to
 bluetooth
References: <4637CD25.5070104@rtr.ca> <464080C1.6010105@rtr.ca> <20070513092701.GD11249@suse.de>
In-Reply-To: <20070513092701.GD11249@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>
> Ok, I'll take a patch to keep the loop from going forever, but the main
> issue here is that there is probably a hardware failure somewhere.

Okay, found it.  The root cause here was a missing CONFIG_USB_SUSPEND=y,
which means the hci_usb device never got marked as USB_STATE_SUSPENDED,
which then caused the loop to go on forever.

The system works fine now with CONFIG_USB_SUSPEND=y in the .config.

Here's the patch to prevent future lockups for this or other causes.
I no longer need it, but it does still seem a good idea.

Signed-off-by:  Mark Lord <mlord@pobox.com>
---

--- old/drivers/usb/core/hub.c	2007-04-26 12:02:47.000000000 -0400
+++ linux/drivers/usb/core/hub.c	2007-05-01 18:48:46.000000000 -0400
@@ -403,9 +403,10 @@
 	struct usb_hub		*hub =
 		container_of(work, struct usb_hub, tt.kevent);
 	unsigned long		flags;
+	int			limit = 100;
 
 	spin_lock_irqsave (&hub->tt.lock, flags);
-	while (!list_empty (&hub->tt.clear_list)) {
+	while (--limit && !list_empty (&hub->tt.clear_list)) {
 		struct list_head	*temp;
 		struct usb_tt_clear	*clear;
 		struct usb_device	*hdev = hub->hdev;
