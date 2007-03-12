Return-Path: <linux-kernel-owner+w=401wt.eu-S1030584AbXCLQ1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030584AbXCLQ1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030587AbXCLQ1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:27:13 -0400
Received: from rtr.ca ([64.26.128.89]:1695 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030584AbXCLQ1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:27:12 -0400
Message-ID: <45F57F63.7010308@rtr.ca>
Date: Mon, 12 Mar 2007 12:27:15 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca> <200703121606.06601.oneukum@suse.de> <45F56E37.9050506@rtr.ca> <20070312152920.GA29597@kroah.com> <45F579CF.7040802@rtr.ca> <45F57BB8.5010705@rtr.ca> <45F57C52.1010105@rtr.ca>
In-Reply-To: <45F57C52.1010105@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> ..and here is a retest with linux-2.6.21-rc3-git7
> of simply plug/wait/unplug a USB hub/serial/parallel/PS2 gizmo.
> 
> I have two of these, with different serial port hardware in each,
> and doing this with either of them produces an ooops.
> 
...
> 12:12:06 kernel: mct_u232 ttyUSB2: MCT U232 converter now disconnected 
> from ttyUSB2
> 12:12:06 kernel: BUG: unable to handle kernel NULL pointer dereference 
> at virtual address 00000168
> 12:12:06 kernel:  printing eip:
> 12:12:06 kernel: f8ca6542
> 12:12:06 kernel: *pde = 00000000
> 12:12:06 kernel: Oops: 0000 [#2]

Okay, from that part (above), the problem is obvious:
in that the "MCT U232 converter now disconnected" appears,
and then we continue to try and call the driver's method.. Oops!

The hack patch below "fixes" this, but it really just hides whatever
the real problem underneath was:

Signed-off-by:  Mark Lord <mlord@pobox.com>
---
--- linux/include/linux/usb/serial.h.orig	2007-03-12 12:18:48.000000000 -0400
+++ linux/include/linux/usb/serial.h	2007-03-12 12:18:23.000000000 -0400
@@ -99,11 +99,19 @@
 /* get and set the port private data pointer helper functions */
 static inline void *usb_get_serial_port_data (struct usb_serial_port *port)
 {
+	if (!port) {
+		WARN_ON(1);
+		return NULL;
+	}
 	return dev_get_drvdata(&port->dev);
 }
 
 static inline void usb_set_serial_port_data (struct usb_serial_port *port, void *data)
 {
+	if (!port) {
+		WARN_ON(1);
+		return;
+	}
 	dev_set_drvdata(&port->dev, data);
 }
 
