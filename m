Return-Path: <linux-kernel-owner+w=401wt.eu-S1946056AbXEAX2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946056AbXEAX2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946057AbXEAX2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:28:41 -0400
Received: from rtr.ca ([64.26.128.89]:1586 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946056AbXEAX2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:28:40 -0400
Message-ID: <4637CD25.5070104@rtr.ca>
Date: Tue, 01 May 2007 19:28:37 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>
Subject: [BUG] usb/core/hub.c loops forever on resume from ram due to bluetooth
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have just replaced my primary single-core notebook
with a nearly identical dual-core notebook,
and moved the usb-bluetooth peripheral from the old
machine to the new one.

On the single-core machine, suspend/resume (RAM) worked
fine even with the bluetooth module enabled.

On the new dual-core machine, resuming with bluetooth
enabled results in an infinite(?) lockup in an unbounded
loop in hub_tt_kevent().  With PM debug on, I see
tens of thousands of these messages scrolling on the console:

     kernel: usb 5-1: clear tt 4 (9042) error -71
     kernel: usb 5-1: clear tt 4 (9042) error -71
     kernel: usb 5-1: clear tt 4 (9042) error -71
     (over and over and ...)

By restricting iterations on the unbounded loop
the machine is able to resume again.

Greg / Marcel: any words of wisdom?

And we should probably put bounds permanently on that loop:

I devised/used this patch to accomplish it.
Now, I still get close to a thousand or so such
messages, in groups, showing up in syslog,
but at least the system can resume after suspend.

Signed-off-by:  Mark Lord <mlord@pobox.com>

--- linux/drivers/usb/core/hub.c.orig	2007-04-26 12:02:47.000000000 -0400
+++ linux/drivers/usb/core/hub.c	2007-05-01 18:48:46.000000000 -0400
@@ -403,9 +403,10 @@
 	struct usb_hub		*hub =
 		container_of(work, struct usb_hub, tt.kevent);
 	unsigned long		flags;
+	int			limit = 500;
 
 	spin_lock_irqsave (&hub->tt.lock, flags);
-	while (!list_empty (&hub->tt.clear_list)) {
+	while (--limit && !list_empty (&hub->tt.clear_list)) {
 		struct list_head	*temp;
 		struct usb_tt_clear	*clear;
 		struct usb_device	*hdev = hub->hdev;
-----

