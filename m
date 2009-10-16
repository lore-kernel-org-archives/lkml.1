Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZJPRS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZJPRS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZJPRSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:25 -0400
Received: from kroah.org ([198.145.64.141]:48492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbZJPRSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:23 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:54 2009
Message-Id: <20091016171154.161866512@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [15/46] USB: ipaq: fix oops when device is plugged in
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-ipaq-fix-oops-when-device-is-plugged-in.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 06bad89da686f6323e95cf925105e8cf88d87caf upstream.

This patch (as1293) fixes a problem with the ipaq serial driver.  It
tries to bind to all the interfaces, even those that don't have enough
endpoints.  The symptom is an invalid memory reference and oops when
the device is plugged in.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Matthias Geissert <geissert@mathematik.tu-darmstadt.de>
Tested-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ipaq.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -971,6 +971,15 @@ static int ipaq_calc_num_ports(struct us
 static int ipaq_startup(struct usb_serial *serial)
 {
 	dbg("%s", __func__);
+
+	/* Some of the devices in ipaq_id_table[] are composite, and we
+	 * shouldn't bind to all the interfaces.  This test will rule out
+	 * some obviously invalid possibilities.
+	 */
+	if (serial->num_bulk_in < serial->num_ports ||
+			serial->num_bulk_out < serial->num_ports)
+		return -ENODEV;
+
 	if (serial->dev->actconfig->desc.bConfigurationValue != 1) {
 		/*
 		 * FIXME: HP iPaq rx3715, possibly others, have 1 config that


