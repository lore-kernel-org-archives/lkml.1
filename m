Return-Path: <linux-kernel-owner+w=401wt.eu-S1030766AbXCMQf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030766AbXCMQf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030791AbXCMQf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:35:57 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:3332 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030766AbXCMQf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:35:56 -0400
Message-ID: <45F6D2EA.403@rtr.ca>
Date: Tue, 13 Mar 2007 12:35:54 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jim Radford <radford@blackbean.org>
Cc: Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial regression fix
References: <200703121948.21453.oneukum@suse.de> <45F5B67E.7000105@rtr.ca> <20070312203331.GA6769@kroah.com> <20070312224235.GB3709@blackbean.org> <20070312225922.GA4064@blackbean.org> <20070313001819.GA6147@kroah.com> <20070313004142.GA4835@blackbean.org> <45F60482.6010501@rtr.ca> <20070313091408.GA7205@blackbean.org> <45F6AD5D.4020700@rtr.ca> <20070313153050.GA14687@blackbean.org>
In-Reply-To: <20070313153050.GA14687@blackbean.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Radford wrote:
> ...
> This patch reverts d9a7ecacac5f8274d2afce09aadcf37bdb42b93a since it
> breaks drivers that need to access the ->port[] array in shutdown
> (most of them).

Patch applied, tested, works for me.
 
Signed-Off: Jim Radford <radford@blackbean.org>
Acked-by: Mark Lord <mlord@pobox.com>

--- b/drivers/usb/serial/usb-serial.c
+++ a/drivers/usb/serial/usb-serial.c
@@ -137,6 +135,11 @@
 
 	dbg("%s - %s", __FUNCTION__, serial->type->description);
 
+	serial->type->shutdown(serial);
+
+	/* return the minor range that this device had */
+	return_serial(serial);
+
 	for (i = 0; i < serial->num_ports; ++i)
 		serial->port[i]->open_count = 0;
 
@@ -147,12 +150,6 @@
 			serial->port[i] = NULL;
 		}
 
-	if (serial->type->shutdown)
-		serial->type->shutdown(serial);
-
-	/* return the minor range that this device had */
-	return_serial(serial);
-
 	/* If this is a "fake" port, we have to clean it up here, as it will
 	 * not get cleaned up in port_release() as it was never registered with
 	 * the driver core */


