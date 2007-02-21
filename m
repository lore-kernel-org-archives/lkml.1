Return-Path: <linux-kernel-owner+w=401wt.eu-S1422682AbXBUQxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422682AbXBUQxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422683AbXBUQxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:53:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422682AbXBUQx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:53:29 -0500
Message-ID: <45DC7859.7060300@redhat.com>
Date: Wed, 21 Feb 2007 11:50:33 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com>
In-Reply-To: <20070221013619.GA30227@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------050402010604010301070306"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050402010604010301070306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.19.5 release.
> 
> This will probably be the last release of the 2.6.19-stable series, so
> if there are patches that you feel should be applied to that tree,
> please let me know.
> 

The attached fixes an oops in the usbnet driver. The same patch is
in 2.6.21-rc1, but that one has many whitespace changes. This is much
smaller.


From: David Brownell <david-b@pacbell.net>
Signed-off-by: David Brownell <david-b@pacbell.net>


--------------050402010604010301070306
Content-Type: text/plain;
 name="linux-2.6-usbnet_fix_failure_path_oops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6-usbnet_fix_failure_path_oops.patch"

Index: linux-2.6.20.noarch/drivers/usb/net/usbnet.c
===================================================================
--- linux-2.6.20.noarch.orig/drivers/usb/net/usbnet.c	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.20.noarch/drivers/usb/net/usbnet.c	2007-02-18 18:57:05.000000000 -0500
@@ -1182,6 +1182,9 @@
 	// NOTE net->name still not usable ...
 	if (info->bind) {
 		status = info->bind (dev, udev);
+		if (status < 0)
+			goto out1;
+
 		// heuristic:  "usb%d" for links we know are two-host,
 		// else "eth%d" when there's reasonable doubt.  userspace
 		// can rename the link if it knows better.
@@ -1208,12 +1211,12 @@
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

--------------050402010604010301070306--
