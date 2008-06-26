Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbYFZOxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbYFZOxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYFZOxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:53:06 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26597 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753886AbYFZOxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:53:04 -0400
Message-ID: <4863AD33.3070005@panasas.com>
Date: Thu, 26 Jun 2008 17:52:35 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: keyspan_pda.c use of keyspan_pda_get_modem_info
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2008 14:52:37.0498 (UTC) FILETIME=[465625A0:01C8D79C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with gcc 4.3.0 i see these warnings:

drivers/usb/serial/keyspan_pda.c: In function 'keyspan_pda_tiocmget':
drivers/usb/serial/keyspan_pda.c:444: warning: 'status' may be used uninitialized in this function
drivers/usb/serial/keyspan_pda.c: In function 'keyspan_pda_tiocmset':
drivers/usb/serial/keyspan_pda.c:465: warning: 'status' may be used uninitialized in this function

In these two call sites the callers bail out if
keyspan_pda_get_modem_info return value is < 0
e.g.
static int keyspan_pda_tiocmget(struct usb_serial_port *port, struct file *file)
{
...
	unsigned char status;
...
	rc = keyspan_pda_get_modem_info(serial, &status);
	if (rc < 0)
		return rc;
	value =
		((status & (1<<7)) ? TIOCM_DTR : 0) |
...
	return value;

However, keyspan_pda_get_modem_info sets status only for rc > 0
so it may indeed be used uninitialized in case keyspan_pda_get_modem_info
returns 0.

static int keyspan_pda_get_modem_info(struct usb_serial *serial,
				      unsigned char *value)
{
	int rc;
	unsigned char data;
	rc = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
			     3, /* get pins */
			     USB_TYPE_VENDOR|USB_RECIP_INTERFACE|USB_DIR_IN,
			     0, 0, &data, 1, 2000);
	if (rc > 0)
		*value = data;
	return rc;
}

In the usb_control_msg/usb_internal_control_msg/usb_start_wait_urb path,
if usb_submit_urb

That said, I'm not sure if that can happen at all but regardless,
it seems like a good idea to handle this case.

Benny
