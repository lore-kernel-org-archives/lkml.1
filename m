Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbXCLUWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbXCLUWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXCLUWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:22:25 -0400
Received: from rtr.ca ([64.26.128.89]:3178 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbXCLUWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:22:24 -0400
Message-ID: <45F5B67E.7000105@rtr.ca>
Date: Mon, 12 Mar 2007 16:22:22 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>, Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb-serial regression (Oops)  in 2.6.21-rc*
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45F57F63.7010308@rtr.ca> <45F584D9.4090802@rtr.ca> <200703121948.21453.oneukum@suse.de>
In-Reply-To: <200703121948.21453.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
>> Mark Lord wrote:
>>> Okay, from that part (above), the problem is obvious:
>>> in that the "MCT U232 converter now disconnected" appears,
>>> and then we continue to try and call the driver's method.. Oops!
..
> IMHO shutdown() is using serial->port[] and bombs.
> Could you reverse the order here?

Yup.  Fixed.  Tested.  Works.

This patch fixes the Oops that otherwise occurs whenever
a USB serial adapter is unplugged from a system, as well
the Oops seen when one is in use before resume (to RAM).

GregKH:  This needs to go into 2.6.21-rc*.

Signed-off-by:  Mark Lord <mlord@pobox.com>
---
--- 2.6.21-rc3/drivers/usb/serial/usb-serial.c	2007-03-12 11:22:43.000000000 -0400
+++ linux/drivers/usb/serial/usb-serial.c	2007-03-12 16:12:53.000000000 -0400
@@ -141,6 +141,9 @@
 	for (i = 0; i < serial->num_ports; ++i)
 		serial->port[i]->open_count = 0;
 
+	if (serial->type->shutdown)
+		serial->type->shutdown(serial);
+
 	/* the ports are cleaned up and released in port_release() */
 	for (i = 0; i < serial->num_ports; ++i)
 		if (serial->port[i]->dev.parent != NULL) {
@@ -148,9 +151,6 @@
 			serial->port[i] = NULL;
 		}
 
-	if (serial->type->shutdown)
-		serial->type->shutdown(serial);
-
 	/* return the minor range that this device had */
 	return_serial(serial);
 
