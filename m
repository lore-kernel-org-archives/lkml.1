Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXCLWUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXCLWUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932774AbXCLWUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:20:17 -0400
Received: from rtr.ca ([64.26.128.89]:2808 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbXCLWUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:20:15 -0400
Message-ID: <45F5D21C.7050108@rtr.ca>
Date: Mon, 12 Mar 2007 18:20:12 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Jim Radford <radford@blackbean.org>, linux-usb-devel@lists.sourceforge.net,
       Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial regression (Oops)  in 2.6.21-rc*
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45F57F63.7010308@rtr.ca> <45F584D9.4090802@rtr.ca> <200703121948.21453.oneukum@suse.de> <45F5B67E.7000105@rtr.ca> <20070312203331.GA6769@kroah.com>
In-Reply-To: <20070312203331.GA6769@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>>>> Mark Lord wrote:
>> This patch fixes the Oops that otherwise occurs whenever
>> a USB serial adapter is unplugged from a system, as well
>> the Oops seen when one is in use before resume (to RAM).
>>
>> GregKH:  This needs to go into 2.6.21-rc*.
>>
>> Signed-off-by:  Mark Lord <mlord@pobox.com>
>> ---
>> --- 2.6.21-rc3/drivers/usb/serial/usb-serial.c	2007-03-12 
>> 11:22:43.000000000 -0400
>> +++ linux/drivers/usb/serial/usb-serial.c	2007-03-12 
>> 16:12:53.000000000 -0400
>> @@ -141,6 +141,9 @@
>> 	for (i = 0; i < serial->num_ports; ++i)
>> 		serial->port[i]->open_count = 0;
>>
>> +	if (serial->type->shutdown)
>> +		serial->type->shutdown(serial);
>> +
>> 	/* the ports are cleaned up and released in port_release() */
>> 	for (i = 0; i < serial->num_ports; ++i)
>> 		if (serial->port[i]->dev.parent != NULL) {
>> @@ -148,9 +151,6 @@
>> 			serial->port[i] = NULL;
>> 		}
>>
>> -	if (serial->type->shutdown)
>> -		serial->type->shutdown(serial);
>> -
>
> Argh, no, this change was done to help the ftdi drivers out.
> 
> Look at changeset d9a7ecacac5f8274d2afce09aadcf37bdb42b93a in Linus's
> tree from Jim Radford:
> 	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9a7ecacac5f8274d2afce09aadcf37bdb42b93a
> 
> It makes this change because the usb-serial drivers need the port
> devices when the port_remove() callbacks happen.  Otherwise you get an
> oops that way.

Oh, good. Now we know the exact changeset that caused the regression, thanks.
That patch should either get reverted, or an alternative fix be posted.

Such as.. this one, from earlier, except perhaps minus the WARN_ON()s:

Signed-off-by:  Mark Lord <mlord@pobox.com>
---
--- linux/include/linux/usb/serial.h.orig	2007-03-12 12:18:48.000000000 -0400
+++ linux/include/linux/usb/serial.h	2007-03-12 12:18:23.000000000 -0400
@@ -99,11 +99,19 @@
 /* get and set the port private data pointer helper functions */
 static inline void *usb_get_serial_port_data (struct usb_serial_port *port)
 {
+	if (!port) {
+		/* WARN_ON(1);*/
+		return NULL;
+	}
 	return dev_get_drvdata(&port->dev);
 }
 
 static inline void usb_set_serial_port_data (struct usb_serial_port *port, void *data)
 {
+	if (!port) {
+		/* WARN_ON(1); */
+		return;
+	}
 	dev_set_drvdata(&port->dev, data);
 }
 

