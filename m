Return-Path: <linux-kernel-owner+w=401wt.eu-S1161473AbXB0AHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161473AbXB0AHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161461AbXB0AHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:07:51 -0500
Received: from mail.kroah.org ([69.55.234.183]:44860 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161460AbXB0AHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:07:32 -0500
Date: Mon, 26 Feb 2007 16:06:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Brownell <david-b@pacbell.net>
Subject: [patch 7/9] USB: usbnet driver bugfix
Message-ID: <20070227000639.GH6283@kroah.com>
References: <20070226235248.438556696@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-usbnet-driver-bugfix.patch"
In-Reply-To: <20070227000538.GA6283@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Brownell <david-b@pacbell.net>

The attached fixes an oops in the usbnet driver. The same patch is
in 2.6.21-rc1, but that one has many whitespace changes. This is much
smaller.


Signed-off-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/net/usbnet.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-2.6.19.5.orig/drivers/usb/net/usbnet.c
+++ linux-2.6.19.5/drivers/usb/net/usbnet.c
@@ -1181,6 +1181,9 @@ usbnet_probe (struct usb_interface *udev
 	// NOTE net->name still not usable ...
 	if (info->bind) {
 		status = info->bind (dev, udev);
+		if (status < 0)
+			goto out1;
+
 		// heuristic:  "usb%d" for links we know are two-host,
 		// else "eth%d" when there's reasonable doubt.  userspace
 		// can rename the link if it knows better.
@@ -1207,12 +1210,12 @@ usbnet_probe (struct usb_interface *udev
 	if (status == 0 && dev->status)
 		status = init_status (dev, udev);
 	if (status < 0)
-		goto out1;
+		goto out3;
 
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
-	
+
 	SET_NETDEV_DEV(net, &udev->dev);
 	status = register_netdev (net);
 	if (status)

--
