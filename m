Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbXGWBwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbXGWBwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbXGWBwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:52:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41573 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752746AbXGWBwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:52:03 -0400
Date: Mon, 23 Jul 2007 03:51:28 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Oliver Neukum <oneukum@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: usb_serial_suspend(): buggy(?) code
Message-ID: <20070723015128.GY26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ec22559e0b7a05283a3413bda5d177e42c950e23 added the following 
function to drivers/usb/serial/usb-serial.c:

<--  snip  -->

...
int usb_serial_suspend(struct usb_interface *intf, pm_message_t message)
{
        struct usb_serial *serial = usb_get_intfdata(intf);
        struct usb_serial_port *port;
        int i, r = 0;

        if (serial) {
                for (i = 0; i < serial->num_ports; ++i) {
                        port = serial->port[i];
                        if (port)
                                kill_traffic(port);
                }
        }

        if (serial->type->suspend)
                serial->type->suspend(serial, message);

        return r;
}
...

<--  snip  -->

The Coverity checker spotted the inconsequent NULL checking for "serial".

Looking at the code it also doesn't seem to have been intended to always 
return 0.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

